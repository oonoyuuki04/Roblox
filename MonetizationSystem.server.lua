--[[
    MonetizationSystem.server.lua
    配置場所: ServerScriptService
    機能: 
    1. GamePass（永続アイテム）の購入処理
    2. DeveloperProduct（消費アイテム）の購入処理
    3. UIへの通知
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- ID設定（Roblox Webサイトで作成したIDを入れてください）
-- ※テスト時はダミーIDでも動作確認できる場合がありますが、基本は本番IDが必要です
local GAME_PASS_IDS = {
    VIP = 12345678,        -- VIPルーム入場、特別なタグなど
    SKIP_STAGE = 87654321, -- 特定のステージをスキップ（実装によりますが、今回はDevProductの方が適していることが多い）
}

local DEV_PRODUCT_IDS = {
    SKIP_ONE_STAGE = 11111111, -- 1ステージスキップ（消費型）
    REVIVE = 22222222,         -- その場で復活
}

-- GamePass購入完了時の処理
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, wasPurchased)
    if wasPurchased then
        if passId == GAME_PASS_IDS.VIP then
            print(player.Name .. " がVIPになりました！")
            -- VIP特典の付与（例：頭上にUIを表示、VIPエリアへのアクセス許可など）
            -- ここに処理を追加
        end
    end
end)

-- DeveloperProduct（消費型）の購入処理
MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        -- プレイヤーがすでにいない場合、未処理としてマーク（次回ログイン時に再試行される）
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    if receiptInfo.ProductId == DEV_PRODUCT_IDS.SKIP_ONE_STAGE then
        print(player.Name .. " がステージスキップを購入しました")
        
        -- ステージを進める処理
        local leaderstats = player:FindFirstChild("leaderstats")
        local stage = leaderstats and leaderstats:FindFirstChild("Stage")
        
        if stage then
            stage.Value = stage.Value + 1
            player:LoadCharacter() -- リスポーンさせて新しいステージへ
        end
        
        return Enum.ProductPurchaseDecision.PurchaseGranted

    elseif receiptInfo.ProductId == DEV_PRODUCT_IDS.REVIVE then
        print(player.Name .. " が復活を購入しました")
        -- 復活処理（本来は死んだ瞬間のGuiから呼ばれる）
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end
