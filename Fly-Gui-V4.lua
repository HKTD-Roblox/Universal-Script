--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

--- [[SCRIPT]]--
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")
local keybindButton = Instance.new("TextButton")
local keybindLabel = Instance.new("TextLabel")
local resetKeybindButton = Instance.new("TextButton")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local flySpeed = 50
local flyEnabled = false
local flying = false
local bodyVelocity, bodyGyro, flyConnection, stateChangedConnection, animationConnection, noclipConnection
local currentKeybind = Enum.KeyCode.F
local settingKeybind = false
local lastLookDirection = Vector3.new(0, 0, -1)
local rotationSpeed = (getgenv and getgenv().rotationSpeed) or 0.03

local originalCollisionStates = {}

local speeds = 1
local speaker = game:GetService("Players").LocalPlayer
local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
local nowe = false
local tpwalking = false

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 85)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.329411775, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.329411775, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "FLY"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "FLY GUI V4"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 27)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.329411775, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "50"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.329411775, 0)
mine.Size = UDim2.new(0, 45, 0, 28)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

keybindButton.Name = "keybindButton"
keybindButton.Parent = Frame
keybindButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
keybindButton.Position = UDim2.new(0.231578946, 0, 0.658823550, 0)
keybindButton.Size = UDim2.new(0, 88, 0, 28)
keybindButton.Font = Enum.Font.SourceSans
keybindButton.Text = "Set Keybind"
keybindButton.TextColor3 = Color3.fromRGB(0, 0, 0)
keybindButton.TextScaled = true
keybindButton.TextSize = 14.000
keybindButton.TextWrapped = true

keybindLabel.Name = "keybindLabel"
keybindLabel.Parent = Frame
keybindLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
keybindLabel.Position = UDim2.new(0, 0, 0.658823550, 0)
keybindLabel.Size = UDim2.new(0, 44, 0, 28)
keybindLabel.Font = Enum.Font.SourceSans
keybindLabel.Text = "F"
keybindLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
keybindLabel.TextScaled = true
keybindLabel.TextSize = 14.000
keybindLabel.TextWrapped = true

resetKeybindButton.Name = "resetKeybindButton"
resetKeybindButton.Parent = Frame
resetKeybindButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
resetKeybindButton.Position = UDim2.new(0.706, 0, 0.647058824, 0)
resetKeybindButton.Size = UDim2.new(0, 55.1, 0, 29)
resetKeybindButton.Font = Enum.Font.SourceSans
resetKeybindButton.Text = "Reset"
resetKeybindButton.TextColor3 = Color3.fromRGB(0, 0, 0)
resetKeybindButton.TextScaled = true
resetKeybindButton.TextSize = 14.000
resetKeybindButton.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position = UDim2.new(0, 0, -1, 55)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 55)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 85)
mini2.Visible = false

Frame.Active = true
Frame.Draggable = true

local function createClickEffect(button)
    local originalColor = button.BackgroundColor3
    local originalSize = button.Size
    button.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local scaledSize = UDim2.new(
            originalSize.X.Scale * 0.9,
            originalSize.X.Offset * 0.9,
            originalSize.Y.Scale * 0.9,
            originalSize.Y.Offset * 0.9
        )
        local scaleDown = TweenService:Create(button, tweenInfo, {Size = scaledSize})
        local darkerColor = Color3.fromRGB(
            math.floor(originalColor.R * 255 * 0.8),
            math.floor(originalColor.G * 255 * 0.8),
            math.floor(originalColor.B * 255 * 0.8)
        )
        local colorTween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = darkerColor})
        scaleDown:Play()
        colorTween:Play()
        scaleDown.Completed:Connect(function()
            local scaleUp = TweenService:Create(button, tweenInfo, {Size = originalSize})
            local colorRestore = TweenService:Create(button, tweenInfo, {BackgroundColor3 = originalColor})
            scaleUp:Play()
            colorRestore:Play()
        end)
    end)
end

local buttons = {up, down, onof, plus, mine, keybindButton, resetKeybindButton, closebutton, mini, mini2}
for _, button in pairs(buttons) do
    createClickEffect(button)
end

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRootPart()
    local char = getCharacter()
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function waitForControlModule()
    local success, controlModule = pcall(function()
        return require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    end)
    if success then return controlModule else return nil end
end

local function isMovementAnimation(animationId)
    if not animationId then return false end
    local movementAnimIds = {
        "rbxassetid://180436334", "rbxassetid://180436148", "rbxassetid://125750702",
        "rbxassetid://180436148", "rbxassetid://180435571", "rbxassetid://180435792",
        "rbxassetid://180436334"
    }
    for _, id in pairs(movementAnimIds) do
        if animationId:find(id:gsub("rbxassetid://", "")) then
            return true
        end
    end
    return false
