--[[
    RemoteSetup.luau
    =================
    CREATES ALL REMOTEVENTS AND REMOTEFUNCTIONS
    
    📍 Location: ServerScriptService.Server.Remotes
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Runs FIRST on the server. Creates all RemoteEvents and RemoteFunctions
    in ReplicatedStorage so that both server handlers and client controllers
    can find them.
    
    📛 NAMING CONVENTION:
      - RE_ prefix = RemoteEvent     (fire-and-forget, one-way communication)
      - RF_ prefix = RemoteFunction  (request-response, waits for return value)
    
    📋 REMOTE LIST:
      === EGG SYSTEM ===
      RE_BuyEgg         — Client requests to buy/hatch an egg
      RE_EggResult      — Server sends hatch result back to client
      
      === SHOP ===
      RF_GetShopData    — Client requests current shop data
      
      === SELL ===
      RE_SellPet        — Client requests to sell a pet from inventory
      
      === UPGRADES ===
      RE_BuyUpgrade     — Client requests to purchase an upgrade level
      
      === PLOTS ===
      RE_PlacePet       — Client requests to place a pet on a plot
      RE_RemovePet      — Client requests to remove a pet from a plot
      
      === PETS ===
      RE_EquipPet       — Client requests to equip a pet
      RE_UnequipPet     — Client requests to unequip a pet
      
      === REBIRTH ===
      RE_Rebirth        — Client requests to rebirth
      
      === POTIONS ===
      RE_BuyPotion      — Client requests to buy a potion
      
      === GEMS ===
      RE_BuyGemItem     — Client purchases something with gems
      
      === DATA SYNC ===
      RE_DataUpdate     — Server sends updated player data to client
      RF_GetPlayerData  — Client requests full player data snapshot
      
      === LEADERBOARD ===
      RF_GetLeaderboard — Client requests leaderboard data

    🔧 HOW TO ADD A NEW REMOTE:
      1) Add it to the remoteEvents or remoteFunctions table below
      2) Connect it in the appropriate server handler
      3) Fire/invoke it from the appropriate client controller
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteSetup = {}

-- All RemoteEvents to create
local remoteEvents = {
    -- Egg system
    "RE_BuyEgg",
    "RE_EggResult",

    -- Sell
    "RE_SellPet",

    -- Upgrades
    "RE_BuyUpgrade",

    -- Plots
    "RE_PlacePet",
    "RE_RemovePet",

    -- Pets
    "RE_EquipPet",
    "RE_UnequipPet",

    -- Rebirth
    "RE_Rebirth",

    -- Potions
    "RE_BuyPotion",

    -- Gems
    "RE_BuyGemItem",

    -- Data sync (server → client)
    "RE_DataUpdate",
}

-- All RemoteFunctions to create
local remoteFunctions = {
    "RF_GetShopData",
    "RF_GetPlayerData",
    "RF_GetLeaderboard",
}

function RemoteSetup.Init()
    -- Create a folder to hold all remotes (keeps ReplicatedStorage organized)
    local remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "Remotes"
    remotesFolder.Parent = ReplicatedStorage

    -- Create RemoteEvents
    for _, name in remoteEvents do
        local remote = Instance.new("RemoteEvent")
        remote.Name = name
        remote.Parent = remotesFolder
    end

    -- Create RemoteFunctions
    for _, name in remoteFunctions do
        local remote = Instance.new("RemoteFunction")
        remote.Name = name
        remote.Parent = remotesFolder
    end
end

return RemoteSetup
