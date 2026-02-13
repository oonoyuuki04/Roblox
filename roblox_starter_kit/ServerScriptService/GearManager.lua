--[[
    Service: GearManager
    Purpose: Adds tools (Gear) like Speed Coil and Gravity Coil to players.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PurchaseGear = Instance.new("RemoteFunction")
PurchaseGear.Name = "BuyGear"
PurchaseGear.Parent = ReplicatedStorage

local GEARS = {
    Speed = {
        Cost = 500,
        Effect = function(player)
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 32 -- Double speed
            end
        end,
        ModelName = "SpeedCoil" -- In a real game, clone from ReplicatedStorage
    },
    Jump = {
        Cost = 1000,
        Effect = function(player)
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = 100 -- Double jump power
            end
        end,
        ModelName = "GravityCoil"
    }
}

PurchaseGear.OnServerInvoke = function(player, gearName)
    local gear = GEARS[gearName]
    if not gear then return false, "Invalid Gear" end

    local ls = player:FindFirstChild("leaderstats")
    if not ls or ls.Money.Value < gear.Cost then return false, "Too Expensive" end

    ls.Money.Value = ls.Money.Value - gear.Cost
    gear.Effect(player)
    
    -- Give physical tool if available
    -- local tool = ReplicatedStorage:FindFirstChild(gear.ModelName):Clone()
    -- tool.Parent = player.Backpack
    
    return true, "Equipped " .. gearName
end
