local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local targetParent = nil
local success, err = pcall(function()
    targetParent = CoreGui
end)
if not success or not targetParent then
    targetParent = player:WaitForChild("PlayerGui", 10)
end
if not targetParent then
    warn("UI Loading Error: Could not resolve a valid parent container.")
    return
end

local camera = workspace.CurrentCamera
local FOV_RADIUS = 150
local MAX_RANGE = 1000000
local TRACKING_SMOOTHNESS = 0.15
local TARGET_PART = "HumanoidRootPart"

local isFeatureEnabled = false
local isMinimized = false
local isHighlightEnabled = false
local isTeamCheckEnabled = true
local isFlyEnabled = false
local isNoclipEnabled = false

local highlightAddedConn = nil
local aimbotAddedConn = nil
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil
local noclipConnection = nil

local COLORS = {
    MainBg = Color3.fromRGB(24, 21, 33),
    TopBar = Color3.fromRGB(15, 13, 20),
    Sidebar = Color3.fromRGB(17, 15, 23),
    CardBg = Color3.fromRGB(38, 34, 53),
    AccentLight = Color3.fromRGB(216, 191, 216), 
    TextMain = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(160, 150, 175),
    ToggleGreen = Color3.fromRGB(0, 200, 115),
    CloseRed = Color3.fromRGB(211, 47, 47),
    MinimizeGrey = Color3.fromRGB(60, 60, 65),
    SliderTrack = Color3.fromRGB(50, 45, 65),
    TabActive = Color3.fromRGB(45, 40, 60),
    DiscordBlurple = Color3.fromRGB(88, 101, 242)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Workspace UI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.Parent = targetParent

local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(0, 480, 0, 360)
mainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
mainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
mainWindow.BackgroundColor3 = COLORS.MainBg
mainWindow.BorderSizePixel = 0
mainWindow.ClipsDescendants = true 
mainWindow.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainWindow

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = COLORS.TopBar
topBar.BorderSizePixel = 0
topBar.Parent = mainWindow

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topBar

local fixFrame = Instance.new("Frame")
fixFrame.Size = UDim2.new(1, 0, 0, 5)
fixFrame.Position = UDim2.new(0, 0, 1, -5)
fixFrame.BackgroundColor3 = COLORS.TopBar
fixFrame.BorderSizePixel = 0
fixFrame.Parent = topBar

local uiTitle = Instance.new("TextLabel")
uiTitle.Name = "UITitle"
uiTitle.Size = UDim2.new(1, -120, 1, 0)
uiTitle.Position = UDim2.new(0, 15, 0, 0)
uiTitle.BackgroundTransparency = 1
uiTitle.Text = "Aimbot Script | By HKTD"
uiTitle.TextColor3 = COLORS.TextMain
uiTitle.Font = Enum.Font.SourceSansBold
uiTitle.TextSize = 22
uiTitle.TextXAlignment = Enum.TextXAlignment.Left
uiTitle.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 24)
closeButton.Position = UDim2.new(1, -38, 0.5, -12)
closeButton.BackgroundColor3 = COLORS.CloseRed
closeButton.Text = "×"
closeButton.TextColor3 = COLORS.TextMain
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 28, 0, 24)
minimizeButton.Position = UDim2.new(1, -72, 0.5, -12)
minimizeButton.BackgroundColor3 = COLORS.MinimizeGrey
minimizeButton.Text = "−"
minimizeButton.TextColor3 = COLORS.TextMain
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18
minimizeButton.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 4)
minimizeCorner.Parent = minimizeButton

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 120, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 55)
sidebar.BackgroundColor3 = COLORS.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = mainWindow

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar

local sidePadding = Instance.new("UIPadding")
sidePadding.PaddingTop = UDim.new(0, 10)
sidePadding.Parent = sidebar

local function createTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "TabBtn"
    btn.Size = UDim2.new(1, -14, 0, 32)
    btn.BackgroundColor3 = COLORS.Sidebar
    btn.Text = name
    btn.TextColor3 = COLORS.TextMain
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.Parent = sidebar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local miscBtn = createTabButton("Misc", 1)
local aimbotBtn = createTabButton("Aimbot", 2)
local espBtn = createTabButton("ESP", 3)
local discordBtn = createTabButton("Discord", 4)

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -150, 1, -60)
container.Position = UDim2.new(0, 140, 0, 55)
container.BackgroundTransparency = 1
container.Parent = mainWindow

local function createTabFrame(name)
    local f = Instance.new("Frame")
    f.Name = name .. "Frame"
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.Parent = container
    return f
end

local miscFrame = createTabFrame("Misc")
local aimbotFrame = createTabFrame("Aimbot")
local espFrame = createTabFrame("ESP")
local discordFrame = createTabFrame("Discord")

local miscLayout = Instance.new("UIListLayout")
miscLayout.Padding = UDim.new(0, 10)
miscLayout.SortOrder = Enum.SortOrder.LayoutOrder
miscLayout.Parent = miscFrame

