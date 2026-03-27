--[[
    PlotController.luau
    ====================
    CLIENT-SIDE PLOT VISUALS
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Controllers
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Handles client-side plot rendering and interaction:
      - Displaying plot pads in the player's plot area
      - Showing placed pet models on plots
      - Visual feedback when placing/removing pets
      - Highlighting available plots (green glow)
      - Showing locked plots (red/gray)
    
    📦 DEPENDS ON: DataController, PlotConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotController = {}

function PlotController.Init(player, remotes)
    local placePetRemote = remotes:WaitForChild("RE_PlacePet")
    local removePetRemote = remotes:WaitForChild("RE_RemovePet")

    -- TODO: Listen for data changes to update plot visuals
    -- TODO: Render plot pads based on unlocked count
    -- TODO: Show placed pet models on occupied plots
    -- TODO: Handle click-to-place and click-to-remove interactions

    print("[PlotController] Initialized")
end

-- Request to place a pet on a plot
function PlotController.PlacePet(petUniqueId: string, plotId: string)
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    remotes:WaitForChild("RE_PlacePet"):FireServer(petUniqueId, plotId)
end

-- Request to remove a pet from a plot
function PlotController.RemovePet(plotId: string)
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    remotes:WaitForChild("RE_RemovePet"):FireServer(plotId)
end

return PlotController
