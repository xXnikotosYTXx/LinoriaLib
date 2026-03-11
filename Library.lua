-- ENHANCED LINORIA LIBRARY with ESP Preview & Improved Design
-- Модифицированная версия Linoria с встроенными улучшениями

local InputService = game:GetService('UserInputService');
local TextService = game:GetService('TextService');
local CoreGui = game:GetService('CoreGui');
local Teams = game:GetService('Teams');
local Players = game:GetService('Players');
local RunService = game:GetService('RunService')
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

-- ENHANCED LIBRARY with ESP Preview System
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
    
    -- ESP PREVIEW SYSTEM
    ESPPreview = {
        Enabled = false,
        Container = nil,
        Elements = {},
        Settings = nil, -- Will store ESP settings reference
    };
    
    -- ENHANCED FEATURES
    EnhancedFeatures = {
        WiderInterface = true,
        AnimatedWatermark = true,
        SmoothAnimations = true,
        ImprovedDesign = true,
    };
};

-- Rainbow animation system
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

-- ESP PREVIEW SYSTEM IMPLEMENTATION
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
    
    -- Create preview container with enhanced design
    self.Container = Library:Create('Frame', {
        Name = 'ESPPreview',
        BackgroundColor3 = Library.BackgroundColor,
        BorderColor3 = Library.AccentColor,
        Position = UDim2.fromOffset(50, 100),
        Size = UDim2.fromOffset(320, 240), -- Larger preview
        ZIndex = 1000,
        Parent = Library.ScreenGui,
    })
    
    Library:AddToRegistry(self.Container, {
        BackgroundColor3 = 'BackgroundColor',
        BorderColor3 = 'AccentColor'
    })
    
    -- Animated header with gradient
    local header = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        ZIndex = 1001,
        Parent = self.Container,
    })
    
    Library:AddToRegistry(header, {BackgroundColor3 = 'AccentColor'})
    
    -- Header gradient
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.AccentColor),
            ColorSequenceKeypoint.new(1, Library:GetDarkerColor(Library.AccentColor)),
        }),
        Rotation = 90,
        Parent = header,
    })
    
    -- Animated title
    local title = Library:CreateLabel({
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        Text = '✨ ESP Preview - Live',
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1002,
        Parent = header,
    })
    
    -- Close button
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
    
    -- Preview content area with dark background
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
    
    -- Add smooth fade-in animation
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
    
    -- Animate in
    local fadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(self.Container, fadeInfo, {BackgroundTransparency = 0}):Play()
    
    for _, child in pairs(self.Container:GetDescendants()) do
        if child:IsA('Frame') or child:IsA('TextLabel') or child:IsA('TextButton') then
            local originalTrans = child:GetAttribute('OriginalTransparency') or 0
            TweenService:Create(child, fadeInfo, {BackgroundTransparency = originalTrans}):Play()
            if child:IsA('TextLabel') or child:IsA('TextButton') then
                TweenService:Create(child, fadeInfo, {TextTransparency = 0}):Play()
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
    
    -- Box ESP Preview with enhanced visuals
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
                    ZIndex = 1002 + (4 - i), -- Reverse Z-order for proper layering
                    Parent = content,
                })
                
                -- Animate glow opacity
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
    
    -- Enhanced Healthbar Preview
    if self.Settings.healthbar and self.Settings.healthbar.enabled then
        local healthPercent = 0.75
        local hpWidth, hpHeight = 4, 80
        local hpX = centerX - 35
        
        -- Position based on setting
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
        
        -- Healthbar background with border
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
        
        -- Healthbar fill with gradient
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
    
    -- Enhanced Name Preview
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
    
    -- Enhanced Tracer Preview
    if self.Settings.tracer and self.Settings.tracer.enabled then
        local fromX, fromY = 30, 220
        if self.Settings.tracer.from == "center" then
            fromX, fromY = centerX, centerY
        elseif self.Settings.tracer.from == "mouse" then
            fromX, fromY = 80, 80
        elseif self.Settings.tracer.from == "top" then
            fromX, fromY = centerX, 40
        end
        
        -- Create tracer line using multiple frames for smooth line
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
        
        -- Rotate the line
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
            
            local speed = (self.Settings.animations.rainbow_speed or 0.03) * 2 -- Faster for preview
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
        -- Smooth fade out
        local fadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(self.Container, fadeInfo, {BackgroundTransparency = 1}):Play()
        
        for _, child in pairs(self.Container:GetDescendants()) do
            if child:IsA('Frame') or child:IsA('TextLabel') or child:IsA('TextButton') then
                TweenService:Create(child, fadeInfo, {BackgroundTransparency = 1}):Play()
                if child:IsA('TextLabel') or child:IsA('TextButton') then
                    TweenService:Create(child, fadeInfo, {TextTransparency = 1}):Play()
                end
            end
        end
        
        task.wait(0.2)
        self.Container:Destroy()
        self.Container = nil
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

-- Enhanced AddESPPreview function for groupboxes
function Library:AddESPPreview(groupbox, espSettings)
    local PreviewGroup = groupbox
    
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
        Tooltip = 'Refresh preview with current settings'
    })
    
    PreviewGroup:AddButton({
        Text = '📍 Reset Position',
        Func = function()
            if Library.ESPPreview.Container then
                local resetInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                TweenService:Create(Library.ESPPreview.Container, resetInfo, {
                    Position = UDim2.fromOffset(50, 100)
                }):Play()
                Library:Notify('📍 Preview position reset!', 2)
            end
        end,
        Tooltip = 'Move preview back to default position'
    })
    
    PreviewGroup:AddLabel('The ESP Preview shows a live\nrepresentation of your ESP settings.\nDrag it around and watch it update!', true)
end

-- Continue with original Library functions...
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
    if not Library.NotifyOnError then
        return f(...);
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
-- Enhanced color utilities
function Library:GetDarkerColor(color, factor)
    factor = factor or 0.8
    return Color3.new(color.R * factor, color.G * factor, color.B * factor)
end

function Library:GetLighterColor(color, factor)
    factor = factor or 1.2
    return Color3.new(
        math.min(color.R * factor, 1),
        math.min(color.G * factor, 1),
        math.min(color.B * factor, 1)
    )
end

-- Enhanced registry system
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

-- Enhanced notification system
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
    
    -- Enhanced gradient background
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.MainColor),
            ColorSequenceKeypoint.new(1, Library:GetDarkerColor(Library.MainColor)),
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
    });
    
    -- Smooth slide-in animation
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

