local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local credentials = {
    admin = "admin123",
    test = "testpass"
}
local Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(10, 10, 10),
    Button = Color3.fromRGB(30, 30, 30),
    ButtonAccent = Color3.fromRGB(180, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    ToggleOn = Color3.fromRGB(0, 200, 100),
    ToggleOff = Color3.fromRGB(50, 50, 50),
    TopBar = Color3.fromRGB(40, 80, 150),
    Exit = Color3.fromRGB(200, 50, 50),
    Accent = Color3.fromRGB(120, 120, 255),
    Secondary = Color3.fromRGB(255, 100, 255),
    Outline = Color3.fromRGB(255, 215, 0),
    Credits = Color3.fromRGB(255, 165, 0)
}
local LoginUI = Instance.new("ScreenGui", game.CoreGui)
LoginUI.Name = "LoginUI"
local LoginFrame = Instance.new("Frame", LoginUI)
LoginFrame.Size = UDim2.new(0, 300, 0, 180)
LoginFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
LoginFrame.BackgroundColor3 = Theme.Background
LoginFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoginFrame.Active = true
LoginFrame.Draggable = true
local loginCorner = Instance.new("UICorner", LoginFrame)
loginCorner.CornerRadius = UDim.new(0, 12)
-- Add enhanced glow effect to login frame
local loginGlow = Instance.new("ImageLabel", LoginFrame)
loginGlow.Size = UDim2.new(1, 40, 1, 40)
loginGlow.Position = UDim2.new(0, -20, 0, -20)
loginGlow.BackgroundTransparency = 1
loginGlow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
loginGlow.ImageColor3 = Theme.ButtonAccent
loginGlow.ImageTransparency = 0.6
loginGlow.ZIndex = -1
-- Add outline to login frame
local loginOutline = Instance.new("UIStroke", LoginFrame)
loginOutline.Color = Theme.Outline
loginOutline.Thickness = 3
loginOutline.Transparency = 0.3
local function createInput(parent, placeholder, posY)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0.9, 0, 0, 30)
    box.Position = UDim2.new(0.05, 0, 0, posY)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.BackgroundColor3 = Theme.Button
    box.TextColor3 = Theme.Text
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", box)
    stroke.Color = Theme.ButtonAccent
    stroke.Thickness = 1
    -- Add outline to input boxes
    local outline = Instance.new("UIStroke", box)
    outline.Color = Theme.Outline
    outline.Thickness = 1
    outline.Transparency = 0.7
    outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return box