-- Misc Tab Content (same as before)
local welcomeCard = Instance.new("Frame")
welcomeCard.Name = "WelcomeCard"
welcomeCard.Size = UDim2.new(1, 0, 0, 75)
welcomeCard.BackgroundColor3 = COLORS.CardBg
welcomeCard.LayoutOrder = 1
welcomeCard.Parent = miscFrame

local welcomeCorner = Instance.new("UICorner")
welcomeCorner.CornerRadius = UDim.new(0, 6)
welcomeCorner.Parent = welcomeCard

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, -20, 0, 25)
welcomeTitle.Position = UDim2.new(0, 12, 0, 12)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "Welcome back, " .. player.DisplayName
welcomeTitle.TextColor3 = COLORS.TextMain
welcomeTitle.Font = Enum.Font.SourceSansBold
welcomeTitle.TextSize = 18
welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
welcomeTitle.Parent = welcomeCard

local welcomeDesc = Instance.new("TextLabel")
welcomeDesc.Size = UDim2.new(1, -20, 0, 20)
welcomeDesc.Position = UDim2.new(0, 12, 0, 37)
welcomeDesc.BackgroundTransparency = 1
welcomeDesc.Text = "Press [H] or [F] to quickly minimize this interface frame."
welcomeDesc.TextColor3 = COLORS.TextDark
welcomeDesc.Font = Enum.Font.SourceSans
welcomeDesc.TextSize = 14
welcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
welcomeDesc.Parent = welcomeCard

-- Unlock Cursor Row
local unlockRow = Instance.new("TextButton")
unlockRow.Name = "UnlockCursorRow"
unlockRow.Size = UDim2.new(1, 0, 0, 42)
unlockRow.BackgroundColor3 = COLORS.CardBg
unlockRow.AutoButtonColor = false
unlockRow.Text = ""
unlockRow.LayoutOrder = 2
unlockRow.Parent = miscFrame

local unlockRowCorner = Instance.new("UICorner")
unlockRowCorner.CornerRadius = UDim.new(0, 6)
unlockRowCorner.Parent = unlockRow

local unlockIcon = Instance.new("TextLabel")
unlockIcon.Size = UDim2.new(0, 30, 1, 0)
unlockIcon.Position = UDim2.new(0, 10, 0, 0)
unlockIcon.BackgroundTransparency = 1
unlockIcon.Text = "🖱️"
unlockIcon.TextColor3 = COLORS.AccentLight
unlockIcon.Font = Enum.Font.SourceSansLight
unlockIcon.TextSize = 22
unlockIcon.Parent = unlockRow

local unlockLabel = Instance.new("TextLabel")
unlockLabel.Size = UDim2.new(0, 150, 1, 0)
unlockLabel.Position = UDim2.new(0, 42, 0, 0)
unlockLabel.BackgroundTransparency = 1
unlockLabel.Text = "Unlock cursor (K)"
unlockLabel.TextColor3 = COLORS.TextMain
unlockLabel.Font = Enum.Font.SourceSansBold
unlockLabel.TextSize = 15
unlockLabel.TextXAlignment = Enum.TextXAlignment.Left
unlockLabel.Parent = unlockRow

-- Fly Row
local flyRow = Instance.new("TextButton")
flyRow.Name = "FlyRow"
flyRow.Size = UDim2.new(1, 0, 0, 42)
flyRow.BackgroundColor3 = COLORS.CardBg
flyRow.AutoButtonColor = false
flyRow.Text = ""
flyRow.LayoutOrder = 3
flyRow.Parent = miscFrame

local flyRowCorner = Instance.new("UICorner")
flyRowCorner.CornerRadius = UDim.new(0, 6)
flyRowCorner.Parent = flyRow

local flyIcon = Instance.new("TextLabel")
flyIcon.Size = UDim2.new(0, 30, 1, 0)
flyIcon.Position = UDim2.new(0, 10, 0, 0)
flyIcon.BackgroundTransparency = 1
flyIcon.Text = "✈"
flyIcon.TextColor3 = COLORS.AccentLight
flyIcon.Font = Enum.Font.SourceSansLight
flyIcon.TextSize = 20
flyIcon.Parent = flyRow

local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(0, 150, 1, 0)
flyLabel.Position = UDim2.new(0, 42, 0, 0)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "Fly"
flyLabel.TextColor3 = COLORS.TextMain
flyLabel.Font = Enum.Font.SourceSansBold
flyLabel.TextSize = 15
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.Parent = flyRow

local flyIndicator = Instance.new("Frame")
flyIndicator.Size = UDim2.new(0, 10, 0, 10)
flyIndicator.Position = UDim2.new(1, -25, 0.5, -5)
flyIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
flyIndicator.BorderSizePixel = 0
flyIndicator.Parent = flyRow

local flyIndicatorCorner = Instance.new("UICorner")
flyIndicatorCorner.CornerRadius = UDim.new(1, 0)
flyIndicatorCorner.Parent = flyIndicator

