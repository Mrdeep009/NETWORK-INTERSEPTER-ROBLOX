-- Delta Executor Network Module (Fully Functional Version)
local DeltaNetwork = {}

-- Services
local HttpService = game:GetService("HttpService")
local NetworkClient = game:GetService("NetworkClient")
local CollectionService = game:GetService("CollectionService") -- Optional for tagging remotes

-- Configuration
DeltaNetwork.Config = {
    Logging = {
        Mode = "BOTH", -- Options: SENT, RECEIVED, BOTH
        SaveLocal = false, -- Set to true if you want to save logs locally
        LogDirectory = "DeltaLogs", -- Directory for saving logs (if supported)
    },
    Filters = {
        RemoteNames = {}, -- List of specific remote names to monitor (empty = all)
    },
}

-- Internal State
DeltaNetwork.Hooks = {
    RemoteEvents = {},
    RemoteFunctions = {},
}
DeltaNetwork.Logs = {} -- Store logs in memory

-- Utility: Log Data
function DeltaNetwork.LogData(direction, remote, data)
    local logEntry = {
        Direction = direction, -- SENT or RECEIVED
        RemoteName = remote.Name,
        RemoteType = remote.ClassName,
        Data = data,
        Timestamp = os.time(),
    }

    -- Print log to console
    print(string.format("[%s] %s (%s): %s", direction, remote.Name, remote.ClassName, HttpService:JSONEncode(data)))

    -- Save log in memory
    table.insert(DeltaNetwork.Logs, logEntry)

    -- Optional: Save to file (if enabled)
    if DeltaNetwork.Config.Logging.SaveLocal then
        local logFileName = string.format("%s/%s_%s.json", DeltaNetwork.Config.Logging.LogDirectory, remote.Name, os.time())
        writefile(logFileName, HttpService:JSONEncode(logEntry)) -- Requires writefile support
    end
end

-- Hook RemoteEvent
function DeltaNetwork.HookRemoteEvent(remote)
    if DeltaNetwork.Hooks.RemoteEvents[remote] then
        return -- Already hooked
    end

    -- Hook FireServer (Client-to-Server)
    local originalFireServer = remote.FireServer
    remote.FireServer = function(self, ...)
        DeltaNetwork.LogData("SENT", self, {...})
        return originalFireServer(self, ...)
    end

    -- Hook OnClientEvent (Server-to-Client)
    remote.OnClientEvent:Connect(function(...)
        DeltaNetwork.LogData("RECEIVED", remote, {...})
    end)

    DeltaNetwork.Hooks.RemoteEvents[remote] = true
    print("Hooked RemoteEvent: " .. remote.Name)
end

-- Hook RemoteFunction
function DeltaNetwork.HookRemoteFunction(remote)
    if DeltaNetwork.Hooks.RemoteFunctions[remote] then
        return -- Already hooked
    end

    -- Hook InvokeServer (Client-to-Server)
    local originalInvokeServer = remote.InvokeServer
    remote.InvokeServer = function(self, ...)
        DeltaNetwork.LogData("SENT", self, {...})
        return originalInvokeServer(self, ...)
    end

    -- Hook OnClientInvoke (Server-to-Client)
    remote.OnClientInvoke = function(...)
        DeltaNetwork.LogData("RECEIVED", remote, {...})
        return nil -- Optionally modify return value
    end

    DeltaNetwork.Hooks.RemoteFunctions[remote] = true
    print("Hooked RemoteFunction: " .. remote.Name)
end

-- Intercept All Remote Objects
function DeltaNetwork.InterceptRemotes()
    -- Hook existing remotes
    for _, remote in ipairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            DeltaNetwork.HookRemoteEvent(remote)
        elseif remote:IsA("RemoteFunction") then
            DeltaNetwork.HookRemoteFunction(remote)
        end
    end

    -- Automatically hook new remotes
    game.DescendantAdded:Connect(function(remote)
        if remote:IsA("RemoteEvent") then
            DeltaNetwork.HookRemoteEvent(remote)
        elseif remote:IsA("RemoteFunction") then
            DeltaNetwork.HookRemoteFunction(remote)
        end
    end)

    print("Started intercepting network traffic.")
end

-- Start Interception
function DeltaNetwork.StartInterception()
    DeltaNetwork.InterceptRemotes()
end

return DeltaNetwork
