--[[
    MainUI.lua
    SCRIPT TYPE: LocalScript (NOT Script or ModuleScript)
    LOCATION: StarterGui/MainUI

    Creates all UI elements for the game
    (Score display, upgrades panel, tool shop, admin panel, notifications)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ===== SCORE DISPLAY (Top Right) =====
local scoreFrame = Instance.new("Frame")
scoreFrame.Name = "ScoreFrame"
scoreFrame.Size = UDim2.new(0, 250, 0, 100)
scoreFrame.Position = UDim2.new(1, -260, 0, 10)
scoreFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scoreFrame.BorderSizePixel = 0
scoreFrame.Parent = screenGui

local scoreFrameCorner = Instance.new("UICorner")
scoreFrameCorner.CornerRadius = UDim.new(0, 10)
scoreFrameCorner.Parent = scoreFrame

local scoreTitle = Instance.new("TextLabel")
scoreTitle.Name = "Title"
scoreTitle.Size = UDim2.new(1, 0, 0, 30)
scoreTitle.Position = UDim2.new(0, 0, 0, 5)
scoreTitle.BackgroundTransparency = 1
scoreTitle.Text = "⏰ TIME POINTS"
scoreTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
scoreTitle.TextSize = 18
scoreTitle.Font = Enum.Font.GothamBold
scoreTitle.Parent = scoreFrame

local scoreValue = Instance.new("TextLabel")
scoreValue.Name = "Value"
scoreValue.Size = UDim2.new(1, 0, 0, 50)
scoreValue.Position = UDim2.new(0, 0, 0, 35)
scoreValue.BackgroundTransparency = 1
scoreValue.Text = "0"
scoreValue.TextColor3 = Color3.fromRGB(100, 255, 100)
scoreValue.TextSize = 36
scoreValue.Font = Enum.Font.GothamBold
scoreValue.Parent = scoreFrame

-- ===== DAY/NIGHT INDICATOR =====
local dayNightLabel = Instance.new("TextLabel")
dayNightLabel.Name = "DayNightLabel"
dayNightLabel.Size = UDim2.new(0, 150, 0, 40)
dayNightLabel.Position = UDim2.new(0.5, -75, 0, 10)
dayNightLabel.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
dayNightLabel.BorderSizePixel = 0
dayNightLabel.Text = "☀️ DAY"
dayNightLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
dayNightLabel.TextSize = 24
dayNightLabel.Font = Enum.Font.GothamBold
dayNightLabel.Parent = screenGui

local dayNightCorner = Instance.new("UICorner")
dayNightCorner.CornerRadius = UDim.new(0, 10)
dayNightCorner.Parent = dayNightLabel

-- ===== EVENT NOTIFICATION (Top Center) =====
local eventNotification = Instance.new("TextLabel")
eventNotification.Name = "EventNotification"
eventNotification.Size = UDim2.new(0, 500, 0, 60)
eventNotification.Position = UDim2.new(0.5, -250, 0, 60)
eventNotification.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
eventNotification.BorderSizePixel = 0
eventNotification.Text = ""
eventNotification.TextColor3 = Color3.fromRGB(255, 255, 255)
eventNotification.TextSize = 22
eventNotification.Font = Enum.Font.GothamBold
eventNotification.Visible = false
eventNotification.Parent = screenGui

local eventCorner = Instance.new("UICorner")
eventCorner.CornerRadius = UDim.new(0, 10)
eventCorner.Parent = eventNotification

-- ===== UPGRADES PANEL (Left Side) =====
local upgradesFrame = Instance.new("ScrollingFrame")
upgradesFrame.Name = "UpgradesFrame"
upgradesFrame.Size = UDim2.new(0, 300, 0, 400)
upgradesFrame.Position = UDim2.new(0, 10, 0.5, -200)
upgradesFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
upgradesFrame.BorderSizePixel = 0
upgradesFrame.ScrollBarThickness = 8
upgradesFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
upgradesFrame.Parent = screenGui

local upgradesCorner = Instance.new("UICorner")
upgradesCorner.CornerRadius = UDim.new(0, 10)
upgradesCorner.Parent = upgradesFrame

local upgradesTitle = Instance.new("TextLabel")
upgradesTitle.Name = "Title"
upgradesTitle.Size = UDim2.new(1, -10, 0, 40)
upgradesTitle.Position = UDim2.new(0, 5, 0, 5)
upgradesTitle.BackgroundTransparency = 1
upgradesTitle.Text = "📈 UPGRADES"
upgradesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradesTitle.TextSize = 20
upgradesTitle.Font = Enum.Font.GothamBold
upgradesTitle.Parent = upgradesFrame

-- Create upgrade buttons
local upgradeNames = {"SleepEfficiency", "TheftProtection", "ToolCapacity", "ScoreMultiplier"}
local upgradeDisplayNames = {
    SleepEfficiency = "Sleep Efficiency",
    TheftProtection = "Theft Protection",
    ToolCapacity = "Tool Capacity",
    ScoreMultiplier = "Score Multiplier"
}

local upgradeButtons = {}
for i, upgradeName in ipairs(upgradeNames) do
    local button = Instance.new("TextButton")
    button.Name = upgradeName
    button.Size = UDim2.new(1, -20, 0, 80)
    button.Position = UDim2.new(0, 10, 0, 50 + (i - 1) * 90)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = upgradesFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0, 25)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = upgradeDisplayNames[upgradeName]
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = button

    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.Size = UDim2.new(1, -10, 0, 20)
    levelLabel.Position = UDim2.new(0, 5, 0, 30)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Level: 0/10"
    levelLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    levelLabel.TextSize = 14
    levelLabel.Font = Enum.Font.Gotham
    levelLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelLabel.Parent = button

    local costLabel = Instance.new("TextLabel")
    costLabel.Name = "CostLabel"
    costLabel.Size = UDim2.new(1, -10, 0, 20)
    costLabel.Position = UDim2.new(0, 5, 0, 55)
    costLabel.BackgroundTransparency = 1
    costLabel.Text = "Cost: 100 TP"
    costLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    costLabel.TextSize = 14
    costLabel.Font = Enum.Font.GothamBold
    costLabel.TextXAlignment = Enum.TextXAlignment.Left
    costLabel.Parent = button

    upgradeButtons[upgradeName] = button
end

-- ===== TOOL SHOP BUTTON (Bottom Center) =====
local toolShopButton = Instance.new("TextButton")
toolShopButton.Name = "ToolShopButton"
toolShopButton.Size = UDim2.new(0, 200, 0, 50)
toolShopButton.Position = UDim2.new(0.5, -100, 1, -60)
toolShopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toolShopButton.BorderSizePixel = 0
toolShopButton.Text = "🔧 Buy Tool (500 TP)"
toolShopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toolShopButton.TextSize = 18
toolShopButton.Font = Enum.Font.GothamBold
toolShopButton.Parent = screenGui

local toolShopCorner = Instance.new("UICorner")
toolShopCorner.CornerRadius = UDim.new(0, 10)
toolShopCorner.Parent = toolShopButton

-- ===== ADMIN PANEL (Hidden by default) =====
local adminPanel = Instance.new("Frame")
adminPanel.Name = "AdminPanel"
adminPanel.Size = UDim2.new(0, 400, 0, 500)
adminPanel.Position = UDim2.new(0.5, -200, 0.5, -250)
adminPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
adminPanel.BorderSizePixel = 2
adminPanel.BorderColor3 = Color3.fromRGB(255, 0, 0)
adminPanel.Visible = false
adminPanel.Parent = screenGui

local adminCorner = Instance.new("UICorner")
adminCorner.CornerRadius = UDim.new(0, 10)
adminCorner.Parent = adminPanel

local adminTitle = Instance.new("TextLabel")
adminTitle.Size = UDim2.new(1, 0, 0, 40)
adminTitle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
adminTitle.Text = "👑 ADMIN PANEL"
adminTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
adminTitle.TextSize = 22
adminTitle.Font = Enum.Font.GothamBold
adminTitle.Parent = adminPanel

local adminTitleCorner = Instance.new("UICorner")
adminTitleCorner.CornerRadius = UDim.new(0, 10)
adminTitleCorner.Parent = adminTitle

local commandInput = Instance.new("TextBox")
commandInput.Name = "CommandInput"
commandInput.Size = UDim2.new(1, -20, 0, 40)
commandInput.Position = UDim2.new(0, 10, 0, 50)
commandInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
commandInput.BorderSizePixel = 0
commandInput.PlaceholderText = "Enter command... (type Help for list)"
commandInput.Text = ""
commandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
commandInput.TextSize = 16
commandInput.Font = Enum.Font.Gotham
commandInput.ClearTextOnFocus = false
commandInput.Parent = adminPanel

local commandCorner = Instance.new("UICorner")
commandCorner.CornerRadius = UDim.new(0, 8)
commandCorner.Parent = commandInput

local outputScroll = Instance.new("ScrollingFrame")
outputScroll.Name = "Output"
outputScroll.Size = UDim2.new(1, -20, 1, -110)
outputScroll.Position = UDim2.new(0, 10, 0, 100)
outputScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
outputScroll.BorderSizePixel = 0
outputScroll.ScrollBarThickness = 6
outputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
outputScroll.Parent = adminPanel

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 8)
outputCorner.Parent = outputScroll

local outputLayout = Instance.new("UIListLayout")
outputLayout.Padding = UDim.new(0, 5)
outputLayout.Parent = outputScroll

-- Store reference for client script
_G.GameUI = {
    scoreValue = scoreValue,
    eventNotification = eventNotification,
    dayNightLabel = dayNightLabel,
    upgradeButtons = upgradeButtons,
    toolShopButton = toolShopButton,
    adminPanel = adminPanel,
    commandInput = commandInput,
    outputScroll = outputScroll,
}

print("[MainUI] UI Created!")
