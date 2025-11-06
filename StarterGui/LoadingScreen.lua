--[[
    LoadingScreen.lua
    SCRIPT TYPE: LocalScript
    LOCATION: StarterGui/LoadingScreen

    Shows loading screen during game initialization
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Create loading screen GUI
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loadingGui.DisplayOrder = 1000  -- Make sure it's on top
loadingGui.Parent = player:WaitForChild("PlayerGui")

-- Black background
local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
background.BorderSizePixel = 0
background.Parent = loadingGui

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 600, 0, 80)
titleLabel.Position = UDim2.new(0.5, -300, 0.35, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SLEEP TO GET TIME"
titleLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
titleLabel.TextSize = 48
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextStrokeTransparency = 0
titleLabel.Parent = background

-- Loading text
local loadingLabel = Instance.new("TextLabel")
loadingLabel.Name = "LoadingLabel"
loadingLabel.Size = UDim2.new(0, 400, 0, 40)
loadingLabel.Position = UDim2.new(0.5, -200, 0.5, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "Generating zones..."
loadingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingLabel.TextSize = 24
loadingLabel.Font = Enum.Font.Gotham
loadingLabel.Parent = background

-- Progress bar background
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0, 500, 0, 20)
progressBg.Position = UDim2.new(0.5, -250, 0.55, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
progressBg.BorderSizePixel = 0
progressBg.Parent = background

local progressBgCorner = Instance.new("UICorner")
progressBgCorner.CornerRadius = UDim.new(0, 10)
progressBgCorner.Parent = progressBg

-- Progress bar fill
local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBg

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 10)
progressBarCorner.Parent = progressBar

-- Tip text
local tipLabel = Instance.new("TextLabel")
tipLabel.Size = UDim2.new(0, 700, 0, 60)
tipLabel.Position = UDim2.new(0.5, -350, 0.65, 0)
tipLabel.BackgroundTransparency = 1
tipLabel.Text = "TIP: Sleep during night for 2x earnings!"
tipLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
tipLabel.TextSize = 18
tipLabel.Font = Enum.Font.Gotham
tipLabel.TextWrapped = true
tipLabel.Parent = background

-- Freeze character during loading
if player.Character then
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
end

-- Listen for game ready signal
local gameReadyEvent = Instance.new("RemoteEvent")
gameReadyEvent.Name = "GameReady"
gameReadyEvent.Parent = ReplicatedStorage

-- Wait for either the GameReady event or a timeout
local loadingComplete = false
local startTime = tick()

-- Animate progress bar
task.spawn(function()
    while not loadingComplete do
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / 10, 0.95)  -- Cap at 95% until actually ready

        TweenService:Create(progressBar, TweenInfo.new(0.3), {
            Size = UDim2.new(progress, 0, 1, 0)
        }):Play()

        task.wait(0.3)
    end

    -- Fill to 100%
    TweenService:Create(progressBar, TweenInfo.new(0.5), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
end)

-- Wait for game ready (or timeout after 15 seconds)
-- Function to complete loading
local function CompleteLoading()
    if loadingComplete then
        return
    end

    loadingComplete = true
    loadingLabel.Text = "Ready!"

    task.wait(0.5)

    -- Unfreeze character
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end

    -- Fade out
    TweenService:Create(background, TweenInfo.new(1), {
        BackgroundTransparency = 1
    }):Play()

    for _, child in ipairs(background:GetChildren()) do
        if child:IsA("GuiObject") then
            TweenService:Create(child, TweenInfo.new(1), {
                TextTransparency = 1
            }):Play()
        end
    end

    task.wait(1)
    if loadingGui then
        loadingGui:Destroy()
    end
    if readyConnection then
        readyConnection:Disconnect()
    end
end

-- Listen for game ready event
local readyConnection
readyConnection = gameReadyEvent.OnClientEvent:Connect(function()
    CompleteLoading()
end)

-- Timeout fallback (force complete after 15 seconds)
task.delay(15, function()
    if not loadingComplete then
        warn("[LoadingScreen] Timeout - forcing load complete")
        CompleteLoading()
    end
end)

print("[LoadingScreen] Loading screen active")
