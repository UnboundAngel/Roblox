--[[
    ToolHandler.lua
    SCRIPT TYPE: LocalScript (NOT Script or ModuleScript)
    LOCATION: StarterPlayer/StarterPlayerScripts/ToolHandler

    Handles tool activation on the client
    Fires UseToolEvent to server when tool is clicked
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local UseToolEvent = RemoteEvents:WaitForChild("UseTool")

-- Handle tool activation
player.CharacterAdded:Connect(function(character)
    local backpack = player:WaitForChild("Backpack")

    local function SetupTool(tool)
        if tool.Name == "Wake & Steal Tool" then
            tool.Activated:Connect(function()
                UseToolEvent:FireServer(tool)
            end)
        end
    end

    -- Setup existing tools
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            SetupTool(tool)
        end
    end

    -- Setup new tools
    backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            SetupTool(child)
        end
    end)

    -- Also check character (equipped tools)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            SetupTool(child)
        end
    end)
end)

-- If character already exists
if player.Character then
    local backpack = player:WaitForChild("Backpack")

    local function SetupTool(tool)
        if tool.Name == "Wake & Steal Tool" then
            tool.Activated:Connect(function()
                UseToolEvent:FireServer(tool)
            end)
        end
    end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            SetupTool(tool)
        end
    end

    backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            SetupTool(child)
        end
    end)

    player.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            SetupTool(child)
        end
    end)
end

print("[ToolHandler] Tool handler initialized!")
