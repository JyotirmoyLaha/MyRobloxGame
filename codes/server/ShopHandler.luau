--[[
    ShopHandler.luau
    =================
    SERVER-SIDE SHOP STAND LOGIC
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Provides shop data to client UI:
      - Responding to RF_GetShopData requests
      - Building list of all eggs with prices, requirements, and unlock status
      - Pet pool preview data for each egg
    
    📋 SHOP DISPLAYS:
      - All eggs (locked and unlocked)
      - Prices
      - Required rebirth level
      - Pet pool preview (names + rarities)
    
    📦 DEPENDS ON: EggModule, EggConfig, DataManager
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ShopHandler = {}

function ShopHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local EggModule = require(Shared.Modules.EggModule)
    local EggConfig = require(Shared.Config.EggConfig)
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local getShopData = remotesFolder:WaitForChild("RF_GetShopData")

    -- Client requests shop data
    getShopData.OnServerInvoke = function(player)
        local data = DataManager.GetData(player)
        if not data then return {} end

        -- Build shop data with lock/unlock status
        local shopData = {}
        for i, egg in EggConfig do
            table.insert(shopData, {
                Index = i,
                EggName = egg.EggName,
                Price = egg.Price,
                RequiredRebirth = egg.RequiredRebirth,
                BaseMutationChance = egg.BaseMutationChance,
                IsUnlocked = data.Rebirths >= egg.RequiredRebirth,
                CanAfford = data.Money >= egg.Price,
                PetPool = egg.PetPool, -- Send pet pool for preview
            })
        end

        return shopData
    end

    print("[ShopHandler] Initialized")
end

return ShopHandler
