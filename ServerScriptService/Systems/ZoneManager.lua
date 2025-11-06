--[[
    ZoneManager.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/Systems/ZoneManager

    Manages zones, teleportation, and zone-specific bed spawning
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local ZoneConfig = require(GameData:WaitForChild("ZoneConfig"))

local PlayerDataManager = require(script.Parent.Parent.PlayerDataManager)
local BedManager = require(script.Parent.Parent.BedManager)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")

local ZoneManager = {}
ZoneManager.Zones = {} -- Store zone models and data

-- Zone positions (spread FAR apart to prevent overlap - platforms are 250x250)
local ZonePositions = {
    ["Hub"] = Vector3.new(0, 5, 0),
    ["Starter Zone"] = Vector3.new(-400, 5, -400),
    ["Forest Zone"] = Vector3.new(400, 5, -400),
    ["Mountain Zone"] = Vector3.new(-400, 5, 400),
    ["Beach Zone"] = Vector3.new(400, 5, 400),
    ["Volcano Zone"] = Vector3.new(-800, 5, 0),
    ["Ice Zone"] = Vector3.new(800, 5, 0),
    ["Space Zone"] = Vector3.new(0, 5, -800),
    ["Heaven Zone"] = Vector3.new(0, 5, 800),
}

-- Zone materials and textures
local ZoneMaterials = {
    ["Hub"] = {Material = Enum.Material.Concrete},
    ["Starter Zone"] = {Material = Enum.Material.Grass},
    ["Forest Zone"] = {Material = Enum.Material.LeafyGrass},
    ["Mountain Zone"] = {Material = Enum.Material.Rock},
    ["Beach Zone"] = {Material = Enum.Material.Sand},
    ["Volcano Zone"] = {Material = Enum.Material.Basalt},
    ["Ice Zone"] = {Material = Enum.Material.Ice},
    ["Space Zone"] = {Material = Enum.Material.ForceField},
    ["Heaven Zone"] = {Material = Enum.Material.Neon},
}

-- Create a zone area
function ZoneManager.CreateZoneArea(zoneName, zoneConfig, position)
    local zoneFolder = Instance.new("Folder")
    zoneFolder.Name = zoneName
    zoneFolder.Parent = workspace

    -- Create zone platform (MUCH larger)
    local platform = Instance.new("Part")
    platform.Name = "ZonePlatform"
    platform.Size = Vector3.new(600, 3, 600)  -- Made MUCH bigger - 600x600
    platform.Position = position
    platform.Anchored = true

    -- Apply themed material
    local zoneMaterial = ZoneMaterials[zoneName]
    if zoneMaterial then
        platform.Material = zoneMaterial.Material
        -- Keep color for zones that need it (Heaven/Space)
        if zoneName == "Heaven Zone" or zoneName == "Space Zone" then
            platform.Color = zoneConfig.Color
        end
    else
        platform.Material = Enum.Material.SmoothPlastic
        platform.Color = zoneConfig.Color
    end

    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = zoneFolder

    -- Add subtle glow effect (not blinding)
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 0.3  -- Even more subtle
    pointLight.Range = 20  -- Smaller range
    pointLight.Color = zoneConfig.Color
    pointLight.Parent = platform

    -- NO BILLBOARD LABELS - they clutter the screen and hover everywhere

    -- Spawn beds if not hub
    if not zoneConfig.IsHub and zoneConfig.BedCount > 0 then
        BedManager.SpawnBedsInArea(platform, zoneConfig.BedCount, zoneName, zoneConfig.BedMultiplier)
    end

    -- Store zone data
    ZoneManager.Zones[zoneName] = {
        Name = zoneName,
        Config = zoneConfig,
        Platform = platform,
        Folder = zoneFolder,
        Position = position,
    }

    print(string.format("[ZoneManager] Created zone: %s with %d beds", zoneName, zoneConfig.BedCount or 0))
end

-- Teleport player to zone
function ZoneManager.TeleportToZone(player, zoneName)
    local data = PlayerDataManager.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    -- Check if zone exists
    local zoneData = ZoneManager.Zones[zoneName]
    if not zoneData then
        return false, "Zone not found"
    end

    -- Check if unlocked
    if not ZoneConfig.IsZoneUnlocked(zoneName, data.RebirthLevel or 0) then
        return false, "Zone locked! Rebirth required."
    end

    -- Teleport player
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local spawnPosition = zoneData.Position + Vector3.new(0, 5, 0)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPosition)

        -- Update current zone
        data.CurrentZone = zoneName

        EventNotificationEvent:FireClient(
            player,
            string.format("=� Entered %s", zoneName),
            2,
            nil,
            nil
        )

        print(string.format("[ZoneManager] %s teleported to %s", player.Name, zoneName))
        return true, "Teleported!"
    end

    return false, "Character not found"
end

-- Initialize all zones
function ZoneManager.InitializeZones()
    for _, zoneConfig in ipairs(ZoneConfig.Zones) do
        local position = ZonePositions[zoneConfig.Name] or Vector3.new(0, 5, 0)
        ZoneManager.CreateZoneArea(zoneConfig.Name, zoneConfig, position)
    end

    print(string.format("[ZoneManager] Initialized %d zones", #ZoneConfig.Zones))
end

-- Setup remote events
function ZoneManager.Setup()
    -- Teleport event
    local TeleportToZoneEvent = RemoteEvents:FindFirstChild("TeleportToZone")
    if not TeleportToZoneEvent then
        TeleportToZoneEvent = Instance.new("RemoteEvent")
        TeleportToZoneEvent.Name = "TeleportToZone"
        TeleportToZoneEvent.Parent = RemoteEvents
    end

    TeleportToZoneEvent.OnServerEvent:Connect(function(player, zoneName)
        local success, message = ZoneManager.TeleportToZone(player, zoneName)
        if not success then
            EventNotificationEvent:FireClient(player, "L " .. message, 3, nil, nil)
        end
    end)

    print("[ZoneManager] Setup complete")
end

return ZoneManager
