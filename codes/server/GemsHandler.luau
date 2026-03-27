--[[
    GemsHandler.luau
    =================
    SERVER-SIDE GEMS CURRENCY SYSTEM
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles the secondary/premium currency (Gems):
      - Gem purchases (RE_BuyGemItem)
      - Gem rewards (from achievements, codes, etc.)
      - Gem shop items (exclusive pets, potions, cosmetics)
    
    💎 GEMS CAN BE EARNED BY:
      - Rebirthing (bonus gems per rebirth)
      - Achievements / milestones
      - Daily login rewards (future)
      - Codes (future)
    
    💎 GEMS CAN BE SPENT ON:
      - Premium potions
      - Exclusive items
      - Extra equip slots
    
    📦 DEPENDS ON: DataManager
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GemsHandler = {}

function GemsHandler.Init()
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local buyGemItemRemote = remotesFolder:WaitForChild("RE_BuyGemItem")

    buyGemItemRemote.OnServerEvent:Connect(function(player, itemName, gemCost)
        local data = DataManager.GetData(player)
        if not data then return end

        -- TODO: Validate itemName is a real gem shop item
        -- TODO: Check gem cost matches server-side definition (never trust client)
        -- TODO: Deduct gems and give item

        warn("[GemsHandler] Gem purchase not yet implemented: " .. tostring(itemName))
    end)

    print("[GemsHandler] Initialized")
end

-- Utility: Award gems to a player (call from other server scripts).
function GemsHandler.AwardGems(player, amount)
    local DataManager = require(script.Parent.DataManager)
    local data = DataManager.GetData(player)
    if data then
        data.Gems = (data.Gems or 0) + amount
        DataManager.SyncToClient(player)
    end
end

return GemsHandler
