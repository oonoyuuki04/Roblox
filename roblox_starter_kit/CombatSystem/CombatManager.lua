--[[
    Service: CombatManager
    Purpose: Handles attack inputs, weapon collisions, and skills.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

-- Configuration
local WEAPONS = {
    Sword = { Damage = 10, Cooldown = 0.5 },
    Spear = { Damage = 15, Cooldown = 0.8 },
    Fan = { Damage = 5, Cooldown = 0.2, Skill = "WindGust" } -- Three Kingdoms style
}

-- Remote Event for Attacks
local AttackEvent = Instance.new("RemoteEvent")
AttackEvent.Name = "PerformAttack"
AttackEvent.Parent = ReplicatedStorage

local function createHitbox(player, weaponName, position, range)
    local hb = Instance.new("Part")
    hb.Name = "Hitbox"
    hb.Size = Vector3.new(range, range, range)
    hb.Position = position
    hb.Transparency = 1 -- Invisible
    hb.Anchored = true
    hb.CanCollide = false
    hb.Parent = workspace
    Debris:AddItem(hb, 0.1)
    
    local touching = hb:GetTouchingParts()
    for _, part in ipairs(touching) do
        local hum = part.Parent:FindFirstChild("Humanoid")
        if hum and part.Parent ~= player.Character then
            -- Damage!
            hum:TakeDamage(WEAPONS[weaponName].Damage)
            
            -- Visual Effect (Simplified)
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
    
    -- In a real game, verify cooldowns here
    
    local forward = root.CFrame.LookVector
    local pos = root.Position + (forward * 3)
    
    createHitbox(player, weaponName, pos, 5)
    
    print(player.Name .. " attacked with " .. weaponName)
end)

-- Skill System (e.g. Musou Attack)
local SkillEvent = Instance.new("RemoteEvent")
SkillEvent.Name = "UseSkill"
SkillEvent.Parent = ReplicatedStorage

SkillEvent.OnServerEvent:Connect(function(player, skillName)
    if skillName == "Musou" then
        local char = player.Character
        if char then
            -- Create a massive area attack
            local explosion = Instance.new("Explosion")
            explosion.Position = char.HumanoidRootPart.Position
            explosion.BlastRadius = 20
            explosion.BlastPressure = 0 -- Don't fling parts too much
            explosion.Parent = workspace
            
            -- Custom damage logic to avoid killing self would go here
        end
    end
end)

return {}
