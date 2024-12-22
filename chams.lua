local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local runService = game:GetService("RunService")

-- Настройки
local isESPEnabled = false
local espColor = Color3.new(1, 0, 0)
local isFillTransparent = true -- true = 0 (прозрачный), false = 1 (непрозрачный)

local function createESPBox(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    highlight.Adornee = player.Character
    highlight.FillTransparency = isFillTransparent and 0 or 1 -- Преобразование булевой переменной в значение для FillTransparency

    if player.Team then
        highlight.OutlineColor = player.Team.TeamColor.Color
    else
        highlight.OutlineColor = espColor
    end
    
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
end

local function addESP()
    if not isESPEnabled then return end
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not player.Character:FindFirstChild(player.Name .. "_ESP") then
                createESPBox(player)
            end
        end
    end
end

runService.RenderStepped:Connect(function()
    addESP()
end)

players.PlayerRemoving:Connect(function(player)
    if player.Character and player.Character:FindFirstChild(player.Name .. "_ESP") then
        player.Character[player.Name .. "_ESP"]:Destroy()
    end
end)

local function toggleESP()
    isESPEnabled = not isESPEnabled
end

local function setESPColor(newColor)
    espColor = newColor
end

local function setFillTransparency(isTransparent)
    isFillTransparent = isTransparent
end
