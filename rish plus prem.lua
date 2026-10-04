-- Rish Plus HB (Smart Shift & Return Edition)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Звук при запуске
local function playCustomSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://133758255538431"
        sound.Volume = 1
        sound.Parent = CoreGui
        sound:Play()
        game.Debris:AddItem(sound, 3)
    end)
end

if CoreGui:FindFirstChild("FootballHelperGUI") then
    playCustomSound()
    task.wait(0.15)
    CoreGui.FootballHelperGUI:Destroy()
end

playCustomSound()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FootballHelperGUI"
ScreenGui.Parent = CoreGui

local viewport = Camera.ViewportSize
local startX = math.floor(viewport.X * 0.05)
local startY = math.floor(viewport.Y * 0.2)

-- Константы размеров
local PANEL_WIDTH = 220
local PANEL_HEIGHT = 175
local BTN_WIDTH = 95
local BTN_HEIGHT = 32

-- Сохраняем позицию, куда пользователь перетащил элемент
local savedPosition = UDim2.new(0, startX, 0, startY)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = savedPosition
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Градиентный фон
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 12, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 5, 12))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180)
UIStroke.Transparency = 0.4
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "  Rish Plus HB"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 3
Title.Parent = MainFrame

-- Кнопка сворачивания (_) в шапке панели
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Position = UDim2.new(1, -28, 0, 3)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 15, 30)
MinimizeButton.BackgroundTransparency = 0.3
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.ZIndex = 4
MinimizeButton.Parent = MainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinimizeButton

local minStroke = Instance.new("UIStroke")
minStroke.Color = Color3.fromRGB(255, 105, 180)
minStroke.Transparency = 0.4
minStroke.Thickness = 1
minStroke.Parent = MinimizeButton

-- Анимация появления
task.spawn(function()
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local openTween = TweenService:Create(MainFrame, tweenInfo, {
        Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
    })
    openTween:Play()
end)

-- Кнопка для открытия скрытой панели (перетаскиваемая)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, BTN_WIDTH, 0, BTN_HEIGHT)
OpenButton.Position = savedPosition
OpenButton.BackgroundColor3 = Color3.fromRGB(25, 10, 20)
OpenButton.BackgroundTransparency = 0.2
OpenButton.Text = "Открыть HB"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 11
OpenButton.Visible = false
OpenButton.ZIndex = 5
OpenButton.Parent = ScreenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = OpenButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(255, 105, 180)
openStroke.Transparency = 0.4
openStroke.Thickness = 1.5
openStroke.Parent = OpenButton

-- Перетаскивание основной панели
local dragging, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            
            local currentViewport = Camera.ViewportSize
            newX = math.clamp(newX, 10, currentViewport.X - PANEL_WIDTH - 10)
            newY = math.clamp(newY, 10, currentViewport.Y - PANEL_HEIGHT - 10)
            
            MainFrame.Position = UDim2.new(0, newX, 0, newY)
            savedPosition = MainFrame.Position
        end
    end
end)

-- Перетаскивание кнопки открытия (можно тащить к самому краю)
local openDragging, openDragStart, openStartPos
local openHasMoved = false

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = true
        openDragStart = input.Position
        openStartPos = OpenButton.Position
        openHasMoved = false
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                openDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if openDragging then
            local delta = input.Position - openDragStart
            if delta.Magnitude > 4 then
                openHasMoved = true
            end
            local newX = openStartPos.X.Offset + delta.X
            local newY = openStartPos.Y.Offset + delta.Y
            
            local currentViewport = Camera.ViewportSize
            -- Кнопку ограничиваем только размером самой кнопки, чтобы она не улетала за экран полностью
            newX = math.clamp(newX, 10, currentViewport.X - BTN_WIDTH - 10)
            newY = math.clamp(newY, 10, currentViewport.Y - BTN_HEIGHT - 10)
            
            OpenButton.Position = UDim2.new(0, newX, 0, newY)
            savedPosition = OpenButton.Position
        end
    end
end)

local lookActive = false
local lockedLookVector = nil
local isVHeld = false
local magnetActive = false
local hitboxActive = false
local slideActive = false
local isBoosting = false

