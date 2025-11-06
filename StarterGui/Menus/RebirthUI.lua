--[[
    RebirthUI.lua
    SCRIPT TYPE: LocalScript
    LOCATION: StarterGui/Menus/RebirthUI

    Epic full-screen rebirth menu with animations
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local GameData = ReplicatedStorage:WaitForChild("GameData")

local RebirthConfig = require(GameData:WaitForChild("RebirthConfig"))

-- Wait for PlayerGui
local playerGui = player:WaitForChild("PlayerGui")

-- Create Rebirth UI
local rebirthGui = Instance.new("ScreenGui")
rebirthGui.Name = "RebirthUI"
rebirthGui.ResetOnSpawn = false
rebirthGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
rebirthGui.DisplayOrder = 100
rebirthGui.Enabled = false
rebirthGui.Parent = playerGui

-- Full screen dark overlay
local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.3
overlay.BorderSizePixel = 0
overlay.Parent = rebirthGui

-- Main rebirth frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 450)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = rebirthGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 215, 0)
mainStroke.Thickness = 3
mainStroke.Parent = mainFrame

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 40), Color3.fromRGB(15, 15, 20))
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -40, 0, 60)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "P REBIRTH P"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.TextSize = 42
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextStrokeTransparency = 0
titleLabel.Parent = mainFrame

-- Current level display
local currentLevelLabel = Instance.new("TextLabel")
currentLevelLabel.Name = "CurrentLevel"
currentLevelLabel.Size = UDim2.new(1, -40, 0, 40)
currentLevelLabel.Position = UDim2.new(0, 20, 0, 90)
currentLevelLabel.BackgroundTransparency = 1
currentLevelLabel.Text = "Current Rebirth: 0"
currentLevelLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
currentLevelLabel.TextSize = 20
currentLevelLabel.Font = Enum.Font.Gotham
currentLevelLabel.Parent = mainFrame

-- Current multiplier display
local currentMultiplierLabel = Instance.new("TextLabel")
currentMultiplierLabel.Name = "CurrentMultiplier"
currentMultiplierLabel.Size = UDim2.new(1, -40, 0, 30)
currentMultiplierLabel.Position = UDim2.new(0, 20, 0, 130)
currentMultiplierLabel.BackgroundTransparency = 1
currentMultiplierLabel.Text = "Current Multiplier: 1x"
currentMultiplierLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
currentMultiplierLabel.TextSize = 18
currentMultiplierLabel.Font = Enum.Font.GothamBold
currentMultiplierLabel.Parent = mainFrame

-- Cost display
local costLabel = Instance.new("TextLabel")
costLabel.Name = "Cost"
costLabel.Size = UDim2.new(1, -40, 0, 50)
costLabel.Position = UDim2.new(0, 20, 0, 180)
costLabel.BackgroundTransparency = 1
costLabel.Text = "Cost: 10,000 TP"
costLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
costLabel.TextSize = 24
costLabel.Font = Enum.Font.Gotham
costLabel.Parent = mainFrame

-- Next level display
local nextLevelLabel = Instance.new("TextLabel")
nextLevelLabel.Name = "NextLevel"
nextLevelLabel.Size = UDim2.new(1, -40, 0, 40)
nextLevelLabel.Position = UDim2.new(0, 20, 0, 240)
nextLevelLabel.BackgroundTransparency = 1
nextLevelLabel.Text = "’ Rebirth Level 1"
nextLevelLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
nextLevelLabel.TextSize = 22
nextLevelLabel.Font = Enum.Font.GothamBold
nextLevelLabel.Parent = mainFrame

-- Next multiplier display
local nextMultiplierLabel = Instance.new("TextLabel")
nextMultiplierLabel.Name = "NextMultiplier"
nextMultiplierLabel.Size = UDim2.new(1, -40, 0, 30)
nextMultiplierLabel.Position = UDim2.new(0, 20, 0, 280)
nextMultiplierLabel.BackgroundTransparency = 1
nextMultiplierLabel.Text = "New Multiplier: 2x"
nextMultiplierLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
nextMultiplierLabel.TextSize = 20
nextMultiplierLabel.Font = Enum.Font.GothamBold
nextMultiplierLabel.Parent = mainFrame

