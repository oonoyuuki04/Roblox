--[[
    Service: CombatManager (Warlord Ed.)
    Purpose: Handles attack inputs, weapon collisions, skills (Musou), and Warlord Follower AI targeting.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

-- Configuration
local WEAPONS = {
    Sword = { Damage = 10, Cooldown = 0.5 },
    Spear = { Damage = 15, Cooldown = 0.8 },
    Fan = { Damage = 5, Cooldown = 0.2, Skill = "WindGust" }
}

local AttackEvent = Instance.new("RemoteEvent")
AttackEvent.Name = "PerformAttack"
AttackEvent.Parent = ReplicatedStorage

local function createHitbox(player, weaponName, position, range)
    local hb = Instance.new("Part")
    hb.Name = "Hitbox"
    hb.Size = Vector3.new(range, range, range)
    hb.Position = position
    hb.Transparency = 1
    hb.Anchored = true
    hb.CanCollide = false
    hb.Parent = workspace
    Debris:AddItem(hb, 0.1)
    
    local touching = hb:GetTouchingParts()
    for _, part in ipairs(touching) do
        local hum = part.Parent:FindFirstChild("Humanoid")
        if hum and part.Parent ~= player.Character then
            -- Damage logic
            hum:TakeDamage(WEAPONS[weaponName].Damage)
            hum:SetAttribute("LastHitBy", player.Name) -- For loot credit
            
            -- Visual
            local fx = Instance.new("Sparkles", part)
            Debris:AddItem(fx, 0.5)
        end
    end
end

AttackEvent.OnServerEvent:Connect(function(player, weaponName)
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local weapon = WEAPONS[weaponName]
    if not weapon then return end
    
    local forward = root.CFrame.LookVector
    local pos = root.Position + (forward * 3)
    
    createHitbox(player, weaponName, pos, 5)
    
    -- Warlord Follower Attack AI (The "Assist" Logic)
    local warlord = char:FindFirstChild("ActiveWarlord")
    if warlord then
        -- Find nearest enemy within strict range
        local myPos = root.Position
        local nearestEnemy = nil
        local dist = 15 
        
        for _, obj in ipairs(workspace.Enemies:GetChildren()) do
            local enemyRoot = obj:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                local d = (enemyRoot.Position - myPos).Magnitude
                if d < dist then
                    dist = d
                    nearestEnemy = obj
                end
            end
        end
        
        if nearestEnemy then
            -- Make warlord look at enemy
            local bg = warlord:FindFirstChild("BodyGyro")
            if bg then
                bg.CFrame = CFrame.new(warlord.Position, nearestEnemy.HumanoidRootPart.Position)
            end
            
            -- Deal Damage (Simulated Attack)
            local enemyHum = nearestEnemy:FindFirstChild("Humanoid")
            if enemyHum then
                enemyHum:TakeDamage(5) -- Warlord deals constant tick damage
                print(player.Name .. "'s Warlord hit Bandit!")
            end
        end
    end
end)

return {}
