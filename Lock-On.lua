local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer
local specialPlace = game.PlaceId == 9391468976

local lockEnabled = false
local targetMode = "PLAYER"
local lockType = "Camera"
local selectedDevice = nil
local forceHoldCamera = false
local cameraSmooth = 1
local characterSmooth = 0.35
local sideOffset = -1.27

local idleIcon = specialPlace and "rbxassetid://110432273832755" or "rbxassetid://73466246454364"
local activeIcon = specialPlace and "rbxassetid://139332620449694" or "rbxassetid://113252099863593"
local markerIcon = specialPlace and "rbxassetid://100230908593841" or "rbxassetid://125342227220370"

local function saveConfig()
	if typeof(writefile) ~= "function" then
		return
	end
	pcall(function()
		writefile("LockOn_Config.json", HttpService:JSONEncode({
			cameraSmooth = cameraSmooth,
			characterSmooth = characterSmooth,
			sideOffset = sideOffset,
			lockType = lockType,
			targetMode = targetMode,
			device = selectedDevice or "Mobile",
			forceHoldCamera = forceHoldCamera,
		}))
	end)
end

local function loadConfig()
	if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" then
		return
	end
	if not isfile("LockOn_Config.json") then
		return
	end
	local success, data = pcall(function()
		return HttpService:JSONDecode(readfile("LockOn_Config.json"))
	end)
	if not success or type(data) ~= "table" then
		return
	end
	cameraSmooth = data.cameraSmooth or data.camSmooth or cameraSmooth
	characterSmooth = data.characterSmooth or data.charSmooth or characterSmooth
	sideOffset = data.sideOffset or data.rightOffset or sideOffset
	lockType = data.lockType or lockType
	targetMode = data.targetMode or targetMode
	forceHoldCamera = data.forceHoldCamera or data.forceResetUniversal or false
end

loadConfig()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LockOnScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local lockButton = nil
local targetMarker = nil
local lockedHead = nil
local holdCameraActive = false
local lastRetargetTime = 0
local lastMarkerTime = 0
local aimCache = {}
local aimCacheTime = 0
local aimCacheTtl = 0.016
local screenCenter = nil
local lastViewport = nil
local seenModels = {}

local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Exclude

local function restoreCamera()
	if not holdCameraActive then
		return
	end
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and camera then
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = humanoid
	end
end

local function setHoldCamera(enabled)
	local needHold = (specialPlace and lockType ~= "Character") or (forceHoldCamera and lockType ~= "Character")
	if not needHold then
		if holdCameraActive then
			holdCameraActive = false
			RunService:UnbindFromRenderStep("FlashCamLoop")
		end
		return
	end
	if enabled and not holdCameraActive then
		holdCameraActive = true
		RunService:BindToRenderStep("FlashCamLoop", Enum.RenderPriority.Last.Value + 2000, restoreCamera)
	elseif not enabled and holdCameraActive then
		holdCameraActive = false
		RunService:UnbindFromRenderStep("FlashCamLoop")
	end
end

local function isValidTarget(head)
	if not head or not head.Parent then
		return false
	end
	local model = head.Parent
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 or model == localPlayer.Character then
		return false
	end
	local owner = Players:GetPlayerFromCharacter(model)
	if targetMode == "PLAYER" then
		return owner ~= nil
	end
	if targetMode == "NPC" then
		return owner == nil
	end
	return false
end

local function getHead(model)
	return model and model:FindFirstChild("Head")
end

local function getAimPoint(head)
	if not head then
		return nil
	end
	local now = tick()
	if aimCache[head] and now - aimCacheTime < aimCacheTtl then
		return aimCache[head]
	end
	local model = head.Parent
	if not model then
		return nil
	end
	local neck = head:FindFirstChild("NeckAttachment")
	if not neck then
		local upper = model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
		if upper then
			neck = upper:FindFirstChild("NeckAttachment")
		end
	end
	local point
	if neck and neck:IsA("Attachment") then
		point = neck.WorldPosition
	else
		point = (head.CFrame * CFrame.new(0, -0.5, 0)).Position
	end
	aimCache[head] = point
	aimCacheTime = now
	return point
