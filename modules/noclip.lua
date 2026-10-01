-- This file belongs in Roblox Studio at:
-- StarterPlayer > StarterPlayerScripts > modules > noclip (ModuleScript)
-- This module turns off collision on the local player's character.
-- It uses normal Roblox BasePart properties and is safe for a personal Studio project.

local Movement = require(script.Parent:WaitForChild("movement"))

local NoClip = {
    enabled = false,
    characterConnection = nil,
}

local function setCharacterCollision(character, canCollide)
    if not character then
        return
    end

    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = canCollide
        end
    end
end

function NoClip.setEnabled(player, enabled)
    if not player then
        return
    end

    local character = Movement.getCharacter(player)
    if character then
        setCharacterCollision(character, not enabled)
    end

    if enabled then
        NoClip.enabled = true

        if NoClip.characterConnection then
            NoClip.characterConnection:Disconnect()
        end

        NoClip.characterConnection = player.CharacterAdded:Connect(function(newCharacter)
            task.wait(0.1)
            setCharacterCollision(newCharacter, false)
        end)
    else
        NoClip.enabled = false

        if NoClip.characterConnection then
            NoClip.characterConnection:Disconnect()
            NoClip.characterConnection = nil
        end

        if player.Character then
            setCharacterCollision(player.Character, true)
        end
    end
end

return NoClip