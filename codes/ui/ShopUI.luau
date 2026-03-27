--[[
    ShopUI.luau
    ============
    EGG SHOP STAND UI POPUP — Buy and hatch eggs
    
    📍 Location: StarterGui.GameUI (as child ModuleScript)
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Shows when player interacts with the Shop stand. Displays:
      - All eggs in a scrolling grid
      - Each egg card shows: name, image, price, required rebirth, 
        lock/unlock status, base mutation chance, "Hatch!" button
      - Pet pool preview (click egg → see possible pets with rarities)
    
    🔄 HATCH FLOW:
      Player clicks "Hatch!" → ShopUI calls EggController.RequestHatch(eggName)
      → Server processes → Server sends result → EggController plays animation
    
    📝 TODO: Build UI layout with ScrollingFrame + UIGridLayout
    📝 TODO: Create egg card template
    📝 TODO: Connect to DataController for money/rebirth checks
    
    📦 DEPENDS ON: EggController, DataController, EggConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ShopUI = {}

local screenGui = nil

function ShopUI.Init(playerGui)
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ShopUI"
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = false -- Hidden by default, shown by StandController
    screenGui.Parent = playerGui

    -- TODO: Create main frame (centered popup with title "Egg Shop")
    -- TODO: Create close button (X)
    -- TODO: Create ScrollingFrame for egg grid
    -- TODO: For each egg in EggConfig, create an egg card
    -- TODO: Each card has a "Hatch!" button that fires EggController.RequestHatch()

    print("[ShopUI] Initialized")
end

function ShopUI.Show()
    if screenGui then screenGui.Enabled = true end
end

function ShopUI.Hide()
    if screenGui then screenGui.Enabled = false end
end

function ShopUI.Toggle()
    if screenGui then screenGui.Enabled = not screenGui.Enabled end
end

return ShopUI
