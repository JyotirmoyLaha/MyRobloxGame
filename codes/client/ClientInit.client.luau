--[[
    ClientInit.client.luau
    =======================
    MAIN CLIENT ENTRY POINT
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client
    📝 Type: LocalScript (Client)
    
    🎯 PURPOSE:
    The first client script that runs when a player joins.
    Initializes ALL client-side controllers in order:
      1) Wait for Remotes folder to exist (server creates it)
      2) DataController    — Listen for data updates from server
      3) StandController   — Stand proximity detection & UI triggers
      4) EggController     — Egg hatching animations & camera effects
      5) PlotController    — Client-side plot visuals
      6) PetController     — Pet display, equip UI
      7) IncomeController  — Floating money text, income display
      8) RebirthController — Rebirth UI and effects
      9) SoundManager      — Centralized sound system
    
    📋 CLIENT RULES:
      - NEVER trust the client for game logic. All validation is on the server.
      - Client sends REQUESTS via RemoteEvents.
      - Client DISPLAYS data received from server.
      - Client handles ANIMATIONS, SOUNDS, and UI.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

print("[Client] Waiting for game systems...")

-- Wait for shared modules and remotes to be available
local Shared = ReplicatedStorage:WaitForChild("Shared", 30)
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 30)

if not Shared or not Remotes then
    warn("[Client] Failed to find Shared or Remotes — is the server running?")
    return
end

print("[Client] Initializing controllers...")

-- Initialize controllers
local DataController = require(script.Controllers.DataController)
DataController.Init(player, Remotes)

local StandController = require(script.Controllers.StandController)
StandController.Init(player)

local EggController = require(script.Controllers.EggController)
EggController.Init(player, Remotes)

local PlotController = require(script.Controllers.PlotController)
PlotController.Init(player, Remotes)

local PetController = require(script.Controllers.PetController)
PetController.Init(player, Remotes)

local IncomeController = require(script.Controllers.IncomeController)
IncomeController.Init(player)

local RebirthController = require(script.Controllers.RebirthController)
RebirthController.Init(player, Remotes)

-- Initialize effects
local SoundManager = require(script.Effects.SoundManager)
SoundManager.Init()

print("[Client] All controllers initialized! Game is ready for " .. player.Name)
