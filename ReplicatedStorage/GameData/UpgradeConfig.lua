--[[
    UpgradeConfig.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ReplicatedStorage/GameData/UpgradeConfig

    Configuration for new hub-exclusive upgrades
]]

local UpgradeConfig = {
    -- Auto-Sleeper: Passive TP generation bot
    AutoSleeper = {
        Name = "> Auto-Sleeper Bot",
        Description = "A bot that sleeps for you passively!",
        MaxLevel = 10,
        BaseCost = 5000,
        CostMultiplier = 2.5,
        -- Earning rate per level (TP per second)
        EarningRates = {
            [1] = 0.5,   -- Level 1: 0.5 TP/s
            [2] = 1.0,   -- Level 2: 1.0 TP/s
            [3] = 1.5,   -- Level 3: 1.5 TP/s
            [4] = 2.5,   -- Level 4: 2.5 TP/s
            [5] = 4.0,   -- Level 5: 4.0 TP/s
            [6] = 6.0,   -- Level 6: 6.0 TP/s
            [7] = 9.0,   -- Level 7: 9.0 TP/s
            [8] = 13.0,  -- Level 8: 13.0 TP/s
            [9] = 18.0,  -- Level 9: 18.0 TP/s
            [10] = 25.0, -- Level 10: 25.0 TP/s
        },
    },

    -- Offline Generation: Earn while logged off
    OfflineGeneration = {
        Name = "=¤ Offline Generator",
        Description = "Earn TP while offline!",
        MaxLevel = 5,
        BaseCost = 10000,
        CostMultiplier = 3.0,
        -- Earning percentage of auto-sleeper rate per level
        EarningPercentages = {
            [1] = 10,  -- Level 1: 10% of auto-sleeper rate
            [2] = 25,  -- Level 2: 25%
            [3] = 50,  -- Level 3: 50%
            [4] = 75,  -- Level 4: 75%
            [5] = 100, -- Level 5: 100% (full rate)
        },
        -- Max offline time in hours per level
        MaxOfflineHours = {
            [1] = 1,   -- Level 1: 1 hour max
            [2] = 2,   -- Level 2: 2 hours
            [3] = 4,   -- Level 3: 4 hours
            [4] = 8,   -- Level 4: 8 hours
            [5] = 12,  -- Level 5: 12 hours
        },
    },

    -- Theft Shield: Reduce stolen amount
    TheftShield = {
        Name = "=á Theft Shield",
        Description = "Protect yourself from theft!",
        MaxLevel = 10,
        BaseCost = 3000,
        CostMultiplier = 2.8,
        -- Protection percentage per level
        ProtectionPercentages = {
            [1] = 10,  -- Level 1: Block 10% of theft
            [2] = 20,  -- Level 2: 20%
            [3] = 30,  -- Level 3: 30%
            [4] = 40,  -- Level 4: 40%
            [5] = 50,  -- Level 5: 50%
            [6] = 60,  -- Level 6: 60%
            [7] = 70,  -- Level 7: 70%
            [8] = 80,  -- Level 8: 80%
            [9] = 90,  -- Level 9: 90%
            [10] = 95, -- Level 10: 95% (nearly immune)
        },
    },

    -- Speed Boost: Increase walk speed
    SpeedBoost = {
        Name = "¡ Speed Boost",
        Description = "Move faster around the map!",
        MaxLevel = 5,
        BaseCost = 2000,
        CostMultiplier = 2.5,
        -- Walk speed multiplier per level
        SpeedMultipliers = {
            [1] = 1.15,  -- Level 1: 15% faster
            [2] = 1.30,  -- Level 2: 30% faster
            [3] = 1.50,  -- Level 3: 50% faster
            [4] = 1.75,  -- Level 4: 75% faster
            [5] = 2.0,   -- Level 5: 2x speed
        },
    },
}

-- Calculate cost for a specific upgrade at a given level
function UpgradeConfig.CalculateCost(upgradeName, currentLevel)
    local config = UpgradeConfig[upgradeName]
    if not config then
        return nil
    end

    if currentLevel >= config.MaxLevel then
        return nil -- Max level reached
    end

    return math.floor(config.BaseCost * (config.CostMultiplier ^ currentLevel))
end

return UpgradeConfig
