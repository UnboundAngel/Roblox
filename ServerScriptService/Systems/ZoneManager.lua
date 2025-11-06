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

-- Create a zone area as an ISLAND with unique shape and elevation
function ZoneManager.CreateZoneArea(zoneName, zoneConfig, position)
    local zoneFolder = Instance.new("Folder")
    zoneFolder.Name = zoneName
    zoneFolder.Parent = workspace

    -- Get themed material
    local zoneMaterial = ZoneMaterials[zoneName]
    local material = zoneMaterial and zoneMaterial.Material or Enum.Material.SmoothPlastic
    local color = zoneConfig.Color

    -- Create island main platform (where beds spawn)
    local platform = Instance.new("Part")
    platform.Name = "ZonePlatform"
    platform.Size = Vector3.new(120, 8, 120)  -- Spacious bed area
    platform.Position = position
    platform.Anchored = true
    platform.Material = material
    if zoneName == "Heaven Zone" or zoneName == "Space Zone" then
        platform.Color = color
    end
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = zoneFolder

    -- Create island foundation (larger base underneath)
    local foundation = Instance.new("Part")
    foundation.Name = "IslandFoundation"
    foundation.Size = Vector3.new(140, 20, 140)
    foundation.Position = position - Vector3.new(0, 14, 0)
    foundation.Anchored = true
    foundation.Material = material
    foundation.Color = Color3.fromRGB(80, 60, 40)  -- Rocky earth color
    foundation.TopSurface = Enum.SurfaceType.Smooth
    foundation.BottomSurface = Enum.SurfaceType.Smooth
    foundation.Parent = zoneFolder

    -- Add themed decorations to make each island unique
    if zoneName == "Forest Zone" then
        -- Add tree pillars
        for i = 1, 5 do
            local tree = Instance.new("Part")
            tree.Size = Vector3.new(4, 15, 4)
            tree.Position = position + Vector3.new(math.random(-40, 40), 11.5, math.random(-40, 40))
            tree.Anchored = true
            tree.Material = Enum.Material.Wood
            tree.Color = Color3.fromRGB(101, 67, 33)
            tree.Parent = zoneFolder
        end
    elseif zoneName == "Mountain Zone" then
        -- Add rocky peaks
        for i = 1, 3 do
            local peak = Instance.new("Part")
            peak.Size = Vector3.new(20, 25, 20)
            peak.Position = position + Vector3.new(math.random(-35, 35), 16.5, math.random(-35, 35))
            peak.Anchored = true
            peak.Material = Enum.Material.Rock
            peak.Color = Color3.fromRGB(120, 120, 120)
            peak.Parent = zoneFolder
        end
    elseif zoneName == "Volcano Zone" then
        -- Add lava pools
        for i = 1, 3 do
            local lava = Instance.new("Part")
            lava.Size = Vector3.new(15, 1, 15)
            lava.Position = position + Vector3.new(math.random(-40, 40), 4.5, math.random(-40, 40))
            lava.Anchored = true
            lava.Material = Enum.Material.Neon
            lava.Color = Color3.fromRGB(255, 100, 0)
            lava.Parent = zoneFolder
        end
    elseif zoneName == "Ice Zone" then
        -- Add ice spikes
        for i = 1, 4 do
            local spike = Instance.new("Part")
            spike.Size = Vector3.new(5, 18, 5)
            spike.Position = position + Vector3.new(math.random(-40, 40), 13, math.random(-40, 40))
            spike.Anchored = true
            spike.Material = Enum.Material.Ice
            spike.Transparency = 0.3
            spike.Parent = zoneFolder
        end
    elseif zoneName == "Beach Zone" then
        -- Add palm tree-like decorations
        for i = 1, 3 do
            local palm = Instance.new("Part")
            palm.Size = Vector3.new(3, 12, 3)
            palm.Position = position + Vector3.new(math.random(-45, 45), 10, math.random(-45, 45))
            palm.Anchored = true
            palm.Material = Enum.Material.Wood
            palm.Color = Color3.fromRGB(139, 90, 43)
            palm.Parent = zoneFolder
        end
    end

    -- Add subtle glow
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 0.3
    pointLight.Range = 20
    pointLight.Color = color
    pointLight.Parent = platform

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
