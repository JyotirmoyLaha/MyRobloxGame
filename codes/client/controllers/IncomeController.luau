--[[
    IncomeController.luau
    ======================
    CLIENT-SIDE INCOME DISPLAY
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Controllers
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Handles client-side income visual feedback:
      - Showing floating "+$X" text above plots when income ticks
      - Displaying total income per second in the HUD
      - Money counter animation (smooth number rolling)
      - Auto-collect visual effects
    
    📋 FLOATING TEXT BEHAVIOR:
      - Green text for normal income
      - Gold text for mutation-boosted income
      - Text floats up and fades out over ~1 second
    
    📦 DEPENDS ON: DataController, IncomeModule, FloatingText
]]

local IncomeController = {}

function IncomeController.Init(player)
    -- TODO: Listen for DataController.DataChanged
    -- TODO: Calculate income/sec using IncomeModule (for display only)
    -- TODO: Spawn floating text at plot positions each tick
    -- TODO: Animate money counter in HUD

    print("[IncomeController] Initialized")
end

return IncomeController
