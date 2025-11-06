--[[
    RebirthSystem.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/Systems/RebirthSystem

    Handles rebirth logic, resets, and special rewards
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local RebirthConfig = require(GameData:WaitForChild("RebirthConfig"))

local PlayerDataManager = require(script.Parent.Parent.PlayerDataManager)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")
local RebirthEvent = RemoteEvents:WaitForChild("Rebirth")

local RebirthSystem = {}

-- Check if player can rebirth
function RebirthSystem.CanRebirth(player)
    local data = PlayerDataManager.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local currentLevel = data.RebirthLevel or 0
    local currentTP = data.TimePoints or 0

    return RebirthConfig.CanRebirth(currentLevel, currentTP)
end

-- Perform rebirth for player
function RebirthSystem.PerformRebirth(player)
    local data = PlayerDataManager.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    -- Check if can rebirth
    local canRebirth, message = RebirthSystem.CanRebirth(player)
    if not canRebirth then
        return false, message
    end

    local currentLevel = data.RebirthLevel or 0
    local newLevel = currentLevel + 1

    -- Reset based on config
    if RebirthConfig.ResetSettings.ResetTimePoints then
        data.TimePoints = 0

        -- Update leaderstats
        if player:FindFirstChild("leaderstats") then
            local tp = player.leaderstats:FindFirstChild("Time Points")
            if tp then
                tp.Value = 0
            end
        end
    end

    -- Keep upgrades if configured
    if not RebirthConfig.ResetSettings.KeepUpgrades then
        data.Upgrades = {
            SleepEfficiency = 0,
            TheftProtection = 0,
            ToolCapacity = 0,
            ScoreMultiplier = 0,
        }
    end

    if not RebirthConfig.ResetSettings.KeepAutoSleeper then
        data.HubUpgrades.AutoSleeper = 0
    end

    if not RebirthConfig.ResetSettings.KeepOfflineGen then
        data.HubUpgrades.OfflineGeneration = 0
    end

    if not RebirthConfig.ResetSettings.KeepTheftShield then
        data.HubUpgrades.TheftShield = 0
    end

    -- Update rebirth level
    data.RebirthLevel = newLevel

    -- Check for special rewards
    local specialReward = RebirthConfig.SpecialRewards[newLevel]
    if specialReward then
        RebirthSystem.GrantSpecialReward(player, specialReward)
    end

    -- Update client score
    local UpdateScoreEvent = RemoteEvents:FindFirstChild("UpdateScore")
    if UpdateScoreEvent then
        UpdateScoreEvent:FireClient(player, data.TimePoints)
    end

    -- Get multiplier
    local multiplier = RebirthConfig.GetMultiplier(newLevel)

    -- Fire rebirth animation event to client
    local RebirthAnimEvent = RemoteEvents:FindFirstChild("TriggerRebirthAnim")
    if RebirthAnimEvent then
        RebirthAnimEvent:FireClient(player, newLevel, multiplier)
    end

    print(string.format("[RebirthSystem] %s rebirthed to level %d (Multiplier: %dx)", player.Name, newLevel, multiplier))

    return true, string.format("Rebirthed to Level %d! Multiplier: %dx", newLevel, multiplier)
end

-- Grant special reward (aura effects)
function RebirthSystem.GrantSpecialReward(player, reward)
    -- TODO: Implement particle auras when requested
    -- For now, just send notification
    EventNotificationEvent:FireClient(
        player,
        string.format("< SPECIAL REWARD: %s - %s", reward.Name, reward.Description),
        5,
        nil,
        nil
    )

    print(string.format("[RebirthSystem] %s earned special reward: %s", player.Name, reward.Name))
end

-- Setup rebirth remote event
function RebirthSystem.Setup()
    RebirthEvent.OnServerEvent:Connect(function(player)
        local success, message = RebirthSystem.PerformRebirth(player)

        if not success then
            EventNotificationEvent:FireClient(player, "L " .. message, 3, nil, nil)
        end
    end)

    print("[RebirthSystem] Setup complete")
end

return RebirthSystem
