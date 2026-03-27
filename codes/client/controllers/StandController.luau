--[[
    StandController.luau
    =====================
    CLIENT-SIDE STAND PROXIMITY DETECTION & UI TRIGGERS
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Controllers
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Detects when the player is near game stands and opens UI popups:
      - ProximityPrompt-based interaction (Press E to open Shop)
      - Opens the correct UI popup when player interacts
      - Closes UI when player walks away
    
    🏗️ STAND SETUP:
    Each stand in the workspace should have:
      - A Part named "StandTrigger" with a ProximityPrompt
      - Or be detected by this controller's distance loop
    
    📦 DEPENDS ON: StandConfig, UI modules
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StandController = {}

function StandController.Init(player)
    -- TODO: Find all stand models in workspace
    -- TODO: For each stand, attach ProximityPrompt
    -- TODO: On Triggered, open the corresponding UI popup
    -- TODO: On TriggeredEnded or walk away, close UI

    -- Example proximity prompt setup (to be connected to actual workspace parts):
    --[[
    local standPart = workspace:FindFirstChild("Stands"):FindFirstChild("Shop"):FindFirstChild("StandTrigger")
    if standPart then
        local prompt = Instance.new("ProximityPrompt")
        prompt.ActionText = "Open Shop"
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 10
        prompt.Parent = standPart
        
        prompt.Triggered:Connect(function(triggerPlayer)
            if triggerPlayer == player then
                -- Open ShopUI
            end
        end)
    end
    ]]

    print("[StandController] Initialized (connect to workspace stand models)")
end

return StandController
