-- Client-side Delta Executor Loader (Enhanced Version)
-- Executes all modules from GitHub in sequence with better integration and error handling

-- List of modules to load
local MODULES = {
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_core.lua",
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_network.lua",
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_webhook.lua",
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_ui.lua",
    "https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/main/delta_executor_main.lua"
}

local function loadModule(url)
    print("Attempting to load module: " .. url)
    local success, result = pcall(function()
        local response = game:HttpGet(url)
        assert(response, "Received empty response from: " .. url)
        return loadstring(response)()
    end)

    if not success then
        warn("Failed to load module: " .. url .. "\nError: " .. tostring(result))
        return false, nil
    else
        print("Successfully loaded module: " .. url)
    end
    return true, result
end

-- Table to hold loaded modules
local LoadedModules = {}

-- Load and execute all modules in order
for _, moduleUrl in ipairs(MODULES) do
    local success, module = loadModule(moduleUrl)
    if not success then
        error("Critical module failed to load: " .. moduleUrl)
    else
        table.insert(LoadedModules, module)
    end
end

-- Initialize the executor using the main module
local mainModule = LoadedModules[#LoadedModules]
if mainModule and type(mainModule.Init) == "function" then
    print("Initializing Delta Executor...")
    mainModule.Init()
    print("Delta Executor initialized successfully!")
else
    error("Main module is missing Init function!")
end
