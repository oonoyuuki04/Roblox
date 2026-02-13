--[[
    Service: MonetizationManager (Unified)
    Purpose: Handles Developer Products (Gold) and GamePasses (VIP/Warlord Passes).
    Location: ServerScriptService
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local PRODUCTS = {
    GOLD_1000 = 12345678, -- "War Chest"
    GOLD_5000 = 87654321, -- "Imperial Tribute"
    VIP_PASS  = 11223344, -- "Warlord VIP"
}

local productFunctions = {}

productFunctions[PRODUCTS.GOLD_1000] = function(receipt, player)
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        ls.Money.Value = ls.Money.Value + 1000
        return true
    end
end

MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

    local handler = productFunctions[receiptInfo.ProductId]
    if handler then
        local success, result = pcall(handler, receiptInfo, player)
        if success then return Enum.ProductPurchaseDecision.PurchaseGranted end
    end
    return Enum.ProductPurchaseDecision.NotProcessedYet
end

return {
    ProductIds = PRODUCTS
}
