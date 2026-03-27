--[[
    HUD.luau — Main HUD with Inventory Button
    
    📍 Location: StarterGui.GameUI (as child ModuleScript)
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Creates the main heads-up display with:
      - Inventory button (dark purple glassmorphism style)
      - Pulsing glow animation on the button border
      - Hover effects with size and color transitions
      - Click to toggle InventoryUI
    
    🎨 DESIGN: Dark purple glassmorphism with UIStroke glow
    
    📦 DEPENDS ON: InventoryUI
]]

local TweenService = game:GetService("TweenService")

local HUD = {}
local screenGui = nil

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
end

local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255,255,255)
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function addGlassSheen(parent, cr)
    local sh = Instance.new("Frame")
    sh.Name = "GlassSheen"
    sh.Size = UDim2.new(1, 0, 0.45, 0)
    sh.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sh.BackgroundTransparency = 0.88
    sh.BorderSizePixel = 0
    sh.ZIndex = 2
    sh.Parent = parent
    addCorner(sh, cr or 14)
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    g.Rotation = 90
    g.Parent = sh
end

function HUD.Init(playerGui)
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HUD"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local sideFrame = Instance.new("Frame")
    sideFrame.Name = "SideButtons"
    sideFrame.Size = UDim2.new(0, 64, 0, 300)
    sideFrame.Position = UDim2.new(1, -75, 0.5, -150)
    sideFrame.BackgroundTransparency = 1
    sideFrame.BorderSizePixel = 0
    sideFrame.Parent = screenGui

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = sideFrame

    -- Dark purple glassmorphism button
    local invBtn = Instance.new("TextButton")
    invBtn.Name = "InventoryButton"
    invBtn.Size = UDim2.new(0, 56, 0, 56)
    invBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
    invBtn.Text = ""
    invBtn.BorderSizePixel = 0
    invBtn.AutoButtonColor = false
    invBtn.LayoutOrder = 1
    invBtn.Parent = sideFrame
    addCorner(invBtn, 14)
    local invStroke = addStroke(invBtn, Color3.fromRGB(90, 60, 220), 2)
    addGlassSheen(invBtn, 14)

    -- BAG text icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0.6, 0)
    iconLabel.Position = UDim2.new(0, 0, 0, 2)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "BAG"
    iconLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
    iconLabel.TextSize = 14
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.ZIndex = 3
    iconLabel.Parent = invBtn

    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, 0, 0.35, 0)
    subLabel.Position = UDim2.new(0, 0, 0.6, 0)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "Inventory"
    subLabel.TextColor3 = Color3.fromRGB(160, 140, 210)
    subLabel.TextSize = 9
    subLabel.Font = Enum.Font.GothamSemibold
    subLabel.ZIndex = 3
    subLabel.Parent = invBtn

    -- Pulsing glow animation
    task.spawn(function()
        while invBtn and invBtn.Parent do
            TweenService:Create(invStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(140, 100, 255)}):Play()
            task.wait(1.2)
            TweenService:Create(invStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(70, 40, 180)}):Play()
            task.wait(1.2)
        end
    end)

    -- Hover effects
    invBtn.MouseEnter:Connect(function()
        TweenService:Create(invBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 45, 90)}):Play()
        TweenService:Create(invBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 62, 0, 62)}):Play()
    end)
    invBtn.MouseLeave:Connect(function()
        TweenService:Create(invBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 30, 60)}):Play()
        TweenService:Create(invBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 56, 0, 56)}):Play()
    end)

    invBtn.MouseButton1Click:Connect(function()
        local InventoryUI = require(script.Parent.InventoryUI)
        InventoryUI.Toggle()
    end)

    print("[HUD] Initialized with Inventory button")
end

function HUD.UpdateMoney(amount) end
function HUD.UpdateGems(amount) end
function HUD.UpdateRebirths(level) end

return HUD