-- Noclip Row
local noclipRow = Instance.new("TextButton")
noclipRow.Name = "NoclipRow"
noclipRow.Size = UDim2.new(1, 0, 0, 42)
noclipRow.BackgroundColor3 = COLORS.CardBg
noclipRow.AutoButtonColor = false
noclipRow.Text = ""
noclipRow.LayoutOrder = 4
noclipRow.Parent = miscFrame

local noclipRowCorner = Instance.new("UICorner")
noclipRowCorner.CornerRadius = UDim.new(0, 6)
noclipRowCorner.Parent = noclipRow

local noclipIcon = Instance.new("TextLabel")
noclipIcon.Size = UDim2.new(0, 30, 1, 0)
noclipIcon.Position = UDim2.new(0, 10, 0, 0)
noclipIcon.BackgroundTransparency = 1
noclipIcon.Text = "👻"
noclipIcon.TextColor3 = COLORS.AccentLight
noclipIcon.Font = Enum.Font.SourceSansLight
noclipIcon.TextSize = 20
noclipIcon.Parent = noclipRow

local noclipLabel = Instance.new("TextLabel")
noclipLabel.Size = UDim2.new(0, 150, 1, 0)
noclipLabel.Position = UDim2.new(0, 42, 0, 0)
noclipLabel.BackgroundTransparency = 1
noclipLabel.Text = "Noclip"
noclipLabel.TextColor3 = COLORS.TextMain
noclipLabel.Font = Enum.Font.SourceSansBold
noclipLabel.TextSize = 15
noclipLabel.TextXAlignment = Enum.TextXAlignment.Left
noclipLabel.Parent = noclipRow

local noclipIndicator = Instance.new("Frame")
noclipIndicator.Size = UDim2.new(0, 10, 0, 10)
noclipIndicator.Position = UDim2.new(1, -25, 0.5, -5)
noclipIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noclipIndicator.BorderSizePixel = 0
noclipIndicator.Parent = noclipRow

local noclipIndicatorCorner = Instance.new("UICorner")
noclipIndicatorCorner.CornerRadius = UDim.new(1, 0)
noclipIndicatorCorner.Parent = noclipIndicator

-- Stats Card
local statsCard = Instance.new("Frame")
statsCard.Name = "StatsCard"
statsCard.Size = UDim2.new(1, 0, 0, 80)
statsCard.BackgroundColor3 = COLORS.CardBg
statsCard.LayoutOrder = 5
statsCard.Parent = miscFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 6)
statsCorner.Parent = statsCard

local statsTitle = Instance.new("TextLabel")
statsTitle.Size = UDim2.new(1, -20, 0, 25)
statsTitle.Position = UDim2.new(0, 12, 0, 8)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "Environment Diagnostics"
statsTitle.TextColor3 = COLORS.TextMain
statsTitle.Font = Enum.Font.SourceSansBold
statsTitle.TextSize = 14
statsTitle.TextXAlignment = Enum.TextXAlignment.Left
statsTitle.Parent = statsCard

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.5, -12, 0, 20)
pingLabel.Position = UDim2.new(0, 12, 0, 33)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Network Delay: Checking..."
pingLabel.TextColor3 = COLORS.TextDark
pingLabel.Font = Enum.Font.SourceSans
pingLabel.TextSize = 14
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Parent = statsCard

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.5, -12, 0, 20)
fpsLabel.Position = UDim2.new(0, 12, 0, 53)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "Frame Rate: Computing..."
fpsLabel.TextColor3 = COLORS.TextDark
fpsLabel.Font = Enum.Font.SourceSans
fpsLabel.TextSize = 14
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = statsCard

local playerCounterLabel = Instance.new("TextLabel")
playerCounterLabel.Size = UDim2.new(0.5, -12, 0, 20)
playerCounterLabel.Position = UDim2.new(0.5, 0, 0, 33)
playerCounterLabel.BackgroundTransparency = 1
playerCounterLabel.Text = "Active Players: 0"
playerCounterLabel.TextColor3 = COLORS.TextDark
playerCounterLabel.Font = Enum.Font.SourceSans
playerCounterLabel.TextSize = 14
playerCounterLabel.TextXAlignment = Enum.TextXAlignment.Left
playerCounterLabel.Parent = statsCard

-- Aimbot Tab
local aimbotLayout = Instance.new("UIListLayout")
aimbotLayout.Padding = UDim.new(0, 10)
aimbotLayout.SortOrder = Enum.SortOrder.LayoutOrder
aimbotLayout.Parent = aimbotFrame

local trackingRow = Instance.new("TextButton")
trackingRow.Name = "TrackingToggleRow"
trackingRow.Size = UDim2.new(1, 0, 0, 42)
trackingRow.BackgroundColor3 = COLORS.CardBg
trackingRow.AutoButtonColor = false
trackingRow.Text = ""
trackingRow.LayoutOrder = 1
trackingRow.Parent = aimbotFrame

local rowCorner = Instance.new("UICorner")
rowCorner.CornerRadius = UDim.new(0, 6)
rowCorner.Parent = trackingRow