-- Enhanced window creation
function Library:CreateWindow(Options)
    Options = Options or {};
    
    local Window = {
        Tabs = {};
        TabCount = 0;
        Options = Options;
    };
    
    -- Enhanced window size for wider interface
    local WindowSize = Library.EnhancedFeatures.WiderInterface and 
        UDim2.fromOffset(720, 650) or UDim2.fromOffset(550, 600);
    
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
    
    -- Enhanced window gradient
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.MainColor),
            ColorSequenceKeypoint.new(1, Library:GetDarkerColor(Library.MainColor, 0.9)),
        });
        Rotation = 135;
        Parent = WindowFrame;
    });
    
    -- Enhanced title bar with animated watermark
    local TitleBar = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 35);
        ZIndex = 2;
        Parent = WindowFrame;
    });
    
    Library:AddToRegistry(TitleBar, {BackgroundColor3 = 'AccentColor'});
    
    -- Animated title bar gradient
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.AccentColor),
            ColorSequenceKeypoint.new(0.5, Library:GetLighterColor(Library.AccentColor, 1.1)),
            ColorSequenceKeypoint.new(1, Library.AccentColor),
        });
        Rotation = 90;
        Parent = TitleBar;
    });
    
    -- Animated watermark with rainbow effect
    local WatermarkText = Options.Title or 'Enhanced Linoria Library';
    if Library.EnhancedFeatures.AnimatedWatermark then
        WatermarkText = '✨ ' .. WatermarkText .. ' ✨';
    end;
    
    local TitleLabel = Library:CreateLabel({
        Position = UDim2.new(0, 10, 0, 0);
        Size = UDim2.new(1, -120, 1, 0);
        Text = WatermarkText;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 16;
        Font = Enum.Font.GothamBold;
        ZIndex = 3;
        Parent = TitleBar;
    });
    
    -- Rainbow watermark animation
    if Library.EnhancedFeatures.AnimatedWatermark then
        table.insert(Library.Signals, RunService.Heartbeat:Connect(function()
            if TitleLabel and TitleLabel.Parent then
                TitleLabel.TextColor3 = Library.CurrentRainbowColor or Library.FontColor;
            end;
        end));
    end;
    
    -- Enhanced close button
    local CloseButton = Library:Create('TextButton', {
        BackgroundColor3 = Library.RiskColor;
        BorderSizePixel = 0;
        Position = UDim2.new(1, -30, 0, 5);
        Size = UDim2.fromOffset(25, 25);
        Text = '×';
        TextColor3 = Color3.new(1, 1, 1);
        TextSize = 18;
        Font = Enum.Font.GothamBold;
        ZIndex = 4;
        Parent = TitleBar;
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = CloseButton});
    
    CloseButton.MouseButton1Click:Connect(function()
        Library:SafeCallback(Window.CloseCallback);
        WindowFrame.Visible = false;
    end);
    
    -- Enhanced minimize button
    local MinimizeButton = Library:Create('TextButton', {
        BackgroundColor3 = Color3.fromRGB(255, 193, 7);
        BorderSizePixel = 0;
        Position = UDim2.new(1, -60, 0, 5);
        Size = UDim2.fromOffset(25, 25);
        Text = '−';
        TextColor3 = Color3.new(1, 1, 1);
        TextSize = 18;
        Font = Enum.Font.GothamBold;
        ZIndex = 4;
        Parent = TitleBar;
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = MinimizeButton});
    
    local IsMinimized = false;
    MinimizeButton.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized;
        local targetSize = IsMinimized and UDim2.fromOffset(WindowSize.X.Offset, 35) or WindowSize;
        TweenService:Create(WindowFrame, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = targetSize}
        ):Play();
    end);
    
    -- Tab container with enhanced design
    local TabContainer = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderSizePixel = 0;
        Position = UDim2.fromOffset(0, 35);
        Size = UDim2.new(1, 0, 0, 40);
        ZIndex = 2;
        Parent = WindowFrame;
    });
    
    Library:AddToRegistry(TabContainer, {BackgroundColor3 = 'BackgroundColor'});
    
    -- Content container
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
    
    -- Enhanced show/hide with smooth animations
    function Window:Show()
        WindowFrame.Visible = true;
        WindowFrame.Size = UDim2.fromOffset(0, 0);
        local showTween = TweenService:Create(WindowFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = WindowSize}
        );
        showTween:Play();
    end;
    
    function Window:Hide()
        local hideTween = TweenService:Create(WindowFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Size = UDim2.fromOffset(0, 0)}
        );
        hideTween:Play();
        hideTween.Completed:Connect(function()
            WindowFrame.Visible = false;
        end);
    end;
    
    return Window;
end;
-- Enhanced Tab Creation
function Library:CreateTab(Window, Name)
    local Tab = {
        Name = Name;
        Groupboxes = {};
        GroupboxCount = 0;
    };
    
    Window.TabCount = Window.TabCount + 1;
    
    -- Enhanced tab button with smooth animations
    local TabButton = Library:Create('TextButton', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset((Window.TabCount - 1) * 120 + 5, 5);
        Size = UDim2.fromOffset(115, 30);
        Text = Name;
        TextColor3 = Library.FontColor;
        TextSize = 14;
        Font = Enum.Font.Gotham;
        ZIndex = 3;
        Parent = Window.TabContainer;
    });
    
    Library:AddToRegistry(TabButton, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
        TextColor3 = 'FontColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 6), Parent = TabButton});
    
    -- Tab content frame
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
    
    -- Enhanced tab switching with smooth transitions
    TabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs with fade out
        if Window.Tabs then
            for _, OtherTab in pairs(Window.Tabs) do
                if OtherTab.Frame and OtherTab.Frame.Visible then
                    pcall(function()
                        local fadeOut = TweenService:Create(OtherTab.Frame,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                            {ScrollBarImageTransparency = 1}
                        );
                        fadeOut:Play();
                        fadeOut.Completed:Connect(function()
                            OtherTab.Frame.Visible = false;
                        end);
                    end);
                end;
                -- Reset button colors
                if OtherTab.Button then
                    pcall(function()
                        TweenService:Create(OtherTab.Button,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Library.MainColor}
                        ):Play();
                    end);
                end;
            end;
        end;
        
        -- Show current tab with fade in
        TabFrame.Visible = true;
        TabFrame.ScrollBarImageTransparency = 1;
        pcall(function()
            local fadeIn = TweenService:Create(TabFrame,
                TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {ScrollBarImageTransparency = 0}
            );
            fadeIn:Play();
        end);
        
        -- Highlight active button
        pcall(function()
            TweenService:Create(TabButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Library.AccentColor}
            ):Play();
        end);
    end);
    
    -- Auto-resize canvas
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
            task.wait(0.1) -- Small delay to ensure everything is ready
            pcall(function()
                TabButton.MouseButton1Click:Fire()
            end)
        end)
    end;
    
    return Tab;
end;

