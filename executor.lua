local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FancyExecutorUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 150, 250)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 70, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 70))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

local tweenService = game:GetService("TweenService")
local function loopGradient()
    gradient.Rotation = 0
    local tween = tweenService:Create(gradient, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    tween:Play()
end
loopGradient()

local glow = Instance.new("ImageLabel")
glow.Size = UDim2.new(1.2, 0, 1.2, 0)
glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://1316045217"
glow.ImageColor3 = Color3.fromRGB(150, 150, 250)
glow.ImageTransparency = 0.7
glow.ScaleType = Enum.ScaleType.Slice
glow.SliceCenter = Rect.new(10, 10, 118, 118)
glow.Parent = mainFrame

local particleFrame = Instance.new("Frame")
particleFrame.Size = UDim2.new(1, 0, 1, 0)
particleFrame.BackgroundTransparency = 1
particleFrame.ClipsDescendants = true
particleFrame.Parent = mainFrame

local function createParticle()
    local particle = Instance.new("ImageLabel")
    particle.Size = UDim2.new(0.05, 0, 0.05, 0)
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundTransparency = 1
    particle.Image = "rbxassetid://7074962988"
    particle.ImageColor3 = Color3.fromRGB(255, 255, 255)
    particle.ImageTransparency = 0.8
    particle.Parent = particleFrame

    local targetPosition = UDim2.new(particle.Position.X.Scale + math.random(-20, 20) / 100, 0, particle.Position.Y.Scale + math.random(-20, 20) / 100, 0)
    local tween = tweenService:Create(particle, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {Position = targetPosition, ImageTransparency = 1})
    tween:Play()

    tween.Completed:Connect(function() particle:Destroy() end)
end

while true do
    createParticle()
    wait(0.2)
end

local execButton = Instance.new("TextButton")
execButton.Text = "Execute"
execButton.Font = Enum.Font.GothamBold
execButton.Size = UDim2.new(0.8, 0, 0.1, 0)
execButton.Position = UDim2.new(0.1, 0, 0.85, 0)
execButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
execButton.TextColor3 = Color3.fromRGB(255, 255, 255)
execButton.Parent = mainFrame

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0.03, 0)
execCorner.Parent = execButton

execButton.MouseEnter:Connect(function()
    tweenService:Create(execButton, TweenInfo.new(0.2), {Size = UDim2.new(0.83, 0, 0.11, 0)}):Play()
end)

execButton.MouseLeave:Connect(function()
    tweenService:Create(execButton, TweenInfo.new(0.2), {Size = UDim2.new(0.8, 0, 0.1, 0)}):Play()
end)

execButton.MouseButton1Click:Connect(function()
    local success, result = pcall(function()
        loadstring("print('Executing Script in Fancy UI!')")()
    end)
    if success then
        print("Script executed successfully.")
    else
        warn("Error executing script: " .. result)
    end
end)
