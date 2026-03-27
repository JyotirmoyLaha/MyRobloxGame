--[[
    FloatingMoneyAnimation.client.luau
    ====================================
    FLOATING "+$X" TEXT ANIMATION (Screen-Space)
    
    📍 Location: StarterGui
    📝 Type: LocalScript (Client)
    
    🎯 PURPOSE:
    Displays a floating green "+$X" text that rises and fades when the
    player collects money from a MoneyBlock.
    
    📋 HOW IT WORKS:
      1. Server fires FloatingMoneyAnimation event with the collected amount
      2. Client creates a TextLabel at the money display position
      3. Text floats upward 100 pixels over 1.2 seconds
      4. Text fades to 50% transparency simultaneously
      5. Label is destroyed after animation completes
    
    🎨 STYLE:
      - Green text (#00FF64) with GothamBold font
      - Black UIStroke for readability
      - Animates with Quad easing
    
    📦 DEPENDS ON: FloatingMoneyAnimation RemoteEvent, MoneyGui ScreenGui
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Wait for the RemoteEvent
local floatingMoneyEvent = ReplicatedStorage:WaitForChild("FloatingMoneyAnimation")

-- Get reference to your MoneyGui
local screenGui = script.Parent:WaitForChild("MoneyGui")

floatingMoneyEvent.OnClientEvent:Connect(function(amount)
    -- Create floating text at money storage location
    local floatingText = Instance.new("TextLabel")
    floatingText.Name = "FloatingMoney"
    floatingText.Size = UDim2.new(0, 120, 0, 40)
    floatingText.Position = UDim2.new(0, 20, 1, -80)  -- START at money storage
    floatingText.BackgroundTransparency = 1
    floatingText.TextColor3 = Color3.fromRGB(0, 255, 100)  -- GREEN
    floatingText.TextSize = 28
    floatingText.Font = Enum.Font.GothamBold
    floatingText.Text = "+$" .. amount  -- Shows exact amount collected
    floatingText.ZIndex = 10
    floatingText.Parent = screenGui

    -- Add BLACK stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 0, 0)  -- BLACK
    stroke.Thickness = 2
    stroke.Parent = floatingText

    -- ANIMATION: Float up and fade out
    local tweenInfo = TweenInfo.new(
        1.2,  -- Duration
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    -- Move up animation
    local moveTween = TweenService:Create(floatingText, tweenInfo, {
        Position = UDim2.new(0, 20, 1, -180)  -- Float up 100 pixels
    })

    -- Fade out animation
    local fadeTween = TweenService:Create(floatingText, tweenInfo, {
        TextTransparency = 0.5  -- Fade out
    })

    -- Play both animations
    moveTween:Play()
    fadeTween:Play()

    -- Clean up
    moveTween.Completed:Connect(function()
        floatingText:Destroy()
    end)
end)