-- Enhanced Groupbox Creation with ESP Preview Support
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
    
    -- Enhanced groupbox frame with improved design
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
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 8), Parent = GroupboxFrame});
    
    -- Enhanced gradient background
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.BackgroundColor),
            ColorSequenceKeypoint.new(1, Library:GetDarkerColor(Library.BackgroundColor, 0.95)),
        });
        Rotation = 45;
        Parent = GroupboxFrame;
    });
    
    -- Enhanced header with glow effect
    local HeaderFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 30);
        ZIndex = 4;
        Parent = GroupboxFrame;
    });
    
    Library:AddToRegistry(HeaderFrame, {BackgroundColor3 = 'AccentColor'});
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 6), Parent = HeaderFrame});
    
    -- Header gradient
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.AccentColor),
            ColorSequenceKeypoint.new(1, Library:GetDarkerColor(Library.AccentColor, 0.8)),
        });
        Rotation = 90;
        Parent = HeaderFrame;
    });
    
    -- Enhanced title with icon support
    local TitleIcon = Name:match('^[✨🎯🔧⚙️🎨🌈💫🔥⭐🚀💎🎪🎭🎨]') and Name:sub(1, 4) or '';
    local TitleText = TitleIcon ~= '' and Name:sub(5) or Name;
    
    local TitleLabel = Library:CreateLabel({
        Position = UDim2.new(0, 10, 0, 0);
        Size = UDim2.new(1, -20, 1, 0);
        Text = Name;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 15;
        Font = Enum.Font.GothamBold;
        ZIndex = 5;
        Parent = HeaderFrame;
    });
    
    -- Content container with padding
    local ContentFrame = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.fromOffset(5, 35);
        Size = UDim2.new(1, -10, 1, -40);
        ZIndex = 4;
        Parent = GroupboxFrame;
    });
    
    -- Auto-resize groupbox based on content
    local function UpdateGroupboxSize()
        local ContentHeight = 0;
        for _, Element in pairs(Groupbox.Elements) do
            if Element.Frame and Element.Frame.Parent then
                ContentHeight = math.max(ContentHeight, Element.Frame.Position.Y.Offset + Element.Frame.Size.Y.Offset);
            end;
        end;
        
        local NewHeight = math.max(100, ContentHeight + 45);
        
        -- Smooth resize animation
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(GroupboxFrame,
                TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Size = UDim2.fromOffset(GroupboxFrame.Size.X.Offset, NewHeight)}
            ):Play();
        else
            GroupboxFrame.Size = UDim2.fromOffset(GroupboxFrame.Size.X.Offset, NewHeight);
        end;
        
        -- Update tab canvas size
        Tab.UpdateCanvasSize();
    end;
    
    Groupbox.Frame = GroupboxFrame;
    Groupbox.ContentFrame = ContentFrame;
    Groupbox.UpdateSize = UpdateGroupboxSize;
    
    Tab.Groupboxes[Name] = Groupbox;
    
    -- ESP PREVIEW INTEGRATION - Special handling for ESP-related groupboxes
    if Name:lower():find('esp') or Name:lower():find('visual') or Name:lower():find('render') then
        -- Add ESP Preview button automatically
        task.spawn(function()
            task.wait(0.1); -- Wait for groupbox to be fully created
            local PreviewButton = Library:Create('TextButton', {
                BackgroundColor3 = Color3.fromRGB(100, 200, 255);
                BorderSizePixel = 0;
                Position = UDim2.new(1, -80, 0, 5);
                Size = UDim2.fromOffset(70, 20);
                Text = '👁️ Preview';
                TextColor3 = Color3.new(1, 1, 1);
                TextSize = 12;
                Font = Enum.Font.Gotham;
                ZIndex = 6;
                Parent = HeaderFrame;
            });
            
            Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = PreviewButton});
            
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
-- Enhanced Toggle Creation
function Library:CreateToggle(Groupbox, Options)
    Options = Options or {};
    local Toggle = {
        Value = Options.Default or false;
        Callback = Options.Callback or function() end;
        Flag = Options.Flag;
    };
    
    local ElementHeight = 25;
    local YOffset = #Groupbox.Elements * (ElementHeight + 5) + 5;
    
    -- Enhanced toggle frame with hover effects
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
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = ToggleFrame});
    
    -- Enhanced toggle indicator with smooth animations
    local ToggleIndicator = Library:Create('Frame', {
        BackgroundColor3 = Toggle.Value and Library.AccentColor or Color3.fromRGB(100, 100, 100);
        BorderSizePixel = 0;
        Position = UDim2.fromOffset(5, 5);
        Size = UDim2.fromOffset(15, 15);
        ZIndex = 6;
        Parent = ToggleFrame;
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 3), Parent = ToggleIndicator});
    
    -- Enhanced toggle label
    local ToggleLabel = Library:CreateLabel({
        Position = UDim2.fromOffset(25, 0);
        Size = UDim2.new(1, -30, 1, 0);
        Text = Options.Text or 'Toggle';
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 6;
        Parent = ToggleFrame;
    });
    
    -- Enhanced click handling with smooth animations
    local ToggleButton = Library:Create('TextButton', {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 1, 0);
        Text = '';
        ZIndex = 7;
        Parent = ToggleFrame;
    });
    
    -- Hover effects
    ToggleButton.MouseEnter:Connect(function()
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(ToggleFrame,
                TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Library:GetLighterColor(Library.MainColor, 1.1)}
            ):Play();
        end;
    end);
    
    ToggleButton.MouseLeave:Connect(function()
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(ToggleFrame,
                TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Library.MainColor}
            ):Play();
        end;
    end);
    
    ToggleButton.MouseButton1Click:Connect(function()
        Toggle.Value = not Toggle.Value;
        
        -- Smooth color transition
        local TargetColor = Toggle.Value and Library.AccentColor or Color3.fromRGB(100, 100, 100);
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(ToggleIndicator,
                TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = TargetColor}
            ):Play();
        else
            ToggleIndicator.BackgroundColor3 = TargetColor;
        end;
        
        -- Update ESP Preview if this is an ESP setting
        if Library.ESPPreview.Enabled and Library.ESPPreview.Settings then
            task.spawn(function()
                task.wait(0.1); -- Small delay for setting to update
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

-- Enhanced Slider Creation
function Library:CreateSlider(Groupbox, Options)
    Options = Options or {};
    local Slider = {
        Value = Options.Default or Options.Min or 0;
        Min = Options.Min or 0;
        Max = Options.Max or 100;
        Increment = Options.Increment or 1;
        Callback = Options.Callback or function() end;
        Flag = Options.Flag;
    };
    
    local ElementHeight = 45;
    local YOffset = #Groupbox.Elements * 30 + 5;
    
    -- Enhanced slider frame
    local SliderFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    Library:AddToRegistry(SliderFrame, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = SliderFrame});
    
    -- Enhanced slider label
    local SliderLabel = Library:CreateLabel({
        Position = UDim2.fromOffset(5, 0);
        Size = UDim2.new(1, -60, 0, 20);
        Text = Options.Text or 'Slider';
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 6;
        Parent = SliderFrame;
    });
    
    -- Enhanced value display
    local ValueLabel = Library:CreateLabel({
        Position = UDim2.new(1, -55, 0, 0);
        Size = UDim2.fromOffset(50, 20);
        Text = tostring(Slider.Value);
        TextXAlignment = Enum.TextXAlignment.Right;
        TextSize = 14;
        TextColor3 = Library.AccentColor;
        ZIndex = 6;
        Parent = SliderFrame;
    });
    
    Library:AddToRegistry(ValueLabel, {TextColor3 = 'AccentColor'});
    
    -- Enhanced slider track
    local SliderTrack = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, 25);
        Size = UDim2.new(1, -10, 0, 15);
        ZIndex = 6;
        Parent = SliderFrame;
    });
    
    Library:AddToRegistry(SliderTrack, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 3), Parent = SliderTrack});
    
    -- Enhanced slider fill with gradient
    local SliderFill = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = UDim2.fromOffset(1, 1);
        Size = UDim2.new(0, 0, 1, -2);
        ZIndex = 7;
        Parent = SliderTrack;
    });
    
    Library:AddToRegistry(SliderFill, {BackgroundColor3 = 'AccentColor'});
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 2), Parent = SliderFill});
    
    -- Gradient for fill
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.AccentColor),
            ColorSequenceKeypoint.new(1, Library:GetLighterColor(Library.AccentColor, 1.2)),
        });
        Rotation = 90;
        Parent = SliderFill;
    });
    
    -- Enhanced slider handle
    local SliderHandle = Library:Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1);
        BorderColor3 = Library.AccentColor;
        BorderSizePixel = 2;
        Position = UDim2.fromOffset(-5, -2);
        Size = UDim2.fromOffset(10, 19);
        ZIndex = 8;
        Parent = SliderFill;
    });
    
    Library:AddToRegistry(SliderHandle, {BorderColor3 = 'AccentColor'});
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 5), Parent = SliderHandle});
    
    -- Update slider display
    local function UpdateSlider()
        local Percentage = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min);
        local FillWidth = Percentage * (SliderTrack.AbsoluteSize.X - 2);
        
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(SliderFill,
                TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, FillWidth, 1, -2)}
            ):Play();
        else
            SliderFill.Size = UDim2.new(0, FillWidth, 1, -2);
        end;
        
        ValueLabel.Text = tostring(Slider.Value);
        
        -- Update ESP Preview if this is an ESP setting
        if Library.ESPPreview.Enabled and Library.ESPPreview.Settings then
            task.spawn(function()
                task.wait(0.05);
                Library.ESPPreview:UpdatePreview();
            end);
        end;
    end;
    
    -- Enhanced drag handling
    local Dragging = false;
    SliderTrack.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true;
            
            -- Immediate update on click
            local MouseX = Mouse.X - SliderTrack.AbsolutePosition.X;
            local Percentage = math.clamp(MouseX / SliderTrack.AbsoluteSize.X, 0, 1);
            local NewValue = math.floor((Slider.Min + (Slider.Max - Slider.Min) * Percentage) / Slider.Increment + 0.5) * Slider.Increment;
            Slider.Value = math.clamp(NewValue, Slider.Min, Slider.Max);
            UpdateSlider();
            Library:SafeCallback(Slider.Callback, Slider.Value);
        end;
    end);
    
    InputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local MouseX = Mouse.X - SliderTrack.AbsolutePosition.X;
            local Percentage = math.clamp(MouseX / SliderTrack.AbsoluteSize.X, 0, 1);
            local NewValue = math.floor((Slider.Min + (Slider.Max - Slider.Min) * Percentage) / Slider.Increment + 0.5) * Slider.Increment;
            Slider.Value = math.clamp(NewValue, Slider.Min, Slider.Max);
            UpdateSlider();
            Library:SafeCallback(Slider.Callback, Slider.Value);
        end;
    end);
    
    InputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false;
            Library:AttemptSave();
        end;
    end);
    
    -- Store in options if flag provided
    if Slider.Flag then
        Options[Slider.Flag] = Slider;
    end;
    
    Slider.Frame = SliderFrame;
    Slider.SetValue = function(Value)
        Slider.Value = math.clamp(Value, Slider.Min, Slider.Max);
        UpdateSlider();
        Library:SafeCallback(Slider.Callback, Slider.Value);
    end;
    
    UpdateSlider();
    table.insert(Groupbox.Elements, Slider);
    Groupbox.UpdateSize();
    
    return Slider;
