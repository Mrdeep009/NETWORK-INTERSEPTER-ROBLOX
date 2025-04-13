-- Delta Executor Final Main Module
local Delta = require(script.Parent.delta_executor_ui) -- Load UI module
local DeltaNetwork = require(script.Parent.delta_executor_network) -- Load Network module
local DeltaWebhook = require(script.Parent.delta_executor_webhook) -- Load Webhook module
local DeltaSettings = require(script.Parent.delta_executor_settings) -- Load Settings module

-- Initialize the executor
function Delta.Init()
    Delta.UI.ShowLoadingScreen() -- Show loading screen
    task.delay(3, function() -- Simulate loading
        Delta.UI.LoadingScreen.Tween:Cancel()
        Delta.UI.LoadingScreen.Frame:Destroy()
        Delta.UI.ShowMainDashboard() -- Show main dashboard after loading
    end)
end

-- Setup webhook and logging options
function Delta.SetupWebhook(url)
    local success, err = DeltaWebhook.ValidateURL(url)
    if success then
        DeltaWebhook.Config.WebhookURL = url
        return true
    else
        return false, err
    end
end

-- Start the network interception
function Delta.StartInterception()
    DeltaNetwork.StartInterception()
end

return Delta
