--[[
    SleepSystem.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/SleepSystem

    Handles sleeping mechanics and score earning
]]

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

        -- Restore character state
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

            -- Unanchor and restore controls
            if rootPart then
                rootPart.Anchored = false
            end

            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Sit = false
            end

            -- Restore full opacity
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end

            -- Restore head and face
            local head = player.Character:FindFirstChild("Head")
            if head then
                head.Transparency = 0
                local face = head:FindFirstChild("face")
                if face then
                    face.Transparency = 0
                end

                -- Remove sleeping Zs particle emitter
                local zEmitter = head:FindFirstChild("SleepingZs")
                if zEmitter then
                    zEmitter:Destroy()
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

        -- Make character lay down on bed
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character.HumanoidRootPart

            -- Find bed surface to lay on
            local bedSurface = bed:FindFirstChild("Mattress") or bed:FindFirstChild("WoolCover") or bed:FindFirstChildWhichIsA("BasePart")

            if bedSurface then
                -- Position character on bed (laying down)
                local bedTop = bedSurface.Position + Vector3.new(0, bedSurface.Size.Y / 2 + 1.5, 0)

                -- Rotate character to lay horizontally
                local layingCFrame = CFrame.new(bedTop) * CFrame.Angles(math.rad(90), 0, 0)
                rootPart.CFrame = layingCFrame

                -- Anchor root part to prevent falling
                rootPart.Anchored = true

                -- Disable character controls
                if humanoid then
                    humanoid.PlatformStand = true
                    humanoid.Sit = false
                end

                -- Make character slightly transparent
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 0.3
                    end
                end

                -- Add floating Zs above head
                local head = player.Character:FindFirstChild("Head")
                if head then
                    -- Remove existing Z emitter if any
                    local existingZ = head:FindFirstChild("SleepingZs")
                    if existingZ then
                        existingZ:Destroy()
                    end

                    local zEmitter = Instance.new("ParticleEmitter")
                    zEmitter.Name = "SleepingZs"
                    zEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"  -- Will show as white particles
                    zEmitter.Rate = 2
                    zEmitter.Lifetime = NumberRange.new(2, 3)
                    zEmitter.Speed = NumberRange.new(0.5, 1)
                    zEmitter.SpreadAngle = Vector2.new(10, 10)
                    zEmitter.VelocityInheritance = 0
                    zEmitter.Acceleration = Vector3.new(0, 1, 0)  -- Float upward
                    zEmitter.Size = NumberSequence.new(0.5, 0)
                    zEmitter.Transparency = NumberSequence.new(0, 1)
                    zEmitter.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
                    zEmitter.ZOffset = 2
                    zEmitter.Parent = head
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
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

                        -- Unanchor and restore controls
                        if rootPart then
                            rootPart.Anchored = false
                        end

                        if humanoid then
                            humanoid.PlatformStand = false
                            humanoid.Sit = false
                        end

                        -- Restore full opacity
                        for _, part in pairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Transparency = 0
                            end
                        end

                        -- Restore head and face, remove Zs
                        local head = player.Character:FindFirstChild("Head")
                        if head then
                            head.Transparency = 0
                            local face = head:FindFirstChild("face")
                            if face then
                                face.Transparency = 0
                            end

                            -- Remove sleeping Zs particle emitter
                            local zEmitter = head:FindFirstChild("SleepingZs")
                            if zEmitter then
                                zEmitter:Destroy()
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
                        local bedMultiplier = mutation.Multiplier

                        -- Apply zone multiplier if present
                        local zoneMultiplierValue = data.CurrentBed:FindFirstChild("ZoneMultiplier")
                        if zoneMultiplierValue and zoneMultiplierValue:IsA("NumberValue") then
                            bedMultiplier = bedMultiplier * zoneMultiplierValue.Value
                        end

                        local baseRate = PlayerDataManager.GetEarningRate(player, bedMultiplier)
                        local nightBonus = SleepSystem.IsNight and GameConfig.Sleep.NightMultiplier or 1

                        -- Apply rebirth multiplier
                        local rebirthMultiplier = 1
                        if data.RebirthLevel and data.RebirthLevel > 0 then
                            local GameData = game:GetService("ReplicatedStorage"):WaitForChild("GameData")
                            local RebirthConfig = require(GameData:WaitForChild("RebirthConfig"))
                            rebirthMultiplier = RebirthConfig.GetMultiplier(data.RebirthLevel) or 1
                        end

                        local finalRate = baseRate * nightBonus * SleepSystem.GlobalMultiplier * rebirthMultiplier

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
        -- Check if it's a bed model (either named "Bed" or contains "_Bed_")
        if bed:IsA("Model") and (bed.Name == "Bed" or bed.Name:find("_Bed_")) then
            local mattress = bed:FindFirstChild("Mattress")
            if mattress then
                local prompt = mattress:FindFirstChild("ProximityPrompt")
                if prompt then
                    prompt.Triggered:Connect(function(player)
                        OnBedActivated(player, bed)
                    end)
                    print("[SleepSystem] Connected bed:", bed.Name)
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
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

            -- Unanchor and restore controls
            if rootPart then
                rootPart.Anchored = false
            end

            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Sit = false
            end

            -- Restore full opacity
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end

            -- Restore head and face
            local head = player.Character:FindFirstChild("Head")
            if head then
                head.Transparency = 0
                local face = head:FindFirstChild("face")
                if face then
                    face.Transparency = 0
                end

                -- Remove sleeping Zs particle emitter
                local zEmitter = head:FindFirstChild("SleepingZs")
                if zEmitter then
                    zEmitter:Destroy()
                end
            end
        end
    end
end

return SleepSystem