end;
-- Enhanced Button Creation
function Library:CreateButton(Groupbox, Options)
    Options = Options or {};
    local Button = {
        Callback = Options.Func or function() end;
    };
    
    local ElementHeight = 30;
    local YOffset = #Groupbox.Elements * 35 + 5;
    
    -- Enhanced button frame with gradient and hover effects
    local ButtonFrame = Library:Create('TextButton', {
        BackgroundColor3 = Library.AccentColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        Text = Options.Text or 'Button';
        TextColor3 = Color3.new(1, 1, 1);
        TextSize = 14;
        Font = Enum.Font.GothamBold;
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    Library:AddToRegistry(ButtonFrame, {
        BackgroundColor3 = 'AccentColor';
        BorderColor3 = 'OutlineColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 6), Parent = ButtonFrame});
    
    -- Enhanced gradient background
    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.AccentColor),
            ColorSequenceKeypoint.new(1, Library:GetDarkerColor(Library.AccentColor, 0.8)),
        });
        Rotation = 90;
        Parent = ButtonFrame;
    });
    
    -- Enhanced hover and click effects
    ButtonFrame.MouseEnter:Connect(function()
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(ButtonFrame,
                TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = Library:GetLighterColor(Library.AccentColor, 1.1);
                    Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 8, ElementHeight + 2);
                }
            ):Play();
        end;
    end);
    
    ButtonFrame.MouseLeave:Connect(function()
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(ButtonFrame,
                TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = Library.AccentColor;
                    Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
                }
            ):Play();
        end;
    end);
    
    ButtonFrame.MouseButton1Down:Connect(function()
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(ButtonFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 12, ElementHeight - 2)}
            ):Play();
        end;
    end);
    
    ButtonFrame.MouseButton1Up:Connect(function()
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(ButtonFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 8, ElementHeight + 2)}
            ):Play();
        end;
    end);
    
    ButtonFrame.MouseButton1Click:Connect(function()
        Library:SafeCallback(Button.Callback);
    end);
    
    Button.Frame = ButtonFrame;
    table.insert(Groupbox.Elements, Button);
    Groupbox.UpdateSize();
    
    return Button;
end;

-- Enhanced Label Creation for Groupboxes
function Library:CreateGroupboxLabel(Groupbox, Text, WrapText)
    local Label = {};
    
    local ElementHeight = WrapText and 40 or 20;
    local YOffset = #Groupbox.Elements * 25 + 5;
    
    -- Enhanced label frame
    local LabelFrame = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    -- Enhanced label text with better styling
    local LabelText = Library:Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Library.Font;
        Size = UDim2.new(1, 0, 1, 0);
        Text = Text or 'Label';
        TextColor3 = Color3.fromRGB(200, 200, 200);
        TextSize = 13;
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

