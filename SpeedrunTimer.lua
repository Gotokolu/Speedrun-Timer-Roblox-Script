-- Best Speedrun Timer Script
--// Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

--// GUI Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedrunTimerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

--// Frame Principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.4, 0)
frame.Position = UDim2.new(0.25, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Gradient + Stroke + Coins
local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(35,25,55)), ColorSequenceKeypoint.new(1, Color3.fromRGB(25,20,35))}
frameGradient.Rotation = 90
frameGradient.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(140, 60, 255)
frameStroke.Thickness = 2
frameStroke.Parent = frame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Shadow Glow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5,0.5)
shadow.Position = UDim2.new(0.5,0,0.5,0)
shadow.Size = UDim2.new(1.1,0,1.1,0)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(140,60,255)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.ZIndex = -1
shadow.Parent = frame

-- Barre de titre
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0.15,0)
titleBar.BackgroundColor3 = Color3.fromRGB(35,25,55)
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(45,35,65)), ColorSequenceKeypoint.new(1, Color3.fromRGB(35,25,55))}
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0,10)
barCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.55,0,1,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200,180,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Text = "⚡ Speedrun Timer"
title.TextTransparency = 1
title.Parent = titleBar

-- Fonctions boutons de contrôle (X, Fullscreen, Minimize)
local function createControlBtn(txt, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.15,0,1,0)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 1
    btn.Text = txt
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextTransparency = 1
    btn.Parent = titleBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,6)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(140,60,255)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn

    return btn
end

local fullscreenBtn = createControlBtn("⬜", UDim2.new(0.55,0,0,0), Color3.fromRGB(90,40,150))
local minimizeBtn = createControlBtn("-", UDim2.new(0.7,0,0,0), Color3.fromRGB(120,60,200))
local closeBtn = createControlBtn("X", UDim2.new(0.85,0,0,0), Color3.fromRGB(180,60,200))

-- Label Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1,0,0.25,0)
timerLabel.Position = UDim2.new(0,0,0.15,0)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(120,255,200)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextScaled = true
timerLabel.Text = "00:00.00"
timerLabel.TextTransparency = 1
timerLabel.Parent = frame

-- Section Splits
local splitsFrame = Instance.new("ScrollingFrame")
splitsFrame.Size = UDim2.new(1,0,0.25,0)
splitsFrame.Position = UDim2.new(0,0,0.75,0)
splitsFrame.BackgroundTransparency = 1
splitsFrame.BorderSizePixel = 0
splitsFrame.ScrollBarThickness = 4
splitsFrame.ScrollBarImageColor3 = Color3.fromRGB(140,60,255)
splitsFrame.Parent = frame

local splitsLayout = Instance.new("UIListLayout")
splitsLayout.Padding = UDim.new(0,5)
splitsLayout.SortOrder = Enum.SortOrder.LayoutOrder
splitsLayout.Parent = splitsFrame

-- Fonctions Timer
local running = false
local startTime = 0
local elapsedTime = 0
local splitCount = 0

local function formatTime(t)
    local m = math.floor(t/60)
    local s = math.floor(t%60)
    local cs = math.floor((t - math.floor(t)) * 100)
    return string.format("%02d:%02d.%02d", m,s,cs)
end

local function startTimer()
    if not running then
        startTime = os.clock() - elapsedTime
        running = true
    end
end

local function stopTimer()
    if running then
        elapsedTime = os.clock() - startTime
        running = false
    end
end

-- Fonction Split corrigée
local function splitTimer()
    if running then
        local currentTime = os.clock() - startTime
        splitCount = splitCount + 1

        local splitLabel = Instance.new("TextLabel")
        splitLabel.Size = UDim2.new(1, -10, 0, 25)
        splitLabel.Position = UDim2.new(0, 5, 0, 0)
        splitLabel.BackgroundTransparency = 1
        splitLabel.TextColor3 = Color3.fromRGB(200,180,255)
        splitLabel.Font = Enum.Font.Gotham
        splitLabel.TextScaled = true
        splitLabel.TextXAlignment = Enum.TextXAlignment.Left
        splitLabel.Text = string.format("Split %d: %s", splitCount, formatTime(currentTime))
        splitLabel.Parent = splitsFrame

        splitsFrame.CanvasSize = UDim2.new(0, 0, 0, splitsLayout.AbsoluteContentSize.Y)
    end
end

local function resetTimer()
    running = false
    startTime = 0
    elapsedTime = 0
    timerLabel.Text = "00:00.00"
    splitCount = 0
    for _, child in ipairs(splitsFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    splitsFrame.CanvasSize = UDim2.new(0,0,0,0)
end

-- Update Timer
RunService.Heartbeat:Connect(function()
    if running then
        timerLabel.Text = formatTime(os.clock() - startTime)
    end
end)

-- Boutons Start / Split / Stop / Reset
local function createTimerButton(text,pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.22,0,0.2,0)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(120,60,200)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = frame
    return btn
end

local startBtn = createTimerButton("▶ Start", UDim2.new(0.03,0,0.45,0))
local splitBtn = createTimerButton("⏺ Split", UDim2.new(0.26,0,0.45,0))
local stopBtn = createTimerButton("⏸ Stop", UDim2.new(0.49,0,0.45,0))
local resetBtn = createTimerButton("🔄 Reset", UDim2.new(0.72,0,0.45,0))

startBtn
