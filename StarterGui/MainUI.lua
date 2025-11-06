--[[
    MainUI.lua
    SCRIPT TYPE: LocalScript (NOT Script or ModuleScript)
    LOCATION: StarterGui/MainUI

    Professional sidebar UI with event icons and hover tooltips
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
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ===== RIGHT SIDEBAR =====
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 250, 1, 0)
sidebar.Position = UDim2.new(1, -250, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
sidebar.BorderSizePixel = 0
sidebar.Parent = screenGui

-- Sidebar gradient
local sidebarGradient = Instance.new("UIGradient")
sidebarGradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 35), Color3.fromRGB(20, 20, 25))
sidebarGradient.Rotation = 90
sidebarGradient.Parent = sidebar

-- Player info section
local playerInfo = Instance.new("Frame")
playerInfo.Name = "PlayerInfo"
playerInfo.Size = UDim2.new(1, -20, 0, 100)
playerInfo.Position = UDim2.new(0, 10, 0, 10)
playerInfo.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
playerInfo.BorderSizePixel = 0
playerInfo.Parent = sidebar

local playerInfoCorner = Instance.new("UICorner")
playerInfoCorner.CornerRadius = UDim.new(0, 8)
playerInfoCorner.Parent = playerInfo

-- Player name
local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(1, -20, 0, 25)
playerNameLabel.Position = UDim2.new(0, 10, 0, 10)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = player.Name
playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameLabel.TextSize = 16
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
playerNameLabel.Parent = playerInfo

-- Time Points display
local tpLabel = Instance.new("TextLabel")
tpLabel.Size = UDim2.new(1, -20, 0, 20)
tpLabel.Position = UDim2.new(0, 10, 0, 40)
tpLabel.BackgroundTransparency = 1
tpLabel.Text = "⏰ Time Points"
tpLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
tpLabel.TextSize = 12
tpLabel.Font = Enum.Font.Gotham
tpLabel.TextXAlignment = Enum.TextXAlignment.Left
tpLabel.Parent = playerInfo

local tpValue = Instance.new("TextLabel")
tpValue.Name = "TPValue"
tpValue.Size = UDim2.new(1, -20, 0, 30)
tpValue.Position = UDim2.new(0, 10, 0, 60)
tpValue.BackgroundTransparency = 1
tpValue.Text = "0"
tpValue.TextColor3 = Color3.fromRGB(100, 255, 150)
tpValue.TextSize = 24
tpValue.Font = Enum.Font.GothamBold
tpValue.TextXAlignment = Enum.TextXAlignment.Left
tpValue.Parent = playerInfo

-- Stats section
local statsFrame = Instance.new("Frame")
statsFrame.Name = "Stats"
statsFrame.Size = UDim2.new(1, -20, 0, 120)
statsFrame.Position = UDim2.new(0, 10, 0, 120)
statsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
statsFrame.BorderSizePixel = 0
statsFrame.Parent = sidebar

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 8)
statsCorner.Parent = statsFrame

local statsTitle = Instance.new("TextLabel")
statsTitle.Size = UDim2.new(1, -20, 0, 30)
statsTitle.Position = UDim2.new(0, 10, 0, 5)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "📊 STATS"
statsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
statsTitle.TextSize = 14
statsTitle.Font = Enum.Font.GothamBold
statsTitle.TextXAlignment = Enum.TextXAlignment.Left
statsTitle.Parent = statsFrame

-- Total steals stat
local stealsLabel = Instance.new("TextLabel")
stealsLabel.Name = "StealsLabel"
stealsLabel.Size = UDim2.new(1, -20, 0, 20)
stealsLabel.Position = UDim2.new(0, 10, 0, 40)
stealsLabel.BackgroundTransparency = 1
stealsLabel.Text = "💰 Total Steals: 0"
stealsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
stealsLabel.TextSize = 12
stealsLabel.Font = Enum.Font.Gotham
stealsLabel.TextXAlignment = Enum.TextXAlignment.Left
stealsLabel.Parent = statsFrame

-- Earning rate stat
local rateLabel = Instance.new("TextLabel")
rateLabel.Name = "RateLabel"
rateLabel.Size = UDim2.new(1, -20, 0, 20)
rateLabel.Position = UDim2.new(0, 10, 0, 65)
rateLabel.BackgroundTransparency = 1
rateLabel.Text = "📈 Earning: 1.0 TP/s"
rateLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
rateLabel.TextSize = 12
rateLabel.Font = Enum.Font.Gotham
rateLabel.TextXAlignment = Enum.TextXAlignment.Left
rateLabel.Parent = statsFrame

