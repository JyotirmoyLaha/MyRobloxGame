--[[
    UpgradeHandler.luau
    ====================
    SERVER-SIDE UPGRADE PURCHASING LOGIC
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles upgrade purchases:
      - Receiving upgrade purchase requests from client (RE_BuyUpgrade)
      - Validating player can afford and hasn't maxed the upgrade
      - Deducting money
      - Incrementing the upgrade level in player data
    
    📋 AVAILABLE UPGRADES (defined in UpgradeConfig):
      - LuckLevel            — Better odds on egg hatches
      - MutationChanceLevel  — Higher chance of mutations
      - MoneyMultiplierLevel — More income from plots
      - AutoCollect          — Auto-collect money (1-level purchase)
    
    📦 DEPENDS ON: DataManager, UpgradeModule, UpgradeConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpgradeHandler = {}

function UpgradeHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local UpgradeModule = require(Shared.Modules.UpgradeModule)
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local buyUpgradeRemote = remotesFolder:WaitForChild("RE_BuyUpgrade")

    buyUpgradeRemote.OnServerEvent:Connect(function(player, upgradeName)
        local data = DataManager.GetData(player)
        if not data then return end

        -- Get current level (data field name matches upgrade name)
        local currentLevel = data[upgradeName] or 0

        -- Validate
        local canBuy, reason = UpgradeModule.CanAfford(upgradeName, currentLevel, data.Money)
        if not canBuy then
            warn("[UpgradeHandler] " .. player.Name .. " can't buy " .. upgradeName .. ": " .. reason)
            return
        end

        -- Deduct cost
        local cost = UpgradeModule.GetUpgradeCost(upgradeName, currentLevel)
        data.Money -= cost

        -- Increment level
        data[upgradeName] = currentLevel + 1

        DataManager.SyncToClient(player)
        print("[UpgradeHandler] " .. player.Name .. " upgraded " .. upgradeName .. " to level " .. data[upgradeName])
    end)

    print("[UpgradeHandler] Initialized")
end

return UpgradeHandler