local ACTIVE_COLOR = Color3.fromRGB(0, 255, 128)
local INACTIVE_COLOR = Color3.fromRGB(35, 20, 30)

local function createButton(posY, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = INACTIVE_COLOR
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.ZIndex = 3
    btn.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 45, 70)
    stroke.Transparency = 0.5
    stroke.Thickness = 1
    stroke.Parent = btn
    
    return btn
end

local LookButton = createButton(34, "Фикс Взгляда: ВЫКЛ")
local MagnetButton = createButton(68, "Анти-Магнит: ВЫКЛ")
local HitboxButton = createButton(102, "Хитбокс: ВЫКЛ")
local SlideButton = createButton(136, "Слайд (E): ВЫКЛ")

-- Сворачивание панели: возвращаем кнопку ровно на сохраненную позицию
MinimizeButton.MouseButton1Click:Connect(function()
    OpenButton.Position = savedPosition
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

-- Открытие панели: сдвигаем панель на экран, если она у края, но кнопку не трогаем
OpenButton.MouseButton1Click:Connect(function()
    if openHasMoved then return end
    
    local posX = savedPosition.X.Offset
    local posY = savedPosition.Y.Offset
    local currentViewport = Camera.ViewportSize
    
    -- Умный сдвиг панели при открытии, чтобы она не обрезалась
    posX = math.clamp(posX, 10, currentViewport.X - PANEL_WIDTH - 10)
    posY = math.clamp(posY, 10, currentViewport.Y - PANEL_HEIGHT - 10)
    
    MainFrame.Position = UDim2.new(0, posX, 0, posY)
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- 1. Кнопка: Фиксация взгляда
LookButton.MouseButton1Click:Connect(function()
    lookActive = not lookActive
    if lookActive then
        LookButton.Text = "Фикс Взгляда: ВКЛ"
        LookButton.BackgroundColor3 = ACTIVE_COLOR
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local look = root.CFrame.LookVector
            lockedLookVector = Vector3.new(look.X, 0, look.Z).Unit
        end
    else
        LookButton.Text = "Фикс Взгляда: ВЫКЛ"
        LookButton.BackgroundColor3 = INACTIVE_COLOR
        lockedLookVector = nil
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if lookActive and not isVHeld then
        if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
            local camLook = Camera.CFrame.LookVector
            lockedLookVector = Vector3.new(camLook.X, 0, camLook.Z).Unit
        end
    end
    
    if input.KeyCode == Enum.KeyCode.V then
        isVHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        isVHeld = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not lookActive or isVHeld or not lockedLookVector then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    root.CFrame = CFrame.new(root.Position, root.Position + lockedLookVector)
end)

-- Умный перехватчик скиллов и ударов
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and self:IsA("RemoteEvent") then
            local name = self.Name:lower()
            if name:find("shoot") or name:find("kick") or name:find("skill") or name:find("ability") or name:find("pass") or name:find("action") then
                local mouseHit = Mouse.Hit and Mouse.Hit.Position
                if mouseHit then
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            args[i] = mouseHit
                        elseif typeof(arg) == "table" then
                            for k, v in pairs(arg) do
                                if typeof(v) == "Vector3" then
                                    arg[k] = mouseHit
                                end
                            end
                        end
                    end
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end)
end)

-- 2. Кнопка: Анти-Магнит
MagnetButton.MouseButton1Click:Connect(function()
    magnetActive = not magnetActive
    if magnetActive then
        MagnetButton.Text = "Анти-Магнит: ВКЛ"
        MagnetButton.BackgroundColor3 = ACTIVE_COLOR
        pcall(function()
            for _, v in ipairs(getgc(true)) do
                if type(v) == "table" then
                    if rawget(v, "AutoAim") ~= nil then v.AutoAim = false end
                    if rawget(v, "LockOn") ~= nil then v.LockOn = false end
                    if rawget(v, "TargetAssist") ~= nil then v.TargetAssist = false end
                    if rawget(v, "AimAssist") ~= nil then v.AimAssist = false end
                    if rawget(v, "Magnetism") ~= nil then v.Magnetism = false end
                end
            end
        end)
    else
        MagnetButton.Text = "Анти-Магнит: ВЫКЛ"
        MagnetButton.BackgroundColor3 = INACTIVE_COLOR
    end
end)

