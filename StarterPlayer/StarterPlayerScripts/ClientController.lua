--[[
    ClientController.lua
    SCRIPT TYPE: LocalScript (NOT Script or ModuleScript)
    LOCATION: StarterPlayer/StarterPlayerScripts/ClientController

    Handles client-side logic and UI updates
    Listens to RemoteEvents from server
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local GameData = ReplicatedStorage:WaitForChild("GameData")
local EventImages = require(GameData:WaitForChild("EventImages"))

-- Wait for UI to load
repeat task.wait() until _G.GameUI

local UI = _G.GameUI

-- ===== SCORE UPDATE =====
local UpdateScoreEvent = RemoteEvents:WaitForChild("UpdateScore")
UpdateScoreEvent.OnClientEvent:Connect(function(newScore)
    UI.scoreValue.Text = string.format("%d", math.floor(newScore))
end)

-- ===== DAY/NIGHT UPDATE =====
local DayNightEvent = RemoteEvents:WaitForChild("DayNight")
local TweenService = game:GetService("TweenService")

DayNightEvent.OnClientEvent:Connect(function(isDay)
    if UI.dayNightText then
        if isDay then
            UI.dayNightText.Text = "☀️ DAY"
        else
            UI.dayNightText.Text = "🌙 NIGHT (2x)"
        end
    end

    if UI.dayNightLabel then
        if isDay then
            TweenService:Create(UI.dayNightLabel, TweenInfo.new(2, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Color3.fromRGB(255, 200, 50)
            }):Play()
        else
            TweenService:Create(UI.dayNightLabel, TweenInfo.new(2, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 150)
            }):Play()
        end
    end
end)

-- ===== EVENT NOTIFICATION =====
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")
local currentEventName = nil

EventNotificationEvent.OnClientEvent:Connect(function(message, duration, eventName, multiplier)
    if message ~= "" then
        -- Store current event data
        currentEventName = eventName

        -- Show event icon with appropriate image
        local eventIcon = UI.eventIcon
        local eventTooltip = UI.eventTooltip

        if eventName and EventImages[eventName] and EventImages[eventName] ~= "" then
            eventIcon.Image = EventImages[eventName]
            eventIcon.Visible = true

            -- Update tooltip
            eventTooltip:FindFirstChild("Title").Text = eventName

            -- Set multiplier text based on event type
            local multiplierText = ""
            if eventName == "Score Surge" then
                multiplierText = string.format("⚡ %dx Multiplier", multiplier or 3)
            elseif eventName == "Bed Chaos" then
                multiplierText = "🛏️ All beds randomized!"
            elseif eventName == "Theft Frenzy" then
                multiplierText = "💰 Tool cooldown halved"
            elseif eventName == "Golden Hour" then
                multiplierText = "✨ Night bonus active"
            elseif eventName == "Shield Storm" then
                multiplierText = "🛡️ Theft protection"
            elseif eventName == "Score Drain" then
                multiplierText = "💀 5% score lost"
            end
            eventTooltip:FindFirstChild("Multiplier").Text = multiplierText
            eventTooltip:FindFirstChild("Duration").Text = string.format("⏱️ %ds remaining", duration or 0)
        end

        if duration > 0 then
            task.delay(duration, function()
                if currentEventName == eventName then
                    eventIcon.Visible = false
                    eventTooltip.Visible = false
                    currentEventName = nil
                end
            end)
        end
    else
        -- Hide event icon when event ends
        UI.eventIcon.Visible = false
        UI.eventTooltip.Visible = false
        currentEventName = nil
    end
end)

-- ===== SLEEP STATE =====
local SleepEvent = RemoteEvents:WaitForChild("Sleep")
SleepEvent.OnClientEvent:Connect(function(isSleeping, mutationType)
    if isSleeping then
        print("[Client] Started sleeping in", mutationType, "bed")
    else
        print("[Client] Stopped sleeping")
    end
end)

-- ===== UPGRADES =====
local PurchaseUpgradeEvent = RemoteEvents:WaitForChild("PurchaseUpgrade")
local UpdateUpgradesEvent = RemoteEvents:WaitForChild("UpdateUpgrades")

-- Config (copied from server for cost calculations)
local UpgradesConfig = {
    SleepEfficiency = {MaxLevel = 10, BaseCost = 100, CostMultiplier = 2.5},
    TheftProtection = {MaxLevel = 10, BaseCost = 200, CostMultiplier = 2.5},
    ToolCapacity = {MaxLevel = 5, BaseCost = 300, CostMultiplier = 3},
    ScoreMultiplier = {MaxLevel = 10, BaseCost = 500, CostMultiplier = 3},
}

local currentUpgrades = {
    SleepEfficiency = 0,
    TheftProtection = 0,
    ToolCapacity = 0,
    ScoreMultiplier = 0,
}

-- Update upgrade buttons
local function UpdateUpgradeButtons()
    for upgradeName, button in pairs(UI.upgradeButtons) do
        local config = UpgradesConfig[upgradeName]
        local currentLevel = currentUpgrades[upgradeName]

        local levelLabel = button:FindFirstChild("LevelLabel")
        local costLabel = button:FindFirstChild("CostLabel")

        if levelLabel then
            levelLabel.Text = string.format("Level: %d/%d", currentLevel, config.MaxLevel)
        end

        if costLabel then
            if currentLevel >= config.MaxLevel then
                costLabel.Text = "MAX LEVEL"
                costLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                button.BackgroundColor3 = Color3.fromRGB(80, 80, 0)
            else
                local cost = math.floor(config.BaseCost * (config.CostMultiplier ^ currentLevel))
                costLabel.Text = string.format("Cost: %d TP", cost)
                costLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
        end
    end
end

-- Handle upgrade purchases
if UI.upgradeButtons then
    for upgradeName, button in pairs(UI.upgradeButtons) do
        button.MouseButton1Click:Connect(function()
            local config = UpgradesConfig[upgradeName]
            if currentUpgrades[upgradeName] < config.MaxLevel then
                PurchaseUpgradeEvent:FireServer(upgradeName)
            end
        end)
    end
end

UpdateUpgradesEvent.OnClientEvent:Connect(function(upgrades)
    currentUpgrades = upgrades
    UpdateUpgradeButtons()
end)

UpdateUpgradeButtons()

-- ===== TOOL SHOP =====
local PurchaseToolEvent = RemoteEvents:WaitForChild("PurchaseTool")

UI.toolShopButton.MouseButton1Click:Connect(function()
    PurchaseToolEvent:FireServer()
end)

-- ===== ADMIN PANEL =====
local AdminCommandEvent = RemoteEvents:WaitForChild("AdminCommand")

-- Toggle admin panel with F1
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F1 then
        UI.adminPanel.Visible = not UI.adminPanel.Visible
    end
end)

