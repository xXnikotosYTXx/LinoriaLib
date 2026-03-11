-- HYBRID LINORIA LIBRARY
-- Original Linoria style + ESP Preview + Enhanced Notifications
-- Keeps the classic Linoria look but adds modern features

local InputService = game:GetService('UserInputService');
local TextService = game:GetService('TextService');
local CoreGui = game:GetService('CoreGui');
local Teams = game:GetService('Teams');
local Players = game:GetService('Players');
local RunService = game:GetService('RunService');
local TweenService = game:GetService('TweenService');
local RenderStepped = RunService.RenderStepped;
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);
local ScreenGui = Instance.new('ScreenGui');
ProtectGui(ScreenGui);
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
ScreenGui.Parent = CoreGui;

local Toggles = {};
local Options = {};
getgenv().Toggles = Toggles;
getgenv().Options = Options;

-- ORIGINAL LINORIA LIBRARY with ESP Preview additions
local Library = {
    Registry = {};
    RegistryMap = {};
    HudRegistry = {};
    FontColor = Color3.fromRGB(255, 255, 255);
    MainColor = Color3.fromRGB(28, 28, 28);
    BackgroundColor = Color3.fromRGB(20, 20, 20);
    AccentColor = Color3.fromRGB(0, 85, 255);
    OutlineColor = Color3.fromRGB(50, 50, 50);
    RiskColor = Color3.fromRGB(255, 50, 50),
    Black = Color3.new(0, 0, 0);
    Font = Enum.Font.Code,
    OpenedFrames = {};
    DependencyBoxes = {};
    Signals = {};
    ScreenGui = ScreenGui;
    
    -- ESP PREVIEW SYSTEM (NEW ADDITION)
    ESPPreview = {
        Enabled = false,
        Container = nil,
        Elements = {},
        Settings = nil,
    };
};

-- Rainbow animation system (for notifications)
local RainbowStep = 0
local Hue = 0
table.insert(Library.Signals, RenderStepped:Connect(function(Delta)
    RainbowStep = RainbowStep + Delta
    if RainbowStep >= (1 / 60) then
        RainbowStep = 0
        Hue = Hue + (1 / 400);
        if Hue > 1 then
            Hue = 0;
        end;
        Library.CurrentRainbowHue = Hue;
        Library.CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1);
    end
end))

-- ESP PREVIEW SYSTEM (Enhanced notifications style)
function Library.ESPPreview:SetESPSettings(settings)
    self.Settings = settings
    if self.Enabled then
        self:UpdatePreview()
    end
end

function Library.ESPPreview:CreatePreview()
    if self.Container then
        self:DestroyPreview()
    end
    
    -- Create preview container with enhanced notification style
    self.Container = Library:Create('Frame', {
        Name = 'ESPPreview',
        BackgroundColor3 = Library.BackgroundColor,
        BorderColor3 = Library.AccentColor,
        BorderSizePixel = 2,
        Position = UDim2.fromOffset(50, 100),
        Size = UDim2.fromOffset(320, 240),
        ZIndex = 1000,
        Parent = Library.ScreenGui,
    })
    
    Library:AddToRegistry(self.Container, {
        BackgroundColor3 = 'BackgroundColor',
        BorderColor3 = 'AccentColor'
    })
    
    -- Enhanced gradient header (notification style)
    local header = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        ZIndex = 1001,
        Parent = self.Container,
    })
    
    Library:AddToRegistry(header, {BackgroundColor3 = 'AccentColor'})
    
    -- Header gradient (notification style)
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.AccentColor),
            ColorSequenceKeypoint.new(1, Color3.new(
                Library.AccentColor.R * 0.8,
                Library.AccentColor.G * 0.8,
                Library.AccentColor.B * 0.8
            )),
        }),
        Rotation = 90,
        Parent = header,
    })
    
    -- Animated title (notification style)
    local title = Library:CreateLabel({
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        Text = '✨ ESP Preview - Live',
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1002,
        Parent = header,
    })
    
    -- Close button (notification style)
    local closeBtn = Library:Create('TextButton', {
        BackgroundColor3 = Color3.fromRGB(255, 100, 100),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -25, 0, 5),
        Size = UDim2.fromOffset(20, 20),
        Text = '×',
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 14,
        ZIndex = 1003,
        Parent = header,
    })
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Toggle(false)
    end)
    
    -- Preview content area
    local content = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 30),
        Size = UDim2.new(1, 0, 1, -30),
        ZIndex = 1001,
        Parent = self.Container,
    })
    
    -- Make draggable
    Library:MakeDraggable(self.Container, 30)
    
    -- Smooth notification-style fade-in
    self.Container.BackgroundTransparency = 1
    for _, child in pairs(self.Container:GetDescendants()) do
        if child:IsA('Frame') or child:IsA('TextLabel') or child:IsA('TextButton') then
            if child:GetAttribute('OriginalTransparency') == nil then
                child:SetAttribute('OriginalTransparency', child.BackgroundTransparency or 0)
            end
            child.BackgroundTransparency = 1
            if child:IsA('TextLabel') or child:IsA('TextButton') then
                child.TextTransparency = 1
            end
        end
    end
    
    -- Notification-style slide and fade animation
    self.Container.Position = UDim2.fromOffset(-320, 100)
    local slideIn = TweenService:Create(self.Container, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Position = UDim2.fromOffset(50, 100),
            BackgroundTransparency = 0
        }
    )
    slideIn:Play()
    
    for _, child in pairs(self.Container:GetDescendants()) do
        if child:IsA('Frame') or child:IsA('TextLabel') or child:IsA('TextButton') then
            local originalTrans = child:GetAttribute('OriginalTransparency') or 0
            TweenService:Create(child, 
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
                {BackgroundTransparency = originalTrans}
            ):Play()
            if child:IsA('TextLabel') or child:IsA('TextButton') then
                TweenService:Create(child, 
                    TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
                    {TextTransparency = 0}
                ):Play()
            end
        end
    end
    
    self:UpdatePreview()
