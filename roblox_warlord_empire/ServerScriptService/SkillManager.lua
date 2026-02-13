--[[
    Service: SkillManager
    Purpose: Active Skills depending on Equipped Warlord.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local MAX_ENERGY = 100
local CHARGE_PER_HIT = 20

-- Define Warlord Skills
local SKILL_DEF = {
    ["Dragon Blade"] = { Name = "Green Dragon Strike", Desc = "Massive AoE damage.", Cost = 100 },
    ["Divine Strategist"] = { Name = "Fire Ploy (火計)", Desc = "Ignites the battlefield.", Cost = 80 },
    ["Flying Warlord"] = { Name = "Unparalled Musou", Desc = "Knocks back all enemies.", Cost = 100 },
    ["Veteran General"] = { Name = "Rally", Desc = "Heals troops.", Cost = 50 },
}

local SkillEvent = Instance.new("RemoteEvent")
SkillEvent.Name = "UseSkill"
SkillEvent.Parent = ReplicatedStorage
local ChargeEvent = Instance.new("SkillCharge") -- For updating UI

-- Track Player Skill Gauge
local playerEnergy = {} -- [UserId] = 0-100

-- Charge on hit (Hook into CombatManager logic)
local function addCharge(player, amount)
    playerEnergy[player.UserId] = math.min((playerEnergy[player.UserId] or 0) + amount, MAX_ENERGY)
    -- Fire Client to update UI (TODO: RemoteEvent)
end

-- Use Skill
SkillEvent.OnServerEvent:Connect(function(player)
    local energy = playerEnergy[player.UserId] or 0
    local char = player.Character
    local warlordPart = char:FindFirstChild("ActiveWarlord")
    
    -- Determine Skill based on Warlord Name (simplified logic)
    -- In real game, store Warlord ID in attribute
    local skillName = "Rally" -- Default
    if warlordPart then
        -- Find match in SKILL_DEF based on warlord name
        -- For now hardcode a check
        if string.find(warlordPart.Name, "Dragon") then skillName = "Green Dragon Strike"
        elseif string.find(warlordPart.Name, "Strategist") then skillName = "Fire Ploy (火計)"
        elseif string.find(warlordPart.Name, "Flying") then skillName = "Unparalled Musou"
        end
    end
    
    local skill = SKILL_DEF[skillName] or SKILL_DEF["Veteran General"]
    
    if energy >= skill.Cost then
        playerEnergy[player.UserId] = energy - skill.Cost
        
        -- Execute Skill Logic
        local root = char.HumanoidRootPart
        
        if skillName == "Fire Ploy (火計)" then
            -- Create Fire Zone
            local zone = Instance.new("Part")
            zone.Shape = Enum.PartType.Cylinder
            zone.Size = Vector3.new(1, 30, 30)
            zone.CFrame = root.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(0,0,math.rad(90))
            zone.Transparency = 0.5
            zone.BrickColor = BrickColor.new("Bright orange")
            zone.CanCollide = false
            zone.Anchored = true
            zone.Parent = workspace
            
            local fire = Instance.new("Fire", zone)
            fire.Size = 20
            
            Debris:AddItem(zone, 5) -- Lasts 5 seconds
            
            -- Damage Loop
            task.spawn(function()
                for i=1, 5 do
                    local parts = workspace:GetPartsInPart(zone)
                    for _, p in ipairs(parts) do
                        local h = p.Parent:FindFirstChild("Humanoid")
                        if h and h.Parent ~= char then h:TakeDamage(10) end
                    end
                    task.wait(1)
                end
            end)
            
        elseif skillName == "Unparalled Musou" then
            -- Knockback Explosion
            local exp = Instance.new("Explosion")
            exp.Position = root.Position
            exp.BlastRadius = 20
            exp.BlastPressure = 50000 -- High push
            exp.DestroyJointsRadius = 0 -- Don't insta-kill parts
            exp.Parent = workspace
        end
        
        print(player.Name .. " used " .. skill.Name .. "!")
    end
end)

return {
    AddCharge = addCharge
}