-- Warning label
local warningLabel = Instance.new("TextLabel")
warningLabel.Name = "Warning"
warningLabel.Size = UDim2.new(1, -40, 0, 25)
warningLabel.Position = UDim2.new(0, 20, 0, 320)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "  Resets Time Points to 0 | Keeps Upgrades"
warningLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
warningLabel.TextSize = 14
warningLabel.Font = Enum.Font.Gotham
warningLabel.Parent = mainFrame

-- Rebirth button
local rebirthButton = Instance.new("TextButton")
rebirthButton.Name = "RebirthButton"
rebirthButton.Size = UDim2.new(0, 250, 0, 60)
rebirthButton.Position = UDim2.new(0.5, -125, 1, -80)
rebirthButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
rebirthButton.BorderSizePixel = 0
rebirthButton.Text = "< REBIRTH <"
rebirthButton.TextColor3 = Color3.fromRGB(0, 0, 0)
rebirthButton.TextSize = 24
rebirthButton.Font = Enum.Font.GothamBold
rebirthButton.Parent = mainFrame

local rebirthCorner = Instance.new("UICorner")
rebirthCorner.CornerRadius = UDim.new(0, 10)
rebirthCorner.Parent = rebirthButton

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = ""
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Player data
local currentRebirthLevel = 0
local currentTP = 0

-- Update UI data
local function UpdateRebirthUI()
    local nextLevel = currentRebirthLevel + 1
    local rebirthData = RebirthConfig.GetRebirthData(nextLevel)

    currentLevelLabel.Text = string.format("Current Rebirth: %d", currentRebirthLevel)

    local currentMult = RebirthConfig.GetMultiplier(currentRebirthLevel)
    currentMultiplierLabel.Text = string.format("Current Multiplier: %dx", currentMult)

    if rebirthData then
        local cost = rebirthData.Cost
        costLabel.Text = string.format("Cost: %s TP", tostring(cost):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
        nextLevelLabel.Text = string.format("’ Rebirth Level %d", nextLevel)
        nextMultiplierLabel.Text = string.format("New Multiplier: %dx", rebirthData.Multiplier)

        -- Check if can afford
        local canAfford = currentTP >= cost
        rebirthButton.BackgroundColor3 = canAfford and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 100)
        rebirthButton.TextColor3 = canAfford and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 150, 150)
    else
        costLabel.Text = "MAX LEVEL REACHED!"
        nextLevelLabel.Text = "You are at maximum rebirth!"
        nextMultiplierLabel.Text = ""
        rebirthButton.Visible = false
    end
end

-- Open rebirth menu
local function OpenRebirthMenu()
    rebirthGui.Enabled = true
    UpdateRebirthUI()

    -- Animate entrance
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
        Size = UDim2.new(0, 600, 0, 450),
        Position = UDim2.new(0.5, -300, 0.5, -225)
    }):Play()
end

-- Close rebirth menu
local function CloseRebirthMenu()
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()

    task.wait(0.3)
    rebirthGui.Enabled = false
end

-- Rebirth button clicked
rebirthButton.MouseButton1Click:Connect(function()
    local RebirthEvent = RemoteEvents:FindFirstChild("Rebirth")
    if RebirthEvent then
        RebirthEvent:FireServer()
        CloseRebirthMenu()
    end
end)

-- Close button clicked
closeButton.MouseButton1Click:Connect(function()
    CloseRebirthMenu()
end)

-- Listen for score updates
local UpdateScoreEvent = RemoteEvents:WaitForChild("UpdateScore")
UpdateScoreEvent.OnClientEvent:Connect(function(newTP)
    currentTP = newTP
    if rebirthGui.Enabled then
        UpdateRebirthUI()
    end
end)

-- Listen for rebirth level changes (through UpdateScore event initially)
-- TODO: Add dedicated rebirth level update event if needed

-- Hotkey to open (R key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.R then
        if not rebirthGui.Enabled then
            OpenRebirthMenu()
        else
            CloseRebirthMenu()
        end
    end
end)

-- Expose global function for opening from other scripts
_G.OpenRebirthMenu = OpenRebirthMenu
_G.UpdateRebirthData = function(rebirthLevel, timePoints)
    currentRebirthLevel = rebirthLevel
    currentTP = timePoints
    UpdateRebirthUI()
end

print("[RebirthUI] Loaded - Press R to open Rebirth menu")