end

function Library.ESPPreview:UpdatePreview()
    if not self.Container or not self.Settings then return end
    
    -- Clear existing elements
    for _, element in pairs(self.Elements) do
        if element and element.Parent then
            element:Destroy()
        end
    end
    self.Elements = {}
    
    local content = self.Container:FindFirstChild('Frame')
    if not content then return end
    
    -- Sample player representation (scaled for preview)
    local scale = 0.7
    local centerX, centerY = 160, 140
    
    -- Box ESP Preview
    if self.Settings.box and self.Settings.box.enabled then
        local boxWidth, boxHeight = 60, 80
        
        -- Glow effect preview (render first, behind box)
        if self.Settings.glow and self.Settings.glow.enabled then
            for i = 1, 4 do
                local glowSize = i * 2
                local glow = Library:Create('Frame', {
                    BackgroundTransparency = 1,
                    BorderColor3 = self.Settings.glow.color,
                    BorderSizePixel = math.ceil(i * 1.5),
                    Position = UDim2.fromOffset(centerX - boxWidth/2 - glowSize, centerY - boxHeight/2 - glowSize),
                    Size = UDim2.fromOffset(boxWidth + glowSize*2, boxHeight + glowSize*2),
                    ZIndex = 1002 + (4 - i),
                    Parent = content,
                })
                
                local glowTrans = 0.3 + (i * 0.15)
                glow.BorderColor3 = Color3.new(
                    self.Settings.glow.color.R * (1 - glowTrans),
                    self.Settings.glow.color.G * (1 - glowTrans),
                    self.Settings.glow.color.B * (1 - glowTrans)
                )
                
                table.insert(self.Elements, glow)
            end
        end
        
        -- Main box
        local box = Library:Create('Frame', {
            BackgroundTransparency = 1,
            BorderColor3 = self.Settings.box.fill,
            BorderSizePixel = 2,
            Position = UDim2.fromOffset(centerX - boxWidth/2, centerY - boxHeight/2),
            Size = UDim2.fromOffset(boxWidth, boxHeight),
            ZIndex = 1006,
            Parent = content,
        })
        table.insert(self.Elements, box)
        
        -- Corner box style
        if self.Settings.box.type == "corner" then
            box.BorderSizePixel = 0
            local cornerLength = 15
            local corners = {
                -- Top-left
                {UDim2.fromOffset(centerX - boxWidth/2, centerY - boxHeight/2), UDim2.fromOffset(cornerLength, 2)},
                {UDim2.fromOffset(centerX - boxWidth/2, centerY - boxHeight/2), UDim2.fromOffset(2, cornerLength)},
                -- Top-right
                {UDim2.fromOffset(centerX + boxWidth/2 - cornerLength, centerY - boxHeight/2), UDim2.fromOffset(cornerLength, 2)},
                {UDim2.fromOffset(centerX + boxWidth/2 - 2, centerY - boxHeight/2), UDim2.fromOffset(2, cornerLength)},
                -- Bottom-left
                {UDim2.fromOffset(centerX - boxWidth/2, centerY + boxHeight/2 - 2), UDim2.fromOffset(cornerLength, 2)},
                {UDim2.fromOffset(centerX - boxWidth/2, centerY + boxHeight/2 - cornerLength), UDim2.fromOffset(2, cornerLength)},
                -- Bottom-right
                {UDim2.fromOffset(centerX + boxWidth/2 - cornerLength, centerY + boxHeight/2 - 2), UDim2.fromOffset(cornerLength, 2)},
                {UDim2.fromOffset(centerX + boxWidth/2 - 2, centerY + boxHeight/2 - cornerLength), UDim2.fromOffset(2, cornerLength)},
            }
            
            for _, corner in ipairs(corners) do
                local line = Library:Create('Frame', {
                    BackgroundColor3 = self.Settings.box.fill,
                    BorderSizePixel = 0,
                    Position = corner[1],
                    Size = corner[2],
                    ZIndex = 1006,
                    Parent = content,
                })
                table.insert(self.Elements, line)
            end
        end
    end
    
    -- Healthbar Preview
    if self.Settings.healthbar and self.Settings.healthbar.enabled then
        local healthPercent = 0.75
        local hpWidth, hpHeight = 4, 80
        local hpX = centerX - 35
        
        if self.Settings.healthbar.position == "right" then
            hpX = centerX + 35
        elseif self.Settings.healthbar.position == "bottom" then
            hpX = centerX - 30
            hpWidth, hpHeight = 60, 4
        end
        
        local hpY = centerY - 40
        if self.Settings.healthbar.position == "bottom" then
            hpY = centerY + 45
        end
        
        -- Healthbar background
        local hpBg = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = self.Settings.healthbar.outline or Color3.new(0.3, 0.3, 0.3),
            BorderSizePixel = 1,
            Position = UDim2.fromOffset(hpX, hpY),
            Size = UDim2.fromOffset(hpWidth, hpHeight),
            ZIndex = 1005,
            Parent = content,
        })
        table.insert(self.Elements, hpBg)
        
        -- Healthbar fill
        local fillWidth = self.Settings.healthbar.position == "bottom" and (hpWidth * healthPercent) or hpWidth
        local fillHeight = self.Settings.healthbar.position == "bottom" and hpHeight or (hpHeight * healthPercent)
        local fillY = self.Settings.healthbar.position == "bottom" and hpY or (hpY + hpHeight - fillHeight)
        
        local hpColor = self.Settings.healthbar.fill or Color3.new(0, 1, 0)
        if self.Settings.healthbar.gradient then
            local low = self.Settings.healthbar.low_color or Color3.new(1, 0, 0)
            local high = self.Settings.healthbar.high_color or Color3.new(0, 1, 0)
            hpColor = Color3.new(
                low.R + (high.R - low.R) * healthPercent,
                low.G + (high.G - low.G) * healthPercent,
                low.B + (high.B - low.B) * healthPercent
            )
        end
        
        local hpFill = Library:Create('Frame', {
            BackgroundColor3 = hpColor,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(hpX + 1, fillY + 1),
            Size = UDim2.fromOffset(fillWidth - 2, fillHeight - 2),
            ZIndex = 1006,
            Parent = content,
        })
        table.insert(self.Elements, hpFill)
    end
    
    -- Name Preview
    if self.Settings.name and self.Settings.name.enabled then
        local nameText = "SamplePlayer"
        if self.Settings.name.show_health then
            nameText = nameText .. " [75:100]"
        end
        if self.Settings.friends and self.Settings.friends.enabled and self.Settings.friends.show_tags then
            nameText = nameText .. " [E]"
        end
        
        local nameLabel = Library:CreateLabel({
            Position = UDim2.fromOffset(centerX, centerY - 65),
            Size = UDim2.fromOffset(150, 20),
            Text = nameText,
            TextColor3 = self.Settings.name.fill or Color3.new(1, 1, 1),
            TextSize = math.floor((self.Settings.name.size or 13) * scale),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 1007,
            Parent = content,
        })
        table.insert(self.Elements, nameLabel)
    end
    
    -- Distance Preview
    if self.Settings.distance and self.Settings.distance.enabled then
        local distLabel = Library:CreateLabel({
            Position = UDim2.fromOffset(centerX, centerY + 55),
            Size = UDim2.fromOffset(60, 20),
            Text = "50m",
            TextColor3 = self.Settings.distance.fill or Color3.new(1, 1, 1),
            TextSize = math.floor((self.Settings.distance.size or 13) * scale),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 1007,
            Parent = content,
        })
        table.insert(self.Elements, distLabel)
    end
    
    -- Tracer Preview
    if self.Settings.tracer and self.Settings.tracer.enabled then
        local fromX, fromY = 30, 220
        if self.Settings.tracer.from == "center" then
            fromX, fromY = centerX, centerY
        elseif self.Settings.tracer.from == "mouse" then
            fromX, fromY = 80, 80
        elseif self.Settings.tracer.from == "top" then
            fromX, fromY = centerX, 40
        end
        
        local dx = centerX - fromX
        local dy = centerY - fromY
        local distance = math.sqrt(dx*dx + dy*dy)
        local angle = math.atan2(dy, dx)
        
        local tracerLine = Library:Create('Frame', {
            BackgroundColor3 = self.Settings.tracer.fill or Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(fromX, fromY - 1),
            Size = UDim2.fromOffset(distance, 2),
            ZIndex = 1004,
            Parent = content,
        })
        
        tracerLine.Rotation = math.deg(angle)
        table.insert(self.Elements, tracerLine)
    end
    
    -- Rainbow animation for preview
    if self.Settings.animations and self.Settings.animations.rainbow then
        local rainbowConnection
        rainbowConnection = RunService.Heartbeat:Connect(function()
            if not self.Container or not self.Container.Parent then
                rainbowConnection:Disconnect()
                return
            end
            
            local speed = (self.Settings.animations.rainbow_speed or 0.03) * 2
            local hue = (tick() * speed) % 1
            local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
            
            for _, element in pairs(self.Elements) do
                if element and element.Parent then
                    if element:IsA('Frame') and element.BorderSizePixel > 0 then
                        element.BorderColor3 = rainbowColor
                    elseif element:IsA('Frame') and element.BorderSizePixel == 0 then
                        element.BackgroundColor3 = rainbowColor
                    elseif element:IsA('TextLabel') then
                        element.TextColor3 = rainbowColor
                    end
                end
            end
        end)
        
        table.insert(Library.Signals, rainbowConnection)
    end
    
    -- Add info text
    local infoLabel = Library:CreateLabel({
        Position = UDim2.fromOffset(10, 200),
        Size = UDim2.fromOffset(300, 30),
        Text = "🎯 Live preview updates with your settings",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1007,
        Parent = content,
    })
    table.insert(self.Elements, infoLabel)
