--[[
    PetController.luau
    ===================
    CLIENT-SIDE PET DISPLAY & EQUIP UI
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Controllers
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Handles pet inventory display and equip/unequip actions:
      - Displaying pet inventory
      - Equip/unequip pet buttons
      - Showing pet details (name, rarity, mutation, income, luck)
      - Pet model preview
      - Sorting by rarity
    
    📦 DEPENDS ON: DataController, PetModule, PetConfig
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PetController = {}

function PetController.Init(player, remotes)
    local equipRemote = remotes:WaitForChild("RE_EquipPet")
    local unequipRemote = remotes:WaitForChild("RE_UnequipPet")

    -- TODO: Listen for DataController.DataChanged to refresh pet list
    -- TODO: Build inventory UI from OwnedPets data
    -- TODO: Handle equip/unequip button clicks

    print("[PetController] Initialized")
end

-- Request to equip a pet
function PetController.EquipPet(petUniqueId: string)
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    remotes:WaitForChild("RE_EquipPet"):FireServer(petUniqueId)
end

-- Request to unequip a pet
function PetController.UnequipPet(petUniqueId: string)
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    remotes:WaitForChild("RE_UnequipPet"):FireServer(petUniqueId)
end

return PetController
