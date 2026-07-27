local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FPS_PING"

if game:GetService("CoreGui"):FindFirstChild("NinjaHub_FastFlags_V1_5") then
    game:GetService("CoreGui").NinjaHub_FastFlags_V1_5:Destroy()
end

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Theme = {
    BG = Color3.fromRGB(15, 15, 20),
    Accent = Color3.fromRGB(0, 255, 150),
    Txt = Color3.fromRGB(255, 255, 255)
}

local statsLocked = true
local function makeDraggable(obj, isStats)
    local dragging, dragInput, dragStart, startPos

    obj.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if isStats and statsLocked then
                    return
                end

                dragging = true
                dragStart = input.Position
                startPos = obj.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end
                )
            end
        end
    )

    obj.InputChanged:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end
    )

    RunService.RenderStepped:Connect(
        function()
            if dragging and dragInput then
                local delta = dragInput.Position - dragStart
                obj.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    )
end

local statsFrame = Instance.new("Frame", ScreenGui)
statsFrame.Size = UDim2.new(0, 180, 0, 45)
statsFrame.Position = UDim2.new(0.5, -90, 0, 10)
statsFrame.BackgroundColor3 = Theme.BG
statsFrame.BackgroundTransparency = 1
statsFrame.BorderSizePixel = 0

Instance.new("UICorner", statsFrame)
makeDraggable(statsFrame, true)

local pL = Instance.new("TextLabel", statsFrame)
pL.Size = UDim2.new(1, 0, 0.5, 0)
pL.BackgroundTransparency = 1
pL.TextSize = 16
pL.TextColor3 = Theme.Accent
pL.Font = Enum.Font.Arcade
pL.Active = false

local fL = Instance.new("TextLabel", statsFrame)
fL.Size = UDim2.new(1, 0, 0.5, 0)
fL.Position = UDim2.new(0, 0, 0.5, 0)
fL.BackgroundTransparency = 1
fL.TextSize = 16
fL.TextColor3 = Theme.Txt
fL.Font = Enum.Font.Arcade
fL.Active = false

task.spawn(
    function()
        while true do
            local fps = math.round(1 / RunService.RenderStepped:Wait())
            local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

            pL.Text = "PING: " .. ping .. "MS"
            fL.Text = "FPS: " .. fps

            task.wait(0.5)
        end
    end
)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local Window = Library:NewWindow("Fix Lag Script")

local fixLagEnabled = false

local CreditsSection = Window:NewSection("Make By HKTD")

CreditsSection:NewToggle("Fix Lag", "Loading...", function(state)
    fixLagEnabled = state
    
    if fixLagEnabled then
        
        task.spawn(function()
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("DataModelMesh") or v:IsA("CharacterMesh") or v:IsA("MeshPart") or v:IsA("Texture") or v:IsA("Decal") then
                    v:Destroy()
                end
            end
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end

            if setfpscap then
                setfpscap(999)
            end

            pcall(function()
                settings().Rendering.QualityLevel = 1
            end)
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("MeshPart") then
                    v.LevelOfDetail = Enum.ModelLevelOfDetail.Low
                end
            end

            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") then
                    v.Enabled = false
                end
            end

            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("BasePart") and not v.Anchored then
                    v:Destroy()
                end
            end

            pcall(function()
                settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always
            end)

            local Lighting = game:GetService("Lighting")
            Lighting.FogEnd = 9e9
            Lighting.GlobalShadows = false
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                end
            end

            print("🚀 Fix Lag On!")
        end)
    else
        print("🛑 Fix Lag Off!")
    end
end)
