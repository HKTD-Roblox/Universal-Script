--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

loadstring(game:HttpGet("https://raw.githubusercontent.com/HKTD-Roblox/Script-Beta/refs/heads/main/Mobile-Keyborad.lua", true))()

-- [ESP SCRIPT]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- [ESP SETTINGS]
local ESP_Settings = {
    MenuOpen = true,
    Box = false,
    Name = false,
    Distance = false,
    Outline = false,
    Teammates = false 
}

local COLORS = {
    MainBg = Color3.fromRGB(15, 15, 18),
    HeaderBg = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(255, 65, 65), 
    ToggleOn = Color3.fromRGB(0, 255, 150),
    ToggleOff = Color3.fromRGB(200, 50, 50),
    Text = Color3.fromRGB(255, 255, 255)
}

-- [CORE UI SETUP]
local CoreGui = Instance.new("ScreenGui")
CoreGui.Name = "S3_PRO_ESP_V11"
CoreGui.IgnoreGuiInset = true
CoreGui.ResetOnSpawn = false

local success = pcall(function() CoreGui.Parent = game:GetService("CoreGui") end)
if not success then CoreGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ESP_Container = Instance.new("Folder", CoreGui)

-- [MOBILE TOGGLE BUTTON]
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 45, 0, 45)
OpenButton.Position = UDim2.new(0, 15, 0.5, -22)
OpenButton.BackgroundColor3 = COLORS.HeaderBg
OpenButton.Text = "ESP"
OpenButton.TextColor3 = COLORS.Accent
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 13
OpenButton.Parent = CoreGui
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", OpenButton).Color = COLORS.Accent

-- [MAIN MENU]
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 220, 0, 305)
MainMenu.Position = UDim2.new(0.5, -110, 0.5, -150)
MainMenu.BackgroundColor3 = COLORS.MainBg
MainMenu.Visible = ESP_Settings.MenuOpen
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Parent = CoreGui
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainMenu)
MainStroke.Color = COLORS.Accent
MainStroke.Thickness = 1.5

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "ESP SCRIPT"
Title.TextColor3 = COLORS.Text
Title.BackgroundColor3 = COLORS.HeaderBg
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.Parent = MainMenu
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

OpenButton.MouseButton1Click:Connect(function()
    ESP_Settings.MenuOpen = not ESP_Settings.MenuOpen
    MainMenu.Visible = ESP_Settings.MenuOpen
end)

local function CreateToggle(name, yPos, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.BackgroundColor3 = COLORS.ToggleOff
    btn.Text = name .. ": OFF"
    btn.TextColor3 = COLORS.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = MainMenu
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        ESP_Settings[key] = not ESP_Settings[key]
        btn.Text = name .. (ESP_Settings[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = ESP_Settings[key] and COLORS.ToggleOn or COLORS.ToggleOff
    end)
end

CreateToggle("Box ESP", 50, "Box")
CreateToggle("Name ESP", 95, "Name")
CreateToggle("Distance ESP", 140, "Distance")
CreateToggle("Outline ESP", 185, "Outline")
CreateToggle("Show Teammates", 230, "Teammates")

-- [ADVANCED LOGIC & CACHE]
local espCache = {}

local function GetCharacter(player)
    local char = player.Character or workspace:FindFirstChild(player.Name)
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char
    end
    return nil
end

local function ClearESP(player)
    if espCache[player] then
        espCache[player].Box:Destroy()
        espCache[player].Name:Destroy()
        if espCache[player].Highlight then
            espCache[player].Highlight:Destroy()
        end
        espCache[player] = nil
    end
end

Players.PlayerRemoving:Connect(ClearESP)

-- [PRO RENDER LOOP - FIXED SCALING]
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local char = GetCharacter(player)
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        local isAlive = hrp and (hum == nil or hum.Health > 0)
        local isTeammate = (player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team)
        local shouldShow = isAlive and (ESP_Settings.Teammates or not isTeammate)

        if not espCache[player] then
            local box = Instance.new("Frame", ESP_Container)
            box.BackgroundTransparency = 1
            local stroke = Instance.new("UIStroke", box)
            stroke.Thickness = 1.5
            
            local nameLbl = Instance.new("TextLabel", ESP_Container)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextStrokeTransparency = 0 
            nameLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
            
            espCache[player] = { Box = box, Stroke = stroke, Name = nameLbl, Highlight = nil }
        end

        local data = espCache[player]

        if shouldShow then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            local color = player.TeamColor.Color
            
            -- Outline (Highlight) Logic
            if ESP_Settings.Outline then
                if not data.Highlight or data.Highlight.Parent ~= char then
                    if data.Highlight then data.Highlight:Destroy() end
                    data.Highlight = Instance.new("Highlight", char)
                    data.Highlight.Name = "S3_PRO_HL"
                    data.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    data.Highlight.FillTransparency = 1
                end
                data.Highlight.Enabled = true
                data.Highlight.OutlineColor = color
            elseif data.Highlight then
                data.Highlight.Enabled = false
            end

            -- Screen Drawing & Perfect Bounding Box Logic
            if onScreen then
                -- Karakterin üst ve alt noktalarını 3D dünyada hesaplayıp 2D ekrana çeviriyoruz
                local topPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.2, 0))
                local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                -- Yeni Kutu Yüksekliği ve Genişliği
                local height = math.abs(bottomPos.Y - topPos.Y)
                local width = height / 1.7 -- Karakteri tam saran dar hitbox oranı
                
                if ESP_Settings.Box then
                    data.Box.Visible = true
                    data.Box.Size = UDim2.new(0, width, 0, height)
                    data.Box.Position = UDim2.new(0, pos.X - (width / 2), 0, topPos.Y)
                    data.Stroke.Color = color
                else
                    data.Box.Visible = false
                end

                if ESP_Settings.Name or ESP_Settings.Distance then
                    data.Name.Visible = true
                    -- Yazı yüksekliği tam kafanın "15 piksel" üstüne sabitlendi
                    data.Name.Position = UDim2.new(0, pos.X, 0, topPos.Y - 15)
                    data.Name.TextColor3 = color
                    
                    local text = ""
                    if ESP_Settings.Name then text = player.Name end
                    if ESP_Settings.Distance then 
                        text = text .. (ESP_Settings.Name and " [" or "") .. dist .. "s" .. (ESP_Settings.Name and "]" or "")
                    end
                    data.Name.Text = text
                else
                    data.Name.Visible = false
                end
            else
                data.Box.Visible = false
                data.Name.Visible = false
            end
        else
            data.Box.Visible = false
            data.Name.Visible = false
            if data.Highlight then 
                data.Highlight.Enabled = false 
            end
        end
    end
end)
