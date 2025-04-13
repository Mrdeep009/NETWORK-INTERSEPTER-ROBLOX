-- Delta Executor Main Module
local Delta = require(script.Parent.delta_executor_ui) -- Load UI module

-- Initialize the executor
function Delta.Init()
    Delta.UI.ShowLoadingScreen() -- Show loading screen
    task.delay(3, function() -- Simulate loading
        Delta.UI.LoadingScreen.Tween:Cancel()
        Delta.UI.LoadingScreen.Frame:Destroy()
        Delta.UI.ShowMainDashboard() -- Show main dashboard after loading
    end)
end

return Delta
