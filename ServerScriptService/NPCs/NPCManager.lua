--[[
    NPCManager.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/NPCs/NPCManager

    Manages NPC spawning, positioning, and interaction
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NPCManager = {}
NPCManager.NPCs = {}

-- Create a basic humanoid NPC model (placeholder until custom rigs are provided)
local function CreateBasicNPC(name, position, color)
    local npc = Instance.new("Model")
    npc.Name = name

    -- Create humanoid parts
    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Size = Vector3.new(2, 2, 1)
    torso.Position = position
    torso.Anchored = true
    torso.BrickColor = color or BrickColor.new("Bright blue")
    torso.Material = Enum.Material.SmoothPlastic
    torso.Parent = npc

    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(2, 1, 1)
    head.Position = position + Vector3.new(0, 1.5, 0)
    head.Anchored = true
    head.BrickColor = color or BrickColor.new("Bright blue")
    head.Material = Enum.Material.SmoothPlastic
    head.Shape = Enum.PartType.Ball
    head.Parent = npc

    -- Add face decal
    local face = Instance.new("Decal")
    face.Name = "face"
    face.Texture = "rbxasset://textures/face.png"
    face.Face = Enum.NormalId.Front
    face.Parent = head

    -- Add name tag
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = billboardGui

    -- Set PrimaryPart
    npc.PrimaryPart = torso

    return npc, torso
end

-- Spawn an NPC with a ProximityPrompt
function NPCManager.SpawnNPC(name, position, color, promptText, merchantType)
    -- Create NPC model
    local npc, interactPart = CreateBasicNPC(name, position, color)
    npc.Parent = workspace

    -- Add ProximityPrompt for interaction
    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "InteractPrompt"
    prompt.ActionText = promptText or "Talk"
    prompt.ObjectText = name
    prompt.MaxActivationDistance = 10
    prompt.HoldDuration = 0
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.Parent = interactPart

    -- Store NPC data
    table.insert(NPCManager.NPCs, {
        Model = npc,
        Name = name,
        Prompt = prompt,
        MerchantType = merchantType,
        Position = position,
    })

    print(string.format("[NPCManager] Spawned NPC: %s at %s", name, tostring(position)))

    return npc, prompt
end

-- Remove an NPC
function NPCManager.RemoveNPC(name)
    for i, npcData in ipairs(NPCManager.NPCs) do
        if npcData.Name == name then
            npcData.Model:Destroy()
            table.remove(NPCManager.NPCs, i)
            print(string.format("[NPCManager] Removed NPC: %s", name))
            break
        end
    end
end

-- Get NPC by name
function NPCManager.GetNPC(name)
    for _, npcData in ipairs(NPCManager.NPCs) do
        if npcData.Name == name then
            return npcData
        end
    end
    return nil
end

-- Spawn all default NPCs
function NPCManager.SpawnDefaultNPCs()
    -- Tool Merchant (near spawn/starter zone)
    NPCManager.SpawnNPC(
        "Tool Merchant",
        Vector3.new(20, 5, 20),
        BrickColor.new("Bright orange"),
        "Buy Tools",
        "ToolMerchant"
    )

    -- Upgrade Merchant (in hub - will be repositioned by HubZone)
    NPCManager.SpawnNPC(
        "Upgrade Master",
        Vector3.new(100, 5, 100),
        BrickColor.new("Bright violet"),
        "Upgrades",
        "UpgradeMerchant"
    )

    print("[NPCManager] Spawned all default NPCs")
end

return NPCManager
