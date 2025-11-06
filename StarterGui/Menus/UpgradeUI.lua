--[[
    UpgradeUI.lua
    SCRIPT TYPE: LocalScript
    LOCATION: StarterGui/Menus/UpgradeUI

    Hub upgrade shop interface
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local GameData = ReplicatedStorage:WaitForChild("GameData")

local UpgradeConfig = require(GameData:WaitForChild("UpgradeConfig"))

local playerGui = player:WaitForChild("PlayerGui")

-- Create Upgrade UI
local upgradeGui = Instance.new("ScreenGui")
upgradeGui.Name = "UpgradeUI"
upgradeGui.ResetOnSpawn = false
upgradeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
upgradeGui.DisplayOrder = 90
upgradeGui.Enabled = false
upgradeGui.Parent = playerGui

-- Overlay
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.4
overlay.BorderSizePixel = 0
overlay.Parent = upgradeGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 500)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = upgradeGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 15)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "P Hub Upgrades"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
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

-- Upgrades container
local upgradesContainer = Instance.new("ScrollingFrame")
upgradesContainer.Size = UDim2.new(1, -40, 1, -90)
upgradesContainer.Position = UDim2.new(0, 20, 0, 70)
upgradesContainer.BackgroundTransparency = 1
upgradesContainer.BorderSizePixel = 0
upgradesContainer.ScrollBarThickness = 6
upgradesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
upgradesContainer.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = upgradesContainer

-- Auto-resize canvas
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    upgradesContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- Player data
local playerUpgrades = {
    AutoSleeper = 0,
    OfflineGeneration = 0,
    TheftShield = 0,
    SpeedBoost = 0,
}
local currentTP = 0

-- Create upgrade card
local function CreateUpgradeCard(upgradeName, upgradeData, layoutOrder)
    local card = Instance.new("Frame")
    card.Name = upgradeName
    card.Size = UDim2.new(1, 0, 0, 120)
    card.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    card.BorderSizePixel = 0
    card.LayoutOrder = layoutOrder
    card.Parent = upgradesContainer

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    -- Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -120, 0, 30)
    nameLabel.Position = UDim2.new(0, 15, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = upgradeData.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    nameLabel.TextSize = 20
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = card

    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -120, 0, 20)
    descLabel.Position = UDim2.new(0, 15, 0, 40)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = upgradeData.Description
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.TextSize = 14
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = card

    -- Level
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.Size = UDim2.new(1, -120, 0, 25)
    levelLabel.Position = UDim2.new(0, 15, 0, 65)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = string.format("Level: 0/%d", upgradeData.MaxLevel)
    levelLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    levelLabel.TextSize = 16
    levelLabel.Font = Enum.Font.Gotham
    levelLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelLabel.Parent = card

    -- Cost
    local costLabel = Instance.new("TextLabel")
    costLabel.Name = "CostLabel"
    costLabel.Size = UDim2.new(1, -120, 0, 20)
    costLabel.Position = UDim2.new(0, 15, 0, 92)
    costLabel.BackgroundTransparency = 1
    costLabel.Text = "Cost: 0 TP"
    costLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    costLabel.TextSize = 14
    costLabel.Font = Enum.Font.Gotham
    costLabel.TextXAlignment = Enum.TextXAlignment.Left
    costLabel.Parent = card

    -- Buy button
    local buyButton = Instance.new("TextButton")
    buyButton.Name = "BuyButton"
    buyButton.Size = UDim2.new(0, 100, 0, 45)
    buyButton.Position = UDim2.new(1, -110, 0.5, -22.5)
    buyButton.BackgroundColor3 = Color3.fromRGB(75, 175, 75)
    buyButton.BorderSizePixel = 0
    buyButton.Text = "UPGRADE"
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.TextSize = 16
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Parent = card

    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 8)
    buyCorner.Parent = buyButton

    -- Button click
    buyButton.MouseButton1Click:Connect(function()
        local PurchaseHubUpgradeEvent = RemoteEvents:FindFirstChild("PurchaseHubUpgrade")
        if PurchaseHubUpgradeEvent then
            PurchaseHubUpgradeEvent:FireServer(upgradeName)
        end
    end)

    return card
end

-- Update upgrade cards
local function UpdateUpgradeCards()
    for upgradeName, level in pairs(playerUpgrades) do
        local card = upgradesContainer:FindFirstChild(upgradeName)
        if card then
            local upgradeData = UpgradeConfig[upgradeName]

            local levelLabel = card:FindFirstChild("LevelLabel")
            local costLabel = card:FindFirstChild("CostLabel")
            local buyButton = card:FindFirstChild("BuyButton")

            if levelLabel then
                levelLabel.Text = string.format("Level: %d/%d", level, upgradeData.MaxLevel)
            end

            if level >= upgradeData.MaxLevel then
                if costLabel then
                    costLabel.Text = "MAX LEVEL"
                    costLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                end
                if buyButton then
                    buyButton.Visible = false
                end
            else
                local cost = UpgradeConfig.CalculateCost(upgradeName, level)
                if costLabel and cost then
                    costLabel.Text = string.format("Cost: %s TP", tostring(cost):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
                end

                if buyButton then
                    buyButton.Visible = true
                    local canAfford = cost and currentTP >= cost
                    buyButton.BackgroundColor3 = canAfford and Color3.fromRGB(75, 175, 75) or Color3.fromRGB(100, 100, 100)
                end
            end
        end
    end
end

-- Create upgrade cards
CreateUpgradeCard("AutoSleeper", UpgradeConfig.AutoSleeper, 1)
CreateUpgradeCard("OfflineGeneration", UpgradeConfig.OfflineGeneration, 2)
CreateUpgradeCard("TheftShield", UpgradeConfig.TheftShield, 3)
CreateUpgradeCard("SpeedBoost", UpgradeConfig.SpeedBoost, 4)

-- Open upgrade menu
local function OpenUpgradeMenu()
    upgradeGui.Enabled = true
    UpdateUpgradeCards()

    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 700, 0, 500)
    }):Play()
end

-- Close upgrade menu
local function CloseUpgradeMenu()
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.wait(0.3)
    upgradeGui.Enabled = false
end

closeButton.MouseButton1Click:Connect(function()
    CloseUpgradeMenu()
end)

-- Listen for open event
local OpenUpgradeUIEvent = RemoteEvents:FindFirstChild("OpenUpgradeUI")
if OpenUpgradeUIEvent then
    OpenUpgradeUIEvent.OnClientEvent:Connect(function()
        OpenUpgradeMenu()
    end)
end

-- Listen for score updates
local UpdateScoreEvent = RemoteEvents:WaitForChild("UpdateScore")
UpdateScoreEvent.OnClientEvent:Connect(function(newTP)
    currentTP = newTP
    if upgradeGui.Enabled then
        UpdateUpgradeCards()
    end
end)

-- Expose global
_G.OpenUpgradeMenu = OpenUpgradeMenu
_G.UpdatePlayerUpgrades = function(upgrades)
    if upgrades then
        playerUpgrades = upgrades
        UpdateUpgradeCards()
    end
end

print("[UpgradeUI] Loaded")
