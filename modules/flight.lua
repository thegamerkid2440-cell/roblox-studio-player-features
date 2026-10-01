-- This file belongs in Roblox Studio at:
-- StarterPlayer > StarterPlayerScripts > modules > flight (ModuleScript)
-- This module adds a simple hover/flight feature using normal Roblox physics.
-- It does not use exploit-only APIs and is safe for a personal Roblox Studio project.

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Flight = {
    enabled = false,
    renderConnection = nil,
    inputConnection = nil,
}

function Flight.start(player)
    if not player then
        return
    end

    local character = player.Character
    if not character then
        return
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then
        return
    end

    -- Stop previous connections if there were any
    if Flight.renderConnection then
        Flight.renderConnection:Disconnect()
        Flight.renderConnection = nil
    end

    if Flight.inputConnection then
        Flight.inputConnection:Disconnect()
        Flight.inputConnection = nil
    end

    Flight.enabled = true

    Flight.renderConnection = RunService.RenderStepped:Connect(function()
        if not player.Character then
            Flight.stop(player)
            return
        end

        local currentCharacter = player.Character
        local currentRoot = currentCharacter:FindFirstChild("HumanoidRootPart")
        local currentHumanoid = currentCharacter:FindFirstChildOfClass("Humanoid")

        if not currentRoot or not currentHumanoid then
            return
        end

        if not Flight.enabled then
            return
        end

        local currentVelocity = currentRoot.AssemblyLinearVelocity
        currentRoot.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 18, currentVelocity.Z)
        currentHumanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    end)

    Flight.inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.KeyCode == Enum.KeyCode.Space and Flight.enabled then
            local currentCharacter = player.Character
            if not currentCharacter then
                return
            end

            local currentRoot = currentCharacter:FindFirstChild("HumanoidRootPart")
            if currentRoot then
                local velocity = currentRoot.AssemblyLinearVelocity
                currentRoot.AssemblyLinearVelocity = Vector3.new(velocity.X, velocity.Y + 20, velocity.Z)
            end
        end
    end)
end

function Flight.stop(player)
    if Flight.renderConnection then
        Flight.renderConnection:Disconnect()
        Flight.renderConnection = nil
    end

    if Flight.inputConnection then
        Flight.inputConnection:Disconnect()
        Flight.inputConnection = nil
    end

    Flight.enabled = false

    if player and player.Character then
        local currentRoot = player.Character:FindFirstChild("HumanoidRootPart")
        if currentRoot then
            local velocity = currentRoot.AssemblyLinearVelocity
            currentRoot.AssemblyLinearVelocity = Vector3.new(velocity.X, 0, velocity.Z)
        end
    end
end

function Flight.setEnabled(player, enabled)
    if enabled then
        Flight.start(player)
    else
        Flight.stop(player)
    end
end

return Flight