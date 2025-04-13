-- Delta Mobile Executor Pro 
local Delta = {
    _VERSION = "7.0",
    _AUTHOR = "DeepScriptAI",
    _LICENSE = "PRIVATE - USE AT YOUR OWN RISK"
}

-- Services and configuration (previous code remains)

-- Enhanced Network Interception with Complete Implementation
Delta.Network = {
    BlockOutgoing = false,
    BlockIncoming = false,
    OriginalSend = nil,
    OriginalReceive = nil,
    Hooked = false
}

-- Hook network functions with error handling
function Delta.HookNetwork()
    if not Delta.Network.Hooked then
        local success, err = pcall(function()
            Delta.Network.OriginalSend = hookfunction(originalSendFunction, function(data)
                if Delta.Network.BlockOutgoing then
                    return nil -- Block outgoing data
                end
                return Delta.Network.OriginalSend(data)
            end)
            
            Delta.Network.OriginalReceive = hookfunction(originalReceiveFunction, function(data)
                if Delta.Network.BlockIncoming then
                    return nil -- Block incoming data
                end
                return Delta.Network.OriginalReceive(data)
            end)
            Delta.Network.Hooked = true
        end)
        
        if not success then
            warn("Network hook failed: "..tostring(err))
        end
    end
end

function Delta.ToggleOutgoingBlock()
    Delta.Network.BlockOutgoing = not Delta.Network.BlockOutgoing
    Delta.UI.UpdateButtonStates()
    return Delta.Network.BlockOutgoing
end

function Delta.ToggleIncomingBlock()
    Delta.Network.BlockIncoming = not Delta.Network.BlockIncoming
    Delta.UI.UpdateButtonStates()
    return Delta.Network.BlockIncoming
end

-- Complete Manual Send Implementation
function Delta.ManualSend(data)
    if type(data) ~= "string" then
        return false, "Invalid data type"
    end
    
    if Delta.Network.OriginalSend then
        local success, result = pcall(function()
            return Delta.Network.OriginalSend(data)
        end)
        return success, result
    else
        -- Fallback direct send implementation
        return pcall(function()
            return game:GetService("HttpService"):PostAsync(
                Delta.Config.Webhook,
                data
            )
        end)
    end
end

-- Enhanced UI with Complete Security Controls
function Delta.UI.AddSecurityControls(parentFrame)
    local securityFrame = Instance.new("Frame")
    securityFrame.Size = UDim2.new(0.9, 0, 0.2, 0)
    securityFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
    securityFrame.BackgroundTransparency = 1
    securityFrame.Parent = parentFrame

    -- Block Outgoing Button
    local blockOutBtn = Instance.new("TextButton")
    blockOutBtn.Name = "BlockOutgoingBtn"
    blockOutBtn.Text = "BLOCK OUTGOING"
    blockOutBtn.Size = UDim2.new(0.45, 0, 0.9, 0)
    blockOutBtn.Position = UDim2.new(0, 0, 0, 0)
    blockOutBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    blockOutBtn.TextColor3 = Color3.fromRGB(255,255,255)
    blockOutBtn.TextScaled = true
    blockOutBtn.Parent = securityFrame

    -- Block Incoming Button
    local blockInBtn = Instance.new("TextButton")
    blockInBtn.Name = "BlockIncomingBtn"
    blockInBtn.Text = "BLOCK INCOMING"
    blockInBtn.Size = UDim2.new(0.45, 0, 0.9, 0)
    blockInBtn.Position = UDim2.new(0.5, 0, 0, 0)
    blockInBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    blockInBtn.TextColor3 = Color3.fromRGB(255,255,255)
    blockInBtn.TextScaled = true
    blockInBtn.Parent = securityFrame

    -- Button functionality
    blockOutBtn.MouseButton1Click:Connect(function()
        Delta.ToggleOutgoingBlock()
    end)

    blockInBtn.MouseButton1Click:Connect(function()
        Delta.ToggleIncomingBlock()
    end)

    Delta.UI.SecurityControls = {
        OutButton = blockOutBtn,
        InButton = blockInBtn
    }
end

function Delta.UI.UpdateButtonStates()
    if Delta.UI.SecurityControls then
        local outState = Delta.Network.BlockOutgoing
        Delta.UI.SecurityControls.OutButton.Text = outState and "ALLOW OUTGOING" or "BLOCK OUTGOING"
        Delta.UI.SecurityControls.OutButton.BackgroundColor3 = outState and Color3.fromRGB(255,50,50) or Color3.fromRGB(0,170,255)
        
        local inState = Delta.Network.BlockIncoming
        Delta.UI.SecurityControls.InButton.Text = inState and "ALLOW INCOMING" or "BLOCK INCOMING"
        Delta.UI.SecurityControls.InButton.BackgroundColor3 = inState and Color3.fromRGB(255,50,50) or Color3.fromRGB(0,170,255)
    end
end

-- Verify and correct all UI positions
function Delta.UI.VerifyAllPositions()
    if not Delta.UI.SecurityControls then return end
    
    local expectedPositions = {
        [Delta.UI.SecurityControls.OutButton] = UDim2.new(0, 0, 0, 0),
        [Delta.UI.SecurityControls.InButton] = UDim2.new(0.5, 0, 0, 0)
    }

    for element, expectedPos in pairs(expectedPositions) do
        if element and element.Position ~= expectedPos then
            element.Position = expectedPos
        end
    end
end

-- Initialize with all features
local loadingScreen = Delta.UI.ShowLoadingScreen()
task.delay(3, function()
    loadingScreen.PulseTween:Cancel()
    loadingScreen.Frame:Destroy()
    local dashboard = Delta.UI.ShowMainDashboard()
    Delta.UI.AddManualSendFeature(dashboard)
    Delta.UI.AddSecurityControls(dashboard)
    Delta.UI.VerifyAllPositions() -- Ensures proper GUI alignment
end)

return Delta
