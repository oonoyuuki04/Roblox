--[[
    Service: TerritoryManager
    Purpose: Manages player territory (Castle, Strategy Tent) and Stipend generation.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local PLOT_SIZE = 100
local BASE_INCOME = 5
local INCOME_TICK = 3

-- Base Structures (The "Base" Departments re-skinned for Warlords)
local STRUCTURES = {
    [1] = { Name = "Outpost (関所)",      Cost = 0,     Income = 5,   Description = "Establish your domain." },
    [2] = { Name = "Strategy Tent (軍議所)", Cost = 200,   Income = 15,  UnlockLevel = 1, Description = "Meet with potential captains here. (Replaces Interview Room)" },
    [3] = { Name = "Training Grounds (練兵場)", Cost = 1000,  Income = 50,  UnlockLevel = 2, Description = "Train your troops." },
    [4] = { Name = "Treasury (蔵)",       Cost = 5000,  Income = 200, UnlockLevel = 3, Description = "Store your war chest." },
    [5] = { Name = "Audience Hall (謁見の間)", Cost = 20000, Income = 1000, UnlockLevel = 4, Description = "Receive legendary warlords." },
}

local playerTycoons = {} -- [UserId] = { OwnedDeps = {1=true}, Plot = CFrame }

-- Function to find a free plot
local function assignPlot(player)
    local index = #Players:GetPlayers()
    local x = (index - 1) * (PLOT_SIZE + 20)
    local plotCFrame = CFrame.new(x, 0, 0)
    
    -- Create physical base (Castle Ground)
    local base = Instance.new("Part")
    base.Name = player.Name .. "_Castle"
    base.Size = Vector3.new(PLOT_SIZE, 1, PLOT_SIZE)
    base.Position = Vector3.new(x, 0, 0)
    base.BasePlate.Material = Enum.Material.Grass
    base.BasePlate.Color = Color3.fromRGB(50, 100, 50)
    base.Anchored = true
    base.Parent = Workspace

    playerTycoons[player.UserId] = {
        OwnedDeps = { [1] = true }, -- Start with Outpost
        Plot = plotCFrame
    }
    
    print("New Domain established for Lord " .. player.Name)
end

-- Purchase Function
local function buildStructure(player, structId)
    local data = STRUCTURES[structId]
    local tycoon = playerTycoons[player.UserId]
    if not data or not tycoon then return false end
    
    local ls = player:FindFirstChild("leaderstats")
    if ls.Money.Value >= data.Cost then
        -- Check prerequisites
        if not tycoon.OwnedDeps[structId-1] and structId > 1 then
            return false, "Build previous structure first!"
        end

        ls.Money.Value = ls.Money.Value - data.Cost
        tycoon.OwnedDeps[structId] = true
        
        -- Place Visual Model (Japanese Castle Theme)
        local model = Instance.new("Part")
        model.Name = data.Name
        model.Size = Vector3.new(15, 12, 15)
        local offset = (structId - 1) * 18
        model.CFrame = tycoon.Plot * CFrame.new(offset - 40, 6, 0)
        model.Anchored = true
        model.Material = Enum.Material.Wood
        model.Color = Color3.fromRGB(139, 69, 19) -- Brown wood
        model.Parent = Workspace
        
        -- Roof
        local roof = Instance.new("WedgePart", model)
        roof.Size = Vector3.new(15, 4, 15)
        roof.CFrame = model.CFrame * CFrame.new(0, 8, 0)
        roof.Color = Color3.fromRGB(50, 50, 50) -- Dark tiles
        roof.Material = Enum.Material.Slate
        
        local bill = Instance.new("BillboardGui", model)
        bill.Size = UDim2.new(0,200,0,50)
        bill.AlwaysOnTop = true
        bill.StudsOffset = Vector3.new(0, 10, 0)
        local txt = Instance.new("TextLabel", bill)
        txt.Size = UDim2.new(1,0,1,0)
        txt.Text = data.Name
        txt.TextScaled = true
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.new(1,1,1)

        return true
    end
    return false, "Insufficient War Funds (軍資金不足)"
end

-- Income Loop (Taxes/Tributes)
task.spawn(function()
    while true do
        task.wait(INCOME_TICK)
        for userId, data in pairs(playerTycoons) do
            local player = Players:GetPlayerByUserId(userId)
            if player then
                local income = 0
                for id, owned in pairs(data.OwnedDeps) do
                    if owned then income = income + STRUCTURES[id].Income end
                end
                
                local ls = player:FindFirstChild("leaderstats")
                if ls then
                    ls.Money.Value = ls.Money.Value + income
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(assignPlot)

return {
    Structures = STRUCTURES,
    Build = buildStructure
}
