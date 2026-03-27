--[[
    RebirthHandler.luau
    ====================
    SERVER-SIDE REBIRTH (PRESTIGE) LOGIC
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles the rebirth/prestige system:
      - Checking if player meets the rebirth cost
      - Resetting appropriate data (money, placed pets)
      - Applying permanent rebirth rewards (luck boost, money multiplier)
      - Unlocking new eggs and plots
    
    🔄 REBIRTH EFFECTS:
      - Money → RESET to 0
      - Placed Pets → CLEARED from all plots
      - Upgrades → KEPT (configurable in RebirthConfig)
      - Inventory → KEPT (configurable)
      - Permanent Luck Boost → ADDED
      - Permanent Money Multiplier → ADDED
      - New egg unlocked (handled by EggConfig.RequiredRebirth)
    
    💰 REBIRTH COST: BaseCost × (CostMultiplier ^ currentRebirth)
    
    📦 DEPENDS ON: DataManager, RebirthConfig, PlotModule
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RebirthHandler = {}

function RebirthHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local RebirthConfig = require(Shared.Config.RebirthConfig)
    local PlotModule = require(Shared.Modules.PlotModule)
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local rebirthRemote = remotesFolder:WaitForChild("RE_Rebirth")

    rebirthRemote.OnServerEvent:Connect(function(player)
        local data = DataManager.GetData(player)
        if not data then return end

        -- Check max rebirth
        if data.Rebirths >= RebirthConfig.MaxRebirths then
            warn("[RebirthHandler] " .. player.Name .. " already at max rebirth")
            return
        end

        -- Calculate cost
        local cost = math.floor(RebirthConfig.BaseCost * (RebirthConfig.CostMultiplier ^ data.Rebirths))
        if data.Money < cost then
            warn("[RebirthHandler] " .. player.Name .. " can't afford rebirth (need " .. cost .. ")")
            return
        end

        -- === PERFORM REBIRTH ===
        data.Rebirths += 1

        -- Reset money
        if RebirthConfig.ResetMoney then
            data.Money = 0
        end

        -- Clear placed pets from plots
        if RebirthConfig.ResetPlots then
            data.PlacedPets = {}
        end

        -- Optionally reset upgrades
        if RebirthConfig.ResetUpgrades then
            data.LuckLevel = 0
            data.MutationChanceLevel = 0
            data.MoneyMultiplierLevel = 0
        end

        -- Optionally reset inventory
        if RebirthConfig.ResetInventory then
            data.OwnedPets = {}
            data.EquippedPets = {}
        end

        -- Update unlocked plots
        data.UnlockedPlots.Floor1 = PlotModule.GetUnlockedPlotCount(data.Rebirths, 1)
        if PlotModule.IsFloor2Unlocked(data.Rebirths) then
            data.UnlockedPlots.Floor2 = PlotModule.GetUnlockedPlotCount(data.Rebirths, 2)
        end

        -- Sync to client
        DataManager.SyncToClient(player)

        print("[RebirthHandler] " .. player.Name .. " rebirthed! Now at rebirth " .. data.Rebirths)
    end)

    print("[RebirthHandler] Initialized")
end

return RebirthHandler
