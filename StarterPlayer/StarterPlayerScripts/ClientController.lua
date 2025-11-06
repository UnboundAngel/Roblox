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
    UI.tpValue.Text = string.format("%d", math.floor(newScore))
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

    if UI.dayNightFrame then
        if isDay then
            TweenService:Create(UI.dayNightFrame, TweenInfo.new(2, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Color3.fromRGB(255, 200, 50)
            }):Play()
        else
            TweenService:Create(UI.dayNightFrame, TweenInfo.new(2, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 150)
            }):Play()
        end
    end
end)

-- ===== EVENT NOTIFICATION =====
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")
local currentEventName = nil

EventNotificationEvent.OnClientEvent:Connect(function(message, duration, eventName, multiplier)
    if message ~= "" and eventName then
        -- Store current event data
        currentEventName = eventName

        -- Show event frame
        if UI.eventFrame then
            UI.eventFrame.Visible = true

            -- Update event icon if available
            if UI.eventIcon and EventImages[eventName] and EventImages[eventName] ~= "" then
                UI.eventIcon.Image = EventImages[eventName]
            end

            -- Update title
            if UI.eventTitle then
                UI.eventTitle.Text = eventName
            end

            -- Update timer
            if UI.eventTimer and duration then
                UI.eventTimer.Text = string.format("⏱️ %ds", duration)

                -- Start countdown
                task.spawn(function()
                    for i = duration, 0, -1 do
                        if currentEventName ~= eventName then
                            break
                        end
                        if UI.eventTimer then
                            UI.eventTimer.Text = string.format("⏱️ %ds", i)
                        end
                        task.wait(1)
                    end
                end)
            end

            -- Hide after duration
            if duration and duration > 0 then
                task.delay(duration, function()
                    if currentEventName == eventName and UI.eventFrame then
                        UI.eventFrame.Visible = false
                        currentEventName = nil
                    end
                end)
            end
        end
    else
        -- Hide event frame
        if UI.eventFrame then
            UI.eventFrame.Visible = false
        end
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

-- ===== ADMIN PANEL =====
local AdminCommandEvent = RemoteEvents:WaitForChild("AdminCommand")

-- Toggle admin panel with F5
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F5 then
        if UI.adminPanel then
            UI.adminPanel.Visible = not UI.adminPanel.Visible
        end
    end
end)

-- Handle command input
if UI.commandInput then
    UI.commandInput.FocusLost:Connect(function(enterPressed)
        if enterPressed and UI.commandInput.Text ~= "" then
            local command = UI.commandInput.Text
            AdminCommandEvent:FireServer(command)
            UI.commandInput.Text = ""
        end
    end)
end

-- Display command output
AdminCommandEvent.OnClientEvent:Connect(function(result)
    if not UI.outputScroll then
        return
    end

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
    local layout = UI.outputScroll:FindFirstChildOfClass("UIListLayout")
    if layout then
        UI.outputScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        UI.outputScroll.CanvasPosition = Vector2.new(0, UI.outputScroll.CanvasSize.Y.Offset)
    end
end)

print("[ClientController] Client controller initialized!")