-- Enhanced Dropdown Creation
function Library:CreateDropdown(Groupbox, Options)
    Options = Options or {};
    local Dropdown = {
        Value = Options.Default or '';
        Values = Options.Values or {};
        Multi = Options.Multi or false;
        Callback = Options.Callback or function() end;
        Flag = Options.Flag;
        IsOpen = false;
    };
    
    local ElementHeight = 25;
    local YOffset = #Groupbox.Elements * 30 + 5;
    
    -- Enhanced dropdown frame
    local DropdownFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    Library:AddToRegistry(DropdownFrame, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = DropdownFrame});
    
    -- Enhanced dropdown button
    local DropdownButton = Library:Create('TextButton', {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 1, 0);
        Text = '';
        ZIndex = 6;
        Parent = DropdownFrame;
    });
    
    -- Enhanced dropdown label
    local DropdownLabel = Library:CreateLabel({
        Position = UDim2.fromOffset(8, 0);
        Size = UDim2.new(1, -30, 1, 0);
        Text = Dropdown.Value ~= '' and Dropdown.Value or (Options.Text or 'Select...'),
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 7;
        Parent = DropdownFrame;
    });
    
    -- Enhanced dropdown arrow
    local DropdownArrow = Library:CreateLabel({
        Position = UDim2.new(1, -20, 0, 0);
        Size = UDim2.fromOffset(15, ElementHeight);
        Text = '▼';
        TextXAlignment = Enum.TextXAlignment.Center;
        TextSize = 12;
        ZIndex = 7;
        Parent = DropdownFrame;
    });
    
    -- Enhanced dropdown list (initially hidden)
    local DropdownList = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(0, ElementHeight + 2);
        Size = UDim2.fromOffset(DropdownFrame.AbsoluteSize.X, 0);
        ZIndex = 100;
        Visible = false;
        Parent = DropdownFrame;
    });
    
    Library:AddToRegistry(DropdownList, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = DropdownList});
    
    -- Function to update dropdown list
    local function UpdateDropdownList()
        -- Clear existing options
        for _, child in pairs(DropdownList:GetChildren()) do
            if child:IsA('TextButton') then
                child:Destroy();
            end;
        end;
        
        -- Create new options
        for i, value in ipairs(Dropdown.Values) do
            local OptionButton = Library:Create('TextButton', {
                BackgroundColor3 = Library.MainColor;
                BorderSizePixel = 0;
                Position = UDim2.fromOffset(2, (i - 1) * 22 + 2);
                Size = UDim2.fromOffset(DropdownList.AbsoluteSize.X - 4, 20);
                Text = value;
                TextColor3 = Library.FontColor;
                TextSize = 13;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 101;
                Parent = DropdownList;
            });
            
            Library:AddToRegistry(OptionButton, {
                BackgroundColor3 = 'MainColor';
                TextColor3 = 'FontColor';
            });
            
            Library:Create('UICorner', {CornerRadius = UDim.new(0, 3), Parent = OptionButton});
            
            -- Enhanced hover effect
            OptionButton.MouseEnter:Connect(function()
                if Library.EnhancedFeatures.SmoothAnimations then
                    TweenService:Create(OptionButton,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Library.AccentColor}
                    ):Play();
                else
                    OptionButton.BackgroundColor3 = Library.AccentColor;
                end;
            end);
            
            OptionButton.MouseLeave:Connect(function()
                if Library.EnhancedFeatures.SmoothAnimations then
                    TweenService:Create(OptionButton,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Library.MainColor}
                    ):Play();
                else
                    OptionButton.BackgroundColor3 = Library.MainColor;
                end;
            end);
            
            OptionButton.MouseButton1Click:Connect(function()
                Dropdown.Value = value;
                DropdownLabel.Text = value;
                
                -- Close dropdown with animation
                if Library.EnhancedFeatures.SmoothAnimations then
                    local closeTween = TweenService:Create(DropdownList,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                        {Size = UDim2.fromOffset(DropdownFrame.AbsoluteSize.X, 0)}
                    );
                    closeTween:Play();
                    closeTween.Completed:Connect(function()
                        DropdownList.Visible = false;
                        Dropdown.IsOpen = false;
                        DropdownArrow.Text = '▼';
                    end);
                else
                    DropdownList.Visible = false;
                    Dropdown.IsOpen = false;
                    DropdownArrow.Text = '▼';
                end;
                
                -- Update ESP Preview if this is an ESP setting
                if Library.ESPPreview.Enabled and Library.ESPPreview.Settings then
                    task.spawn(function()
                        task.wait(0.1);
                        Library.ESPPreview:UpdatePreview();
                    end);
                end;
                
                Library:SafeCallback(Dropdown.Callback, value);
                Library:AttemptSave();
            end);
        end;
        
        -- Update list size
        local ListHeight = #Dropdown.Values * 22 + 4;
        DropdownList.Size = UDim2.fromOffset(DropdownFrame.AbsoluteSize.X, ListHeight);
    end;
    
    -- Enhanced dropdown toggle
    DropdownButton.MouseButton1Click:Connect(function()
        Dropdown.IsOpen = not Dropdown.IsOpen;
        
        if Dropdown.IsOpen then
            UpdateDropdownList();
            DropdownList.Visible = true;
            DropdownArrow.Text = '▲';
            
            if Library.EnhancedFeatures.SmoothAnimations then
                DropdownList.Size = UDim2.fromOffset(DropdownFrame.AbsoluteSize.X, 0);
                TweenService:Create(DropdownList,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {Size = UDim2.fromOffset(DropdownFrame.AbsoluteSize.X, #Dropdown.Values * 22 + 4)}
                ):Play();
            end;
        else
            DropdownArrow.Text = '▼';
            
            if Library.EnhancedFeatures.SmoothAnimations then
                local closeTween = TweenService:Create(DropdownList,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                    {Size = UDim2.fromOffset(DropdownFrame.AbsoluteSize.X, 0)}
                );
                closeTween:Play();
                closeTween.Completed:Connect(function()
                    DropdownList.Visible = false;
                end);
            else
                DropdownList.Visible = false;
            end;
        end;
    end);
    
    -- Store in options if flag provided
    if Dropdown.Flag then
        Options[Dropdown.Flag] = Dropdown;
    end;
    
    Dropdown.Frame = DropdownFrame;
    Dropdown.SetValues = function(NewValues)
        Dropdown.Values = NewValues;
        if Dropdown.IsOpen then
            UpdateDropdownList();
        end;
    end;
    
    Dropdown.SetValue = function(Value)
        Dropdown.Value = Value;
        DropdownLabel.Text = Value;
        Library:SafeCallback(Dropdown.Callback, Value);
    end;
    
    table.insert(Groupbox.Elements, Dropdown);
    Groupbox.UpdateSize();
    
    return Dropdown;
end;
-- Enhanced Groupbox Methods
function Library:AddToggle(Groupbox, Flag, Options)
    Options = Options or {};
    Options.Flag = Flag;
    local Toggle = self:CreateToggle(Groupbox, Options);
    if Flag then
        Toggles[Flag] = Toggle;
    end;
    return Toggle;
end;

function Library:AddSlider(Groupbox, Flag, Options)
    Options = Options or {};
    Options.Flag = Flag;
    local Slider = self:CreateSlider(Groupbox, Options);
    if Flag then
        Options[Flag] = Slider;
    end;
    return Slider;
end;

function Library:AddButton(Groupbox, Options)
    return self:CreateButton(Groupbox, Options);
end;

function Library:AddLabel(Groupbox, Text, WrapText)
    return self:CreateGroupboxLabel(Groupbox, Text, WrapText);
end;

function Library:AddDropdown(Groupbox, Flag, Options)
    Options = Options or {};
    Options.Flag = Flag;
    local Dropdown = self:CreateDropdown(Groupbox, Options);
    if Flag then
        Options[Flag] = Dropdown;
    end;
    return Dropdown;
end;

-- Enhanced Color Picker Creation
function Library:CreateColorPicker(Groupbox, Options)
    Options = Options or {};
    local ColorPicker = {
        Value = Options.Default or Color3.new(1, 1, 1);
        Callback = Options.Callback or function() end;
        Flag = Options.Flag;
    };
    
    local ElementHeight = 25;
    local YOffset = #Groupbox.Elements * 30 + 5;
    
    -- Enhanced color picker frame
    local ColorFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    Library:AddToRegistry(ColorFrame, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = ColorFrame});
    
    -- Enhanced color display
    local ColorDisplay = Library:Create('Frame', {
        BackgroundColor3 = ColorPicker.Value;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, 5);
        Size = UDim2.fromOffset(15, 15);
        ZIndex = 6;
        Parent = ColorFrame;
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 3), Parent = ColorDisplay});
    
    -- Enhanced color label
    local ColorLabel = Library:CreateLabel({
        Position = UDim2.fromOffset(25, 0);
        Size = UDim2.new(1, -30, 1, 0);
        Text = Options.Text or 'Color';
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 6;
        Parent = ColorFrame;
    });
    
    -- Enhanced color picker button
    local ColorButton = Library:Create('TextButton', {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 1, 0);
        Text = '';
        ZIndex = 7;
        Parent = ColorFrame;
    });
    
    -- Simple color picker (basic implementation)
    ColorButton.MouseButton1Click:Connect(function()
        -- Create simple color picker window
        local ColorWindow = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.AccentColor;
            BorderSizePixel = 2;
            Position = UDim2.fromOffset(Mouse.X - 100, Mouse.Y - 100);
            Size = UDim2.fromOffset(200, 150);
            ZIndex = 1000;
            Parent = Library.ScreenGui;
        });
        
        Library:Create('UICorner', {CornerRadius = UDim.new(0, 8), Parent = ColorWindow});
        Library:MakeDraggable(ColorWindow, 30);
        
        -- Color picker header
        local Header = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 30);
            ZIndex = 1001;
            Parent = ColorWindow;
        });
        
        Library:Create('UICorner', {CornerRadius = UDim.new(0, 6), Parent = Header});
        
        local HeaderLabel = Library:CreateLabel({
            Size = UDim2.new(1, -30, 1, 0);
            Position = UDim2.fromOffset(10, 0);
            Text = '🎨 Color Picker';
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            ZIndex = 1002;
            Parent = Header;
        });
        
        -- Close button
        local CloseBtn = Library:Create('TextButton', {
            BackgroundColor3 = Color3.fromRGB(255, 100, 100);
            BorderSizePixel = 0;
            Position = UDim2.new(1, -25, 0, 5);
            Size = UDim2.fromOffset(20, 20);
            Text = '×';
            TextColor3 = Color3.new(1, 1, 1);
            TextSize = 12;
            ZIndex = 1003;
            Parent = Header;
        });
        
        Library:Create('UICorner', {CornerRadius = UDim.new(0, 10), Parent = CloseBtn});
        
        CloseBtn.MouseButton1Click:Connect(function()
            ColorWindow:Destroy();
        end);
        
        -- Preset colors
        local PresetColors = {
            Color3.new(1, 0, 0), Color3.new(0, 1, 0), Color3.new(0, 0, 1),
            Color3.new(1, 1, 0), Color3.new(1, 0, 1), Color3.new(0, 1, 1),
            Color3.new(1, 1, 1), Color3.new(0, 0, 0), Color3.new(0.5, 0.5, 0.5),
        };
        
        for i, color in ipairs(PresetColors) do
            local ColorBtn = Library:Create('TextButton', {
                BackgroundColor3 = color;
                BorderColor3 = Library.OutlineColor;
                BorderSizePixel = 1;
                Position = UDim2.fromOffset(10 + ((i - 1) % 3) * 25, 40 + math.floor((i - 1) / 3) * 25);
                Size = UDim2.fromOffset(20, 20);
                Text = '';
                ZIndex = 1002;
                Parent = ColorWindow;
            });
            
            Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = ColorBtn});
            
            ColorBtn.MouseButton1Click:Connect(function()
                ColorPicker.Value = color;
                ColorDisplay.BackgroundColor3 = color;
                
                -- Update ESP Preview if this is an ESP setting
                if Library.ESPPreview.Enabled and Library.ESPPreview.Settings then
                    task.spawn(function()
                        task.wait(0.1);
                        Library.ESPPreview:UpdatePreview();
                    end);
                end;
                
                Library:SafeCallback(ColorPicker.Callback, color);
                Library:AttemptSave();
                ColorWindow:Destroy();
            end);
        end;
    end);
    
    -- Store in options if flag provided
    if ColorPicker.Flag then
        Options[ColorPicker.Flag] = ColorPicker;
    end;
    
    ColorPicker.Frame = ColorFrame;
    ColorPicker.SetValue = function(Value)
        ColorPicker.Value = Value;
        ColorDisplay.BackgroundColor3 = Value;
        Library:SafeCallback(ColorPicker.Callback, Value);
    end;
    
    table.insert(Groupbox.Elements, ColorPicker);
    Groupbox.UpdateSize();
    
    return ColorPicker;
