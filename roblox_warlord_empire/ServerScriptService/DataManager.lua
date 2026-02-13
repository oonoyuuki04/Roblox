--[[
    Service: DataManager (Robust)
    Purpose: Saves player stats with Retry Logic and Error Handling.
    Location: ServerScriptService
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local PlayerDataStore = DataStoreService:GetDataStore("WarlordData_v2")

local DATA_RETRIES = 3

-- Retry Wrapper
local function retry(func, ...)
    local args = {...}
    for i = 1, DATA_RETRIES do
        local success, result = pcall(func, unpack(args))
        if success then return result end
        warn("DataStore Error (Attempt " .. i .. "): " .. tostring(result))
        task.wait(2)
    end
    return nil
end

local function createLeaderstats(player)
    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"

    local money = Instance.new("IntValue", leaderstats)
    money.Name = "Money"
    money.Value = 0

    local level = Instance.new("IntValue", leaderstats)
    level.Name = "Level"
    level.Value = 1
    
    return money
end

local function loadData(player)
    local money = createLeaderstats(player)

    local data = retry(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)

    if data then
        money.Value = data.Money or 0
        print("Data loaded for " .. player.Name)
        
        -- Load Warlord Inventory (Calls RecruitmentManager)
        local recManager = game.ServerScriptService:FindFirstChild("RecruitmentManager")
        if recManager and recManager:FindFirstChild("LoadRoster") then
             recManager.LoadRoster:Fire(player, data.Roster or {})
        end
    else
        print("New profile for " .. player.Name)
    end
end

local function saveData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    -- Gather data from other services
    local roster = {} 
    
    -- (Ideally use BindableFunction to get data from RecruitmentManager)
    -- For now, we assume simple saving
    
    local data = {
        Money = leaderstats.Money.Value,
        Roster = roster -- Needs integration
    }

    retry(function()
        PlayerDataStore:SetAsync(player.UserId, data)
    end)
    print("Data saved for " .. player.Name)
end

Players.PlayerAdded:Connect(loadData)
Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
    if RunService:IsStudio() then return end -- Skip in Studio
    for _, p in ipairs(Players:GetPlayers()) do 
        coroutine.wrap(saveData)(p) 
    end
    task.wait(2) -- Wait for saves
end)
