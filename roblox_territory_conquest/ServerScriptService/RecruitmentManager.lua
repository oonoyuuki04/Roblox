--[[
    Service: RecruitmentManager
    Purpose: Handles 'Scouting' (Gacha) and Talent Evaluation (Appraisal/鑑定).
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local RecruitData = DataStoreService:GetDataStore("RecruitData_v2")

-- Cost to "Expand Influence" or "Send Envoys"
local SCOUT_COST = 500

-- Define Warlord Candidates (Retainers)
local CANDIDATES = {
    -- Commoners
    { Name = "Militia Captain",    Rank = "D", Might = 5,  Intellect = 2,  Desc = "Experienced local guard." },
    { Name = "Traveling Mercenary",Rank = "C", Might = 15, Intellect = 5,  Desc = "Fights for coin." },
    
    -- Officers
    { Name = "Veteran General",    Rank = "B", Might = 30, Intellect = 20, Desc = "Served under a fallen lord." },
    { Name = "Wise Hermit",        Rank = "B", Might = 5,  Intellect = 40, Desc = "Knows the terrain well." },
    
    -- Legends
    { Name = "Dragon Blade",       Rank = "S", Might = 95, Intellect = 60, Special = "Peerless Might", Desc = "One swing clears a thousand foes." },
    { Name = "Divine Strategist",  Rank = "S", Might = 10, Intellect = 100, Special = "Current of River", Desc = "Controls the flow of battle." },
}

local playerRoster = {} 

local ScoutFunction = Instance.new("RemoteFunction")
ScoutFunction.Name = "ScoutTalent"
ScoutFunction.Parent = ReplicatedStorage

-- Core "Scouting" Logic
ScoutFunction.OnServerInvoke = function(player)
    local ls = player:FindFirstChild("leaderstats")
    if ls.Money.Value < SCOUT_COST then
        return nil, "Insufficient Gold to send envoys."
    end
    ls.Money.Value = ls.Money.Value - SCOUT_COST
    
    -- Weighted Random Selection
    local pool = {}
    -- (Simplified pool generation logic same as before)
    -- ...
    
    local recruited = CANDIDATES[math.random(1, #CANDIDATES)] -- Placeholder logic
    
    -- Add to Roster
    playerRoster[player.UserId] = playerRoster[player.UserId] or {}
    table.insert(playerRoster[player.UserId], recruited)
    
    pcall(function()
        RecruitData:SetAsync(player.UserId, playerRoster[player.UserId])
    end)
    
    print("Appraised Candidate: " .. recruited.Name .. " [Appraisal Scroll attached]")
    return recruited
end

return {}
