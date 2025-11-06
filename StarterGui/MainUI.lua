--[[
    MainUI.lua
    SCRIPT TYPE: LocalScript (NOT Script or ModuleScript)
    LOCATION: StarterGui/MainUI

    Creates all UI elements for the game - REDESIGNED FOR BETTER AESTHETICS
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ===== SCORE DISPLAY (Top Right - Cleaner) =====
local scoreFrame = Instance.new("Frame")
scoreFrame.Name = "ScoreFrame"
scoreFrame.Size = UDim2.new(0, 220, 0, 80)
scoreFrame.Position = UDim2.new(1, -230, 0, 10)
scoreFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
scoreFrame.BorderSizePixel = 0
scoreFrame.Parent = screenGui

local scoreCorner = Instance.new("UICorner")
scoreCorner.CornerRadius = UDim.new(0, 12)
scoreCorner.Parent = scoreFrame

local scoreStroke = Instance.new("UIStroke")
scoreStroke.Color = Color3.fromRGB(100, 255, 100)
scoreStroke.Thickness = 2
scoreStroke.Transparency = 0.5
scoreStroke.Parent = scoreFrame

local scoreTitle = Instance.new("TextLabel")
scoreTitle.Size = UDim2.new(1, -20, 0, 25)
scoreTitle.Position = UDim2.new(0, 10, 0, 8)
scoreTitle.BackgroundTransparency = 1
scoreTitle.Text = "⏰ Time Points"
scoreTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
scoreTitle.TextSize = 14
scoreTitle.Font = Enum.Font.Gotham
scoreTitle.TextXAlignment = Enum.TextXAlignment.Left
scoreTitle.Parent = scoreFrame

local scoreValue = Instance.new("TextLabel")
scoreValue.Name = "Value"
scoreValue.Size = UDim2.new(1, -20, 0, 40)
scoreValue.Position = UDim2.new(0, 10, 0, 33)
scoreValue.BackgroundTransparency = 1
scoreValue.Text = "0"
scoreValue.TextColor3 = Color3.fromRGB(100, 255, 100)
scoreValue.TextSize = 32
scoreValue.Font = Enum.Font.GothamBold
scoreValue.TextXAlignment = Enum.TextXAlignment.Left
scoreValue.Parent = scoreFrame

-- ===== DAY/NIGHT INDICATOR (Top Center - Sleeker) =====
local dayNightLabel = Instance.new("Frame")
dayNightLabel.Name = "DayNightFrame"
dayNightLabel.Size = UDim2.new(0, 140, 0, 45)
dayNightLabel.Position = UDim2.new(0.5, -70, 0, 10)
dayNightLabel.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
dayNightLabel.BorderSizePixel = 0
dayNightLabel.Parent = screenGui

local dayNightCorner = Instance.new("UICorner")
dayNightCorner.CornerRadius = UDim.new(0, 12)
dayNightCorner.Parent = dayNightLabel

local dayNightGradient = Instance.new("UIGradient")
dayNightGradient.Color = ColorSequence.new(Color3.fromRGB(255, 220, 100), Color3.fromRGB(255, 180, 50))
dayNightGradient.Rotation = 90
dayNightGradient.Parent = dayNightLabel

local dayNightText = Instance.new("TextLabel")
dayNightText.Name = "Text"
dayNightText.Size = UDim2.new(1, 0, 1, 0)
dayNightText.BackgroundTransparency = 1
dayNightText.Text = "☀️ DAY"
dayNightText.TextColor3 = Color3.fromRGB(255, 255, 255)
dayNightText.TextSize = 22
dayNightText.Font = Enum.Font.GothamBold
dayNightText.TextStrokeTransparency = 0.5
dayNightText.Parent = dayNightLabel

-- ===== EVENT NOTIFICATION (Better positioning) =====
local eventNotification = Instance.new("Frame")
eventNotification.Name = "EventNotification"
eventNotification.Size = UDim2.new(0, 450, 0, 70)
eventNotification.Position = UDim2.new(0.5, -225, 0, 70)
eventNotification.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
eventNotification.BorderSizePixel = 0
eventNotification.Visible = false
eventNotification.Parent = screenGui

local eventCorner = Instance.new("UICorner")
eventCorner.CornerRadius = UDim.new(0, 12)
eventCorner.Parent = eventNotification

local eventStroke = Instance.new("UIStroke")
eventStroke.Color = Color3.fromRGB(255, 255, 255)
eventStroke.Thickness = 3
eventStroke.Transparency = 0.3
eventStroke.Parent = eventNotification

local eventText = Instance.new("TextLabel")
eventText.Name = "EventText"
eventText.Size = UDim2.new(1, -20, 1, -10)
eventText.Position = UDim2.new(0, 10, 0, 5)
eventText.BackgroundTransparency = 1
eventText.Text = ""
eventText.TextColor3 = Color3.fromRGB(255, 255, 255)
eventText.TextSize = 20
eventText.Font = Enum.Font.GothamBold
eventText.TextStrokeTransparency = 0.3
eventText.TextWrapped = true
eventText.Parent = eventNotification

-- ===== UPGRADES BUTTON (Collapsible) =====
local upgradesButton = Instance.new("TextButton")
upgradesButton.Name = "UpgradesButton"
upgradesButton.Size = UDim2.new(0, 180, 0, 50)
upgradesButton.Position = UDim2.new(0, 10, 0, 10)
upgradesButton.BackgroundColor3 = Color3.fromRGB(75, 50, 150)
upgradesButton.BorderSizePixel = 0
upgradesButton.Text = "📈 UPGRADES"
upgradesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradesButton.TextSize = 18
upgradesButton.Font = Enum.Font.GothamBold
upgradesButton.Parent = screenGui

local upgradesButtonCorner = Instance.new("UICorner")
upgradesButtonCorner.CornerRadius = UDim.new(0, 10)
upgradesButtonCorner.Parent = upgradesButton

-- ===== UPGRADES PANEL (Hidden by default, cleaner design) =====
local upgradesFrame = Instance.new("Frame")
upgradesFrame.Name = "UpgradesFrame"
upgradesFrame.Size = UDim2.new(0, 320, 0, 450)
upgradesFrame.Position = UDim2.new(0, -330, 0.5, -225)  -- Hidden off-screen
upgradesFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
upgradesFrame.BorderSizePixel = 0
upgradesFrame.Parent = screenGui

local upgradesCorner = Instance.new("UICorner")
upgradesCorner.CornerRadius = UDim.new(0, 15)
upgradesCorner.Parent = upgradesFrame

local upgradesStroke = Instance.new("UIStroke")
upgradesStroke.Color = Color3.fromRGB(75, 50, 150)
upgradesStroke.Thickness = 3
upgradesStroke.Parent = upgradesFrame

local upgradesTitle = Instance.new("TextLabel")
upgradesTitle.Size = UDim2.new(1, -20, 0, 45)
upgradesTitle.Position = UDim2.new(0, 10, 0, 10)
upgradesTitle.BackgroundTransparency = 1
upgradesTitle.Text = "📈 UPGRADES"
upgradesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradesTitle.TextSize = 22
upgradesTitle.Font = Enum.Font.GothamBold
upgradesTitle.TextXAlignment = Enum.TextXAlignment.Left
upgradesTitle.Parent = upgradesFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 12)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = upgradesFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Scroll frame for upgrades
local upgradesScroll = Instance.new("ScrollingFrame")
upgradesScroll.Size = UDim2.new(1, -20, 1, -70)
upgradesScroll.Position = UDim2.new(0, 10, 0, 60)
upgradesScroll.BackgroundTransparency = 1
upgradesScroll.BorderSizePixel = 0
upgradesScroll.ScrollBarThickness = 6
upgradesScroll.ScrollBarImageColor3 = Color3.fromRGB(75, 50, 150)
upgradesScroll.CanvasSize = UDim2.new(0, 0, 0, 380)
upgradesScroll.Parent = upgradesFrame

-- Create upgrade buttons (cleaner design)
local upgradeNames = {"SleepEfficiency", "TheftProtection", "ToolCapacity", "ScoreMultiplier"}
local upgradeDisplayNames = {
    SleepEfficiency = "💤 Sleep Efficiency",
    TheftProtection = "🛡️ Theft Protection",
    ToolCapacity = "🔧 Tool Capacity",
    ScoreMultiplier = "⭐ Score Multiplier"
}

local upgradeButtons = {}
for i, upgradeName in ipairs(upgradeNames) do
    local button = Instance.new("TextButton")
    button.Name = upgradeName
    button.Size = UDim2.new(1, -10, 0, 85)
    button.Position = UDim2.new(0, 5, 0, (i - 1) * 95)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = upgradesScroll

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(75, 50, 150)
    buttonStroke.Thickness = 2
    buttonStroke.Transparency = 0.7
    buttonStroke.Parent = button

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -15, 0, 25)
    nameLabel.Position = UDim2.new(0, 10, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = upgradeDisplayNames[upgradeName]
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = button

    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.Size = UDim2.new(1, -15, 0, 20)
    levelLabel.Position = UDim2.new(0, 10, 0, 35)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Level: 0/10"
    levelLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    levelLabel.TextSize = 13
    levelLabel.Font = Enum.Font.Gotham
    levelLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelLabel.Parent = button

    local costLabel = Instance.new("TextLabel")
    costLabel.Name = "CostLabel"
    costLabel.Size = UDim2.new(1, -15, 0, 22)
    costLabel.Position = UDim2.new(0, 10, 0, 58)
    costLabel.BackgroundTransparency = 1
    costLabel.Text = "Cost: 100 TP"
    costLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    costLabel.TextSize = 15
    costLabel.Font = Enum.Font.GothamBold
    costLabel.TextXAlignment = Enum.TextXAlignment.Left
    costLabel.Parent = button

    upgradeButtons[upgradeName] = button
end

-- Toggle upgrades panel
local upgradesOpen = false
upgradesButton.MouseButton1Click:Connect(function()
    upgradesOpen = not upgradesOpen
    local targetPos = upgradesOpen
        and UDim2.new(0, 10, 0.5, -225)
        or UDim2.new(0, -330, 0.5, -225)

    TweenService:Create(upgradesFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = targetPos
    }):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    upgradesOpen = false
    TweenService:Create(upgradesFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, -330, 0.5, -225)
    }):Play()