local rowIcon = Instance.new("TextLabel")
rowIcon.Size = UDim2.new(0, 30, 1, 0)
rowIcon.Position = UDim2.new(0, 10, 0, 0)
rowIcon.BackgroundTransparency = 1
rowIcon.Text = "◯"
rowIcon.TextColor3 = COLORS.AccentLight
rowIcon.Font = Enum.Font.SourceSansLight
rowIcon.TextSize = 22
rowIcon.Parent = trackingRow

local rowLabel = Instance.new("TextLabel")
rowLabel.Size = UDim2.new(0, 150, 1, 0)
rowLabel.Position = UDim2.new(0, 42, 0, 0)
rowLabel.BackgroundTransparency = 1
rowLabel.Text = "Aimbot"
rowLabel.TextColor3 = COLORS.TextMain
rowLabel.Font = Enum.Font.SourceSansBold
rowLabel.TextSize = 15
rowLabel.TextXAlignment = Enum.TextXAlignment.Left
rowLabel.Parent = trackingRow

local stateIndicator = Instance.new("Frame")
stateIndicator.Size = UDim2.new(0, 10, 0, 10)
stateIndicator.Position = UDim2.new(1, -25, 0.5, -5)
stateIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
stateIndicator.BorderSizePixel = 0
stateIndicator.Parent = trackingRow

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(1, 0)
indicatorCorner.Parent = stateIndicator

-- FOV Slider
local fovSliderContainer = Instance.new("Frame")
fovSliderContainer.Size = UDim2.new(1, 0, 0, 50)
fovSliderContainer.BackgroundColor3 = COLORS.CardBg
fovSliderContainer.LayoutOrder = 2
fovSliderContainer.Parent = aimbotFrame

local fovSliderCorner = Instance.new("UICorner")
fovSliderCorner.CornerRadius = UDim.new(0, 6)
fovSliderCorner.Parent = fovSliderContainer

local fovSliderTitle = Instance.new("TextLabel")
fovSliderTitle.Size = UDim2.new(1, -70, 0, 20)
fovSliderTitle.Position = UDim2.new(0, 12, 0, 4)
fovSliderTitle.BackgroundTransparency = 1
fovSliderTitle.Text = "FOV Size"
fovSliderTitle.TextColor3 = COLORS.TextMain
fovSliderTitle.Font = Enum.Font.SourceSansBold
fovSliderTitle.TextSize = 14
fovSliderTitle.TextXAlignment = Enum.TextXAlignment.Left
fovSliderTitle.Parent = fovSliderContainer

local fovSliderValue = Instance.new("TextLabel")
fovSliderValue.Size = UDim2.new(0, 50, 0, 20)
fovSliderValue.Position = UDim2.new(1, -62, 0, 4)
fovSliderValue.BackgroundTransparency = 1
fovSliderValue.Text = tostring(FOV_RADIUS)
fovSliderValue.TextColor3 = COLORS.AccentLight
fovSliderValue.Font = Enum.Font.SourceSansBold
fovSliderValue.TextSize = 14
fovSliderValue.TextXAlignment = Enum.TextXAlignment.Right
fovSliderValue.Parent = fovSliderContainer

local fovSliderButton = Instance.new("TextButton")
fovSliderButton.Size = UDim2.new(1, -24, 0, 12)
fovSliderButton.Position = UDim2.new(0, 12, 0, 28)
fovSliderButton.BackgroundColor3 = COLORS.SliderTrack
fovSliderButton.Text = ""
fovSliderButton.AutoButtonColor = false
fovSliderButton.Parent = fovSliderContainer

local fovTrackCorner = Instance.new("UICorner")
fovTrackCorner.CornerRadius = UDim.new(0, 4)
fovTrackCorner.Parent = fovSliderButton

local fovSliderFill = Instance.new("Frame")
fovSliderFill.Size = UDim2.new(FOV_RADIUS / 500, 0, 1, 0)
fovSliderFill.BackgroundColor3 = COLORS.AccentLight
fovSliderFill.BorderSizePixel = 0
fovSliderFill.Parent = fovSliderButton

local fovFillCorner = Instance.new("UICorner")
fovFillCorner.CornerRadius = UDim.new(0, 4)
fovFillCorner.Parent = fovSliderFill

-- Range Slider
local rangeSliderContainer = Instance.new("Frame")
rangeSliderContainer.Size = UDim2.new(1, 0, 0, 50)
rangeSliderContainer.BackgroundColor3 = COLORS.CardBg
rangeSliderContainer.LayoutOrder = 3
rangeSliderContainer.Parent = aimbotFrame

local rangeSliderCorner = Instance.new("UICorner")
rangeSliderCorner.CornerRadius = UDim.new(0, 6)
rangeSliderCorner.Parent = rangeSliderContainer