end

function Library.ESPPreview:DestroyPreview()
    if self.Container then
        -- Notification-style slide out
        local slideOut = TweenService:Create(self.Container, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {
                Position = UDim2.fromOffset(-320, self.Container.Position.Y.Offset),
                BackgroundTransparency = 1
            }
        )
        slideOut:Play()
        
        for _, child in pairs(self.Container:GetDescendants()) do
            if child:IsA('Frame') or child:IsA('TextLabel') or child:IsA('TextButton') then
                TweenService:Create(child, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
                    {BackgroundTransparency = 1}
                ):Play()
                if child:IsA('TextLabel') or child:IsA('TextButton') then
                    TweenService:Create(child, 
                        TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
                        {TextTransparency = 1}
                    ):Play()
                end
            end
        end
        
        slideOut.Completed:Connect(function()
            self.Container:Destroy()
            self.Container = nil
        end)
    end
    self.Elements = {}
end

function Library.ESPPreview:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self:CreatePreview()
    else
        self:DestroyPreview()
    end
end
-- ORIGINAL LINORIA FUNCTIONS (keeping the classic style)

local function GetPlayersString()
    local PlayerList = Players:GetPlayers();
    for i = 1, #PlayerList do
        PlayerList[i] = PlayerList[i].Name;
    end;
    table.sort(PlayerList, function(str1, str2) return str1 < str2 end);
    return PlayerList;
