--[[
    PotionHandler.luau
    ===================
    SERVER-SIDE POTION SYSTEM
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles the complete potion purchase and management system:
      - Receiving potion purchase requests from client (RE_BuyPotion)
      - Validating the player can afford the potion (Money or Gems)
      - Activating the potion with a duration timer
      - Cleaning up expired potions automatically
      - Applying potion multipliers to income/luck/mutation calculations
    
    📋 POTION RULES:
      - Same potion type does NOT stack (buying again refreshes duration)
      - Different potion types DO stack
      - Potions are stored in ActivePotions: { [potionName] = expiryTick }
    
    📦 DEPENDS ON: DataManager, PotionConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PotionHandler = {}

function PotionHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local PotionConfig = require(Shared.Config.PotionConfig)
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local buyPotionRemote = remotesFolder:WaitForChild("RE_BuyPotion")

    buyPotionRemote.OnServerEvent:Connect(function(player, potionName)
        local data = DataManager.GetData(player)
        if not data then return end

        local potionDef = PotionConfig.Potions[potionName]
        if not potionDef then
            warn("[PotionHandler] Invalid potion: " .. tostring(potionName))
            return
        end

        -- Check currency
        local currency = potionDef.Currency or "Money"
        if data[currency] < potionDef.Price then
            warn("[PotionHandler] " .. player.Name .. " can't afford " .. potionName)
            return
        end

        -- Deduct cost
        data[currency] -= potionDef.Price

        -- Activate potion (set expiry time)
        data.ActivePotions[potionName] = tick() + potionDef.Duration

        DataManager.SyncToClient(player)
        print("[PotionHandler] " .. player.Name .. " activated " .. potionName .. " for " .. potionDef.Duration .. "s")
    end)

    -- Cleanup loop: remove expired potions
    task.spawn(function()
        while true do
            task.wait(5) -- Check every 5 seconds
            for _, player in Players:GetPlayers() do
                local data = DataManager.GetData(player)
                if data and data.ActivePotions then
                    local now = tick()
                    for potionName, expiry in data.ActivePotions do
                        if now >= expiry then
                            data.ActivePotions[potionName] = nil
                        end
                    end
                end
            end
        end
    end)

    print("[PotionHandler] Initialized")
end

return PotionHandler
