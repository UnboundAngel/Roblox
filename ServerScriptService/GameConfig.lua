--[[
    GameConfig.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/GameConfig

    Configuration module for the entire game
    IMPORTANT: Update Admin User IDs before playing!
]]

local GameConfig = {}

-- Admin User IDs
GameConfig.Admins = {
    5049861856,  -- UnboundAngel350
    931881945,   -- Susie
}

-- Sleep System
GameConfig.Sleep = {
    BaseEarningRate = 1,  -- Time Points per second
    NightMultiplier = 2,  -- 2x during night
}

-- Day/Night Cycle
GameConfig.DayNight = {
    CycleDuration = 300,  -- 5 minutes (300 seconds)
    DayLightingColor = Color3.fromRGB(200, 220, 255),
    NightLightingColor = Color3.fromRGB(50, 50, 100),
    DayAmbient = Color3.fromRGB(150, 150, 150),
    NightAmbient = Color3.fromRGB(20, 20, 50),
}

-- Random Events
GameConfig.RandomEvents = {
    MinInterval = 300,  -- 5 minutes
    MaxInterval = 900,  -- 15 minutes
    Events = {
        {
            Name = "Score Surge",
            Duration = 60,
            Multiplier = 3,
            Message = "⚡ SCORE SURGE! Earn 3x for 60 seconds!",
        },
        {
            Name = "Bed Chaos",
            Duration = 0,
            Message = "🛏️ BED CHAOS! All beds have been randomly mutated!",
        },
        {
            Name = "Theft Frenzy",
            Duration = 90,
            Message = "💰 THEFT FRENZY! Tool cooldowns halved for 90 seconds!",
        },
        {
            Name = "Golden Hour",
            Duration = 120,
            Message = "✨ GOLDEN HOUR! Night bonus active!",
        },
        {
            Name = "Shield Storm",
            Duration = 45,
            Message = "🛡️ SHIELD STORM! Everyone is immune to theft!",
        },
        {
            Name = "Score Drain",
            Duration = 0,
            DrainPercent = 5,
            Message = "💀 SCORE DRAIN! Everyone loses 5% of their score!",
        },
    }
}

-- Tool System
GameConfig.Tools = {
    WakeAndSteal = {
        Name = "Wake & Steal Tool",
        DefaultUses = 3,
        Cost = 500,
        Cooldown = 10,
        StealPercentDay = 25,
        StealPercentNight = 35,
        Range = 20,
    }
}

-- Bed Mutations
GameConfig.BedMutations = {
    {Name = "Normal", Multiplier = 1, Color = Color3.fromRGB(200, 200, 200), TheftProtection = 0},
    {Name = "Comfy", Multiplier = 1.5, Color = Color3.fromRGB(100, 200, 100), TheftProtection = 0},
    {Name = "Luxury", Multiplier = 2, Color = Color3.fromRGB(200, 100, 200), TheftProtection = 0},
    {Name = "Cursed", Multiplier = 0.75, Color = Color3.fromRGB(100, 0, 100), TheftProtection = 100},
    {Name = "Golden", Multiplier = 3, Color = Color3.fromRGB(255, 215, 0), TheftProtection = 0},
    {Name = "Speed", Multiplier = 1.75, Color = Color3.fromRGB(0, 200, 255), TheftProtection = 0, KickTime = 30},
    {Name = "Fortress", Multiplier = 1, Color = Color3.fromRGB(150, 150, 150), TheftProtection = 50},
}

-- Upgrades
GameConfig.Upgrades = {
    SleepEfficiency = {
        Name = "Sleep Efficiency",
        Description = "Increases your earning rate",
        MaxLevel = 10,
        BaseCost = 100,
        CostMultiplier = 2.5,
        BonusPerLevel = 0.5,  -- +50% per level
    },
    TheftProtection = {
        Name = "Theft Protection",
        Description = "Reduces amount stolen from you",
        MaxLevel = 10,
        BaseCost = 200,
        CostMultiplier = 2.5,
        BonusPerLevel = 5,  -- +5% protection per level
    },
    ToolCapacity = {
        Name = "Tool Capacity",
        Description = "Carry more tool uses",
        MaxLevel = 5,
        BaseCost = 300,
        CostMultiplier = 3,
        BonusPerLevel = 2,  -- +2 uses per level
    },
    ScoreMultiplier = {
        Name = "Score Multiplier",
        Description = "Passive score bonus",
        MaxLevel = 10,
        BaseCost = 500,
        CostMultiplier = 3,
        BonusPerLevel = 0.25,  -- +25% per level
    },
}

-- Map Generation
GameConfig.Map = {
    BedCount = 30,  -- Total beds scattered on baseplate
}

return GameConfig
