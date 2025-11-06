--[[
    BedManager.lua
    SCRIPT TYPE: ModuleScript
    LOCATION: ServerScriptService/BedManager

    Spawns and manages beds on the baseplate using existing Bed model
]]

local GameConfig = require(script.Parent.GameConfig)

local BedManager = {}
BedManager.AllBeds = {}

-- Get random mutation
local function GetRandomMutation()
    return GameConfig.BedMutations[math.random(1, #GameConfig.BedMutations)]
end

-- Spawn beds scattered on the baseplate
function BedManager.SpawnBedsOnBaseplate(baseplate, bedCount)
    -- Find the template bed in workspace
    local templateBed = game.Workspace:FindFirstChild("Bed")
    if not templateBed then
        warn("[BedManager] No 'Bed' model found in Workspace! Please add a Bed model.")
        return
    end

    -- Get baseplate bounds
    local baseplateSize = baseplate.Size
    local baseplatePos = baseplate.Position

    -- Calculate spawn area (slightly smaller than baseplate for safety)
    local spawnAreaX = baseplateSize.X * 0.9
    local spawnAreaZ = baseplateSize.Z * 0.9

    print(string.format("[BedManager] Spawning %d beds on baseplate (%.1f x %.1f)",
        bedCount, spawnAreaX, spawnAreaZ))

    for i = 1, bedCount do
        -- Clone the template bed
        local bed = templateBed:Clone()

        -- Get random mutation
        local mutation = GetRandomMutation()

        -- Find WoolCover part
        local woolCover = bed:FindFirstChild("WoolCover", true)
        if woolCover and woolCover:IsA("BasePart") then
            woolCover.Color = mutation.Color
        else
            warn("[BedManager] WoolCover not found in bed model!")
        end

        -- Random position on baseplate
        local randomX = math.random(-spawnAreaX/2, spawnAreaX/2)
        local randomZ = math.random(-spawnAreaZ/2, spawnAreaZ/2)
        local spawnY = baseplatePos.Y + (baseplateSize.Y / 2) + 3  -- Slightly above baseplate

        -- Position the bed
        if bed.PrimaryPart then
            bed:SetPrimaryPartCFrame(CFrame.new(baseplatePos.X + randomX, spawnY, baseplatePos.Z + randomZ))
        else
            -- If no PrimaryPart, try to position the first part
            local firstPart = bed:FindFirstChildWhichIsA("BasePart")
            if firstPart then
                firstPart.Position = Vector3.new(baseplatePos.X + randomX, spawnY, baseplatePos.Z + randomZ)
            end
        end

        -- Add proximity prompt if it doesn't exist
        local mattress = bed:FindFirstChild("Mattress") or bed:FindFirstChild("WoolCover") or bed:FindFirstChildWhichIsA("BasePart")
        if mattress then
            local existingPrompt = mattress:FindFirstChild("ProximityPrompt")
            if not existingPrompt then
                local prompt = Instance.new("ProximityPrompt")
                prompt.ActionText = "Sleep in " .. mutation.Name .. " Bed"
                prompt.ObjectText = mutation.Name .. " Bed (+" .. math.floor(mutation.Multiplier * 100) .. "%)"
                prompt.MaxActivationDistance = 10
                prompt.HoldDuration = 0
                prompt.Parent = mattress
            else
                -- Update existing prompt
                existingPrompt.ActionText = "Sleep in " .. mutation.Name .. " Bed"
                existingPrompt.ObjectText = mutation.Name .. " Bed (+" .. math.floor(mutation.Multiplier * 100) .. "%)"
            end
        end

        -- Store mutation data
        local mutationValue = bed:FindFirstChild("Mutation")
        if not mutationValue then
            mutationValue = Instance.new("StringValue")
            mutationValue.Name = "Mutation"
            mutationValue.Parent = bed
        end
        mutationValue.Value = mutation.Name

        -- Add glow for Golden beds
        if mutation.Name == "Golden" then
            for _, part in ipairs(bed:GetDescendants()) do
                if part:IsA("BasePart") then
                    local light = part:FindFirstChild("PointLight")
                    if not light then
                        light = Instance.new("PointLight")
                        light.Brightness = 1.5
                        light.Color = mutation.Color
                        light.Range = 12
                        light.Parent = part
                    end
                end
            end
        end

        bed.Name = "Bed_" .. i
        bed.Parent = game.Workspace
        table.insert(BedManager.AllBeds, bed)
    end

    print(string.format("[BedManager] Successfully spawned %d beds!", #BedManager.AllBeds))
end

-- Spawn beds in a specific zone area
function BedManager.SpawnBedsInArea(platform, bedCount, zoneName, multiplier)
    local ModelGenerator = require(script.Parent.ModelGenerator)

    local platformSize = platform.Size
    local platformPos = platform.Position

    -- Spawn area slightly smaller than platform
    local spawnAreaX = platformSize.X * 0.8
    local spawnAreaZ = platformSize.Z * 0.8

    for i = 1, bedCount do
        -- Get random mutation
        local mutation = GetRandomMutation()

        -- Apply zone multiplier boost
        local finalMultiplier = mutation.Multiplier * (multiplier or 1.0)

        -- Random position on platform
        local randomX = math.random(-spawnAreaX/2, spawnAreaX/2)
        local randomZ = math.random(-spawnAreaZ/2, spawnAreaZ/2)
        -- Spawn right on top of platform (platform Y + half height + 0.5 for bed legs)
        local spawnY = platformPos.Y + (platformSize.Y / 2) + 0.5

        -- Create bed using ModelGenerator
        local bedPosition = Vector3.new(platformPos.X + randomX, spawnY, platformPos.Z + randomZ)
        local bed = ModelGenerator.CreateBed(bedPosition, mutation)

        -- Update prompt text to show zone multiplier
        local mattress = bed:FindFirstChild("Mattress")
        if mattress then
            local prompt = mattress:FindFirstChild("ProximityPrompt")
            if prompt then
                prompt.ObjectText = string.format("%s Bed (%.1fx)", mutation.Name, finalMultiplier)
            end
        end

        -- Store zone multiplier
        local multiplierValue = Instance.new("NumberValue")
        multiplierValue.Name = "ZoneMultiplier"
        multiplierValue.Value = multiplier or 1.0
        multiplierValue.Parent = bed

        bed.Name = zoneName .. "_Bed_" .. i
        bed.Parent = workspace
        table.insert(BedManager.AllBeds, bed)
    end

    print(string.format("[BedManager] Spawned %d beds in %s (%.1fx multiplier)", bedCount, zoneName, multiplier or 1.0))
end

-- Randomize all beds (for Bed Chaos event)
function BedManager.RandomizeBeds()
    for _, bed in ipairs(BedManager.AllBeds) do
        if bed and bed.Parent then
            local mutation = GetRandomMutation()

            -- Update WoolCover color
            local woolCover = bed:FindFirstChild("WoolCover", true)
            if woolCover and woolCover:IsA("BasePart") then
                woolCover.Color = mutation.Color
            end

            -- Update prompt
            local mattress = bed:FindFirstChild("Mattress") or bed:FindFirstChild("WoolCover") or bed:FindFirstChildWhichIsA("BasePart")
            if mattress then
                local prompt = mattress:FindFirstChild("ProximityPrompt")
                if prompt then
                    prompt.ActionText = "Sleep in " .. mutation.Name .. " Bed"
                    prompt.ObjectText = mutation.Name .. " Bed (+" .. math.floor(mutation.Multiplier * 100) .. "%)"
                end
            end

            -- Update mutation value
            local mutationValue = bed:FindFirstChild("Mutation")
            if mutationValue then
                mutationValue.Value = mutation.Name
            end

            -- Handle Golden bed glow
            if mutation.Name == "Golden" then
                for _, part in ipairs(bed:GetDescendants()) do
                    if part:IsA("BasePart") and not part:FindFirstChild("PointLight") then
                        local light = Instance.new("PointLight")
                        light.Brightness = 1.5
                        light.Color = mutation.Color
                        light.Range = 12
                        light.Parent = part
                    end
                end
            else
                -- Remove lights if not Golden
                for _, part in ipairs(bed:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local light = part:FindFirstChild("PointLight")
                        if light then
                            light:Destroy()
                        end
                    end
                end
            end
        end
    end

    print("[BedManager] Randomized all beds!")
end

return BedManager
