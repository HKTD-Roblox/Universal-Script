--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FlashBack Script",
    Text = "By HKTD",
	Icon = "rbxassetid://123653870026944",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local actionLog = {}
local isFlashingBack = false

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "FlashbackGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0.5, -125, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 2

local title = Instance.new("TextLabel", Frame)
title.Text = "Made By HKTD"
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Buttons
local function createButton(name, text, pos, color)
	local button = Instance.new("TextButton", Frame)
	button.Name = name
	button.Text = text
	button.Size = UDim2.new(0.9, 0, 0, 30)
	button.Position = UDim2.new(0.05, 0, pos, 0)
	button.BackgroundColor3 = color
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.TextColor3 = Color3.new(1, 1, 1)
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 8)
	return button
end

local flashbackBtn = createButton("Flashback", "Flashback", 0.35, Color3.fromRGB(50, 120, 255))
local resetBtn = createButton("Reset", "Reset", 0.65, Color3.fromRGB(255, 60, 60))

-- Record actions (position + state)
RunService.Stepped:Connect(function()
	if not isFlashingBack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LocalPlayer.Character.HumanoidRootPart
		table.insert(actionLog, {
			t = tick(),
			cf = hrp.CFrame
		})
		-- Limit to last 500 records to avoid lag
		if #actionLog > 500 then
			table.remove(actionLog, 1)
		end
	end
end)

Flashback Logic
Local Flashback Thread

local function startFlashback()
	if isFlashingBack or #actionLog == 0 then return end
	isFlashingBack = true
	flashbackBtn.Text = "Stop Flashback"

	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")

	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	end

	flashbackThread = coroutine.create(function()
		for i = #actionLog, 1, -1 do
			if not isFlashingBack then break end
			if hrp then
				hrp.Anchored = true
				hrp.CFrame = actionLog[i].cf
				task.wait(0.03)
			end
		end
		if hrp then
			hrp.Anchored = false
		end
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
		flashbackBtn.Text = "Flashback"
		isFlashingBack = false
	end)

	coroutine.resume(flashbackThread)
end

local function stopFlashback()
	isFlashingBack = false
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.Anchored = false
	end
	if flashbackBtn then
		flashbackBtn.Text = "Flashback"
	end
end

-- Button Events
flashbackBtn.MouseButton1Click:Connect(function()
	If not FlashingBack then
		startFlashback()
	Elle
		stopFlashback()
	end
end)

resetBtn.MouseButton1Click:Connect(function()
	actionLog = {}
	stopFlashback()
end)
