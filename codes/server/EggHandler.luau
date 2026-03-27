--[[
    EggHandler.luau
    ================
    SERVER-SIDE EGG HATCHING LOGIC
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles the complete egg hatching flow on the server:
      - Receiving egg purchase requests from clients (RE_BuyEgg)
      - Validating player can afford the egg and meets rebirth requirement
      - Deducting money
      - Rolling a pet from the egg's PetPool (weighted RNG)
      - Rolling mutation (separate RNG pass)
      - Creating the pet entry in player's inventory
      - Sending the result back to client (RE_EggResult) for animations
    
    🔄 FLOW:
      Client fires RE_BuyEgg(eggName)
      → Server validates → deducts money → rolls pet → rolls mutation
      → Adds pet to OwnedPets → fires RE_EggResult(petData) back to client
    
    📦 DEPENDS ON:
      - DataManager (player data)
      - EggModule (egg lookup, pet rolling)
      - MutationModule (mutation rolling)
      - TableUtil (unique ID generation)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EggHandler = {}

function EggHandler.Init()
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local EggModule = require(Shared.Modules.EggModule)
    local MutationModule = require(Shared.Modules.MutationModule)
    local UpgradeConfig = require(Shared.Config.UpgradeConfig)
    local TableUtil = require(Shared.Utils.TableUtil)
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local buyEggRemote = remotesFolder:WaitForChild("RE_BuyEgg")
    local eggResultRemote = remotesFolder:WaitForChild("RE_EggResult")

    buyEggRemote.OnServerEvent:Connect(function(player, eggName)
        local data = DataManager.GetData(player)
        if not data then return end

        -- Validate egg purchase
        local canBuy, reason = EggModule.CanBuyEgg(eggName, data.Money, data.Rebirths)
        if not canBuy then
            warn("[EggHandler] " .. player.Name .. " can't buy " .. eggName .. ": " .. reason)
            return
        end

        -- Deduct money
        local egg = EggModule.GetEggByName(eggName)
        data.Money -= egg.Price

        -- Roll pet from egg pool
        local rolledPet = EggModule.RollPet(egg)

        -- Calculate effective mutation chance
        local baseMutChance = egg.BaseMutationChance
        local upgradeBonus = (data.MutationChanceLevel or 0) * UpgradeConfig.Upgrades.MutationChanceLevel.ValuePerLevel
        local potionMult = data.ActiveMutationPotionMultiplier or 1
        local effectiveChance = (baseMutChance + upgradeBonus) * potionMult

        -- Roll mutation
        local mutationName = MutationModule.RollMutation(effectiveChance)

        -- Create pet entry
        local newPet = {
            PetName = rolledPet.Name,
            Rarity = rolledPet.Rarity,
            Mutation = mutationName,
            UniqueId = TableUtil.RandomId(),
            BaseIncome = rolledPet.BaseIncome,
            LuckMultiplier = rolledPet.LuckMultiplier,
            EggSource = eggName,
        }

        -- Add to inventory
        table.insert(data.OwnedPets, newPet)

        -- Sync data to client
        DataManager.SyncToClient(player)

        -- Send hatch result for animation
        eggResultRemote:FireClient(player, newPet)

        print("[EggHandler] " .. player.Name .. " hatched " .. newPet.PetName .. " (" .. newPet.Rarity .. ", " .. mutationName .. ")")
    end)

    print("[EggHandler] Initialized")
end

return EggHandler
