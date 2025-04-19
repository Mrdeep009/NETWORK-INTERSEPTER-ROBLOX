-- Delta Executor Main Module (Enhanced Version)
local Delta = {}

-- Debug Logging
local function safeRequire(modulePath)
    local success, result = pcall(function()
        return require(modulePath)
    end)
    if not success then
        warn("Failed to load module:", tostring(modulePath), "Error:", tostring(result))
        return nil
    end
    return result
end

-- Require Modules Safely
Delta.UI = safeRequire(script.Parent.delta_executor_ui)
Delta.Network = safeRequire(script.Parent.delta_executor_network)
Delta.Webhook = safeRequire(script.Parent.delta_executor_webhook)

-- Validate Modules
if not Delta.UI then error("delta_executor_ui failed to load!") end
if not Delta.Network then error("delta_executor_network failed to load!") end
if not Delta.Webhook then error("delta_executor_webhook failed to load!") end

-- Initialize the executor
function Delta.Init()
    -- Show loading screen
    print("Initializing Delta Executor...")
    local loadingScreen = Delta.UI.ShowLoadingScreen()

    task.delay(3, function()
        -- Remove loading screen
        print("Loading complete. Showing main dashboard...")
        if loadingScreen.Tween then loadingScreen.Tween:Cancel() end
        if loadingScreen.Frame then loadingScreen.Frame:Destroy() end

        -- Show main dashboard
        Delta.UI.ShowMainDashboard()
    end)

    -- Start network interception
    Delta.Network.StartInterception()
end

return Delta
