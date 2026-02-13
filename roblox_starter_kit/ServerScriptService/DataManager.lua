--[[
    Service: DataManager
    Purpose: Handles player data (Money, Level), leaderstats, and DataStore saving/loading.
    Location: ServerScriptService
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1") -- Change version if schema changes

local function createLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local money = Instance.new("IntValue")
    money.Name = "Money"
    money.Value = 0 -- Default
    money.Parent = leaderstats

    local level = Instance.new("IntValue")
    level.Name = "Level"
    level.Value = 1 -- Default
    level.Parent = leaderstats

    return money, level
end

local function savePlayerData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local dataToSave = {
        Money = leaderstats.Money.Value,
        Level = leaderstats.Level.Value
    }

    local success, errorMessage = pcall(function()
        PlayerDataStore:SetAsync(player.UserId, dataToSave)
    end)

    if success then
        print("Data saved successfully for " .. player.Name)
    else
        warn("Failed to save data for " .. player.Name .. ": " .. errorMessage)
    end
end

-- Load Data on Join
Players.PlayerAdded:Connect(function(player)
    local money, level = createLeaderstats(player)

    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)

    if success then
        if data then
            money.Value = data.Money or 0
            level.Value = data.Level or 1
            print("Data loaded for " .. player.Name)
        else
            print("New player joined: " .. player.Name)
        end
    else
        warn("Failed to load data for " .. player.Name)
        -- Important: Consider kicking player or disabling saving to prevent data loss here
    end
end)

-- Save Data on Leave
Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
end)

-- Auto-Save Loop (Every 60 seconds)
task.spawn(function()
    while true do
        task.wait(60)
        for _, player in ipairs(Players:GetPlayers()) do
            savePlayerData(player)
        end
    end
end)

-- Handle Server Shutdown (Save all players)
game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        savePlayerData(player)
    end
end)
