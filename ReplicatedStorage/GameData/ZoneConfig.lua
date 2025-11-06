--[[
    ZoneConfig.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ReplicatedStorage/GameData/ZoneConfig

    Configuration for zones unlocked through rebirth progression
]]

local ZoneConfig = {
    -- Zone definitions
    Zones = {
        {
            Name = "<à Hub",
            Description = "Safe zone with merchants",
            RebirthRequired = 0,  -- Always available
            Color = Color3.fromRGB(100, 150, 255),
            BedCount = 0,  -- No beds in hub
            IsHub = true,
        },
        {
            Name = "<1 Starter Zone",
            Description = "The beginning of your journey",
            RebirthRequired = 0,  -- Always available
            Color = Color3.fromRGB(100, 255, 100),
            BedCount = 6,
            BedMultiplier = 1.0,
        },
        {
            Name = "<2 Forest Zone",
            Description = "Peaceful forest with better beds",
            RebirthRequired = 2,
            Color = Color3.fromRGB(50, 150, 50),
            BedCount = 8,
            BedMultiplier = 1.5,
        },
        {
            Name = "ð Mountain Zone",
            Description = "High altitude, high rewards",
            RebirthRequired = 5,
            Color = Color3.fromRGB(150, 150, 150),
            BedCount = 10,
            BedMultiplier = 2.5,
        },
        {
            Name = "<Ö Beach Zone",
            Description = "Tropical paradise with luxury beds",
            RebirthRequired = 8,
            Color = Color3.fromRGB(255, 230, 150),
            BedCount = 12,
            BedMultiplier = 4.0,
        },
        {
            Name = "< Volcano Zone",
            Description = "Dangerous but extremely rewarding",
            RebirthRequired = 12,
            Color = Color3.fromRGB(200, 50, 50),
            BedCount = 15,
            BedMultiplier = 7.0,
        },
        {
            Name = "D Ice Zone",
            Description = "Frozen tundra with rare beds",
            RebirthRequired = 15,
            Color = Color3.fromRGB(150, 200, 255),
            BedCount = 18,
            BedMultiplier = 12.0,
        },
        {
            Name = "< Space Zone",
            Description = "Zero gravity, infinite possibilities",
            RebirthRequired = 18,
            Color = Color3.fromRGB(50, 0, 100),
            BedCount = 20,
            BedMultiplier = 20.0,
        },
        {
            Name = "( Heaven Zone",
            Description = "The ultimate endgame zone",
            RebirthRequired = 20,
            Color = Color3.fromRGB(255, 215, 0),
            BedCount = 25,
            BedMultiplier = 50.0,
        },
    },
}

-- Get available zones for a rebirth level
function ZoneConfig.GetAvailableZones(rebirthLevel)
    local availableZones = {}

    for _, zone in ipairs(ZoneConfig.Zones) do
        if rebirthLevel >= zone.RebirthRequired then
            table.insert(availableZones, zone)
        end
    end

    return availableZones
end

-- Check if zone is unlocked
function ZoneConfig.IsZoneUnlocked(zoneName, rebirthLevel)
    for _, zone in ipairs(ZoneConfig.Zones) do
        if zone.Name == zoneName then
            return rebirthLevel >= zone.RebirthRequired
        end
    end
    return false
end

-- Get zone by name
function ZoneConfig.GetZone(zoneName)
    for _, zone in ipairs(ZoneConfig.Zones) do
        if zone.Name == zoneName then
            return zone
        end
    end
    return nil
end

return ZoneConfig