end;

function Library:AddColorPicker(Groupbox, Flag, Options)
    Options = Options or {};
    Options.Flag = Flag;
    local ColorPicker = self:CreateColorPicker(Groupbox, Options);
    if Flag then
        Options[Flag] = ColorPicker;
    end;
    return ColorPicker;
end;

-- Enhanced Keybind Creation
function Library:CreateKeybind(Groupbox, Options)
    Options = Options or {};
    local Keybind = {
        Value = Options.Default or Enum.KeyCode.Unknown;
        Callback = Options.Callback or function() end;
        Flag = Options.Flag;
        Mode = Options.Mode or 'Toggle'; -- Toggle, Hold, Always
    };
    
    local ElementHeight = 25;
    local YOffset = #Groupbox.Elements * 30 + 5;
    
    -- Enhanced keybind frame
    local KeybindFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    Library:AddToRegistry(KeybindFrame, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = KeybindFrame});
    
    -- Enhanced keybind label
    local KeybindLabel = Library:CreateLabel({
        Position = UDim2.fromOffset(8, 0);
        Size = UDim2.new(1, -80, 1, 0);
        Text = Options.Text or 'Keybind';
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 6;
        Parent = KeybindFrame;
    });
    
    -- Enhanced key display
    local KeyDisplay = Library:Create('TextButton', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.new(1, -70, 0, 3);
        Size = UDim2.fromOffset(65, 19);
        Text = Keybind.Value.Name;
        TextColor3 = Library.FontColor;
        TextSize = 12;
        ZIndex = 6;
        Parent = KeybindFrame;
    });
    
    Library:AddToRegistry(KeyDisplay, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
        TextColor3 = 'FontColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 3), Parent = KeyDisplay});
    
    local IsBinding = false;
    
    KeyDisplay.MouseButton1Click:Connect(function()
        if IsBinding then return end;
        IsBinding = true;
        KeyDisplay.Text = '...';
        
        local Connection;
        Connection = InputService.InputBegan:Connect(function(Input, GameProcessed)
            if GameProcessed then return end;
            
            local KeyCode = Input.KeyCode;
            if KeyCode == Enum.KeyCode.Unknown then
                KeyCode = Input.UserInputType;
            end;
            
            Keybind.Value = KeyCode;
            KeyDisplay.Text = KeyCode.Name;
            IsBinding = false;
            Connection:Disconnect();
            
            Library:SafeCallback(Keybind.Callback, KeyCode);
            Library:AttemptSave();
        end);
    end);
    
    -- Store in options if flag provided
    if Keybind.Flag then
        Options[Keybind.Flag] = Keybind;
    end;
    
    Keybind.Frame = KeybindFrame;
    Keybind.SetValue = function(Value)
        Keybind.Value = Value;
        KeyDisplay.Text = Value.Name;
        Library:SafeCallback(Keybind.Callback, Value);
    end;
    
    table.insert(Groupbox.Elements, Keybind);
    Groupbox.UpdateSize();
    
    return Keybind;
end;

function Library:AddKeybind(Groupbox, Flag, Options)
    Options = Options or {};
    Options.Flag = Flag;
    local Keybind = self:CreateKeybind(Groupbox, Options);
    if Flag then
        Options[Flag] = Keybind;
    end;
    return Keybind;
end;

-- Enhanced Input/Textbox Creation
function Library:CreateInput(Groupbox, Options)
    Options = Options or {};
    local Input = {
        Value = Options.Default or '';
        Callback = Options.Callback or function() end;
        Flag = Options.Flag;
    };
    
    local ElementHeight = 25;
    local YOffset = #Groupbox.Elements * 30 + 5;
    
    -- Enhanced input frame
    local InputFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(5, YOffset);
        Size = UDim2.fromOffset(Groupbox.ContentFrame.AbsoluteSize.X - 10, ElementHeight);
        ZIndex = 5;
        Parent = Groupbox.ContentFrame;
    });
    
    Library:AddToRegistry(InputFrame, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });
    
    Library:Create('UICorner', {CornerRadius = UDim.new(0, 4), Parent = InputFrame});
    
    -- Enhanced text input
    local TextInput = Library:Create('TextBox', {
        BackgroundTransparency = 1;
        Position = UDim2.fromOffset(8, 0);
        Size = UDim2.new(1, -16, 1, 0);
        Text = Input.Value;
        TextColor3 = Library.FontColor;
        TextSize = 14;
        TextXAlignment = Enum.TextXAlignment.Left;
        PlaceholderText = Options.Text or 'Enter text...';
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150);
        ClearTextOnFocus = false;
        ZIndex = 6;
        Parent = InputFrame;
    });
    
    Library:AddToRegistry(TextInput, {TextColor3 = 'FontColor'});
    
    -- Enhanced focus effects
    TextInput.Focused:Connect(function()
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(InputFrame,
                TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BorderColor3 = Library.AccentColor}
            ):Play();
        else
            InputFrame.BorderColor3 = Library.AccentColor;
        end;
    end);
    
    TextInput.FocusLost:Connect(function(EnterPressed)
        if Library.EnhancedFeatures.SmoothAnimations then
            TweenService:Create(InputFrame,
                TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BorderColor3 = Library.OutlineColor}
            ):Play();
        else
            InputFrame.BorderColor3 = Library.OutlineColor;
        end;
        
        if EnterPressed then
            Input.Value = TextInput.Text;
            Library:SafeCallback(Input.Callback, Input.Value);
            Library:AttemptSave();
        end;
    end);
    
    -- Store in options if flag provided
    if Input.Flag then
        Options[Input.Flag] = Input;
    end;
    
    Input.Frame = InputFrame;
    Input.SetValue = function(Value)
        Input.Value = Value;
        TextInput.Text = Value;
        Library:SafeCallback(Input.Callback, Value);
    end;
    
    table.insert(Groupbox.Elements, Input);
    Groupbox.UpdateSize();
    
    return Input;
