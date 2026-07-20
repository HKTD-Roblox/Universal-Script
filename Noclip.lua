--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local noclip = false
local connection

loadstring(game:HttpGet("https://raw.githubusercontent.com/HKTD-Roblox/Script-Beta/refs/heads/main/Script-By-HKTD.lua", true))()

local function toggleNoclip()
    noclip = not noclip
    if noclip then
        connection =
            RunService.Stepped:Connect(
            function()
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        )

        notify("Noclip On, Script by HKTD!")
    else
        if connection then
            connection:Disconnect()
        end

        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end

        notify("Noclip Off, Script by HKTD!")
    end
end

local function createTool()
    local tool = Instance.new("Tool")
    tool.Name = "Noclip"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.Parent = player:WaitForChild("Backpack")
    tool.Activated:Connect(
        function()
            toggleNoclip()
        end
    )
end

local function onCharacterAdded()
    task.wait(0.1)
    createTool()
end

if player.Character then
    onCharacterAdded()
end

player.CharacterAdded:Connect(onCharacterAdded)
