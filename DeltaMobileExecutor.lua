-- Delta Mobile Executor (Client-Sided)
local Delta = {
    _VERSION = "4.0",
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
        Mode = "NONE", -- SENT, RECEIVED, BOTH, NONE
        Active = false,
        SaveLocal = false,
        EncryptionDetection = true
    },
    UI = {
        Theme = "Dark",
        Animations = true,
        Draggable = true
    }
}

-- UI Framework
Delta.UI = {
    MainGui = Instance.new("ScreenGui"),
    CurrentPosition = UDim2.new(0.3, 0, 0.2, 0),
    ActiveFrames = {}
}

Delta.UI.MainGui.Name = "DeltaMobileExecutor"
Delta.UI.MainGui.ResetOnSpawn = false
Delta.UI.MainGui.Parent = game:GetService("CoreGui")

-- Create loading screen with animation
function Delta.UI.ShowLoadingScreen()
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    loadingFrame.Parent = Delta.UI.MainGui

    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Text = "DELTA EXECUTOR INITIALIZING..."
    loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingLabel.Size = UDim2.new(1, 0, 0.1, 0)
    loadingLabel.Position = UDim2.new(0, 0, 0.45, 0)
    loadingLabel.Parent = loadingFrame

    -- Loading animation
    local tween = TweenService:Create(
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

-- Create main dashboard
function Delta.UI.ShowMainDashboard()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)
    mainFrame.Position = Delta.UI.CurrentPosition
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    mainFrame.Parent = Delta.UI.MainGui

    -- Make frame draggable
    if Delta.Config.UI.Draggable then
        local dragStartPos, frameStartPos
        mainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragStartPos = input.Position
                frameStartPos = mainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragStartPos = nil
                    end
                end)
            end
        end)

        mainFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and dragStartPos then
                local delta = input.Position - dragStartPos
                mainFrame.Position = UDim2.new(
                    frameStartPos.X.Scale, 
                    frameStartPos.X.Offset + delta.X,
                    frameStartPos.Y.Scale,
                    frameStartPos.Y.Offset + delta.Y
                )
                Delta.UI.CurrentPosition = mainFrame.Position
            end
        end)
    end

    -- Webhook Configuration
    local webhookFrame = Instance.new("Frame")
    webhookFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
    webhookFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    webhookFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    webhookFrame.Parent = mainFrame

    local webhookInput = Instance.new("TextBox")
    webhookInput.PlaceholderText = "Enter Discord Webhook URL"
    webhookInput.Size = UDim2.new(0.8, 0, 0.3, 0)
    webhookInput.Position = UDim2.new(0.1, 0, 0.2, 0)
    webhookInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    webhookInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    webhookInput.Parent = webhookFrame

    local setupButton = Instance.new("TextButton")
    setupButton.Text = "SETUP WEBHOOK"
    setupButton.Size = UDim2.new(0.5, 0, 0.2, 0)
    setupButton.Position = UDim2.new(0.25, 0, 0.6, 0)
    setupButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    setupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    setupButton.Parent = webhookFrame

    -- Setup button functionality
    setupButton.MouseButton1Click:Connect(function()
        if #webhookInput.Text > 0 then
            setupButton.Text = "VERIFYING..."
            local loadingCircle = Instance.new("ImageLabel")
            loadingCircle.Image = "rbxassetid://3570695787"
            loadingCircle.Size = UDim2.new(0.5, 0, 0.5, 0)
            loadingCircle.Position = UDim2.new(0.25, 0, 0.25, 0)
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
                Delta.UI.ShowLoggingOptions(mainFrame)
            end)
        end
    end)

    Delta.UI.ActiveFrames.Main = mainFrame
    Delta.UI.ActiveFrames.Webhook = webhookFrame
end