end

local function getSmoothedAim(head)
	if not head then
		return nil
	end
	local model = head.Parent
	local character = localPlayer.Character
	if not character or not model then
		return getAimPoint(head)
	end
	local myRoot = character:FindFirstChild("HumanoidRootPart")
	local theirRoot = model:FindFirstChild("HumanoidRootPart")
	if not myRoot or not theirRoot then
		return getAimPoint(head)
	end
	local headPoint = getAimPoint(head)
	local distance = (myRoot.Position - theirRoot.Position).Magnitude
	if distance >= 22 then
		return headPoint
	end
	if distance <= 7 then
		return theirRoot.Position
	end
	return theirRoot.Position:Lerp(headPoint, (distance - 7) / 15)
end

local function onTargetDied(model)
	if not model then
		return
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	local connection
	connection = humanoid.Died:Connect(function()
		if connection then
			connection:Disconnect()
		end
		lockEnabled = false
		lockedHead = nil
		setHoldCamera(false)
		if lockButton and lockButton.Visible then
			lockButton.Image = idleIcon
		end
		if targetMarker then
			targetMarker.Enabled = false
		end
	end)
end

local function getScreenCenter()
	local size = camera.ViewportSize
	if lastViewport ~= size then
		lastViewport = size
		screenCenter = Vector2.new(size.X / 2, size.Y / 2)
	end
	return screenCenter
end

local function findClosestTarget()
	local character = localPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end
	local center = getScreenCenter()
	overlapParams.FilterDescendantsInstances = { character }
	local parts = workspace:GetPartBoundsInRadius(root.Position, 55, overlapParams)
	table.clear(seenModels)
	local bestHead = nil
	local bestDistance = math.huge
	for _, part in ipairs(parts) do
		local model = part:FindFirstAncestorWhichIsA("Model")
		if model and model ~= character and not seenModels[model] then
			seenModels[model] = true
			local humanoid = model:FindFirstChildOfClass("Humanoid")
			local owner = Players:GetPlayerFromCharacter(model)
			local valid = humanoid and humanoid.Health > 0
			if valid then
				if targetMode == "PLAYER" then
					valid = owner ~= nil
				elseif targetMode == "NPC" then
					valid = owner == nil
				end
			end
			if valid then
				local head = getHead(model)
				local worldPoint = head and getAimPoint(head)
				if worldPoint then
					local screenPoint, onScreen = camera:WorldToViewportPoint(worldPoint)
					if onScreen then
						local dx = screenPoint.X - center.X
						local dy = screenPoint.Y - center.Y
						local distSq = dx * dx + dy * dy
						if distSq < bestDistance * bestDistance then
							bestDistance = math.sqrt(distSq)
							bestHead = head
						end
					end
				end
			end
		end
	end
	return bestHead
end

local function pulseButton(pressed)
	if not lockButton or not lockButton.Visible then
		return
	end
	TweenService:Create(lockButton, TweenInfo.new(pressed and 0.2 or 0.25, Enum.EasingStyle.Quad), {
		Size = pressed and UDim2.new(0, 78, 0, 78) or UDim2.new(0, 85, 0, 85),
		ImageTransparency = pressed and 0.15 or 0,
	}):Play()
end

local function bounceButton()
	if not lockButton or not lockButton.Visible then
		return
	end
	local shrink = TweenService:Create(lockButton, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 72, 0, 72),
	})
	local grow = TweenService:Create(lockButton, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 85, 0, 85),
	})
	shrink:Play()
	shrink.Completed:Connect(function()
		grow:Play()
	end)
end

