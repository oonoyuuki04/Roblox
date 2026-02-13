--[[
    Service: TycoonManager
    Purpose: Handles purchase of droppers and income generation.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")

-- Configuration
local INCOME_INTERVAL = 2 -- Seconds per payout
local BASE_INCOME = 1 -- Default Money per tick
local DROPPER_MULTIPLIER = 5 -- How much extra income per dropper

-- Data Structure for Droppers
local Droppers = {
    { Name = "Tier 1 Dropper", Cost = 50,  Income = 5,  ModelColor = Color3.fromRGB(255, 100, 100) },
    { Name = "Tier 2 Dropper", Cost = 150, Income = 10, ModelColor = Color3.fromRGB(100, 255, 100) },
    { Name = "Tier 3 Dropper", Cost = 500, Income = 25, ModelColor = Color3.fromRGB(100, 100, 255) },
    { Name = "OMEGA Dropper",  Cost = 2000, Income = 100, ModelColor = Color3.fromRGB(255, 215, 0) },
}

-- Store player owned droppers in memory (should save to DataStore ideally)
local playerTycoons = {}

local function createTycoonButton(player, dropperData, index)
    -- This function would normally create a physical button in the workspace.
    -- For simplicity, we handle logic here.
    return true
end

-- Purchase Logic (Called via RemoteFunction)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PurchaseEvent = Instance.new("RemoteFunction")
PurchaseEvent.Name = "PurchaseTycoonItem"
PurchaseEvent.Parent = ReplicatedStorage

PurchaseEvent.OnServerInvoke = function(player, itemIndex)
    local dropper = Droppers[itemIndex]
    if not dropper then return false, "Invalid Item" end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return false, "No Data" end
    
    local money = leaderstats.Money
    
    -- Check if already owned
    playerTycoons[player.UserId] = playerTycoons[player.UserId] or {}
    if playerTycoons[player.UserId][itemIndex] then
        return false, "Already Owned"
    end

    if money.Value >= dropper.Cost then
        money.Value = money.Value - dropper.Cost
        playerTycoons[player.UserId][itemIndex] = true
        return true, "Purchased " .. dropper.Name
    else
        return false, "Not enough Money"
    end
end

-- Income Loop
task.spawn(function()
    while true do
        task.wait(INCOME_INTERVAL)
        for _, player in ipairs(Players:GetPlayers()) do
            local income = BASE_INCOME
            local owned = playerTycoons[player.UserId] or {}
            
            for index, isOwned in pairs(owned) do
                if isOwned then
                    income = income + Droppers[index].Income
                end
            end
            
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                leaderstats.Money.Value = leaderstats.Money.Value + income
            end
        end
    end
end)

return {
    Droppers = Droppers
}