end;

function Library:AddInput(Groupbox, Flag, Options)
    Options = Options or {};
    Options.Flag = Flag;
    local Input = self:CreateInput(Groupbox, Options);
    if Flag then
        Options[Flag] = Input;
    end;
    return Input;
end;
-- Enhanced Save/Load System
Library.SaveManager = {};

function Library.SaveManager:SetLibrary(Lib)
    self.Library = Lib;
end;

function Library.SaveManager:SetFolder(Folder)
    self.Folder = Folder;
    if not isfolder(Folder) then
        makefolder(Folder);
    end;
end;

function Library.SaveManager:Save(Name)
    if not self.Folder then
        return false, 'No folder set';
    end;
    
    Name = Name or 'default';
    local ConfigData = {};
    
    -- Save toggles
    for Flag, Toggle in pairs(Toggles) do
        ConfigData[Flag] = Toggle.Value;
    end;
    
    -- Save options
    for Flag, Option in pairs(Options) do
        if Option.Value ~= nil then
            ConfigData[Flag] = Option.Value;
        end;
    end;
    
    local Success, Result = pcall(function()
        writefile(self.Folder .. '/' .. Name .. '.json', game:GetService('HttpService'):JSONEncode(ConfigData));
    end);
    
    if Success then
        Library:Notify('💾 Configuration saved: ' .. Name, 3);
        return true;
    else
        Library:Notify('❌ Failed to save: ' .. Result, 5);
        return false, Result;
    end;
end;

function Library.SaveManager:Load(Name)
    if not self.Folder then
        return false, 'No folder set';
    end;
    
    Name = Name or 'default';
    local FilePath = self.Folder .. '/' .. Name .. '.json';
    
    if not isfile(FilePath) then
        return false, 'File does not exist';
    end;
    
    local Success, Result = pcall(function()
        local ConfigData = game:GetService('HttpService'):JSONDecode(readfile(FilePath));
        
        -- Load toggles
        for Flag, Value in pairs(ConfigData) do
            if Toggles[Flag] then
                Toggles[Flag]:SetValue(Value);
            elseif Options[Flag] then
                Options[Flag]:SetValue(Value);
            end;
        end;
        
        return ConfigData;
    end);
    
    if Success then
        Library:Notify('📁 Configuration loaded: ' .. Name, 3);
        return true, Result;
    else
        Library:Notify('❌ Failed to load: ' .. Result, 5);
        return false, Result;
    end;
end;

function Library.SaveManager:Delete(Name)
    if not self.Folder then
        return false, 'No folder set';
    end;
    
    Name = Name or 'default';
    local FilePath = self.Folder .. '/' .. Name .. '.json';
    
    if not isfile(FilePath) then
        return false, 'File does not exist';
    end;
    
    local Success, Result = pcall(function()
        delfile(FilePath);
    end);
    
    if Success then
        Library:Notify('🗑️ Configuration deleted: ' .. Name, 3);
        return true;
    else
        Library:Notify('❌ Failed to delete: ' .. Result, 5);
        return false, Result;
    end;
end;

function Library.SaveManager:GetConfigs()
    if not self.Folder then
        return {};
    end;
    
    local Configs = {};
    local Success, Files = pcall(function()
        return listfiles(self.Folder);
    end);
    
    if Success then
        for _, File in pairs(Files) do
            if File:sub(-5) == '.json' then
                local Name = File:match('([^/\\]+)%.json$');
                table.insert(Configs, Name);
            end;
        end;
    end;
    
    return Configs;