end

local function isCharacterAnchored()
    local char = getCharacter()
    local root = getRootPart()
    if not char or not root then return false end
    if root.Anchored then return true end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Sit then return true end
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Anchored then
            return true
        end
    end
    local joints = root:GetJoints()
    for _, joint in pairs(joints) do
        if joint:IsA("Motor6D") or joint:IsA("Weld") or joint:IsA("WeldConstraint") then
            local otherPart = joint.Part0 == root and joint.Part1 or joint.Part0
            if otherPart and otherPart.Anchored and otherPart.Parent ~= char then
                return true
            end
        end
    end
    return false
end

local function handleAnimations()
    local char = getCharacter()
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if animationConnection then animationConnection:Disconnect() end
    animationConnection = humanoid.AnimationPlayed:Connect(function(track)
        if flyEnabled and flying then
            if track.Animation and track.Animation.AnimationId then
                local animId = track.Animation.AnimationId
                if isMovementAnimation(animId) then
                    track:Stop()
                end
            end
        end
    end)
end

local function preventSitting()
    local char = getCharacter()
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid and flyEnabled then
        if stateChangedConnection then stateChangedConnection:Disconnect() end
        stateChangedConnection = humanoid.StateChanged:Connect(function(old, new)
            if flyEnabled then
                if new == Enum.HumanoidStateType.Seated then
                    task.spawn(function()
                        task.wait(0.1)
                        if flyEnabled and humanoid.Parent then
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end)
                elseif old == Enum.HumanoidStateType.Seated and (new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Running or new == Enum.HumanoidStateType.Freefall) then
                    task.spawn(function()
                        task.wait(0.2)
                        if flyEnabled and humanoid.Parent then
                            humanoid.PlatformStand = true
                            if not flying then
                                startFly()
                            end
                        end
                    end)
                end
            end
        end)
    end
end

local function storeOriginalCollisions()
    originalCollisionStates = {}
    local char = player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                originalCollisionStates[v] = v.CanCollide
            end
        end
    end
end

