--[[
    BlockMoneyDisplay.server.luau
    ==============================
    SURFACE GUI MONEY DISPLAY FOR BLOCKS
    
    📍 Location: ServerScriptService.BlockMoneyDisplay
    📝 Type: Script (Server)
    
    🎯 PURPOSE:
    Creates SurfaceGui displays on top of MoneyBlocks to show how
    much money has accumulated. Works with MoneySystem.server.luau.
    
    📋 HOW IT WORKS:
      1. For each block in MoneyBlocks folder → create SurfaceGui on top face
      2. Display updates every 0.5 seconds reading from _G.BlockMoneyGenerated
      3. Shows "$0" during cooldown periods
      4. Listens for ResetBlockMoney event to reset display
      5. Listens for BlockCooldown event to track cooldown state
    
    🎨 DISPLAY STYLE:
      - Yellow/gold text (#FFEF41) on transparent background
      - GothamBold font, text scaled to fit
      - Positioned on the top face of each block
    
    📦 WORKSPACE SETUP:
      Place money blocks inside: Workspace > [Building Name] > MoneyBlocks
    
    📦 DEPENDS ON: MoneySystem (must run first to initialize _G globals)
]]

-- ⚠️ CHANGE THIS PATH to match your workspace hierarchy
local moneyBlocksFolder = workspace:WaitForChild("Building 1"):WaitForChild("MoneyBlocks")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local resetMoneyEvent = ReplicatedStorage:WaitForChild("ResetBlockMoney")
local blockCooldownEvent = ReplicatedStorage:WaitForChild("BlockCooldown")

-- Initialize globals
if not _G.BlockMoneyGenerated then
    _G.BlockMoneyGenerated = {}
end
if not _G.BlockInCooldown then
    _G.BlockInCooldown = {}
end

for _, moneyBlock in pairs(moneyBlocksFolder:GetChildren()) do
    _G.BlockMoneyGenerated[moneyBlock] = 0
    _G.BlockInCooldown[moneyBlock] = false

    -- CREATE SURFACE GUI
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Parent = moneyBlock
    surfaceGui.Face = Enum.NormalId.Top
    surfaceGui.CanvasSize = Vector2.new(200, 100)

    -- CREATE TEXT
    local moneyText = Instance.new("TextLabel")
    moneyText.Name = "MoneyText"
    moneyText.Size = UDim2.new(0.6, 0, 0.6, 0)
    moneyText.Position = UDim2.new(0.2, 0, 0.2, 0)
    moneyText.BackgroundTransparency = 1
    moneyText.TextColor3 = Color3.fromRGB(255, 239, 65)
    moneyText.TextSize = 10
    moneyText.Font = Enum.Font.GothamBold
    moneyText.Text = "$0"
    moneyText.TextScaled = true
    moneyText.Parent = surfaceGui

    -- UPDATE DISPLAY (reads from _G, doesn't generate money)
    task.spawn(function()
        while true do
            task.wait(0.5)
            if not _G.BlockInCooldown[moneyBlock] then
                moneyText.Text = "$" .. _G.BlockMoneyGenerated[moneyBlock]
            else
                moneyText.Text = "$0"
            end
        end
    end)

    -- LISTEN FOR RESET SIGNAL
    resetMoneyEvent.OnServerEvent:Connect(function(_, blockToReset)
        if blockToReset == moneyBlock then
            _G.BlockMoneyGenerated[moneyBlock] = 0
            moneyText.Text = "$0"
        end
    end)

    -- LISTEN FOR COOLDOWN SIGNAL
    blockCooldownEvent.OnServerEvent:Connect(function(_, blockCooldown, isCooldown)
        if blockCooldown == moneyBlock then
            _G.BlockInCooldown[moneyBlock] = isCooldown
            if isCooldown then
                moneyText.Text = "$0"
            end
        end
    end)
end

print("BlockMoneyDisplay loaded!")
