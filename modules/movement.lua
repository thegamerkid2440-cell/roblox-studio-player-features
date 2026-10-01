-- This file belongs in Roblox Studio at:
-- StarterPlayer > StarterPlayerScripts > modules > movement (ModuleScript)
-- This module handles basic player and character access.
-- It is meant to be reused by the other modules.

local Utilities = require(script.Parent:WaitForChild("utilities"))

local Movement = {}

function Movement.getPlayer()
    return Utilities.getPlayer()
end

function Movement.getCharacter(player)
    return Utilities.getCharacter(player)
end

function Movement.getHumanoid(player)
    return Utilities.getHumanoid(player)
end

function Movement.getRootPart(player)
    return Utilities.getRootPart(player)
end

function Movement.waitForCharacter(player)
    return Utilities.waitForCharacter(player)
end

function Movement.resetCharacterState(player)
    local character = Utilities.getCharacter(player)
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end

return Movement