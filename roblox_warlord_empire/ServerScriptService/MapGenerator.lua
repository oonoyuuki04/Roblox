--[[
    Service: MapGenerator
    Purpose: Generates a tactical map with Mountains, Rivers, and Forts.
    Location: ServerScriptService
]]

local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain

local MAP_SIZE = 512
local SEED = tick()

local function generateMap()
    -- 1. Base Terrain
    Terrain:Clear()
    
    local region = Region3.new(
        Vector3.new(-MAP_SIZE/2, -10, -MAP_SIZE/2),
        Vector3.new(MAP_SIZE/2, 10, MAP_SIZE/2)
    )
    
    -- Fill Base Plate
    Terrain:FillBlock(CFrame.new(0, -5, 0), Vector3.new(MAP_SIZE, 10, MAP_SIZE), Enum.Material.Grass)

    -- 2. Mountains (Perlin Noise)
    for x = -MAP_SIZE/2, MAP_SIZE/2, 4 do
        for z = -MAP_SIZE/2, MAP_SIZE/2, 4 do
            local noise = math.noise(x/100, z/100, SEED)
            if noise > 0.3 then
                -- Create Mountain
                local height = (noise - 0.3) * 100
                Terrain:FillBlock(CFrame.new(x, height/2, z), Vector3.new(5, height, 5), Enum.Material.Rock)
            end
        end
    end

    -- 3. Rivers (Sin Wave)
    for z = -MAP_SIZE/2, MAP_SIZE/2, 2 do
        local x = math.sin(z/50) * 100
        Terrain:FillBlock(CFrame.new(x, -2, z), Vector3.new(15, 8, 5), Enum.Material.Water)
    end
    
    -- 4. Forts (Strategic Points)
    local fortLocations = {
        Vector3.new(100, 5, 100),
        Vector3.new(-100, 5, -100),
        Vector3.new(100, 5, -100),
        Vector3.new(-100, 5, 100)
    }
    
    for _, pos in ipairs(fortLocations) do
        local fort = Instance.new("Part")
        fort.Name = "Neutral Fort"
        fort.Size = Vector3.new(20, 10, 20)
        fort.Position = pos
        fort.Anchored = true
        fort.BrickColor = BrickColor.new("Dark stone grey")
        fort.Material = Enum.Material.Slate
        fort.Parent = Workspace
        
        -- Flag
        local pole = Instance.new("Part", fort)
        pole.Size = Vector3.new(1, 15, 1)
        pole.Position = pos + Vector3.new(0, 10, 0)
        pole.Anchored = true
        pole.Color = Color3.new(1,1,1)
    end
end

-- Generate on server start
generateMap()

return {}
