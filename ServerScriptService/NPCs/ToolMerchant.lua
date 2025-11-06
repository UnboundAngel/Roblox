--[[
    ToolMerchant.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/NPCs/ToolMerchant

    Handles tool purchases from the Tool Merchant NPC
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(script.Parent.Parent.GameConfig)
local PlayerDataManager = require(script.Parent.Parent.PlayerDataManager)
local ToolSystem = require(script.Parent.Parent.ToolSystem)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local EventNotificationEvent = RemoteEvents:WaitForChild("EventNotification")

local ToolMerchant = {}

-- Handle tool purchase
function ToolMerchant.PurchaseTool(player)
    local cost = GameConfig.Tools.WakeAndSteal.Cost
    local uses = GameConfig.Tools.WakeAndSteal.DefaultUses

    -- Check if player has enough Time Points
    local data = PlayerDataManager.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    if data.TimePoints < cost then
        return false, string.format("Not enough Time Points! Need %d TP", cost)
    end

    -- Deduct cost
    if PlayerDataManager.DeductTimePoints(player, cost) then
        -- Give tool
        ToolSystem.GiveTool(player, uses)

        -- Send success notification
        EventNotificationEvent:FireClient(
            player,
            string.format("=' Purchased Wake & Steal Tool (%d uses)", uses),
            3,
            nil,
            nil
        )

        print(string.format("[ToolMerchant] %s purchased tool for %d TP", player.Name, cost))
        return true, "Purchase successful!"
    else
        return false, "Purchase failed"
    end
end

-- Setup merchant prompt interaction
function ToolMerchant.Setup(npcData)
    if not npcData or not npcData.Prompt then
        warn("[ToolMerchant] Invalid NPC data")
        return
    end

    -- Connect to ProximityPrompt triggered event
    npcData.Prompt.Triggered:Connect(function(player)
        local success, message = ToolMerchant.PurchaseTool(player)

        if not success then
            -- Send error notification
            EventNotificationEvent:FireClient(player, "L " .. message, 3, nil, nil)
        end
    end)

    print("[ToolMerchant] Setup complete")
end

return ToolMerchant
