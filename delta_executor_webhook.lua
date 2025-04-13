-- Delta Executor Webhook Module
local DeltaWebhook = {}

-- Services
local HttpService = game:GetService("HttpService")

-- Configuration
DeltaWebhook.Config = {
    WebhookURL = "",
    RateLimit = 5, -- seconds between requests
    LastRequest = 0
}

-- Validate webhook URL
function DeltaWebhook.ValidateURL(url)
    return type(url) == "string" and #url > 0 and string.find(url, "discord.com/api/webhooks")
end

-- Send data to webhook
function DeltaWebhook.Send(data)
    if not DeltaWebhook.ValidateURL(DeltaWebhook.Config.WebhookURL) then
        return false, "Invalid webhook URL"
    end

    -- Rate limiting check
    local now = os.time()
    if now - DeltaWebhook.Config.LastRequest < DeltaWebhook.Config.RateLimit then
        return false, "Rate limited"
    end

    -- Prepare payload
    local payload = {
        content = data,
        username = "Delta Executor",
        avatar_url = "https://i.imgur.com/xxxxxxx.png"
    }

    -- Send request
    local success, response = pcall(function()
        return HttpService:PostAsync(
            DeltaWebhook.Config.WebhookURL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson
        )
    end)

    if success then
        DeltaWebhook.Config.LastRequest = now
        return true
    else
        return false, response
    end
end

return DeltaWebhook