local function toggleLock()
	bounceButton()
	lockEnabled = not lockEnabled
	lockedHead = lockEnabled and findClosestTarget() or nil
	if not lockEnabled then
		setHoldCamera(false)
		if targetMarker then
			targetMarker.Enabled = false
		end
	elseif lockedHead then
		setHoldCamera(true)
		if lockedHead.Parent then
			onTargetDied(lockedHead.Parent)
		end
	end
	if lockButton and lockButton.Visible then
		lockButton.Image = lockEnabled and activeIcon or idleIcon
	end
end

local function createLockButton()
	lockButton = Instance.new("ImageButton")
	lockButton.Name = "LockButton"
	lockButton.Size = UDim2.new(0, 85, 0, 85)
	lockButton.Position = UDim2.new(1, -95, 0, 10)
	lockButton.BackgroundTransparency = 1
	lockButton.Image = idleIcon
	lockButton.Visible = false
	lockButton.Parent = screenGui
	Instance.new("UICorner", lockButton).CornerRadius = UDim.new(1, 0)

	targetMarker = Instance.new("BillboardGui")
	targetMarker.Name = "TargetMarker"
	targetMarker.AlwaysOnTop = true
	targetMarker.Enabled = false
	targetMarker.Parent = screenGui

	local markerImage = Instance.new("ImageLabel")
	markerImage.Size = UDim2.new(1, 0, 1, 0)
	markerImage.BackgroundTransparency = 1
	markerImage.Image = markerIcon
	markerImage.ImageTransparency = specialPlace and 0.45 or 0.5
	markerImage.ImageColor3 = specialPlace and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
	markerImage.Parent = targetMarker
	Instance.new("UICorner", markerImage).CornerRadius = UDim.new(1, 0)

	local pressing = false
	local dragging = false
	local dragLocked = false
	local startPosition = nil
	local startInput = nil

	lockButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			pressing = true
			startPosition = lockButton.Position
			startInput = input.Position
			pulseButton(true)
			task.delay(0.45, function()
				if pressing then
					dragging = true
					dragLocked = true
				end
			end)
		end
	end)

	lockButton.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startInput
			lockButton.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end
	end)

	lockButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			pressing = false
			dragging = false
			dragLocked = false
			pulseButton(false)
		end
	end)

	lockButton.MouseButton1Click:Connect(function()
		if dragging or dragLocked then
			return
		end
		toggleLock()
	end)
end

local function createNumberField(parent, labelText, value, y)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.42, 0, 0, 18)
	label.Position = UDim2.new(0.04, 0, 0, y)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.Parent = parent

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.48, 0, 0, 22)
	box.Position = UDim2.new(0.48, 0, 0, y - 2)
	box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	box.Text = tostring(value)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.Parent = parent
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	Instance.new("UIStroke", box).Color = Color3.fromRGB(0, 200, 200)
	return box
end

