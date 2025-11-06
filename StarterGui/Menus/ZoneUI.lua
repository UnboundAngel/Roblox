--[[
    ZoneUI.lua
    SCRIPT TYPE: LocalScript
    LOCATION: StarterGui/Menus/ZoneUI

    Zone selection and teleportation interface
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local GameData = ReplicatedStorage:WaitForChild("GameData")

local ZoneConfig = require(GameData:WaitForChild("ZoneConfig"))

local playerGui = player:WaitForChild("PlayerGui")

-- Create Zone UI
local zoneGui = Instance.new("ScreenGui")
zoneGui.Name = "ZoneUI"
zoneGui.ResetOnSpawn = false
zoneGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
zoneGui.DisplayOrder = 85
zoneGui.Enabled = false
zoneGui.Parent = playerGui

-- Overlay
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.4
overlay.BorderSizePixel = 0
overlay.Parent = zoneGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 750, 0, 550)
mainFrame.Position = UDim2.new(0.5, -375, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = zoneGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 15)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Zone Selection"
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.TextSize = 32
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = ""
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Zones container
local zonesContainer = Instance.new("ScrollingFrame")
zonesContainer.Size = UDim2.new(1, -40, 1, -90)
zonesContainer.Position = UDim2.new(0, 20, 0, 70)
zonesContainer.BackgroundTransparency = 1
zonesContainer.BorderSizePixel = 0
zonesContainer.ScrollBarThickness = 6
zonesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
zonesContainer.Parent = mainFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 340, 0, 140)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = zonesContainer

-- Auto-resize canvas
gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    zonesContainer.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 10)
end)

-- Player data
local currentRebirthLevel = 0

-- Create zone card
local function CreateZoneCard(zoneData, layoutOrder)
    local isUnlocked = currentRebirthLevel >= zoneData.RebirthRequired

    local card = Instance.new("Frame")
    card.Name = zoneData.Name
    card.BackgroundColor3 = zoneData.Color
    card.BorderSizePixel = 0
    card.LayoutOrder = layoutOrder
    card.Parent = zonesContainer

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    -- Overlay for locked zones
    if not isUnlocked then
        local lockOverlay = Instance.new("Frame")
        lockOverlay.Size = UDim2.new(1, 0, 1, 0)
        lockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        lockOverlay.BackgroundTransparency = 0.7
        lockOverlay.BorderSizePixel = 0
        lockOverlay.Parent = card

        local lockCorner = Instance.new("UICorner")
        lockCorner.CornerRadius = UDim.new(0, 8)
        lockCorner.Parent = lockOverlay
    end

    -- Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -20, 0, 30)
    nameLabel.Position = UDim2.new(0, 10, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = zoneData.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 20
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = card

    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -20, 0, 20)
    descLabel.Position = UDim2.new(0, 10, 0, 40)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = zoneData.Description
    descLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    descLabel.TextSize = 14
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextStrokeTransparency = 0.5
    descLabel.Parent = card

    -- Stats
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(1, -20, 0, 18)
    statsLabel.Position = UDim2.new(0, 10, 0, 65)
    statsLabel.BackgroundTransparency = 1

    if zoneData.IsHub then
        statsLabel.Text = "Safe zone - No beds"
    else
        statsLabel.Text = string.format("=Ï %d beds | %.1fx multiplier", zoneData.BedCount, zoneData.BedMultiplier)
    end

    statsLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
    statsLabel.TextSize = 13
    statsLabel.Font = Enum.Font.Gotham
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.TextStrokeTransparency = 0.5
    statsLabel.Parent = card

    -- Requirement
    local reqLabel = Instance.new("TextLabel")
    reqLabel.Size = UDim2.new(1, -20, 0, 18)
    reqLabel.Position = UDim2.new(0, 10, 0, 87)
    reqLabel.BackgroundTransparency = 1

    if zoneData.RebirthRequired == 0 then
        reqLabel.Text = " Always Available"
        reqLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    elseif isUnlocked then
        reqLabel.Text = string.format(" Unlocked (Rebirth %d)", zoneData.RebirthRequired)
        reqLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        reqLabel.Text = string.format("= Requires Rebirth %d", zoneData.RebirthRequired)
        reqLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end

    reqLabel.TextSize = 12
    reqLabel.Font = Enum.Font.Gotham
    reqLabel.TextXAlignment = Enum.TextXAlignment.Left
    reqLabel.TextStrokeTransparency = 0.5
    reqLabel.Parent = card

    -- Teleport button
    if isUnlocked then
        local teleportButton = Instance.new("TextButton")
        teleportButton.Size = UDim2.new(1, -20, 0, 30)
        teleportButton.Position = UDim2.new(0, 10, 1, -40)
        teleportButton.BackgroundColor3 = Color3.fromRGB(75, 175, 255)
        teleportButton.BorderSizePixel = 0
        teleportButton.Text = "=Í TELEPORT"
        teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportButton.TextSize = 16
        teleportButton.Font = Enum.Font.GothamBold
        teleportButton.Parent = card

        local teleportCorner = Instance.new("UICorner")
        teleportCorner.CornerRadius = UDim.new(0, 6)
        teleportCorner.Parent = teleportButton

        teleportButton.MouseButton1Click:Connect(function()
            local TeleportToZoneEvent = RemoteEvents:FindFirstChild("TeleportToZone")
            if TeleportToZoneEvent then
                TeleportToZoneEvent:FireServer(zoneData.Name)
                CloseZoneMenu()
            end
        end)
    end

    return card
end

-- Create all zone cards
for i, zoneData in ipairs(ZoneConfig.Zones) do
    CreateZoneCard(zoneData, i)
end

-- Open zone menu
local function OpenZoneMenu()
    zoneGui.Enabled = true

    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 750, 0, 550)
    }):Play()
end

-- Close zone menu
function CloseZoneMenu()
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.wait(0.3)
    zoneGui.Enabled = false
end

closeButton.MouseButton1Click:Connect(function()
    CloseZoneMenu()
end)

-- Hotkey (Z key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.Z then
        if not zoneGui.Enabled then
            OpenZoneMenu()
        else
            CloseZoneMenu()
        end
    end
end)

-- Update zones when rebirth level changes
local function UpdateZones(rebirthLevel)
    currentRebirthLevel = rebirthLevel

    -- Recreate all cards
    zonesContainer:ClearAllChildren()
    gridLayout.Parent = zonesContainer

    for i, zoneData in ipairs(ZoneConfig.Zones) do
        CreateZoneCard(zoneData, i)
    end
end

-- Expose globals
_G.OpenZoneMenu = OpenZoneMenu
_G.UpdateZones = UpdateZones

print("[ZoneUI] Loaded - Press Z to open Zone menu")
