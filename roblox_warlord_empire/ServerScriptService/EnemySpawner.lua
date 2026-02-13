--[[
    Service: EnemySpawner (Bandit System)
    Purpose: Spawns Bandits (NPCs) around player bases.
    Location: ServerScriptService
]]

local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local PathfindingService = game:GetService("PathfindingService")

local SPAWN_INTERVAL = 10
local MAX_ENEMIES = 15
local SPAWN_RADIUS = 150

local enemiesFolder = Instance.new("Folder", workspace)
enemiesFolder.Name = "Enemies"

local function createBandit(position)
    local bandit = Instance.new("Model")
    bandit.Name = "Bandit"
    bandit.Parent = enemiesFolder
    
    local humanoid = Instance.new("Humanoid", bandit)
    humanoid.MaxHealth = 50
    humanoid.Health = 50
    humanoid.PlatformStand = false
    
    local rootPart = Instance.new("Part", bandit)
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 5, 2)
    rootPart.Color = Color3.fromRGB(50, 50, 50) -- Dark clothes
    rootPart.Position = position
    rootPart.CanCollide = true
    rootPart.Anchored = false
    
    local head = Instance.new("Part", bandit)
    head.Name = "Head"
    head.Size = Vector3.new(1.2, 1.2, 1.2)
    head.Color = Color3.fromRGB(200, 150, 100)
    head.Position = position + Vector3.new(0, 3, 0)
    
    local weld = Instance.new("WeldConstraint", bandit)
    weld.Part0 = rootPart
    weld.Part1 = head
    
    -- AI Logic (Wander or Chase)
    task.spawn(function()
        while humanoid.Health > 0 do
            -- Find nearest player
            local target = nil
            local dist = 100
            for _, p in ipairs(game.Players:GetPlayers()) do
                local char = p.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local d = (char.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        target = char
                    end
                end
            end
            
            if target then
                humanoid:MoveTo(target.HumanoidRootPart.Position)
            else
                -- Random wander
                humanoid:MoveTo(rootPart.Position + Vector3.new(math.random(-20,20), 0, math.random(-20,20)))
            end
            task.wait(2)
        end
    end)
    
    -- Drop Loot on Death
    humanoid.Died:Connect(function()
        local killer = humanoid:GetAttribute("LastHitBy") -- Needs CombatManager to set this
        if killer then 
            -- Give rewards 
        end
        bandit:Destroy()
    end)
    
    return bandit
end

-- Spawn Loop
task.spawn(function()
    while true do
        task.wait(SPAWN_INTERVAL)
        if #enemiesFolder:GetChildren() < MAX_ENEMIES then
            local x = math.random(-SPAWN_RADIUS, SPAWN_RADIUS)
            local z = math.random(-SPAWN_RADIUS, SPAWN_RADIUS)
            createBandit(Vector3.new(x, 5, z))
        end
    end
end)

return {}