local function findBall()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("ball") or name:find("football") or name:find("soccer") or name:find("мяч") then
                return obj
            end
        end
    end
    for _, folder in pairs(workspace:GetDescendants()) do
        if folder:IsA("BasePart") then
            local name = folder.Name:lower()
            if name:find("ball") or name:find("football") or name:find("soccer") or name:find("мяч") then
                return folder
            end
        end
    end
    return nil
end

local function applyHitbox(character)
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not root then return end

    if hitboxActive then
        root.Size = Vector3.new(25, 2, 25)
        root.Transparency = 1 
        root.CanCollide = false

        if not root:FindFirstChild("HitboxVisualizer") then
            local box = Instance.new("SelectionBox")
            box.Name = "HitboxVisualizer"
            box.Adornee = root
            box.LineThickness = 0.02
            box.Color3 = ACTIVE_COLOR
            box.Parent = root
        end
    else
        root.Size = Vector3.new(2, 2, 1)
        if root:FindFirstChild("HitboxVisualizer") then
            root.HitboxVisualizer:Destroy()
        end
    end
end

HitboxButton.MouseButton1Click:Connect(function()
    hitboxActive = not hitboxActive
    if hitboxActive then
        HitboxButton.Text = "Хитбокс: ВКЛ"
        HitboxButton.BackgroundColor3 = ACTIVE_COLOR
    else
        HitboxButton.Text = "Хитбокс: ВЫКЛ"
        HitboxButton.BackgroundColor3 = INACTIVE_COLOR
    end
    if LocalPlayer.Character then
        applyHitbox(LocalPlayer.Character)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.spawn(function()
        task.wait(1)
        if hitboxActive and newChar then
            applyHitbox(newChar)
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if not hitboxActive then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if root.Size.X ~= 25 then
        root.Size = Vector3.new(25, 2, 25)
    end
    
    local ball = findBall()
    if ball then
        local relativePos = root.CFrame:PointToObjectSpace(ball.Position)
        if math.abs(relativePos.X) <= 12.5 and math.abs(relativePos.Z) <= 12.5 and math.abs(relativePos.Y) <= 5 then
            local targetPos = root.Position - Vector3.new(0, 1.5, 0) + (root.CFrame.LookVector * 2.2)
            ball.CFrame = CFrame.new(targetPos)
            ball.AssemblyLinearVelocity = Vector3.zero
            ball.AssemblyAngularVelocity = Vector3.zero
            
            pcall(function()
                firetouchinterest(root, ball, 0)
                firetouchinterest(root, ball, 1)
            end)
        end
    end
end)

-- 4. Кнопка: Слайд-Буст (E)
SlideButton.MouseButton1Click:Connect(function()
    slideActive = not slideActive
    if slideActive then
        SlideButton.Text = "Слайд (E): ВКЛ"
        SlideButton.BackgroundColor3 = ACTIVE_COLOR
    else
        SlideButton.Text = "Слайд (E): ВЫКЛ"
        SlideButton.BackgroundColor3 = INACTIVE_COLOR
        isBoosting = false
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not slideActive then return end
    if input.KeyCode == Enum.KeyCode.E then
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                isBoosting = true
                local camLook = Camera.CFrame.LookVector
                local lookVec = Vector3.new(camLook.X, 0, camLook.Z).Unit
                root.AssemblyLinearVelocity = Vector3.new(
                    lookVec.X * 90,
                    root.AssemblyLinearVelocity.Y,
                    lookVec.Z * 90
                )
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if not slideActive then return end
    if input.KeyCode == Enum.KeyCode.E then
        isBoosting = false
    end
end)

RunService.Heartbeat:Connect(function()
    if not slideActive or not isBoosting then return end
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local camLook = Camera.CFrame.LookVector
            local lookVec = Vector3.new(camLook.X, 0, camLook.Z).Unit
            local currentV = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(
                lookVec.X * 80,
                currentV.Y,
                lookVec.Z * 80
            )
        end
    end
end)

print("Панель Rish Plus HB успешно запущена!")