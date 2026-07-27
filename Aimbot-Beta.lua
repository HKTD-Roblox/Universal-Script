local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local aimbotEnabled = false
local aimbotFOV = 30
local aimbotRange = 1000000
local trackingSmoothness = 0.15
local targetPart = "Head"
local teamCheck = true

local Window = Library:NewWindow("Aimbot Script")
local MainSection = Window:NewSection("Settings")

MainSection:CreateToggle("Enable Aimbot", function(value)
    aimbotEnabled = value
end)

MainSection:CreateTextbox("Aimbot FOV Radius [Max INF]", function(text)
    local value = tonumber(text)
    if value and value >= 1 then
        aimbotFOV = value
    end
end)

MainSection:CreateTextbox("Aimbot Range [Max 1.000.000]", function(text)
    local value = tonumber(text)
    if value and value >= 1 and value <= 1000000 then
        aimbotRange = value
    end
end)

local function GetClosestPlayer()
    local target = nil
    local shortestAngle = aimbotFOV
    local cameraCFrame = camera.CFrame
    local cameraLookVector = cameraCFrame.LookVector

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not teamCheck or (player.Team ~= LocalPlayer.Team) then
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                    local part = character:FindFirstChild(targetPart)
                    if part then
                        local distance3D = (cameraCFrame.Position - part.Position).Magnitude
                        if distance3D <= aimbotRange then
                            local directionToTarget = (part.Position - cameraCFrame.Position).Unit
                            local dotProduct = cameraLookVector:Dot(directionToTarget)
                            dotProduct = math.clamp(dotProduct, -1, 1)
                            local angle = math.deg(math.acos(dotProduct))

                            if angle <= shortestAngle then
                                local _, onScreen = camera:WorldToViewportPoint(part.Position)
                                if onScreen then
                                    shortestAngle = angle
                                    target = part
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return target
end

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then return end

    local target = GetClosestPlayer()
    if target then
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
        camera.CFrame = currentCFrame:Lerp(targetCFrame, trackingSmoothness)
    end
end)
