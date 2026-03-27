--[[
    SellHandler.luau
    =================
    SERVER-SIDE SELL STAND LOGIC
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles selling pets for money:
      - Receiving sell requests from client (RE_SellPet)
      - Validating the pet exists in inventory
      - Calculating sell value (based on BaseIncome × rarity × mutation)
      - Removing pet from inventory, equipped list, and plots
      - Adding money to player
    
    💰 SELL VALUE FORMULA (from PetModule.GetSellValue):
      SellValue = BaseIncome × 10 × RarityOrder × MutationMoneyBoost
    
    📦 DEPENDS ON: DataManager, PetModule
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SellHandler = {}

function SellHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local PetModule = require(Shared.Modules.PetModule)
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local sellRemote = remotesFolder:WaitForChild("RE_SellPet")

    sellRemote.OnServerEvent:Connect(function(player, petUniqueId)
        local data = DataManager.GetData(player)
        if not data then return end

        -- Find pet in inventory
        local petIndex = nil
        local petData = nil
        for i, pet in data.OwnedPets do
            if pet.UniqueId == petUniqueId then
                petIndex = i
                petData = pet
                break
            end
        end

        if not petIndex then
            warn("[SellHandler] Pet not found in inventory: " .. tostring(petUniqueId))
            return
        end

        -- Calculate sell value
        local sellValue = PetModule.GetSellValue(petData, petData.Mutation or "None")

        -- Remove from equipped list if equipped
        for i, id in data.EquippedPets do
            if id == petUniqueId then
                table.remove(data.EquippedPets, i)
                break
            end
        end

        -- Remove from plots if placed
        for plotId, id in data.PlacedPets do
            if id == petUniqueId then
                data.PlacedPets[plotId] = nil
                break
            end
        end

        -- Remove from inventory
        table.remove(data.OwnedPets, petIndex)

        -- Add money
        data.Money += sellValue

        DataManager.SyncToClient(player)
        print("[SellHandler] " .. player.Name .. " sold " .. petData.PetName .. " for " .. sellValue)
    end)

    print("[SellHandler] Initialized")
end

return SellHandler
