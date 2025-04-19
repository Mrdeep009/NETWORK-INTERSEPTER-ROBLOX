-- Delta Executor Core (Enhanced Version)
local Delta = {
    _VERSION = "2.1",
    _AUTHOR = "Delta Team",
    _LICENSE = "PRIVATE"
}

-- Main GUI Container
Delta.UI = {
    MainGui = Instance.new("ScreenGui"),
    CurrentTheme = {
        Background = Color3.fromRGB(20, 20, 30),
        Primary = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

Delta.UI.MainGui.Name = "DeltaExecutor"
Delta.UI.MainGui.ResetOnSpawn = false
Delta.UI.MainGui.Parent = game:GetService("CoreGui")

-- Create a unified Loading Screen for the Executor
function Delta.UI.ShowLoadingScreen()
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Delta.UI.CurrentTheme.Background
    loadingFrame.Parent = Delta.UI.MainGui

    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Text = "DELTA EXECUTOR INITIALIZING..."
    loadingLabel.TextColor3 = Delta.UI.CurrentTheme.Text
    loadingLabel.Size = UDim2.new(1, 0, 0.1, 0)
    loadingLabel.Position = UDim2.new(0, 0, 0.45, 0)
    loadingLabel.Parent = loadingFrame

    -- Simple loading animation
    local tweenService = game:GetService("TweenService")
    local tween = tweenService:Create(
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

return Delta
