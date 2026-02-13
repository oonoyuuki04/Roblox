--[[
    LocalScript: WarlordHUD
    Purpose: Main game interface. Tabs for: 
    - Domain (City Building)
    - Warlords (Recruitment/Inventory)
    - War Chest (Shop)
    Location: StarterGui > WarlordHUD (LocalScript)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Remotes
local ScoutFunction = ReplicatedStorage:WaitForChild("ScoutTalent")
local AssignEvent = ReplicatedStorage:WaitForChild("AssignWarlord")
local AttackEvent = ReplicatedStorage:WaitForChild("PerformAttack")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WarlordHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- 1. FUNDS (Stipend) DISPLAY
local fundsFrame = Instance.new("Frame")
fundsFrame.Size = UDim2.new(0, 200, 0, 50)
fundsFrame.Position = UDim2.new(0.5, -100, 0, 10)
fundsFrame.BackgroundColor3 = Color3.fromRGB(40, 30, 20) -- Wood
fundsFrame.Parent = screenGui
Instance.new("UICorner", fundsFrame).CornerRadius = UDim.new(0, 12)

local moneyText = Instance.new("TextLabel")
moneyText.Size = UDim2.new(1, 0, 1, 0)
moneyText.BackgroundTransparency = 1
moneyText.Text = "軍資金 (Funds): 0"
moneyText.TextColor3 = Color3.fromRGB(255, 215, 0)
moneyText.Font = Enum.Font.Sarpanch
moneyText.TextSize = 20
moneyText.Parent = fundsFrame

task.spawn(function()
    while true do
        local ls = player:FindFirstChild("leaderstats")
        if ls then moneyText.Text = "軍資金 (Funds): " .. ls.Money.Value end
        task.wait(0.5)
    end
end)

-- 2. ATTACK BUTTON (For Combat)
local attackBtn = Instance.new("TextButton")
attackBtn.Size = UDim2.new(0, 100, 0, 100)
attackBtn.Position = UDim2.new(0.85, 0, 0.7, 0)
attackBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20) -- Blood Red
attackBtn.Text = "撃"
attackBtn.TextColor3 = Color3.new(1,1,1)
attackBtn.Font = Enum.Font.Sarpanch
attackBtn.TextSize = 40
attackBtn.Parent = screenGui
Instance.new("UICorner", attackBtn).CornerRadius = UDim.new(1, 0)

attackBtn.MouseButton1Click:Connect(function()
    AttackEvent:FireServer("Sword")
end)

-- 3. MAIN MENU UI (Tabs)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- Toggle Button
local menuToggle = Instance.new("TextButton")
menuToggle.Size = UDim2.new(0, 80, 0, 80)
menuToggle.Position = UDim2.new(0, 20, 0.5, -40)
menuToggle.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
menuToggle.Text = "采配\n(Menu)"
menuToggle.TextColor3 = Color3.new(1,1,1)
menuToggle.Font = Enum.Font.Sarpanch
menuToggle.Parent = screenGui
Instance.new("UICorner", menuToggle).CornerRadius = UDim.new(0, 12)

menuToggle.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
-- Close btn inside mainFrame... (omitted for brevity)

-- Tabs
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 50)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame
local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -50)
contentContainer.Position = UDim2.new(0, 0, 0, 50)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local currentTab = nil

local function showTab(name)
    if currentTab then currentTab:Destroy() end
    currentTab = Instance.new("ScrollingFrame", contentContainer)
    currentTab.Size = UDim2.new(1,0,1,0)
    currentTab.BackgroundTransparency = 1
    local gl = Instance.new("UIGridLayout", currentTab)
    gl.CellSize = UDim2.new(0, 140, 0, 140)
    gl.CellPadding = UDim2.new(0, 10, 0, 10)

    if name == "Recruit" then
        -- Show Recruit/Assign Options
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.Text = "登用 (Scout)\nCost: 500"
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Parent = currentTab
        btn.MouseButton1Click:Connect(function()
            -- Invoke Audience Animation (Ideally call RecruitmentUI logic)
            local result = ScoutFunction:InvokeServer()
            if result then print(result.Name) end
        end)
    elseif name == "Build" then
        -- Show buildings
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
        btn.Text = "軍議所 (Strategy Tent)\nCost: 200"
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Parent = currentTab
        -- Connect to TerritoryManager Build function
    end
end

-- Tab Buttons
local tabs = {"Recruit", "Build", "Shop"}
for _, t in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = t
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Parent = tabContainer
    btn.MouseButton1Click:Connect(function() showTab(t) end)
end
