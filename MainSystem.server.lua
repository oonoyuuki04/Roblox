--[[
    MainSystem.server.lua
    配置場所: ServerScriptService
    機能: 
    1. プレイヤーの入室検知
    2. リーダーボード（ステージ数）の作成
    3. データのセーブ＆ロード（DataStore）
    4. ステージに応じたリスポーン処理
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- データストアの名前（開発中は変更してデータをリセットできます）
local DATA_STORE_KEY = "ObbyData_v1"
local myDataStore = DataStoreService:GetDataStore(DATA_STORE_KEY)

-- プレイヤーが参加したときの処理
Players.PlayerAdded:Connect(function(player)
    -- 1. leaderstats（画面右上のボード）を作成
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local stage = Instance.new("IntValue")
    stage.Name = "Stage"
    stage.Value = 1 -- デフォルトはステージ1
    stage.Parent = leaderstats

    -- 2. データのロード
    local success, savedStage = pcall(function()
        return myDataStore:GetAsync(player.UserId)
    end)

    if success and savedStage then
        stage.Value = savedStage
        print(player.Name .. " のデータをロードしました: ステージ " .. savedStage)
    else
        print("新規プレイヤー、またはデータロード失敗")
    end

    -- 3. キャラクターがスポーンしたときの処理（チェックポイントへ移動）
    player.CharacterAdded:Connect(function(character)
        -- 少し待ってから移動（確実にロードさせるため）
        task.wait(0.5) 
        
        local currentStage = stage.Value
        -- Workspace内の "Checkpoints" フォルダを探す
        local checkpoints = workspace:FindFirstChild("Checkpoints")
        
        if checkpoints then
            -- 現在のステージ番号に対応するパーツを探す（例: "1", "2", "3" という名前のパーツ）
            local checkpointPart = checkpoints:FindFirstChild(tostring(currentStage))
            
            if checkpointPart then
                -- キャラクターをチェックポイントの上に移動
                character:PivotTo(checkpointPart.CFrame + Vector3.new(0, 3, 0))
            end
        end
    end)
end)

-- プレイヤーが退出したときの処理（セーブ）
Players.PlayerRemoving:Connect(function(player)
    local success, err = pcall(function()
        myDataStore:SetAsync(player.UserId, player.leaderstats.Stage.Value)
    end)

    if success then
        print(player.Name .. " のデータをセーブしました")
    else
        warn("セーブ失敗: " .. err)
    end
end)
