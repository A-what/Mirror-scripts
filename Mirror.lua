-- [[ MIRROR DELUXE - FULL VERSION ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()

-- [[ ГЛОБАЛЬНЫЙ КОНФИГ ]] --
_G.Config = {
    NoClip = false,
    InfJump = false,
    Speed = 16,
    EspSkeleton = false, 
    EspNames = false,
    ShowFPS = false,
    FullBright = false
}

-- [[ ФУНКЦИИ ЗАЩИТЫ (BYPASS) ]] --
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
        return k == "WalkSpeed" and 16 or 50
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- [[ СОЗДАНИЕ ИНТЕРФЕЙСА ]] --
if CG:FindFirstChild("MirrorNeon") then CG.MirrorNeon:Destroy() end
local Gui = Instance.new("ScreenGui", CG); Gui.Name = "MirrorNeon"

-- СЧЕТЧИК FPS
local FPSLabel = Instance.new("TextLabel", Gui)
FPSLabel.Size = UDim2.new(0, 100, 0, 30); FPSLabel.Position = UDim2.new(0, 10, 0, 10)
FPSLabel.BackgroundColor3 = Color3.new(0,0,0); FPSLabel.BackgroundTransparency = 0.5
FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 150); FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 14; FPSLabel.Visible = false; Instance.new("UICorner", FPSLabel)

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 450, 0, 320)
Main.Position = UDim2.new(0.5, -225, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0; Main.Visible = false; Main.Draggable = true; Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(0, 150, 255); MainStroke.Thickness = 2

-- КНОПКА СВОРАЧИВАНИЯ (M)
local MIcon = Instance.new("TextButton", Gui)
MIcon.Size = UDim2.new(0, 60, 0, 60); MIcon.Position = UDim2.new(0, 15, 0.5, -30)
MIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25); MIcon.Text = "M"
MIcon.TextColor3 = Color3.new(1,1,1); MIcon.Font = Enum.Font.GothamBold; MIcon.TextSize = 25
MIcon.Visible = false; MIcon.Draggable = true; MIcon.Active = true
Instance.new("UICorner", MIcon).CornerRadius = UDim.new(1, 0)
local MStroke = Instance.new("UIStroke", MIcon); MStroke.Color = Color3.fromRGB(0, 150, 255)

-- САЙДБАР
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 110, 1, -20); Sidebar.Position = UDim2.new(0, 10, 0, 10)
Sidebar.BackgroundTransparency = 0.95; Instance.new("UICorner", Sidebar)
local SideList = Instance.new("UIListLayout", Sidebar); SideList.Padding = UDim.new(0, 5); SideList.HorizontalAlignment = "Center"

-- КОНТЕЙНЕР ДЛЯ ВКЛАДОК
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -140, 1, -50); Container.Position = UDim2.new(0, 130, 0, 40)
Container.BackgroundTransparency = 1

local function NewTab(name)
    local f = Instance.new("ScrollingFrame", Container)
    f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.ScrollBarThickness = 0; f.Name = name
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
    
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        f.Visible = true
    end)
    return f
end

local TabMove = NewTab("Movement")
local TabVis = NewTab("Visuals")
local TabSett = NewTab("Settings")
TabMove.Visible = true

-- КОМПОНЕНТ ТУМБЛЕРА
local function AddToggle(text, tab, key)
    local b = Instance.new("TextButton", tab)
    b.Size = UDim2.new(1, -10, 0, 40); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.Text = "  " .. text; b.TextColor3 = Color3.fromRGB(180, 180, 180); b.TextXAlignment = "Left"
    b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    
    local ind = Instance.new("Frame", b)
    ind.Size = UDim2.new(0, 24, 0, 12); ind.Position = UDim2.new(1, -35, 0.5, -6)
    ind.BackgroundColor3 = _G.Config[key] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
    
    b.MouseButton1Click:Connect(function()
        _G.Config[key] = not _G.Config[key]
        TS:Create(ind, TweenInfo.new(0.3), {BackgroundColor3 = _G.Config[key] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)}):Play()
        if key == "ShowFPS" then FPSLabel.Visible = _G.Config[key] end
    end)
end

-- [[ НАПОЛНЕНИЕ ]] --
AddToggle("NoClip (Wallhack)", TabMove, "NoClip")
AddToggle("Infinity Jump", TabMove, "InfJump")

