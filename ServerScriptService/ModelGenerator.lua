--[[
    ModelGenerator.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/ModelGenerator

    Generates all 3D models procedurally (beds, islands, tools, sky)
]]

local ModelGenerator = {}

-- Create a simple bed model
function ModelGenerator.CreateBed(position, mutation)
    local bedModel = Instance.new("Model")
    bedModel.Name = "Bed"

    -- Bed frame (main part)
    local frame = Instance.new("Part")
    frame.Name = "Frame"
    frame.Size = Vector3.new(6, 1, 10)
    frame.Position = position
    frame.Anchored = true
    frame.Color = mutation.Color
    frame.Material = Enum.Material.SmoothPlastic
    frame.Parent = bedModel

    -- Mattress
    local mattress = Instance.new("Part")
    mattress.Name = "Mattress"
    mattress.Size = Vector3.new(5.5, 1.5, 9.5)
    mattress.Position = position + Vector3.new(0, 1.25, 0)
    mattress.Anchored = true
    mattress.Color = mutation.Color
    mattress.Material = Enum.Material.Fabric
    mattress.Parent = bedModel

    -- Pillow
    local pillow = Instance.new("Part")
    pillow.Name = "Pillow"
    pillow.Size = Vector3.new(4, 1, 2)
    pillow.Position = position + Vector3.new(0, 2.5, -3.5)
    pillow.Anchored = true
    pillow.Color = Color3.fromRGB(255, 255, 255)
    pillow.Material = Enum.Material.Fabric
    pillow.Parent = bedModel

    -- Add glow effect for special mutations
    if mutation.Name == "Golden" then
        local light = Instance.new("PointLight")
        light.Brightness = 2
        light.Color = mutation.Color
        light.Range = 15
        light.Parent = frame
    end

    -- Interaction prompt
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Sleep in " .. mutation.Name .. " Bed"
    prompt.ObjectText = mutation.Name .. " Bed (+" .. math.floor(mutation.Multiplier * 100) .. "%)"
    prompt.MaxActivationDistance = 8
    prompt.Parent = mattress

    -- Store mutation data
    local mutationValue = Instance.new("StringValue")
    mutationValue.Name = "Mutation"
    mutationValue.Value = mutation.Name
    mutationValue.Parent = bedModel

    bedModel.PrimaryPart = frame
    return bedModel
end

-- Create an island
function ModelGenerator.CreateIsland(position, size)
    local island = Instance.new("Model")
    island.Name = "Island"

    -- Main island platform
    local platform = Instance.new("Part")
    platform.Name = "Platform"
    platform.Size = Vector3.new(size, 3, size)
    platform.Position = position
    platform.Anchored = true
    platform.Color = Color3.fromRGB(100, 200, 100)
    platform.Material = Enum.Material.Grass
    platform.Parent = island

    -- Add some decoration blocks
    for i = 1, 3 do
        local deco = Instance.new("Part")
        deco.Size = Vector3.new(2, math.random(2, 5), 2)
        deco.Position = position + Vector3.new(
            math.random(-size/3, size/3),
            platform.Size.Y/2 + deco.Size.Y/2,
            math.random(-size/3, size/3)
        )
        deco.Anchored = true
        deco.Color = Color3.fromRGB(34, 139, 34)
        deco.Material = Enum.Material.Grass
        deco.Parent = island
    end

    island.PrimaryPart = platform
    return island
end

-- Create the spawn platform
function ModelGenerator.CreateSpawnPlatform()
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = "SpawnLocation"
    spawn.Size = Vector3.new(20, 1, 20)
    spawn.Position = Vector3.new(0, 10, 0)
    spawn.Anchored = true
    spawn.Color = Color3.fromRGB(0, 150, 255)
    spawn.Material = Enum.Material.Neon
    spawn.CanCollide = true
    spawn.Transparency = 0.3
    spawn.Duration = 0

    return spawn
end

-- Create the Wake & Steal tool
function ModelGenerator.CreateWakeTool(uses)
    local tool = Instance.new("Tool")
    tool.Name = "Wake & Steal Tool"
    tool.RequiresHandle = true
    tool.CanBeDropped = false

    -- Tool handle
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 4, 0.5)
    handle.Color = Color3.fromRGB(255, 0, 0)
    handle.Material = Enum.Material.Neon
    handle.Parent = tool

    -- Top orb
    local orb = Instance.new("Part")
    orb.Name = "Orb"
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(1.5, 1.5, 1.5)
    orb.Color = Color3.fromRGB(255, 100, 100)
    orb.Material = Enum.Material.Neon
    orb.CanCollide = false

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = orb
    weld.Parent = orb

    orb.Parent = tool

    -- Add glow
    local light = Instance.new("PointLight")
    light.Brightness = 2
    light.Color = Color3.fromRGB(255, 0, 0)
    light.Range = 10
    light.Parent = orb

    -- Store uses
    local usesValue = Instance.new("IntValue")
    usesValue.Name = "Uses"
    usesValue.Value = uses
    usesValue.Parent = tool

    return tool
end

-- Create a sky
function ModelGenerator.CreateSky()
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex"
    sky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
    sky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
    sky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
    sky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
    sky.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
    sky.SunAngularSize = 21
    sky.MoonAngularSize = 11

    return sky
end

return ModelGenerator
