--[[
    Service: PetManager
    Purpose: Handles hatching, inventory, and equipping pets.
    Location: ServerScriptService
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PetInventoryStore = DataStoreService:GetDataStore("PetInventory_v1")

local EGG_COST = 100

local PET_STATS = {
    Cat = { Multiplier = 1.2, Color = Color3.fromRGB(255, 170, 0), Chance = 50 },
    Dog = { Multiplier = 1.3, Color = Color3.fromRGB(139, 69, 19), Chance = 30 },
    Dragon = { Multiplier = 2.0, Color = Color3.fromRGB(200, 0, 0), Chance = 10 },
    Dominus = { Multiplier = 5.0, Color = Color3.fromRGB(0, 0, 0), Chance = 1 } -- Legendary!
}

local equippedPets = {} -- runtime cache [UserId] = nil or pet model

-- Helper to make a simple pet model
local function createPetModel(petName)
    local petPart = Instance.new("Part")
    petPart.Name = petName
    petPart.Size = Vector3.new(2, 2, 2)
    petPart.Material = Enum.Material.Neon
    petPart.CanCollide = false
    petPart.Color = PET_STATS[petName].Color
    
    local bodyPos = Instance.new("BodyPosition", petPart)
    bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyPos.D = 500
    
    local bodyGyro = Instance.new("BodyGyro", petPart)
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    
    return petPart
end

-- Equip Logic
local function equipPet(player, petName)
    if equippedPets[player.UserId] then
        equippedPets[player.UserId]:Destroy()
    end
    
    local character = player.Character or player.CharacterAdded:Wait()
    local petModel = createPetModel(petName)
    petModel.Parent = character
    equippedPets[player.UserId] = petModel
    
    -- Movement Loop
    task.spawn(function()
        while petModel.Parent and character.Parent do
            local goalPos = character.HumanoidRootPart.Position + Vector3.new(3, 2, 3)
            petModel.BodyPosition.Position = goalPos
            petModel.BodyGyro.CFrame = character.HumanoidRootPart.CFrame
            task.wait()
        end
    end)
    
    -- Apply boost
    local ls = player:FindFirstChild("leaderstats")
    -- (Ideally pass multiplier to ClickerManager, for now just visual/ownership)
    print(player.Name .. " equipped " .. petName .. " (x" .. PET_STATS[petName].Multiplier .. ")")
end

-- Purchase Function
local HatchFunction = Instance.new("RemoteFunction")
HatchFunction.Name = "HatchEgg"
HatchFunction.Parent = ReplicatedStorage

HatchFunction.OnServerInvoke = function(player)
    local ls = player:FindFirstChild("leaderstats")
    if not ls then return nil end
    local money = ls.Money
    
    if money.Value < EGG_COST then
        return nil, "Not enough Money!"
    end
    
    money.Value = money.Value - EGG_COST
    
    -- Lottery
    local roll = math.random(1, 100)
    local hatch = "Cat"
    if roll > 99 then hatch = "Dominus"
    elseif roll > 89 then hatch = "Dragon"
    elseif roll > 50 then hatch = "Dog"
    end
    
    -- Save to DataStore (Simplified for now - just append to a list)
    local success, inventory = pcall(function()
        return PetInventoryStore:GetAsync(player.UserId) or {}
    end)
    
    if success then
        table.insert(inventory, hatch)
        pcall(function() PetInventoryStore:SetAsync(player.UserId, inventory) end)
    end
    
    equipPet(player, hatch)
    return hatch
end

-- Load Pets on Join
Players.PlayerAdded:Connect(function(player)
    local success, inventory = pcall(function()
        return PetInventoryStore:GetAsync(player.UserId)
    end)
    
    if success and inventory and #inventory > 0 then
        -- Auto-equip best pet
        equipPet(player, inventory[#inventory])
    end
end)

return {}
