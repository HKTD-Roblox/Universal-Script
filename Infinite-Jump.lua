--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

loadstring(game:HttpGet("https://raw.githubusercontent.com/HKTD-Roblox/Script-Beta/refs/heads/main/Script-By-HKTD.lua", true))()

-- Infinite Jump GUI
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local InfiniteJump = false
local Minimized = false

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 160)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0
Main.ZIndex = 1

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Top Bar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
Top.BorderSizePixel = 0
Top.ZIndex = 2

-- Title
local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Infinite Jump"
Title.TextColor3 = Color3.fromRGB(255, 230, 230)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3

-- Minimize Button
local MinBtn = Instance.new("TextButton", Top)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 2)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
MinBtn.BorderSizePixel = 0
MinBtn.ZIndex = 3
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

-- Close Button
local CloseBtn = Instance.new("TextButton", Top)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 3
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- Toggle Button
local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0.8, 0, 0, 45)
Toggle.Position = UDim2.new(0.1, 0, 0.45, 0)
Toggle.Text = "Infinite Jump : OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 15
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Toggle.BorderSizePixel = 0
Toggle.ZIndex = 2
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)

-- Credit
local Credit = Instance.new("TextLabel", Main)
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.Position = UDim2.new(0, 0, 1, -22)
Credit.BackgroundTransparency = 1
Credit.Text = "Made By HKTD"
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 12
Credit.TextColor3 = Color3.fromRGB(200, 200, 200)
Credit.ZIndex = 2

-- Toggle Logic + Animation
Toggle.MouseButton1Click:Connect(function()
	InfiniteJump = not InfiniteJump

	TweenService:Create(
		Toggle,
		TweenInfo.new(0.15),
		{Size = UDim2.new(0.82, 0, 0, 48)}
	):Play()

	task.delay(0.15, function()
		TweenService:Create(
			Toggle,
			TweenInfo.new(0.15),
			{Size = UDim2.new(0.8, 0, 0, 45)}
		):Play()
	end)

	if InfiniteJump then
		Toggle.Text = "Infinite Jump : ON"
		Toggle.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	else
		Toggle.Text = "Infinite Jump : OFF"
		Toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	end
end)

-- Minimize Logic
MinBtn.MouseButton1Click:Connect(function()
	Minimized = not Minimized

	if Minimized then
		Toggle.Visible = false
		Credit.Visible = false
		TweenService:Create(
			Main,
			TweenInfo.new(0.25),
			{Size = UDim2.new(0, 260, 0, 40)}
		):Play()
	else
		TweenService:Create(
			Main,
			TweenInfo.new(0.25),
			{Size = UDim2.new(0, 260, 0, 160)}
		):Play()
		task.delay(0.2, function()
			Toggle.Visible = true
			Credit.Visible = true
		end)
	end
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if InfiniteJump then
		local Char = Player.Character
		if Char then
			local Humanoid = Char:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)
