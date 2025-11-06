--[[
    UpgradeMerchant.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/NPCs/UpgradeMerchant

    Handles upgrade purchases from the Upgrade Merchant NPC in the hub
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local UpgradeConfig = require(GameData:WaitForChild("UpgradeConfig"))

local PlayerDataManager = require(script.Parent.Parent.PlayerDataManager)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")

local UpgradeMerchant = {}

-- Purchase an upgrade
function UpgradeMerchant.PurchaseUpgrade(player, upgradeName)
    -- Validate upgrade name
    local upgradeData = UpgradeConfig[upgradeName]
    if not upgradeData then
        return false, "Invalid upgrade"
    end

    -- Get player data
    local data = PlayerDataManager.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    -- Initialize hub upgrades if not exist
    if not data.HubUpgrades then
        data.HubUpgrades = {
            AutoSleeper = 0,
            OfflineGeneration = 0,
            TheftShield = 0,
            SpeedBoost = 0,
        }
    end

    local currentLevel = data.HubUpgrades[upgradeName] or 0

    -- Check if max level
    if currentLevel >= upgradeData.MaxLevel then
        return false, "Already at max level!"
    end

    -- Calculate cost
    local cost = UpgradeConfig.CalculateCost(upgradeName, currentLevel)
    if not cost then
        return false, "Cannot calculate cost"
    end

    -- Check if player has enough TP
    if data.TimePoints < cost then
        return false, string.format("Not enough TP! Need %d", cost)
    end

    -- Deduct cost
    if PlayerDataManager.DeductTimePoints(player, cost) then
        -- Upgrade level
        data.HubUpgrades[upgradeName] = currentLevel + 1

        -- Apply upgrade effects
        UpgradeMerchant.ApplyUpgradeEffects(player, upgradeName, data.HubUpgrades[upgradeName])

        -- Send success notification
        local newLevel = data.HubUpgrades[upgradeName]
        EventNotificationEvent:FireClient(
            player,
            string.format("P Upgraded %s to Level %d!", upgradeData.Name, newLevel),
            3,
            nil,
            nil
        )

        print(string.format("[UpgradeMerchant] %s upgraded %s to level %d", player.Name, upgradeName, newLevel))
        return true, string.format("Upgraded to Level %d!", newLevel)
    else
        return false, "Purchase failed"
    end
end

-- Apply upgrade effects to player
function UpgradeMerchant.ApplyUpgradeEffects(player, upgradeName, level)
    local data = PlayerDataManager.GetData(player)
    if not data then
        return
    end

    -- Apply speed boost if applicable
    if upgradeName == "SpeedBoost" then
        local upgradeData = UpgradeConfig.SpeedBoost
        local speedMultiplier = upgradeData.SpeedMultipliers[level] or 1

        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16 * speedMultiplier
        end
    end

    -- Other upgrades are passive and don't need immediate application
    -- (Auto-sleeper runs in AutoSleeperSystem, Offline in OfflineGenerationSystem, etc.)
end

-- Setup merchant prompt interaction
function UpgradeMerchant.Setup(npcData)
    if not npcData or not npcData.Prompt then
        warn("[UpgradeMerchant] Invalid NPC data")
        return
    end

    -- For now, the interaction opens a UI menu
    -- The actual purchase will be handled by RemoteEvents from the UpgradeUI
    npcData.Prompt.Triggered:Connect(function(player)
        -- Fire event to open upgrade UI on client
        local OpenUpgradeUIEvent = RemoteEvents:FindFirstChild("OpenUpgradeUI")
        if OpenUpgradeUIEvent then
            OpenUpgradeUIEvent:FireClient(player)
        else
            EventNotificationEvent:FireClient(player, "P Upgrade menu coming soon!", 3, nil, nil)
        end
    end)

    print("[UpgradeMerchant] Setup complete")
end

return UpgradeMerchant