local SpeedInput = Instance.new("TextBox", TabMove)
SpeedInput.Size = UDim2.new(1, -10, 0, 40); SpeedInput.PlaceholderText = "Speed [Default 16]"; SpeedInput.Text = ""
SpeedInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30); SpeedInput.TextColor3 = Color3.new(1,1,1); SpeedInput.Font = Enum.Font.Gotham; Instance.new("UICorner", SpeedInput)
SpeedInput.FocusLost:Connect(function() _G.Config.Speed = tonumber(SpeedInput.Text) or 16 end)

AddToggle("Skeleton ESP", TabVis, "EspSkeleton")
AddToggle("Player Names", TabVis, "EspNames")
AddToggle("FullBright", TabVis, "FullBright")

AddToggle("Display FPS", TabSett, "ShowFPS")
local Credits = Instance.new("TextLabel", TabSett)
Credits.Size = UDim2.new(1, 0, 0, 40); Credits.Text = "Developer: cepde4ko\nVersion: 5.2 Premium"; Credits.TextColor3 = Color3.new(0.5,0.5,0.5); Credits.BackgroundTransparency = 1; Credits.Font = Enum.Font.Gotham

-- [[ ОСНОВНАЯ ЛОГИКА ]] --

-- FPS Logic
local lastTime, fCount = tick(), 0
RS.RenderStepped:Connect(function()
    fCount = fCount + 1
    if tick() - lastTime >= 1 then
        FPSLabel.Text = "FPS: " .. fCount
        fCount = 0; lastTime = tick()
    end
end)

-- Visuals Logic
RS.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character then
            -- Names
            local head = v.Character:FindFirstChild("Head")
            local tag = v.Character:FindFirstChild("MirrorTag")
            if _G.Config.EspNames and head then
                if not tag then
                    tag = Instance.new("BillboardGui", v.Character); tag.Name = "MirrorTag"; tag.Adornee = head; tag.Size = UDim2.new(0,100,0,50); tag.AlwaysOnTop = true; tag.ExtentsOffset = Vector3.new(0,3,0)
                    local tl = Instance.new("TextLabel", tag); tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1; tl.Text = v.Name; tl.TextColor3 = Color3.new(1,1,1); tl.Font = Enum.Font.GothamBold; tl.TextSize = 14
                end
            elseif tag then tag:Destroy() end

            -- Skeleton (Highlight Method)
            local high = v.Character:FindFirstChild("MirrorSkel")
            if _G.Config.EspSkeleton then
                if not high then
                    high = Instance.new("Highlight", v.Character); high.Name = "MirrorSkel"; high.FillTransparency = 1; high.OutlineColor = Color3.fromRGB(0, 150, 255); high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif high then high:Destroy() end
        end
    end
end)

-- Movement Logic
RS.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        
        -- NoClip
        if _G.Config.NoClip then
            for _, v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        
        -- Speed (CFrame)
        if _G.Config.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * ((_G.Config.Speed - 16) / 50))
        end
    end
end)

-- Inf Jump
UIS.JumpRequest:Connect(function()
    if _G.Config.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- [[ АНИМАЦИИ ЗАКРЫТИЯ/ОТКРЫТИЯ ]] --
local function ToggleUI()
    if Main.Visible then
        local t = TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
        t:Play() t.Completed:Wait() Main.Visible = false; MIcon.Visible = true
    else
        MIcon.Visible = false; Main.Visible = true
        TS:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0, 450, 0, 320)}):Play()
    end
end

MIcon.MouseButton1Click:Connect(ToggleUI)
local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5); Close.Text = "✕"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.MouseButton1Click:Connect(function() Gui:Destroy() end)
local Mini = Instance.new("TextButton", Main); Mini.Size = UDim2.new(0,30,0,30); Mini.Position = UDim2.new(1,-65,0,5); Mini.Text = "—"; Mini.TextColor3 = Color3.new(1,1,1); Mini.BackgroundTransparency = 1; Mini.MouseButton1Click:Connect(ToggleUI)

-- [[ ИНТРО ]] --
local Intro = Instance.new("TextLabel", Gui)
Intro.Size = UDim2.new(1, 0, 1, 0); Intro.BackgroundTransparency = 1; Intro.Text = "MIRROR DELUXE"; Intro.TextColor3 = Color3.new(1,1,1); Intro.Font = Enum.Font.GothamBold; Intro.TextSize = 60; Intro.TextTransparency = 1
task.spawn(function()
    TS:Create(Intro, TweenInfo.new(1), {TextTransparency = 0}):Play(); task.wait(2)
    TS:Create(Intro, TweenInfo.new(1), {TextTransparency = 1}):Play(); task.wait(1)
    Intro:Destroy(); Main.Visible = true; Main.Size = UDim2.new(0,0,0,0)
    TS:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Back), {Size = UDim2.new(0, 450, 0, 320)}):Play()
end)
