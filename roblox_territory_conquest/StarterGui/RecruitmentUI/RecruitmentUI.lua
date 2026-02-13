--[[
    LocalScript: RecruitmentUI
    Purpose: Handles the 'Audience' animation (Fusuma opening) and 'Warlord Appraisal' UI.
    Location: StarterGui > RecruitmentUI (LocalScript)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Remotes
local ScoutFunction = ReplicatedStorage:WaitForChild("ScoutTalent")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RecruitmentUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- --- 1. AUDIENCE HALL (Fusuma Animation) ---
local audienceFrame = Instance.new("Frame")
audienceFrame.Size = UDim2.new(1, 0, 1, 0)
audienceFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
audienceFrame.Visible = false
audienceFrame.ZIndex = 10 -- Top layer
audienceFrame.Parent = screenGui

-- Left Fusuma (Door)
local fusumaLeft = Instance.new("ImageLabel")
fusumaLeft.Size = UDim2.new(0.5, 0, 1, 0)
fusumaLeft.Position = UDim2.new(0, 0, 0, 0)
fusumaLeft.BackgroundColor3 = Color3.fromRGB(200, 180, 140) -- Beige paper color
fusumaLeft.Image = "rbxassetid://12345678" -- Placeholder for Fusuma texture
fusumaLeft.Parent = audienceFrame
-- Frame (Wood)
local fl_border = Instance.new("Frame", fusumaLeft)
fl_border.Size = UDim2.new(1, 0, 1, 0)
fl_border.BackgroundTransparency = 1
fl_border.BorderSizePixel = 5
fl_border.BorderColor3 = Color3.fromRGB(50, 20, 0) -- Dark wood

-- Right Fusuma (Door)
local fusumaRight = fusumaLeft:Clone()
fusumaRight.Position = UDim2.new(0.5, 0, 0, 0)
fusumaRight.Parent = audienceFrame

-- Warlord Silhouette (Hidden behind doors)
local warlordImage = Instance.new("ImageLabel")
warlordImage.Size = UDim2.new(0.4, 0, 0.8, 0)
warlordImage.Position = UDim2.new(0.3, 0, 0.1, 0)
warlordImage.BackgroundTransparency = 1
warlordImage.ImageTransparency = 1 -- Start invisible
warlordImage.Image = "rbxassetid://0" -- Dynamic
warlordImage.Parent = audienceFrame

-- --- 2. SCROLL UI (Appraisal Result) ---
local scrollFrame = Instance.new("ImageLabel") -- The Scroll background
scrollFrame.Size = UDim2.new(0, 400, 0, 600)
scrollFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
scrollFrame.BackgroundColor3 = Color3.fromRGB(240, 230, 200) -- Parchment
scrollFrame.Image = "rbxassetid://98765432" -- Scroll texture
scrollFrame.Visible = false
scrollFrame.Parent = screenGui

local scrollCorner = Instance.new("UICorner", scrollFrame)
scrollCorner.CornerRadius = UDim.new(0, 20)

-- Name (Ink Brush Style)
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0.15, 0)
nameLabel.Position = UDim2.new(0, 0, 0.1, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Lu Bu"
nameLabel.TextColor3 = Color3.fromRGB(20, 20, 20) -- Ink black
nameLabel.Font = Enum.Font.Sarpanch -- Rough/Brush style
nameLabel.TextSize = 40
nameLabel.Parent = scrollFrame

-- Stats (Might / Intellect)
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0.8, 0, 0.3, 0)
statsFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
statsFrame.BackgroundTransparency = 1
statsFrame.Parent = scrollFrame

local mightLabel = Instance.new("TextLabel")
mightLabel.Size = UDim2.new(1, 0, 0.5, 0)
mightLabel.BackgroundTransparency = 1
mightLabel.Text = "武力 (Might): 100"
mightLabel.TextColor3 = Color3.fromRGB(150, 0, 0) -- War Red
mightLabel.Font = Enum.Font.SourceSansBold
mightLabel.TextSize = 25
mightLabel.Parent = statsFrame

local intLabel = Instance.new("TextLabel")
intLabel.Size = UDim2.new(1, 0, 0.5, 0)
intLabel.Position = UDim2.new(0, 0, 0.5, 0)
intLabel.BackgroundTransparency = 1
intLabel.Text = "知力 (Intellect): 30"
intLabel.TextColor3 = Color3.fromRGB(0, 0, 150) -- Strategy Blue
intLabel.Font = Enum.Font.SourceSansBold
intLabel.TextSize = 25
intLabel.Parent = statsFrame

-- Description (Commentary)
local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
descLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
descLabel.BackgroundTransparency = 1
descLabel.Text = "天下無双の豪傑なり。"
descLabel.TextColor3 = Color3.fromRGB(50, 50, 50)
descLabel.Font = Enum.Font.Antique
descLabel.TextWrapped = true
descLabel.TextSize = 20
descLabel.Parent = scrollFrame

-- Close / Accept Button (Seal)
local sealBtn = Instance.new("TextButton")
sealBtn.Size = UDim2.new(0, 100, 0, 100)
sealBtn.Position = UDim2.new(0.5, -50, 0.8, 0)
sealBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red Seal Ink
sealBtn.Text = "承認 (Decline? No)"
sealBtn.TextColor3 = Color3.new(1,1,1)
sealBtn.Font = Enum.Font.FredokaOne -- Should look like a stamp
sealBtn.Parent = scrollFrame
Instance.new("UICorner", sealBtn).CornerRadius = UDim.new(1, 0) -- Circle

sealBtn.MouseButton1Click:Connect(function()
    scrollFrame.Visible = false
    audienceFrame.Visible = false
    -- Reset animation
    fusumaLeft.Position = UDim2.new(0, 0, 0, 0)
    fusumaRight.Position = UDim2.new(0.5, 0, 0, 0)
    warlordImage.ImageTransparency = 1
end)

-- --- 3. TRIGGER BUTTON (Scout) ---
local scoutBtn = Instance.new("TextButton")
scoutBtn.Size = UDim2.new(0, 150, 0, 60)
scoutBtn.Position = UDim2.new(0, 20, 0.5, 0)
scoutBtn.BackgroundColor3 = Color3.fromRGB(139, 69, 19) -- Wood
scoutBtn.Text = "登用 (Scout)"
scoutBtn.TextColor3 = Color3.new(1,1,1)
scoutBtn.Font = Enum.Font.Sarpanch
scoutBtn.TextSize = 24
scoutBtn.Parent = screenGui
Instance.new("UICorner", scoutBtn).CornerRadius = UDim.new(0, 8)

-- Animation Logic
scoutBtn.MouseButton1Click:Connect(function()
    -- 1. Show Closed Fusuma
    audienceFrame.Visible = true
    fusumaLeft.Position = UDim2.new(0, 0, 0, 0)
    fusumaRight.Position = UDim2.new(0.5, 0, 0, 0)
    warlordImage.ImageTransparency = 1
    
    -- 2. Call Server (Wait for result)
    local result = ScoutFunction:InvokeServer()
    if not result then 
        audienceFrame.Visible = false
        return 
    end
    
    -- 3. Update UI Data
    nameLabel.Text = result.Name .. " [" .. result.Rank .. "]"
    mightLabel.Text = "武力: " .. result.Might
    intLabel.Text = "知力: " .. result.Intellect
    descLabel.Text = result.Desc or "詳細は不明"
    
    -- 4. Play Animation
    task.wait(0.5)
    
    -- Open Doors
    local tInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    TweenService:Create(fusumaLeft, tInfo, {Position = UDim2.new(-0.4, 0, 0, 0)}):Play()
    TweenService:Create(fusumaRight, tInfo, {Position = UDim2.new(0.9, 0, 0, 0)}):Play()
    
    -- Reveal Warlord (Fade In)
    task.wait(1.0)
    TweenService:Create(warlordImage, tInfo, {ImageTransparency = 0}):Play()
    
    -- Show Scroll (Result)
    task.wait(1.5)
    scrollFrame.Visible = true
    
    -- Sound Effect would go here (Ta-da!)
end)
