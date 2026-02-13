--[[
    LocalScript: ShopClient
    Purpose: Handles UI buttons for buying Coins and VIP.
    Location: StarterGui > ShopGUI > ShopFrame > LocalScript
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local screenGui = script.Parent.Parent -- Adjust based on your hierarchy
local buyCoinsButton = script.Parent:WaitForChild("BuyCoinsButton") -- Ensure button exists
local buyVIPButton = script.Parent:WaitForChild("BuyVIPButton") -- Ensure button exists

-- IDs (Must match Server config)
local COIN_PRODUCT_ID = 12345678
local VIP_GAMEPASS_ID = 87654321

-- Button: Buy 100 Coins
buyCoinsButton.MouseButton1Click:Connect(function()
    print("Prompting Coin Purchase...")
    MarketplaceService:PromptProductPurchase(player, COIN_PRODUCT_ID)
end)

-- Button: Buy VIP
buyVIPButton.MouseButton1Click:Connect(function()
    print("Prompting VIP Purchase...")
    MarketplaceService:PromptGamePassPurchase(player, VIP_GAMEPASS_ID)
end)

-- Optional: Listen for purchase completion to update UI instantly (though data updates usually replicate)
MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)
    if userId == player.UserId and isPurchased then
        print("Thanks for buying!")
        -- You could play a sound or show a confetti effect here
    end
end)