end;

local function GetTeamsString()
    local TeamList = Teams:GetTeams();
    for i = 1, #TeamList do
        TeamList[i] = TeamList[i].Name;
    end;
    table.sort(TeamList, function(str1, str2) return str1 < str2 end);
    return TeamList;
end;

function Library:SafeCallback(f, ...)
    if (not f) then
        return;
    end;
    local success, event = pcall(f, ...);
    if not success then
        local _, i = event:find(":%d+: ");
        if not i then
            return Library:Notify(event);
        end;
        return Library:Notify(event:sub(i + 1), 3);
    end;
end;

function Library:AttemptSave()
    if Library.SaveManager then
        Library.SaveManager:Save();
    end;
end;

function Library:Create(Class, Properties)
    local _Instance = Class;
    if type(Class) == 'string' then
        _Instance = Instance.new(Class);
    end;
    for Property, Value in next, Properties do
        _Instance[Property] = Value;
    end;
    return _Instance;
end;

function Library:ApplyTextStroke(Inst)
    Inst.TextStrokeTransparency = 1;
    Library:Create('UIStroke', {
        Color = Color3.new(0, 0, 0);
        Thickness = 1;
        LineJoinMode = Enum.LineJoinMode.Miter;
        Parent = Inst;
    });
end;

function Library:CreateLabel(Properties, IsHud)
    local _Instance = Library:Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Library.Font;
        TextColor3 = Library.FontColor;
        TextSize = 16;
        TextStrokeTransparency = 0;
    });
    Library:ApplyTextStroke(_Instance);
    Library:AddToRegistry(_Instance, {
        TextColor3 = 'FontColor';
    }, IsHud);
    return Library:Create(_Instance, Properties);
end;

function Library:MakeDraggable(Instance, Cutoff)
    Instance.Active = true;
    Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ObjPos = Vector2.new(
                Mouse.X - Instance.AbsolutePosition.X,
                Mouse.Y - Instance.AbsolutePosition.Y
            );
            if ObjPos.Y > (Cutoff or 40) then
                return;
            end;
            while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                Instance.Position = UDim2.new(
                    0, Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                    0, Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                );
                RenderStepped:Wait();
            end;
        end;
    end)
end;
function Library:AddToRegistry(Instance, Properties, IsHud)
    local Reg = {
        Instance = Instance;
        Properties = Properties;
        UpdateCallback = function()
            for Property, ColorIdx in next, Properties do
                Instance[Property] = Library[ColorIdx];
            end;
        end;
    };
    if IsHud then
        table.insert(Library.HudRegistry, Reg);
    else
        table.insert(Library.Registry, Reg);
    end;
    Library.RegistryMap[Instance] = Reg;
end;

function Library:RemoveFromRegistry(Instance)
    local Reg = Library.RegistryMap[Instance];
    if not Reg then
        return;
    end;
    for Idx, RegEntry in next, Library.Registry do
        if RegEntry == Reg then
            table.remove(Library.Registry, Idx);
            break;
        end;
    end;
    for Idx, RegEntry in next, Library.HudRegistry do
        if RegEntry == Reg then
            table.remove(Library.HudRegistry, Idx);
            break;
        end;
    end;
    Library.RegistryMap[Instance] = nil;
end;

function Library:UpdateColorsUsingRegistry()
    for _, Object in next, Library.Registry do
        Object.UpdateCallback();
    end;
    for _, Object in next, Library.HudRegistry do
        Object.UpdateCallback();
    end;
end;

