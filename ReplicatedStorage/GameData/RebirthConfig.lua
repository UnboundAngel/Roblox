--[[
    RebirthConfig.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ReplicatedStorage/GameData/RebirthConfig

    Configuration for the rebirth system
]]

local RebirthConfig = {
    MaxRebirths = 20,

    -- Rebirth requirements and multipliers
    Rebirths = {
        -- Format: [Level] = {Cost = TP required, Multiplier = earning multiplier}
        [1] = {Cost = 10000, Multiplier = 2},
        [2] = {Cost = 50000, Multiplier = 3},
        [3] = {Cost = 150000, Multiplier = 5},
        [4] = {Cost = 500000, Multiplier = 8},
        [5] = {Cost = 1500000, Multiplier = 12},
        [6] = {Cost = 5000000, Multiplier = 18},
        [7] = {Cost = 15000000, Multiplier = 25},
        [8] = {Cost = 50000000, Multiplier = 35},
        [9] = {Cost = 150000000, Multiplier = 50},
        [10] = {Cost = 500000000, Multiplier = 75},
        [11] = {Cost = 1500000000, Multiplier = 100},
        [12] = {Cost = 5000000000, Multiplier = 150},
        [13] = {Cost = 15000000000, Multiplier = 200},
        [14] = {Cost = 50000000000, Multiplier = 300},
        [15] = {Cost = 150000000000, Multiplier = 500},
        [16] = {Cost = 500000000000, Multiplier = 750},
        [17] = {Cost = 1500000000000, Multiplier = 1000},
        [18] = {Cost = 5000000000000, Multiplier = 1500},
        [19] = {Cost = 15000000000000, Multiplier = 2500},
        [20] = {Cost = 50000000000000, Multiplier = 5000},
    },

    -- Special rewards at certain rebirth milestones
    SpecialRewards = {
        [5] = {
            Name = "Golden Aura",
            Description = "A golden particle effect surrounds you!",
        },
        [10] = {
            Name = "Rainbow Aura",
            Description = "A rainbow particle effect surrounds you!",
        },
        [15] = {
            Name = "Cosmic Aura",
            Description = "A cosmic galaxy effect surrounds you!",
        },
        [20] = {
            Name = "Divine Aura",
            Description = "The ultimate divine aura effect!",
        },
    },

    -- What gets reset on rebirth
    ResetSettings = {
        ResetTimePoints = true,     -- Reset TP to 0
        KeepUpgrades = true,         -- Keep all upgrades
        KeepAutoSleeper = true,      -- Keep auto-sleeper level
        KeepOfflineGen = true,       -- Keep offline generation
        KeepTheftShield = true,      -- Keep theft shield
    },
}

-- Get rebirth data for a specific level
function RebirthConfig.GetRebirthData(level)
    return RebirthConfig.Rebirths[level]
end

-- Get total multiplier at a rebirth level
function RebirthConfig.GetMultiplier(level)
    local data = RebirthConfig.GetRebirthData(level)
    return data and data.Multiplier or 1
end

-- Check if player can rebirth
function RebirthConfig.CanRebirth(currentLevel, currentTP)
    if currentLevel >= RebirthConfig.MaxRebirths then
        return false, "Max rebirth level reached!"
    end

    local nextLevel = currentLevel + 1
    local rebirthData = RebirthConfig.GetRebirthData(nextLevel)

    if not rebirthData then
        return false, "Invalid rebirth level"
    end

    if currentTP < rebirthData.Cost then
        return false, string.format("Need %d TP to rebirth", rebirthData.Cost)
    end

    return true, "Ready to rebirth!"
end

return RebirthConfig