local rangeSliderTitle = Instance.new("TextLabel")
rangeSliderTitle.Size = UDim2.new(1, -80, 0, 20)
rangeSliderTitle.Position = UDim2.new(0, 12, 0, 4)
rangeSliderTitle.BackgroundTransparency = 1
rangeSliderTitle.Text = "Aimbot Range"
rangeSliderTitle.TextColor3 = COLORS.TextMain
rangeSliderTitle.Font = Enum.Font.SourceSansBold
rangeSliderTitle.TextSize = 14
rangeSliderTitle.TextXAlignment = Enum.TextXAlignment.Left
rangeSliderTitle.Parent = rangeSliderContainer

local rangeSliderValue = Instance.new("TextLabel")
rangeSliderValue.Size = UDim2.new(0, 60, 0, 20)
rangeSliderValue.Position = UDim2.new(1, -72, 0, 4)
rangeSliderValue.BackgroundTransparency = 1
rangeSliderValue.Text = tostring(MAX_RANGE)
rangeSliderValue.TextColor3 = COLORS.AccentLight
rangeSliderValue.Font = Enum.Font.SourceSansBold
rangeSliderValue.TextSize = 14
rangeSliderValue.TextXAlignment = Enum.TextXAlignment.Right
rangeSliderValue.Parent = rangeSliderContainer

local rangeSliderButton = Instance.new("TextButton")
rangeSliderButton.Size = UDim2.new(1, -24, 0, 12)
rangeSliderButton.Position = UDim2.new(0, 12, 0, 28)
rangeSliderButton.BackgroundColor3 = COLORS.SliderTrack
rangeSliderButton.Text = ""
rangeSliderButton.AutoButtonColor = false
rangeSliderButton.Parent = rangeSliderContainer

local rangeTrackCorner = Instance.new("UICorner")
rangeTrackCorner.CornerRadius = UDim.new(0, 4)
rangeTrackCorner.Parent = rangeSliderButton

local rangeSliderFill = Instance.new("Frame")
rangeSliderFill.Size = UDim2.new(MAX_RANGE / 1000000, 0, 1, 0)
rangeSliderFill.BackgroundColor3 = COLORS.AccentLight
rangeSliderFill.BorderSizePixel = 0
rangeSliderFill.Parent = rangeSliderButton

local rangeFillCorner = Instance.new("UICorner")
rangeFillCorner.CornerRadius = UDim.new(0, 4)
rangeFillCorner.Parent = rangeSliderFill

-- ESP Tab
local espLayout = Instance.new("UIListLayout")
espLayout.Padding = UDim.new(0, 10)
espLayout.SortOrder = Enum.SortOrder.LayoutOrder
espLayout.Parent = espFrame

local highlightRow = Instance.new("TextButton")
highlightRow.Size = UDim2.new(1, 0, 0, 42)
highlightRow.BackgroundColor3 = COLORS.CardBg
highlightRow.AutoButtonColor = false
highlightRow.Text = ""
highlightRow.LayoutOrder = 1
highlightRow.Parent = espFrame

local highlightRowCorner = Instance.new("UICorner")
highlightRowCorner.CornerRadius = UDim.new(0, 6)
highlightRowCorner.Parent = highlightRow

local highlightIcon = Instance.new("TextLabel")
highlightIcon.Size = UDim2.new(0, 30, 1, 0)
highlightIcon.Position = UDim2.new(0, 10, 0, 0)
highlightIcon.BackgroundTransparency = 1
highlightIcon.Text = "👁"
highlightIcon.TextColor3 = COLORS.AccentLight
highlightIcon.Font = Enum.Font.SourceSansLight
highlightIcon.TextSize = 20
highlightIcon.Parent = highlightRow

local highlightLabel = Instance.new("TextLabel")
highlightLabel.Size = UDim2.new(0, 150, 1, 0)
highlightLabel.Position = UDim2.new(0, 42, 0, 0)
highlightLabel.BackgroundTransparency = 1
highlightLabel.Text = "ESP"
highlightLabel.TextColor3 = COLORS.TextMain
highlightLabel.Font = Enum.Font.SourceSansBold
highlightLabel.TextSize = 15
highlightLabel.TextXAlignment = Enum.TextXAlignment.Left
highlightLabel.Parent = highlightRow

local highlightIndicator = Instance.new("Frame")
highlightIndicator.Size = UDim2.new(0, 10, 0, 10)
highlightIndicator.Position = UDim2.new(1, -25, 0.5, -5)
highlightIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
highlightIndicator.BorderSizePixel = 0
highlightIndicator.Parent = highlightRow

local highlightIndicatorCorner = Instance.new("UICorner")
highlightIndicatorCorner.CornerRadius = UDim.new(1, 0)
highlightIndicatorCorner.Parent = highlightIndicator

local teamCheckRow = Instance.new("TextButton")
teamCheckRow.Name = "TeamCheckRow"
teamCheckRow.Size = UDim2.new(1, 0, 0, 42)
teamCheckRow.BackgroundColor3 = COLORS.CardBg
teamCheckRow.AutoButtonColor = false
teamCheckRow.Text = ""
teamCheckRow.LayoutOrder = 2
teamCheckRow.Parent = espFrame

local teamCheckCorner = Instance.new("UICorner")
teamCheckCorner.CornerRadius = UDim.new(0, 6)
teamCheckCorner.Parent = teamCheckRow

