--[[
    Checkpoint.server.lua
    配置場所: チェックポイントのパーツの中（Partの子要素として配置）
    機能: 触れるとステージを進める
]]

local checkpointPart = script.Parent

-- パーツの名前をステージ番号にする必要があります（例: "1", "2", "3"...）
local stageNumber = tonumber(checkpointPart.Name)

local function onTouch(hit)
    local character = hit.Parent
    local player = game.Players:GetPlayerFromCharacter(character)

    if player then
        local leaderstats = player:FindFirstChild("leaderstats")
        local stageStat = leaderstats and leaderstats:FindFirstChild("Stage")

        if stageStat then
            -- プレイヤーの現在のステージより1つ大きい場合のみ更新
            -- （つまり、ステージ1の人がステージ2に触れたら更新。ステージ5の人がステージ2に触れても戻らない）
            if stageStat.Value == (stageNumber - 1) then
                stageStat.Value = stageNumber
                
                -- 音を鳴らすなどの演出を入れるならここ
                print(player.Name .. " がステージ " .. stageNumber .. " に到達！")
            end
        end
    end
end

checkpointPart.Touched:Connect(onTouch)
