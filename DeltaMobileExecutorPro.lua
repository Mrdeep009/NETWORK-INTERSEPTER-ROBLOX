-- Delta Mobile Executor Pro (Enhanced Client-Sided)
local Delta = {
    _VERSION = "5.1",
    _AUTHOR = "Delta Team",
    _LICENSE = "PRIVATE"
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Configuration
Delta.Config = {
    Webhook = "",
    Logging = {
        Mode = "NONE",
        Active = false,
        SaveLocal = true,
        EncryptionDetection = true,
        MaxDataSize = 5000,
        AutoDecrypt = true
    },
    UI = {
        Theme = "Dark",
        Animations = true,
        Draggable = true,
        Transparency = 0.95
    }
}

-- UI Framework
Delta.UI = {
    MainGui = Instance.new("ScreenGui"),
    CurrentPosition = UDim2.new(0.3, 0, 0.2, 0),
    ActiveFrames = {},
    Themes = {
        Dark = {
            Background = Color3.fromRGB(20, 20, 30),
            Primary = Color3.fromRGB(0, 170, 255),
            Secondary = Color3.fromRGB(40, 40, 50),
            Text = Color3.fromRGB(255, 255, 255),
            Error = Color3.fromRGB(255, 50, 50)
        }
    }
}

Delta.UI.MainGui.Name = "DeltaMobileExecutorPro"
Delta.UI.MainGui.ResetOnSpawn = false
Delta.UI.MainGui.Parent = game:GetService("CoreGui")

-- Enhanced Loading Screen with progress animation
function Delta.UI.ShowLoadingScreen()
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Delta.UI.Themes.Dark.Background
    loadingFrame.Parent = Delta.UI.MainGui

    -- Animated logo
    local logo = Instance.new("ImageLabel")
    logo.Image = "rbxassetid://123456789" -- Replace with actual logo ID
    logo.Size = UDim2.new(0.3, 0, 0.3, 0)
    logo.Position = UDim2.new(0.35, 0, 0.35, 0)
    logo.BackgroundTransparency = 1
    logo.Parent = loadingFrame

    -- Loading bar with progress animation
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0.6, 0, 0.02, 0)
    loadingBar.Position = UDim2.new(0.2, 0, 0.6, 0)
    loadingBar.BackgroundColor3 = Delta.UI.Themes.Dark.Secondary
    loadingBar.Parent = loadingFrame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Delta.UI.Themes.Dark.Primary
    progressBar.Parent = loadingBar

    -- Animate progress bar
    TweenService:Create(
        progressBar,
        TweenInfo.new(3, Enum.EasingStyle.Quint),
        {Size = UDim2.new(1, 0, 1, 0)}
    ):Play()

    -- Loading text with pulsing animation
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = "INITIALIZING DELTA EXECUTOR PRO..."
    loadingText.TextColor3 = Delta.UI.Themes.Dark.Text
    loadingText.Size = UDim2.new(1, 0, 0.1, 0)
    loadingText.Position = UDim2.new(0, 0, 0.7, 0)
    loadingText.BackgroundTransparency = 1
    loadingText.Parent = loadingFrame

    local pulseTween = TweenService:Create(
        loadingText,
        TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true),
        {TextTransparency = 0.5}
    )
    pulseTween:Play()

    return {
        Frame = loadingFrame,
        ProgressBar = progressBar,
        PulseTween = pulseTween,
        Logo = logo
    }
end