local teamCheckIcon = Instance.new("TextLabel")
teamCheckIcon.Size = UDim2.new(0, 30, 1, 0)
teamCheckIcon.Position = UDim2.new(0, 10, 0, 0)
teamCheckIcon.BackgroundTransparency = 1
teamCheckIcon.Text = "🛡"
teamCheckIcon.TextColor3 = COLORS.AccentLight
teamCheckIcon.Font = Enum.Font.SourceSansLight
teamCheckIcon.TextSize = 18
teamCheckIcon.Parent = teamCheckRow

local teamCheckLabel = Instance.new("TextLabel")
teamCheckLabel.Size = UDim2.new(0, 150, 1, 0)
teamCheckLabel.Position = UDim2.new(0, 42, 0, 0)
teamCheckLabel.BackgroundTransparency = 1
teamCheckLabel.Text = "Team Check"
teamCheckLabel.TextColor3 = COLORS.TextMain
teamCheckLabel.Font = Enum.Font.SourceSansBold
teamCheckLabel.TextSize = 15
teamCheckLabel.TextXAlignment = Enum.TextXAlignment.Left
teamCheckLabel.Parent = teamCheckRow

local teamCheckIndicator = Instance.new("Frame")
teamCheckIndicator.Size = UDim2.new(0, 10, 0, 10)
teamCheckIndicator.Position = UDim2.new(1, -25, 0.5, -5)
teamCheckIndicator.BackgroundColor3 = COLORS.ToggleGreen
teamCheckIndicator.BorderSizePixel = 0
teamCheckIndicator.Parent = teamCheckRow

local teamCheckIndicatorCorner = Instance.new("UICorner")
teamCheckIndicatorCorner.CornerRadius = UDim.new(1, 0)
teamCheckIndicatorCorner.Parent = teamCheckIndicator

-- Discord Tab
local discordLayout = Instance.new("UIListLayout")
discordLayout.Padding = UDim.new(0, 10)
discordLayout.SortOrder = Enum.SortOrder.LayoutOrder
discordLayout.Parent = discordFrame

local discordCard = Instance.new("Frame")
discordCard.Name = "DiscordCard"
discordCard.Size = UDim2.new(1, 0, 0, 110)
discordCard.BackgroundColor3 = COLORS.CardBg
discordCard.LayoutOrder = 1
discordCard.Parent = discordFrame

local discordCardCorner = Instance.new("UICorner")
discordCardCorner.CornerRadius = UDim.new(0, 6)
discordCardCorner.Parent = discordCard

local discordTitle = Instance.new("TextLabel")
discordTitle.Size = UDim2.new(1, -20, 0, 25)
discordTitle.Position = UDim2.new(0, 12, 0, 12)
discordTitle.BackgroundTransparency = 1
discordTitle.Text = "Join Our Discord Community"
discordTitle.TextColor3 = COLORS.TextMain
discordTitle.Font = Enum.Font.SourceSansBold
discordTitle.TextSize = 16
discordTitle.TextXAlignment = Enum.TextXAlignment.Left
discordTitle.Parent = discordCard

local discordDesc = Instance.new("TextLabel")
discordDesc.Size = UDim2.new(1, -20, 0, 20)
discordDesc.Position = UDim2.new(0, 12, 0, 34)
discordDesc.BackgroundTransparency = 1
discordDesc.Text = "Click the button below to copy the network invite code."
discordDesc.TextColor3 = COLORS.TextDark
discordDesc.Font = Enum.Font.SourceSans
discordDesc.TextSize = 13
discordDesc.TextXAlignment = Enum.TextXAlignment.Left
discordDesc.Parent = discordCard

local copyInviteBtn = Instance.new("TextButton")
copyInviteBtn.Name = "CopyInviteButton"
copyInviteBtn.Size = UDim2.new(1, -24, 0, 34)
copyInviteBtn.Position = UDim2.new(0, 12, 0, 64)
copyInviteBtn.BackgroundColor3 = COLORS.DiscordBlurple
copyInviteBtn.Text = "Copy Discord Invite"
copyInviteBtn.TextColor3 = COLORS.TextMain
copyInviteBtn.Font = Enum.Font.SourceSansBold
copyInviteBtn.TextSize = 14
copyInviteBtn.AutoButtonColor = true
copyInviteBtn.Parent = discordCard

local copyBtnCorner = Instance.new("UICorner")
copyBtnCorner.CornerRadius = UDim.new(0, 5)
copyBtnCorner.Parent = copyInviteBtn

local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOVCircle"
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
fovFrame.BackgroundTransparency = 1
fovFrame.Visible = false
fovFrame.Parent = screenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovFrame

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness = 1.5
fovStroke.Parent = fovFrame

