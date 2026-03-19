-- [[ MIRROR DELUXE - ANTI-DETECTION EDITION ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

-- [[ КОНФИГ ]] --
_G.Config = {
    NoClip = false,
    InfJump = false,
    Speed = 16,
    EspSkeleton = false,
    EspNames = false,
    ShowFPS = false
}

-- [[ БЕЗОПАСНЫЙ ИНТЕРФЕЙС ]] --
-- Пытаемся спрятать GUI от игровых скриптов
local ProtectGui = (gethui and gethui()) or CG
if ProtectGui:FindFirstChild("MirrorNeon") then ProtectGui.MirrorNeon:Destroy() end
local Gui = Instance.new("ScreenGui", ProtectGui); Gui.Name = "MirrorNeon"

-- ФУНКЦИЯ ПЛАВНОЙ АНИМАЦИИ (Твоя любимая M -> MIRROR)
local function CreateIntro()
    local Intro = Instance.new("TextLabel", Gui)
    Intro.Size = UDim2.new(1, 0, 1, 0); Intro.BackgroundTransparency = 1
    Intro.Text = "M"; Intro.TextColor3 = Color3.new(1, 1, 1)
    Intro.Font = Enum.Font.GothamBold; Intro.TextSize = 80; Intro.TextTransparency = 1
    
    task.spawn(function()
        TS:Create(Intro, TweenInfo.new(1), {TextTransparency = 0}):Play()
        task.wait(1)
        Intro.Text = "MIRROR"
        task.wait(1.5)
        TS:Create(Intro, TweenInfo.new(1), {TextTransparency = 1}):Play()
        task.wait(1); Intro:Destroy()
    end)
end

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 420, 0, 300); Main.Position = UDim2.new(0.5, -210, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Main.Visible = false; Main.Draggable = true; Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 150, 255)

-- КНОПКА M
local MIcon = Instance.new("TextButton", Gui)
MIcon.Size = UDim2.new(0, 50, 0, 50); MIcon.Position = UDim2.new(0, 15, 0.5, -25)
MIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 35); MIcon.Text = "M"; MIcon.TextColor3 = Color3.new(1,1,1)
MIcon.Font = Enum.Font.GothamBold; MIcon.Visible = false; MIcon.Draggable = true; MIcon.Active = true
Instance.new("UICorner", MIcon).CornerRadius = UDim.new(1, 0)

-- ВКЛАДКИ
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 100, 1, -20); Sidebar.Position = UDim2.new(0, 10, 0, 10); Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -130, 1, -20); Container.Position = UDim2.new(0, 120, 0, 10); Container.BackgroundTransparency = 1

local function NewTab(name)
    local f = Instance.new("ScrollingFrame", Container); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.ScrollBarThickness = 0
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 8)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
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
    end)
end

-- НАПОЛНЕНИЕ
AddToggle("NoClip", TabMove, "NoClip"); AddToggle("Infinity Jump", TabMove, "InfJump")
AddToggle("Skeleton (Highlight)", TabVis, "EspSkeleton"); AddToggle("Nicknames", TabVis, "EspNames")
Instance.new("TextLabel", TabSett).Text = "Dev: cepde4ko"; TabSett:GetChildren()[1].BackgroundTransparency = 1; TabSett:GetChildren()[1].TextColor3 = Color3.new(0.5,0.5,0.5); TabSett:GetChildren()[1].Size = UDim2.new(1,0,0,30)

-- [[ ОСНОВНАЯ ЛОГИКА (БЕЗОПАСНАЯ) ]] --

-- ESP
RS.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character then
            -- Nicknames
            local tag = v.Character:FindFirstChild("MirrorTag")
            if _G.Config.EspNames and v.Character:FindFirstChild("Head") then
                if not tag then
                    tag = Instance.new("BillboardGui", v.Character); tag.Name = "MirrorTag"; tag.Adornee = v.Character.Head; tag.Size = UDim2.new(0,100,0,50); tag.AlwaysOnTop = true; tag.ExtentsOffset = Vector3.new(0,3,0)
                    local tl = Instance.new("TextLabel", tag); tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1; tl.Text = v.Name; tl.TextColor3 = Color3.new(1,1,1); tl.Font = Enum.Font.GothamBold; tl.TextSize = 14
                end
            elseif tag then tag:Destroy() end

            -- Skeleton (Highlight)
            local high = v.Character:FindFirstChild("MirrorSkel")
            if _G.Config.EspSkeleton then
                if not high then
                    high = Instance.new("Highlight", v.Character); high.Name = "MirrorSkel"; high.FillTransparency = 1; high.OutlineColor = Color3.new(0, 0.7, 1); high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif high then high:Destroy() end
        end
    end
end)

-- Movement
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

-- [[ ЗАПУСК ]] --
CreateIntro()
task.wait(3.5)
Main.Visible = true
Main.Size = UDim2.new(0,0,0,0)
TS:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0, 420, 0, 300)}):Play()

-- Управление кнопками
MIcon.MouseButton1Click:Connect(function() MIcon.Visible = false; Main.Visible = true end)
local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5); Close.Text = "✕"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.MouseButton1Click:Connect(function() Gui:Destroy() end)
local Mini = Instance.new("TextButton", Main); Mini.Size = UDim2.new(0,30,0,30); Mini.Position = UDim2.new(1,-65,0,5); Mini.Text = "—"; Mini.TextColor3 = Color3.new(1,1,1); Mini.BackgroundTransparency = 1; Mini.MouseButton1Click:Connect(function() Main.Visible = false; MIcon.Visible = true end)
