--[[
    KillBlock.server.lua
    配置場所: 即死させたいパーツの中（Partの子要素として配置）
    機能: 触れたプレイヤーをキルする
]]

local trapPart = script.Parent

local function onTouch(hit)
    -- 触れたオブジェクトの親からHumanoidを探す
    local character = hit.Parent
    local humanoid = character:FindFirstChild("Humanoid")

    if humanoid then
        -- HPを0にする
        humanoid.Health = 0
    end
end

-- タッチイベントを接続
trapPart.Touched:Connect(onTouch)
