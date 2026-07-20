--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox--

loadstring(game:HttpGet("https://raw.githubusercontent.com/HKTD-Roblox/Script-Beta/refs/heads/main/Mobile-Keyborad.lua", true))()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Anti Lag | By HKTD",
    LoadingTitle = "Loading GUI...",
    LoadingSubtitle = "By HKTD | TikTok: @hktd_roblox",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = true
        Invite = "RNgyh8MhxN",
        RememberJoins = true
    }
})

-- Do clean tabs optimization aur graphics ke liye
local LagTab = Window:CreateTab("Lag Optimizer", 4483362458)
local ShaderTab = Window:CreateTab("Beautiful Shaders", 4483362458)

local UltraLoop = nil
local Lighting = game:GetService("Lighting")

-- Helper Function: Purane shaders ko clear karne ke liye
local function ClearAllShaders()
    if UltraLoop then UltraLoop:Disconnect(); UltraLoop = nil end
    for _, shader in pairs(Lighting:GetChildren()) do
        if shader:IsA("PostEffect") or shader:IsA("BlurEffect") or shader:IsA("SunRaysEffect") or shader:IsA("ColorCorrectionEffect") or shader:IsA("BloomEffect") or shader:IsA("DepthOfFieldEffect") or shader:IsA("Atmosphere") then
            shader:Destroy()
        end
    end
end

-- ====================================================
--            SECTION 1: ANTI-LAG PROFILE CODE
-- ====================================================

local function NormalAntiLag()
    ClearAllShaders()
    Lighting.GlobalShadows = false
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level05
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Sparkles") then obj.Enabled = false end
    end
end

local function MediumAntiLag()
    ClearAllShaders()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level03
    Lighting.GlobalShadows = false
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then Terrain.WaterWaveSize = 0; Terrain.WaterWaveSpeed = 0 end
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false end
    end
end

local function SuperAntiLag()
    ClearAllShaders()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize = 0; Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0; Terrain.WaterDetailSize = 0
    end
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0; obj.CastShadow = false
        elseif obj:IsA("Texture") or obj:IsA("Decal") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
            obj.Enabled = false
        end
    end
end

local function UltraAntiLag()
    SuperAntiLag()
    Lighting.Technology = Enum.Technology.Compatibility
    local function AbsolutePotato(obj)
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Clothing") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
            obj.Enabled = false
        end
    end
    UltraLoop = game.DescendantAdded:Connect(function(newObj)
        pcall(function() AbsolutePotato(newObj) end)
    end)
end

-- ====================================================
--            SECTION 2: REALISTIC SHADERS CODE
-- ====================================================

local function ApplyRealistic()
    ClearAllShaders()
    Lighting.Technology = Enum.Technology.Future
    Lighting.GlobalShadows = true
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(40, 40, 50)
    
    local Bloom = Instance.new("BloomEffect", Lighting)
    Bloom.Intensity = 0.4; Bloom.Size = 12; Bloom.Threshold = 0.9
    
    local ColorCorr = Instance.new("ColorCorrectionEffect", Lighting)
    ColorCorr.Contrast = 0.1; ColorCorr.Saturation = 0.15
end

local function ApplySuperRealistic()
    ClearAllShaders()
    Lighting.Technology = Enum.Technology.Future
    Lighting.GlobalShadows = true
    Lighting.Brightness = 2.5
    
    local Bloom = Instance.new("BloomEffect", Lighting)
    Bloom.Intensity = 0.6; Bloom.Size = 24; Bloom.Threshold = 0.85
    
    local SunRays = Instance.new("SunRaysEffect", Lighting)
    SunRays.Intensity = 0.25; SunRays.Spread = 0.6
    
    local ColorCorr = Instance.new("ColorCorrectionEffect", Lighting)
    ColorCorr.Contrast = 0.2; ColorCorr.Saturation = 0.3
    ColorCorr.TintColor = Color3.fromRGB(255, 245, 230)
end

local function ApplyUltraRealistic()
    ClearAllShaders()
    Lighting.Technology = Enum.Technology.Future
    Lighting.GlobalShadows = true
    Lighting.Brightness = 3
    
    local Bloom = Instance.new("BloomEffect", Lighting)
    Bloom.Intensity = 0.8; Bloom.Size = 30; Bloom.Threshold = 0.8
    
    local SunRays = Instance.new("SunRaysEffect", Lighting)
    SunRays.Intensity = 0.4; SunRays.Spread = 0.75
    
    local ColorCorr = Instance.new("ColorCorrectionEffect", Lighting)
    ColorCorr.Contrast = 0.25; ColorCorr.Saturation = 0.4
    
    local Atmos = Instance.new("Atmosphere", Lighting)
    Atmos.Density = 0.2; Atmos.Glare = 0.4; Atmos.Haze = 1.5
    Atmos.Color = Color3.fromRGB(180, 200, 220); Atmos.Decay = Color3.fromRGB(120, 140, 160)
    
    local DOF = Instance.new("DepthOfFieldEffect", Lighting)
    DOF.FarIntensity = 0.2; DOF.FocusDistance = 20; DOF.InFocusRadius = 40; DOF.NearIntensity = 0.05
end

-- ====================================================
--                  GUI CONNECTING BUTTONS
-- ====================================================

LagTab:CreateButton({
    Name = "🟢 Normal Anti-Lag",
    Callback = function() 
        NormalAntiLag() 
        Rayfield:Notify({Title = "Anti-Lag 🟢", Content = "Basic performance tweaks applied.", Duration = 3}) 
    end
})

LagTab:CreateButton({
    Name = "🟡 Medium Anti-Lag",
    Callback = function() 
        MediumAntiLag() 
        Rayfield:Notify({Title = "Anti-Lag 🟡", Content = "Standard shaders disabled.", Duration = 3}) 
    end
})

LagTab:CreateButton({
    Name = "🟠 Super Anti-Lag",
    Callback = function() 
        SuperAntiLag() 
        Rayfield:Notify({Title = "Anti-Lag 🟠", Content = "Textures replaced with smooth plastic.", Duration = 3}) 
    end
})

LagTab:CreateButton({
    Name = "🔴 Ultra Anti-Lag (Potato Mode)",
    Callback = function() 
        UltraAntiLag() 
        Rayfield:Notify({Title = "Anti-Lag 🔴", Content = "Engine forced to minimum + live object wiper active!", Duration = 4}) 
    end
})

ShaderTab:CreateButton({
    Name = "✨ Realistic Shader",
    Callback = function() 
        ApplyRealistic() 
        Rayfield:Notify({Title = "Anti-Lag ✨", Content = "Ambient colors and light contrast boosted.", Duration = 3}) 
    end
})

ShaderTab:CreateButton({
    Name = "🔥 Super Realistic Shader",
    Callback = function() 
        ApplySuperRealistic() 
        Rayfield:Notify({Title = "Anti-Lag 🔥", Content = "Cinematic Sunrays and warm profile loaded!", Duration = 3}) 
    end
})

ShaderTab:CreateButton({
    Name = "👑 Ultra Realistic Shader (Next-Gen)",
    Callback = function() 
        ApplyUltraRealistic() 
        Rayfield:Notify({Title = "Anti-Lag 👑", Content = "Next-gen Depth of Field and atmosphere activated!", Duration = 4}) 
    end
})
