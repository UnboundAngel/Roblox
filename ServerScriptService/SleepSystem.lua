-- SleepSystem.lua
-- Handles sleeping mechanics and score earning

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local GameConfig = require(script.Parent.GameConfig)
local PlayerDataManager = require(script.Parent.PlayerDataManager)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local SleepEvent = RemoteEvents:WaitForChild("Sleep")
local WakeEvent = RemoteEvents:WaitForChild("Wake")

local SleepSystem = {}
SleepSystem.GlobalMultiplier = 1  -- For events
SleepSystem.IsNight = false

-- Handle bed interaction
local function OnBedActivated(player, bed)
    local data = PlayerDataManager.GetData(player)
    if not data then return end

    if data.IsSleeping then
        -- Wake up
        PlayerDataManager.StopSleeping(player)
        SleepEvent:FireClient(player, false, nil)

        -- Make character visible and enable controls
        if player.Character then
            player.Character.Archivable = true
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
    else
        -- Start sleeping
        local mutationValue = bed:FindFirstChild("Mutation")
        if not mutationValue then return end

        -- Find mutation config
        local mutation = nil
        for _, mut in ipairs(GameConfig.BedMutations) do
            if mut.Name == mutationValue.Value then
                mutation = mut
                break
            end
        end

        if not mutation then return end

        PlayerDataManager.StartSleeping(player, bed)
        SleepEvent:FireClient(player, true, mutation.Name)

        -- Make character semi-transparent and lock in place
        if player.Character and player.Character.PrimaryPart then
            local bedPosition = bed.PrimaryPart.Position + Vector3.new(0, 3, 0)
            player.Character:SetPrimaryPartCFrame(CFrame.new(bedPosition))

            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                end
            end
        end

        -- Handle Speed bed kick
        if mutation.KickTime then
            task.delay(mutation.KickTime, function()
                if PlayerDataManager.IsSleeping(player) and data.CurrentBed == bed then
                    PlayerDataManager.StopSleeping(player)
                    SleepEvent:FireClient(player, false, nil)

                    if player.Character then
                        for _, part in pairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Transparency = 0
                            end
                        end
                    end
                end
            end)
        end
    end
end

-- Earning loop
function SleepSystem.StartEarningLoop()
    RunService.Heartbeat:Connect(function(deltaTime)
        for _, player in ipairs(Players:GetPlayers()) do
            local data = PlayerDataManager.GetData(player)
            if data and data.IsSleeping and data.CurrentBed then
                -- Get bed mutation
                local mutationValue = data.CurrentBed:FindFirstChild("Mutation")
                if mutationValue then
                    local mutation = nil
                    for _, mut in ipairs(GameConfig.BedMutations) do
                        if mut.Name == mutationValue.Value then
                            mutation = mut
                            break
                        end
                    end

                    if mutation then
                        local baseRate = PlayerDataManager.GetEarningRate(player, mutation.Multiplier)
                        local nightBonus = SleepSystem.IsNight and GameConfig.Sleep.NightMultiplier or 1
                        local finalRate = baseRate * nightBonus * SleepSystem.GlobalMultiplier

                        PlayerDataManager.AddTimePoints(player, finalRate * deltaTime)
                    end
                end
            end
        end
    end)
end

-- Set up all beds in workspace
function SleepSystem.SetupBeds()
    for _, bed in ipairs(game.Workspace:GetDescendants()) do
        if bed:IsA("Model") and bed.Name == "Bed" then
            local mattress = bed:FindFirstChild("Mattress")
            if mattress then
                local prompt = mattress:FindFirstChild("ProximityPrompt")
                if prompt then
                    prompt.Triggered:Connect(function(player)
                        OnBedActivated(player, bed)
                    end)
                end
            end
        end
    end
end

-- Manual wake (for tools and admin)
function SleepSystem.WakePlayer(player)
    if PlayerDataManager.IsSleeping(player) then
        PlayerDataManager.StopSleeping(player)
        SleepEvent:FireClient(player, false, nil)

        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
    end
end

return SleepSystem
