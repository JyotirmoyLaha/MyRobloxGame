--[[
    MoneySystem.server.luau
    ========================
    STANDALONE MONEY BLOCK COLLECTION SYSTEM
    
    📍 Location: ServerScriptService.MoneySystem
    📝 Type: Script (Server)
    
    🎯 PURPOSE:
    A complete money generation + collection system using touchable "MoneyBlocks":
      - Money blocks accumulate money over time (passive generation)
      - When a player touches a block, they collect the accumulated money
      - Floating money animation plays on client
      - Cooldown system prevents spam-collection
      - Block display resets to $0 during cooldown
    
    📋 HOW IT WORKS:
      1. Each MoneyBlock in the "MoneyBlocks" folder generates money every second
      2. When player touches a block → they collect all accumulated money
      3. Block enters cooldown (1-2 seconds), showing $0
      4. After cooldown, block starts generating money again
    
    🔄 EVENTS USED:
      - MoneyChanged         → Updates client money display
      - FloatingMoneyAnimation → Shows "+$X" text on client
      - ResetBlockMoney      → Resets block display after collection
      - BlockCooldown        → Signals cooldown start/end to display script
    
    ⚙️ CONFIGURATION:
      - moneyPerTap = 3000           — Base money generated per second
      - tapCooldown = 0.5            — Min time between collections
      - Block cooldown = 1-2 seconds — After collection
    
    ⚠️ NOTE: This is a standalone system separate from the main pet-based
       income system. It provides an additional way for players to earn money.
    
    📦 WORKSPACE SETUP:
      Place money blocks inside: Workspace > [Building Name] > MoneyBlocks
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create remote events if they don't exist
local moneyEvent = ReplicatedStorage:FindFirstChild("MoneyChanged")
if not moneyEvent then
    moneyEvent = Instance.new("RemoteEvent")
    moneyEvent.Name = "MoneyChanged"
    moneyEvent.Parent = ReplicatedStorage
end

local floatingMoneyEvent = ReplicatedStorage:FindFirstChild("FloatingMoneyAnimation")
if not floatingMoneyEvent then
    floatingMoneyEvent = Instance.new("RemoteEvent")
    floatingMoneyEvent.Name = "FloatingMoneyAnimation"
    floatingMoneyEvent.Parent = ReplicatedStorage
end

local resetBlockMoneyEvent = ReplicatedStorage:FindFirstChild("ResetBlockMoney")
if not resetBlockMoneyEvent then
    resetBlockMoneyEvent = Instance.new("RemoteEvent")
    resetBlockMoneyEvent.Name = "ResetBlockMoney"
    resetBlockMoneyEvent.Parent = ReplicatedStorage
end

local blockCooldownEvent = ReplicatedStorage:FindFirstChild("BlockCooldown")
if not blockCooldownEvent then
    blockCooldownEvent = Instance.new("RemoteEvent")
    blockCooldownEvent.Name = "BlockCooldown"
    blockCooldownEvent.Parent = ReplicatedStorage
end

local moneyPerTapValue = ReplicatedStorage:FindFirstChild("MoneyPerTap")
if not moneyPerTapValue then
    moneyPerTapValue = Instance.new("IntValue")
    moneyPerTapValue.Name = "MoneyPerTap"
    moneyPerTapValue.Parent = ReplicatedStorage
end

local moneyAmount = {}
local moneyPerTap = 3000
moneyPerTapValue.Value = moneyPerTap
local tapCooldown = 0.5
local lastTapTime = {}

if not _G.BlockMoneyGenerated then
    _G.BlockMoneyGenerated = {}
end

if not _G.BlockInCooldown then
    _G.BlockInCooldown = {}
end

for _, player in Players:GetPlayers() do
    moneyAmount[player.UserId] = 0
    lastTapTime[player.UserId] = 0
    moneyEvent:FireClient(player, 0)
end

Players.PlayerAdded:Connect(function(player)
    moneyAmount[player.UserId] = 0
    lastTapTime[player.UserId] = 0
    moneyEvent:FireClient(player, 0)
end)

-- ⚠️ CHANGE THIS PATH to match your workspace hierarchy
local moneyBlocksFolder = workspace:WaitForChild("Building 1"):WaitForChild("MoneyBlocks")

for _, moneyBlock in pairs(moneyBlocksFolder:GetChildren()) do
    _G.BlockMoneyGenerated[moneyBlock] = 0
    _G.BlockInCooldown[moneyBlock] = false
    local canCollect = true

    -- Money generation loop
    task.spawn(function()
        while true do
            task.wait(1)
            -- Only generate if NOT in cooldown
            if not _G.BlockInCooldown[moneyBlock] then
                _G.BlockMoneyGenerated[moneyBlock] = _G.BlockMoneyGenerated[moneyBlock] + moneyPerTap
            end
        end
    end)

    moneyBlock.Touched:Connect(function(hit)
        if not canCollect then return end

        local character = hit.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                local currentTime = tick()
                if currentTime - (lastTapTime[player.UserId] or 0) >= tapCooldown then
                    canCollect = false
                    lastTapTime[player.UserId] = currentTime

                    local blockAccumulated = _G.BlockMoneyGenerated[moneyBlock] or 0

                    if blockAccumulated > 0 then
                        moneyAmount[player.UserId] = (moneyAmount[player.UserId] or 0) + blockAccumulated
                        moneyEvent:FireClient(player, moneyAmount[player.UserId])
                        floatingMoneyEvent:FireClient(player, blockAccumulated)

                        -- Reset and cooldown
                        _G.BlockMoneyGenerated[moneyBlock] = 0
                        _G.BlockInCooldown[moneyBlock] = true
                        resetBlockMoneyEvent:FireAllClients(moneyBlock)
                        blockCooldownEvent:FireAllClients(moneyBlock, true)

                        print(player.Name .. " collected $" .. blockAccumulated .. "! Total: $" .. moneyAmount[player.UserId])

                        -- Cooldown
                        task.wait(1)
                        _G.BlockInCooldown[moneyBlock] = false
                        blockCooldownEvent:FireAllClients(moneyBlock, false)

                    else
                        moneyAmount[player.UserId] = (moneyAmount[player.UserId] or 0) + moneyPerTap
                        moneyEvent:FireClient(player, moneyAmount[player.UserId])
                        floatingMoneyEvent:FireClient(player, moneyPerTap)

                        _G.BlockMoneyGenerated[moneyBlock] = 0
                        _G.BlockInCooldown[moneyBlock] = true
                        resetBlockMoneyEvent:FireAllClients(moneyBlock)
                        blockCooldownEvent:FireAllClients(moneyBlock, true)

                        print(player.Name .. " collected money! Total: $" .. moneyAmount[player.UserId])

                        task.wait(2)
                        _G.BlockInCooldown[moneyBlock] = false
                        blockCooldownEvent:FireAllClients(moneyBlock, false)
                    end

                    task.wait(0.5)
                    canCollect = true
                end
            end
        end
    end)
end

Players.PlayerRemoving:Connect(function(player)
    moneyAmount[player.UserId] = nil
    lastTapTime[player.UserId] = nil
end)
