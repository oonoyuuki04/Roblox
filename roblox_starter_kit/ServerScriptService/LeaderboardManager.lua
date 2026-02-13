--[[
    Service: LeaderboardManager
    Purpose: Creates a global leaderboard (SurfaceGui) for "Richest Players".
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local Workspace = game:GetService("Workspace")

local STAT_KEY = "Money" -- Attribute to rank
local UPDATE_INTERVAL = 60 -- Seconds

local OrderedStore = DataStoreService:GetOrderedDataStore("GlobalLeaderboard_v1")

local function updateLeaderboard()
    local success, pages = pcall(function()
        return OrderedStore:GetSortedAsync(false, 10) -- Top 10, Descending
    end)

    if not success then return end

    local entries = pages:GetCurrentPage()
    
    -- Find the specific part in workspace (Assume user placed a part named 'GlobalLeaderboard')
    local boardPart = Workspace:FindFirstChild("GlobalLeaderboard")
    if not boardPart then
        -- Auto-setup if missing
        boardPart = Instance.new("Part")
        boardPart.Name = "GlobalLeaderboard"
        boardPart.Anchored = true
        boardPart.Size = Vector3.new(10, 8, 1)
        boardPart.Position = Vector3.new(0, 10, -20) -- Place in lobby
        boardPart.Color = Color3.fromRGB(0, 0, 0)
        boardPart.Parent = Workspace
        
        -- Add SurfaceGui
        local sg = Instance.new("SurfaceGui", boardPart)
        -- sg.Face = Enum.NormalId.Front
        
        local frame = Instance.new("ScrollingFrame", sg)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        
        local list = Instance.new("UIListLayout", frame)
        list.Padding = UDim.new(0, 5)
    end
    
    local sg = boardPart:FindFirstChildOfClass("SurfaceGui")
    if not sg then return end
    
    local frame = sg:FindFirstChildOfClass("ScrollingFrame")
    frame:ClearAllChildren()
    Instance.new("UIListLayout", frame).Padding = UDim.new(0, 5)

    -- Populate entries
    for rank, entry in ipairs(entries) do
        local userId = entry.key
        local value = entry.value
        local name = "[Loading...]"
        
        pcall(function()
            name = Players:GetNameFromUserIdAsync(userId)
        end)

        local row = Instance.new("TextLabel")
        row.Size = UDim2.new(1, 0, 0, 50)
        row.Text = "#" .. rank .. " " .. name .. ": $" .. value
        row.TextSize = 30
        row.TextColor3 = Color3.new(1,1,1)
        row.BackgroundTransparency = 1
        row.Parent = frame
    end
end

-- Update Loop
task.spawn(function()
    while true do
        -- Save everyone first
        for _, player in ipairs(Players:GetPlayers()) do
            local ls = player:FindFirstChild("leaderstats")
            if ls then
                OrderedStore:SetAsync(player.UserId, ls[STAT_KEY].Value)
            end
        end
        
        updateLeaderboard()
        task.wait(UPDATE_INTERVAL)
    end
end)
