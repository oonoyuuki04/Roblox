--[[
    Script: VIPDoorScript
    Purpose: Checks if a player owns the VIP GamePass when touching a door. Teleports if true, prompts purchase if false.
    Location: Workspace > VIP_Door (Part) > Script
    Make sure to create a part named "VIP_Door" and put this script inside.
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local doorPart = script.Parent
local VIP_GAMEPASS_ID = 87654321 -- Replace with your Game Pass ID

local debouce = {} -- Prevent spamming the prompt

doorPart.Touched:Connect(function(hit)
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    
    if player then
        if debouce[player.UserId] then return end
        debouce[player.UserId] = true

        local success, hasPass = pcall(function()
            return MarketplaceService:UserOwnsGamePassAsync(player.UserId, VIP_GAMEPASS_ID)
        end)

        if success and hasPass then
            -- Player has VIP! Open door or teleport.
            print("Welcome VIP member: " .. player.Name)
            doorPart.CanCollide = false
            task.wait(1)
            doorPart.CanCollide = true
        else
            -- Player does NOT have VIP. Prompt them to buy it!
            print("Prompting VIP purchase for: " .. player.Name)
            MarketplaceService:PromptGamePassPurchase(player, VIP_GAMEPASS_ID)
        end
        
        task.wait(2)
        debouce[player.UserId] = nil
    end
end)
