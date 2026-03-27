--[[
    FloatingText.luau
    ==================
    FLOATING MONEY TEXT EFFECT
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Effects
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Creates floating "+$X" text above plots when income is collected.
    Text rises upward and fades out over ~1 second.
    Uses BillboardGui attached to a temporary Part.
    
    🎨 COLORS:
      - Green  (#00FF00) for normal income
      - Gold   (#FFD700) for mutation-boosted income
      - Cyan   (#00FFFF) for potion-boosted income
    
    🔧 HOW TO USE:
      local FloatingText = require(Client.Effects.FloatingText)
      FloatingText.Show(position, "+$150", Color3.fromRGB(0, 255, 0))
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local FloatingText = {}

-- Show floating text at a world position.
-- position : Vector3 world position
-- text     : string to display (e.g. "+$150")
-- color    : Color3 for the text
function FloatingText.Show(position: Vector3, text: string, color: Color3?)
    local displayColor = color or Color3.fromRGB(0, 255, 0) -- Default green

    -- Create a temporary part at the position
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Position = position
    part.Parent = workspace

    -- Create BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    -- Create TextLabel
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = displayColor
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    -- Animate: float up and fade out
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(billboard, tweenInfo, {
        StudsOffset = Vector3.new(0, 5, 0)
    }):Play()

    TweenService:Create(label, tweenInfo, {
        TextTransparency = 1
    }):Play()

    -- Cleanup after animation
    task.delay(1.2, function()
        part:Destroy()
    end)
end

return FloatingText