-- ENHANCED NOTIFICATION SYSTEM (keeping the beautiful style you like)
function Library:Notify(Text, Time)
    if not Text then
        return;
    end;
    Time = Time or 5;
    
    local NotificationContainer = Library.ScreenGui:FindFirstChild('NotificationContainer');
    if not NotificationContainer then
        NotificationContainer = Library:Create('Frame', {
            Name = 'NotificationContainer';
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 20, 0, 20);
            Size = UDim2.new(0, 300, 1, -40);
            ZIndex = 10000;
            Parent = Library.ScreenGui;
        });
    end;
    
    local Notification = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderSizePixel = 2;
        Size = UDim2.new(1, 0, 0, 60);
        ZIndex = 10001;
        Parent = NotificationContainer;
    });
    
    Library:AddToRegistry(Notification, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'AccentColor';
    });
    
    -- Beautiful gradient background (the style you like)
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.MainColor),
            ColorSequenceKeypoint.new(1, Color3.new(
                Library.MainColor.R * 0.8,
                Library.MainColor.G * 0.8,
                Library.MainColor.B * 0.8
            )),
        });
        Rotation = 45;
        Parent = Notification;
    });
    
    local NotificationLabel = Library:Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Library.Font;
        Position = UDim2.new(0, 10, 0, 0);
        Size = UDim2.new(1, -20, 1, 0);
        Text = Text;
        TextColor3 = Library.FontColor;
        TextSize = 14;
        TextStrokeTransparency = 0;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 10002;
        Parent = Notification;
    });
    
    Library:ApplyTextStroke(NotificationLabel);
    Library:AddToRegistry(NotificationLabel, {
        TextColor3 = 'FontColor';
    })
    
    -- Beautiful slide-in animation (the style you like)
    Notification.Position = UDim2.new(0, -320, 0, 0);
    local slideIn = TweenService:Create(Notification, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, 0)}
    );
    slideIn:Play();
    
    -- Auto-position notifications
    local function UpdatePositions()
        for i, child in ipairs(NotificationContainer:GetChildren()) do
            if child:IsA('Frame') then
                local targetPos = UDim2.new(0, 0, 0, (i - 1) * 70);
                TweenService:Create(child, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {Position = targetPos}
                ):Play();
            end;
        end;
    end;
    
    UpdatePositions();
    
    -- Auto-remove after time
    task.spawn(function()
        task.wait(Time);
        local slideOut = TweenService:Create(Notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Position = UDim2.new(0, -320, 0, Notification.Position.Y.Offset)}
        );
        slideOut:Play();
        slideOut.Completed:Connect(function()
            Notification:Destroy();
            UpdatePositions();
        end);
    end);
end;
-- ORIGINAL LINORIA WINDOW CREATION (classic style)
function Library:CreateWindow(Options)
    Options = Options or {};
    
    local Window = {
        Tabs = {};
        TabCount = 0;
        Options = Options;
    };
    
    -- Original Linoria window size (classic)
    local WindowSize = UDim2.fromOffset(550, 600);
    
    local WindowFrame = Library:Create('Frame', {
        Name = 'WindowFrame';
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 2;
        Position = UDim2.fromScale(0.5, 0.5);
        AnchorPoint = Vector2.new(0.5, 0.5);
        Size = WindowSize;
        ZIndex = 1;
        Visible = false;
        Parent = Library.ScreenGui;
    });
    
    Library:AddToRegistry(WindowFrame, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });
    
    -- Original Linoria title bar (classic style)
    local TitleBar = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 35);
        ZIndex = 2;
        Parent = WindowFrame;
    });
    
    Library:AddToRegistry(TitleBar, {BackgroundColor3 = 'AccentColor'});
    
    -- Classic title (no fancy animations, just clean)
    local TitleLabel = Library:CreateLabel({
        Position = UDim2.new(0, 10, 0, 0);
        Size = UDim2.new(1, -120, 1, 0);
        Text = Options.Title or 'Linoria Library';
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 16;
        Font = Enum.Font.Code;
        ZIndex = 3;
        Parent = TitleBar;
    });
    
    -- Classic close button
    local CloseButton = Library:Create('TextButton', {
        BackgroundColor3 = Library.RiskColor;
        BorderSizePixel = 0;
        Position = UDim2.new(1, -30, 0, 5);
        Size = UDim2.fromOffset(25, 25);
        Text = '×';
        TextColor3 = Color3.new(1, 1, 1);
        TextSize = 18;
        Font = Enum.Font.Code;
        ZIndex = 4;
        Parent = TitleBar;
    });
    
    CloseButton.MouseButton1Click:Connect(function()
        Library:SafeCallback(Window.CloseCallback);
        WindowFrame.Visible = false;
    end);
    
    -- Classic minimize button
    local MinimizeButton = Library:Create('TextButton', {
        BackgroundColor3 = Color3.fromRGB(255, 193, 7);
        BorderSizePixel = 0;
        Position = UDim2.new(1, -60, 0, 5);
        Size = UDim2.fromOffset(25, 25);
        Text = '−';
        TextColor3 = Color3.new(1, 1, 1);
        TextSize = 18;
        Font = Enum.Font.Code;
        ZIndex = 4;
        Parent = TitleBar;
    });
    
    local IsMinimized = false;
    MinimizeButton.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized;
        local targetSize = IsMinimized and UDim2.fromOffset(WindowSize.X.Offset, 35) or WindowSize;
        WindowFrame.Size = targetSize; -- No animation, instant like classic Linoria
    end);
    
    -- Classic tab container
    local TabContainer = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderSizePixel = 0;
        Position = UDim2.fromOffset(0, 35);
        Size = UDim2.new(1, 0, 0, 40);
        ZIndex = 2;
        Parent = WindowFrame;
    });
    
    Library:AddToRegistry(TabContainer, {BackgroundColor3 = 'BackgroundColor'});
    
    -- Classic content container
    local ContentContainer = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.fromOffset(0, 75);
        Size = UDim2.new(1, 0, 1, -75);
        ZIndex = 1;
        Parent = WindowFrame;
    });
    
    Library:MakeDraggable(WindowFrame, 35);
    
    Window.Frame = WindowFrame;
    Window.TabContainer = TabContainer;
    Window.ContentContainer = ContentContainer;
    
    -- Classic show/hide (no fancy animations)
    function Window:Show()
        WindowFrame.Visible = true;
    end;
    
    function Window:Hide()
        WindowFrame.Visible = false;
    end;
    
    return Window;
