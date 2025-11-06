--[[
    AdminEventSystem.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/Systems/AdminEventSystem

    Handles global admin events across all servers using MessagingService
    Similar to how "Grow a Garden", "Fisch", and "Steal a Brainrot" work
]]

local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RandomEvents = require(script.Parent.Parent.RandomEvents)
local PlayerDataManager = require(script.Parent.Parent.PlayerDataManager)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")

local AdminEventSystem = {}

-- Topic name for cross-server communication
local ADMIN_EVENT_TOPIC = "AdminEvents_GlobalTrigger"

-- Available global events
AdminEventSystem.GlobalEvents = {
    "Score Surge",
    "Bed Chaos",
    "Theft Frenzy",
    "Golden Hour",
    "Shield Storm",
    "Score Drain"
}

-- Publish global event to all servers
function AdminEventSystem.PublishGlobalEvent(eventName, adminName)
    local success, err = pcall(function()
        MessagingService:PublishAsync(ADMIN_EVENT_TOPIC, {
            EventName = eventName,
            AdminName = adminName or "Admin",
            Timestamp = os.time()
        })
    end)

    if success then
        print(string.format("[AdminEventSystem] Published global event '%s' to all servers", eventName))
        return true
    else
        warn(string.format("[AdminEventSystem] Failed to publish event: %s", tostring(err)))
        return false
    end
end

-- Handle incoming global events from other servers
local function OnGlobalEventReceived(message)
    local data = message.Data

    if not data or not data.EventName then
        return
    end

    local eventName = data.EventName
    local adminName = data.AdminName or "Admin"

    print(string.format("[AdminEventSystem] Received global event '%s' from %s", eventName, adminName))

    -- Trigger the event on this server
    RandomEvents.TriggerEvent(eventName)

    -- Notify all players that this is a global event
    EventNotificationEvent:FireAllClients(
        string.format("🌐 GLOBAL EVENT triggered by %s!", adminName),
        3,
        nil,
        nil
    )
end

-- Subscribe to global events
function AdminEventSystem.Setup()
    local success, connection = pcall(function()
        return MessagingService:SubscribeAsync(ADMIN_EVENT_TOPIC, OnGlobalEventReceived)
    end)

    if success then
        print(string.format("[AdminEventSystem] Subscribed to global admin events on topic '%s'", ADMIN_EVENT_TOPIC))
    else
        warn(string.format("[AdminEventSystem] Failed to subscribe: %s", tostring(connection)))
    end
end

-- Check if event name is valid
function AdminEventSystem.IsValidEvent(eventName)
    for _, validEvent in ipairs(AdminEventSystem.GlobalEvents) do
        if validEvent:lower() == eventName:lower() then
            return true, validEvent
        end
    end
    return false, nil
end

-- Trigger global event (called by admin commands)
function AdminEventSystem.TriggerGlobalEvent(eventName, adminPlayer)
    local isValid, correctName = AdminEventSystem.IsValidEvent(eventName)

    if not isValid then
        return false, string.format("Invalid event name. Available: %s", table.concat(AdminEventSystem.GlobalEvents, ", "))
    end

    local adminName = adminPlayer and adminPlayer.Name or "Console"

    -- Publish to all servers
    local success = AdminEventSystem.PublishGlobalEvent(correctName, adminName)

    if success then
        return true, string.format("Global event '%s' triggered across ALL servers!", correctName)
    else
        return false, "Failed to publish global event (MessagingService error)"
    end
end

-- List available global events
function AdminEventSystem.ListEvents()
    return string.format("Available Global Events:\n%s", table.concat(AdminEventSystem.GlobalEvents, "\n"))
end

return AdminEventSystem