end
local userBox = createInput(LoginFrame, "Username", 30)
local passBox = createInput(LoginFrame, "Password", 70)
passBox.TextScaled = true
local loginButton = Instance.new("TextButton", LoginFrame)
loginButton.Size = UDim2.new(0.9, 0, 0, 35)
loginButton.Position = UDim2.new(0.05, 0, 0, 120)
loginButton.Text = "Login"
loginButton.Font = Enum.Font.GothamBold
loginButton.TextColor3 = Color3.new(1, 1, 1)
loginButton.BackgroundColor3 = Theme.ButtonAccent
local loginBtnCorner = Instance.new("UICorner", loginButton)
loginBtnCorner.CornerRadius = UDim.new(0, 8)
-- Add outline to login button
local loginBtnOutline = Instance.new("UIStroke", loginButton)
loginBtnOutline.Color = Theme.Outline
loginBtnOutline.Thickness = 2
loginBtnOutline.Transparency = 0.5
function loadMainGUI(username)
    local ESP = {
        GLOW = false,
        LINE_IN_BOX = false,
        BOX_ALL_PLAYERS = false
    }
    local AIMBOT = {
        ENABLED = false,
        FOV = 100,
        SMOOTHNESS = 1,
        SHOW_FOV = false
    }
    local players = {}
    local SelectedPlayer = nil
    local ESPConnections = {}
    local GlowObjects = {}
    local BoxObjects = {}
    local LineObjects = {}
    local FOVCircle = nil
    local AimbotConnection = nil
    -- ESP Functions
    local function CreateGlow(player)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local character = player.Character
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Name = "ESPGlow"
        
        GlowObjects[player] = highlight
    end
    local function CreateBox(player)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local character = player.Character
        local rootPart = character.HumanoidRootPart
        
        local box = Instance.new("BoxHandleAdornment")
        box.Parent = rootPart
        box.Size = character:GetExtentsSize()
        box.Color3 = Color3.fromRGB(0, 255, 0)
        box.Transparency = 0.7
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Name = "ESPBox"
        
        BoxObjects[player] = box
    end
    local function CreateLineInBox(player)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local character = player.Character
        local rootPart = character.HumanoidRootPart
        
        -- Create line from camera to the center of the player's box
        local line = Instance.new("Beam")
        local attachment0 = Instance.new("Attachment")
        local attachment1 = Instance.new("Attachment")
        
        attachment0.Parent = Camera
        attachment1.Parent = rootPart
        attachment1.Position = Vector3.new(0, 0, 0) -- Center of the box
        
        line.Parent = rootPart
        line.Attachment0 = attachment0
        line.Attachment1 = attachment1
        line.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        line.Width0 = 0.5
        line.Width1 = 0.5
        line.Transparency = NumberSequence.new(0.3)
        line.Name = "ESPLineInBox"
        
        LineObjects[player] = {line = line, att0 = attachment0, att1 = attachment1}
    end
    local function RemoveGlow(player)
        if GlowObjects[player] then
            GlowObjects[player]:Destroy()
            GlowObjects[player] = nil
        end
    end
    local function RemoveBox(player)
        if BoxObjects[player] then
            BoxObjects[player]:Destroy()
            BoxObjects[player] = nil
        end
    end
    local function RemoveLine(player)
        if LineObjects[player] then
            LineObjects[player].line:Destroy()
            LineObjects[player].att0:Destroy()
            LineObjects[player].att1:Destroy()
            LineObjects[player] = nil
        end
    end
    local function UpdateESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character then
                -- Glow ESP
                if ESP.GLOW and not GlowObjects[player] then
                    CreateGlow(player)
                elseif not ESP.GLOW and GlowObjects[player] then
                    RemoveGlow(player)
                end
                
                -- Box ESP for all players
                if ESP.BOX_ALL_PLAYERS and not BoxObjects[player] then
                    CreateBox(player)
                elseif not ESP.BOX_ALL_PLAYERS and BoxObjects[player] then
                    RemoveBox(player)
                end
                
                -- Line in Box ESP
                if ESP.LINE_IN_BOX and not LineObjects[player] then
                    CreateLineInBox(player)
                elseif not ESP.LINE_IN_BOX and LineObjects[player] then
                    RemoveLine(player)
                end
            end
        end
    end
    -- Enhanced FOV Circle
    local function CreateFOVCircle()
        local circle = Drawing.new("Circle")
        circle.Thickness = 3
        circle.NumSides = 64
        circle.Color = Color3.fromRGB(255, 255, 255)
        circle.Transparency = 0.5
        circle.Visible = false
        circle.Filled = false
        return circle
    end
    FOVCircle = CreateFOVCircle()
    -- Enhanced Aimbot Functions
    local function GetClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    local fovRadius = AIMBOT.FOV
                    
                    if distance < fovRadius and distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        
        return closestPlayer
    end
    local function UpdateAimbot()
        if not AIMBOT.ENABLED then return end
        
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local camera = Camera
            local targetPosition = head.Position
            
            -- Enhanced smooth aiming with better interpolation
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.lookAt(camera.CFrame.Position, targetPosition)
            local smoothness = AIMBOT.SMOOTHNESS / 100
            local smoothCFrame = currentCFrame:Lerp(targetCFrame, smoothness)
            
            camera.CFrame = smoothCFrame
        end
    end
    -- Handle new players
    local function OnPlayerAdded(player)
        if player ~= Player then
            player.CharacterAdded:Connect(function()
                wait(0.1)
                UpdateESP()
            end)
        end
    end
    local function OnPlayerRemoving(player)
        RemoveGlow(player)
        RemoveBox(player)
        RemoveLine(player)
    end
    Players.PlayerAdded:Connect(OnPlayerAdded)
    Players.PlayerRemoving:Connect(OnPlayerRemoving)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            OnPlayerAdded(player)
        end
    end
    local MainUI = Instance.new("ScreenGui", game.CoreGui)
    MainUI.Name = "FBLiteUI"
    local MainFrame = Instance.new("Frame", MainUI)
    MainFrame.Size = UDim2.new(0, 650, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Active = true
    MainFrame.Draggable = true
    local mainCorner = Instance.new("UICorner", MainFrame)
    mainCorner.CornerRadius = UDim.new(0, 15)
    local mainStroke = Instance.new("UIStroke", MainFrame)
    mainStroke.Color = Theme.ButtonAccent
    mainStroke.Thickness = 2
    -- Enhanced outline for main frame
    local mainOutline = Instance.new("UIStroke", MainFrame)
    mainOutline.Color = Theme.Outline
    mainOutline.Thickness = 4
    mainOutline.Transparency = 0.4
    mainOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- Add gradient to main frame
    local gradient = Instance.new("UIGradient", MainFrame)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
    }
    gradient.Rotation = 45
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Theme.TopBar
    local topCorner = Instance.new("UICorner", TopBar)
    topCorner.CornerRadius = UDim.new(0, 15)
    local topGradient = Instance.new("UIGradient", TopBar)
    topGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.TopBar),
        ColorSequenceKeypoint.new(1, Theme.Accent)
    }
    -- Add outline to top bar
    local topOutline = Instance.new("UIStroke", TopBar)
    topOutline.Color = Theme.Outline
    topOutline.Thickness = 2
    topOutline.Transparency = 0.6
    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Text = "FBLITE ROBLOX SCRIPT : zyxk 1128"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Theme.Text
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Center
    local titleStroke = Instance.new("UIStroke", Title)
    titleStroke.Color = Color3.fromRGB(0, 0, 0)
    titleStroke.Thickness = 1
    local Exit = Instance.new("TextButton", TopBar)
    Exit.Size = UDim2.new(0, 25, 0, 25)
    Exit.Position = UDim2.new(1, -30, 0, 3)
    Exit.Text = "X"
    Exit.BackgroundColor3 = Theme.Exit
    Exit.TextColor3 = Theme.Text
    Exit.Font = Enum.Font.GothamBold
    Exit.TextSize = 14
    local exitCorner = Instance.new("UICorner", Exit)
    exitCorner.CornerRadius = UDim.new(0, 8)
    -- Add outline to exit button
    local exitOutline = Instance.new("UIStroke", Exit)
    exitOutline.Color = Theme.Outline
    exitOutline.Thickness = 2
    exitOutline.Transparency = 0.5
    Exit.MouseButton1Click:Connect(function()
        -- Clean up ESP when closing
        for player, glow in pairs(GlowObjects) do
            RemoveGlow(player)
        end
        for player, box in pairs(BoxObjects) do
            RemoveBox(player)
        end
        for player, line in pairs(LineObjects) do
            RemoveLine(player)
        end
        if FOVCircle then
            FOVCircle:Remove()
        end
        if AimbotConnection then
            AimbotConnection:Disconnect()
        end
        MainUI:Destroy()
    end)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.Q then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    local Hide = Instance.new("TextButton", MainFrame)
    Hide.Size = UDim2.new(0, 100, 0, 30)
    Hide.Position = UDim2.new(1, -110, 1, -40)
    Hide.Text = "Hide Menu (Q)"
    Hide.Font = Enum.Font.Gotham
    Hide.TextSize = 13
    Hide.BackgroundColor3 = Theme.Button
    Hide.TextColor3 = Theme.Text
    local hideCorner = Instance.new("UICorner", Hide)
    hideCorner.CornerRadius = UDim.new(0, 8)
    -- Add outline to hide button
    local hideOutline = Instance.new("UIStroke", Hide)
    hideOutline.Color = Theme.Outline
    hideOutline.Thickness = 1
    hideOutline.Transparency = 0.7
    Hide.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 120, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    local sideCorner = Instance.new("UICorner", Sidebar)
    sideCorner.CornerRadius = UDim.new(0, 12)
    -- Add outline to sidebar
    local sideOutline = Instance.new("UIStroke", Sidebar)
    sideOutline.Color = Theme.Outline
    sideOutline.Thickness = 2
    sideOutline.Transparency = 0.7
    local Tabs = {"VISUAL", "AIMBOT", "TROLL", "SETTINGS"}
    local TabFrames = {}
    local function CreateTab(name, index)
        local Button = Instance.new("TextButton", Sidebar)
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.Position = UDim2.new(0, 0, 0, 10 + (index - 1) * 45)
        Button.Text = name
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        Button.TextColor3 = Theme.Text
        Button.BackgroundColor3 = Theme.Button
        local btnCorner = Instance.new("UICorner", Button)
        btnCorner.CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", Button)
        stroke.Color = Theme.ButtonAccent
        stroke.Thickness = 1
        -- Add outline to tab buttons
        local btnOutline = Instance.new("UIStroke", Button)
        btnOutline.Color = Theme.Outline
        btnOutline.Thickness = 1
        btnOutline.Transparency = 0.8
        local btnGradient = Instance.new("UIGradient", Button)
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Button),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45))
        }
        local Frame = Instance.new("Frame", MainFrame)
        Frame.Size = UDim2.new(1, -130, 1, -40)
        Frame.Position = UDim2.new(0, 130, 0, 40)
        Frame.Visible = false
        Frame.BackgroundTransparency = 1
        TabFrames[name] = Frame
        Button.MouseButton1Click:Connect(function()
            for _, v in pairs(TabFrames) do v.Visible = false end
            Frame.Visible = true
            
            -- Update button colors
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Theme.Button
                end
            end
            Button.BackgroundColor3 = Theme.ButtonAccent
        end)
    end
    for i, tab in ipairs(Tabs) do CreateTab(tab, i) end
    local function CreateCheckbox(parent, label, key, x, y)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(0, 300, 0, 30)
        holder.Position = UDim2.new(0, x, 0, y)
        holder.BackgroundTransparency = 1
        local Box = Instance.new("TextButton", holder)
        Box.Size = UDim2.new(0, 20, 0, 20)
        Box.Position = UDim2.new(0, 0, 0, 5)
        Box.BackgroundColor3 = Theme.ToggleOff
        Box.Text = ""
        local boxCorner = Instance.new("UICorner", Box)
        boxCorner.CornerRadius = UDim.new(0, 4)
        local stroke = Instance.new("UIStroke", Box)
        stroke.Color = Theme.ButtonAccent
        stroke.Thickness = 2
        -- Add outline to checkbox
        local boxOutline = Instance.new("UIStroke", Box)
        boxOutline.Color = Theme.Outline
        boxOutline.Thickness = 1
        boxOutline.Transparency = 0.8
        local Mark = Instance.new("TextLabel", Box)
        Mark.Size = UDim2.new(1, 0, 1, 0)
        Mark.Text = ""
        Mark.TextColor3 = Theme.Text
        Mark.BackgroundTransparency = 1
        Mark.Font = Enum.Font.GothamBold
        Mark.TextSize = 14
        local Label = Instance.new("TextLabel", holder)
        Label.Position = UDim2.new(0, 30, 0, 5)
        Label.Size = UDim2.new(1, -30, 1, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Theme.Text
        Label.Font = Enum.Font.Gotham
        Label.Text = label
        Label.TextSize = 14
        Box.MouseButton1Click:Connect(function()
            ESP[key] = not ESP[key]
            Box.BackgroundColor3 = ESP[key] and Theme.ToggleOn or Theme.ToggleOff
            Mark.Text = ESP[key] and "✓" or ""
            UpdateESP()
        end)
    end
    local function CreateSlider(parent, label, min, max, default, callback, x, y)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(0, 300, 0, 50)
        holder.Position = UDim2.new(0, x, 0, y)
        holder.BackgroundTransparency = 1
        local Label = Instance.new("TextLabel", holder)
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Position = UDim2.new(0, 0, 0, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Theme.Text
        Label.Font = Enum.Font.Gotham
        Label.Text = label .. ": " .. default
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        local SliderFrame = Instance.new("Frame", holder)
        SliderFrame.Size = UDim2.new(0, 200, 0, 20)
        SliderFrame.Position = UDim2.new(0, 0, 0, 25)
        SliderFrame.BackgroundColor3 = Theme.Button
        local sliderCorner = Instance.new("UICorner", SliderFrame)
        sliderCorner.CornerRadius = UDim.new(0, 10)
        -- Add outline to slider
        local sliderOutline = Instance.new("UIStroke", SliderFrame)
        sliderOutline.Color = Theme.Outline
        sliderOutline.Thickness = 1
        sliderOutline.Transparency = 0.8
        local SliderButton = Instance.new("TextButton", SliderFrame)
        SliderButton.Size = UDim2.new(0, 20, 0, 20)
        SliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, 0)
        SliderButton.BackgroundColor3 = Theme.ButtonAccent
        SliderButton.Text = ""
        local sliderBtnCorner = Instance.new("UICorner", SliderButton)
        sliderBtnCorner.CornerRadius = UDim.new(0, 10)
        -- Add outline to slider button
        local sliderBtnOutline = Instance.new("UIStroke", SliderButton)
        sliderBtnOutline.Color = Theme.Outline
        sliderBtnOutline.Thickness = 1
        sliderBtnOutline.Transparency = 0.6
        local dragging = false
        SliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = Player:GetMouse()
                local relativeX = mouse.X - SliderFrame.AbsolutePosition.X
                local percentage = math.clamp(relativeX / SliderFrame.AbsoluteSize.X, 0, 1)
                local value = min + (max - min) * percentage
                
                SliderButton.Position = UDim2.new(percentage, -10, 0, 0)
                Label.Text = label .. ": " .. math.floor(value)
                callback(value)
            end
        end)
    end
    -- VISUAL Tab
    local Visual = TabFrames["VISUAL"]
    CreateCheckbox(Visual, "ESP Glow", "GLOW", 0, 20)
    CreateCheckbox(Visual, "ESP Box All Players", "BOX_ALL_PLAYERS", 0, 60)
    CreateCheckbox(Visual, "ESP Line in Box", "LINE_IN_BOX", 0, 100)
    -- AIMBOT Tab
    local Aimbot = TabFrames["AIMBOT"]
    
    local function CreateAimbotCheckbox(parent, label, key, x, y)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(0, 300, 0, 30)
        holder.Position = UDim2.new(0, x, 0, y)
        holder.BackgroundTransparency = 1
        local Box = Instance.new("TextButton", holder)
        Box.Size = UDim2.new(0, 20, 0, 20)
        Box.Position = UDim2.new(0, 0, 0, 5)
        Box.BackgroundColor3 = Theme.ToggleOff
        Box.Text = ""
        local boxCorner = Instance.new("UICorner", Box)
        boxCorner.CornerRadius = UDim.new(0, 4)
        local stroke = Instance.new("UIStroke", Box)
        stroke.Color = Theme.ButtonAccent
        stroke.Thickness = 2
        -- Add outline to aimbot checkbox
        local boxOutline = Instance.new("UIStroke", Box)
        boxOutline.Color = Theme.Outline
        boxOutline.Thickness = 1
        boxOutline.Transparency = 0.8
        local Mark = Instance.new("TextLabel", Box)
        Mark.Size = UDim2.new(1, 0, 1, 0)
        Mark.Text = ""
        Mark.TextColor3 = Theme.Text
        Mark.BackgroundTransparency = 1
        Mark.Font = Enum.Font.GothamBold
        Mark.TextSize = 14
        local Label = Instance.new("TextLabel", holder)
        Label.Position = UDim2.new(0, 30, 0, 5)
        Label.Size = UDim2.new(1, -30, 1, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Theme.Text
        Label.Font = Enum.Font.Gotham
        Label.Text = label
        Label.TextSize = 14
        Box.MouseButton1Click:Connect(function()
            AIMBOT[key] = not AIMBOT[key]
            Box.BackgroundColor3 = AIMBOT[key] and Theme.ToggleOn or Theme.ToggleOff
            Mark.Text = AIMBOT[key] and "✓" or ""
            
            if key == "ENABLED" then
                if AIMBOT[key] then
                    AimbotConnection = RunService.Heartbeat:Connect(function()
                        UpdateAimbot()
                        -- Update FOV Circle
                        if AIMBOT.SHOW_FOV then
                            FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
                            FOVCircle.Radius = AIMBOT.FOV
                            FOVCircle.Visible = true
                        else
                            FOVCircle.Visible = false
                        end
                    end)
                else
                    if AimbotConnection then
                        AimbotConnection:Disconnect()
                    end
                end
            end
        end)
    end
    CreateAimbotCheckbox(Aimbot, "Enable Aimbot", "ENABLED", 0, 20)
    CreateAimbotCheckbox(Aimbot, "Show FOV Circle", "SHOW_FOV", 0, 60)
    CreateSlider(Aimbot, "Aimbot FOV", 50, 500, AIMBOT.FOV, function(val)
        AIMBOT.FOV = math.floor(val)
    end, 0, 100)
    CreateSlider(Aimbot, "Smoothness", 1, 100, AIMBOT.SMOOTHNESS, function(val)
        AIMBOT.SMOOTHNESS = math.floor(val)
    end, 0, 160)
    -- TROLL Tab
    local Troll = TabFrames["TROLL"]
    local playersList = {}
    local selected = nil
    local playerDropdown = Instance.new("TextButton", Troll)
    playerDropdown.Size = UDim2.new(0, 250, 0, 30)
    playerDropdown.Position = UDim2.new(0, 0, 0, 20)
    playerDropdown.Text = "Select Player"
    playerDropdown.Font = Enum.Font.Gotham
    playerDropdown.TextSize = 14
    playerDropdown.TextColor3 = Theme.Text
    playerDropdown.BackgroundColor3 = Theme.Button
    local dropdownCorner = Instance.new("UICorner", playerDropdown)
    dropdownCorner.CornerRadius = UDim.new(0, 8)
    local dropdownOutline = Instance.new("UIStroke", playerDropdown)
    dropdownOutline.Color = Theme.Outline
    dropdownOutline.Thickness = 1
    dropdownOutline.Transparency = 0.7
    local function RefreshPlayers()
        table.clear(playersList)
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= Player then
                table.insert(playersList, v.Name)
            end
        end
    end
    RefreshPlayers()
    local function ShowDropdown()
        local dropFrame = Instance.new("Frame", Troll)
        dropFrame.Size = UDim2.new(0, 250, 0, #playersList * 25)
        dropFrame.Position = playerDropdown.Position + UDim2.new(0, 0, 0, 35)
        dropFrame.BackgroundColor3 = Theme.Sidebar
        local dropCorner = Instance.new("UICorner", dropFrame)
        dropCorner.CornerRadius = UDim.new(0, 8)
        local dropOutline = Instance.new("UIStroke", dropFrame)
        dropOutline.Color = Theme.Outline
        dropOutline.Thickness = 1
        dropOutline.Transparency = 0.7
        for i, name in ipairs(playersList) do
            local btn = Instance.new("TextButton", dropFrame)
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
            btn.Text = name
            btn.BackgroundColor3 = Theme.Button
            btn.TextColor3 = Theme.Text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 6)
            local btnOutline = Instance.new("UIStroke", btn)
            btnOutline.Color = Theme.Outline
            btnOutline.Thickness = 1
            btnOutline.Transparency = 0.8
            btn.MouseButton1Click:Connect(function()
                selected = name
                playerDropdown.Text = name
                dropFrame:Destroy()
            end)
        end
    end
    playerDropdown.MouseButton1Click:Connect(function()
        ShowDropdown()
    end)
    local refreshBtn = Instance.new("TextButton", Troll)
    refreshBtn.Size = UDim2.new(0, 100, 0, 30)
    refreshBtn.Position = UDim2.new(0, 0, 0, 70)
    refreshBtn.Text = "Refresh"
    refreshBtn.Font = Enum.Font.Gotham
    refreshBtn.TextSize = 13
    refreshBtn.TextColor3 = Theme.Text
    refreshBtn.BackgroundColor3 = Theme.Button
    local refreshCorner = Instance.new("UICorner", refreshBtn)
    refreshCorner.CornerRadius = UDim.new(0, 8)
    local refreshOutline = Instance.new("UIStroke", refreshBtn)
    refreshOutline.Color = Theme.Outline
    refreshOutline.Thickness = 1
    refreshOutline.Transparency = 0.7
    refreshBtn.MouseButton1Click:Connect(function()
        RefreshPlayers()
    end)
    local teleportBtn = Instance.new("TextButton", Troll)
    teleportBtn.Size = UDim2.new(0, 150, 0, 30)
    teleportBtn.Position = UDim2.new(0, 110, 0, 70)
    teleportBtn.Text = "Teleport to Player"
    teleportBtn.Font = Enum.Font.Gotham
    teleportBtn.TextSize = 13
    teleportBtn.TextColor3 = Theme.Text
    teleportBtn.BackgroundColor3 = Theme.Button
    local tpCorner = Instance.new("UICorner", teleportBtn)
    tpCorner.CornerRadius = UDim.new(0, 8)
    local tpOutline = Instance.new("UIStroke", teleportBtn)
    tpOutline.Color = Theme.Outline
    tpOutline.Thickness = 1
    tpOutline.Transparency = 0.7
    teleportBtn.MouseButton1Click:Connect(function()
        if selected then
            local target = Players:FindFirstChild(selected)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            end
        end
    end)
    -- SETTINGS Tab
    local Settings = TabFrames["SETTINGS"]
    local credits = Instance.new("TextLabel", Settings)
    credits.Position = UDim2.new(0, 0, 0, 20)
    credits.Size = UDim2.new(0, 400, 0, 30)
    credits.Text = "Credits to Developer: zyxk 1128"
    credits.TextColor3 = Theme.Credits
    credits.BackgroundTransparency = 1
    credits.Font = Enum.Font.GothamBold
    credits.TextSize = 16
end
loginButton.MouseButton1Click:Connect(function()
    local username = userBox.Text
    local password = passBox.Text
    if credentials[username] and credentials[username] == password then
        LoginUI:Destroy()
        loadMainGUI(username)
    else
        loginButton.Text = "Invalid Credentials!"
        wait(1)
        loginButton.Text = "Login"
    end
end)