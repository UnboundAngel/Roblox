--[[
    MainUI.lua
    SCRIPT TYPE: LocalScript (NOT Script or ModuleScript)
    LOCATION: StarterGui/MainUI

    Minimal UI matching reference game style
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

-- ===== TOP CENTER: DAY/NIGHT TIME =====
local dayNightFrame = Instance.new("Frame")
dayNightFrame.Name = "DayNight"
dayNightFrame.Size = UDim2.new(0, 120, 0, 40)
dayNightFrame.Position = UDim2.new(0.5, -60, 0, 10)
dayNightFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
dayNightFrame.BorderSizePixel = 0
dayNightFrame.Parent = screenGui

local dayNightCorner = Instance.new("UICorner")
dayNightCorner.CornerRadius = UDim.new(0, 20)
dayNightCorner.Parent = dayNightFrame

local dayNightText = Instance.new("TextLabel")
dayNightText.Name = "Text"
dayNightText.Size = UDim2.new(1, 0, 1, 0)
dayNightText.BackgroundTransparency = 1
dayNightText.Text = "☀️ DAY"
dayNightText.TextColor3 = Color3.fromRGB(255, 255, 255)
dayNightText.TextSize = 18
dayNightText.Font = Enum.Font.GothamBold
dayNightText.TextStrokeTransparency = 0.5
dayNightText.Parent = dayNightFrame

-- ===== TOP LEFT: CURRENCY =====
local currencyFrame = Instance.new("Frame")
currencyFrame.Name = "Currency"
currencyFrame.Size = UDim2.new(0, 150, 0, 40)
currencyFrame.Position = UDim2.new(0, 10, 0, 10)
currencyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
currencyFrame.BorderSizePixel = 0
currencyFrame.Parent = screenGui

local currencyCorner = Instance.new("UICorner")
currencyCorner.CornerRadius = UDim.new(0, 20)
currencyCorner.Parent = currencyFrame

local currencyIcon = Instance.new("TextLabel")
currencyIcon.Size = UDim2.new(0, 30, 0, 30)
currencyIcon.Position = UDim2.new(0, 5, 0, 5)
currencyIcon.BackgroundTransparency = 1
currencyIcon.Text = "⭐"
currencyIcon.TextSize = 24
currencyIcon.Parent = currencyFrame

local tpValue = Instance.new("TextLabel")
tpValue.Name = "TPValue"
tpValue.Size = UDim2.new(1, -40, 1, 0)
tpValue.Position = UDim2.new(0, 40, 0, 0)
tpValue.BackgroundTransparency = 1
tpValue.Text = "0"
tpValue.TextColor3 = Color3.fromRGB(255, 255, 255)
tpValue.TextSize = 18
tpValue.Font = Enum.Font.GothamBold
tpValue.TextXAlignment = Enum.TextXAlignment.Left
tpValue.Parent = currencyFrame

-- ===== LEFT SIDE: ACTION BUTTONS =====
local leftButtons = Instance.new("Frame")
leftButtons.Name = "LeftButtons"
leftButtons.Size = UDim2.new(0, 60, 0, 300)
leftButtons.Position = UDim2.new(0, 10, 0, 60)
leftButtons.BackgroundTransparency = 1
leftButtons.Parent = screenGui

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Vertical
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
buttonLayout.Padding = UDim.new(0, 10)
buttonLayout.Parent = leftButtons

-- Function to create circular button
local function CreateCircleButton(name, icon, color)
    local button = Instance.new("ImageButton")
    button.Name = name
    button.Size = UDim2.new(0, 50, 0, 50)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Parent = leftButtons

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 24
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = button

    return button
end

local hubButton = CreateCircleButton("HubButton", "🏠", Color3.fromRGB(75, 100, 200))
local zonesButton = CreateCircleButton("ZonesButton", "🌍", Color3.fromRGB(100, 200, 100))

-- ===== BOTTOM RIGHT: EVENT NOTIFICATION =====
local eventFrame = Instance.new("Frame")
eventFrame.Name = "EventFrame"
eventFrame.Size = UDim2.new(0, 250, 0, 80)
eventFrame.Position = UDim2.new(1, -260, 1, -90)
eventFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
eventFrame.BorderSizePixel = 0
eventFrame.Visible = false
eventFrame.Parent = screenGui

local eventCorner = Instance.new("UICorner")
eventCorner.CornerRadius = UDim.new(0, 12)
eventCorner.Parent = eventFrame

local eventStroke = Instance.new("UIStroke")
eventStroke.Color = Color3.fromRGB(255, 200, 0)
eventStroke.Thickness = 3
eventStroke.Parent = eventFrame

local eventIcon = Instance.new("ImageLabel")
eventIcon.Name = "Icon"
eventIcon.Size = UDim2.new(0, 60, 0, 60)
eventIcon.Position = UDim2.new(0, 10, 0, 10)
eventIcon.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
eventIcon.BorderSizePixel = 0
eventIcon.ScaleType = Enum.ScaleType.Fit
eventIcon.Parent = eventFrame

local eventIconCorner = Instance.new("UICorner")
eventIconCorner.CornerRadius = UDim.new(0, 10)
eventIconCorner.Parent = eventIcon

local eventTitle = Instance.new("TextLabel")
eventTitle.Name = "Title"
eventTitle.Size = UDim2.new(1, -80, 0, 30)
eventTitle.Position = UDim2.new(0, 75, 0, 10)
eventTitle.BackgroundTransparency = 1
eventTitle.Text = "Event Name"
eventTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
eventTitle.TextSize = 16
eventTitle.Font = Enum.Font.GothamBold
eventTitle.TextXAlignment = Enum.TextXAlignment.Left
eventTitle.Parent = eventFrame

local eventTimer = Instance.new("TextLabel")
eventTimer.Name = "Timer"
eventTimer.Size = UDim2.new(1, -80, 0, 20)
eventTimer.Position = UDim2.new(0, 75, 0, 40)
eventTimer.BackgroundTransparency = 1
eventTimer.Text = "⏱️ 60s"
eventTimer.TextColor3 = Color3.fromRGB(200, 200, 200)
eventTimer.TextSize = 14
eventTimer.Font = Enum.Font.Gotham
eventTimer.TextXAlignment = Enum.TextXAlignment.Left
eventTimer.Parent = eventFrame

-- ===== ADMIN PANEL (F5 - Hidden by default) =====
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
adminTitleText.Text = "ADMIN PANEL"
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
    tpValue = tpValue,
    dayNightFrame = dayNightFrame,
    dayNightText = dayNightText,
    dayNightLabel = dayNightFrame,  -- Alias for compatibility
    eventFrame = eventFrame,
    eventIcon = eventIcon,
    eventTitle = eventTitle,
    eventTimer = eventTimer,
    hubButton = hubButton,
    zonesButton = zonesButton,
    adminPanel = adminPanel,
    commandInput = commandInput,
    outputScroll = outputScroll,
}

print("[MainUI] Minimal UI created!")
