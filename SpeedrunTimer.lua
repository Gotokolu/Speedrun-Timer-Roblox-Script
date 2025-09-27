-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedrunTimerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5,0,0.4,0)
frame.Position = UDim2.new(0.25,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(25,20,35)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Gradient + Stroke + Corner
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(35,25,55)),ColorSequenceKeypoint.new(1,Color3.fromRGB(25,20,35))})
grad.Rotation = 90
grad.Parent = frame
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(140,60,255)
stroke.Thickness = 2
stroke.Parent = frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = frame

-- Shadow
local shadow = Instance.new("ImageLabel")
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

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0.15,0)
titleBar.BackgroundColor3 = Color3.fromRGB(35,25,55)
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(45,35,65)),ColorSequenceKeypoint.new(1,Color3.fromRGB(35,25,55))})
titleGrad.Rotation = 90
titleGrad.Parent = titleBar
local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0,10)
barCorner.Parent = titleBar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8,0,1,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200,180,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Text = "⚡ Speedrun Timer"
title.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.15,0,1,0)
closeBtn.Position = UDim2.new(0.85,0,0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,6)
closeCorner.Parent = closeBtn
local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(140,60,255)
closeStroke.Thickness = 1
closeStroke.Transparency = 0.5
closeStroke.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Timer Label
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1,0,0.25,0)
timerLabel.Position = UDim2.new(0,0,0.15,0)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(120,255,200)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextScaled = true
timerLabel.Text = "00:00.00"
timerLabel.Parent = frame

-- Splits
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

-- Timer logic
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

local function splitTimer()
    if running then
        local currentTime = os.clock() - startTime
        splitCount += 1
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-10,0,25)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(200,180,255)
        lbl.Font = Enum.Font.Gotham
        lbl.TextScaled = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = string.format("Split %d: %s", splitCount, formatTime(currentTime))
        lbl.Parent = splitsFrame
        splitsFrame.CanvasSize = UDim2.new(0,0,0,splitsLayout.AbsoluteContentSize.Y)
    end
end

local function resetTimer()
    running = false
    startTime = 0
    elapsedTime = 0
    timerLabel.Text = "00:00.00"
    splitCount = 0
    for _, c in ipairs(splitsFrame:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    splitsFrame.CanvasSize = UDim2.new(0,0,0,0)
end

-- Update timer
RunService.Heartbeat:Connect(function()
    if running then
        timerLabel.Text = formatTime(os.clock() - startTime)
    end
end)

-- Buttons
local function createBtn(text,pos,callback)
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
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createBtn("▶ Start", UDim2.new(0.03,0,0.45,0), startTimer)
createBtn("⏺ Split", UDim2.new(0.26,0,0.45,0), splitTimer)
createBtn("⏸ Stop", UDim2.new(0.49,0,0.45,0), stopTimer)
createBtn("🔄 Reset", UDim2.new(0.72,0,0.45,0), resetTimer)

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.KeyCode==Enum.KeyCode.Space then
        if running then stopTimer() else startTimer() end
    elseif input.KeyCode==Enum.KeyCode.S then
        splitTimer()
    elseif input.KeyCode==Enum.KeyCode.R then
        resetTimer()
    end
    end
