local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Настройки
local highlightEnabled = false
local fillTransparencyEnabled = false
local outlineColor = Color3.new(1, 1, 1)

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
    highlightEnabled = not highlightEnabled -- Переключаем состояние обводки
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            if highlightEnabled then
                onCharacterAdded(player.Character) -- Применяем обводку, если она включена
            else
                -- Удаляем существующую обводку, если она отключена
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight:Destroy()
                end
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
