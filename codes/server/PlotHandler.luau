--[[
    PlotHandler.luau
    =================
    SERVER-SIDE PLOT MANAGEMENT
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles plot management for pet placement:
      - Creating plot folders for each player in Workspace
      - Processing place/remove pet requests from client
      - Validating plot ownership and availability
      - Tracking which pets are placed on which plots
    
    🏗️ PLOT STRUCTURE IN WORKSPACE:
      Workspace/
        Plots/
          Player_123456/          -- Folder per player (named by UserId)
            Plot_F1_1/            -- Floor 1, Plot 1
              PetModel            -- The pet model placed here
            Plot_F1_2/
            ...
    
    📦 DEPENDS ON: DataManager, PlotModule, PlotConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PlotHandler = {}

function PlotHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local PlotConfig = require(Shared.Config.PlotConfig)
    local PlotModule = require(Shared.Modules.PlotModule)
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local placePetRemote = remotesFolder:WaitForChild("RE_PlacePet")
    local removePetRemote = remotesFolder:WaitForChild("RE_RemovePet")

    -- Create Plots folder in workspace if it doesn't exist
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then
        plotsFolder = Instance.new("Folder")
        plotsFolder.Name = "Plots"
        plotsFolder.Parent = workspace
    end

    -- Create player plot folder on join
    Players.PlayerAdded:Connect(function(player)
        local playerFolder = Instance.new("Folder")
        playerFolder.Name = "Player_" .. player.UserId
        playerFolder.Parent = plotsFolder
        -- TODO: Create physical plot pads here based on PlotConfig
    end)

    -- Clean up on leave
    Players.PlayerRemoving:Connect(function(player)
        local playerFolder = plotsFolder:FindFirstChild("Player_" .. player.UserId)
        if playerFolder then
            playerFolder:Destroy()
        end
    end)

    -- Handle place pet on plot
    placePetRemote.OnServerEvent:Connect(function(player, petUniqueId, plotId)
        local data = DataManager.GetData(player)
        if not data then return end

        -- TODO: Validate plotId is unlocked
        -- TODO: Validate pet exists in inventory
        -- TODO: Check plot isn't already occupied
        -- TODO: Place pet model in workspace

        data.PlacedPets[plotId] = petUniqueId
        DataManager.SyncToClient(player)
    end)

    -- Handle remove pet from plot
    removePetRemote.OnServerEvent:Connect(function(player, plotId)
        local data = DataManager.GetData(player)
        if not data then return end

        data.PlacedPets[plotId] = nil
        -- TODO: Remove pet model from workspace
        DataManager.SyncToClient(player)
    end)

    print("[PlotHandler] Initialized")
end

return PlotHandler
