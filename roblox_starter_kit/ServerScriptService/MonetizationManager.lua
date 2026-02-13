--[[
    Service: MonetizationManager
    Purpose: Handles Developer Products (Coins) and GamePasses (VIP).
    Location: ServerScriptService
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- Configuration: Replace these IDs with your actual Roblox IDs
local PRODUCTS = {
    COINS_100 = 12345678, -- Replace with Developer Product ID
    VIP_PASS = 87654321,   -- Replace with Game Pass ID
    PREMIUM_BONUS = 50     -- Extra coins for Premium players
}

-- Product Handler Functions
local productFunctions = {}

-- Function to handle buying 100 Coins
productFunctions[PRODUCTS.COINS_100] = function(receipt, player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local money = leaderstats:FindFirstChild("Money")
        if money then
            money.Value = money.Value + 100
            print(player.Name .. " bought 100 Coins!")
            return true -- Success
        end
    end
    return false -- Failed
end

-- Process Receipt Standard Structure
MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    
    if not player then
        -- Player left before purchase completed. Don't charge them yet.
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local productId = receiptInfo.ProductId
    local handler = productFunctions[productId]

    if handler then
        -- Execute the product logic securely
        local success, result = pcall(handler, receiptInfo, player)
        if success and result then
            -- Purchase successful!
            return Enum.ProductPurchaseDecision.PurchaseGranted
        else
            warn("Failed to process purchase for " .. player.Name)
        end
    else
        warn("No handler found for product ID: " .. productId)
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- VIP Check (Example function to be called by other scripts)
local function checkVIP(player)
    local hasPass = false
    local success, message = pcall(function()
        hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, PRODUCTS.VIP_PASS)
    end)
    
    if not success then
        warn("Error checking VIP pass: " .. tostring(message))
        return false
    end
    
    return hasPass
end

-- Bonus for Premium Players (Premium Payouts logic helper)
Players.PlayerAdded:Connect(function(player)
    if player.MembershipType == Enum.MembershipType.Premium then
        print(player.Name .. " is a Premium member! Giving welcome bonus.")
        -- Example: Give a small amount of currency or a chat tag
        local leaderstats = player:WaitForChild("leaderstats", 10)
        if leaderstats then
             local money = leaderstats:FindFirstChild("Money")
             if money then
                 money.Value = money.Value + PRODUCTS.PREMIUM_BONUS
             end
        end
    end
end)

return {
    CheckVIP = checkVIP,
    ProductIds = PRODUCTS
}
