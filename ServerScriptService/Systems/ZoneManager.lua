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

-- Zone positions (spread out on baseplate)
local ZonePositions = {
    ["<à Hub"] = Vector3.new(0, 5, 0),
    ["<1 Starter Zone"] = Vector3.new(-150, 5, -150),
    ["<2 Forest Zone"] = Vector3.new(150, 5, -150),
    ["ð Mountain Zone"] = Vector3.new(-150, 5, 150),
    ["<Ö Beach Zone"] = Vector3.new(150, 5, 150),
    ["< Volcano Zone"] = Vector3.new(-300, 5, 0),
    ["D Ice Zone"] = Vector3.new(300, 5, 0),
    ["< Space Zone"] = Vector3.new(0, 5, -300),
    ["( Heaven Zone"] = Vector3.new(0, 5, 300),
}

-- Create a zone area
function ZoneManager.CreateZoneArea(zoneName, zoneConfig, position)
    local zoneFolder = Instance.new("Folder")
    zoneFolder.Name = zoneName
    zoneFolder.Parent = workspace

    -- Create zone platform
    local platform = Instance.new("Part")
    platform.Name = "ZonePlatform"
    platform.Size = Vector3.new(100, 2, 100)
    platform.Position = position
    platform.Anchored = true
    platform.Color = zoneConfig.Color
    platform.Material = Enum.Material.Neon
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = zoneFolder

    -- Add glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 1
    pointLight.Range = 50
    pointLight.Color = zoneConfig.Color
    pointLight.Parent = platform

    -- Create zone label
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 300, 0, 100)
    billboardGui.StudsOffset = Vector3.new(0, 8, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = platform

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = zoneName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = billboardGui

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, 0, 0.5, 0)
    descLabel.Position = UDim2.new(0, 0, 0.5, 0)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = zoneConfig.Description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 18
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextStrokeTransparency = 0
    descLabel.Parent = billboardGui

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
            string.format("=Í Entered %s", zoneName),
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