end;

-- Enhanced Theme System
Library.ThemeManager = {};

function Library.ThemeManager:SetLibrary(Lib)
    self.Library = Lib;
end;

function Library.ThemeManager:ApplyTheme(ThemeName)
    local Themes = {
        ['Default'] = {
            FontColor = Color3.fromRGB(255, 255, 255);
            MainColor = Color3.fromRGB(28, 28, 28);
            BackgroundColor = Color3.fromRGB(20, 20, 20);
            AccentColor = Color3.fromRGB(0, 85, 255);
            OutlineColor = Color3.fromRGB(50, 50, 50);
            RiskColor = Color3.fromRGB(255, 50, 50);
        };
        ['Dark Blue'] = {
            FontColor = Color3.fromRGB(255, 255, 255);
            MainColor = Color3.fromRGB(25, 30, 40);
            BackgroundColor = Color3.fromRGB(15, 20, 30);
            AccentColor = Color3.fromRGB(64, 128, 255);
            OutlineColor = Color3.fromRGB(40, 50, 65);
            RiskColor = Color3.fromRGB(255, 80, 80);
        };
        ['Purple'] = {
            FontColor = Color3.fromRGB(255, 255, 255);
            MainColor = Color3.fromRGB(35, 25, 40);
            BackgroundColor = Color3.fromRGB(25, 15, 30);
            AccentColor = Color3.fromRGB(150, 100, 255);
            OutlineColor = Color3.fromRGB(55, 40, 65);
            RiskColor = Color3.fromRGB(255, 100, 150);
        };
        ['Green'] = {
            FontColor = Color3.fromRGB(255, 255, 255);
            MainColor = Color3.fromRGB(25, 35, 25);
            BackgroundColor = Color3.fromRGB(15, 25, 15);
            AccentColor = Color3.fromRGB(100, 200, 100);
            OutlineColor = Color3.fromRGB(40, 60, 40);
            RiskColor = Color3.fromRGB(255, 100, 100);
        };
        ['Red'] = {
            FontColor = Color3.fromRGB(255, 255, 255);
            MainColor = Color3.fromRGB(40, 25, 25);
            BackgroundColor = Color3.fromRGB(30, 15, 15);
            AccentColor = Color3.fromRGB(255, 100, 100);
            OutlineColor = Color3.fromRGB(65, 40, 40);
            RiskColor = Color3.fromRGB(255, 150, 150);
        };
    };
    
    local Theme = Themes[ThemeName];
    if not Theme then
        return false, 'Theme not found';
    end;
    
    -- Apply theme colors
    for ColorName, Color in pairs(Theme) do
        Library[ColorName] = Color;
    end;
    
    -- Update all registered elements
    Library:UpdateColorsUsingRegistry();
    
    Library:Notify('🎨 Theme applied: ' .. ThemeName, 3);
    return true;
end;

-- Enhanced Cleanup System
function Library:Unload()
    -- Disconnect all signals
    for _, Signal in pairs(self.Signals) do
        if Signal and Signal.Disconnect then
            Signal:Disconnect();
        end;
    end;
    
    -- Destroy ESP Preview
    if self.ESPPreview.Container then
        self.ESPPreview:DestroyPreview();
    end;
    
    -- Destroy main GUI
    if self.ScreenGui then
        self.ScreenGui:Destroy();
    end;
    
    -- Clear tables
    self.Registry = {};
    self.RegistryMap = {};
    self.HudRegistry = {};
    self.OpenedFrames = {};
    self.DependencyBoxes = {};
    self.Signals = {};
    
    -- Clear global references
    getgenv().Toggles = {};
    getgenv().Options = {};
    
    print('🧹 Enhanced Linoria Library unloaded');
end;

-- Enhanced Initialization
function Library:Init()
    -- Set up save manager
    if self.SaveManager then
        self.SaveManager:SetLibrary(self);
        self.SaveManager:SetFolder('LinoriaConfigs');
    end;
    
    -- Set up theme manager
    if self.ThemeManager then
        self.ThemeManager:SetLibrary(self);
        
        -- Apply default theme
        pcall(function()
            self.ThemeManager:ApplyTheme('Default');
        end);
    end;
    
    -- Create notification system (with delay to ensure GUI is ready)
    task.spawn(function()
        task.wait(0.1);
        pcall(function()
            self:Notify('✨ Enhanced Linoria Library loaded!', 3);
        end);
    end);
    
    print('🚀 Enhanced Linoria Library initialized with ESP Preview support');
    return self;
end;

-- Enhanced Window Creation (Main API)
function Library:CreateMainWindow(Options)
    Options = Options or {};
    
    -- Enhanced default options
    local DefaultOptions = {
        Title = 'Enhanced Linoria Library';
        Center = true;
        AutoShow = true;
        TabPadding = 8;
        MenuFadeTime = 0.2;
        Size = Library.EnhancedFeatures.WiderInterface and UDim2.fromOffset(720, 650) or UDim2.fromOffset(550, 600);
    };
    
    -- Merge options
    for Key, Value in pairs(DefaultOptions) do
        if Options[Key] == nil then
            Options[Key] = Value;
        end;
    end;
    
    local Window = self:CreateWindow(Options);
    
    -- Enhanced auto-show with smooth animation
    if Options.AutoShow then
        task.spawn(function()
            task.wait(0.1);
            Window:Show();
        end);
    end;
    
    return Window;
end;

-- Enhanced Tab Creation (Main API)
function Library:CreateMainTab(Window, Name, Icon)
    local Tab = self:CreateTab(Window, Icon and (Icon .. ' ' .. Name) or Name);
    return Tab;
end;

-- Enhanced Groupbox Creation (Main API)  
function Library:CreateGroupBox(Tab, Name, Side)
    local Groupbox = self:CreateGroupbox(Tab, Name, Side);
    
    -- Enhanced groupbox methods
    function Groupbox:AddToggle(Flag, Options)
        return Library:AddToggle(self, Flag, Options);
    end;
    
    function Groupbox:AddSlider(Flag, Options)
        return Library:AddSlider(self, Flag, Options);
    end;
    
    function Groupbox:AddButton(Options)
        return Library:AddButton(self, Options);
    end;
    
    function Groupbox:AddLabel(Text, WrapText)
        return Library:AddLabel(self, Text, WrapText);
    end;
    
    function Groupbox:AddDropdown(Flag, Options)
        return Library:AddDropdown(self, Flag, Options);
    end;
    
    function Groupbox:AddColorPicker(Flag, Options)
        return Library:AddColorPicker(self, Flag, Options);
    end;
    
    function Groupbox:AddKeybind(Flag, Options)
        return Library:AddKeybind(self, Flag, Options);
    end;
    
    function Groupbox:AddInput(Flag, Options)
        return Library:AddInput(self, Flag, Options);
    end;
    
    -- ESP PREVIEW INTEGRATION
    function Groupbox:AddESPPreview(espSettings)
        return Library:AddESPPreview(self, espSettings);
    end;
    
    return Groupbox;
end;

-- Initialize the library
Library:Init();

-- Return the enhanced library
return Library;
