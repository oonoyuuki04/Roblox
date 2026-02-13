--[[
    Service: CityManager
    Purpose: Allows players to build structures on a grid that generate income.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Configuration
local GRID_SIZE = 10
local BUILDINGS = {
    [1] = { Name = "House", Cost = 100, Income = 2, Model = nil, Color = Color3.fromRGB(200, 200, 200) },
    [2] = { Name = "Shop",  Cost = 500, Income = 10, Model = nil, Color = Color3.fromRGB(100, 100, 255) },
    [3] = { Name = "Castle",Cost = 2000, Income = 50, Model = nil, Color = Color3.fromRGB(255, 215, 0) },
}

-- Remote Function for Building
local PlaceBuilding = Instance.new("RemoteFunction")
PlaceBuilding.Name = "PlaceBuilding"
PlaceBuilding.Parent = ReplicatedStorage

-- Tracking
local playerBuildings = {} -- [UserId] = { { Type=1, X=10, Z=20 }, ... }

local function createBuildingModel(typeId, position)
    local data = BUILDINGS[typeId]
    local part = Instance.new("Part")
    part.Name = data.Name
    part.Size = Vector3.new(GRID_SIZE, GRID_SIZE, GRID_SIZE)
    part.Position = position + Vector3.new(0, GRID_SIZE/2, 0)
    part.Anchored = true
    part.Color = data.Color
    part.Material = Enum.Material.Brick
    part.Parent = Workspace
    
    local gui = Instance.new("SurfaceGui", part)
    gui.Face = Enum.NormalId.Top
    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1,0,1,0)
    label.Text = data.Name .. "\n+$" .. data.Income
    label.TextScaled = true
    return part
end

PlaceBuilding.OnServerInvoke = function(player, typeId, cframe)
    local data = BUILDINGS[typeId]
    if not data then return false, "Invalid Building" end
    
    local ls = player:FindFirstChild("leaderstats")
    if not ls or ls.Money.Value < data.Cost then return false, "Too Expensive" end
    
    -- Snap to Grid
    local x = math.floor(cframe.Position.X / GRID_SIZE + 0.5) * GRID_SIZE
    local z = math.floor(cframe.Position.Z / GRID_SIZE + 0.5) * GRID_SIZE
    local pos = Vector3.new(x, 0, z)
    
    -- Check overlap (Simplified)
    -- In a real game, check a grid map or region
    
    ls.Money.Value = ls.Money.Value - data.Cost
    
    -- Record
    playerBuildings[player.UserId] = playerBuildings[player.UserId] or {}
    table.insert(playerBuildings[player.UserId], { Type = typeId, Position = pos })
    
    createBuildingModel(typeId, pos)
    
    return true, "Built " .. data.Name
end

-- Income Loop
task.spawn(function()
    while true do
        task.wait(5) -- Every 5 seconds
        for userId, buildings in pairs(playerBuildings) do
            local player = Players:GetPlayerByUserId(userId)
            if player then
                local income = 0
                for _, b in ipairs(buildings) do
                    income = income + BUILDINGS[b.Type].Income
                end
                
                local ls = player:FindFirstChild("leaderstats")
                if ls and income > 0 then
                    ls.Money.Value = ls.Money.Value + income
                    -- Show popup?
                end
            end
        end
    end
end)

return BUILDINGS