-- Tab Switching
local function setTab(tabName)
    miscFrame.Visible = (tabName == "Misc")
    aimbotFrame.Visible = (tabName == "Aimbot")
    espFrame.Visible = (tabName == "ESP")
    discordFrame.Visible = (tabName == "Discord")
    miscBtn.BackgroundColor3 = (tabName == "Misc" and COLORS.TabActive or COLORS.Sidebar)
    aimbotBtn.BackgroundColor3 = (tabName == "Aimbot" and COLORS.TabActive or COLORS.Sidebar)
    espBtn.BackgroundColor3 = (tabName == "ESP" and COLORS.TabActive or COLORS.Sidebar)
    discordBtn.BackgroundColor3 = (tabName == "Discord" and COLORS.TabActive or COLORS.Sidebar)
end

miscBtn.MouseButton1Click:Connect(function() setTab("Misc") end)
aimbotBtn.MouseButton1Click:Connect(function() setTab("Aimbot") end)
espBtn.MouseButton1Click:Connect(function() setTab("ESP") end)
discordBtn.MouseButton1Click:Connect(function() setTab("Discord") end)
setTab("Misc")

-- Dragging
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainWindow.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Sliders
local fovDragging = false
local function updateFovSlider(input)
    local absolutePosition = fovSliderButton.AbsolutePosition.X
    local absoluteSize = fovSliderButton.AbsoluteSize.X
    local mouseX = input.Position.X
    local percentage = math.clamp((mouseX - absolutePosition) / absoluteSize, 0, 1)
    FOV_RADIUS = math.round(percentage * 500)
    fovSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    fovSliderValue.Text = tostring(FOV_RADIUS)
    fovFrame.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
end

fovSliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fovDragging = true
        updateFovSlider(input)
    end
end)

local rangeDragging = false
local function updateRangeSlider(input)
    local absolutePosition = rangeSliderButton.AbsolutePosition.X
    local absoluteSize = rangeSliderButton.AbsoluteSize.X
    local mouseX = input.Position.X
    local percentage = math.clamp((mouseX - absolutePosition) / absoluteSize, 0, 1)
    MAX_RANGE = math.round(percentage * 1000000)
    rangeSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    rangeSliderValue.Text = tostring(MAX_RANGE)
end

rangeSliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        rangeDragging = true
        updateRangeSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if fovDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateFovSlider(input)
    elseif rangeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateRangeSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fovDragging = false
        rangeDragging = false
    end
end)

-- Core Logic
local function isVisible(targetPart)
    local origin = camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character, targetPart.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    return raycastResult == nil
end

