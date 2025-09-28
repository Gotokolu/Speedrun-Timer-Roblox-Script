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
frame.Size = UDim2.new(0.5, 0, 0.3, 0)
frame.Position = UDim2.new(0.25, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Gradient + Stroke
local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35,25,55)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25,20,35))
}
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
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45,35,65)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35,25,55))
}
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0,10)
barCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7,0,1,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200,180,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Text = "⚡ Speedrun Timer"
title.TextTransparency = 1
title.Parent = titleBar

-- Bouton Close
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

local closeBtn = createControlBtn("X", UDim2.new(0.85,0,0,0), Color3.fromRGB(180,60,200))
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Label Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1,0,0.4,0)
timerLabel.Position = UDim2.new(0,0,0.15,0)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(120,255,200)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextScaled = true
timerLabel.Text = "00:00.00"
timerLabel.TextTransparency = 1
timerLabel.Parent = frame

-- Fonctions Timer
local running = false
local startTime = 0
local elapsedTime = 0

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

local function resetTimer()
    running = false
    startTime = 0
    elapsedTime = 0
    timerLabel.Text = "00:00.00"
end

-- Update Timer
RunService.Heartbeat:Connect(function()
    if running then
        timerLabel.Text = formatTime(os.clock() - startTime)
    end
end)

-- Frame des boutons
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1,0,0.25,0)
buttonsFrame.Position = UDim2.new(0,0,0.55,0)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Padding = UDim.new(0.05,0)
listLayout.Parent = buttonsFrame

-- Création des boutons Start / Stop / Reset
local function createTimerButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25,0,1,0)
    btn.BackgroundColor3 = Color3.fromRGB(120,60,200)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = buttonsFrame
    return btn
end

local startBtn = createTimerButton("▶ Start")
local stopBtn  = createTimerButton("⏸ Stop")
local resetBtn = createTimerButton("🔄 Reset")

startBtn.MouseButton1Click:Connect(startTimer)
stopBtn.MouseButton1Click:Connect(stopTimer)
resetBtn.MouseButton1Click:Connect(resetTimer)

-- Hover Effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = normalColor
    end)
end

local btnNormal = Color3.fromRGB(120,60,200)
local btnHover  = Color3.fromRGB(160,100,255)
local closeNormal = Color3.fromRGB(180,60,200)
local closeHover  = Color3.fromRGB(255,60,60)

addHoverEffect(startBtn, btnNormal, btnHover)
addHoverEffect(stopBtn, btnNormal, btnHover)
addHoverEffect(resetBtn, btnNormal, btnHover)
addHoverEffect(closeBtn, closeNormal, closeHover)

-- Click Pop Effect
local function addClickPop(button)
    button.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenUp = TweenService:Create(button, tweenInfo, {Size = button.Size * 1.1})
        local tweenDown = TweenService:Create(button, tweenInfo, {Size = button.Size})
        tweenUp:Play()
        tweenUp.Completed:Connect(function()
            tweenDown:Play()
        end)
    end)
end

addClickPop(startBtn)
addClickPop(stopBtn)
addClickPop(resetBtn)
addClickPop(closeBtn)

-- Petit clic discret style Blox Build A Boat
local function addClickSound(button)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1842220556" -- ID du petit clic discret
    sound.Volume = 0.5
    sound.Parent = button

    button.MouseButton1Click:Connect(function()
        sound:Play()
    end)
end

addClickSound(startBtn)
addClickSound(stopBtn)
addClickSound(resetBtn)
addClickSound(closeBtn)

-- Raccourcis clavier
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        if running then stopTimer() else startTimer() end
    elseif input.KeyCode == Enum.KeyCode.R then
        resetTimer()
    end
end)

-- Fade-in global
local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(frame,fadeInfo,{BackgroundTransparency=0}):Play()
TweenService:Create(titleBar,fadeInfo,{BackgroundTransparency=0}):Play()
TweenService:Create(timerLabel,fadeInfo,{TextTransparency=0}):Play()
TweenService:Create(title,fadeInfo,{TextTransparency=0}):Play()
TweenService:Create(startBtn,fadeInfo,{BackgroundTransparency=0}):Play()
TweenService:Create(stopBtn,fadeInfo,{BackgroundTransparency=0}):Play()
TweenService:Create(resetBtn,fadeInfo,{BackgroundTransparency=0}):Play()
TweenService:Create(closeBtn,fadeInfo,{BackgroundTransparency=0,TextTransparency=0}):Play()
