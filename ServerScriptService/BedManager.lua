-- BedManager.lua
-- Spawns and manages beds on islands

local GameConfig = require(script.Parent.GameConfig)
local ModelGenerator = require(script.Parent.ModelGenerator)

local BedManager = {}
BedManager.AllBeds = {}

-- Get random mutation
local function GetRandomMutation()
    return GameConfig.BedMutations[math.random(1, #GameConfig.BedMutations)]
end

-- Spawn beds on an island
function BedManager.SpawnBedsOnIsland(island)
    local platform = island:FindFirstChild("Platform")
    if not platform then return end

    local islandSize = GameConfig.Map.IslandSize
    local bedsPerIsland = GameConfig.Map.BedsPerIsland

    for i = 1, bedsPerIsland do
        local mutation = GetRandomMutation()

        -- Random position on island
        local randomX = math.random(-islandSize/3, islandSize/3)
        local randomZ = math.random(-islandSize/3, islandSize/3)
        local bedPosition = platform.Position + Vector3.new(randomX, platform.Size.Y/2 + 2, randomZ)

        local bed = ModelGenerator.CreateBed(bedPosition, mutation)
        bed.Parent = island

        table.insert(BedManager.AllBeds, bed)
    end
end

-- Randomize all beds (for Bed Chaos event)
function BedManager.RandomizeBeds()
    for _, bed in ipairs(BedManager.AllBeds) do
        if bed and bed.Parent then
            local mutation = GetRandomMutation()

            -- Update bed color
            local frame = bed:FindFirstChild("Frame")
            local mattress = bed:FindFirstChild("Mattress")

            if frame then
                frame.Color = mutation.Color
            end

            if mattress then
                mattress.Color = mutation.Color

                -- Update prompt
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

            -- Add/remove glow for Golden beds
            if mutation.Name == "Golden" then
                if frame and not frame:FindFirstChild("PointLight") then
                    local light = Instance.new("PointLight")
                    light.Brightness = 2
                    light.Color = mutation.Color
                    light.Range = 15
                    light.Parent = frame
                end
            else
                if frame then
                    local light = frame:FindFirstChild("PointLight")
                    if light then
                        light:Destroy()
                    end
                end
            end
        end
    end

    print("[BedManager] Randomized all beds!")
end

return BedManager
