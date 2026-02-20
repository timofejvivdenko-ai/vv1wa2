-- FULL ULTIMATE SCRIPT: Fixed Icon, Scrolling Menu, Chat, Sword, ESP, Spin, Fly, Speed, HP
local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Створюємо ScreenGui
local justguygui = Instance.new("ScreenGui")
justguygui.Name = "JustGuyMenu"
justguygui.ResetOnSpawn = false
justguygui.Parent = pgui

-- Основний Frame для меню (контейнер)
local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Parent = justguygui
Frame.BackgroundColor3 = Color3.fromRGB(255, 194, 51)
Frame.Position = UDim2.new(0.5, -231, 0.1, 0)
Frame.Size = UDim2.new(0, 463, 0, 500)
Frame.BorderSizePixel = 0
Frame.Active = true

-- --- ІКОНКА (Верхній правий кут) ---
local Icon = Instance.new("ImageLabel", Frame)
Icon.Name = "MenuIcon"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(1, -90, 0, -40) -- Виступає зверху
Icon.Size = UDim2.new(0, 80, 0, 80)
Icon.Image = "rbxassetid://10494531702"
Icon.ZIndex = 5

-- ScrollingFrame всередині основного фрейму
local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "BtnScroll"
Scroll.Parent = Frame
Scroll.BackgroundTransparency = 1
Scroll.Position = UDim2.new(0, 0, 0.1, 0)
Scroll.Size = UDim2.new(1, 0, 0.9, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 3, 0)
Scroll.ScrollBarThickness = 8

-- Layout для кнопок
local layout = Instance.new("UIListLayout", Scroll)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Скрипт перетягування (Drag)
local UIS = game:GetService("UserInputService")
local dragToggle, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true; dragStart = input.Position; startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Функція для кнопок
local function createBtn(text, color, order)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(0, 400, 0, 45); b.BackgroundColor3 = color
    b.Text = text; b.TextColor3 = Color3.new(1, 1, 1); b.TextScaled = true
    b.BorderSizePixel = 0; b.LayoutOrder = order
    return b
end

-- --- ЕЛЕМЕНТИ ---
local NameInput = Instance.new("TextBox", Scroll)
NameInput.Size = UDim2.new(0, 400, 0, 40); NameInput.PlaceholderText = "Нік для ТП/Kick..."
NameInput.LayoutOrder = -5

local MessageInput = Instance.new("TextBox", Scroll)
MessageInput.Size = UDim2.new(0, 400, 0, 40); MessageInput.PlaceholderText = "Текст для чату..."
MessageInput.LayoutOrder = 10

local SwordBtn = createBtn("ВЗЯТИ МЕЧ (INSTA-KILL)", Color3.fromRGB(255, 0, 0), 1)
local SpinBtn = createBtn("SPIN (1000): OFF", Color3.fromRGB(255, 69, 0), 2)
local HumESPBtn = createBtn("Humanoid ESP: OFF", Color3.fromRGB(180, 0, 255), 3)
local CubeBtn = createBtn("SPAWN 100 CUBES", Color3.fromRGB(255, 215, 0), 4)
local TPBtn = createBtn("ТЕЛЕПОРТ", Color3.fromRGB(0, 150, 0), 5)
local SpeedBtn = createBtn("SPEED", Color3.fromRGB(0, 200, 200), 6)
local FlyBtn = createBtn("FLY", Color3.fromRGB(50, 150, 255), 7)
local SendMsgBtn = createBtn("НАДІСЛАТИ В ЧАТ", Color3.fromRGB(255, 165, 0), 11)

-- --- ЛОГІКА ---

-- 1. Spin
local spinning = false
SpinBtn.MouseButton1Click:Connect(function()
    spinning = not spinning
    SpinBtn.Text = "SPIN: " .. (spinning and "ON" or "OFF")
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if spinning and hrp then
        local bva = Instance.new("BodyAngularVelocity", hrp)
        bva.Name = "SpinVel"; bva.MaxTorque = Vector3.new(0, math.huge, 0); bva.AngularVelocity = Vector3.new(0, 1000, 0)
    else
        if hrp and hrp:FindFirstChild("SpinVel") then hrp.SpinVel:Destroy() end
    end
end)

-- 2. Меч
SwordBtn.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool"); tool.Name = "Sword"; tool.RequiresHandle = true
    local handle = Instance.new("Part", tool); handle.Name = "Handle"; handle.Size = Vector3.new(1, 6, 1)
    handle.BrickColor = BrickColor.new("Really red"); handle.Material = Enum.Material.Neon
    tool.Activated:Connect(function()
        local c; c = handle.Touched:Connect(function(hit)
            local h = hit.Parent:FindFirstChild("Humanoid")
            if h and hit.Parent ~= player.Character then h.Health = 0 end
        end)
        task.wait(0.3); c:Disconnect()
    end)
    tool.Parent = player.Backpack
end)

-- 3. Куби (100 шт)
CubeBtn.MouseButton1Click:Connect(function()
    for i = 1, 100 do
        local p = Instance.new("Part", workspace)
        p.Size = Vector3.new(2, 2, 2)
        p.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10, 10), 30, math.random(-10, 10))
        p.Color = Color3.fromHSV(math.random(), 1, 1)
        game:GetService("Debris"):AddItem(p, 10)
    end
end)

-- 4. Чат
SendMsgBtn.MouseButton1Click:Connect(function()
    local text = MessageInput.Text
    local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if text ~= "" and chatEvents then
        chatEvents.SayMessageRequest:FireServer(text, "All")
    end
end)

-- Решта (ТП, Швидкість, Політ)
TPBtn.MouseButton1Click:Connect(function()
    local target = game.Players:FindFirstChild(NameInput.Text)
    if target and target.Character then player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end
end)

local spMode = 1
SpeedBtn.MouseButton1Click:Connect(function()
    if spMode == 1 then player.Character.Humanoid.WalkSpeed = 100; spMode = 2
    else player.Character.Humanoid.WalkSpeed = 16; spMode = 1 end
end)

local flyOn = false
FlyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    local hrp = player.Character.HumanoidRootPart
    if flyOn then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flyOn do bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100; task.wait() end
            bv:Destroy()
        end)
    end
end)
