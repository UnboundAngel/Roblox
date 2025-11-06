--[[
    PlayerDataManager.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/PlayerDataManager

    Manages player data (scores, upgrades, sleeping state)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameConfig = require(script.Parent.GameConfig)
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local UpdateScoreEvent = RemoteEvents:WaitForChild("UpdateScore")

local PlayerDataManager = {}
PlayerDataManager.PlayerData = {}

-- Initialize player data
function PlayerDataManager.InitPlayer(player)
    PlayerDataManager.PlayerData[player.UserId] = {
        TimePoints = 0,
        IsSleeping = false,
        CurrentBed = nil,
        SleepStartTime = 0,
        Upgrades = {
            SleepEfficiency = 0,
            TheftProtection = 0,
            ToolCapacity = 0,
            ScoreMultiplier = 0,
        },
        HubUpgrades = {
            AutoSleeper = 0,
            OfflineGeneration = 0,
            TheftShield = 0,
            SpeedBoost = 0,
        },
        RebirthLevel = 0,
        CurrentZone = "🌱 Starter Zone",
        LastLogoutTime = 0,
        Tools = {},
        IsAdmin = table.find(GameConfig.Admins, player.UserId) ~= nil,
        GodMode = false,
    }

    -- Create leaderstats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local timePoints = Instance.new("IntValue")
    timePoints.Name = "Time Points"
    timePoints.Value = 0
    timePoints.Parent = leaderstats

    print("[PlayerDataManager] Initialized player:", player.Name, "Admin:", PlayerDataManager.PlayerData[player.UserId].IsAdmin)
end

-- Remove player data
function PlayerDataManager.RemovePlayer(player)
    local data = PlayerDataManager.GetData(player)
    if data then
        -- Store logout time for offline generation
        data.LastLogoutTime = os.time()

        -- TODO: Save data to DataStore here
        -- For now, data is lost on server restart
    end

    PlayerDataManager.PlayerData[player.UserId] = nil
end

-- Get player data
function PlayerDataManager.GetData(player)
    return PlayerDataManager.PlayerData[player.UserId]
end

-- Add time points to player
function PlayerDataManager.AddTimePoints(player, amount)
    local data = PlayerDataManager.GetData(player)
    if not data then return end

    data.TimePoints = data.TimePoints + amount

    -- Update leaderstats
    if player:FindFirstChild("leaderstats") then
        local tp = player.leaderstats:FindFirstChild("Time Points")
        if tp then
            tp.Value = math.floor(data.TimePoints)
        end
    end

    -- Update client
    UpdateScoreEvent:FireClient(player, data.TimePoints)
end

-- Deduct time points
function PlayerDataManager.DeductTimePoints(player, amount)
    local data = PlayerDataManager.GetData(player)
    if not data then return false end

    if data.TimePoints >= amount then
        data.TimePoints = data.TimePoints - amount

        -- Update leaderstats
        if player:FindFirstChild("leaderstats") then
            local tp = player.leaderstats:FindFirstChild("Time Points")
            if tp then
                tp.Value = math.floor(data.TimePoints)
            end
        end

        UpdateScoreEvent:FireClient(player, data.TimePoints)
        return true
    end

    return false
end

-- Get earning rate for player
function PlayerDataManager.GetEarningRate(player, bedMultiplier)
    local data = PlayerDataManager.GetData(player)
    if not data then return 0 end

    local baseRate = GameConfig.Sleep.BaseEarningRate

    -- Apply upgrades
    local efficiencyBonus = 1 + (data.Upgrades.SleepEfficiency * GameConfig.Upgrades.SleepEfficiency.BonusPerLevel)
    local scoreMultiplier = 1 + (data.Upgrades.ScoreMultiplier * GameConfig.Upgrades.ScoreMultiplier.BonusPerLevel)

    return baseRate * bedMultiplier * efficiencyBonus * scoreMultiplier
end

-- Get theft protection percentage
function PlayerDataManager.GetTheftProtection(player)
    local data = PlayerDataManager.GetData(player)
    if not data then return 0 end

    local protection = data.Upgrades.TheftProtection * GameConfig.Upgrades.TheftProtection.BonusPerLevel
    return math.min(protection, 100)  -- Cap at 100%
end

-- Start sleeping
function PlayerDataManager.StartSleeping(player, bed)
    local data = PlayerDataManager.GetData(player)
    if not data then return end

    data.IsSleeping = true
    data.CurrentBed = bed
    data.SleepStartTime = tick()
end

-- Stop sleeping
function PlayerDataManager.StopSleeping(player)
    local data = PlayerDataManager.GetData(player)
    if not data then return end

    data.IsSleeping = false
    data.CurrentBed = nil
    data.SleepStartTime = 0
end

-- Is player sleeping?
function PlayerDataManager.IsSleeping(player)
    local data = PlayerDataManager.GetData(player)
    return data and data.IsSleeping
end

-- Upgrade player stat
function PlayerDataManager.PurchaseUpgrade(player, upgradeName)
    local data = PlayerDataManager.GetData(player)
    if not data then return false end

    local upgradeConfig = GameConfig.Upgrades[upgradeName]
    if not upgradeConfig then return false end

    local currentLevel = data.Upgrades[upgradeName]
    if currentLevel >= upgradeConfig.MaxLevel then return false end

    local cost = upgradeConfig.BaseCost * (upgradeConfig.CostMultiplier ^ currentLevel)

    if PlayerDataManager.DeductTimePoints(player, cost) then
        data.Upgrades[upgradeName] = currentLevel + 1
        return true
    end

    return false
end

return PlayerDataManager
