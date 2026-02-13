--[[
    Service: ObbyGenerator
    Purpose: Procedurally generates a challenging and "rich" looking obstacle course.
    Location: ServerScriptService
]]

local Workspace = game:GetService("Workspace")
local PhysicsService = game:GetService("PhysicsService")

local OBBY_START_POS = Vector3.new(0, 50, 0)
local PLATFORM_SIZE = Vector3.new(8, 1, 8)
local JUMP_GAP = 12

-- Colors and materials for a "rich" feel
local COLORS = {
    Color3.fromRGB(255, 105, 180), -- Hot Pink
    Color3.fromRGB(0, 255, 255),   -- Cyan
    Color3.fromRGB(138, 43, 226),  -- BlueViolet
    Color3.fromRGB(255, 215, 0)    -- Gold
}

local function createPlatform(position, color, material)
    local part = Instance.new("Part")
    part.Anchored = true
    part.Size = PLATFORM_SIZE
    part.Position = position
    part.Color = color or COLORS[math.random(1, #COLORS)]
    part.Material = material or Enum.Material.Neon
    part.Parent = Workspace
    return part
end

local function generateCourse()
    local currentPos = OBBY_START_POS
    
    -- Start Platform
    createPlatform(currentPos, Color3.new(1,1,1), Enum.Material.Grass)

    -- Segment 1: Simple Jumps (Neon Blocks)
    for i = 1, 10 do
        currentPos = currentPos + Vector3.new(0, 2, JUMP_GAP)
        createPlatform(currentPos)
    end

    -- Segment 2: Rotating Platforms
    for i = 1, 5 do
        currentPos = currentPos + Vector3.new(JUMP_GAP, 0, 0)
        local plat = createPlatform(currentPos, Color3.fromRGB(255, 0, 0))
        plat.Shape = Enum.PartType.Cylinder
        plat.Size = Vector3.new(10, 1, 10)
        plat.CFrame = CFrame.new(currentPos) * CFrame.Angles(0,0,math.rad(90))
        
        -- Spinner Script logic inside
        local spinner = Instance.new("BodyAngularVelocity")
        spinner.MaxTorque = Vector3.new(0, math.huge, 0)
        spinner.AngularVelocity = Vector3.new(0, 2, 0)
        spinner.Parent = plat
    end

    -- Segment 3: Fading Platforms (Trap)
    for i = 1, 8 do
        currentPos = currentPos + Vector3.new(0, -1, -JUMP_GAP)
        local plat = createPlatform(currentPos, Color3.new(0.5, 0.5, 0.5), Enum.Material.Glass)
        
        task.spawn(function()
            while true do
                plat.Transparency = 0
                plat.CanCollide = true
                task.wait(2)
                plat.Transparency = 0.8
                plat.CanCollide = false
                task.wait(2)
            end
        end)
    end

    -- End Goal (Winner Platform)
    currentPos = currentPos + Vector3.new(0, 0, -20)
    local winPlat = createPlatform(currentPos, Color3.fromRGB(255, 215, 0), Enum.Material.Glacier)
    winPlat.Size = Vector3.new(20, 2, 20)
    
    -- Reward Logic
    local detector = Instance.new("TouchTransmitter", winPlat) -- Normally create simple Touched event
    
    local debounce = {}
    winPlat.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player and not debounce[player.UserId] then
            debounce[player.UserId] = true
            
            -- Give massive reward
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                leaderstats.Money.Value = leaderstats.Money.Value + 1000
                print(player.Name .. " completed the Obby!")
            end
            
            -- Teleport back to spawn
            task.wait(1)
            player.Character:MoveTo(Vector3.new(0, 10, 0))
            task.wait(5)
            debounce[player.UserId] = nil
        end
    end)
end

-- Generate on server start
generateCourse()
