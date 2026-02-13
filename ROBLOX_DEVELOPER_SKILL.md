# Roblox Development Skills & Best Practices

This document compiles "skills" and best practices for high-level Roblox development, optimized for AI assistance.

## 1. Code Standards (Luau)

*   **Strict Typing:** Always use `--!strict` at the top of scripts when possible.
*   **Services:** Fetch services at the top level using `game:GetService("ServiceName")`.
*   **Async Logic:** Use `task.wait()`, `task.spawn()`, `task.delay()` instead of global `wait()`, `spawn()`, `delay()`.
*   **Events:** Always disconnect events when objects are destroyed to prevent memory leaks. Use `Janitor` or `Maid` patterns if available.

### Example: Robust Hit Detection
```lua
-- Bad
script.Parent.Touched:Connect(function(hit) ... end)

-- Good (with Debounce and Validation)
local DEBOUNCE_TIME = 0.5
local lastTouch = 0

part.Touched:Connect(function(hit)
    local now = os.clock()
    if now - lastTouch < DEBOUNCE_TIME then return end
    lastTouch = now

    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health > 0 then
        -- Logic here
    end
end)
```

## 2. Monetization Patterns (The "Money Maker" Skill)

### Developer Products (Consumables)
*   **Usage:** Skip Stage, Revive, Temporary Boosts.
*   **Handling:** Must use `ProcessReceipt`. Ensure idempotency (don't grant twice for the same receipt ID).

### Game Passes (Perpetual)
*   **Usage:** VIP access, Special Items, 2x XP.
*   **Handling:** Check `MarketplaceService:UserOwnsGamePassAsync` on player join and character spawn. Cache the result to avoid API limits.

## 3. Data Persistence (ProfileService Pattern)

*   **Never** use raw `DataStore:SetAsync` without pcall and retry logic.
*   **Session Locking:** Prevent data corruption if a player joins another server before the first one checks out.
*   **Structure:**
    ```lua
    local ProfileTemplate = {
        Stage = 1,
        Coins = 0,
        Inventory = {},
        LoginTimes = 0
    }
    ```

## 4. UI Design (Roact/Fusion Style)

*   **State Management:** Don't manipulate UI properties directly (`Gui.Text = "..."`) in complex apps. Use a state-based approach or at least a centralized generic function updates the view.
*   **Scaling:** Always use `Scale` (0-1) for positions/sizes, not `Offset` (pixels), to support mobile/console.
*   **Aspect Ratio:** Use `UIAspectRatioConstraint` to keep buttons square or specific shapes on all screens.