-- Zone stat
local zoneLabel = Instance.new("TextLabel")
zoneLabel.Name = "ZoneLabel"
zoneLabel.Size = UDim2.new(1, -20, 0, 20)
zoneLabel.Position = UDim2.new(0, 10, 0, 90)
zoneLabel.BackgroundTransparency = 1
zoneLabel.Text = "🌍 Zone: Starter"
zoneLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
zoneLabel.TextSize = 12
zoneLabel.Font = Enum.Font.Gotham
zoneLabel.TextXAlignment = Enum.TextXAlignment.Left
zoneLabel.Parent = statsFrame

-- Day/Night indicator
local dayNightFrame = Instance.new("Frame")
dayNightFrame.Name = "DayNight"
dayNightFrame.Size = UDim2.new(1, -20, 0, 45)
dayNightFrame.Position = UDim2.new(0, 10, 0, 250)
dayNightFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
dayNightFrame.BorderSizePixel = 0
dayNightFrame.Parent = sidebar

local dayNightCorner = Instance.new("UICorner")
dayNightCorner.CornerRadius = UDim.new(0, 8)
dayNightCorner.Parent = dayNightFrame

local dayNightGradient = Instance.new("UIGradient")
dayNightGradient.Color = ColorSequence.new(Color3.fromRGB(255, 220, 100), Color3.fromRGB(255, 180, 50))
dayNightGradient.Rotation = 90
dayNightGradient.Parent = dayNightFrame

local dayNightText = Instance.new("TextLabel")
dayNightText.Name = "Text"
dayNightText.Size = UDim2.new(1, 0, 1, 0)
dayNightText.BackgroundTransparency = 1
dayNightText.Text = "☀️ DAY"
dayNightText.TextColor3 = Color3.fromRGB(255, 255, 255)
dayNightText.TextSize = 20
dayNightText.Font = Enum.Font.GothamBold
dayNightText.TextStrokeTransparency = 0.5
dayNightText.Parent = dayNightFrame

-- ===== EVENT ICON (Bottom Left) =====
local eventIcon = Instance.new("ImageButton")
eventIcon.Name = "EventIcon"
eventIcon.Size = UDim2.new(0, 80, 0, 80)
eventIcon.Position = UDim2.new(0, 20, 1, -100)
eventIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
eventIcon.BorderSizePixel = 0
eventIcon.Visible = false
eventIcon.Image = ""  -- Will be set when event starts
eventIcon.ScaleType = Enum.ScaleType.Fit
eventIcon.Parent = screenGui

local eventIconCorner = Instance.new("UICorner")
eventIconCorner.CornerRadius = UDim.new(0, 12)
eventIconCorner.Parent = eventIcon

local eventIconStroke = Instance.new("UIStroke")
eventIconStroke.Color = Color3.fromRGB(255, 200, 0)
eventIconStroke.Thickness = 3
eventIconStroke.Parent = eventIcon

-- Event tooltip (shows on hover)
local eventTooltip = Instance.new("Frame")
eventTooltip.Name = "Tooltip"
eventTooltip.Size = UDim2.new(0, 200, 0, 70)
eventTooltip.Position = UDim2.new(0, 110, 1, -100)
eventTooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
eventTooltip.BorderSizePixel = 0
eventTooltip.Visible = false
eventTooltip.ZIndex = 10
eventTooltip.Parent = screenGui

local tooltipCorner = Instance.new("UICorner")
tooltipCorner.CornerRadius = UDim.new(0, 8)
tooltipCorner.Parent = eventTooltip

local tooltipStroke = Instance.new("UIStroke")
tooltipStroke.Color = Color3.fromRGB(255, 200, 0)
tooltipStroke.Thickness = 2
tooltipStroke.Parent = eventTooltip

local tooltipTitle = Instance.new("TextLabel")
tooltipTitle.Name = "Title"
tooltipTitle.Size = UDim2.new(1, -20, 0, 25)
tooltipTitle.Position = UDim2.new(0, 10, 0, 5)
tooltipTitle.BackgroundTransparency = 1
tooltipTitle.Text = "Event Name"
tooltipTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
tooltipTitle.TextSize = 16
tooltipTitle.Font = Enum.Font.GothamBold
tooltipTitle.TextXAlignment = Enum.TextXAlignment.Left
tooltipTitle.Parent = eventTooltip

