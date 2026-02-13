--[[
    LocalScript: WarlordCombatClient
    Purpose: Handles user input (Left Click) to trigger attacks and play animations.
    Location: StarterPlayer > StarterPlayerScripts
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local AttackEvent = ReplicatedStorage:WaitForChild("PerformAttack")

-- Animation IDs (Standard Roblox R15 Animations)
-- Replace with custom sword swings for better feel
local SWORD_SLASH_ANIM = "rbxassetid://12345678" 

local isAttacking = false
local COOLDOWN = 0.6

-- Input Handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Don't attack if clicking UI
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if isAttacking then return end
        isAttacking = true
        
        -- 1. Play Animation
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            local animator = hum:FindFirstChild("Animator") or hum:WaitForChild("Animator")
            
            -- Ideally load animation track once, but simplified here
            -- local track = animator:LoadAnimation(script.SlashAnimation)
            -- track:Play()
            
            -- Visual Swing (Tween Hand if no animation asset)
            local tool = char:FindFirstChildOfClass("Tool") -- If holding a tool
            -- Or just swing arm
        end
        
        -- 2. Send Request
        AttackEvent:FireServer("Sword")
        
        -- 3. Visual FX (Camera Shake?)
        
        task.wait(COOLDOWN)
        isAttacking = false
    end
end)
