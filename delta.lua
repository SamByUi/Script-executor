local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "DeltaLikeExecutorUI_Mobile"

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            dragInput = input
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
        end
    end)
end

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(550, 380)
main.Position = UDim2.new(0.5, -265, 0.4, -160)
main.BackgroundColor3 = Color3.fromRGB(30,32,35)
main.BorderSizePixel = 0
main.Active = true

local topbar = Instance.new("Frame", main)
topbar.BackgroundColor3 = Color3.fromRGB(25,25,32)
topbar.Size = UDim2.new(1, 0, 0, 38)
topbar.BorderSizePixel = 0
topbar.Active = true

local title = Instance.new("TextLabel", topbar)
title.Text = "Delta Like Executor"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(50,220,180)
title.TextSize = 22
title.BackgroundTransparency = 1
title.Position = UDim2.new(0,15,0,0)
title.Size = UDim2.new(1,-60,1,0)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", topbar)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255,75,75)
closeBtn.BackgroundTransparency = 1
closeBtn.Size = UDim2.new(0,38,1,0)
closeBtn.Position = UDim2.new(1,-44,0,0)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

makeDraggable(main, topbar)

local minimizeBtn = Instance.new("TextButton", topbar)
minimizeBtn.Text = "▢"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 22
minimizeBtn.TextColor3 = Color3.fromRGB(55,170,255)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Size = UDim2.new(0,38,1,0)
minimizeBtn.Position = UDim2.new(1,-82,0,0)

local miniWindow = Instance.new("TextButton")
miniWindow.Text = "☰"
miniWindow.Visible = false
miniWindow.Font = Enum.Font.GothamBold
miniWindow.TextSize = 36
miniWindow.TextColor3 = Color3.fromRGB(0,230,200)
miniWindow.Size = UDim2.fromOffset(56,56)
miniWindow.Position = UDim2.new(0, 16, 1, -72)
miniWindow.BackgroundColor3 = Color3.fromRGB(28,36,45)
miniWindow.Parent = gui
miniWindow.BorderSizePixel = 0

minimizeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    miniWindow.Visible = true
end)
miniWindow.MouseButton1Click:Connect(function()
    main.Visible = true
    miniWindow.Visible = false
end)

local tabScroll = Instance.new("ScrollingFrame", main)
tabScroll.Name = "TabScroll"
tabScroll.Position = UDim2.new(0,0,0,38)
tabScroll.Size = UDim2.new(1,0,0,36)
tabScroll.BackgroundColor3 = Color3.fromRGB(23, 30, 35)
tabScroll.BorderSizePixel = 0
tabScroll.ScrollingDirection = Enum.ScrollingDirection.X
tabScroll.CanvasSize = UDim2.new(0,0,1,0)
tabScroll.ScrollBarThickness = 5
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
tabScroll.ClipsDescendants = true

local tabs = {}
local tabContentFrames = {}
local curTab = 1

local function selectTab(idx)
    for i,v in ipairs(tabContentFrames) do
        v.Visible = (i == idx)
        tabs[i].TabBtn.BackgroundColor3 = (i==idx) and Color3.fromRGB(35, 80, 90) or Color3.fromRGB(26,42,50)
    end
    curTab = idx
end

local function removeTab(idx)
    if #tabs <= 1 then return end
    tabs[idx].TabBtn:Destroy()
    tabContentFrames[idx]:Destroy()
    table.remove(tabs, idx)
    table.remove(tabContentFrames, idx)
    for i,info in ipairs(tabs) do
        info.TabBtn.Position = UDim2.new(0, (i-1)*122, 0, 0)
        info.Idx = i
        info.CloseBtn.TagIdx = i
    end
    if curTab > #tabs then curTab = #tabs end
    selectTab(curTab)
end