-- Handle command input
UI.commandInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and UI.commandInput.Text ~= "" then
        local command = UI.commandInput.Text
        AdminCommandEvent:FireServer(command)
        UI.commandInput.Text = ""
    end
end)

-- Display command output
AdminCommandEvent.OnClientEvent:Connect(function(result)
    local outputLabel = Instance.new("TextLabel")
    outputLabel.Size = UDim2.new(1, -10, 0, 0)
    outputLabel.BackgroundTransparency = 1
    outputLabel.Text = "> " .. result
    outputLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    outputLabel.TextSize = 14
    outputLabel.Font = Enum.Font.Code
    outputLabel.TextXAlignment = Enum.TextXAlignment.Left
    outputLabel.TextYAlignment = Enum.TextYAlignment.Top
    outputLabel.TextWrapped = true
    outputLabel.Parent = UI.outputScroll

    -- Auto-size
    outputLabel.Size = UDim2.new(1, -10, 0, outputLabel.TextBounds.Y + 5)

    -- Update canvas size
    UI.outputScroll.CanvasSize = UDim2.new(0, 0, 0, UI.outputScroll.UIListLayout.AbsoluteContentSize.Y + 10)
    UI.outputScroll.CanvasPosition = Vector2.new(0, UI.outputScroll.CanvasSize.Y.Offset)
end)

print("[ClientController] Client controller initialized!")
