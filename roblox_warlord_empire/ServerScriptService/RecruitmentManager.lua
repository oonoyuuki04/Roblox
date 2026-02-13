--[[
    Service: RecruitmentManager
    Purpose: Handles 'Scouting' (Gacha), Talent Evaluation, and Warlord Summoning.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local RecruitData = DataStoreService:GetDataStore("RecruitData_v2")

-- Cost to "Send a Scout"
local SCOUT_COST = 500

-- Define Warlord Candidates (Retainers)
local CANDIDATES = {
    -- Commoners / Militia
    { Name = "Militia Captain",    Rank = "D", Might = 5,  Intellect = 2,  Chance = 40, Desc = "Experienced local guard." },
    { Name = "Traveling Mercenary",Rank = "C", Might = 15, Intellect = 5,  Chance = 30, Desc = "Fights for coin." },
    
    -- Officers / Strategists
    { Name = "Veteran General",    Rank = "B", Might = 30, Intellect = 20, Chance = 15, Desc = "Served under a fallen lord." },
    { Name = "Wise Hermit",        Rank = "B", Might = 5,  Intellect = 40, Chance = 10, Desc = "Knows the terrain well." },
    
    -- Legends (The "True Talent")
    { Name = "Dragon Blade",       Rank = "S", Might = 95, Intellect = 60, Chance = 1,  Special = "Peerless Might", Desc = "One swing clears a thousand foes." },
    { Name = "Divine Strategist",  Rank = "S", Might = 10, Intellect = 100, Chance = 1, Special = "Current of River", Desc = "Controls the flow of battle." },
    { Name = "Flying Warlord",     Rank = "SS", Might = 100, Intellect = 30, Chance = 0.5, Special = "Invincible", Desc = "None dare challenge him." },
}

local playerRoster = {} -- [UserId] = list of hired warlords

local ScoutFunction = Instance.new("RemoteFunction")
ScoutFunction.Name = "ScoutTalent"
ScoutFunction.Parent = ReplicatedStorage

local AssignWarlord = Instance.new("RemoteEvent")
AssignWarlord.Name = "AssignWarlord"
AssignWarlord.Parent = ReplicatedStorage

local function createWarlordModel(warlordName)
    local part = Instance.new("Part")
    part.Name = warlordName
    part.Size = Vector3.new(2, 5, 2)
    part.Material = Enum.Material.Metal
    part.CanCollide = false
    part.Color = Color3.fromRGB(200, 50, 50)
    
    local gyro = Instance.new("BodyGyro", part)
    gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    
    local pos = Instance.new("BodyPosition", part)
    pos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    pos.D = 500
    
    return part
end

-- Core "Scouting" Logic
ScoutFunction.OnServerInvoke = function(player)
    local ls = player:FindFirstChild("leaderstats")
    if ls.Money.Value < SCOUT_COST then
        return nil, "Insufficient Gold."
    end
    
    ls.Money.Value = ls.Money.Value - SCOUT_COST
    
    -- Weighted Random Selection
    local pool = {}
    for _, c in pairs(CANDIDATES) do
        for i = 1, (c.Chance * 10) do
             table.insert(pool, c)
        end
    end
    
    local recruited = pool[math.random(1, #pool)]
    
    -- Add to Roster
    playerRoster[player.UserId] = playerRoster[player.UserId] or {}
    table.insert(playerRoster[player.UserId], recruited)
    
    pcall(function()
        RecruitData:SetAsync(player.UserId, playerRoster[player.UserId])
    end)
    
    print("Scouted Candidate: " .. recruited.Name)
    return recruited
end

-- Assign Warlord (Equip)
AssignWarlord.OnServerEvent:Connect(function(player, warlordName)
    local roster = playerRoster[player.UserId]
    if not roster then return end
    
    local found = nil
    for _, c in ipairs(roster) do
        if c.Name == warlordName then found = c break end 
    end
    
    if found then
        local char = player.Character
        if char then
            local old = char:FindFirstChild("ActiveWarlord")
            if old then old:Destroy() end
            
            local model = createWarlordModel(found.Name)
            model.Name = "ActiveWarlord"
            model.Parent = char
            
            -- Follow Logic
            task.spawn(function()
                while model.Parent and char.Parent do
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        model.BodyPosition.Position = hrp.Position + Vector3.new(3, 2, 3)
                        model.BodyGyro.CFrame = hrp.CFrame
                    end
                    task.wait()
                end
            end)
            
            -- Grant buffs based on Might/Intellect
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = 100 + (found.Might * 2)
                hum.Health = hum.MaxHealth
            end
        end
    end
end)

return {}
