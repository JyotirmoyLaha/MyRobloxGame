--[[
    ConveyorScript.luau
    ====================
    CONVEYOR BELT PHYSICS SCRIPT
    
    📍 Location: ServerScriptService.Server.Scripts (child of Conveyor part)
    📝 Type: Script (Server)
    
    🎯 PURPOSE:
    Makes a Part act as a conveyor belt by setting its velocity
    along its LookVector. Also syncs the beam texture scroll speed
    for a visual conveyor effect.
    
    🔧 HOW TO USE:
    1. Create a Part in Workspace
    2. Add a Beam child to the Part
    3. Place this Script as a child of that Part
    4. Adjust the `speed` variable as needed
    
    ⚙️ CONFIGURATION:
      speed = 140  -- Adjustable conveyor speed (studs/sec)
    
    💡 The script self-destructs after setup (runs once at startup).
]]

local conveyor = script.Parent
local beam = conveyor:FindFirstChild("Beam")
local speed = 140

conveyor.Velocity = script.Parent.CFrame.LookVector * speed
conveyor.FrontSurface = "Studs"
script:Remove()

beam.TextureSpeed = speed / beam.TextureLength
