--[[
    ShopGuiManager.client.lua
    配置場所: StarterGui 内の ScreenGui -> LocalScript
    機能: 画面上のボタンを押して課金画面を出す
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ServerScriptと同じIDを設定する必要があります
local PRODUCT_ID_SKIP = 11111111 

-- 親要素のボタン（例: ImageButton や TextButton）を取得
local skipButton = script.Parent

skipButton.MouseButton1Click:Connect(function()
    -- 課金プロンプトを表示
    MarketplaceService:PromptProductPurchase(player, PRODUCT_ID_SKIP)
end)
