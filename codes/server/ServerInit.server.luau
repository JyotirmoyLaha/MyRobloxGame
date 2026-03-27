--[[
    ServerInit.server.luau
    =======================
    MAIN SERVER ENTRY POINT
    
    📍 Location: ServerScriptService.Server
    📝 Type: Script (Server)
    
    🎯 PURPOSE:
    This is the first server script that runs when the game starts.
    It initializes ALL server-side systems in the correct order.
    
    ⚙️ INITIALIZATION ORDER (ORDER MATTERS!):
      1) RemoteSetup    — Creates all RemoteEvents/RemoteFunctions
      2) DataManager    — Initialize player data system
      3) PlotHandler    — Setup plot system
      4) EggHandler     — Setup egg hatching system
      5) IncomeHandler  — Start income generation loop
      6) PetHandler     — Setup pet equip/manage system
      7) UpgradeHandler — Setup upgrade purchasing
      8) ShopHandler    — Setup shop stand
      9) SellHandler    — Setup sell stand
      10) PotionHandler — Setup potion system
      11) GemsHandler   — Setup gems system
      12) RebirthHandler— Setup rebirth system
      13) LeaderboardHandler — Setup leaderboard (optional)
    
    ⚠️ DataManager must init BEFORE anything that reads player data.
    
    🔧 HOW TO USE:
    Place this script in ServerScriptService. The module scripts it requires
    should be children of this script in corresponding subfolders:
      Server/
        Remotes/
          RemoteSetup.luau
        Services/
          DataManager.luau
          EggHandler.luau
          ... (all handlers)
        Scripts/
          ConveyorScript.luau
]]

print("[Server] Initializing game systems...")

-- Step 1: Create all RemoteEvents so other scripts can find them
local RemoteSetup = require(script.Remotes.RemoteSetup)
RemoteSetup.Init()
print("[Server] Remotes created")

-- Step 2: Initialize data system
local DataManager = require(script.Services.DataManager)
DataManager.Init()
print("[Server] DataManager ready")

-- Step 3: Initialize all game handlers
local PlotHandler = require(script.Services.PlotHandler)
PlotHandler.Init()

local EggHandler = require(script.Services.EggHandler)
EggHandler.Init()

local IncomeHandler = require(script.Services.IncomeHandler)
IncomeHandler.Init()

local PetHandler = require(script.Services.PetHandler)
PetHandler.Init()

local UpgradeHandler = require(script.Services.UpgradeHandler)
UpgradeHandler.Init()

local ShopHandler = require(script.Services.ShopHandler)
ShopHandler.Init()

local SellHandler = require(script.Services.SellHandler)
SellHandler.Init()

local PotionHandler = require(script.Services.PotionHandler)
PotionHandler.Init()

local GemsHandler = require(script.Services.GemsHandler)
GemsHandler.Init()

local RebirthHandler = require(script.Services.RebirthHandler)
RebirthHandler.Init()

local LeaderboardHandler = require(script.Services.LeaderboardHandler)
LeaderboardHandler.Init()

print("[Server] All systems initialized! Game is ready.")
