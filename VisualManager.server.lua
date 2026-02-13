--[[
    VisualManager.server.lua
    配置場所: ServerScriptService
    機能: プレイヤーの色を変えたり、豪華なエフェクト用
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- 1. トレイル（軌跡）をつける（課金アイテムとしても使える）
        local trail = Instance.new("Trail")
        trail.Parent = humanoidRootPart
        
        local att0 = Instance.new("Attachment", humanoidRootPart)
        att0.Position = Vector3.new(0, 1, 0)
        local att1 = Instance.new("Attachment", humanoidRootPart)
        att1.Position = Vector3.new(0, -1, 0)
        
        trail.Attachment0 = att0
        trail.Attachment1 = att1
        trail.Lifetime = 0.5
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 170, 0), Color3.fromRGB(255, 0, 0)) -- オレンジから赤へ
        trail.Enabled = true
        
        -- 2. 歩くたびにパーティクルを出すなど、リッチな演出が可能
    end)
end)
