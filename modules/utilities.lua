-- This file belongs in Roblox Studio at:
-- StarterPlayer > StarterPlayerScripts > modules > utilities (ModuleScript)
-- This module contains shared helper functions used by the other modules.
-- It helps keep the project organized and easier to expand later.

local Utilities = {}

function Utilities.getPlayer()
    return game.Players.LocalPlayer
end

function Utilities.getCharacter(player)
    if not player then
        player = Utilities.getPlayer()
    end

    if player and player.Character then
        return player.Character
    end

    return nil
end

function Utilities.getHumanoid(player)
    local character = Utilities.getCharacter(player)
    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

function Utilities.getRootPart(player)
    local character = Utilities.getCharacter(player)
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

function Utilities.waitForCharacter(player)
    if not player then
        player = Utilities.getPlayer()
    end

    if player.Character then
        return player.Character
    end

    return player.CharacterAdded:Wait()
end

function Utilities.create(className, properties)
    local instance = Instance.new(className)
    for key, value in pairs(properties or {}) do
        instance[key] = value
    end
    return instance
end

function Utilities.getDescendantParts(character)
    local parts = {}
    if not character then
        return parts
    end

    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(parts, descendant)
        end
    end

    return parts
end

function Utilities.makeDraggable(frame, dragZone)
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStartPosition = nil
    local originalPosition = nil

    local zone = dragZone or frame

    zone.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragStartPosition = input.Position
        originalPosition = frame.Position
    end)

    zone.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = false
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        if dragging and dragStartPosition and originalPosition then
            local delta = input.Position - dragStartPosition
            frame.Position = UDim2.new(
                originalPosition.X.Scale,
                originalPosition.X.Offset + delta.X,
                originalPosition.Y.Scale,
                originalPosition.Y.Offset + delta.Y
            )
        end
    end)

    return {
        start = function()
            dragging = true
        end,

        stop = function()
            dragging = false
        end,
    }
end

return Utilities