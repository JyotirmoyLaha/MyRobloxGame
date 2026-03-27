# 🎮 Roblox Game — Open Source Scripts

A collection of **Luau scripts** for building an **idle/clicker Roblox game** with pet hatching, income systems, rebirth mechanics, and more. These scripts are modular and well-documented — perfect for learning or building your own game.

> **⚠️ Important:** These are code templates/references. You'll need to create your own Config modules, Shared modules, and workspace setup to use them in a live game.

---

## 📁 Folder Structure

```
codes/
├── server/           # Server-side scripts (run in ServerScriptService)
├── client/           # Client-side scripts (run in StarterPlayerScripts)
│   ├── controllers/  # Client controllers (data, pets, plots, etc.)
│   └── effects/      # Visual & audio effects
├── ui/               # UI modules (run in StarterGui)
├── standalone/       # Independent feature scripts
└── utils/            # Reusable utility modules
```

---

## 📋 Script Index

### 🖥️ Server Scripts (`server/`)

| Script | Type | Purpose |
|--------|------|---------|
| `ServerInit.server.luau` | Script | Main server entry point — initializes all systems in correct order |
| `RemoteSetup.luau` | ModuleScript | Creates all RemoteEvents/RemoteFunctions with RE_/RF_ naming convention |
| `DataManager.luau` | ModuleScript | Player data save/load system using DataStoreService with auto-save |
| `EggHandler.luau` | ModuleScript | Egg purchase validation, weighted RNG pet rolling, mutation rolling |
| `IncomeHandler.luau` | ModuleScript | Continuous income generation loop for placed pets |
| `PetHandler.luau` | ModuleScript | Pet equip/unequip with slot validation |
| `PlotHandler.luau` | ModuleScript | Plot management — place/remove pets on player plots |
| `PotionHandler.luau` | ModuleScript | Timed potion buffs with auto-expiry cleanup loop |
| `RebirthHandler.luau` | ModuleScript | Prestige/rebirth system with configurable resets and unlocks |
| `SellHandler.luau` | ModuleScript | Pet selling with value calculation and inventory cleanup |
| `ShopHandler.luau` | ModuleScript | Shop data provider with lock/unlock status per player |
| `UpgradeHandler.luau` | ModuleScript | Multi-level upgrade purchase system |
| `GemsHandler.luau` | ModuleScript | Secondary premium currency (Gems) handler |
| `LeaderboardHandler.luau` | ModuleScript | Leaderboard with sorted player rankings |

### 🎮 Client Scripts (`client/`)

| Script | Type | Purpose |
|--------|------|---------|
| `ClientInit.client.luau` | LocalScript | Main client entry point — initializes all controllers |

#### Controllers (`client/controllers/`)

| Script | Type | Purpose |
|--------|------|---------|
| `DataController.luau` | ModuleScript | Receives server data updates, provides read-only API for UI |
| `EggController.luau` | ModuleScript | Egg hatch request + animation trigger (camera, particles, sound) |
| `PetController.luau` | ModuleScript | Pet inventory display, equip/unequip requests |
| `PlotController.luau` | ModuleScript | Plot visualization, place/remove pet requests |
| `IncomeController.luau` | ModuleScript | Floating income text and money counter animations |
| `RebirthController.luau` | ModuleScript | Rebirth confirmation UI and celebration effects |
| `StandController.luau` | ModuleScript | ProximityPrompt-based stand interaction system |

#### Effects (`client/effects/`)

| Script | Type | Purpose |
|--------|------|---------|
| `FloatingText.luau` | ModuleScript | BillboardGui floating "+$X" text with rise-and-fade animation |
| `EggOpenEffect.luau` | ModuleScript | Egg opening animation framework (camera zoom, crack, reveal) |
| `MutationEffect.luau` | ModuleScript | Mutation reveal effects (screen flash, camera shake, particles) |
| `SoundManager.luau` | ModuleScript | Centralized sound system with pre-cached Sound instances |