local tooltipMultiplier = Instance.new("TextLabel")
tooltipMultiplier.Name = "Multiplier"
tooltipMultiplier.Size = UDim2.new(1, -20, 0, 20)
tooltipMultiplier.Position = UDim2.new(0, 10, 0, 30)
tooltipMultiplier.BackgroundTransparency = 1
tooltipMultiplier.Text = "⚡ 3x Multiplier"
tooltipMultiplier.TextColor3 = Color3.fromRGB(200, 200, 200)
tooltipMultiplier.TextSize = 13
tooltipMultiplier.Font = Enum.Font.Gotham
tooltipMultiplier.TextXAlignment = Enum.TextXAlignment.Left
tooltipMultiplier.Parent = eventTooltip

local tooltipDuration = Instance.new("TextLabel")
tooltipDuration.Name = "Duration"
tooltipDuration.Size = UDim2.new(1, -20, 0, 20)
tooltipDuration.Position = UDim2.new(0, 10, 0, 48)
tooltipDuration.BackgroundTransparency = 1
tooltipDuration.Text = "⏱️ 60s remaining"
tooltipDuration.TextColor3 = Color3.fromRGB(200, 200, 200)
tooltipDuration.TextSize = 13
tooltipDuration.Font = Enum.Font.Gotham
tooltipDuration.TextXAlignment = Enum.TextXAlignment.Left
tooltipDuration.Parent = eventTooltip

-- Hover detection for event icon
eventIcon.MouseEnter:Connect(function()
    eventTooltip.Visible = true
    TweenService:Create(eventTooltip, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 220, 0, 75)
    }):Play()
end)

eventIcon.MouseLeave:Connect(function()
    TweenService:Create(eventTooltip, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 200, 0, 70)
    }):Play()
    task.wait(0.2)
    eventTooltip.Visible = false
end)

-- ===== QUICK ACTIONS (Bottom Center) =====
local quickActions = Instance.new("Frame")
quickActions.Name = "QuickActions"
quickActions.Size = UDim2.new(0, 400, 0, 60)
quickActions.Position = UDim2.new(0.5, -200, 1, -70)
quickActions.BackgroundTransparency = 1
quickActions.Parent = screenGui

local actionsLayout = Instance.new("UIListLayout")
actionsLayout.FillDirection = Enum.FillDirection.Horizontal
actionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
actionsLayout.Padding = UDim.new(0, 10)
actionsLayout.Parent = quickActions

-- Hub button
local hubButton = Instance.new("TextButton")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 120, 0, 50)
hubButton.BackgroundColor3 = Color3.fromRGB(75, 100, 200)
hubButton.BorderSizePixel = 0
hubButton.Text = "🏠 HUB"
hubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hubButton.TextSize = 18
hubButton.Font = Enum.Font.GothamBold
hubButton.Parent = quickActions

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 10)
hubCorner.Parent = hubButton

-- Shop button
local shopButton = Instance.new("TextButton")
shopButton.Name = "ShopButton"
shopButton.Size = UDim2.new(0, 120, 0, 50)
shopButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
shopButton.BorderSizePixel = 0
shopButton.Text = "🛒 SHOP"
shopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
shopButton.TextSize = 18
shopButton.Font = Enum.Font.GothamBold
shopButton.Parent = quickActions

local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 10)
shopCorner.Parent = shopButton

-- Zones button
local zonesButton = Instance.new("TextButton")
zonesButton.Name = "ZonesButton"
zonesButton.Size = UDim2.new(0, 120, 0, 50)
zonesButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
zonesButton.BorderSizePixel = 0
zonesButton.Text = "🌍 ZONES"
zonesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
zonesButton.TextSize = 18
zonesButton.Font = Enum.Font.GothamBold
zonesButton.Parent = quickActions

local zonesCorner = Instance.new("UICorner")
zonesCorner.CornerRadius = UDim.new(0, 10)
zonesCorner.Parent = zonesButton

-- ===== ADMIN PANEL (F1 - Hidden by default) =====
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

-- Toggle admin panel with F1
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F1 then
        adminPanel.Visible = not adminPanel.Visible
    end
end)

-- Store reference for client script
_G.GameUI = {
    tpValue = tpValue,
    stealsLabel = stealsLabel,
    rateLabel = rateLabel,
    zoneLabel = zoneLabel,
    dayNightFrame = dayNightFrame,
    dayNightText = dayNightText,
    eventIcon = eventIcon,
    eventTooltip = eventTooltip,
    tooltipTitle = tooltipTitle,
    tooltipMultiplier = tooltipMultiplier,
    tooltipDuration = tooltipDuration,
    hubButton = hubButton,
    shopButton = shopButton,
    zonesButton = zonesButton,
    adminPanel = adminPanel,
    commandInput = commandInput,
    outputScroll = outputScroll,
}

print("[MainUI] Professional sidebar UI created! 🎨")
