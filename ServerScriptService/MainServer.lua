--[[
    MainServer.lua
    SCRIPT TYPE: Script (NOT LocalScript or ModuleScript)
    LOCATION: ServerScriptService/MainServer

    Main server script that initializes all systems and creates RemoteEvents
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

-- Create RemoteEvents folder
local remoteEventsFolder = Instance.new("Folder")
remoteEventsFolder.Name = "RemoteEvents"
remoteEventsFolder.Parent = ReplicatedStorage

-- Create all remote events
local remoteEvents = {
    "UpdateScore",
    "Sleep",
    "Wake",
    "UseTool",
    "PurchaseTool",
    "PurchaseUpgrade",
    "DayNight",
    "EventNotification",
    "AdminCommand",
    "UpdateUpgrades",
}

for _, eventName in ipairs(remoteEvents) do
    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = eventName
    remoteEvent.Parent = remoteEventsFolder
end

print("[MainServer] Created RemoteEvents")

-- Wait for RemoteEvents to replicate
wait(1)

-- Load modules
local GameConfig = require(script.Parent.GameConfig)
local ModelGenerator = require(script.Parent.ModelGenerator)
local PlayerDataManager = require(script.Parent.PlayerDataManager)
local SleepSystem = require(script.Parent.SleepSystem)
local DayNightCycle = require(script.Parent.DayNightCycle)
local RandomEvents = require(script.Parent.RandomEvents)
local BedManager = require(script.Parent.BedManager)
local ToolSystem = require(script.Parent.ToolSystem)
local AdminCommands = require(script.Parent.AdminCommands)

print("[MainServer] Loaded all modules")

-- Setup lighting
Lighting.ClockTime = 14
Lighting.Brightness = 2
Lighting.OutdoorAmbient = GameConfig.DayNight.DayAmbient
Lighting.Ambient = GameConfig.DayNight.DayAmbient

-- Add sky
local sky = ModelGenerator.CreateSky()
sky.Parent = Lighting

print("[MainServer] Setup lighting")

-- Generate map
print("[MainServer] Generating map...")

-- Create spawn platform
local spawnPlatform = ModelGenerator.CreateSpawnPlatform()
spawnPlatform.Parent = game.Workspace

-- Create islands in a circle
local islandCount = GameConfig.Map.IslandCount
local radius = GameConfig.Map.IslandSpacing
local islandSize = GameConfig.Map.IslandSize

for i = 1, islandCount do
    local angle = (i / islandCount) * math.pi * 2
    local x = math.cos(angle) * radius
    local z = math.sin(angle) * radius

    local island = ModelGenerator.CreateIsland(Vector3.new(x, 0, z), islandSize)
    island.Name = "Island" .. i
    island.Parent = game.Workspace

    -- Spawn beds on island
    BedManager.SpawnBedsOnIsland(island)

    print(string.format("[MainServer] Created Island %d with beds", i))
end

print("[MainServer] Map generation complete!")

-- Setup beds
SleepSystem.SetupBeds()
print("[MainServer] Setup all bed interactions")

-- Start systems
SleepSystem.StartEarningLoop()
print("[MainServer] Started earning loop")

DayNightCycle.Start()
print("[MainServer] Started day/night cycle")

RandomEvents.Start()
print("[MainServer] Started random events system")

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    PlayerDataManager.InitPlayer(player)

    -- Give starting tool to admins
    if table.find(GameConfig.Admins, player.UserId) then
        task.wait(2)
        ToolSystem.GiveTool(player, 999)
        print("[MainServer] Gave admin tool to", player.Name)
    end
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    PlayerDataManager.RemovePlayer(player)
end)

-- Initialize existing players
for _, player in ipairs(Players:GetPlayers()) do
    PlayerDataManager.InitPlayer(player)

    if table.find(GameConfig.Admins, player.UserId) then
        task.wait(2)
        ToolSystem.GiveTool(player, 999)
    end
end

-- Setup upgrades remote event
local PurchaseUpgradeEvent = remoteEventsFolder:FindFirstChild("PurchaseUpgrade")
if PurchaseUpgradeEvent then
    PurchaseUpgradeEvent.OnServerEvent:Connect(function(player, upgradeName)
        if PlayerDataManager.PurchaseUpgrade(player, upgradeName) then
            local data = PlayerDataManager.GetData(player)
            if data then
                -- Send updated upgrades to client
                local UpdateUpgradesEvent = remoteEventsFolder:FindFirstChild("UpdateUpgrades")
                if UpdateUpgradesEvent then
                    UpdateUpgradesEvent:FireClient(player, data.Upgrades)
                end
            end
        end
    end)
end

print("[MainServer] ===== SLEEP GAME INITIALIZED =====")
print("[MainServer] Admins:", table.concat(GameConfig.Admins, ", "))
print("[MainServer] Islands:", islandCount)
print("[MainServer] Total Beds:", #BedManager.AllBeds)
print("[MainServer] Day/Night Cycle: Every", GameConfig.DayNight.CycleDuration, "seconds")
print("[MainServer] Random Events: Every", GameConfig.RandomEvents.MinInterval, "-", GameConfig.RandomEvents.MaxInterval, "seconds")
print("[MainServer] =====================================")
