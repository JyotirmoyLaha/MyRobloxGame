--[[
    SellUI.luau
    ============
    SELL STAND UI POPUP — Sell pets for money
    
    📍 Location: StarterGui.GameUI (as child ModuleScript)
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Shows when player interacts with the Sell stand. Displays:
      - Player's inventory in a scrolling grid
      - Each pet card shows: name, rarity color, mutation badge, sell value, "Sell" button
      - "Sell All" button (sells all unequipped, unplaced pets)
      - Filter by rarity (optional)
    
    🔄 SELL FLOW:
      Player clicks "Sell" → fires RE_SellPet to server with pet UniqueId
      → Server validates, removes pet, adds money → data syncs back
    
    📦 DEPENDS ON: DataController, PetModule
]]

local SellUI = {}

local screenGui = nil

function SellUI.Init(playerGui)
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SellUI"
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = false
    screenGui.Parent = playerGui

    -- TODO: Create main frame ("Sell Stand" title)
    -- TODO: Create close button
    -- TODO: Create pet grid (from OwnedPets data)
    -- TODO: Each card shows sell value and "Sell" button
    -- TODO: "Sell All" button at bottom

    print("[SellUI] Initialized")
end

function SellUI.Show()
    if screenGui then screenGui.Enabled = true end
end

function SellUI.Hide()
    if screenGui then screenGui.Enabled = false end
end

return SellUI