end)

-- ===== TOOL SHOP BUTTON (Bottom Center - Better design) =====
local toolShopButton = Instance.new("TextButton")
toolShopButton.Name = "ToolShopButton"
toolShopButton.Size = UDim2.new(0, 220, 0, 55)
toolShopButton.Position = UDim2.new(0.5, -110, 1, -65)
toolShopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toolShopButton.BorderSizePixel = 0
toolShopButton.Text = "🔧 BUY TOOL (500 TP)"
toolShopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toolShopButton.TextSize = 18
toolShopButton.Font = Enum.Font.GothamBold
toolShopButton.Parent = screenGui

local toolShopCorner = Instance.new("UICorner")
toolShopCorner.CornerRadius = UDim.new(0, 12)
toolShopCorner.Parent = toolShopButton

local toolShopGradient = Instance.new("UIGradient")
toolShopGradient.Color = ColorSequence.new(Color3.fromRGB(220, 50, 50), Color3.fromRGB(180, 30, 30))
toolShopGradient.Rotation = 90
toolShopGradient.Parent = toolShopButton

-- ===== ADMIN PANEL (Cleaner design) =====
local adminPanel = Instance.new("Frame")
adminPanel.Name = "AdminPanel"
adminPanel.Size = UDim2.new(0, 450, 0, 550)
adminPanel.Position = UDim2.new(0.5, -225, 0.5, -275)
adminPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
adminPanel.BorderSizePixel = 0
adminPanel.Visible = false
adminPanel.ZIndex = 100
adminPanel.Parent = screenGui

