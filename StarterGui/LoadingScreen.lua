--[[
    LoadingScreen.lua
    SCRIPT TYPE: LocalScript (NOT Script or ModuleScript)
    LOCATION: StarterGui/LoadingScreen

    Clean loading screen that actually works fast
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create loading GUI
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loadingGui.IgnoreGuiInset = true
loadingGui.Parent = playerGui

local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
background.BorderSizePixel = 0
background.Parent = loadingGui

-- Game title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 400, 0, 80)
titleLabel.Position = UDim2.new(0.5, -200, 0.35, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SLEEP GAME"
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.TextSize = 48
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = background

-- Loading label
local loadingLabel = Instance.new("TextLabel")
loadingLabel.Name = "LoadingLabel"
loadingLabel.Size = UDim2.new(0, 300, 0, 40)
loadingLabel.Position = UDim2.new(0.5, -150, 0.5, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "Loading..."
loadingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingLabel.TextSize = 24
loadingLabel.Font = Enum.Font.Gotham
loadingLabel.Parent = background

-- Progress bar background
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0, 400, 0, 10)
progressBg.Position = UDim2.new(0.5, -200, 0.6, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
progressBg.BorderSizePixel = 0
progressBg.Parent = background

local progressBgCorner = Instance.new("UICorner")
progressBgCorner.CornerRadius = UDim.new(0, 5)
progressBgCorner.Parent = progressBg

-- Progress bar fill
local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBg

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 5)
progressBarCorner.Parent = progressBar

-- Freeze character during loading
if player.Character then
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
end

-- Animate loading bar (fake progress but looks good)
local loadingComplete = false

task.spawn(function()
    for i = 0, 100, 2 do
        if loadingComplete then break end
        progressBar.Size = UDim2.new(i/100, 0, 1, 0)
        task.wait(0.05)
    end
end)

-- Wait for game ready event OR timeout after 5 seconds (much faster)
local gameReadyEvent = ReplicatedStorage:WaitForChild("GameReady", 3)

local function CompleteLoading()
    if loadingComplete then
        return
    end

    loadingComplete = true
    loadingLabel.Text = "Ready!"
    progressBar.Size = UDim2.new(1, 0, 1, 0)

    task.wait(0.3)

    -- Unfreeze character
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end

    -- Fade out
    TweenService:Create(background, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    }):Play()

    TweenService:Create(titleLabel, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()

    TweenService:Create(loadingLabel, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()

    task.wait(0.5)
    if loadingGui then
        loadingGui:Destroy()
    end
end

if gameReadyEvent then
    gameReadyEvent.OnClientEvent:Connect(function()
        CompleteLoading()
    end)
end

-- Auto-complete after 5 seconds even if game ready doesn't fire
task.delay(5, function()
    if not loadingComplete then
        print("[LoadingScreen] Auto-completing after 5 seconds")
        CompleteLoading()
    end
end)

print("[LoadingScreen] Loading screen active")
