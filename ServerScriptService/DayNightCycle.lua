--[[
    DayNightCycle.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/DayNightCycle

    Simple day/night cycle using Lighting.ClockTime - NO physical sun/moon objects
]]

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local GameConfig = require(script.Parent.GameConfig)
local SleepSystem = require(script.Parent.SleepSystem)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local DayNightEvent = RemoteEvents:WaitForChild("DayNight")

local DayNightCycle = {}
DayNightCycle.IsDay = true

-- Switch to day
local function SwitchToDay()
    DayNightCycle.IsDay = true
    SleepSystem.IsNight = false

    -- Smoothly transition lighting to day
    TweenService:Create(Lighting, TweenInfo.new(5, Enum.EasingStyle.Sine), {
        ClockTime = 12,
        OutdoorAmbient = GameConfig.DayNight.DayAmbient,
        Ambient = GameConfig.DayNight.DayAmbient,
        Brightness = 2,
        ColorShift_Top = Color3.fromRGB(255, 230, 200),
    }):Play()

    -- Notify all clients
    DayNightEvent:FireAllClients(true)
    print("[DayNightCycle] ☀️  DAY - Normal rates")
end

-- Switch to night
local function SwitchToNight()
    DayNightCycle.IsDay = false
    SleepSystem.IsNight = true

    -- Smoothly transition lighting to night
    TweenService:Create(Lighting, TweenInfo.new(5, Enum.EasingStyle.Sine), {
        ClockTime = 0,
        OutdoorAmbient = GameConfig.DayNight.NightAmbient,
        Ambient = GameConfig.DayNight.NightAmbient,
        Brightness = 0.5,
        ColorShift_Top = Color3.fromRGB(100, 120, 180),
    }):Play()

    -- Notify all clients
    DayNightEvent:FireAllClients(false)
    print("[DayNightCycle] 🌙 NIGHT - 2x earning, increased theft")
end

-- Start the cycle
function DayNightCycle.Start()
    -- Initial setup
    SwitchToDay()

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

    print("[DayNightCycle] Started - Cycles every", GameConfig.DayNight.CycleDuration, "seconds")
end

return DayNightCycle
