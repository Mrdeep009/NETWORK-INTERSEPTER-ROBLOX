-- Delta Executor Main Module (Enhanced Version)
local Delta = {
    UI = require(script.Parent.delta_executor_ui),
    Network = require(script.Parent.delta_executor_network),
    Webhook = require(script.Parent.delta_executor_webhook)
}

-- Initialize the executor
function Delta.Init()
    -- Show loading screen
    print("Initializing Delta Executor...")
    local loadingScreen = Delta.UI.ShowLoadingScreen()

    task.delay(3, function()
        -- Remove loading screen
        print("Loading complete. Showing main dashboard...")
        loadingScreen.Tween:Cancel()
        loadingScreen.Frame:Destroy()

        -- Show main dashboard
        Delta.UI.ShowMainDashboard()
    end)

    -- Start network interception
    Delta.Network.StartInterception()
end

return Delta
