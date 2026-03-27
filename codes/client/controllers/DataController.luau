--[[
    DataController.luau
    ====================
    CLIENT-SIDE DATA LISTENER
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Controllers
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    Receives and stores player data from the server:
      - Listening for RE_DataUpdate from server
      - Storing the latest player data locally for UI display
      - Providing a simple API for other client scripts to read data
      - Firing a BindableEvent signal when data changes (so UI can refresh)
    
    🔧 HOW OTHER SCRIPTS USE THIS:
      local DataController = require(Client.Controllers.DataController)
      local money = DataController.GetData().Money
    
    ⚠️ IMPORTANT:
      - This data is READ-ONLY on the client
      - Never modify it — changes won't be saved
      - All modifications go through server RemoteEvents
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataController = {}

-- Current player data (updated by server)
local currentData = {}

-- Bindable for other scripts to listen to data changes
local dataChangedEvent = Instance.new("BindableEvent")
DataController.DataChanged = dataChangedEvent.Event

function DataController.Init(player, remotes)
    -- Listen for server data updates
    local dataUpdateRemote = remotes:WaitForChild("RE_DataUpdate")
    dataUpdateRemote.OnClientEvent:Connect(function(newData)
        currentData = newData
        dataChangedEvent:Fire(newData)
    end)

    -- Request initial data
    local getDataRemote = remotes:WaitForChild("RF_GetPlayerData")
    local initialData = getDataRemote:InvokeServer()
    if initialData then
        currentData = initialData
        dataChangedEvent:Fire(initialData)
    end

    print("[DataController] Initialized")
end

-- Get the current player data snapshot.
function DataController.GetData()
    return currentData
end

-- Get a specific field from player data.
function DataController.GetField(fieldName: string)
    return currentData[fieldName]
end

return DataController
