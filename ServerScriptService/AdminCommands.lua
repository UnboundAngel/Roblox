--[[
    AdminCommands.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/AdminCommands

    Admin abuse commands for server-wide control
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameConfig = require(script.Parent.GameConfig)
local PlayerDataManager = require(script.Parent.PlayerDataManager)
local ToolSystem = require(script.Parent.ToolSystem)
local SleepSystem = require(script.Parent.SleepSystem)
local RandomEvents = require(script.Parent.RandomEvents)
local BedManager = require(script.Parent.BedManager)
local AdminEventSystem = require(script.Parent.Systems.AdminEventSystem)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local AdminCommandEvent = RemoteEvents:WaitForChild("AdminCommand")

local AdminCommands = {}

-- Check if player is admin
local function IsAdmin(player)
    return table.find(GameConfig.Admins, player.UserId) ~= nil
end

-- Command handlers
local Commands = {
    -- Give unlimited tools
    GiveTools = function(admin, targetName, uses)
        local target = Players:FindFirstChild(targetName)
        if target then
            ToolSystem.GiveTool(target, tonumber(uses) or 999)
            return string.format("Gave %d-use tool to %s", tonumber(uses) or 999, targetName)
        end
        return "Player not found"
    end,

    -- Set player score
    SetScore = function(admin, targetName, amount)
        local target = Players:FindFirstChild(targetName)
        if target then
            local data = PlayerDataManager.GetData(target)
            if data then
                data.TimePoints = tonumber(amount) or 0
                PlayerDataManager.AddTimePoints(target, 0)  -- Trigger update
                return string.format("Set %s's score to %d", targetName, tonumber(amount) or 0)
            end
        end
        return "Player not found"
    end,

    -- Add points to player
    AddScore = function(admin, targetName, amount)
        local target = Players:FindFirstChild(targetName)
        if target then
            PlayerDataManager.AddTimePoints(target, tonumber(amount) or 0)
            return string.format("Added %d points to %s", tonumber(amount) or 0, targetName)
        end
        return "Player not found"
    end,

    -- Steal from player
    StealFrom = function(admin, targetName, amount)
        local target = Players:FindFirstChild(targetName)
        if target then
            if PlayerDataManager.DeductTimePoints(target, tonumber(amount) or 0) then
                PlayerDataManager.AddTimePoints(admin, tonumber(amount) or 0)
                return string.format("Stole %d points from %s", tonumber(amount) or 0, targetName)
            end
            return "Target doesn't have enough points"
        end
        return "Player not found"
    end,

    -- Force wake player
    WakePlayer = function(admin, targetName)
        local target = Players:FindFirstChild(targetName)
        if target then
            SleepSystem.WakePlayer(target)
            return string.format("Woke up %s", targetName)
        end
        return "Player not found"
    end,

    -- Wake all players
    WakeAll = function(admin)
        for _, player in ipairs(Players:GetPlayers()) do
            SleepSystem.WakePlayer(player)
        end
        return "Woke up all players"
    end,

    -- Toggle god mode (immune to theft)
    GodMode = function(admin, targetName)
        local target = targetName and Players:FindFirstChild(targetName) or admin
        if target then
            local data = PlayerDataManager.GetData(target)
            if data then
                data.GodMode = not data.GodMode
                return string.format("%s god mode: %s", target.Name, data.GodMode and "ON" or "OFF")
            end
        end
        return "Player not found"
    end,

    -- Trigger random event
    TriggerEvent = function(admin, eventName)
        RandomEvents.TriggerEvent(eventName)
        return string.format("Triggered event: %s", eventName)
    end,

    -- Randomize all beds
    RandomizeBeds = function(admin)
        BedManager.RandomizeBeds()
        return "Randomized all beds"
    end,

    -- Teleport to player
    TeleportTo = function(admin, targetName)
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character.PrimaryPart then
            if admin.Character and admin.Character.PrimaryPart then
                admin.Character:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame + Vector3.new(5, 0, 0))
                return string.format("Teleported to %s", targetName)
            end
        end
        return "Could not teleport"
    end,

    -- Teleport player to you
    Bring = function(admin, targetName)
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character.PrimaryPart then
            if admin.Character and admin.Character.PrimaryPart then
                target.Character:SetPrimaryPartCFrame(admin.Character.PrimaryPart.CFrame + Vector3.new(5, 0, 0))
                return string.format("Brought %s to you", targetName)
            end
        end
        return "Could not teleport"
    end,

    -- Broadcast message
    Broadcast = function(admin, ...)
        local message = table.concat({...}, " ")
        for _, player in ipairs(Players:GetPlayers()) do
            local EventNotification = RemoteEvents:FindFirstChild("EventNotification")
            if EventNotification then
                EventNotification:FireClient(player, "📢 " .. admin.Name .. ": " .. message, 10)
            end
        end
        return "Broadcasted: " .. message
    end,

    -- Trigger GLOBAL event (across all servers)
    GlobalEvent = function(admin, eventName)
        if not eventName then
            return "Usage: GlobalEvent <event name>"
        end
        local success, message = AdminEventSystem.TriggerGlobalEvent(eventName, admin)
        return message
    end,

    -- List available global events
    ListGlobalEvents = function(admin)
        return AdminEventSystem.ListEvents()
    end,

    -- List all commands
    Help = function(admin)
        return [[
ADMIN COMMANDS:
- GiveTools <player> <uses>
- SetScore <player> <amount>
- AddScore <player> <amount>
- StealFrom <player> <amount>
- WakePlayer <player>
- WakeAll
- GodMode [player]
- TriggerEvent <event name>
- GlobalEvent <event name> (ALL SERVERS!)
- ListGlobalEvents
- RandomizeBeds
- TeleportTo <player>
- Bring <player>
- Broadcast <message>
- Help
]]
    end,
}

-- Handle admin command from client
AdminCommandEvent.OnServerEvent:Connect(function(player, commandString)
    if not IsAdmin(player) then
        return
    end

    local args = string.split(commandString, " ")
    local commandName = table.remove(args, 1)

    local command = Commands[commandName]
    if command then
        local result = command(player, table.unpack(args))
        AdminCommandEvent:FireClient(player, result or "Command executed")
    else
        AdminCommandEvent:FireClient(player, "Unknown command. Type 'Help' for list of commands.")
    end
end)

return AdminCommands
