local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Настройки
local highlightEnabled = true
local fillTransparencyEnabled = false
local outlineColor = Color3.fromRGB(255, 255, 255)

local function createHighlight(character)
    if not highlightEnabled then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillTransparency = fillTransparencyEnabled and 0 or 1
    highlight.OutlineColor = outlineColor
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    return highlight
end

local function onCharacterAdded(character)
    if character:FindFirstChildOfClass("Highlight") then
        character:FindFirstChildOfClass("Highlight"):Destroy()
    end

    createHighlight(character)
end

local function trackPlayer(player)
    if player == LocalPlayer then return end

    -- Подключаемся к событию CharacterAdded
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character)
    end)

    if player.Character then
        onCharacterAdded(player.Character)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    trackPlayer(player)
end

Players.PlayerAdded:Connect(trackPlayer)

local function toggleHighlight()
    highlightEnabled = not highlightEnabled
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            if not highlightEnabled and player.Character:FindFirstChildOfClass("Highlight") then
                player.Character:FindFirstChildOfClass("Highlight"):Destroy()
            else
                onCharacterAdded(player.Character)
            end
        end
    end
end

local function toggleFillTransparency()
    fillTransparencyEnabled = not fillTransparencyEnabled
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            onCharacterAdded(player.Character)
        end
    end
end

local function setOutlineColor(newColor)
    outlineColor = newColor
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            onCharacterAdded(player.Character)
        end
    end
end

-- toggleHighlight()
-- toggleFillTransparency()
-- setOutlineColor(Color3.fromRGB(255, 0, 0))
