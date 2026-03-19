-- [[ СЕРВИСЫ ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

_G.Config = {
    NoClip = false, InfJump = false, Speed = 16,
    EspSkeleton = false, EspNames = false, ShowFPS = false
}

-- [[ ИНТЕРФЕЙС ]] --
if CG:FindFirstChild("MirrorNeon") then CG.MirrorNeon:Destroy() end
local Gui = Instance.new("ScreenGui", CG); Gui.Name = "MirrorNeon"

-- FPS COUNTER (ВИЗУАЛ)
local FPSLabel = Instance.new("TextLabel", Gui)
FPSLabel.Size = UDim2.new(0, 80, 0, 30); FPSLabel.Position = UDim2.new(0, 10, 0, 10)
FPSLabel.BackgroundTransparency = 0.5; FPSLabel.BackgroundColor3 = Color3.new(0,0,0)
FPSLabel.TextColor3 = Color3.new(0, 1, 0.5); FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 14; FPSLabel.Visible = false; Instance.new("UICorner", FPSLabel)

-- АНИМАЦИЯ
local IntroText = Instance.new("TextLabel", Gui)
IntroText.Size = UDim2.new(1, 0, 1, 0); IntroText.BackgroundTransparency = 1; IntroText.Text = "M"; IntroText.TextColor3 = Color3.new(1, 1, 1); IntroText.Font = Enum.Font.GothamBold; IntroText.TextSize = 1; IntroText.TextTransparency = 1

-- КНОПКА M
local MIcon = Instance.new("TextButton", Gui)
MIcon.Size = UDim2.new(0, 50, 0, 50); MIcon.Position = UDim2.new(0, 10, 0.5, -25); MIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25); MIcon.Text = "M"; MIcon.TextColor3 = Color3.new(1,1,1); MIcon.Font = Enum.Font.GothamBold; MIcon.Visible = false; MIcon.Draggable = true; Instance.new("UICorner", MIcon).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", MIcon).Color = Color3.fromRGB(0, 150, 255)

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 420, 0, 300); Main.Position = UDim2.new(0.5, -210, 0.5, -150); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Visible = false; Main.Draggable = true; Main.Active = true; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12); local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 150, 255)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 100, 1, -20); Sidebar.Position = UDim2.new(0, 10, 0, 10); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -130, 1, -20); Container.Position = UDim2.new(0, 120, 0, 10); Container.BackgroundTransparency = 1

local function NewTab(name)
    local f = Instance.new("ScrollingFrame", Container); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.ScrollBarThickness = 0
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 8); local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end f.Visible = true end)
    return f
end

local TabMove = NewTab("Move"); local TabVis = NewTab("Visuals"); local TabSett = NewTab("Settings")
TabMove.Visible = true

local function AddToggle(text, tab, key)
    local b = Instance.new("TextButton", tab); b.Size = UDim2.new(1, -5, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.Text = "  " .. text; b.TextColor3 = Color3.new(0.7,0.7,0.7); b.TextXAlignment = "Left"; b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local ind = Instance.new("Frame", b); ind.Size = UDim2.new(0, 8, 0, 8); ind.Position = UDim2.new(1, -20, 0.5, -4); ind.BackgroundColor3 = _G.Config[key] and Color3.new(0, 0.7, 1) or Color3.new(0.3, 0.3, 0.3); Instance.new("UICorner", ind)
    b.MouseButton1Click:Connect(function() 
        _G.Config[key] = not _G.Config[key]
        ind.BackgroundColor3 = _G.Config[key] and Color3.new(0, 0.7, 1) or Color3.new(0.3, 0.3, 0.3)
        if key == "ShowFPS" then FPSLabel.Visible = _G.Config[key] end
    end)
end

-- НАПОЛНЕНИЕ
AddToggle("NoClip", TabMove, "NoClip"); AddToggle("Infinity Jump", TabMove, "InfJump")
AddToggle("Skeleton (High)", TabVis, "EspSkeleton"); AddToggle("Nicknames", TabVis, "EspNames")
AddToggle("Show FPS", TabSett, "ShowFPS"); Instance.new("TextLabel", TabSett).Text = "Dev: cepde4ko"; TabSett:GetChildren()[#TabSett:GetChildren()].Size = UDim2.new(1,0,0,30); TabSett:GetChildren()[#TabSett:GetChildren()].TextColor3 = Color3.new(0.4,0.4,0.4); TabSett:GetChildren()[#TabSett:GetChildren()].BackgroundTransparency = 1

-- [[ ЛОГИКА FPS ]] --
local lastTime = tick()
local frameCount = 0
RS.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        FPSLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastTime = tick()
    end
end)

-- [[ MOVEMENT & JUMP ]] --
RS.Stepped:Connect(function()
    if LP.Character and _G.Config.NoClip then
        for _, v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

UIS.JumpRequest:Connect(function()
    if _G.Config.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- [[ АНИМАЦИЯ И УПРАВЛЕНИЕ ]] --
task.spawn(function()
    TS:Create(IntroText, TweenInfo.new(0.6), {TextSize = 80, TextTransparency = 0}):Play(); task.wait(0.7)
    IntroText.Text = "MIRROR"; TS:Create(IntroText, TweenInfo.new(0.6), {TextSize = 40}):Play(); task.wait(1)
    TS:Create(IntroText, TweenInfo.new(0.4), {TextTransparency = 1}):Play(); task.wait(0.4)
    IntroText:Destroy(); Main.Visible = true; TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 420, 0, 300)}):Play()
end)

MIcon.MouseButton1Click:Connect(function() MIcon.Visible = false; Main.Visible = true end)
Instance.new("TextButton", Main).Size = UDim2.new(0,30,0,30); Main:GetChildren()[#Main:GetChildren()].Position = UDim2.new(1,-35,0,5); Main:GetChildren()[#Main:GetChildren()].Text = "✕"; Main:GetChildren()[#Main:GetChildren()].TextColor3 = Color3.new(1,0,0); Main:GetChildren()[#Main:GetChildren()].BackgroundTransparency = 1; Main:GetChildren()[#Main:GetChildren()].MouseButton1Click:Connect(function() Gui:Destroy() end)
local Mini = Instance.new("TextButton", Main); Mini.Size = UDim2.new(0,30,0,30); Mini.Position = UDim2.new(1,-65,0,5); Mini.Text = "—"; Mini.TextColor3 = Color3.new(1,1,1); Mini.BackgroundTransparency = 1; Mini.MouseButton1Click:Connect(function() Main.Visible = false; MIcon.Visible = true end)
