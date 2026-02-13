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

-- Base Structures
local STRUCTURES = {
    [1] = { Name = "Outpost (関所)",      Cost = 0,     Income = 5,   Description = "Establish your domain." },
    [2] = { Name = "Strategy Tent (軍議所)", Cost = 200,   Income = 15,  UnlockLevel = 1, Description = "Hire officers." },
    [3] = { Name = "Training Grounds (練兵場)", Cost = 1000,  Income = 50,  UnlockLevel = 2, Description = "Train troops." },
    [4] = { Name = "Treasury (蔵)",       Cost = 5000,  Income = 200, UnlockLevel = 3, Description = "Store war chest." },
    [5] = { Name = "Audience Hall (謁見の間)", Cost = 20000, Income = 1000, UnlockLevel = 4, Description = "Receive legends." },
}

local playerTycoons = {} -- [UserId] = { Owned = {1=true}, Plot = CFrame }

local function assignPlot(player)
    local index = #Players:GetPlayers()
    local x = (index - 1) * (PLOT_SIZE + 20)
    local plotCFrame = CFrame.new(x, 0, 0)
    
    local base = Instance.new("Part")
    base.Name = player.Name .. "_Castle"
    base.Size = Vector3.new(PLOT_SIZE, 1, PLOT_SIZE)
    base.Position = Vector3.new(x, 0, 0)
    base.BasePlate.Material = Enum.Material.Grass
    base.BasePlate.Color = Color3.fromRGB(50, 100, 50)
    base.Anchored = true
    base.Parent = Workspace

    playerTycoons[player.UserId] = {
        OwnedDeps = { [1] = true },
        Plot = plotCFrame
    }
    
    -- Create initial "Outpost" visual
    local m = Instance.new("Model", base)
    m.Name = "Structures"
    
    print("New Domain established for Lord " .. player.Name)
end

local function buildStructure(player, structId)
    local data = STRUCTURES[structId]
    local tycoon = playerTycoons[player.UserId]
    if not data or not tycoon then return false end
    
    local ls = player:FindFirstChild("leaderstats")
    if ls.Money.Value >= data.Cost then
        if not tycoon.OwnedDeps[structId-1] and structId > 1 then return false, "Build previous structure first!" end

        ls.Money.Value = ls.Money.Value - data.Cost
        tycoon.OwnedDeps[structId] = true
        
        -- Place Visual Model
        local model = Instance.new("Part")
        model.Name = data.Name
        model.Size = Vector3.new(15, 10, 15)
        local offset = (structId - 1) * 20
        model.CFrame = tycoon.Plot * CFrame.new(offset - 40, 5, 0)
        model.Anchored = true
        model.Material = Enum.Material.Wood
        model.Color = Color3.fromRGB(139, 69, 19)
        model.Parent = Workspace
        
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
    return false, "Insufficient Funds"
end

-- Income Loop
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
                if ls then ls.Money.Value = ls.Money.Value + income end
            end
        end
    end
end)

Players.PlayerAdded:Connect(assignPlot)

return {
    Structures = STRUCTURES,
    Build = buildStructure
}