local function enableNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if not getgenv().noclipfly then return end
    storeOriginalCollisions()
    
    noclipConnection = RunService.Stepped:Connect(function()
        if not flyEnabled or not flying then return end
        local char = player.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    local char = player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                if originalCollisionStates[v] ~= nil then
                    v.CanCollide = originalCollisionStates[v]
                else
                    if v.Name == "Head" or v.Name == "HumanoidRootPart" or 
                       v.Name == "Torso" or v.Name == "UpperTorso" or 
                       v.Name == "LowerTorso" then
                        v.CanCollide = false
                    else
                        v.CanCollide = true
                    end
                end
            end
        end
    end
    task.wait(0.1)
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if humanoid and root then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            task.wait(0.05)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    originalCollisionStates = {}
end

function startFlyV4()
    local char = getCharacter()
    local root = getRootPart()
    if not char or not root or not flyEnabled then return end
    flying = true
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = root
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 1e4
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId then
                if isMovementAnimation(track.Animation.AnimationId) then
                    track:Stop()
                end
            end
        end
        task.wait(0.1)
        humanoid.PlatformStand = true
        preventSitting()
        handleAnimations()
    end
    local controlModule = waitForControlModule()
    local camera = workspace.CurrentCamera
    lastLookDirection = camera.CFrame.LookVector
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled or not flying or not root or not root.Parent then 
            return 
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and not humanoid.PlatformStand then
            humanoid.PlatformStand = true
        end
        local moveVec = Vector3.zero
        if controlModule then moveVec = controlModule:GetMoveVector() end
        local targetVelocity = Vector3.zero
        if moveVec.Magnitude > 0 then
            local cameraCFrame = camera.CFrame
            local direction = cameraCFrame:VectorToWorldSpace(moveVec)
            targetVelocity = direction.Unit * flySpeed
        end
        if bodyVelocity then
            bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(targetVelocity, 0.25)
        end
        if flyEnabled and flying and bodyGyro and not isCharacterAnchored() then
            local currentLookDirection = camera.CFrame.LookVector
            local smoothedLookDirection = lastLookDirection:Lerp(currentLookDirection, rotationSpeed)
            lastLookDirection = smoothedLookDirection
            local targetCFrame = CFrame.lookAt(root.Position, root.Position + smoothedLookDirection)
            bodyGyro.CFrame = targetCFrame
        end
        if targetVelocity.Magnitude == 0 then
            if bodyVelocity then
                bodyVelocity.Velocity = Vector3.zero
            end
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
    enableNoclip()
end

function startFlyV3()
    if not flyEnabled then return end
    flying = true
    
    if nowe == true then
        nowe = false

        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    else 
        nowe = true

        for i = 1, speeds do
            spawn(function()
                local hb = game:GetService("RunService").Heartbeat	
                tpwalking = true
                local chr = game.Players.LocalPlayer.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end
        
        game.Players.LocalPlayer.Character.Animate.Disabled = true
        local Char = game.Players.LocalPlayer.Character
        local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

        for i,v in next, Hum:GetPlayingAnimationTracks() do
            v:AdjustSpeed(0)
        end
        
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    end

    if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
        local plr = game.Players.LocalPlayer
        local torso = plr.Character.Torso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed_v3 = 0

        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame
        local bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        
        spawn(function()
            while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                wait()

                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed_v3 = speed_v3+.5+(speed_v3/maxspeed)
                    if speed_v3 > maxspeed then
                        speed_v3 = maxspeed
                    end
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed_v3 ~= 0 then
                    speed_v3 = speed_v3-1
                    if speed_v3 < 0 then
                        speed_v3 = 0
                    end
                end
                
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed_v3
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed_v3 ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed_v3
                else
                    bv.velocity = Vector3.new(0,0,0)
                end
                
                bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed_v3/maxspeed),0,0)
            end
            
            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            speed_v3 = 0
            bg:Destroy()
            bv:Destroy()
            plr.Character.Humanoid.PlatformStand = false
            game.Players.LocalPlayer.Character.Animate.Disabled = false
            tpwalking = false
        end)

    else
        local plr = game.Players.LocalPlayer
        local UpperTorso = plr.Character.UpperTorso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed_v3 = 0

        local bg = Instance.new("BodyGyro", UpperTorso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = UpperTorso.CFrame
        local bv = Instance.new("BodyVelocity", UpperTorso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        
        spawn(function()
            while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                wait()

                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed_v3 = speed_v3+.5+(speed_v3/maxspeed)
                    if speed_v3 > maxspeed then
                        speed_v3 = maxspeed
                    end
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed_v3 ~= 0 then
                    speed_v3 = speed_v3-1
                    if speed_v3 < 0 then
                        speed_v3 = 0
                    end
                end
                
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed_v3
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed_v3 ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed_v3
                else
                    bv.velocity = Vector3.new(0,0,0)
                end

                bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed_v3/maxspeed),0,0)
            end
            
            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            speed_v3 = 0
            bg:Destroy()
            bv:Destroy()
            plr.Character.Humanoid.PlatformStand = false
            game.Players.LocalPlayer.Character.Animate.Disabled = false
            tpwalking = false
        end)
    end
    
    enableNoclip()
end

function startFly()
    if getgenv().useV3Method then
        startFlyV3()
    else
        startFlyV4()
    end
end

function stopFly()
    flying = false
    nowe = false
    tpwalking = false
    
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if stateChangedConnection then stateChangedConnection:Disconnect() stateChangedConnection = nil end
    if animationConnection then animationConnection:Disconnect() animationConnection = nil end
    
    disableNoclip()
    
    local char = getCharacter()
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = getRootPart()
    
    if humanoid and root then
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        humanoid.PlatformStand = false
        
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        
        task.wait(0.1)
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
        
        char.Animate.Disabled = false
    end
end

local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        onof.Text = "off"
        onof.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        startFly()
    else
        onof.Text = "FLY"
        onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
        stopFly()
    end
end

local function keyCodeToString(keyCode)
    local keyName = tostring(keyCode):gsub("Enum.KeyCode.", "")
    return keyName
end

local function updateKeybindDisplay()
    keybindLabel.Text = keyCodeToString(currentKeybind)
end

local keybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if settingKeybind then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            currentKeybind = input.KeyCode
            updateKeybindDisplay()
            settingKeybind = false
            keybindButton.Text = "Set Keybind"
            keybindButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
        end
    else
        if input.KeyCode == currentKeybind then
            toggleFly()
        end
    end
end)

local function cleanup()
    flyEnabled = false
    flying = false
    nowe = false
    tpwalking = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if stateChangedConnection then stateChangedConnection:Disconnect() stateChangedConnection = nil end
    if animationConnection then animationConnection:Disconnect() animationConnection = nil end
    if keybindConnection then keybindConnection:Disconnect() keybindConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    disableNoclip()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if humanoid and root then
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            humanoid.PlatformStand = false
            task.wait()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            char.Animate.Disabled = false
        end
    end
end

player.CharacterRemoving:Connect(function()
    flying = false
    nowe = false
    tpwalking = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if stateChangedConnection then stateChangedConnection:Disconnect() stateChangedConnection = nil end
    if animationConnection then animationConnection:Disconnect() animationConnection = nil end
    disableNoclip()
end)

