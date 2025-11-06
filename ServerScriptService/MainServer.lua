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
Lighting.ClockTime = 12
Lighting.Brightness = 2
Lighting.OutdoorAmbient = GameConfig.DayNight.DayAmbient
Lighting.Ambient = GameConfig.DayNight.DayAmbient
Lighting.GlobalShadows = true

print("[MainServer] Setup lighting")

-- Find baseplate and spawn beds
print("[MainServer] Setting up game on baseplate...")

-- Find baseplate in workspace (search for large flat Part)
local baseplate = nil
for _, obj in ipairs(game.Workspace:GetChildren()) do
    if obj:IsA("Part") and obj.Size.Y < 10 and (obj.Size.X > 100 or obj.Size.Z > 100) then
        baseplate = obj
        print("[MainServer] Found baseplate:", obj.Name, "Size:", obj.Size)
        break
    end
end

if not baseplate then
    baseplate = game.Workspace:FindFirstChild("Baseplate") or game.Workspace:FindFirstChild("Base")
end

if not baseplate then
    warn("[MainServer] No Baseplate found! Creating default 512x512 baseplate...")
    baseplate = Instance.new("Part")
    baseplate.Name = "Baseplate"
    baseplate.Size = Vector3.new(512, 2, 512)
    baseplate.Position = Vector3.new(0, 0, 0)
    baseplate.Anchored = true
    baseplate.Color = Color3.fromRGB(100, 100, 100)
    baseplate.Material = Enum.Material.Slate
    baseplate.TopSurface = Enum.SurfaceType.Smooth
    baseplate.BottomSurface = Enum.SurfaceType.Smooth
    baseplate.Parent = game.Workspace
    print("[MainServer] Created new baseplate")
end

-- Spawn beds scattered on baseplate
local bedCount = GameConfig.Map.BedCount or 30  -- Default 30 beds
BedManager.SpawnBedsOnBaseplate(baseplate, bedCount)

print("[MainServer] Baseplate setup complete!")

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
print("[MainServer] Total Beds Spawned:", #BedManager.AllBeds)
print("[MainServer] Day/Night Cycle: Every", GameConfig.DayNight.CycleDuration, "seconds")
print("[MainServer] Random Events: Every", GameConfig.RandomEvents.MinInterval, "-", GameConfig.RandomEvents.MaxInterval, "seconds")
print("[MainServer] =====================================")
