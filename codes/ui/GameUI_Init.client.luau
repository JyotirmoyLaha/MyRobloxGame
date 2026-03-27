--[[
    GameUI_Init.client.luau
    ========================
    MAIN UI ENTRY POINT (runs inside StarterGui)
    
    📍 Location: StarterGui.GameUI
    📝 Type: LocalScript (Client)
    
    🎯 PURPOSE:
    Initializes all UI screens and the HUD. It lives in StarterGui
    and creates/manages ScreenGuis.
    
    📋 UI MODULES INITIALIZED:
      - HUD              — Main heads-up display (money, gems, rebirth level)
      - ShopUI           — Egg shop popup
      - SellUI           — Sell stand popup
      - PotionsUI        — Potions shop popup
      - UpgradesUI       — Upgrade center popup
      - GemsUI           — Gem exchange popup
      - RobuxUI          — Premium/Robux shop popup
      - LeaderboardUI    — Leaderboard popup
      - InventoryUI      — Pet inventory overlay
      - HotbarUI         — Quick-access hotbar
    
    Each UI module creates its own ScreenGui and manages its visibility.
    This entry script just requires them all so they initialize.
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("[GameUI] Initializing all UI modules...")

-- Initialize HUD first (always visible)
local HUD = require(script.HUD)
HUD.Init(playerGui)

-- Initialize stand UIs (shown when player interacts with a stand)
local ShopUI = require(script.ShopUI)
ShopUI.Init(playerGui)

local SellUI = require(script.SellUI)
SellUI.Init(playerGui)

local PotionsUI = require(script.PotionsUI)
PotionsUI.Init(playerGui)

local UpgradesUI = require(script.UpgradesUI)
UpgradesUI.Init(playerGui)

local GemsUI = require(script.GemsUI)
GemsUI.Init(playerGui)

local RobuxUI = require(script.RobuxUI)
RobuxUI.Init(playerGui)

local LeaderboardUI = require(script.LeaderboardUI)
LeaderboardUI.Init(playerGui)

local InventoryUI = require(script.InventoryUI)
InventoryUI.Init(playerGui)

local HotbarUI = require(script.HotbarUI)
HotbarUI.Init(playerGui)

print("[GameUI] All UI modules initialized!")
