-- RandomEvents.lua
-- Triggers random events every 5-15 minutes

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameConfig = require(script.Parent.GameConfig)
local SleepSystem = require(script.Parent.SleepSystem)
local PlayerDataManager = require(script.Parent.PlayerDataManager)
local BedManager = require(script.Parent.BedManager)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")

local RandomEvents = {}
RandomEvents.CurrentEvent = nil
RandomEvents.EventMultiplier = 1
RandomEvents.TheftCooldownMultiplier = 1
RandomEvents.ShieldActive = false

-- Trigger Score Surge
local function TriggerScoreSurge(event)
    print("[RandomEvents] Score Surge activated!")
    RandomEvents.EventMultiplier = event.Multiplier
    EventNotificationEvent:FireAllClients(event.Message, event.Duration)

    task.delay(event.Duration, function()
        RandomEvents.EventMultiplier = 1
        EventNotificationEvent:FireAllClients("", 0)
    end)
end

-- Trigger Bed Chaos
local function TriggerBedChaos(event)
    print("[RandomEvents] Bed Chaos activated!")
    BedManager.RandomizeBeds()
    EventNotificationEvent:FireAllClients(event.Message, 5)

    task.delay(5, function()
        EventNotificationEvent:FireAllClients("", 0)
    end)
end

-- Trigger Theft Frenzy
local function TriggerTheftFrenzy(event)
    print("[RandomEvents] Theft Frenzy activated!")
    RandomEvents.TheftCooldownMultiplier = 0.5
    EventNotificationEvent:FireAllClients(event.Message, event.Duration)

    task.delay(event.Duration, function()
        RandomEvents.TheftCooldownMultiplier = 1
        EventNotificationEvent:FireAllClients("", 0)
    end)
end

-- Trigger Golden Hour
local function TriggerGoldenHour(event)
    print("[RandomEvents] Golden Hour activated!")
    SleepSystem.IsNight = true
    EventNotificationEvent:FireAllClients(event.Message, event.Duration)

    task.delay(event.Duration, function()
        SleepSystem.IsNight = false
        EventNotificationEvent:FireAllClients("", 0)
    end)
end

-- Trigger Shield Storm
local function TriggerShieldStorm(event)
    print("[RandomEvents] Shield Storm activated!")
    RandomEvents.ShieldActive = true
    EventNotificationEvent:FireAllClients(event.Message, event.Duration)

    task.delay(event.Duration, function()
        RandomEvents.ShieldActive = false
        EventNotificationEvent:FireAllClients("", 0)
    end)
end

-- Trigger Score Drain
local function TriggerScoreDrain(event)
    print("[RandomEvents] Score Drain activated!")
    EventNotificationEvent:FireAllClients(event.Message, 5)

    for _, player in ipairs(Players:GetPlayers()) do
        local data = PlayerDataManager.GetData(player)
        if data then
            local drainAmount = data.TimePoints * (event.DrainPercent / 100)
            PlayerDataManager.DeductTimePoints(player, drainAmount)
        end
    end

    task.delay(5, function()
        EventNotificationEvent:FireAllClients("", 0)
    end)
end

-- Event handlers
local EventHandlers = {
    ["Score Surge"] = TriggerScoreSurge,
    ["Bed Chaos"] = TriggerBedChaos,
    ["Theft Frenzy"] = TriggerTheftFrenzy,
    ["Golden Hour"] = TriggerGoldenHour,
    ["Shield Storm"] = TriggerShieldStorm,
    ["Score Drain"] = TriggerScoreDrain,
}

-- Start random event loop
function RandomEvents.Start()
    task.spawn(function()
        while true do
            local waitTime = math.random(GameConfig.RandomEvents.MinInterval, GameConfig.RandomEvents.MaxInterval)
            task.wait(waitTime)

            -- Pick random event
            local events = GameConfig.RandomEvents.Events
            local randomEvent = events[math.random(1, #events)]

            local handler = EventHandlers[randomEvent.Name]
            if handler then
                RandomEvents.CurrentEvent = randomEvent.Name
                handler(randomEvent)
            end
        end
    end)
end

-- Trigger specific event (for admin commands)
function RandomEvents.TriggerEvent(eventName)
    for _, event in ipairs(GameConfig.RandomEvents.Events) do
        if event.Name == eventName then
            local handler = EventHandlers[eventName]
            if handler then
                RandomEvents.CurrentEvent = eventName
                handler(event)
            end
            break
        end
    end
end

return RandomEvents
