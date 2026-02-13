--[[
    LocalScript: ModernHUD (v2)
    Purpose: Rich UI with Tabs for Shop (Items, Pets, Upgrades).
    Location: StarterGui > ModernHUD (LocalScript)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Remotes (Ensure these exist or logic handles missing ones)
local HatchFunction = ReplicatedStorage:WaitForChild("HatchEgg", 5)
local PurchaseGear = ReplicatedStorage:WaitForChild("BuyGear", 5)
local ClickEvent = ReplicatedStorage:WaitForChild("ClickForMoney", 5)

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- 1. MONEY DISPLAY
local moneyFrame = Instance.new("Frame")
moneyFrame.Size = UDim2.new(0, 200, 0, 50)
moneyFrame.Position = UDim2.new(0.5, -100, 0, 10)
moneyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
moneyFrame.Parent = screenGui
Instance.new("UICorner", moneyFrame).CornerRadius = UDim.new(0, 12)

local moneyText = Instance.new("TextLabel")
moneyText.Size = UDim2.new(1, 0, 1, 0)
moneyText.BackgroundTransparency = 1
moneyText.Text = "Money: $0"
moneyText.TextColor3 = Color3.fromRGB(255, 215, 0)
moneyText.Font = Enum.Font.FredokaOne
moneyText.TextSize = 24
moneyText.Parent = moneyFrame

task.spawn(function()
    while true do
        local ls = player:FindFirstChild("leaderstats")
        if ls then moneyText.Text = "Money: $" .. ls.Money.Value end
        task.wait(0.5)
    end
end)

-- 2. CLICK BUTTON
local clickBtn = Instance.new("TextButton")
clickBtn.Size = UDim2.new(0, 120, 0, 120)
clickBtn.Position = UDim2.new(0.5, -60, 0.85, -60)
clickBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
clickBtn.Text = "CLICK!"
clickBtn.TextColor3 = Color3.new(1,1,1)
clickBtn.Font = Enum.Font.FredokaOne
clickBtn.TextSize = 24
clickBtn.Parent = screenGui
Instance.new("UICorner", clickBtn).CornerRadius = UDim.new(1, 0)

clickBtn.MouseButton1Click:Connect(function()
    if ClickEvent then ClickEvent:FireServer() end
    clickBtn.Size = UDim2.new(0, 110, 0, 110)
    task.wait(0.05)
    clickBtn.Size = UDim2.new(0, 120, 0, 120)
end)

-- 3. SHOP UI
local shopFrame = Instance.new("Frame")
shopFrame.Size = UDim2.new(0, 500, 0, 400)
shopFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
shopFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
shopFrame.Visible = false
shopFrame.Parent = screenGui
Instance.new("UICorner", shopFrame).CornerRadius = UDim.new(0, 16)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = shopFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function() shopFrame.Visible = false end)

-- Toggle Button
local shopToggle = Instance.new("TextButton")
shopToggle.Size = UDim2.new(0, 80, 0, 50)
shopToggle.Position = UDim2.new(0, 20, 0.5, -25)
shopToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
shopToggle.Text = "SHOP"
shopToggle.Parent = screenGui
Instance.new("UICorner", shopToggle).CornerRadius = UDim.new(0, 12)

shopToggle.MouseButton1Click:Connect(function() shopFrame.Visible = not shopFrame.Visible end)

-- Tabs Container
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 50)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = shopFrame

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -70)
contentContainer.Position = UDim2.new(0, 10, 0, 60)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = shopFrame

-- Function to create Tab Content
local currentTabFrame = nil

local function showTab(name, items)
    if currentTabFrame then currentTabFrame:Destroy() end
    
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = contentContainer
    currentTabFrame = frame
    
    local list = Instance.new("UIGridLayout", frame)
    list.CellSize = UDim2.new(0, 140, 0, 140)
    list.CellPadding = UDim2.new(0, 10, 0, 10)
    
    for _, item in ipairs(items) do
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        btn.Text = ""
        btn.Parent = frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.6, 0)
        label.BackgroundTransparency = 1
        label.Text = item.Name .. "\n$" .. item.Price
        label.TextColor3 = Color3.new(1,1,1)
        label.TextSize = 18
        label.TextWrapped = true
        label.Parent = btn
        
        local actionText = Instance.new("TextLabel")
        actionText.Size = UDim2.new(1, 0, 0.3, 0)
        actionText.Position = UDim2.new(0, 0, 0.7, 0)
        actionText.BackgroundTransparency = 1
        actionText.Text = "BUY"
        actionText.TextColor3 = Color3.fromRGB(100, 255, 100)
        actionText.Font = Enum.Font.GothamBold
        actionText.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            item.Callback()
        end)
    end
end

-- Define Tabs
local TABS = {
    { Name = "Robux", Items = {
        { Name = "100 Coins", Price = "50 R$", Callback = function() MarketplaceService:PromptProductPurchase(player, 12345678) end },
        { Name = "VIP Pass", Price = "100 R$", Callback = function() MarketplaceService:PromptGamePassPurchase(player, 87654321) end },
    }},
    { Name = "Pets", Items = {
        { Name = "Random Egg", Price = "100 Coins", Callback = function() 
            if HatchFunction then
                local result = HatchFunction:InvokeServer()
                if result then print("Hatched: " .. result) end
            end
        end},
    }},
    { Name = "Items", Items = {
        { Name = "Speed Coil", Price = "500 Coins", Callback = function() 
            if PurchaseGear then PurchaseGear:InvokeServer("Speed") end
        end},
        { Name = "Jump Coil", Price = "1000 Coins", Callback = function() 
            if PurchaseGear then PurchaseGear:InvokeServer("Jump") end
        end},
    }},
}

-- Create Tab Buttons
for _, tabData in ipairs(TABS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = tabData.Name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = tabContainer
    
    btn.MouseButton1Click:Connect(function()
        showTab(tabData.Name, tabData.Items)
    end)
end

-- Default Tab
showTab("Pets", TABS[2].Items)