local adminCorner = Instance.new("UICorner")
adminCorner.CornerRadius = UDim.new(0, 15)
adminCorner.Parent = adminPanel

local adminStroke = Instance.new("UIStroke")
adminStroke.Color = Color3.fromRGB(255, 0, 0)
adminStroke.Thickness = 3
adminStroke.Parent = adminPanel

local adminTitle = Instance.new("Frame")
adminTitle.Size = UDim2.new(1, 0, 0, 50)
adminTitle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
adminTitle.BorderSizePixel = 0
adminTitle.Parent = adminPanel

local adminTitleCorner = Instance.new("UICorner")
adminTitleCorner.CornerRadius = UDim.new(0, 15)
adminTitleCorner.Parent = adminTitle

local adminTitleText = Instance.new("TextLabel")
adminTitleText.Size = UDim2.new(1, 0, 1, 0)
adminTitleText.BackgroundTransparency = 1
adminTitleText.Text = "👑 ADMIN PANEL"
adminTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
adminTitleText.TextSize = 24
adminTitleText.Font = Enum.Font.GothamBold
adminTitleText.Parent = adminTitle

local commandInput = Instance.new("TextBox")
commandInput.Name = "CommandInput"
commandInput.Size = UDim2.new(1, -30, 0, 45)
commandInput.Position = UDim2.new(0, 15, 0, 65)
commandInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
commandInput.BorderSizePixel = 0
commandInput.PlaceholderText = "Type command... (Help for list)"
commandInput.Text = ""
commandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
commandInput.TextSize = 16
commandInput.Font = Enum.Font.Gotham
commandInput.ClearTextOnFocus = false
commandInput.Parent = adminPanel

local commandCorner = Instance.new("UICorner")
commandCorner.CornerRadius = UDim.new(0, 10)
commandCorner.Parent = commandInput

local outputScroll = Instance.new("ScrollingFrame")
outputScroll.Name = "Output"
outputScroll.Size = UDim2.new(1, -30, 1, -130)
outputScroll.Position = UDim2.new(0, 15, 0, 120)
outputScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
outputScroll.BorderSizePixel = 0
outputScroll.ScrollBarThickness = 8
outputScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
outputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
outputScroll.Parent = adminPanel

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 10)
outputCorner.Parent = outputScroll

local outputLayout = Instance.new("UIListLayout")
outputLayout.Padding = UDim.new(0, 5)
outputLayout.Parent = outputScroll

-- Store reference for client script
_G.GameUI = {
    scoreValue = scoreValue,
    eventNotification = eventNotification,
    eventText = eventText,
    dayNightLabel = dayNightLabel,
    dayNightText = dayNightText,
    upgradeButtons = upgradeButtons,
    toolShopButton = toolShopButton,
    adminPanel = adminPanel,
    commandInput = commandInput,
    outputScroll = outputScroll,
}

print("[MainUI] Redesigned UI Created! 🎨")
