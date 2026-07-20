--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

loadstring(game:HttpGet("https://raw.githubusercontent.com/HKTD-Roblox/Script-Beta/refs/heads/main/Script-By-HKTD.lua", true))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local function addUICorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = inst
end

local existing = player:WaitForChild("PlayerGui"):FindFirstChild("FakeLagGUI")
if existing then existing:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeLagGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local loadBg = Instance.new("Frame", screenGui)
loadBg.Size = UDim2.new(0, 300, 0, 30)
loadBg.Position = UDim2.new(0.5, -150, 0.5, -15)
loadBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
addUICorner(loadBg, 8)

local loadFill = Instance.new("Frame", loadBg)
loadFill.Size = UDim2.new(0, 0, 1, 0)
loadFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
addUICorner(loadFill, 8)

local loadTxt = Instance.new("TextLabel", loadBg)
loadTxt.Size = UDim2.new(1,0,1,0)
loadTxt.BackgroundTransparency = 1
loadTxt.Text = "Loading GUI..."
loadTxt.TextColor3 = Color3.new(1,1,1)
loadTxt.Font = Enum.Font.SourceSansBold
loadTxt.TextSize = 18

local badPingAnimId
local badPingAnimIdR6 = "rbxassetid://967278155"
local badPingAnimIdR15 = "rbxassetid://507777826"

local char = player.Character
if char then
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.RigType == Enum.HumanoidRigType.R6 then
            badPingAnimId = badPingAnimIdR6
        else
            badPingAnimId = badPingAnimIdR15
        end
    end
end

TweenService:Create(loadFill, TweenInfo.new(2, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}):Play()
task.wait(2)
loadBg:Destroy()

local main = Instance.new("Frame")
main.Name = "MainGUI"
main.Size = UDim2.new(0, 300, 0, 460)
main.Position = UDim2.new(0.5, -150, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true
main.Visible = true
main.Parent = screenGui
addUICorner(main, 12)

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0,24,0,24)
closeBtn.Position = UDim2.new(1,-30,0,6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Text = "X"
addUICorner(closeBtn,6)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0, 28)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.Text = "Fake Lag GUI"

local statusLbl = Instance.new("TextLabel", main)
statusLbl.Size = UDim2.new(1,-20,0,24)
statusLbl.Position = UDim2.new(0,10,0,40)
statusLbl.BackgroundTransparency = 1
statusLbl.Font = Enum.Font.SourceSans
statusLbl.TextSize = 18
statusLbl.TextColor3 = Color3.new(1,1,1)
statusLbl.Text = "Speed: 1"

local tipLbl = Instance.new("TextLabel", main)
tipLbl.Size = UDim2.new(1,-20,0,20)
tipLbl.Position = UDim2.new(0,10,0,60)
tipLbl.BackgroundTransparency = 1
tipLbl.Font = Enum.Font.SourceSansItalic
tipLbl.TextSize = 14
tipLbl.TextColor3 = Color3.fromRGB(150,255,150)
tipLbl.Text = "Script Created By HKTD"

local speedBox = Instance.new("TextBox", main)
speedBox.Size = UDim2.new(1,-80,0,30)
speedBox.Position = UDim2.new(0,10,0,85)
speedBox.PlaceholderText = "Enter speed"
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 18
speedBox.Text = ""
addUICorner(speedBox,6)

local enterBtn = Instance.new("TextButton", main)
enterBtn.Size = UDim2.new(0,60,0,30)
enterBtn.Position = UDim2.new(1,-70,0,85)
enterBtn.Text = "Set"
enterBtn.Font = Enum.Font.SourceSansBold
enterBtn.TextSize = 18
enterBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
enterBtn.TextColor3 = Color3.new(1,1,1)
addUICorner(enterBtn,6)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1,-20,0,220)
scroll.Position = UDim2.new(0,10,0,130)
scroll.CanvasSize = UDim2.new(0,0,0,400)
scroll.BackgroundColor3 = Color3.fromRGB(20,20,20)
scroll.ScrollBarThickness = 6
addUICorner(scroll,6)

local buttons = {}
local buttonNames = {"Bad Ping","Fake Lag","Crash"}
for i,name in ipairs(buttonNames) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,10 + (i-1)*50)
    btn.Text = name..": OFF"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    addUICorner(btn,6)
    buttons[name] = btn
end

local activeMode = nil
local savedSpeeds = {["Bad Ping"]=1, ["Fake Lag"]=1, ["Crash"]=1}
local lagOn = false
local lagLoop
local lagSpeed = 1
local crashOn = false
local crashAnimTrack
local defaultTip = "hello man"

