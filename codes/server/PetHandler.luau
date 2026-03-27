--[[
    PetHandler.luau
    ================
    SERVER-SIDE PET EQUIP/MANAGE LOGIC
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles pet equipping and unequipping:
      - Equipping pets (adds to EquippedPets, boosts luck)
      - Unequipping pets (removes from EquippedPets)
      - Validating equip slot limits
      - Recalculating total luck when equip changes
    
    📋 EQUIP RULES:
      - Player starts with 2 equip slots (configurable)
      - Can upgrade to max 6 slots
      - Equipped pets provide passive LuckMultiplier bonus
      - A pet can be equipped AND placed on a plot simultaneously
    
    📦 DEPENDS ON: DataManager, PetModule, PetConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PetHandler = {}

function PetHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local PetConfig = require(Shared.Config.PetConfig)
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local equipRemote = remotesFolder:WaitForChild("RE_EquipPet")
    local unequipRemote = remotesFolder:WaitForChild("RE_UnequipPet")

    -- Equip a pet
    equipRemote.OnServerEvent:Connect(function(player, petUniqueId)
        local data = DataManager.GetData(player)
        if not data then return end

        -- Check slot limit
        if #data.EquippedPets >= (data.EquipSlots or PetConfig.DefaultEquipSlots) then
            warn("[PetHandler] " .. player.Name .. " has no equip slots available")
            return
        end

        -- Check pet exists in inventory
        local petExists = false
        for _, pet in data.OwnedPets do
            if pet.UniqueId == petUniqueId then
                petExists = true
                break
            end
        end
        if not petExists then return end

        -- Check not already equipped
        for _, id in data.EquippedPets do
            if id == petUniqueId then return end
        end

        -- Equip
        table.insert(data.EquippedPets, petUniqueId)

        -- TODO: Recalculate TotalLuck using PetModule.CalculateTotalLuck

        DataManager.SyncToClient(player)
    end)

    -- Unequip a pet
    unequipRemote.OnServerEvent:Connect(function(player, petUniqueId)
        local data = DataManager.GetData(player)
        if not data then return end

        for i, id in data.EquippedPets do
            if id == petUniqueId then
                table.remove(data.EquippedPets, i)
                -- TODO: Recalculate TotalLuck
                DataManager.SyncToClient(player)
                return
            end
        end
    end)

    print("[PetHandler] Initialized")
end

return PetHandler
