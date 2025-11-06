-- ToolSystem.lua
-- Handles Wake & Steal tool mechanics

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameConfig = require(script.Parent.GameConfig)
local PlayerDataManager = require(script.Parent.PlayerDataManager)
local SleepSystem = require(script.Parent.SleepSystem)
local DayNightCycle = require(script.Parent.DayNightCycle)
local RandomEvents = require(script.Parent.RandomEvents)
local ModelGenerator = require(script.Parent.ModelGenerator)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local UseToolEvent = RemoteEvents:WaitForChild("UseTool")
local PurchaseToolEvent = RemoteEvents:WaitForChild("PurchaseTool")

local ToolSystem = {}
ToolSystem.Cooldowns = {}

-- Give tool to player
function ToolSystem.GiveTool(player, uses)
    uses = uses or GameConfig.Tools.WakeAndSteal.DefaultUses

    local tool = ModelGenerator.CreateWakeTool(uses)
    tool.Parent = player.Backpack
end

-- Find nearby sleeping players
local function FindNearbySleepingPlayer(player)
    if not player.Character or not player.Character.PrimaryPart then
        return nil
    end

    local playerPosition = player.Character.PrimaryPart.Position
    local nearestPlayer = nil
    local nearestDistance = GameConfig.Tools.WakeAndSteal.Range

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and PlayerDataManager.IsSleeping(otherPlayer) then
            if otherPlayer.Character and otherPlayer.Character.PrimaryPart then
                local distance = (otherPlayer.Character.PrimaryPart.Position - playerPosition).Magnitude

                if distance < nearestDistance then
                    nearestPlayer = otherPlayer
                    nearestDistance = distance
                end
            end
        end
    end

    return nearestPlayer
end

-- Use tool
local function OnToolUsed(player, tool)
    -- Check cooldown
    local now = tick()
    local lastUse = ToolSystem.Cooldowns[player.UserId] or 0
    local cooldown = GameConfig.Tools.WakeAndSteal.Cooldown * RandomEvents.TheftCooldownMultiplier

    if now - lastUse < cooldown then
        return
    end

    -- Check uses
    local usesValue = tool:FindFirstChild("Uses")
    if not usesValue or usesValue.Value <= 0 then
        tool:Destroy()
        return
    end

    -- Find target
    local target = FindNearbySleepingPlayer(player)
    if not target then
        return
    end

    -- Check shield
    if RandomEvents.ShieldActive then
        return
    end

    -- Check god mode
    local targetData = PlayerDataManager.GetData(target)
    if targetData and targetData.GodMode then
        return
    end

    -- Calculate steal amount
    local stealPercent = DayNightCycle.IsDay
        and GameConfig.Tools.WakeAndSteal.StealPercentDay
        or GameConfig.Tools.WakeAndSteal.StealPercentNight

    -- Apply theft protection
    local theftProtection = PlayerDataManager.GetTheftProtection(target)

    -- Get bed mutation protection
    local bedProtection = 0
    if targetData and targetData.CurrentBed then
        local mutationValue = targetData.CurrentBed:FindFirstChild("Mutation")
        if mutationValue then
            for _, mut in ipairs(GameConfig.BedMutations) do
                if mut.Name == mutationValue.Value then
                    bedProtection = mut.TheftProtection
                    break
                end
            end
        end
    end

    -- Final steal percentage
    local totalProtection = math.min(theftProtection + bedProtection, 100)
    local finalStealPercent = stealPercent * (1 - totalProtection / 100)

    -- Steal points
    if targetData then
        local stolenAmount = targetData.TimePoints * (finalStealPercent / 100)
        PlayerDataManager.DeductTimePoints(target, stolenAmount)
        PlayerDataManager.AddTimePoints(player, stolenAmount)

        -- Wake target
        SleepSystem.WakePlayer(target)

        -- Update cooldown
        ToolSystem.Cooldowns[player.UserId] = now

        -- Decrease uses
        usesValue.Value = usesValue.Value - 1

        if usesValue.Value <= 0 then
            tool:Destroy()
        end

        print(string.format("[ToolSystem] %s stole %.1f TP from %s (%.1f%%)",
            player.Name, stolenAmount, target.Name, finalStealPercent))
    end
end

-- Handle tool activation from client
UseToolEvent.OnServerEvent:Connect(function(player, tool)
    OnToolUsed(player, tool)
end)

-- Purchase tool
PurchaseToolEvent.OnServerEvent:Connect(function(player)
    local data = PlayerDataManager.GetData(player)
    if not data then return end

    local cost = GameConfig.Tools.WakeAndSteal.Cost

    if PlayerDataManager.DeductTimePoints(player, cost) then
        local uses = GameConfig.Tools.WakeAndSteal.DefaultUses

        -- Apply tool capacity upgrade
        uses = uses + (data.Upgrades.ToolCapacity * GameConfig.Upgrades.ToolCapacity.BonusPerLevel)

        ToolSystem.GiveTool(player, uses)
        print(string.format("[ToolSystem] %s purchased Wake & Steal tool (%d uses)", player.Name, uses))
    end
end)

return ToolSystem
