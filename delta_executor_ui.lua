-- Delta Executor UI Module (Enhanced Version)
local DeltaUI = {}

-- Core Services
local TweenService = game:GetService("TweenService")

-- UI Framework
DeltaUI.MainGui = Instance.new("ScreenGui")
DeltaUI.MainGui.Name = "DeltaExecutor"
DeltaUI.MainGui.ResetOnSpawn = false
DeltaUI.MainGui.Parent = game:GetService("CoreGui")

-- Main Dashboard
function DeltaUI.ShowMainDashboard()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    mainFrame.Parent = DeltaUI.MainGui

    -- Webhook Configuration
    local webhookFrame = Instance.new("Frame")
    webhookFrame.Size = UDim2.new(0.8, 0, 0.3, 0)
    webhookFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    webhookFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    webhookFrame.Parent = mainFrame

    local webhookInput = Instance.new("TextBox")
    webhookInput.PlaceholderText = "Enter Discord Webhook URL"
    webhookInput.Size = UDim2.new(0.8, 0, 0.3, 0)
    webhookInput.Position = UDim2.new(0.1, 0, 0.2, 0)
    webhookInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
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
            print("Webhook URL entered: " .. webhookInput.Text)
        else
            warn("No webhook URL entered!")
        end
    end)

    return mainFrame
end

return DeltaUI