local function playRunAnim(hum)
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        track:Stop()
        track:Destroy()
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = badPingAnimId

    local track
    if hum.RigType == Enum.HumanoidRigType.R6 then
        hum.PlatformStand = false
        track = hum:LoadAnimation(anim)
    else
        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = hum
        end
        track = animator:LoadAnimation(anim)
    end

    track:Play()
    return track
end

local function updateButtonStates()
    for name,btn in pairs(buttons) do
        if (activeMode == name and lagOn) or (name=="Crash" and crashOn) then
            btn.Text = name..": ON"
            btn.BackgroundColor3 = Color3.fromRGB(100,200,100)
        else
            btn.Text = name..": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
    end
end

local function badPingLoop()
    local wasMoving = false
    while lagOn and activeMode == "Bad Ping" do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            if hum.MoveDirection.Magnitude > 0 then
                wasMoving = true
            elseif wasMoving and hum.MoveDirection.Magnitude == 0 then
                wasMoving = false
                local oldWS, oldJP = hum.WalkSpeed, hum.JumpPower
                hum.WalkSpeed, hum.JumpPower = 0,0
                local runAnim = playRunAnim(hum)
                task.wait(0.5)
                root.CFrame = root.CFrame + (root.CFrame.LookVector * (savedSpeeds["Bad Ping"] or 1))
                task.wait(1.5)
                if runAnim then runAnim:Stop(); runAnim:Destroy() end
                hum.WalkSpeed, hum.JumpPower = oldWS, oldJP
            end
        end
        task.wait(0.2)
    end
end

local function fakeLagLoop()
    while lagOn and activeMode == "Fake Lag" do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local internalSpeed = (savedSpeeds["Fake Lag"] or 1) + 5
            local freezeTime = math.clamp(0.8 / internalSpeed, 0.05, 0.8)
            local unfreezeTime = math.clamp(0.2 / internalSpeed, 0.05, 0.5)
            root.Anchored = true
            task.wait(freezeTime)
            root.Anchored = false
            task.wait(unfreezeTime)
        else
            task.wait(0.2)
        end
    end
end

local function toggleCrash()
    crashOn = not crashOn
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if crashOn and hum and root then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator and #animator:GetPlayingAnimationTracks() > 0 then
            local currentTrack = animator:GetPlayingAnimationTracks()[1]
            if currentTrack then
                local anim = Instance.new("Animation")
                anim.AnimationId = currentTrack.Animation.AnimationId
                crashAnimTrack = animator:LoadAnimation(anim)
                crashAnimTrack.Looped = true
                crashAnimTrack:Play()
                crashAnimTrack:AdjustSpeed(savedSpeeds["Crash"] or 1)
                root.Anchored = true
            end
        end
    else
        if crashAnimTrack then crashAnimTrack:Stop(); crashAnimTrack:Destroy() end
        if root then root.Anchored = false end
    end
    updateButtonStates()
end

local function toggleMode(mode)
    if mode == "Crash" then
        toggleCrash()
        return
    end
    if activeMode == mode and lagOn then
        if mode == "Bad Ping" then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                repeat task.wait(0.1) until root.Velocity.Magnitude < 0.1
            end
        end
        if lagLoop then task.cancel(lagLoop) end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = false
        end
        lagOn = false
        updateButtonStates()
        tipLbl.Text = defaultTip
    else
        activeMode = mode
        tipLbl.Text = mode
        lagSpeed = savedSpeeds[mode] or 1
        statusLbl.Text = "Speed: " .. lagSpeed
        lagOn = true
        updateButtonStates()
        if mode == "Bad Ping" then
            lagLoop = task.spawn(badPingLoop)
        elseif mode == "Fake Lag" then
            lagLoop = task.spawn(fakeLagLoop)
        end
    end
end

for name,btn in pairs(buttons) do
    btn.MouseButton1Click:Connect(function()
        toggleMode(name)
    end)
end

enterBtn.MouseButton1Click:Connect(function()
    if activeMode then
        local num = tonumber(speedBox.Text)
        if num and num > 0 then
            savedSpeeds[activeMode] = num
            lagSpeed = num
            statusLbl.Text = "Speed: "..num
            if activeMode == "Crash" and crashAnimTrack then
                crashAnimTrack:AdjustSpeed(num)
            end
        else
            statusLbl.Text = "Invalid number!"
        end
    end
end)