end;
-- ORIGINAL LINORIA TAB CREATION (classic style)
function Library:CreateTab(Window, Name)
    local Tab = {
        Name = Name;
        Groupboxes = {};
        GroupboxCount = 0;
    };
    
    Window.TabCount = Window.TabCount + 1;
    
    -- Classic tab button (no fancy animations)
    local TabButton = Library:Create('TextButton', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset((Window.TabCount - 1) * 120 + 5, 5);
        Size = UDim2.fromOffset(115, 30);
        Text = Name;
        TextColor3 = Library.FontColor;
        TextSize = 14;
        Font = Library.Font;
        ZIndex = 3;
        Parent = Window.TabContainer;
    });
    
    Library:AddToRegistry(TabButton, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
        TextColor3 = 'FontColor';
    });
    
    -- Classic tab content frame
    local TabFrame = Library:Create('ScrollingFrame', {
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        ScrollBarThickness = 6;
        ScrollBarImageColor3 = Library.AccentColor;
        CanvasSize = UDim2.fromOffset(0, 0);
        ZIndex = 2;
        Visible = false;
        Parent = Window.ContentContainer;
    });
    
    Library:AddToRegistry(TabFrame, {ScrollBarImageColor3 = 'AccentColor'});
    
    -- Classic tab switching (no fancy animations)
    TabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, OtherTab in pairs(Window.Tabs) do
            if OtherTab.Frame then
                OtherTab.Frame.Visible = false;
            end;
            if OtherTab.Button then
                OtherTab.Button.BackgroundColor3 = Library.MainColor;
            end;
        end;
        
        -- Show current tab
        TabFrame.Visible = true;
        TabButton.BackgroundColor3 = Library.AccentColor;
    end);
    
    -- Classic auto-resize canvas
    local function UpdateCanvasSize()
        if not TabFrame or not TabFrame.Parent then return end
        local ContentSize = 0;
        for _, Child in pairs(TabFrame:GetChildren()) do
            if Child:IsA('Frame') then
                ContentSize = math.max(ContentSize, Child.Position.Y.Offset + Child.Size.Y.Offset);
            end;
        end;
        TabFrame.CanvasSize = UDim2.fromOffset(0, ContentSize + 20);
    end;
    
    -- Connect events safely
    pcall(function()
        TabFrame.ChildAdded:Connect(UpdateCanvasSize);
        TabFrame.ChildRemoved:Connect(UpdateCanvasSize);
    end);
    
    Tab.Frame = TabFrame;
    Tab.Button = TabButton;
    Tab.UpdateCanvasSize = UpdateCanvasSize;
    
    Window.Tabs[Name] = Tab;
    
    -- Show first tab by default
    if Window.TabCount == 1 then
        task.spawn(function()
            task.wait(0.1)
            pcall(function()
                TabButton.MouseButton1Click:Fire()
            end)
        end)
    end;
    
    return Tab;
