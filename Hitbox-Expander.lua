--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

loadstring(game:HttpGet("https://raw.githubusercontent.com/HKTD-Roblox/Script-Beta/refs/heads/main/Script-By-HKTD.lua", true))()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local window = WindUI:CreateWindow({
	Title = "Hitbox Expander",
	Author = "By HKTD",
	Icon = "move"
})

local hitbox_tab = window:Tab({
	Title = "Hitbox",
	Icon = "box"
})

local size = 13
local transparency = 0.8
local color = Color3.fromRGB(0, 0, 255)
local expanded = false

local hitbox_toggle = hitbox_tab:Toggle({
	Title = "Expand Hitbox",
	Desc = "Enable/Disable the hitbox expander.",
	Type = "Checkbox",
	Icon = "check",
	Value = false,
	Callback = function(state)
        if state then
		    expanded = true
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

					hrp.Size = Vector3.new(size, size, size)
					hrp.Transparency = transparency
                    hrp.Color = color
				end
			end
		else
		    expanded = false
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

					hrp.Size = Vector3.new(2, 2, 1)
					hrp.Transparency = 1
				end
			end
		end
	end
})

local divider = hitbox_tab:Divider()

local size_slider = hitbox_tab:Slider({
    Title = "Hitbox Size",
	Desc = "Customize the hitbox size from 13-25.",
	Step = 1,
    Value = {
		Min = 13,
		Max = 25,
		Default = 13
	},
	Callback = function(value)
	    if expanded then
        	for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

					hrp.Size = Vector3.new(value, value, value)
				end
			end
		end
	end
})

local transparency_slider = hitbox_tab:Slider({
	Title = "Hitbox Transparency",
	Desc = "Customize hitbox transparency from 0.4-0.9",
	Step = 0.1,
	Value = {
		Min = 0.4,
		Max = 0.9,
		Default = 0.8
	},
	Callback = function(value)
	    if expanded then
        	for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

					hrp.Transparency = value
				end
			end
		end
	end
})

local hitbox_color_picker = hitbox_tab:Dropdown({
	Title = "Hitbox Color",
	Desc = "Customize the color of the hitbox visualisation.",
	Values = {"Blue", "Green", "Red", "Orange", "Yellow", "White"},
	Value = "Blue",
	Callback = function(option)
	    if expanded then 
        	if option == "Blue" then
				color = Color3.fromRGB(0, 0, 255)
			elseif option == "Green" then
				color = Color3.fromRGB(0, 255, 0)
			elseif option == "Red" then
				color = Color3.fromRGB(255, 0, 0)
			elseif option == "Orange" then
			    color = Color3.fromRGB(255, 165, 0)
			elseif option == "Yellow" then
			    color = Color3.fromRGB(255, 255, 0)
			elseif option == "White" then
			    color = Color3.fromRGB(255, 255, 255)
			end

		    for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

                    hrp.Color = color
				end
			end
		end
	end
})

local highlight_hitboxes_toggle = hitbox_tab:Toggle({
	Title = "Highlight Hitboxes",
	Desc = "Toggle the highlight of the hitboxes.",
	Type = "Checkbox",
	Icon = "check",
	Callback = function(state)
        if state and expanded then
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

                    local highlight = Instance.new("Highlight")
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
					highlight.FillColor = color
					highlight.Parent = hrp
				end
			end
		else
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

					for _, item in hrp:GetDescendants() do
						if item:IsA("Highlight") then
							item:Destroy()
						end
					end
				end
			end
		end
	end
})

local visualise_hitboxes_toggle = hitbox_tab:Toggle({
	Title = "Visualise Hitboxes",
	Desc = "Enable/Disable visualisation of hitboxes",
	Type = "Checkbox",
	Icon = "check",
	Value = true,
	Callback = function(state)
		if state and expanded then
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

					hrp.Transparency = transparency
				end
			end
		else
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					local hrp = player.Character:WaitForChild("HumanoidRootPart")

					hrp.Transparency = 1
				end
			end
		end
	end
})
