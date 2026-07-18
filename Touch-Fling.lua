--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Touch Fling",
    Text = "By HKTD",
	Icon = "rbxassetid://132292718620518",
    Duration = 5
})

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Objects
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local HeaderFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

-- ScreenGui Settings
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame Settings
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
MainFrame.Size = UDim2.new(0, 158, 0, 110)

-- Header Settings
HeaderFrame.Parent = MainFrame
HeaderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Size = UDim2.new(0, 158, 0, 25)

-- Title Settings
TitleLabel.Parent = HeaderFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.BorderSizePixel = 0
TitleLabel.Position = UDim2.new(0.112792775, 0, -0.0151660154, 0)
TitleLabel.Size = UDim2.new(0, 121, 0, 26)
TitleLabel.Font = Enum.Font.Sarpanch
TitleLabel.Text = "Touch Fling"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 25

-- Button Settings
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.113924049, 0, 0.418181807, 0)
ToggleButton.Size = UDim2.new(0, 121, 0, 37)
ToggleButton.Font = Enum.Font.SourceSansItalic
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextSize = 20

-- Make GUI Draggable
MainFrame.Active = true
MainFrame.Draggable = true

-- Fling System
local flingEnabled = false
local flingThread
local moveValue = 0.1

local function StartFling()
	local Character
	local HumanoidRootPart
	local OldVelocity
	while flingEnabled do
		RunService.Heartbeat:Wait()
		Character = LocalPlayer.Character
		HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart then
			OldVelocity = HumanoidRootPart.Velocity
			HumanoidRootPart.Velocity =
				OldVelocity * 10000 + Vector3.new(0, 10000, 0)
			RunService.RenderStepped:Wait()
			HumanoidRootPart.Velocity = OldVelocity
			RunService.Stepped:Wait()
			HumanoidRootPart.Velocity =
				OldVelocity + Vector3.new(0, moveValue, 0)
			moveValue = -moveValue
		end
	end
end

-- Button Function
ToggleButton.MouseButton1Click:Connect(function()
	flingEnabled = not flingEnabled
	if flingEnabled then
		ToggleButton.Text = "ON"
		flingThread = coroutine.create(StartFling)
		coroutine.resume(flingThread)
	else
		ToggleButton.Text = "OFF"
	end
end)