local function getClosestTarget()
    local closestPlayer = nil
    local shortestCharacterDistance = math.huge
    local mouseLocation = UserInputService:GetMouseLocation()
    local localCharacter = player.Character
    if not localCharacter or not localCharacter:FindFirstChild("HumanoidRootPart") then return nil end
    local localRoot = localCharacter.HumanoidRootPart

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and (not isTeamCheckEnabled or player.Team == nil or otherPlayer.Team ~= player.Team) then
            if otherPlayer.Character and otherPlayer.Character:FindFirstChild(TARGET_PART) then
                local character = otherPlayer.Character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local targetPart = character[TARGET_PART]
                if humanoid and humanoid.Health > 0 then
                    local screenPosition, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local target2D = Vector2.new(screenPosition.X, screenPosition.Y)
                        local distanceToCursor = (target2D - mouseLocation).Magnitude
                        if distanceToCursor <= FOV_RADIUS then
                            local characterDistance = (targetPart.Position - localRoot.Position).Magnitude
                            if characterDistance <= MAX_RANGE and characterDistance < shortestCharacterDistance then
                                if isVisible(targetPart) then
                                    shortestCharacterDistance = characterDistance
                                    closestPlayer = targetPart
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- =====================
-- IMPROVED FLY (Stronger anti-slide)
-- =====================
local function toggleFly()
    isFlyEnabled = not isFlyEnabled
    local targetColor = isFlyEnabled and COLORS.ToggleGreen or Color3.fromRGB(100, 100, 100)
    TweenService:Create(flyIndicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

    if isFlyEnabled then
        local character = player.Character
        if not character then isFlyEnabled = false return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then isFlyEnabled = false return end

        humanoid.PlatformStand = true

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Velocity = Vector3.zero
        flyBodyVelocity.Parent = root

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.P = 3000
        flyBodyGyro.Parent = root

        flyConnection = RunService.RenderStepped:Connect(function()
            if not isFlyEnabled or not root or not root.Parent then
                if flyConnection then flyConnection:Disconnect() end
                return
            end

            local cam = workspace.CurrentCamera
            local moveDir = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then
                flyBodyVelocity.Velocity = moveDir.Unit * 85
            else
                flyBodyVelocity.Velocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.zero   -- ← This stops the sliding
            end

            flyBodyGyro.CFrame = cam.CFrame
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end

        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    end
end

-- =====================
-- IMPROVED NOCLIP
-- =====================
local function toggleNoclip()
    isNoclipEnabled = not isNoclipEnabled
    local targetColor = isNoclipEnabled and COLORS.ToggleGreen or Color3.fromRGB(100, 100, 100)
    TweenService:Create(noclipIndicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

    if isNoclipEnabled then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            if not isNoclipEnabled or not player.Character then return end
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- =====================
-- MISSING FUNCTIONS
-- =====================
local function updateToggleState(state)
    isFeatureEnabled = state
    local targetColor = isFeatureEnabled and COLORS.ToggleGreen or Color3.fromRGB(100, 100, 100)
    TweenService:Create(stateIndicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    fovFrame.Visible = isFeatureEnabled
end

local function applyHighlights()
    if not isHighlightEnabled then 
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("UiLibHighlight")
                if hl then hl:Destroy() end
            end
        end
        return 
    end
    for _, p in ipairs(Players:GetPlayers()) do
        local passedCheck = true
        if isTeamCheckEnabled and player.Team ~= nil and p.Team == player.Team then
            passedCheck = false
        end
        if p ~= player and passedCheck then
            if p.Character and not p.Character:FindFirstChild("UiLibHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "UiLibHighlight"
                hl.FillColor = COLORS.AccentLight
                hl.FillTransparency = 0.4
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineTransparency = 0.1
                hl.Adornee = p.Character
                hl.Parent = p.Character
            end
        else
            local hl = p.Character and p.Character:FindFirstChild("UiLibHighlight")
            if hl then hl:Destroy() end
        end
    end
end

local function updateHighlightState(state)
    isHighlightEnabled = state
    local targetColor = isHighlightEnabled and COLORS.ToggleGreen or Color3.fromRGB(100, 100, 100)
    TweenService:Create(highlightIndicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    applyHighlights()
end

local function updateTeamCheckState(state)
    isTeamCheckEnabled = state
    local targetColor = isTeamCheckEnabled and COLORS.ToggleGreen or Color3.fromRGB(100, 100, 100)
    TweenService:Create(teamCheckIndicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    applyHighlights()
end

-- Button Connections
trackingRow.MouseButton1Click:Connect(function()
    updateToggleState(not isFeatureEnabled)
end)
highlightRow.MouseButton1Click:Connect(function()
    updateHighlightState(not isHighlightEnabled)
end)
teamCheckRow.MouseButton1Click:Connect(function()
    updateTeamCheckState(not isTeamCheckEnabled)
end)
flyRow.MouseButton1Click:Connect(toggleFly)
noclipRow.MouseButton1Click:Connect(toggleNoclip)

copyInviteBtn.MouseButton1Click:Connect(function()
    local inviteURL = "https://discord.gg/RNgyh8MhxN"
    if typeof(setclipboard) == "function" then
        setclipboard(inviteURL)
        copyInviteBtn.Text = "Copied!"
    elseif typeof(toclipboard) == "function" then
        toclipboard(inviteURL)
        copyInviteBtn.Text = "Copied!"
    else
        copyInviteBtn.Text = "Unsupported Exploit"
    end
    task.wait(2)
    copyInviteBtn.Text = "Copy Discord Invite"
end)

closeButton.MouseButton1Click:Connect(function()
    isFeatureEnabled = false
    isHighlightEnabled = false
    isFlyEnabled = false
    isNoclipEnabled = false

    if flyConnection then flyConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end
    if highlightAddedConn then highlightAddedConn:Disconnect() end
    if aimbotAddedConn then aimbotAddedConn:Disconnect() end

    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("UiLibHighlight")
            if hl then hl:Destroy() end
        end
    end

    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end

    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
end)

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainWindow.Visible = not isMinimized
end)

unlockRow.MouseButton1Click:Connect(function()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.ModalEnabled = true
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.H or input.KeyCode == Enum.KeyCode.F then
        isMinimized = not isMinimized
        mainWindow.Visible = not isMinimized
    elseif input.KeyCode == Enum.KeyCode.K then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.ModalEnabled = true
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        if isHighlightEnabled then
            applyHighlights()
        end
    end)
end)

local fpsCount = 0
local lastFpsUpdate = os.clock()

RunService.RenderStepped:Connect(function()
    local now = os.clock()
    fpsCount = fpsCount + 1
    if now - lastFpsUpdate >= 1 then
        fpsLabel.Text = "Frame Rate: " .. fpsCount .. " FPS"
        fpsCount = 0
        lastFpsUpdate = now

        local successStats, statsResult = pcall(function()
            return player:GetNetworkPing() * 1000
        end)
        if successStats then
            pingLabel.Text = string.format("Network Delay: %.0f ms", statsResult)
        else
            pingLabel.Text = "Network Delay: N/A"
        end
        playerCounterLabel.Text = "Active Players: " .. #Players:GetPlayers()
    end

    local mouseLocation = UserInputService:GetMouseLocation()
    fovFrame.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y)

    if isHighlightEnabled then
        applyHighlights()
    end

    if not isFeatureEnabled then return end

    local target = getClosestTarget()
    if target then
        local targetRotation = CFrame.lookAt(camera.CFrame.Position, target.Position)
        camera.CFrame = camera.CFrame:Lerp(targetRotation, TRACKING_SMOOTHNESS)
    end
end)