local function openSettings()
	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(0, 300, 0, specialPlace and 280 or 350)
	panel.Position = UDim2.new(0.5, -150, 0.5, specialPlace and -140 or -175)
	panel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	panel.Parent = screenGui
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
	Instance.new("UIStroke", panel).Color = Color3.fromRGB(0, 255, 255)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 26)
	title.BackgroundTransparency = 1
	title.Text = specialPlace and "JJS Lock On" or "Lock On Settings"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 15
	title.Parent = panel

	local modeLabel = Instance.new("TextLabel")
	modeLabel.Size = UDim2.new(1, 0, 0, 16)
	modeLabel.Position = UDim2.new(0, 0, 0, 28)
	modeLabel.BackgroundTransparency = 1
	modeLabel.Text = "Lock Mode:"
	modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	modeLabel.Font = Enum.Font.Gotham
	modeLabel.TextSize = 12
	modeLabel.Parent = panel

	local selectedLock = lockType
	local modeButtons = {}
	local fieldsFrame = Instance.new("Frame")
	fieldsFrame.Size = UDim2.new(1, 0, 0, 80)
	fieldsFrame.Position = UDim2.new(0, 0, 0, 78)
	fieldsFrame.BackgroundTransparency = 1
	fieldsFrame.Parent = panel

	local cameraSmoothBox, sideOffsetBox, characterSmoothBox
	local holdLabel, holdDesc, holdToggle

	local function refreshFields()
		for _, child in ipairs(fieldsFrame:GetChildren()) do
			child:Destroy()
		end
		local y = 0
		if selectedLock == "Camera" or selectedLock == "CameraCharacter" then
			if specialPlace or selectedLock == "CameraCharacter" then
				cameraSmoothBox = createNumberField(fieldsFrame, "Camera Smooth", cameraSmooth, y)
				y = y + 26
				sideOffsetBox = createNumberField(fieldsFrame, "Side Offset", sideOffset, y)
				y = y + 26
			end
		end
		if selectedLock == "CameraCharacter" or selectedLock == "Character" then
			characterSmoothBox = createNumberField(fieldsFrame, "Character Smooth", characterSmooth, y)
		end
		if holdLabel then
			local show = not specialPlace and (selectedLock == "Camera" or selectedLock == "CameraCharacter")
			holdLabel.Visible = show
			holdDesc.Visible = show
			holdToggle.Visible = show
		end
	end

	local modes = {
		{ id = "Camera", label = "Camera" },
		{ id = "CameraCharacter", label = "Cam + Char" },
		{ id = "Character", label = "Character" },
	}

	for index, mode in ipairs(modes) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.29, 0, 0, 24)
		button.Position = UDim2.new(0.04 + (index - 1) * 0.32, 0, 0, 46)
		button.Text = mode.label
		button.Font = Enum.Font.GothamBold
		button.TextSize = 11
		button.TextColor3 = Color3.new(1, 1, 1)
		button.BackgroundColor3 = selectedLock == mode.id and Color3.fromRGB(0, 180, 180) or Color3.fromRGB(45, 45, 45)
		button.Parent = panel
		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
		modeButtons[mode.id] = button
		button.MouseButton1Click:Connect(function()
			selectedLock = mode.id
			for key, btn in pairs(modeButtons) do
				btn.BackgroundColor3 = key == mode.id and Color3.fromRGB(0, 180, 180) or Color3.fromRGB(45, 45, 45)
			end
			refreshFields()
		end)
	end

	if not specialPlace then
		holdLabel = Instance.new("TextLabel")
		holdLabel.Size = UDim2.new(1, -16, 0, 14)
		holdLabel.Position = UDim2.new(0, 8, 0, 165)
		holdLabel.BackgroundTransparency = 1
		holdLabel.Text = "HOLD CAMERA"
		holdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		holdLabel.Font = Enum.Font.Gotham
		holdLabel.TextSize = 11
		holdLabel.TextXAlignment = Enum.TextXAlignment.Left
		holdLabel.Parent = panel

		holdDesc = Instance.new("TextLabel")
		holdDesc.Size = UDim2.new(1, -16, 0, 24)
		holdDesc.Position = UDim2.new(0, 8, 0, 178)
		holdDesc.BackgroundTransparency = 1
		holdDesc.Text = "Keeps camera locked on target. Enable only if it detaches."
		holdDesc.TextColor3 = Color3.fromRGB(160, 160, 160)
		holdDesc.Font = Enum.Font.Gotham
		holdDesc.TextSize = 10
		holdDesc.TextWrapped = true
		holdDesc.TextXAlignment = Enum.TextXAlignment.Left
		holdDesc.TextYAlignment = Enum.TextYAlignment.Top
		holdDesc.Parent = panel

		holdToggle = Instance.new("TextButton")
		holdToggle.Size = UDim2.new(0.85, 0, 0, 24)
		holdToggle.Position = UDim2.new(0.075, 0, 0, 204)
		holdToggle.Text = forceHoldCamera and "ENABLED" or "DISABLED"
		holdToggle.Font = Enum.Font.GothamBold
		holdToggle.TextSize = 12
		holdToggle.TextColor3 = Color3.new(1, 1, 1)
		holdToggle.BackgroundColor3 = forceHoldCamera and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 50, 50)
		holdToggle.Parent = panel
		Instance.new("UICorner", holdToggle).CornerRadius = UDim.new(0, 5)
		holdToggle.MouseButton1Click:Connect(function()
			forceHoldCamera = not forceHoldCamera
			holdToggle.Text = forceHoldCamera and "ENABLED" or "DISABLED"
			holdToggle.BackgroundColor3 = forceHoldCamera and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 50, 50)
		end)
	end

	refreshFields()

	local sectionY = specialPlace and 165 or 235

	local targetLabel = Instance.new("TextLabel")
	targetLabel.Size = UDim2.new(1, 0, 0, 14)
	targetLabel.Position = UDim2.new(0, 0, 0, sectionY)
	targetLabel.BackgroundTransparency = 1
	targetLabel.Text = "Target Mode:"
	targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	targetLabel.Font = Enum.Font.Gotham
	targetLabel.TextSize = 12
	targetLabel.Parent = panel

	local selectedTarget = targetMode
	local playersButton = Instance.new("TextButton")
	playersButton.Size = UDim2.new(0.4, 0, 0, 24)
	playersButton.Position = UDim2.new(0.07, 0, 0, sectionY + 16)
	playersButton.Text = "Players"
	playersButton.Font = Enum.Font.GothamBold
	playersButton.TextColor3 = Color3.new(1, 1, 1)
	playersButton.BackgroundColor3 = selectedTarget == "PLAYER" and Color3.fromRGB(0, 180, 180) or Color3.fromRGB(45, 45, 45)
	playersButton.Parent = panel
	Instance.new("UICorner", playersButton).CornerRadius = UDim.new(0, 5)

	local npcButton = Instance.new("TextButton")
	npcButton.Size = UDim2.new(0.4, 0, 0, 24)
	npcButton.Position = UDim2.new(0.53, 0, 0, sectionY + 16)
	npcButton.Text = "NPC"
	npcButton.Font = Enum.Font.GothamBold
	npcButton.TextColor3 = Color3.new(1, 1, 1)
	npcButton.BackgroundColor3 = selectedTarget == "NPC" and Color3.fromRGB(0, 180, 180) or Color3.fromRGB(45, 45, 45)
	npcButton.Parent = panel
	Instance.new("UICorner", npcButton).CornerRadius = UDim.new(0, 5)

	playersButton.MouseButton1Click:Connect(function()
		selectedTarget = "PLAYER"
		playersButton.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
		npcButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	end)

	npcButton.MouseButton1Click:Connect(function()
		selectedTarget = "NPC"
		npcButton.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
		playersButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	end)

	local confirm = Instance.new("TextButton")
	confirm.Size = UDim2.new(0.85, 0, 0, 28)
	confirm.Position = UDim2.new(0.075, 0, 0, sectionY + 52)
	confirm.Text = "Confirm & Save"
	confirm.Font = Enum.Font.GothamBold
	confirm.TextColor3 = Color3.new(1, 1, 1)
	confirm.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
	confirm.Parent = panel
	Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 6)

	confirm.MouseButton1Click:Connect(function()
		cameraSmooth = cameraSmoothBox and tonumber(cameraSmoothBox.Text) or cameraSmooth
		sideOffset = sideOffsetBox and tonumber(sideOffsetBox.Text) or sideOffset
		characterSmooth = characterSmoothBox and tonumber(characterSmoothBox.Text) or characterSmooth
		lockType = selectedLock
		targetMode = selectedTarget
		saveConfig()
		panel:Destroy()
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = "Lock On",
				Text = "Settings saved!",
				Duration = 4,
			})
		end)
	end)