-- Main Dashboard with Tabs
function Delta.UI.ShowMainDashboard()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
    mainFrame.Position = Delta.UI.CurrentPosition
    mainFrame.BackgroundColor3 = Delta.UI.Themes.Dark.Secondary
    mainFrame.BackgroundTransparency = Delta.Config.UI.Transparency
    mainFrame.Parent = Delta.UI.MainGui

    -- Make draggable
    if Delta.Config.UI.Draggable then
        Delta.UI.MakeDraggable(mainFrame)
    end

    -- Tab buttons
    local tabButtons = Instance.new("Frame")
    tabButtons.Size = UDim2.new(1, 0, 0.1, 0)
    tabButtons.BackgroundTransparency = 1
    tabButtons.Parent = mainFrame

    local function createTabButton(text, position)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0.3, 0, 1, 0)
        button.Position = position
        button.BackgroundColor3 = Delta.UI.Themes.Dark.Primary
        button.TextColor3 = Delta.UI.Themes.Dark.Text
        button.Parent = tabButtons
        return button
    end

    local loggerTab = createTabButton("LOGGER", UDim2.new(0, 0, 0, 0))
    local settingsTab = createTabButton("SETTINGS", UDim2.new(0.35, 0, 0, 0))
    local helpTab = createTabButton("HELP", UDim2.new(0.7, 0, 0, 0))

    -- Tab content frames
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0.9, 0)
    contentFrame.Position = UDim2.new(0, 0, 0.1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Logger Tab Content
    local loggerContent = Instance.new("Frame")
    loggerContent.Size = UDim2.new(1, 0, 1, 0)
    loggerContent.BackgroundTransparency = 1
    loggerContent.Visible = true
    loggerContent.Parent = contentFrame

    -- Webhook Configuration
    local webhookFrame = Instance.new("Frame")
    webhookFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
    webhookFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    webhookFrame.BackgroundColor3 = Delta.UI.Themes.Dark.Background
    webhookFrame.Parent = loggerContent

    local webhookInput = Instance.new("TextBox")
    webhookInput.PlaceholderText = "Enter Discord Webhook URL"
    webhookInput.Size = UDim2.new(0.8, 0, 0.3, 0)
    webhookInput.Position = UDim2.new(0.1, 0, 0.2, 0)
    webhookInput.BackgroundColor3 = Delta.UI.Themes.Dark.Secondary
    webhookInput.TextColor3 = Delta.UI.Themes.Dark.Text
    webhookInput.Parent = webhookFrame

    local setupButton = Instance.new("TextButton")
    setupButton.Text = "SETUP WEBHOOK"
    setupButton.Size = UDim2.new(0.5, 0, 0.2, 0)
    setupButton.Position = UDim2.new(0.25, 0, 0.6, 0)
    setupButton.BackgroundColor3 = Delta.UI.Themes.Dark.Primary
    setupButton.TextColor3 = Delta.UI.Themes.Dark.Text
    setupButton.Parent = webhookFrame

    -- Setup button with loading animation
    setupButton.MouseButton1Click:Connect(function()
        if #webhookInput.Text > 0 then
            setupButton.Text = ""
            local loadingCircle = Instance.new("ImageLabel")
            loadingCircle.Image = "rbxassetid://3570695787"
            loadingCircle.Size = UDim2.new(0.8, 0, 0.8, 0)
            loadingCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
            loadingCircle.BackgroundTransparency = 1
            loadingCircle.Parent = setupButton
            
            local spinTween = TweenService:Create(
                loadingCircle,
                TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true),
                {Rotation = 360}
            )
            spinTween:Play()
            
            task.delay(1.5, function()
                spinTween:Cancel()
                loadingCircle:Destroy()
                setupButton.Text = "WEBHOOK SETUP COMPLETE"
                Delta.Config.Webhook = webhookInput.Text
                Delta.UI.ShowLoggingOptions(loggerContent)
            end)
        end
    end)

    -- Logging Options (shown after webhook setup)
    function Delta.UI.ShowLoggingOptions(parentFrame)
        local loggingFrame = Instance.new("Frame")
        loggingFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
        loggingFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
        loggingFrame.BackgroundColor3 = Delta.UI.Themes.Dark.Background
        loggingFrame.Parent = parentFrame

        local title = Instance.new("TextLabel")
        title.Text = "SELECT LOGGING MODE:"
        title.TextColor3 = Delta.UI.Themes.Dark.Text
        title.Size = UDim2.new(1, 0, 0.1, 0)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Parent = loggingFrame

        local logSent = Delta.UI.CreateOptionButton("LOG SENT DATA ONLY", UDim2.new(0.1, 0, 0.15, 0), loggingFrame)
        local logReceived = Delta.UI.CreateOptionButton("LOG RECEIVED DATA ONLY", UDim2.new(0.1, 0, 0.4, 0), loggingFrame)
        local logBoth = Delta.UI.CreateOptionButton("LOG BOTH SENT & RECEIVED", UDim2.new(0.1, 0, 0.65, 0), loggingFrame)

        -- Control buttons
        local controlFrame = Instance.new("Frame")
        controlFrame.Size = UDim2.new(0.9, 0, 0.15, 0)
        controlFrame.Position = UDim2.new(0.05, 0, 0.85, 0)
        controlFrame.BackgroundTransparency = 1
        controlFrame.Parent = parentFrame

        local startButton = Delta.UI.CreateControlButton("START LOGGER", UDim2.new(0, 0, 0, 0), controlFrame)
        local stopButton = Delta.UI.CreateControlButton("STOP LOGGER", UDim2.new(0.5, 0, 0, 0), controlFrame)

        startButton.MouseButton1Click:Connect(function()
            Delta.StartLogger()
        end)

        stopButton.MouseButton1Click:Connect(function()
            Delta.StopLogger()
        end)

        Delta.UI.ActiveFrames.Logging = loggingFrame
    end

    -- Settings Tab Content
    local settingsContent = Instance.new("Frame")
    settingsContent.Size = UDim2.new(1, 0, 1, 0)
    settingsContent.BackgroundTransparency = 1
    settingsContent.Visible = false
    settingsContent.Parent = contentFrame

    -- Help Tab Content
    local helpContent = Instance.new("Frame")
    helpContent.Size = UDim2.new(1, 0, 1, 0)
    helpContent.BackgroundTransparency = 1
    helpContent.Visible = false
    helpContent.Parent = contentFrame

    -- Tab switching functionality
    local function showTab(tab)
        loggerContent.Visible = (tab == "logger")
        settingsContent.Visible = (tab == "settings")
        helpContent.Visible = (tab == "help")
    end

    loggerTab.MouseButton1Click:Connect(function() showTab("logger") end)
    settingsTab.MouseButton1Click:Connect(function() showTab("settings") end)
    helpTab.MouseButton1Click:Connect(function() showTab("help") end)

    Delta.UI.ActiveFrames.Main = mainFrame
    return mainFrame
end

-- Initialize
local loadingScreen = Delta.UI.ShowLoadingScreen()
task.delay(3, function()
    loadingScreen.PulseTween:Cancel()
    loadingScreen.Frame:Destroy()
    Delta.UI.ShowMainDashboard()
end)

return Delta
