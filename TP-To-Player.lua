--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "TELEPORT TO PLAYER",
    Text = "By HKTD",
	  Icon = "rbxassetid://123653870026944",
    Duration = 5
})

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- 1. Main ScreenGui Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AshishHub_TPMenu"
local success, err = pcall(function()
	ScreenGui.Parent = CoreGui
end)
if not success then
	ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end

-- 2. Main Background Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Drag karne ke liye
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = MainFrame

-- 3. Title/Credit Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleLabel.Text = "⚡ TELEPORT TO PLAYER"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold Text
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 10, 0, 0) -- Thoda left side shift kiya button ke liye space banane ko
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = MainFrame

-- Top bar background jiske corner round rahein
local TopBarBg = Instance.new("Frame")
TopBarBg.Size = UDim2.new(1, 0, 0, 40)
TopBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TopBarBg.BorderSizePixel = 0
TopBarBg.ZIndex = 0
TopBarBg.Parent = MainFrame
local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = TopBarBg

-- Sub-credit text
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 15)
SubTitle.Position = UDim2.new(0, 0, 0, 38)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Made By HKTD | TikTok: @hktd_roblox"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
SubTitle.Font = Enum.Font.SourceSansItalic
SubTitle.TextSize = 11
SubTitle.Parent = MainFrame

-- 4. Scrolling Frame (Player List)
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(0, 210, 0, 245)
PlayerList.Position = UDim2.new(0, 10, 0, 60)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = MainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = PlayerList
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	PlayerList.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 10)
end)

-- =======================================================
--  MINIMIZE BUTTON SYSTEM
-- =======================================================
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -40, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 18
MinimizeButton.ZIndex = 2
MinimizeButton.Parent = MainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinimizeButton

local isMinimized = false

MinimizeButton.MouseButton1Click:Connect(function()
	if not isMinimized then
		-- Menu chota karo (Minimize)
		PlayerList.Visible = false
		SubTitle.Visible = false
		MainFrame:TweenSize(UDim2.new(0, 230, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
		MinimizeButton.Text = "+"
		isMinimized = true
	else
		-- Menu bada karo (Maximize)
		MainFrame:TweenSize(UDim2.new(0, 230, 0, 320), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true, function()
			PlayerList.Visible = true
			SubTitle.Visible = true
		end)
		MinimizeButton.Text = "-"
		isMinimized = false
	end
end)

-- =======================================================
--  PLAYER SCANNER FUNCTION
-- =======================================================
local function refreshPlayerList()
	for _, child in ipairs(PlayerList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 38)
			btn.Text = " " .. player.Name
			btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.GothamMedium
			btn.TextSize = 13
			btn.BorderSizePixel = 0
			btn.Parent = PlayerList
			
			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 6)
			btnCorner.Parent = btn

			btn.MouseButton1Click:Connect(function()
				if player.Character and localPlayer.Character then
					local myRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")

					if myRoot and targetRoot then
						myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
					end
				end
			end)
		end
	end
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
