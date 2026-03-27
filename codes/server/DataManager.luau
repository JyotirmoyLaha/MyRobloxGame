--[[
    DataManager.luau
    =================
    PLAYER DATA SYSTEM — Saves and loads all player progress
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    This is the most critical server system. It handles:
      - Loading player data when they join
      - Saving player data periodically and on leave
      - Providing Get/Set functions for other server scripts
      - Creating default data for new players
    
    💡 RECOMMENDED: Replace this with ProfileService for production.
    This implementation uses basic DataStoreService as a starting point.
    
    📦 DATA STORED:
      Money, Gems, Rebirths, Upgrade Levels, OwnedPets,
      EquippedPets, PlacedPets, ActivePotions, etc.
    
    🔧 HOW OTHER SCRIPTS USE THIS:
      local DataManager = require(Server.Services.DataManager)
      local data = DataManager.GetData(player)
      data.Money += 100
      DataManager.SaveData(player)
    
    ⚠️ IMPORTANT:
      - Always call GetData() — never cache data references long-term
      - DataManager must Init() before any other system accesses data
      - On player leave, data is auto-saved
    
    🔒 NOTE: Change the DataStore key name in production to match your game.
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ⚠️ CHANGE THESE PATHS to match your game's Shared module location
local PlayerDataTemplate = require(ReplicatedStorage:WaitForChild("Shared").Types.PlayerData)
local TableUtil = require(ReplicatedStorage:WaitForChild("Shared").Utils.TableUtil)

local DataManager = {}

-- In-memory cache: { [Player.UserId] = dataTable }
local playerDataCache = {}

-- ⚠️ CHANGE THIS to your own DataStore key name
local dataStore = DataStoreService:GetDataStore("YourGame_DataStore_v1")

-- Auto-save interval (seconds)
local AUTO_SAVE_INTERVAL = 120

-- === INTERNAL FUNCTIONS ===

-- Deep-merge saved data onto default template (handles new fields gracefully).
local function reconcileData(savedData)
    local template = TableUtil.DeepCopy(PlayerDataTemplate.DefaultData)
    if savedData then
        for key, value in savedData do
            template[key] = value
        end
    end
    return template
end

-- === PUBLIC API ===

function DataManager.Init()
    -- Handle player joining
    Players.PlayerAdded:Connect(function(player)
        DataManager.LoadData(player)
    end)

    -- Handle player leaving
    Players.PlayerRemoving:Connect(function(player)
        DataManager.SaveData(player)
        playerDataCache[player.UserId] = nil
    end)

    -- Handle server shutdown (save all)
    game:BindToClose(function()
        for _, player in Players:GetPlayers() do
            DataManager.SaveData(player)
        end
    end)

    -- Auto-save loop
    task.spawn(function()
        while true do
            task.wait(AUTO_SAVE_INTERVAL)
            for _, player in Players:GetPlayers() do
                DataManager.SaveData(player)
            end
        end
    end)

    -- Load data for players already in game (studio edge case)
    for _, player in Players:GetPlayers() do
        DataManager.LoadData(player)
    end

    -- Setup RF_GetPlayerData remote
    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local getDataRemote = remotesFolder:WaitForChild("RF_GetPlayerData")
    getDataRemote.OnServerInvoke = function(player)
        return DataManager.GetData(player)
    end

    print("[DataManager] Initialized")
end

-- Load player data from DataStore (or create default).
function DataManager.LoadData(player: Player)
    local userId = player.UserId
    local success, savedData = pcall(function()
        return dataStore:GetAsync("Player_" .. userId)
    end)

    if success then
        playerDataCache[userId] = reconcileData(savedData)
        print("[DataManager] Loaded data for " .. player.Name)
    else
        playerDataCache[userId] = TableUtil.DeepCopy(PlayerDataTemplate.DefaultData)
        warn("[DataManager] Failed to load data for " .. player.Name .. ", using defaults")
    end

    -- Send initial data to client
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if remotesFolder then
        local updateRemote = remotesFolder:FindFirstChild("RE_DataUpdate")
        if updateRemote then
            updateRemote:FireClient(player, playerDataCache[userId])
        end
    end
end

-- Save player data to DataStore.
function DataManager.SaveData(player: Player)
    local userId = player.UserId
    local data = playerDataCache[userId]
    if not data then return end

    local success, err = pcall(function()
        dataStore:SetAsync("Player_" .. userId, data)
    end)

    if not success then
        warn("[DataManager] Failed to save data for " .. player.Name .. ": " .. tostring(err))
    end
end

-- Get player's data table (returns reference — changes are reflected in cache).
function DataManager.GetData(player: Player)
    return playerDataCache[player.UserId]
end

-- Send updated data to the client (call after modifying data).
function DataManager.SyncToClient(player: Player)
    local data = playerDataCache[player.UserId]
    if not data then return end

    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if remotesFolder then
        local updateRemote = remotesFolder:FindFirstChild("RE_DataUpdate")
        if updateRemote then
            updateRemote:FireClient(player, data)
        end
    end
end

return DataManager