local function createTab(name)
    local idx = #tabs + 1

    local tabBtn = Instance.new("Frame", tabScroll)
    tabBtn.Size = UDim2.new(0,120,1,0)
    tabBtn.Position = UDim2.new(0, (idx-1)*122, 0, 0)
    tabBtn.BackgroundColor3 = (idx==1) and Color3.fromRGB(35,80,90) or Color3.fromRGB(26,42,50)
    tabBtn.BorderSizePixel = 0

    local tabText = Instance.new("TextButton", tabBtn)
    tabText.Size = UDim2.new(1,-22,1,0)
    tabText.Position = UDim2.new(0,0,0,0)
    tabText.BackgroundTransparency = 1
    tabText.Text = name
    tabText.Font = Enum.Font.GothamSemibold
    tabText.TextSize = 16
    tabText.TextColor3 = Color3.fromRGB(200,255,235)
    tabText.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", tabBtn)
    closeBtn.Text = "✖"
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 15
    closeBtn.TextColor3 = Color3.fromRGB(255,60,60)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0,20,0,20)
    closeBtn.Position = UDim2.new(1,-20,0,2)
    closeBtn.ZIndex = 2
    closeBtn.TagIdx = idx
    closeBtn.MouseButton1Click:Connect(function()
        if closeBtn.TagIdx <= #tabs then
            removeTab(closeBtn.TagIdx)
        end
    end)

    tabText.MouseButton1Click:Connect(function()
        selectTab(idx)
    end)

    local fr = Instance.new("Frame", main)
    fr.BackgroundTransparency = 1
    fr.Size = UDim2.new(1,-24,1,-130)
    fr.Position = UDim2.new(0,12,0,74)
    fr.Visible = (idx==1)
    local scroll = Instance.new("ScrollingFrame", fr)
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.BorderSizePixel = 0
    scroll.BackgroundColor3 = Color3.fromRGB(40,44,52)
    scroll.ScrollBarThickness = 10
    scroll.Name = "ScriptScroll"
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local tb = Instance.new("TextBox", scroll)
    tb.Size = UDim2.new(1,-12,0,9999)
    tb.Position = UDim2.new(0,6,0,6)
    tb.MultiLine = true
    tb.TextWrapped = false
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.TextYAlignment = Enum.TextYAlignment.Top
    tb.Font = Enum.Font.Code
    tb.TextSize = 18
    tb.TextColor3 = Color3.fromRGB(180,255,225)
    tb.BackgroundTransparency = 1
    tb.ClearTextOnFocus = false
    tb.Text = ""
    tb.ClipsDescendants = true
    tb.AutomaticSize = Enum.AutomaticSize.Y
    tb.Name = "ScriptBox"
    fr.Name = name

    tabs[idx] = {TabBtn = tabBtn, CloseBtn = closeBtn, Idx = idx}
    tabContentFrames[idx] = fr

    tabScroll.CanvasSize = UDim2.new(0, (#tabs)*122+44, 0, 0)
    return idx
end

createTab("脚本1")
createTab("脚本2")

local addTabBtn = Instance.new("TextButton", tabScroll)
addTabBtn.Text = "+"
addTabBtn.Font = Enum.Font.GothamBold
addTabBtn.TextSize = 21
addTabBtn.Size = UDim2.new(0, 38, 1, -4)
addTabBtn.Position = UDim2.new(0, #tabs*122, 0, 0)
addTabBtn.BackgroundColor3 = Color3.fromRGB(46,85,100)
addTabBtn.TextColor3 = Color3.fromRGB(255,255,200)
addTabBtn.BorderSizePixel = 0
addTabBtn.AutoButtonColor = true
addTabBtn.MouseButton1Click:Connect(function()
    local idx = createTab("脚本"..tostring(#tabs+1))
    addTabBtn.Position = UDim2.new(0, #tabs*122, 0, 0)
    tabScroll.CanvasSize = UDim2.new(0, (#tabs)*122+44, 0, 0)
    selectTab(idx)
end)

local clearBtn = Instance.new("TextButton", main)
clearBtn.Text = "清空"
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 18
clearBtn.Size = UDim2.new(0,85,0,36)
clearBtn.Position = UDim2.new(0, 18, 1, -55)
clearBtn.BackgroundColor3 = Color3.fromRGB(65,80,100)
clearBtn.TextColor3 = Color3.new(1,1,1)
clearBtn.BorderSizePixel = 0

local saveBtn = clearBtn:Clone()
saveBtn.Parent = main
saveBtn.Position = UDim2.new(0, 110, 1, -55)
saveBtn.Text = "保存"

local loadBtn = clearBtn:Clone()
loadBtn.Parent = main
loadBtn.Position = UDim2.new(0, 202, 1, -55)
loadBtn.Text = "载入"

clearBtn.Parent = main

local execBtn = clearBtn:Clone()
execBtn.Parent = main
execBtn.Position = UDim2.new(1,-110,1,-55)
execBtn.Size = UDim2.new(0,100,0,36)
execBtn.Text = "执行"

local outputBox = Instance.new("TextBox", main)
outputBox.Size = UDim2.new(1,-26,0,44)
outputBox.Position = UDim2.new(0,13,1,-96)
outputBox.BackgroundColor3 = Color3.fromRGB(20,20,24)
outputBox.TextColor3 = Color3.fromRGB(193,255,200)
outputBox.Text = "输出："
outputBox.ClearTextOnFocus = false
outputBox.Font = Enum.Font.GothamMono
outputBox.TextSize = 17
outputBox.TextXAlignment = Enum.TextXAlignment.Left
outputBox.TextYAlignment = Enum.TextYAlignment.Top
outputBox.TextWrapped = true
outputBox.TextEditable = false
outputBox.MultiLine = true
outputBox.AutomaticSize = Enum.AutomaticSize.None
outputBox.ClipsDescendants = true
outputBox.BorderSizePixel = 0

clearBtn.MouseButton1Click:Connect(function()
    local scriptBox = tabContentFrames[curTab]:FindFirstChild("ScriptScroll"):FindFirstChild("ScriptBox")
    scriptBox.Text = ""
    outputBox.Text = "输出："
end)

execBtn.MouseButton1Click:Connect(function()
    local scriptBox = tabContentFrames[curTab]:FindFirstChild("ScriptScroll"):FindFirstChild("ScriptBox")
    local code = scriptBox.Text
    if code and code:match("%S") then
        local f, err = loadstring(code)
        if f then
            local success, result = pcall(f)
            if success then
                outputBox.Text = "输出：\n" .. (result and tostring(result) or "脚本执行成功")
            else
                outputBox.Text = "错误：\n" .. tostring(result)
            end
        else
            outputBox.Text = "语法错误：\n" .. tostring(err)
        end
    else
        outputBox.Text = "输出：请先输入代码"
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    local scriptBox = tabContentFrames[curTab]:FindFirstChild("ScriptScroll"):FindFirstChild("ScriptBox")
    setclipboard(scriptBox.Text)  -- Roblox Studio窗口下有效
    outputBox.Text = "输出：已复制脚本到剪贴板"
end)

loadBtn.MouseButton1Click:Connect(function()
    local scriptBox = tabContentFrames[curTab]:FindFirstChild("ScriptScroll"):FindFirstChild("ScriptBox")
    scriptBox.Text = ""
    outputBox.Text = "输出：请手动粘贴脚本"
end)
