--[[
    MoneyGUI.client.luau
    =====================
    MONEY DISPLAY GUI WITH ANIMATIONS
    
    📍 Location: StarterPlayer.StarterCharacterScripts
    📝 Type: LocalScript (Client)
    
    🎯 PURPOSE:
    Creates and manages the on-screen money counter GUI:
      - Dollar icon ($) with green color and black stroke
      - Money amount label with animated updates
      - Bounce animation on the $ icon when money changes
      - Elastic animation on the money text when money changes
      - Formats numbers using MoneyFormatter (K, M, B, T)
    
    🎨 DESIGN:
      - Green dollar icon (#00FF64) with black UIStroke
      - White money text with black UIStroke
      - GothamBold font for both elements
      - Positioned at bottom-left of screen
    
    📦 DEPENDS ON: MoneyFormatter, MoneyChanged RemoteEvent
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local MoneyFormatter = require(ReplicatedStorage:WaitForChild("MoneyFormatter"))

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoneyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Dollar Icon
local dollarIcon = Instance.new("TextLabel")
dollarIcon.Name = "DollarIcon"
dollarIcon.Size = UDim2.new(0, 40, 0, 40)
dollarIcon.Position = UDim2.new(0, 20, 1, -80)
dollarIcon.BackgroundTransparency = 1
dollarIcon.TextColor3 = Color3.fromRGB(0, 255, 100)
dollarIcon.TextSize = 40
dollarIcon.Font = Enum.Font.GothamBold
dollarIcon.Text = "$"
dollarIcon.ZIndex = 2
dollarIcon.Parent = screenGui

local dollarStroke = Instance.new("UIStroke")
dollarStroke.Color = Color3.fromRGB(0, 0, 0)
dollarStroke.Thickness = 2
dollarStroke.Parent = dollarIcon

-- Money Label
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(0, 100, 0, 40)
moneyLabel.Position = UDim2.new(0, 65, 1, -80)
moneyLabel.BackgroundTransparency = 1
moneyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
moneyLabel.TextSize = 40
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.Text = "0"
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.ZIndex = 2
moneyLabel.Parent = screenGui

local moneyStroke = Instance.new("UIStroke")
moneyStroke.Color = Color3.fromRGB(0, 0, 0)
moneyStroke.Thickness = 2
moneyStroke.Parent = moneyLabel

-- Listen for money updates from server
local moneyChangedSignal = ReplicatedStorage:WaitForChild("MoneyChanged")

moneyChangedSignal.OnClientEvent:Connect(function(newAmount)
    local formattedMoney = MoneyFormatter:Format(newAmount)
    moneyLabel.Text = formattedMoney

    -- ICON bounce animation
    local iconUp = TweenService:Create(
        dollarIcon,
        TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
        {TextSize = 46}
    )
    local iconDown = TweenService:Create(
        dollarIcon,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {TextSize = 40}
    )
    iconUp:Play()
    iconUp.Completed:Wait()
    iconDown:Play()

    -- TEXT elastic animation
    local textUp = TweenService:Create(
        moneyLabel,
        TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
        {TextSize = 46}
    )
    local textDown = TweenService:Create(
        moneyLabel,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {TextSize = 40}
    )
    textUp:Play()
    textUp.Completed:Wait()
    textDown:Play()
end)
