-- This file belongs in Roblox Studio at:
-- StarterPlayer > StarterPlayerScripts > main (LocalScript)
-- This is the main entry point for the entire feature project.
-- It requires all modules, creates the UI, and connects each feature.
-- ALL you need to do is copy this ONE file. Everything else is handled automatically.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local modulesFolder = script:WaitForChild("modules")

-- Load all modules
local movement = require(modulesFolder:WaitForChild("movement"))
local flight = require(modulesFolder:WaitForChild("flight"))
local speed = require(modulesFolder:WaitForChild("speed"))
local infiniteJump = require(modulesFolder:WaitForChild("infinitejump"))
local noclip = require(modulesFolder:WaitForChild("noclip"))
local gui = require(modulesFolder:WaitForChild("gui"))

-- Global state tracking
local state = {
    speed = false,
    flight = false,
    infiniteJump = false,
    noclip = false,
}

local featureGui = nil

-- Refresh GUI display based on current state
local function refreshGui()
    if not featureGui then
        return
    end

    featureGui.setToggle("Speed", state.speed)
    featureGui.setToggle("Flight", state.flight)
    featureGui.setToggle("Infinite Jump", state.infiniteJump)
    featureGui.setToggle("No Clip", state.noclip)
end

-- Disable all features and reset state
local function resetAllFeatures()
    state.speed = false
    state.flight = false
    state.infiniteJump = false
    state.noclip = false

    speed.setEnabled(player, false)
    flight.setEnabled(player, false)
    infiniteJump.setEnabled(player, false)
    noclip.setEnabled(player, false)

    refreshGui()
end

-- Re-enable active features when character respawns
local function setupCharacterSync()
    local function syncCurrentCharacter()
        if state.speed then
            speed.setEnabled(player, true)
        end

        if state.flight then
            flight.setEnabled(player, true)
        end

        if state.infiniteJump then
            infiniteJump.setEnabled(player, true)
        end

        if state.noclip then
            noclip.setEnabled(player, true)
        end
    end

    syncCurrentCharacter()

    player.CharacterAdded:Connect(function()
        task.wait(0.2)
        syncCurrentCharacter()
    end)
end

-- Main initialization function
local function initialize()
    -- Reset character to default state
    movement.resetCharacterState(player)

    -- Create the GUI
    featureGui = gui.create(player)

    -- Bind Speed toggle
    featureGui.bindToggle("Speed", function(enabled)
        state.speed = enabled
        speed.setEnabled(player, enabled)
    end)

    -- Bind Flight toggle
    featureGui.bindToggle("Flight", function(enabled)
        state.flight = enabled
        flight.setEnabled(player, enabled)
    end)

    -- Bind Infinite Jump toggle
    featureGui.bindToggle("Infinite Jump", function(enabled)
        state.infiniteJump = enabled
        infiniteJump.setEnabled(player, enabled)
    end)

    -- Bind No Clip toggle
    featureGui.bindToggle("No Clip", function(enabled)
        state.noclip = enabled
        noclip.setEnabled(player, enabled)
    end)

    -- Bind Reset button
    featureGui.bindReset(function()
        resetAllFeatures()
    end)

    -- Update GUI display
    refreshGui()

    -- Sync features when character respawns
    setupCharacterSync()
end

-- Start the application
initialize()
