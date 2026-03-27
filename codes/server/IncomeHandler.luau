--[[
    IncomeHandler.luau
    ===================
    SERVER-SIDE INCOME GENERATION LOOP
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Runs a continuous loop that awards money to all players
    every tick (configurable via GameConfig.IncomeTickRate).
    
    💰 INCOME FORMULA (from IncomeModule):
      MoneyPerSecond = BasePetIncome × MutationMultiplier × UpgradeMultiplier
                     × RebirthMultiplier × LuckBonus × PotionMultiplier
    
    🔄 PER PLAYER EACH TICK:
      1) Look at all placed pets on plots
      2) Calculate income per second for each pet using IncomeModule
      3) Add total income to player's Money
      4) Sync updated money to client (for HUD display)
    
    📦 DEPENDS ON: DataManager, IncomeModule, GameConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local IncomeHandler = {}

function IncomeHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local IncomeModule = require(Shared.Modules.IncomeModule)
    local GameConfig = require(Shared.Config.GameConfig)
    local DataManager = require(script.Parent.DataManager)

    -- Main income loop
    task.spawn(function()
        while true do
            task.wait(GameConfig.IncomeTickRate)

            for _, player in Players:GetPlayers() do
                local data = DataManager.GetData(player)
                if not data then continue end

                -- Build list of placed pets with their data
                local placedPetList = {}
                for plotId, petUniqueId in data.PlacedPets do
                    -- Find pet in inventory by UniqueId
                    for _, pet in data.OwnedPets do
                        if pet.UniqueId == petUniqueId then
                            table.insert(placedPetList, {
                                PetData = pet,
                                Mutation = pet.Mutation or "None",
                            })
                            break
                        end
                    end
                end

                -- Calculate and award income
                if #placedPetList > 0 then
                    local totalIncome = IncomeModule.CalculateTotalIncome(placedPetList, data)
                    data.Money += totalIncome

                    -- Sync to client
                    DataManager.SyncToClient(player)
                end
            end
        end
    end)

    print("[IncomeHandler] Initialized — income loop running")
end

return IncomeHandler
