local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- Настройки
local scriptEnabled = false
local rainbowTextEnabled = false
local customTextColor = Color3.new(1, 1, 1)
local textSize = 12
local showName = false
local showDistance = false
local showHealth = false
local maxDisplayDistance = 1000
local TextPosition = {
    Center = Vector3.new(0, 0, 0),
    Above = Vector3.new(0, 2, 0),
    Below = Vector3.new(0, -2, 0)
}
local currentTextPosition = TextPosition.Above

-- Function to create a Drawing text
local function createText()
    local text = Drawing.new("Text")
    text.Size = textSize
    text.Outline = true
    text.Center = true
    text.Visible = false
    return text
end

-- Table to hold the Drawing texts for each player
local playerText = {}

-- Function to generate rainbow colors
local function rainbowColor(frequency)
    local r = math.floor(math.sin(frequency + 0) * 127 + 128)
    local g = math.floor(math.sin(frequency + 2) * 127 + 128)
    local b = math.floor(math.sin(frequency + 4) * 127 + 128)
    return Color3.fromRGB(r, g, b)
end

-- Update the Drawing texts
-- Update the Drawing texts
-- Update the Drawing texts
local function updateTexts()
    -- Если скрипт выключен, скрываем все тексты и выходим
    if not scriptEnabled then 
        for _, text in pairs(playerText) do
            text.Visible = false  -- Скрываем текст
        end
        return 
    end

    local time = tick()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if head and humanoid then
                local distance = (localPlayer.Character.HumanoidRootPart.Position - rootPart.Position).magnitude
                
                -- Проверка расстояния с использованием maxDisplayDistance
                if distance > maxDisplayDistance then
                    if playerText[player] then
                        playerText[player].Visible = false  -- Скрываем текст, если игрок слишком далеко
                    end
                    continue
                end

                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position + currentTextPosition)
                
                local text = playerText[player]
                if not text then
                    text = createText()
                    playerText[player] = text
                end
                
                if onScreen then
                    local displayText = ""

                    -- Формируем текст в зависимости от включенных опций
                    if showName then
                        displayText = player.Name
                    end
                    if showDistance then
                        if displayText ~= "" then
                            displayText = displayText .. " | "
                        end
                        displayText = displayText .. math.floor(distance) .. " studs"
                    end
                    if showHealth then
                        if displayText ~= "" then
                            displayText = displayText .. " | "
                        end
                        local health = humanoid.Health
                        local maxHealth = humanoid.MaxHealth
                        displayText = displayText .. "HP: " .. math.floor(health) .. "/" .. math.floor(maxHealth)
                    end

                    text.Position = Vector2.new(screenPos.X, screenPos.Y)
                    text.Text = displayText

                    -- Установка цвета текста в зависимости от состояния rainbowTextEnabled
                    if rainbowTextEnabled then
                        text.Color = rainbowColor(time + player.UserId)
                    else
                        text.Color = customTextColor
                    end

                    text.Size = textSize
                    text.Visible = true  -- Показываем текст, если он на экране
                else
                    text.Visible = false  -- Скрываем текст, если игрок не на экране
                end
            end
        elseif playerText[player] then
            playerText[player].Visible = false  -- Скрываем текст, если игрок не активен
        end
    end
end

-- Update the texts every frame
runService.RenderStepped:Connect(updateTexts)

-- Clean up when a player leaves
players.PlayerRemoving:Connect(function(player)
    if playerText[player] then
        playerText[player]:Remove()
        playerText[player] = nil
    end
end)

-- Пример функции для переключения состояния скрипта
function toggleScript()
    scriptEnabled = not scriptEnabled
end

-- Пример функции для переключения состояния радуги текста
function toggleRainbowText()
    rainbowTextEnabled = not rainbowTextEnabled
end

-- Пример функции для установки пользовательского цвета текста
function setCustomTextColor(r, g, b)
    customTextColor = Color3.new(r, g, b)
end

-- Пример функции для установки размера текста
function setTextSize(size)
    textSize = size
    for _, text in pairs(playerText) do
        text.Size = textSize
    end
end

-- Пример функции для включения/выключения отображения ника
function toggleShowName()
    showName = not showName
end

-- Пример функции для включения/выключения отображения дистанции
function toggleShowDistance()
    showDistance = not showDistance
end

-- Пример функции для включения/выключения отображения здоровья
function toggleShowHealth()
    showHealth = not showHealth
end

function setTextPosition(position)
    if TextPosition[position] then
        currentTextPosition = TextPosition[position]
    end
end
