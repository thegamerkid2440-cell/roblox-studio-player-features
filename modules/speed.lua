-- This file belongs in Roblox Studio at:
-- StarterPlayer > StarterPlayerScripts > modules > speed (ModuleScript)
-- This module controls walk speed for the local player.
-- It is safe, standard Roblox API, and easy to extend later.

local Movement = require(script.Parent:WaitForChild("movement"))

local Speed = {
    defaultSpeed = 16,
    boostedSpeed = 60,
}

function Speed.setEnabled(player, enabled)
    local character = Movement.getCharacter(player)
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end

    if enabled then
        humanoid.WalkSpeed = Speed.boostedSpeed
    else
        humanoid.WalkSpeed = Speed.defaultSpeed
    end
end

function Speed.setSpeed(player, value)
    local character = Movement.getCharacter(player)
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end

    humanoid.WalkSpeed = value
end

return Speed