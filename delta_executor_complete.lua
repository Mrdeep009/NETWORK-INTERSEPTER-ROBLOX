-- Delta Executor Complete Version
local Delta = {
    _VERSION = "3.1",
    _AUTHOR = "Delta Team",
    _LICENSE = "PRIVATE"
}

-- Core Services
Delta.Services = {
    Tween = game:GetService("TweenService"),
    Input = game:GetService("UserInputService"),
    Http = game:GetService("HttpService"),
    Network = game:GetService("NetworkClient")
}

-- Configuration
Delta.Config = {
    Webhook = "",
    Logging = {
        Mode = "BOTH", -- SENT, RECEIVED, BOTH
        SaveLocal = false
    }
}

-- UI Framework
Delta.UI = {
    Main = Instance.new("ScreenGui"),
    Themes = {
        Dark = {
            Background = Color3.fromRGB(20, 20, 30),
            Primary = Color3.fromRGB(0, 170, 255),
            Secondary = Color3.fromRGB(40, 40, 50),
            Text = Color3.fromRGB(255, 255, 255),
            Error = Color3.fromRGB(255, 50, 50)
        }
    },
    CurrentTheme = "Dark",
    ActiveFrames = {}
}

Delta.UI.Main.Name = "DeltaExecutor"
Delta.UI.Main.ResetOnSpawn = false
Delta.UI.Main.Parent = game:GetService("CoreGui")

-- Loading Screen Implementation
function Delta.UI.ShowLoadingScreen()
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Background
    loadingFrame.Parent = Delta.UI.Main

    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Text = "DELTA EXECUTOR INITIALIZING..."
    loadingLabel.TextColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Text
    loadingLabel.Size = UDim2.new(1, 0, 0.1, 0)
    loadingLabel.Position = UDim2.new(0, 0, 0.45, 0)
    loadingLabel.Parent = loadingFrame

    -- Loading animation
    local tween = Delta.Services.Tween:Create(
        loadingLabel,
        TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true),
        {TextTransparency = 0.5}
    )
    tween:Play()

    return {
        Frame = loadingFrame,
        Label = loadingLabel,
        Tween = tween
    }
end

-- Main Dashboard
function Delta.UI.ShowMainDashboard()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Secondary
    mainFrame.Parent = Delta.UI.Main

    -- Webhook Configuration
    local webhookFrame = Instance.new("Frame")
    webhookFrame.Size = UDim2.new(0.8, 0, 0.3, 0)
    webhookFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    webhookFrame.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Background
    webhookFrame.Parent = mainFrame

    local webhookInput = Instance.new("TextBox")
    webhookInput.PlaceholderText = "Enter Discord Webhook URL"
    webhookInput.Size = UDim2.new(0.8, 0, 0.3, 0)
    webhookInput.Position = UDim2.new(0.1, 0, 0.2, 0)
    webhookInput.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Secondary
    webhookInput.TextColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Text
    webhookInput.Parent = webhookFrame

    local setupButton = Instance.new("TextButton")
    setupButton.Text = "SETUP WEBHOOK"
    setupButton.Size = UDim2.new(0.5, 0, 0.2, 0)
    setupButton.Position = UDim2.new(0.25, 0, 0.6, 0)
    setupButton.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Primary
    setupButton.TextColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Text
    setupButton.Parent = webhookFrame

    -- Setup button functionality
    setupButton.MouseButton1Click:Connect(function()
        if #webhookInput.Text > 0 then
            local success, err = Delta.SetupWebhook(webhookInput.Text)
            if success then
                setupButton.Text = "VERIFYING..."
                task.delay(1.5, function()
                    setupButton.Text = "WEBHOOK SETUP COMPLETE"
                    Delta.UI.ShowLoggingOptions(mainFrame)
                end)
            else
                setupButton.Text = "INVALID WEBHOOK"
                setupButton.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Error
                task.delay(1.5, function()
                    setupButton.Text = "SETUP WEBHOOK"
                    setupButton.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Primary
                end)
            end
        end
    end)

    Delta.UI.ActiveFrames.Main = mainFrame
    Delta.UI.ActiveFrames.Webhook = webhookFrame
end

-- Logging Options
function Delta.UI.ShowLoggingOptions(parentFrame)
    local loggingFrame = Instance.new("Frame")
    loggingFrame.Size = UDim2.new(0.8, 0, 0.4, 0)
    loggingFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
    loggingFrame.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Background
    loggingFrame.Parent = parentFrame

    local logSent = Instance.new("TextButton")
    logSent.Text = "LOG SENT DATA ONLY"
    logSent.Size = UDim2.new(0.8, 0, 0.2, 0)
    logSent.Position = UDim2.new(0.1, 0, 0.1, 0)
    logSent.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Primary
    logSent.TextColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Text
    logSent.Parent = loggingFrame

    local logReceived = Instance.new("TextButton")
    logReceived.Text = "LOG RECEIVED DATA ONLY"
    logReceived.Size = UDim2.new(0.8, 0, 0.2, 0)
    logReceived.Position = UDim2.new(0.1, 0, 0.4, 0)
    logReceived.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Primary
    logReceived.TextColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Text
    logReceived.Parent = loggingFrame

    local logBoth = Instance.new("TextButton")
    logBoth.Text = "LOG BOTH SENT & RECEIVED"
    logBoth.Size = UDim2.new(0.8, 0, 0.2, 0)
    logBoth.Position = UDim2.new(0.1, 0, 0.7, 0)
    logBoth.BackgroundColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Primary
    logBoth.TextColor3 = Delta.UI.Themes[Delta.UI.CurrentTheme].Text
    logBoth.Parent = loggingFrame

    -- Button functionality
    logSent.MouseButton1Click:Connect(function()
        Delta.Config.Logging.Mode = "SENT"
    end)

    logReceived.MouseButton1Click:Connect(function()
        Delta.Config.Logging.Mode = "RECEIVED"
    end)

    logBoth.MouseButton1Click:Connect(function()
        Delta.Config.Logging.Mode = "BOTH"
    end)

    Delta.UI.ActiveFrames.Logging = loggingFrame
end

-- Webhook Setup
function Delta.SetupWebhook(url)
    if type(url) ~= "string" or #url < 10 then
        return false
    end
    Delta.Config.Webhook = url
    return true
end

-- Initialize
local loadingScreen = Delta.UI.ShowLoadingScreen()

-- Simulate loading process
task.delay(3, function()
    loadingScreen.Tween:Cancel()
    loadingScreen.Frame:Destroy()
    Delta.UI.ShowMainDashboard()
end)

return Delta