player.CharacterAdded:Connect(function(char)
    if flyEnabled then
        task.wait(1)
        startFly()
    end
    task.wait(0.7)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.PlatformStand = false
        player.Character.Animate.Disabled = false
    end
end)

closebutton.MouseButton1Click:Connect(function()
    cleanup()
    main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    up.Visible = false
    down.Visible = false
    onof.Visible = false
    plus.Visible = false
    speed.Visible = false
    mine.Visible = false
    keybindButton.Visible = false
    keybindLabel.Visible = false
    resetKeybindButton.Visible = false
    mini.Visible = false
    mini2.Visible = true
    main.Frame.BackgroundTransparency = 1
    closebutton.Position = UDim2.new(0, 0, -1, 85)
end)

mini2.MouseButton1Click:Connect(function()
    up.Visible = true
    down.Visible = true
    onof.Visible = true
    plus.Visible = true
    speed.Visible = true
    mine.Visible = true
    keybindButton.Visible = true
    keybindLabel.Visible = true
    resetKeybindButton.Visible = true
    mini.Visible = true
    mini2.Visible = false
    main.Frame.BackgroundTransparency = 0 
    closebutton.Position = UDim2.new(0, 0, -1, 55)
end)

onof.MouseButton1Click:Connect(function()
    toggleFly()
end)

plus.MouseButton1Click:Connect(function()
    if getgenv().useV3Method then
        speeds = speeds + 1
        speed.Text = tostring(speeds)
        if nowe == true then
            tpwalking = false
            for i = 1, speeds do
                spawn(function()
                    local hb = game:GetService("RunService").Heartbeat	
                    tpwalking = true
                    local chr = game.Players.LocalPlayer.Character
                    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
        end
    else
        flySpeed = flySpeed + 50
        if flySpeed > 1000 then flySpeed = 1000 end
        speed.Text = tostring(flySpeed)
    end
end)

mine.MouseButton1Click:Connect(function()
    if getgenv().useV3Method then
        if speeds == 1 then
            speed.Text = 'cannot be less than 1'
            wait(1)
            speed.Text = tostring(speeds)
        else
            speeds = speeds - 1
            speed.Text = tostring(speeds)
            if nowe == true then
                tpwalking = false
                for i = 1, speeds do
                    spawn(function()
                        local hb = game:GetService("RunService").Heartbeat	
                        tpwalking = true
                        local chr = game.Players.LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                            if hum.MoveDirection.Magnitude > 0 then
                                chr:TranslateBy(hum.MoveDirection)
                            end
                        end
                    end)
                end
            end
        end
    else
        flySpeed = flySpeed - 50
        if flySpeed < 50 then flySpeed = 50 end
        speed.Text = tostring(flySpeed)
    end
end)

local tis
up.MouseButton1Down:connect(function()
    if getgenv().useV3Method then
        tis = up.MouseEnter:connect(function()
            while tis do
                wait()
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
                end
            end
        end)
    else
        if flyEnabled and flying then
            local root = getRootPart()
            if root and bodyVelocity then
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, flySpeed, 0)
            end
        end
    end
end)

up.MouseLeave:connect(function()
    if tis then
        tis:Disconnect()
        tis = nil
    end
end)

local dis
down.MouseButton1Down:connect(function()
    if getgenv().useV3Method then
        dis = down.MouseEnter:connect(function()
            while dis do
                wait()
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
                end
            end
        end)
    else
        if flyEnabled and flying then
            local root = getRootPart()
            if root and bodyVelocity then
                bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, flySpeed, 0)
            end
        end
    end
end)

down.MouseLeave:connect(function()
    if dis then
        dis:Disconnect()
        dis = nil
    end
end)

keybindButton.MouseButton1Click:Connect(function()
    if not settingKeybind then
        settingKeybind = true
        keybindButton.Text = "Press any key..."
        keybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
    else
        settingKeybind = false
        keybindButton.Text = "Set Keybind"
        keybindButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    end
end)

resetKeybindButton.MouseButton1Click:Connect(function()
    currentKeybind = Enum.KeyCode.F
    updateKeybindDisplay()
    settingKeybind = false
    keybindButton.Text = "Set Keybind"
    keybindButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
end)

if getgenv().useV3Method then
    speed.Text = tostring(speeds)
else
    speed.Text = tostring(flySpeed)
end
updateKeybindDisplay()

local notificationText = "By HKTD"
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "FLY GUI V4";
    Text = notificationText;
    Icon = "rbxassetid://132292718620518";
    Duration = 5;
})
