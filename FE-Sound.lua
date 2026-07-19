--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FE Sound",
    Text = "By HKTD",
	Icon = "rbxassetid://123653870026944",
    Duration = 5
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FeSound"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 270, 0, 430)
main.Position = UDim2.new(0.5, -135, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "FE Sound By HKTD"
title.BackgroundColor3 = Color3.fromRGB(45, 55, 75)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local function makeSoundButton(name, id, y)
	local sound = Instance.new("Sound", workspace)
	sound.SoundId = "rbxassetid://" .. id
	sound.Volume = 10
	sound.Looped = false
	game:GetService("Debris"):AddItem(sound, 600)

	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(0.6, 0, 0, 30)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.AutoButtonColor = true
	btn.MouseButton1Click:Connect(function()
		sound:Play()
	end)

	local loop = Instance.new("TextButton", main)
	loop.Size = UDim2.new(0.25, 0, 0, 30)
	loop.Position = UDim2.new(0.7, 0, 0, y)
	loop.Text = "Loop: OFF"
	loop.BackgroundColor3 = Color3.fromRGB(120, 180, 100)
	loop.TextColor3 = Color3.new(1, 1, 1)
	loop.Font = Enum.Font.Gotham
	loop.TextSize = 12
	loop.MouseButton1Click:Connect(function()
		sound.Looped = not sound.Looped
		loop.Text = "Loop: " .. (sound.Looped and "ON" or "OFF")
	end)
end

makeSoundButton("Wooo Alarm", "9081625499", 50)
makeSoundButton("Nuke Alarm", "433848566", 90)
makeSoundButton("Scary Laugh", "7854285068", 130)
makeSoundButton("Jumpscare Loud", "7236490488", 170)
makeSoundButton("TicTac Jumpscare", "5710016194", 210)
makeSoundButton("Bomb Explosion", "165969964", 250)

local customLabel = Instance.new("TextLabel", main)
customLabel.Size = UDim2.new(0.9, 0, 0, 20)
customLabel.Position = UDim2.new(0.05, 0, 0, 290)
customLabel.Text = "Custom Sound ID"
customLabel.BackgroundTransparency = 1
customLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
customLabel.Font = Enum.Font.GothamSemibold
customLabel.TextSize = 12
customLabel.TextXAlignment = Enum.TextXAlignment.Left

local input = Instance.new("TextBox", main)
input.PlaceholderText = "1234567890"
input.Size = UDim2.new(0.6, 0, 0, 30)
input.Position = UDim2.new(0.05, 0, 0, 310)
input.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.Gotham
input.TextSize = 14

local play = Instance.new("TextButton", main)
play.Size = UDim2.new(0.25, 0, 0, 30)
play.Position = UDim2.new(0.7, 0, 0, 310)
play.Text = "Play"
play.BackgroundColor3 = Color3.fromRGB(80, 160, 240)
play.TextColor3 = Color3.new(1, 1, 1)
play.Font = Enum.Font.GothamBold
play.TextSize = 14

local loop = false
local loopToggle = Instance.new("TextButton", main)
loopToggle.Size = UDim2.new(0.9, 0, 0, 25)
loopToggle.Position = UDim2.new(0.05, 0, 0, 350)
loopToggle.Text = "Custom Loop: OFF"
loopToggle.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
loopToggle.TextColor3 = Color3.new(1, 1, 1)
loopToggle.Font = Enum.Font.Gotham
loopToggle.TextSize = 12
loopToggle.MouseButton1Click:Connect(function()
	loop = not loop
	loopToggle.Text = "Custom Loop: " .. (loop and "ON" or "OFF")
end)

play.MouseButton1Click:Connect(function()
	if tonumber(input.Text) then
		local s = Instance.new("Sound", workspace)
		s.SoundId = "rbxassetid://" .. input.Text
		s.Volume = 10
		s.Looped = loop
		s:Play()
		game:GetService("Debris"):AddItem(s, 600)
	end
end)
