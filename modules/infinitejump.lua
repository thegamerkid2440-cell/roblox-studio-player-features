-- This file belongs in Roblox Studio at:
-- StarterPlayer > StarterPlayerScripts > modules > infinitejump (ModuleScript)
-- This module enables infinite jumping using the standard JumpRequest event.
-- It is simple, safe, and does not rely on any external or exploit-only systems.

local UserInputService = game:GetService("UserInputService")

local InfiniteJump = {
    enabled = false,
    connection = nil,
}

function InfiniteJump.setEnabled(player, enabled)
    if not player then
        return
    end

    if enabled then
        if InfiniteJump.connection then
            return
        end

        InfiniteJump.enabled = true

        InfiniteJump.connection = UserInputService.JumpRequest:Connect(function()
            local character = player.Character
            if not character then
                return
            end

            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then
                return
            end

            if humanoid:GetState() ~= Enum.HumanoidStateType.Landed then
                -- Allow repeated jumping while airborne
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        InfiniteJump.enabled = false

        if InfiniteJump.connection then
            InfiniteJump.connection:Disconnect()
            InfiniteJump.connection = nil
        end
    end
end

return InfiniteJump