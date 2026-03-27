--[[
    RebirthController.luau
    =======================
    CLIENT-SIDE REBIRTH UI & EFFECTS
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Controllers
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Handles rebirth UI and celebration effects:
      - Showing rebirth confirmation popup
      - Displaying rebirth cost and rewards
      - Sending rebirth request to server
      - Playing celebration effects (screen flash, camera, sound, particles)
    
    📦 DEPENDS ON: DataController, RebirthConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RebirthController = {}

function RebirthController.Init(player, remotes)
    local rebirthRemote = remotes:WaitForChild("RE_Rebirth")

    -- TODO: Create rebirth confirmation UI
    -- TODO: Show current rebirth level, cost, and rewards
    -- TODO: On confirm, fire rebirthRemote to server
    -- TODO: Play celebration effects after server confirms

    print("[RebirthController] Initialized")
end

-- Request rebirth from server
function RebirthController.RequestRebirth()
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    remotes:WaitForChild("RE_Rebirth"):FireServer()
end

return RebirthController