### 🖼️ UI Modules (`ui/`)

| Script | Type | Purpose |
|--------|------|---------|
| `GameUI_Init.client.luau` | LocalScript | Main UI entry point — initializes all UI screen modules |
| `HUD.luau` | ModuleScript | Glassmorphism HUD with pulsing inventory button and hover effects |
| `ShopUI.luau` | ModuleScript | Egg shop popup framework (Show/Hide/Toggle) |
| `SellUI.luau` | ModuleScript | Sell stand popup framework |

### 🔧 Standalone Scripts (`standalone/`)

| Script | Type | Purpose |
|--------|------|---------|
| `MoneySystem.server.luau` | Script | Complete money block generation + touch collection with cooldowns |
| `BlockMoneyDisplay.server.luau` | Script | SurfaceGui money display on blocks with cooldown sync |
| `MoneyGUI.client.luau` | LocalScript | On-screen money counter with bounce/elastic update animations |
| `FloatingMoneyAnimation.client.luau` | LocalScript | Screen-space "+$X" floating text for money collection |

### 🛠️ Utility Scripts (`utils/`)

| Script | Type | Purpose |
|--------|------|---------|
| `MoneyFormatter.luau` | ModuleScript | Number abbreviation (K, M, B, T) for display |
| `ConveyorScript.server.luau` | Script | One-shot conveyor belt velocity + beam setup |
| `ShiftToRun.client.luau` | LocalScript | Shift-to-run/sprint with FOV changes, animations, mobile support |
| `RunConfig.luau` | ModuleScript | Configuration for shift-to-run speeds, keys, and animations |

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                     SERVER SIDE                         │
│  ServerInit → RemoteSetup → DataManager → All Handlers  │
│                                                         │
│  Handlers: Egg, Income, Pet, Plot, Potion, Rebirth,     │
│            Sell, Shop, Upgrade, Gems, Leaderboard       │
└──────────────────────┬──────────────────────────────────┘
                       │ RemoteEvents / RemoteFunctions
                       │ (RE_ / RF_ naming convention)
┌──────────────────────┴──────────────────────────────────┐
│                     CLIENT SIDE                         │
│  ClientInit → All Controllers → Effects                  │
│                                                         │
│  Controllers: Data, Egg, Pet, Plot, Income, Rebirth,     │
│               Stand                                      │
│  Effects: FloatingText, EggOpen, Mutation, Sound          │
│                                                         │
│  GameUI_Init → HUD, ShopUI, SellUI, etc.                 │
└─────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Design Patterns

1. **Client-Server Architecture** — Client sends requests, server validates and processes
2. **Module Pattern** — Each system is a ModuleScript with `.Init()` method
3. **Data Controller** — Single source of truth for player data on client
4. **Remote Naming** — `RE_` for RemoteEvents, `RF_` for RemoteFunctions
5. **Centralized Sound** — All sounds go through SoundManager
6. **Handler Pattern** — Each game feature has its own server handler

---

## ⚠️ Setup Notes

- Replace placeholder DataStore keys with your own
- Replace `rbxassetid://0` sound IDs with actual Roblox audio assets
- Replace animation IDs in RunConfig with your own
- Create the required Config modules (`GameConfig`, `EggConfig`, `PetConfig`, etc.)
- Create the required Shared modules (`EggModule`, `PetModule`, `IncomeModule`, etc.)
- Adjust workspace paths (e.g., `Building 1 > MoneyBlocks`) to match your game

---

## 🚧 Under Active Development

This game is currently **under active development**! 🛠️ More scripts, systems, and features will be added over time as the game evolves. Stay tuned for updates — there's a lot more to come!

---

## 📜 License

These scripts are provided as open-source references for learning and building Roblox games.
Feel free to use, modify, and adapt them for your own projects.

**ShiftToRun system credit:** Made by @a2x4440
