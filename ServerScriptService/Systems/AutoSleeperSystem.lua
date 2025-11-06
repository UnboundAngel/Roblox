--[[
    AutoSleeperSystem.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/Systems/AutoSleeperSystem

    Manages passive TP generation from Auto-Sleeper Bot upgrade
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local UpgradeConfig = require(GameData:WaitForChild("UpgradeConfig"))

local PlayerDataManager = require(script.Parent.Parent.PlayerDataManager)

local AutoSleeperSystem = {}
AutoSleeperSystem.UpdateInterval = 1 -- Update every 1 second

-- Calculate passive earning rate for a player
function AutoSleeperSystem.GetPassiveRate(player)
    local data = PlayerDataManager.GetData(player)
    if not data or not data.HubUpgrades then
        return 0
    end

    local autoSleeperLevel = data.HubUpgrades.AutoSleeper or 0
    if autoSleeperLevel <= 0 then
        return 0
    end

    -- Get earning rate from config
    local earningRate = UpgradeConfig.AutoSleeper.EarningRates[autoSleeperLevel] or 0

    -- Apply rebirth multiplier
    local rebirthMultiplier = 1
    if data.RebirthLevel and data.RebirthLevel > 0 then
        local RebirthConfig = require(GameData:WaitForChild("RebirthConfig"))
        rebirthMultiplier = RebirthConfig.GetMultiplier(data.RebirthLevel) or 1
    end

    return earningRate * rebirthMultiplier
end

-- Start passive earning loop
function AutoSleeperSystem.Start()
    task.spawn(function()
        while true do
            task.wait(AutoSleeperSystem.UpdateInterval)

            -- Grant passive TP to all players with auto-sleeper
            for _, player in ipairs(Players:GetPlayers()) do
                local passiveRate = AutoSleeperSystem.GetPassiveRate(player)

                if passiveRate > 0 then
                    -- Calculate TP earned this interval
                    local tpEarned = passiveRate * AutoSleeperSystem.UpdateInterval

                    -- Add to player
                    PlayerDataManager.AddTimePoints(player, tpEarned)
                end
            end
        end
    end)

    print("[AutoSleeperSystem] Started passive earning loop")
end

return AutoSleeperSystem