end;
-- ORIGINAL LINORIA GROUPBOX CREATION (classic style)
function Library:CreateGroupbox(Tab, Name, Side)
    Side = Side or 'Left';
    local Groupbox = {
        Name = Name;
        Side = Side;
        Elements = {};
    };
    
    Tab.GroupboxCount = Tab.GroupboxCount + 1;
    
    -- Calculate position based on side and existing groupboxes
    local XOffset = Side == 'Left' and 10 or (Tab.Frame.AbsoluteSize.X / 2 + 5);
    local YOffset = 10;
    
    -- Find Y position by checking existing groupboxes on same side
    for _, ExistingGroupbox in pairs(Tab.Groupboxes) do
        if ExistingGroupbox.Side == Side then
            YOffset = math.max(YOffset, ExistingGroupbox.Frame.Position.Y.Offset + ExistingGroupbox.Frame.Size.Y.Offset + 15);
        end;
    end;
    
    -- Classic groupbox frame (original Linoria style)
    local GroupboxFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 2;
        Position = UDim2.fromOffset(XOffset, YOffset);
        Size = UDim2.fromOffset(Tab.Frame.AbsoluteSize.X / 2 - 20, 100);
        ZIndex = 3;
        Parent = Tab.Frame;
    });
    
    Library:AddToRegistry(GroupboxFrame, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });
    
    -- Classic header (original style)
    local HeaderFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 30);
        ZIndex = 4;
        Parent = GroupboxFrame;
    });
    
    Library:AddToRegistry(HeaderFrame, {BackgroundColor3 = 'AccentColor'});
    
    -- Classic title (original style)
    local TitleLabel = Library:CreateLabel({
        Position = UDim2.new(0, 10, 0, 0);
        Size = UDim2.new(1, -20, 1, 0);
        Text = Name;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 15;
        Font = Library.Font;
        ZIndex = 5;
        Parent = HeaderFrame;
    });
    
    -- Classic content container
    local ContentFrame = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.fromOffset(5, 35);
        Size = UDim2.new(1, -10, 1, -40);
        ZIndex = 4;
        Parent = GroupboxFrame;
    });
    
    -- Classic auto-resize groupbox
    local function UpdateGroupboxSize()
        local ContentHeight = 0;
        for _, Element in pairs(Groupbox.Elements) do
            if Element.Frame and Element.Frame.Parent then
                ContentHeight = math.max(ContentHeight, Element.Frame.Position.Y.Offset + Element.Frame.Size.Y.Offset);
            end;
        end;
        
        local NewHeight = math.max(100, ContentHeight + 45);
        GroupboxFrame.Size = UDim2.fromOffset(GroupboxFrame.Size.X.Offset, NewHeight); -- No animation, instant
        
        -- Update tab canvas size
        Tab.UpdateCanvasSize();
    end;
    
    Groupbox.Frame = GroupboxFrame;
    Groupbox.ContentFrame = ContentFrame;
    Groupbox.UpdateSize = UpdateGroupboxSize;
    
    Tab.Groupboxes[Name] = Groupbox;
    
    -- ESP PREVIEW INTEGRATION - Special handling for ESP-related groupboxes
    if Name:lower():find('esp') or Name:lower():find('visual') or Name:lower():find('render') then
        -- Add ESP Preview button automatically (with classic style)
        task.spawn(function()
            task.wait(0.1);
            local PreviewButton = Library:Create('TextButton', {
                BackgroundColor3 = Color3.fromRGB(100, 200, 255);
                BorderSizePixel = 0;
                Position = UDim2.new(1, -80, 0, 5);
                Size = UDim2.fromOffset(70, 20);
                Text = '👁️ Preview';
                TextColor3 = Color3.new(1, 1, 1);
                TextSize = 12;
                Font = Library.Font;
                ZIndex = 6;
                Parent = HeaderFrame;
            });
            
            PreviewButton.MouseButton1Click:Connect(function()
                -- Toggle ESP Preview
                Library.ESPPreview:Toggle(not Library.ESPPreview.Enabled);
                PreviewButton.Text = Library.ESPPreview.Enabled and '👁️ Hide' or '👁️ Preview';
                PreviewButton.BackgroundColor3 = Library.ESPPreview.Enabled and 
                    Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 200, 255);
            end);
        end);
    end;
    
    return Groupbox;
end;
-- ORIGINAL LINORIA TOGGLE CREATION (classic style)
function Library:CreateToggle(Groupbox, Options)
    Options = Options or {};
    local Toggle = {
        Value = Options.Default or false;
        Callback = Options.Callback or function() end;
        Flag = Options.Flag;
    };
    
    local ElementHeight = 25;
    local YOffset = #Groupbox.Elements * (ElementHeight + 5) + 5;
    
    -- Classic toggle frame
    local ToggleFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    Library:AddToRegistry(ToggleFrame, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });
    
    -- Classic toggle indicator
    local ToggleIndicator = Library:Create('Frame', {
        BackgroundColor3 = Toggle.Value and Library.AccentColor or Color3.fromRGB(100, 100, 100);
        BorderSizePixel = 0;
        Position = UDim2.fromOffset(5, 5);
        Size = UDim2.fromOffset(15, 15);
        ZIndex = 6;
        Parent = ToggleFrame;
    });
    
    -- Classic toggle label
    local ToggleLabel = Library:CreateLabel({
        Position = UDim2.fromOffset(25, 0);
        Size = UDim2.new(1, -30, 1, 0);
        Text = Options.Text or 'Toggle';
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 6;
        Parent = ToggleFrame;
    });
    
    -- Classic click handling (no fancy animations)
    local ToggleButton = Library:Create('TextButton', {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 1, 0);
        Text = '';
        ZIndex = 7;
        Parent = ToggleFrame;
    });
    
    ToggleButton.MouseButton1Click:Connect(function()
        Toggle.Value = not Toggle.Value;
        
        -- Instant color change (no animation)
        local TargetColor = Toggle.Value and Library.AccentColor or Color3.fromRGB(100, 100, 100);
        ToggleIndicator.BackgroundColor3 = TargetColor;
        
        -- Update ESP Preview if this is an ESP setting
        if Library.ESPPreview.Enabled and Library.ESPPreview.Settings then
            task.spawn(function()
                task.wait(0.1);
                Library.ESPPreview:UpdatePreview();
            end);
        end;
        
        Library:SafeCallback(Toggle.Callback, Toggle.Value);
        Library:AttemptSave();
    end);
    
    -- Store in options if flag provided
    if Toggle.Flag then
        Options[Toggle.Flag] = Toggle;
    end;
    
    Toggle.Frame = ToggleFrame;
    Toggle.SetValue = function(Value)
        Toggle.Value = Value;
        local TargetColor = Value and Library.AccentColor or Color3.fromRGB(100, 100, 100);
        ToggleIndicator.BackgroundColor3 = TargetColor;
        Library:SafeCallback(Toggle.Callback, Value);
    end;
    
    table.insert(Groupbox.Elements, Toggle);
    Groupbox.UpdateSize();
    
    return Toggle;
