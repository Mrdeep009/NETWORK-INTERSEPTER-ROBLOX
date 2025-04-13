-- Client-side Delta Executor Loader
-- Executes all modules from GitHub in sequence

local MODULES = {
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_core.lua",
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_network.lua",
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_webhook.lua",
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_ui.lua",
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_main.lua"
}

local function loadModule(url)
    local success, err = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("Failed to load module: "..url.."\nError: "..tostring(err))
        return false
    end
    return true
end

-- Execute all modules in order
for _, moduleUrl in ipairs(MODULES) do
    if not loadModule(moduleUrl) then
        error("Critical module failed to load: "..moduleUrl)
    end
end

-- Initialize after all modules loaded
local Delta = require(script.Parent.delta_executor_main)
Delta.Initialize()

print("Delta Executor Client v1.0 loaded successfully")
print("All modules executed in correct order")

return Delta
