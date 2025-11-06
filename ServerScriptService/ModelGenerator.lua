--[[
    ModelGenerator.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/ModelGenerator

    Generates all 3D models procedurally (beds, islands, tools, sky)
]]

local ModelGenerator = {}

-- Create a highly detailed bed model
function ModelGenerator.CreateBed(position, mutation)
    local bedModel = Instance.new("Model")
    bedModel.Name = "Bed"

    -- Wood frame color (darker than mutation color)
    local woodColor = Color3.fromRGB(101, 67, 33)
    local metalColor = Color3.fromRGB(156, 156, 156)

    -- === BED LEGS (4 corners) ===
    local legPositions = {
        Vector3.new(-2.5, -0.5, -4.5),  -- Front left
        Vector3.new(2.5, -0.5, -4.5),   -- Front right
        Vector3.new(-2.5, -0.5, 4.5),   -- Back left
        Vector3.new(2.5, -0.5, 4.5),    -- Back right
    }

    for i, legPos in ipairs(legPositions) do
        local leg = Instance.new("Part")
        leg.Name = "Leg" .. i
        leg.Size = Vector3.new(0.5, 2, 0.5)
        leg.Position = position + legPos
        leg.Anchored = true
        leg.Color = woodColor
        leg.Material = Enum.Material.Wood
        leg.Parent = bedModel

        -- Add decorative sphere on top of leg
        local sphere = Instance.new("Part")
        sphere.Name = "LegTop"
        sphere.Shape = Enum.PartType.Ball
        sphere.Size = Vector3.new(0.7, 0.7, 0.7)
        sphere.Position = position + legPos + Vector3.new(0, 1.2, 0)
        sphere.Anchored = true
        sphere.Color = woodColor
        sphere.Material = Enum.Material.Wood
        sphere.Parent = bedModel
    end

    -- === BED FRAME (connecting the legs) ===
    -- Side rails
    local leftRail = Instance.new("Part")
    leftRail.Name = "LeftRail"
    leftRail.Size = Vector3.new(0.4, 0.8, 10)
    leftRail.Position = position + Vector3.new(-2.8, 0.4, 0)
    leftRail.Anchored = true
    leftRail.Color = woodColor
    leftRail.Material = Enum.Material.Wood
    leftRail.Parent = bedModel

    local rightRail = Instance.new("Part")
    rightRail.Name = "RightRail"
    rightRail.Size = Vector3.new(0.4, 0.8, 10)
    rightRail.Position = position + Vector3.new(2.8, 0.4, 0)
    rightRail.Anchored = true
    rightRail.Color = woodColor
    rightRail.Material = Enum.Material.Wood
    rightRail.Parent = bedModel

    -- === MATTRESS BASE ===
    local mattressBase = Instance.new("Part")
    mattressBase.Name = "MattressBase"
    mattressBase.Size = Vector3.new(5.6, 0.3, 9.5)
    mattressBase.Position = position + Vector3.new(0, 0.8, 0)
    mattressBase.Anchored = true
    mattressBase.Color = woodColor
    mattressBase.Material = Enum.Material.Wood
    mattressBase.Parent = bedModel

    -- === MATTRESS (main sleeping surface) ===
    local mattress = Instance.new("Part")
    mattress.Name = "Mattress"
    mattress.Size = Vector3.new(5.5, 1.2, 9.3)
    mattress.Position = position + Vector3.new(0, 1.55, 0)
    mattress.Anchored = true
    mattress.Color = mutation.Color
    mattress.Material = Enum.Material.Fabric
    mattress.Parent = bedModel

    -- Add mattress quilting pattern
    for x = -2, 2 do
        for z = -4, 4 do
            local stitch = Instance.new("Part")
            stitch.Name = "Stitch"
            stitch.Size = Vector3.new(0.1, 0.05, 0.1)
            stitch.Position = mattress.Position + Vector3.new(x * 1.2, 0.6, z * 1.8)
            stitch.Anchored = true
            stitch.Color = Color3.fromRGB(
                math.max(0, mutation.Color.R * 255 - 30),
                math.max(0, mutation.Color.G * 255 - 30),
                math.max(0, mutation.Color.B * 255 - 30)
            )
            stitch.Material = Enum.Material.Fabric
            stitch.Parent = bedModel
        end
    end

    -- === WOOL COVER (decorative blanket) ===
    local woolCover = Instance.new("Part")
    woolCover.Name = "WoolCover"
    woolCover.Size = Vector3.new(5.4, 0.4, 6)
    woolCover.Position = position + Vector3.new(0, 2.3, 1.5)
    woolCover.Anchored = true
    woolCover.Color = mutation.Color
    woolCover.Material = Enum.Material.Fabric
    woolCover.Parent = bedModel

    -- === PILLOWS (2) ===
    local pillow1 = Instance.new("Part")
    pillow1.Name = "Pillow1"
    pillow1.Size = Vector3.new(2, 0.8, 1.5)
    pillow1.Position = position + Vector3.new(-1.5, 2.5, -3.8)
    pillow1.Anchored = true
    pillow1.Color = Color3.fromRGB(255, 255, 255)
    pillow1.Material = Enum.Material.Fabric
    pillow1.Parent = bedModel

    local pillowCorner1 = Instance.new("UICorner")
    pillowCorner1.CornerRadius = UDim.new(0.3, 0)

    local pillow2 = Instance.new("Part")
    pillow2.Name = "Pillow2"
    pillow2.Size = Vector3.new(2, 0.8, 1.5)
    pillow2.Position = position + Vector3.new(1.5, 2.5, -3.8)
    pillow2.Anchored = true
    pillow2.Color = Color3.fromRGB(255, 255, 255)
    pillow2.Material = Enum.Material.Fabric
    pillow2.Parent = bedModel

    -- === HEADBOARD ===
    local headboard = Instance.new("Part")
    headboard.Name = "Headboard"
    headboard.Size = Vector3.new(6, 3.5, 0.5)
    headboard.Position = position + Vector3.new(0, 2.2, -5)
    headboard.Anchored = true
    headboard.Color = woodColor
    headboard.Material = Enum.Material.Wood
    headboard.Parent = bedModel

    -- Headboard decorative panels
    for i = -2, 2 do
        local panel = Instance.new("Part")
        panel.Name = "HeadboardPanel"
        panel.Size = Vector3.new(0.9, 2.5, 0.3)
        panel.Position = position + Vector3.new(i * 1.2, 2.2, -5.1)
        panel.Anchored = true
        panel.Color = Color3.fromRGB(80, 53, 26)
        panel.Material = Enum.Material.Wood
        panel.Parent = bedModel
    end

    -- === FOOTBOARD ===
    local footboard = Instance.new("Part")
    footboard.Name = "Footboard"
    footboard.Size = Vector3.new(6, 2, 0.5)
    footboard.Position = position + Vector3.new(0, 1.5, 5)
    footboard.Anchored = true
    footboard.Color = woodColor
    footboard.Material = Enum.Material.Wood
    footboard.Parent = bedModel

    -- === SPECIAL EFFECTS PER MUTATION ===
    if mutation.Name == "Golden" then
        -- Golden glow
        local light = Instance.new("PointLight")
        light.Brightness = 2.5
        light.Color = mutation.Color
        light.Range = 20
        light.Parent = mattress

        -- Make frame metallic gold
        for _, part in ipairs(bedModel:GetChildren()) do
            if part.Name:find("Rail") or part.Name:find("board") or part.Name:find("Leg") then
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 215, 0)
            end
        end
    elseif mutation.Name == "Cursed" then
        -- Purple particles
        local particles = Instance.new("ParticleEmitter")
        particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
        particles.Color = ColorSequence.new(Color3.fromRGB(128, 0, 128))
        particles.Rate = 10
        particles.Lifetime = NumberRange.new(2, 4)
        particles.Speed = NumberRange.new(0.5, 1)
        particles.Parent = mattress
    elseif mutation.Name == "Fortress" then
        -- Metal frame
        for _, part in ipairs(bedModel:GetChildren()) do
            if part.Name:find("Rail") or part.Name:find("board") or part.Name:find("Leg") then
                part.Material = Enum.Material.Metal
                part.Color = metalColor
            end
        end
    end

    -- === INTERACTION PROMPT ===
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Sleep in " .. mutation.Name .. " Bed"
    prompt.ObjectText = mutation.Name .. " Bed (+" .. math.floor(mutation.Multiplier * 100) .. "%)"
    prompt.MaxActivationDistance = 10
    prompt.HoldDuration = 0
    prompt.Parent = mattress

    -- Store mutation data
    local mutationValue = Instance.new("StringValue")
    mutationValue.Name = "Mutation"
    mutationValue.Value = mutation.Name
    mutationValue.Parent = bedModel

    bedModel.PrimaryPart = mattress
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