end

local function applyDevice(deviceName)
	selectedDevice = deviceName
	saveConfig()
	if deviceName == "Mobile" then
		if lockButton then
			lockButton.Visible = true
		end
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = "Lock On",
				Text = "Mobile mode enabled. Tap the lock button to toggle.",
				Duration = 5,
			})
		end)
	else
		if lockButton then
			lockButton.Visible = false
		end
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = "Lock On",
				Text = "PC mode enabled. Press X to toggle lock.",
				Duration = 5,
			})
		end)
	end
	openSettings()
end

local function askDevice()
	local callback = Instance.new("BindableFunction")
	callback.OnInvoke = function(buttonText)
		if buttonText == "Mobile" then
			applyDevice("Mobile")
		elseif buttonText == "PC" then
			applyDevice("PC")
		end
	end
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Lock On",
			Text = "Choose your device",
			Duration = 20,
			Button1 = "Mobile",
			Button2 = "PC",
			Callback = callback,
		})
	end)
end

createLockButton()
askDevice()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if selectedDevice == "PC" and input.KeyCode == Enum.KeyCode.X then
		toggleLock()
	elseif input.KeyCode == Enum.KeyCode.L then
		openSettings()
	end
end)

if localPlayer.Character then
	onTargetDied(localPlayer.Character)
