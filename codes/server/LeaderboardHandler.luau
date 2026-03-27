--[[
    LeaderboardHandler.luau
    ========================
    SERVER-SIDE LEADERBOARD SYSTEM
    
    📍 Location: ServerScriptService.Server.Services
    📝 Type: ModuleScript (Server)
    
    🎯 PURPOSE:
    Handles leaderboard data:
      - Tracking top players by various stats
      - Responding to RF_GetLeaderboard requests from client
      - Returns current players sorted by money
    
    📋 LEADERBOARD CATEGORIES:
      - Total Money Earned (lifetime)
      - Most Rebirths
      - Rarest Pet Collection
      - Highest Income Per Second
    
    📦 DEPENDS ON: DataManager
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LeaderboardHandler = {}

function LeaderboardHandler.Init()
    local DataManager = require(script.Parent.DataManager)

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
    local getLeaderboard = remotesFolder:WaitForChild("RF_GetLeaderboard")

    -- Client requests leaderboard data
    getLeaderboard.OnServerInvoke = function(player, category)
        local leaderboardData = {}

        for _, p in Players:GetPlayers() do
            local data = DataManager.GetData(p)
            if data then
                table.insert(leaderboardData, {
                    PlayerName = p.Name,
                    Money = data.Money or 0,
                    Rebirths = data.Rebirths or 0,
                })
            end
        end

        -- Sort by money (descending)
        table.sort(leaderboardData, function(a, b)
            return a.Money > b.Money
        end)

        return leaderboardData
    end

    print("[LeaderboardHandler] Initialized")
end

return LeaderboardHandler
