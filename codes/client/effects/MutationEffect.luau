--[[
    MutationEffect.luau
    =====================
    MUTATION REVEAL VISUAL EFFECTS
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Effects
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    When a pet hatches with a mutation, this plays a special effect:
      - Screen flash (color based on mutation type)
      - Camera shake
      - Special particle burst
      - Mutation-colored aura on the pet
      - Extra sound effect
    
    🎨 MUTATION COLORS:
      - Gold      → Golden flash
      - Rainbow   → Multi-color cycling flash
      - Corrupted → Dark purple glitch effect
      - Celestial → Cyan glow burst
    
    Called by EggOpenEffect during the reveal step.
    
    📝 TODO: Implement screen flash using a ScreenGui Frame
    📝 TODO: Implement camera shake using CFrame offsets
]]

local TweenService = game:GetService("TweenService")

local MutationEffect = {}

-- Play mutation reveal effect.
-- mutationName : "Gold", "Rainbow", "Corrupted", "Celestial"
-- mutationColor: Color3 from MutationConfig
function MutationEffect.Play(mutationName, mutationColor)
    -- TODO: Create full-screen flash Frame in PlayerGui
    -- TODO: Tween from mutationColor at 0.5 opacity → transparent
    -- TODO: Camera shake for 0.3 seconds
    -- TODO: Play MutationFlash sound
    -- TODO: Spawn mutation-colored particles at pet position

    print("[MutationEffect] Playing " .. mutationName .. " effect!")
end

return MutationEffect
