--[[
    DayNightCycle.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/DayNightCycle

    Manages day/night transitions with realistic sun/moon movement
]]

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local GameConfig = require(script.Parent.GameConfig)
local SleepSystem = require(script.Parent.SleepSystem)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local DayNightEvent = RemoteEvents:WaitForChild("DayNight")

local DayNightCycle = {}
DayNightCycle.IsDay = true
DayNightCycle.Sun = nil
DayNightCycle.Moon = nil

-- Create sun and moon objects
local function CreateSun()
    local sun = Instance.new("Part")
    sun.Name = "Sun"
    sun.Size = Vector3.new(50, 50, 50)
    sun.Shape = Enum.PartType.Ball
    sun.Material = Enum.Material.Neon
    sun.Color = Color3.fromRGB(255, 230, 100)
    sun.Anchored = true
    sun.CanCollide = false
    sun.CastShadow = false
    sun.TopSurface = Enum.SurfaceType.Smooth
    sun.BottomSurface = Enum.SurfaceType.Smooth

    -- Add glow
    local light = Instance.new("PointLight")
    light.Brightness = 3
    light.Color = Color3.fromRGB(255, 230, 100)
    light.Range = 200
    light.Parent = sun

    -- Add surface light for extra effect
    local surfaceLight = Instance.new("SurfaceLight")
    surfaceLight.Brightness = 5
    surfaceLight.Color = Color3.fromRGB(255, 230, 100)
    surfaceLight.Range = 300
    surfaceLight.Face = Enum.NormalId.Front
    surfaceLight.Parent = sun

    sun.Parent = game.Workspace
    return sun
end

local function CreateMoon()
    local moon = Instance.new("Part")
    moon.Name = "Moon"
    moon.Size = Vector3.new(40, 40, 40)
    moon.Shape = Enum.PartType.Ball
    moon.Material = Enum.Material.Neon
    moon.Color = Color3.fromRGB(200, 220, 255)
    moon.Anchored = true
    moon.CanCollide = false
    moon.CastShadow = false
    moon.TopSurface = Enum.SurfaceType.Smooth
    moon.BottomSurface = Enum.SurfaceType.Smooth
    moon.Transparency = 0.2

    -- Add moon glow
    local light = Instance.new("PointLight")
    light.Brightness = 1.5
    light.Color = Color3.fromRGB(150, 180, 255)
    light.Range = 150
    light.Parent = moon

    moon.Parent = game.Workspace
    return moon
end

-- Update sun/moon position based on time of day
local function UpdateCelestialBodies()
    if not DayNightCycle.Sun or not DayNightCycle.Moon then return end

    -- Get progress through current cycle (0 to 1)
    local timeOfDay = Lighting.ClockTime
    local progress = timeOfDay / 24

    -- Calculate arc path across sky
    local radius = 500  -- Distance from center
    local height = 300  -- Height of arc

    -- Sun position (rises east, sets west)
    local sunAngle = progress * math.pi * 2
    local sunX = math.cos(sunAngle) * radius
    local sunY = math.sin(sunAngle) * height + 200
    local sunZ = math.sin(sunAngle) * radius * 0.3

    DayNightCycle.Sun.Position = Vector3.new(sunX, sunY, sunZ)

    -- Moon position (opposite side of sun)
    local moonAngle = sunAngle + math.pi
    local moonX = math.cos(moonAngle) * radius
    local moonY = math.sin(moonAngle) * height + 200
    local moonZ = math.sin(moonAngle) * radius * 0.3

    DayNightCycle.Moon.Position = Vector3.new(moonX, moonY, moonZ)

    -- Hide sun/moon when below horizon
    DayNightCycle.Sun.Transparency = sunY < 0 and 1 or 0
    DayNightCycle.Moon.Transparency = moonY < 0 and 1 or 0.2
end

-- Switch to day
local function SwitchToDay()
    DayNightCycle.IsDay = true
    SleepSystem.IsNight = false

    -- Smoothly transition lighting
    TweenService:Create(Lighting, TweenInfo.new(5, Enum.EasingStyle.Sine), {
        ClockTime = 12,
        OutdoorAmbient = GameConfig.DayNight.DayAmbient,
        Ambient = GameConfig.DayNight.DayAmbient,
        Brightness = 2,
        ColorShift_Top = Color3.fromRGB(255, 230, 200),
    }):Play()

    -- Notify all clients
    DayNightEvent:FireAllClients(true)
    print("[DayNightCycle] Switched to DAY ☀️")
end

-- Switch to night
local function SwitchToNight()
    DayNightCycle.IsDay = false
    SleepSystem.IsNight = true

    -- Smoothly transition lighting
    TweenService:Create(Lighting, TweenInfo.new(5, Enum.EasingStyle.Sine), {
        ClockTime = 0,
        OutdoorAmbient = GameConfig.DayNight.NightAmbient,
        Ambient = GameConfig.DayNight.NightAmbient,
        Brightness = 0.5,
        ColorShift_Top = Color3.fromRGB(100, 120, 180),
    }):Play()

    -- Notify all clients
    DayNightEvent:FireAllClients(false)
    print("[DayNightCycle] Switched to NIGHT 🌙 (2x earning, increased theft)")
end

-- Start the cycle
function DayNightCycle.Start()
    -- Create sun and moon
    DayNightCycle.Sun = CreateSun()
    DayNightCycle.Moon = CreateMoon()

    -- Initial setup
    SwitchToDay()

    -- Update celestial bodies every frame for smooth movement
    RunService.Heartbeat:Connect(function()
        UpdateCelestialBodies()
    end)

    -- Cycle every 5 minutes
    task.spawn(function()
        while true do
            task.wait(GameConfig.DayNight.CycleDuration)

            if DayNightCycle.IsDay then
                SwitchToNight()
            else
                SwitchToDay()
            end
        end
    end)

    print("[DayNightCycle] Sun and Moon created! Moving across sky...")
end

return DayNightCycle