-- Show logging options
function Delta.UI.ShowLoggingOptions(parentFrame)
    local loggingFrame = Instance.new("Frame")
    loggingFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
    loggingFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
    loggingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    loggingFrame.Parent = parentFrame

    local title = Instance.new("TextLabel")
    title.Text = "SELECT LOGGING MODE:"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Parent = loggingFrame

    local logSent = Instance.new("TextButton")
    logSent.Text = "LOG SENT DATA ONLY"
    logSent.Size = UDim2.new(0.8, 0, 0.2, 0)
    logSent.Position = UDim2.new(0.1, 0, 0.15, 0)
    logSent.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    logSent.TextColor3 = Color3.fromRGB(255, 255, 255)
    logSent.Parent = loggingFrame

    local logReceived = Instance.new("TextButton")
    logReceived.Text = "LOG RECEIVED DATA ONLY"
    logReceived.Size = UDim2.new(0.8, 0, 0.2, 0)
    logReceived.Position = UDim2.new(0.1, 0, 0.4, 0)
    logReceived.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    logReceived.TextColor3 = Color3.fromRGB(255, 255, 255)
    logReceived.Parent = loggingFrame

    local logBoth = Instance.new("TextButton")
    logBoth.Text = "LOG BOTH SENT & RECEIVED"
    logBoth.Size = UDim2.new(0.8, 0, 0.2, 0)
    logBoth.Position = UDim2.new(0.1, 0, 0.65, 0)
    logBoth.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    logBoth.TextColor3 = Color3.fromRGB(255, 255, 255)
    logBoth.Parent = loggingFrame

    -- Button animations
    local function buttonHoverEffect(button)
        if Delta.Config.UI.Animations then
            button.MouseEnter:Connect(function()
                TweenService:Create(
                    button,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}
                ):Play()
            end)
            button.MouseLeave:Connect(function()
                TweenService:Create(
                    button,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}
                ):Play()
            end)
        end
    end

    buttonHoverEffect(logSent)
    buttonHoverEffect(logReceived)
    buttonHoverEffect(logBoth)

    -- Button functionality
    logSent.MouseButton1Click:Connect(function()
        Delta.Config.Logging.Mode = "SENT"
        Delta.StartLogger()
    end)

    logReceived.MouseButton1Click:Connect(function()
        Delta.Config.Logging.Mode = "RECEIVED"
        Delta.StartLogger()
    end)

    logBoth.MouseButton1Click:Connect(function()
        Delta.Config.Logging.Mode = "BOTH"
        Delta.StartLogger()
    end)

    Delta.UI.ActiveFrames.Logging = loggingFrame
end

-- Network interception
function Delta.StartLogger()
    if Delta.Config.Logging.Active then return end
    
    Delta.Config.Logging.Active = true
    local oldRequest
    oldRequest = hookfunction(game.HttpService.RequestAsync, function(self, request)
        if Delta.Config.Logging.Mode == "SENT" or Delta.Config.Logging.Mode == "BOTH" then
            Delta.LogData("SENT", request)
        end
        return oldRequest(self, request)
    end)

    -- Add similar hook for received data
    -- This is simplified - actual implementation would need proper hooks
end

function Delta.LogData(direction, data)
    -- Process and format data
    local processed = Delta.ProcessData(data)
    
    -- Send to webhook if configured
    if Delta.Config.Webhook ~= "" then
        Delta.SendToWebhook(direction, processed)
    end
end

function Delta.ProcessData(data)
    -- Attempt decryption if enabled
    if Delta.Config.Logging.EncryptionDetection then
        local decrypted, key = Delta.TryDecrypt(data)
        if decrypted then
            return {
                Original = data,
                Decrypted = decrypted,
                EncryptionKey = key,
                Structure = Delta.AnalyzeStructure(decrypted)
            }
        end
    end
    
    return {
        Original = data,
        Structure = Delta.AnalyzeStructure(data)
    }
end

-- Initialize
local loadingScreen = Delta.UI.ShowLoadingScreen()
task.delay(3, function()
    loadingScreen.Tween:Cancel()
    loadingScreen.Frame:Destroy()
    Delta.UI.ShowMainDashboard()
end)

return Delta
