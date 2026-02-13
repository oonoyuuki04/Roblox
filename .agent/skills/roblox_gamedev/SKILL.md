---
name: Roblox Game Development
description: Expert guidance on building and monetizing Roblox games using Luau.
---
# Roblox Game Development Skill

This skill provides comprehensive capabilities for building, scripting, and monetizing games on the Roblox platform.

## Core Capabilities

### 1. Scripting (Luau)
- **Best Practices**: Strictly adhere to Roblox coding standards. Use `PascalCase` for services/methods and `camelCase` for variables.
- **Performance**: Avoid memory leaks (disconnect events), use `task.wait()` over `wait()`, and cache frequently accessed services.
- **Architecture**: Separate Server (Security) and Client (UX) logic. Use RemoteEvents for communication.

### 2. Monetization Implementation
- **Developer Products**:
  - Use `MarketplaceService:ProcessReceipt` for consumable purchases (gold, health).
  - Implement robust data saving to ensure purchases are not lost.
- **Game Passes**:
  - Use `MarketplaceService:UserOwnsGamePassAsync` to check ownership.
  - Apply benefits immediately upon player join or purchase success.
- **Premium Payouts**:
  - Design engaging gameplay loops to maximize playtime for Premium users.

### 3. Data Persistence
- Use `DataStoreService` for saving player data.
- **Pattern**:
  - Wrap `GetAsync` and `SetAsync` in `pcall` (protected call) to handle failures.
  - Use `UpdateAsync` for safer write operations.
  - Implement auto-saving loops (e.g., every 60 seconds) and save on `PlayerRemoving`.

### 4. UI Development
- Create responsive GUIs using `Scale` instead of `Offset` for positioning and sizing.
- Use `UIListLayout`, `UIGridLayout`, and adding padding for clean layouts.

## Example: Secure Monetization Handler

```lua
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local productFunctions = {}

-- Handler for purchase processing
MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local handler = productFunctions[receiptInfo.ProductId]
    if handler then
        local success, result = pcall(handler, receiptInfo, player)
        if success then
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end
```

## When to Use This Skill
- Whenever the user asks to "build a feature".
- When implementing any purchase logic.
- When designing game systems (leaderstats, inventory).
