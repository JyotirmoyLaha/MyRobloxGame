--[[
    EggController.luau
    ====================
    CLIENT-SIDE EGG HATCHING — Animations, Camera, and Sound
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Controllers
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Handles the client-side experience of egg hatching:
      - Sending egg purchase requests to server (RE_BuyEgg)
      - Receiving hatch results from server (RE_EggResult)
      - Playing the egg opening animation
      - Camera zooms, egg crack effects, pet reveal
      - Mutation flash effects (if mutated)
      - Sound effects
    
    💡 THIS IS WHERE THE "GAME FEEL" LIVES:
      - Camera shake on crack
      - Particle burst on reveal
      - Screen flash for rare mutations
      - Exciting sound effects
    
    📦 DEPENDS ON: DataController, SoundManager, EggOpenEffect, MutationEffect
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EggController = {}

function EggController.Init(player, remotes)
    local buyEggRemote = remotes:WaitForChild("RE_BuyEgg")
    local eggResultRemote = remotes:WaitForChild("RE_EggResult")

    -- Listen for hatch results from server
    eggResultRemote.OnClientEvent:Connect(function(petData)
        -- petData = { PetName, Rarity, Mutation, UniqueId, BaseIncome, LuckMultiplier, EggSource }

        -- TODO: Play egg opening animation
        -- TODO: Camera zoom to egg model
        -- TODO: Egg crack particles & sound
        -- TODO: Reveal pet with rarity-colored glow
        -- TODO: If mutation ~= "None", play mutation flash effect
        -- TODO: Show result UI popup (pet name, rarity, mutation)
        -- TODO: Return camera to normal

        print("[EggController] Hatched: " .. petData.PetName .. " (" .. petData.Rarity .. ", " .. petData.Mutation .. ")")
    end)

    print("[EggController] Initialized")
end

-- Called by ShopUI when player clicks "Hatch" button
function EggController.RequestHatch(eggName: string)
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    local buyEggRemote = remotes:WaitForChild("RE_BuyEgg")
    buyEggRemote:FireServer(eggName)
end

return EggController
