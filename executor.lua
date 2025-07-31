local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local userInputService = game:GetService("UserInputService")

-- ScreenGUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FancyExecutorUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.7, 0, 0.6, 0)
mainFrame.Position = UDim2.new(0.15, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true -- 必须激活以使拖动/缩放生效
mainFrame.Parent = screenGui

-- 圆角效果
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0.03, 0)
frameCorner.Parent = mainFrame

-- 渐变背景
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 70))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Text = "✖"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = mainFrame

-- 圆角效果
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.3, 0)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() -- 销毁整个界面
end)

local dragging, dragStart, startPosition
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = UDim2.new(
            (input.Position.X - dragStart.X) / workspace.CurrentCamera.ViewportSize.X, 0,
            (input.Position.Y - dragStart.Y) / workspace.CurrentCamera.ViewportSize.Y, 0
        )
        mainFrame.Position = startPosition + delta
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0.6, 0, 0.05, 0)
sliderFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderFrame.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0.2, 0)
sliderCorner.Parent = sliderFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.5, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
sliderBar.Parent = sliderFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0.2, 0)
barCorner.Parent = sliderBar

sliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        userInputService.InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                local scale = math.clamp((moveInput.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                sliderBar.Size = UDim2.new(scale, 0, 1, 0)
                mainFrame.BackgroundTransparency = 1 - scale
            end
        end)
    end
end)

local colorPicker = Instance.new("TextButton")
colorPicker.Text = "🎨"
colorPicker.Font = Enum.Font.GothamBold
colorPicker.TextSize = 14
colorPicker.Size = UDim2.new(0.1, 0, 0.05, 0)
colorPicker.Position = UDim2.new(0.8, 0, 0.1, 0)
colorPicker.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
colorPicker.TextColor3 = Color3.fromRGB(255, 255, 255)
colorPicker.Parent = mainFrame

local pickerCorner = Instance.new("UICorner")
pickerCorner.CornerRadius = UDim.new(0.2, 0)
pickerCorner.Parent = colorPicker

colorPicker.MouseButton1Click:Connect(function()
    mainFrame.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end)

local logFrame = Instance.new("ScrollingFrame")
logFrame.Name = "LogFrame"
logFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
logFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
logFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
logFrame.BackgroundTransparency = 0.1
logFrame.BorderSizePixel = 0
logFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0) -- 可滚动区域大小
logFrame.ScrollBarThickness = 5
logFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
logFrame.Parent = mainFrame

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0.03, 0)
logCorner.Parent = logFrame

local sampleLog = Instance.new("TextLabel")
sampleLog.Name = "SampleLog"
sampleLog.Size = UDim2.new(1, -10, 0, 25) -- 宽度随父容器，但高度固定
sampleLog.Position = UDim2.new(0, 5, 0, 5)
sampleLog.Text = "[系统] 日志已加载。"
sampleLog.Font = Enum.Font.Gotham
sampleLog.TextSize = 14
sampleLog.TextColor3 = Color3.fromRGB(180, 180, 180)
sampleLog.TextXAlignment = Enum.TextXAlignment.Left
sampleLog.BackgroundTransparency = 1
sampleLog.Parent = logFrame

-- 自动填充日志的功能，可以动态添加日志：
function addLog(logText)
    local newLog = sampleLog:Clone()
    newLog.Text = logText
    newLog.Position = UDim2.new(0, 5, 0, #logFrame:GetChildren() * 30) -- 每个日志下移
    newLog.Parent = logFrame
end

-- 示例日志:
addLog("[系统] 界面初始化完成。")

local executeButton = Instance.new("TextButton")
executeButton.Text = "运行脚本"
executeButton.Font = Enum.Font.GothamBold
executeButton.TextSize = 16
executeButton.Size = UDim2.new(0.3, 0, 0.08, 0)
executeButton.Position = UDim2.new(0.35, 0, 0.9, 0)
executeButton.BackgroundColor3 = Color3.fromRGB(75, 175, 75)
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.Parent = mainFrame

local executeCorner = Instance.new("UICorner")
executeCorner.CornerRadius = UDim.new(0.2, 0)
executeCorner.Parent = executeButton

-- 点击执行脚本的逻辑
executeButton.MouseButton1Click:Connect(function()
    addLog("[运行中] 你的脚本已执行。")
    -- 你可以在这里插入具体脚本逻辑
    wait(1)
    addLog("[完成] 脚本运行成功！")
end)

local resetButton = Instance.new("TextButton")
resetButton.Text = "恢复默认"
resetButton.Font = Enum.Font.GothamBold
resetButton.TextSize = 14
resetButton.Size = UDim2.new(0.3, 0, 0.08, 0)
resetButton.Position = UDim2.new(0.65, 0, 0.9, 0)
resetButton.BackgroundColor3 = Color3.fromRGB(175, 75, 75)
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.Parent = mainFrame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0.2, 0)
resetCorner.Parent = resetButton

-- 点击恢复默认设置的逻辑
resetButton.MouseButton1Click:Connect(function()
    mainFrame.BackgroundTransparency = 0 -- 恢复无透明度
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- 恢复默认颜色
    addLog("[系统] 已恢复默认界面设置。")
end)