end;

function Library:AddToggle(Groupbox, Flag, Options)
    Options = Options or {};
    Options.Flag = Flag;
    local Toggle = self:CreateToggle(Groupbox, Options);
    if Flag then
        Toggles[Flag] = Toggle;
    end;
    return Toggle;
end;
-- ORIGINAL LINORIA BUTTON CREATION (classic style)
function Library:CreateButton(Groupbox, Options)
    Options = Options or {};
    local Button = {
        Callback = Options.Func or function() end;
    };
    
    local ElementHeight = 30;
    local YOffset = #Groupbox.Elements * 35 + 5;
    
    -- Classic button frame
    local ButtonFrame = Library:Create('TextButton', {
        BackgroundColor3 = Library.AccentColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        Text = Options.Text or 'Button';
        TextColor3 = Color3.new(1, 1, 1);
        TextSize = 14;
        Font = Library.Font;
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    Library:AddToRegistry(ButtonFrame, {
        BackgroundColor3 = 'AccentColor';
        BorderColor3 = 'OutlineColor';
    });
    
    ButtonFrame.MouseButton1Click:Connect(function()
        Library:SafeCallback(Button.Callback);
    end);
    
    Button.Frame = ButtonFrame;
    table.insert(Groupbox.Elements, Button);
    Groupbox.UpdateSize();
    
    return Button;
end;

function Library:AddButton(Groupbox, Options)
    return self:CreateButton(Groupbox, Options);
end;

-- ORIGINAL LINORIA LABEL CREATION (classic style)
function Library:CreateGroupboxLabel(Groupbox, Text, WrapText)
    local Label = {};
    
    local ElementHeight = WrapText and 40 or 20;
    local YOffset = #Groupbox.Elements * 25 + 5;
    
    -- Classic label frame
    local LabelFrame = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    -- Classic label text
    local LabelText = Library:Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Library.Font;
        Size = UDim2.new(1, 0, 1, 0);
        Text = Text or 'Label';
        TextColor3 = Color3.fromRGB(200, 200, 200);
        TextSize = 13;
        TextStrokeTransparency = 0;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        TextWrapped = WrapText or false;
        ZIndex = 6;
        Parent = LabelFrame;
    });
    
    Library:ApplyTextStroke(LabelText);
    
    Label.Frame = LabelFrame;
    Label.SetText = function(NewText)
        LabelText.Text = NewText;
    end;
    
    table.insert(Groupbox.Elements, Label);
    Groupbox.UpdateSize();
    
    return Label;
end;

function Library:AddLabel(Groupbox, Text, WrapText)
    return self:CreateGroupboxLabel(Groupbox, Text, WrapText);
end;

-- ESP PREVIEW INTEGRATION FUNCTION
function Library:AddESPPreview(Groupbox, espSettings)
    local PreviewGroup = Groupbox
    
    PreviewGroup:AddToggle('ESPPreviewEnabled', {
        Text = '✨ Enable ESP Preview',
        Default = false,
        Callback = function(Value)
            Library.ESPPreview:SetESPSettings(espSettings)
            Library.ESPPreview:Toggle(Value)
        end
    })
    
    PreviewGroup:AddButton({
        Text = '🔄 Update Preview',
        Func = function()
            if Library.ESPPreview.Enabled then
                Library.ESPPreview:SetESPSettings(espSettings)
                Library.ESPPreview:UpdatePreview()
                Library:Notify('🔄 Preview updated!', 2)
            else
                Library:Notify('⚠️ Enable preview first!', 2)
            end
        end,
    })
    
    PreviewGroup:AddButton({
        Text = '📍 Reset Position',
        Func = function()
            if Library.ESPPreview.Container then
                Library.ESPPreview.Container.Position = UDim2.fromOffset(50, 100)
                Library:Notify('📍 Preview position reset!', 2)
            end
        end,
    })
    
    PreviewGroup:AddLabel('The ESP Preview shows a live\nrepresentation of your ESP settings.\nDrag it around and watch it update!', true)
end

-- Initialize the library
task.spawn(function()
    task.wait(0.1)
    pcall(function()
        Library:Notify('✨ Hybrid Linoria Library loaded!', 3)
    end)
end)

print('🚀 Hybrid Linoria Library initialized - Classic style + ESP Preview + Beautiful notifications')

-- Return the hybrid library
return Library;
