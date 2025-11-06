--[[
    OfflineGenerationSystem.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/Systems/OfflineGenerationSystem

    Calculates and grants offline TP earnings when player rejoins
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local UpgradeConfig = require(GameData:WaitForChild("UpgradeConfig"))

local PlayerDataManager = require(script.Parent.Parent.PlayerDataManager)
local AutoSleeperSystem = require(script.Parent.AutoSleeperSystem)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")

local OfflineGenerationSystem = {}

-- Calculate offline earnings for a player
function OfflineGenerationSystem.CalculateOfflineEarnings(player, data)
    -- Check if player has offline generation upgrade
    if not data.HubUpgrades or not data.HubUpgrades.OfflineGeneration then
        return 0
    end

    local offlineGenLevel = data.HubUpgrades.OfflineGeneration
    if offlineGenLevel <= 0 then
        return 0
    end

    -- Check if player has auto-sleeper (required for offline generation)
    local autoSleeperLevel = data.HubUpgrades.AutoSleeper or 0
    if autoSleeperLevel <= 0 then
        return 0
    end

    -- Calculate time offline
    local currentTime = os.time()
    local lastLogoutTime = data.LastLogoutTime or 0

    if lastLogoutTime <= 0 then
        return 0 -- First time joining
    end

    local secondsOffline = currentTime - lastLogoutTime

    -- Get max offline hours for this level
    local maxHours = UpgradeConfig.OfflineGeneration.MaxOfflineHours[offlineGenLevel] or 0
    local maxSeconds = maxHours * 3600

    -- Cap offline time
    local cappedSeconds = math.min(secondsOffline, maxSeconds)

    if cappedSeconds <= 0 then
        return 0
    end

    -- Get offline earning percentage
    local earningPercentage = UpgradeConfig.OfflineGeneration.EarningPercentages[offlineGenLevel] or 0

    -- Calculate base passive rate (from auto-sleeper)
    local passiveRate = AutoSleeperSystem.GetPassiveRate(player)

    -- Apply offline percentage
    local offlineRate = passiveRate * (earningPercentage / 100)

    -- Calculate total offline earnings
    local offlineEarnings = offlineRate * cappedSeconds

    return offlineEarnings, cappedSeconds
end

-- Grant offline earnings to player on join
function OfflineGenerationSystem.OnPlayerJoin(player)
    local data = PlayerDataManager.GetData(player)
    if not data then
        return
    end

    local offlineEarnings, secondsOffline = OfflineGenerationSystem.CalculateOfflineEarnings(player, data)

    if offlineEarnings and offlineEarnings > 0 then
        -- Grant offline earnings
        PlayerDataManager.AddTimePoints(player, offlineEarnings)

        -- Calculate hours/minutes offline
        local hoursOffline = math.floor(secondsOffline / 3600)
        local minutesOffline = math.floor((secondsOffline % 3600) / 60)

        -- Send notification
        local timeText = ""
        if hoursOffline > 0 then
            timeText = string.format("%dh %dm", hoursOffline, minutesOffline)
        else
            timeText = string.format("%dm", minutesOffline)
        end

        EventNotificationEvent:FireClient(
            player,
            string.format("=¤ Offline Earnings: +%.0f TP (%s)", offlineEarnings, timeText),
            5,
            nil,
            nil
        )

        print(string.format("[OfflineGeneration] %s earned %.0f TP while offline (%s)", player.Name, offlineEarnings, timeText))
    end
end

return OfflineGenerationSystem
