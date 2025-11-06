--[[
    DayNightCycle.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/DayNightCycle

    Manages day/night transitions every 5 minutes
]]

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

    -- Update lighting
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

    TweenService:Create(Lighting, tweenInfo, {
        ClockTime = 14,
        OutdoorAmbient = GameConfig.DayNight.DayAmbient,
        Ambient = GameConfig.DayNight.DayAmbient,
        Brightness = 2,
    }):Play()

    -- Notify all clients
    DayNightEvent:FireAllClients(true)
    print("[DayNightCycle] Switched to DAY")
end

-- Switch to night
local function SwitchToNight()
    DayNightCycle.IsDay = false
    SleepSystem.IsNight = true

    -- Update lighting
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

    TweenService:Create(Lighting, tweenInfo, {
        ClockTime = 0,
        OutdoorAmbient = GameConfig.DayNight.NightAmbient,
        Ambient = GameConfig.DayNight.NightAmbient,
        Brightness = 0.5,
    }):Play()

    -- Notify all clients
    DayNightEvent:FireAllClients(false)
    print("[DayNightCycle] Switched to NIGHT (2x earning, increased theft)")
end

-- Start the cycle
function DayNightCycle.Start()
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
end

return DayNightCycle
