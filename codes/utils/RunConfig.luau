--[[
    RunConfig.luau
    ===============
    CONFIGURATION MODULE FOR SHIFT-TO-RUN SYSTEM
    
    📍 Location: ReplicatedStorage (or Workspace.ShiftToRun)
    📝 Type: ModuleScript (Shared)
    📦 Credit: Made by @a2x4440
    
    🎯 PURPOSE:
    Configurable settings for the Shift-to-Run sprint system.
    
    ⚙️ SETTINGS:
      - WalkSpeed / RunSpeed / SprintSpeed  — Movement speeds
      - WalkFov / RunFov / SprintFov        — Camera field of view
      - CanRun / CanSprint                  — Feature toggles
      - RunKey                              — Key binding (default: LeftShift)
      - TransitionSpeed                     — Tween duration between states
      - SprintTransitionSpeed               — Time before sprint kicks in
      - RunAnimationId / SprintAnimationId  — Animation asset IDs
    
    ⚠️ Replace animation IDs with your own Roblox animation asset IDs.
]]

local RunConfig = {}

-- \\ SETTINGS \\

RunConfig.WalkSpeed = game.StarterPlayer.CharacterWalkSpeed
RunConfig.RunSpeed = 20 -- Speed while running
RunConfig.SprintSpeed = 25 -- Speed while sprinting

RunConfig.WalkFov = workspace.Camera.FieldOfView
RunConfig.RunFov = 80 -- Camera FieldOfView while running
RunConfig.SprintFov = 85 -- Camera FieldOfView while sprinting

RunConfig.CanRun = true -- If the player is able to run
RunConfig.CanSprint = false -- If the player is able to sprint

RunConfig.RunKey = Enum.KeyCode.LeftShift -- The key to press to run
RunConfig.TransitionSpeed = 0.5 -- Time it takes to go from walking to running
RunConfig.SprintTransitionSpeed = 3 -- Time it takes before you start sprinting

-- ⚠️ Replace these with actual Roblox animation asset IDs
RunConfig.RunAnimationId = "rbxassetid://" -- EXAMPLE: "rbxassetid://1234567890"
RunConfig.SprintAnimationId = "rbxassetid://" -- EXAMPLE: "rbxassetid://1234567890"
RunConfig.ChangeAnimationProirity = true -- Turn this off if your animations are bugging

-- !!WARNING: DO NOT CHANGE THESE — Runtime state variables!!
RunConfig.Walking = false
RunConfig.Running = false
RunConfig.Sprinting = false

return RunConfig
