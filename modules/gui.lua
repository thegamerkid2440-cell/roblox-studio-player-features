-- This file belongs in Roblox Studio at:
-- StarterPlayer > StarterPlayerScripts > modules > gui (ModuleScript)
-- This module creates the mobile-friendly toggle GUI.
-- The UI is designed to be draggable on touch devices without blocking normal swipes.

local Utilities = require(script.Parent:WaitForChild("utilities"))

local GUI = {}

local function createRoundedFrame(parent, name, size, position, color)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    return frame
end

local function createTextLabel(parent, name, text, size, position, fontSize, textColor, alignment)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.Text = text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = fontSize
    label.TextColor3 = textColor
    label.TextXAlignment = alignment or Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function createTextButton(parent, name, text, size, position, color, textColor)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = textColor
    button.Font = Enum.Font.GothamBold
    button.TextSize = 15
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button

    return button
end

function GUI.create(player)
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FeatureManagerGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local panel = createRoundedFrame(screenGui, "Panel", UDim2.new(0, 260, 0, 250), UDim2.new(0, 18, 0, 120), Color3.fromRGB(20, 20, 25))

    local header = createRoundedFrame(panel, "Header", UDim2.new(1, 0, 0, 42), UDim2.new(0, 0, 0, 0), Color3.fromRGB(35, 35, 40))
    local headerTitle = createTextLabel(header, "Title", "Player Tools", UDim2.new(1, -20, 1, 0), UDim2.new(0, 10, 0, 0), 18, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left)

    local featureContainer = Instance.new("Frame")
    featureContainer.Name = "FeatureContainer"
    featureContainer.Size = UDim2.new(1, -14, 1, -68)
    featureContainer.Position = UDim2.new(0, 7, 0, 52)
    featureContainer.BackgroundTransparency = 1
    featureContainer.Parent = panel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = featureContainer

    local featureButtons = {}
    local toggleStates = {}
    local toggleCallbacks = {}

    local function setFeatureState(name, enabled)
        toggleStates[name] = enabled
        local button = featureButtons[name]
        if button then
            button.Text = name .. ": " .. (enabled and "ON" or "OFF")
            button.BackgroundColor3 = enabled and Color3.fromRGB(54, 174, 90) or Color3.fromRGB(93, 96, 108)
        end
    end

    local featureOrder = {
        "Speed",
        "Flight",
        "Infinite Jump",
        "No Clip",
    }

    for _, featureName in ipairs(featureOrder) do
        local button = createTextButton(featureContainer, featureName .. "Button", featureName .. ": OFF", UDim2.new(1, -6, 0, 34), UDim2.new(0, 0, 0, 0), Color3.fromRGB(93, 96, 108), Color3.fromRGB(255, 255, 255))
        featureButtons[featureName] = button
        toggleStates[featureName] = false

        button.MouseButton1Click:Connect(function()
            toggleStates[featureName] = not toggleStates[featureName]
            setFeatureState(featureName, toggleStates[featureName])

            if toggleCallbacks[featureName] then
                toggleCallbacks[featureName](toggleStates[featureName])
            end
        end)
    end

    local resetButton = createTextButton(panel, "ResetButton", "Reset / Disable All", UDim2.new(1, -14, 0, 38), UDim2.new(0, 7, 0, 198), Color3.fromRGB(176, 58, 58), Color3.fromRGB(255, 255, 255))
    local resetCallback = nil

    resetButton.MouseButton1Click:Connect(function()
        if resetCallback then
            resetCallback()
        end
    end)

    Utilities.makeDraggable(panel, header)

    local guiApi = {}

    function guiApi.bindToggle(featureName, callback)
        toggleCallbacks[featureName] = callback
        if callback then
            if toggleStates[featureName] == nil then
                toggleStates[featureName] = false
            end
            setFeatureState(featureName, toggleStates[featureName])
        end
    end

    function guiApi.bindReset(callback)
        resetCallback = callback
    end

    function guiApi.setToggle(featureName, enabled)
        setFeatureState(featureName, enabled)
        toggleStates[featureName] = enabled
    end

    function guiApi.destroy()
        screenGui:Destroy()
    end

    return guiApi
end

return GUI