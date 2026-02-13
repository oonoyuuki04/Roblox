--[[
    Service: ClickerManager
    Purpose: Handles manual click income via RemoteEvent.
    Location: ServerScriptService
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CLICK_AMOUNT = 1 -- Base money per click
local MAX_CLICKS_PS = 10 -- Anti-autoclicker limit

local lastClickTime = {}

local ClickEvent = Instance.new("RemoteEvent")
ClickEvent.Name = "ClickForMoney"
ClickEvent.Parent = ReplicatedStorage

ClickEvent.OnServerEvent:Connect(function(player)
    local now = tick()
    lastClickTime[player.UserId] = lastClickTime[player.UserId] or 0

    if (now - lastClickTime[player.UserId]) < (1/MAX_CLICKS_PS) then
        return -- Too fast
    end
    lastClickTime[player.UserId] = now

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        leaderstats.Money.Value = leaderstats.Money.Value + CLICK_AMOUNT
    end
end)