end
localPlayer.CharacterAdded:Connect(onTargetDied)

RunService:BindToRenderStep("LockCameraLoop", Enum.RenderPriority.Last.Value + 100, function()
	if not lockEnabled then
		if targetMarker then
			targetMarker.Enabled = false
		end
		return
	end

	local now = tick()
	if now - lastRetargetTime > 0.25 then
		if not isValidTarget(lockedHead) then
			lockedHead = findClosestTarget()
			setHoldCamera(lockedHead ~= nil)
			if lockedHead and lockedHead.Parent then
				onTargetDied(lockedHead.Parent)
			end
		end
		lastRetargetTime = now
	end

	if lockedHead and lockedHead.Parent then
		local aimPoint = getSmoothedAim(lockedHead)
		local character = localPlayer.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if (lockType == "CameraCharacter" or lockType == "Character") and root and aimPoint then
			local flat = Vector3.new(aimPoint.X, root.Position.Y, aimPoint.Z)
			root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position, flat), characterSmooth)
		end

		if (lockType == "Camera" or lockType == "CameraCharacter") and aimPoint then
			if specialPlace then
				local look = CFrame.new(camera.CFrame.Position, aimPoint - camera.CFrame.RightVector * sideOffset)
				camera.CFrame = camera.CFrame:Lerp(look, cameraSmooth)
			elseif lockType == "Camera" then
				camera.CFrame = CFrame.new(camera.CFrame.Position, aimPoint)
			else
				local look = CFrame.new(camera.CFrame.Position, aimPoint - camera.CFrame.RightVector * sideOffset)
				camera.CFrame = camera.CFrame:Lerp(look, cameraSmooth)
			end
		end

		local adorn = lockedHead.Parent:FindFirstChild("UpperTorso")
			or lockedHead.Parent:FindFirstChild("Torso")
			or lockedHead.Parent:FindFirstChild("HumanoidRootPart")

		if adorn and targetMarker then
			targetMarker.Adornee = adorn
			targetMarker.Enabled = true
			if now - lastMarkerTime > 0.1 then
				local size = 1400 / ((camera.CFrame.Position - adorn.Position).Magnitude + 8) * math.clamp(lockedHead.Size.Y * 2.5, 3, 10)
				targetMarker.Size = UDim2.new(0, size, 0, size)
				lastMarkerTime = now
			end
		elseif targetMarker then
			targetMarker.Enabled = false
		end
	elseif targetMarker then
		targetMarker.Enabled = false
	end
end)
