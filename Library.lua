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

local Library = {
    Registry = {};
    RegistryMap = {};
    HudRegistry = {};
    
    -- ОСНОВНЫЕ ЦВЕТА
    FontColor = Color3.fromRGB(255, 255, 255);
    MainColor = Color3.fromRGB(28, 28, 28);
    BackgroundColor = Color3.fromRGB(20, 20, 20);
    AccentColor = Color3.fromRGB(0, 85, 255);
    OutlineColor = Color3.fromRGB(50, 50, 50);
    RiskColor = Color3.fromRGB(255, 50, 50);
    Black = Color3.new(0, 0, 0);
    Font = Enum.Font.Code;
    
    -- ✨ НОВЫЕ ЦВЕТА ДЛЯ ВАТЕРМАРКА
    WatermarkProjectColor = Color3.fromRGB(180, 100, 220);  -- Фиолетовый для "Project Radiant"
    WatermarkNicknameColor = Color3.fromRGB(192, 192, 192); -- Серебристый для никнейма
    WatermarkFPSColor = Color3.fromRGB(100, 255, 100);      -- Зеленый для FPS цифр
    WatermarkFPSTextColor = Color3.fromRGB(140, 140, 140);  -- Серый для "FPS" текста
    WatermarkPingGoodColor = Color3.fromRGB(100, 255, 100); -- Зеленый пинг <100ms
    WatermarkPingMediumColor = Color3.fromRGB(255, 255, 100); -- Желтый пинг 100-200ms
    WatermarkPingBadColor = Color3.fromRGB(255, 100, 100);  -- Красный пинг >200ms
    WatermarkPingTextColor = Color3.fromRGB(140, 140, 140); -- Серый для "MS" текста
    WatermarkTimeColor = Color3.fromRGB(120, 120, 120);     -- Серый для времени
    WatermarkSeparatorColor = Color3.fromRGB(100, 100, 100); -- Серый для разделителей |
    WatermarkIconColor = Color3.fromRGB(255, 120, 200);     -- Розовый для иконки молнии
    
    -- ✨ НОВЫЕ ЦВЕТА ДЛЯ КЕЙБИНДОВ
    KeybindHeaderColor = Color3.fromRGB(200, 200, 200);     -- Белый для "Keybinds"
    KeybindIconColor = Color3.fromRGB(150, 150, 255);       -- Синий для иконки палитры
    KeybindNameColor = Color3.fromRGB(180, 180, 180);       -- Серый для названий кейбиндов
    KeybindKeyColor = Color3.fromRGB(120, 120, 130);        -- Темно-серый для клавиш
    KeybindStateOnColor = Color3.fromRGB(100, 255, 100);    -- Зеленый для ON
    KeybindStateOffColor = Color3.fromRGB(255, 100, 100);   -- Красный для OFF
    KeybindSeparatorColor = Color3.fromRGB(100, 100, 100);  -- Серый для разделителя |
    
    OpenedFrames = {};
    DependencyBoxes = {};
    Signals = {};
    ScreenGui = ScreenGui;
};

-- ✨ ФУНКЦИИ ДЛЯ ИЗМЕНЕНИЯ ЦВЕТОВ ВАТЕРМАРКА
function Library:SetWatermarkProjectColor(color)
    self.WatermarkProjectColor = color
    -- Обновляем цвет в реальном времени если ватермарк активен
    if self.WaveSystem and self.WaveSystem.ProjectLetters then
        for _, letter in pairs(self.WaveSystem.ProjectLetters) do
            if letter.Label then
                letter.Label.TextColor3 = color
            end
        end
    end
end

function Library:SetWatermarkNicknameColor(color)
    self.WatermarkNicknameColor = color
    if self.WaveSystem and self.WaveSystem.NicknameLetters then
        for _, letter in pairs(self.WaveSystem.NicknameLetters) do
            if letter.Label then
                letter.Label.TextColor3 = color
            end
        end
    end
end

function Library:SetWatermarkFPSColor(color)
    self.WatermarkFPSColor = color
    if self.WaveSystem and self.WaveSystem.FPSLetters then
        for _, letter in pairs(self.WaveSystem.FPSLetters) do
            if letter.Label and letter.IsDigit then
                letter.Label.TextColor3 = color
            end
        end
    end
end

function Library:SetWatermarkTimeColor(color)
    self.WatermarkTimeColor = color
    if self.WaveSystem and self.WaveSystem.TimeLetters then
        for _, letter in pairs(self.WaveSystem.TimeLetters) do
            if letter.Label then
                letter.Label.TextColor3 = color
            end
        end
    end
end

function Library:SetWatermarkIconColor(color)
    self.WatermarkIconColor = color
    if self.WaveSystem and self.WaveSystem.IconLabel then
        self.WaveSystem.IconLabel.TextColor3 = color
    end
end

-- ✨ ФУНКЦИИ ДЛЯ ИЗМЕНЕНИЯ ЦВЕТОВ КЕЙБИНДОВ
function Library:SetKeybindHeaderColor(color)
    self.KeybindHeaderColor = color
    if self.WaveSystem and self.WaveSystem.KeybindHeaderLetters then
        for _, letter in pairs(self.WaveSystem.KeybindHeaderLetters) do
            if letter.Label then
                letter.Label.TextColor3 = color
            end
        end
    end
end

function Library:SetKeybindIconColor(color)
    self.KeybindIconColor = color
    if self.WaveSystem and self.WaveSystem.PaletteIcon then
        if self.WaveSystem.PaletteIcon.ClassName == "ImageLabel" then
            self.WaveSystem.PaletteIcon.ImageColor3 = color
        else
            self.WaveSystem.PaletteIcon.TextColor3 = color
        end
    end
end

-- ✨ ФУНКЦИЯ ДЛЯ УСТАНОВКИ ТЕМЫ ВАТЕРМАРКА
function Library:SetWatermarkTheme(themeName)
    if themeName == "purple" then
        -- Фиолетовая тема
        self:SetWatermarkProjectColor(Color3.fromRGB(180, 100, 220))
        self:SetWatermarkNicknameColor(Color3.fromRGB(200, 150, 255))
        self:SetWatermarkIconColor(Color3.fromRGB(255, 120, 200))
        
    elseif themeName == "blue" then
        -- Синяя тема
        self:SetWatermarkProjectColor(Color3.fromRGB(100, 150, 255))
        self:SetWatermarkNicknameColor(Color3.fromRGB(150, 200, 255))
        self:SetWatermarkIconColor(Color3.fromRGB(120, 180, 255))
        
    elseif themeName == "green" then
        -- Зеленая тема
        self:SetWatermarkProjectColor(Color3.fromRGB(100, 220, 150))
        self:SetWatermarkNicknameColor(Color3.fromRGB(150, 255, 180))
        self:SetWatermarkIconColor(Color3.fromRGB(120, 255, 160))
        
    elseif themeName == "red" then
        -- Красная тема
        self:SetWatermarkProjectColor(Color3.fromRGB(255, 100, 120))
        self:SetWatermarkNicknameColor(Color3.fromRGB(255, 150, 170))
        self:SetWatermarkIconColor(Color3.fromRGB(255, 120, 140))
        
    elseif themeName == "rainbow" then
        -- Радужная тема (будет меняться автоматически)
        self.WatermarkRainbowMode = true
        
    elseif themeName == "accent" then
        -- Использовать AccentColor библиотеки
        self:SetWatermarkProjectColor(self.AccentColor)
        self:SetWatermarkNicknameColor(self.AccentColor)
        self:SetWatermarkIconColor(self.AccentColor)
        
    else
        -- Стандартная тема
        self:SetWatermarkProjectColor(Color3.fromRGB(180, 100, 220))
        self:SetWatermarkNicknameColor(Color3.fromRGB(192, 192, 192))
        self:SetWatermarkIconColor(Color3.fromRGB(255, 120, 200))
    end
end

-- ✨ ФУНКЦИЯ ДЛЯ ПОЛУЧЕНИЯ ЦВЕТА ПИНГА ПО ЗНАЧЕНИЮ
function Library:GetPingColor(ping)
    if ping < 100 then
        return self.WatermarkPingGoodColor
    elseif ping < 200 then
        return self.WatermarkPingMediumColor
    else
        return self.WatermarkPingBadColor
    end
end

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
                    0,
                    Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                    0,
                    Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                );

                RenderStepped:Wait();
            end;
        end;
    end)
end;

function Library:AddToolTip(InfoStr, HoverInstance)
    local X, Y = Library:GetTextBounds(InfoStr, Library.Font, 14);
    local Tooltip = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor,
        BorderColor3 = Library.OutlineColor,

        Size = UDim2.fromOffset(X + 5, Y + 4),
        ZIndex = 100,
        Parent = Library.ScreenGui,

        Visible = false,
    })

    local Label = Library:CreateLabel({
        Position = UDim2.fromOffset(3, 1),
        Size = UDim2.fromOffset(X, Y);
        TextSize = 14;
        Text = InfoStr,
        TextColor3 = Library.FontColor,
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = Tooltip.ZIndex + 1,

        Parent = Tooltip;
    });

    Library:AddToRegistry(Tooltip, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

    Library:AddToRegistry(Label, {
        TextColor3 = 'FontColor',
    });

    local IsHovering = false

    HoverInstance.MouseEnter:Connect(function()
        if Library:MouseIsOverOpenedFrame() then
            return
        end

        IsHovering = true

        Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
        Tooltip.Visible = true

        while IsHovering do
            RunService.Heartbeat:Wait()
            Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
        end
    end)

    HoverInstance.MouseLeave:Connect(function()
        IsHovering = false
        Tooltip.Visible = false
    end)
end

function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault)
    HighlightInstance.MouseEnter:Connect(function()
        local Reg = Library.RegistryMap[Instance];

        for Property, ColorIdx in next, Properties do
            Instance[Property] = Library[ColorIdx] or ColorIdx;

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx;
            end;
        end;
    end)

    HighlightInstance.MouseLeave:Connect(function()
        local Reg = Library.RegistryMap[Instance];

        for Property, ColorIdx in next, PropertiesDefault do
            Instance[Property] = Library[ColorIdx] or ColorIdx;

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx;
            end;
        end;
    end)
end;

function Library:MouseIsOverOpenedFrame()
    for Frame, _ in next, Library.OpenedFrames do
        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

        if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
            and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

            return true;
        end;
    end;
end;

function Library:IsMouseOverFrame(Frame)
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

    if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

        return true;
    end;
end;

function Library:UpdateDependencyBoxes()
    for _, Depbox in next, Library.DependencyBoxes do
        Depbox:Update();
    end;
end;

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
    return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB;
end;

function Library:GetTextBounds(Text, Font, Size, Resolution)
    local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
    return Bounds.X, Bounds.Y
end;

function Library:GetDarkerColor(Color)
    local H, S, V = Color3.toHSV(Color);
    return Color3.fromHSV(H, S, V / 1.5);
end;
Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);

function Library:AddToRegistry(Instance, Properties, IsHud)
    local Idx = #Library.Registry + 1;
    local Data = {
        Instance = Instance;
        Properties = Properties;
        Idx = Idx;
    };

    table.insert(Library.Registry, Data);
    Library.RegistryMap[Instance] = Data;

    if IsHud then
        table.insert(Library.HudRegistry, Data);
    end;
end;

function Library:RemoveFromRegistry(Instance)
    local Data = Library.RegistryMap[Instance];

    if Data then
        for Idx = #Library.Registry, 1, -1 do
            if Library.Registry[Idx] == Data then
                table.remove(Library.Registry, Idx);
            end;
        end;

        for Idx = #Library.HudRegistry, 1, -1 do
            if Library.HudRegistry[Idx] == Data then
                table.remove(Library.HudRegistry, Idx);
            end;
        end;

        Library.RegistryMap[Instance] = nil;
    end;
end;

function Library:UpdateColorsUsingRegistry()
    -- TODO: Could have an 'active' list of objects
    -- where the active list only contains Visible objects.

    -- IMPL: Could setup .Changed events on the AddToRegistry function
    -- that listens for the 'Visible' propert being changed.
    -- Visible: true => Add to active list, and call UpdateColors function
    -- Visible: false => Remove from active list.

    -- The above would be especially efficient for a rainbow menu color or live color-changing.

    for Idx, Object in next, Library.Registry do
        for Property, ColorIdx in next, Object.Properties do
            if type(ColorIdx) == 'string' then
                Object.Instance[Property] = Library[ColorIdx];
            elseif type(ColorIdx) == 'function' then
                Object.Instance[Property] = ColorIdx()
            end
        end;
    end;
end;

function Library:GiveSignal(Signal)
    -- Only used for signals not attached to library instances, as those should be cleaned up on object destruction by Roblox
    table.insert(Library.Signals, Signal)
end

function Library:Unload()
    -- Unload all of the signals
    for Idx = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Idx)
        Connection:Disconnect()
    end

     -- Call our unload callback, maybe to undo some hooks etc
    if Library.OnUnload then
        Library.OnUnload()
    end

    ScreenGui:Destroy()
end

function Library:OnUnload(Callback)
    Library.OnUnload = Callback
end

Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
    if Library.RegistryMap[Instance] then
        Library:RemoveFromRegistry(Instance);
    end;
end))

local BaseAddons = {};

do
    local Funcs = {};

    function Funcs:AddColorPicker(Idx, Info)
        local ToggleLabel = self.TextLabel;
        -- local Container = self.Container;

        assert(Info.Default, 'AddColorPicker: Missing default value.');

        local ColorPicker = {
            Value = Info.Default;
            Transparency = Info.Transparency or 0;
            Type = 'ColorPicker';
            Title = type(Info.Title) == 'string' and Info.Title or 'Color picker',
            Callback = Info.Callback or function(Color) end;
        };

        function ColorPicker:SetHSVFromRGB(Color)
            local H, S, V = Color3.toHSV(Color);

            ColorPicker.Hue = H;
            ColorPicker.Sat = S;
            ColorPicker.Vib = V;
        end;

        ColorPicker:SetHSVFromRGB(ColorPicker.Value);

        local DisplayFrame = Library:Create('Frame', {
            BackgroundColor3 = ColorPicker.Value;
            BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(0, 28, 0, 14);
            ZIndex = 6;
            Parent = ToggleLabel;
        });

        -- Transparency image taken from https://github.com/matas3535/SplixPrivateDrawingLibrary/blob/main/Library.lua cus i'm lazy
        local CheckerFrame = Library:Create('ImageLabel', {
            BorderSizePixel = 0;
            Size = UDim2.new(0, 27, 0, 13);
            ZIndex = 5;
            Image = 'http://www.roblox.com/asset/?id=12977615774';
            Visible = not not Info.Transparency;
            Parent = DisplayFrame;
        });

        -- 1/16/23
        -- Rewrote this to be placed inside the Library ScreenGui
        -- There was some issue which caused RelativeOffset to be way off
        -- Thus the color picker would never show

        local PickerFrameOuter = Library:Create('Frame', {
            Name = 'Color';
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18),
            Size = UDim2.fromOffset(230, Info.Transparency and 271 or 253);
            Visible = false;
            ZIndex = 15;
            Parent = ScreenGui,
        });

        DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
            PickerFrameOuter.Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18);
        end)

        local PickerFrameInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 16;
            Parent = PickerFrameOuter;
        });

        local Highlight = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 2);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local SatVibMapOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 4, 0, 25);
            Size = UDim2.new(0, 200, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local SatVibMapInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Parent = SatVibMapOuter;
        });

        local SatVibMap = Library:Create('ImageLabel', {
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Image = 'rbxassetid://4155801252';
            Parent = SatVibMapInner;
        });

        local CursorOuter = Library:Create('ImageLabel', {
            AnchorPoint = Vector2.new(0.5, 0.5);
            Size = UDim2.new(0, 6, 0, 6);
            BackgroundTransparency = 1;
            Image = 'http://www.roblox.com/asset/?id=9619665977';
            ImageColor3 = Color3.new(0, 0, 0);
            ZIndex = 19;
            Parent = SatVibMap;
        });

        local CursorInner = Library:Create('ImageLabel', {
            Size = UDim2.new(0, CursorOuter.Size.X.Offset - 2, 0, CursorOuter.Size.Y.Offset - 2);
            Position = UDim2.new(0, 1, 0, 1);
            BackgroundTransparency = 1;
            Image = 'http://www.roblox.com/asset/?id=9619665977';
            ZIndex = 20;
            Parent = CursorOuter;
        })

        local HueSelectorOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 208, 0, 25);
            Size = UDim2.new(0, 15, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local HueSelectorInner = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Parent = HueSelectorOuter;
        });

        local HueCursor = Library:Create('Frame', { 
            BackgroundColor3 = Color3.new(1, 1, 1);
            AnchorPoint = Vector2.new(0, 0.5);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, 0, 0, 1);
            ZIndex = 18;
            Parent = HueSelectorInner;
        });

        local HueBoxOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.fromOffset(4, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            ZIndex = 18,
            Parent = PickerFrameInner;
        });

        local HueBoxInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18,
            Parent = HueBoxOuter;
        });

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = HueBoxInner;
        });

        local HueBox = Library:Create('TextBox', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            Font = Library.Font;
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
            PlaceholderText = 'Hex color',
            Text = '#FFFFFF',
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 20,
            Parent = HueBoxInner;
        });

        Library:ApplyTextStroke(HueBox);

        local RgbBoxBase = Library:Create(HueBoxOuter:Clone(), {
            Position = UDim2.new(0.5, 2, 0, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            Parent = PickerFrameInner
        });

        local RgbBox = Library:Create(RgbBoxBase.Frame:FindFirstChild('TextBox'), {
            Text = '255, 255, 255',
            PlaceholderText = 'RGB color',
            TextColor3 = Library.FontColor
        });

        local TransparencyBoxOuter, TransparencyBoxInner, TransparencyCursor;
        
        if Info.Transparency then 
            TransparencyBoxOuter = Library:Create('Frame', {
                BorderColor3 = Color3.new(0, 0, 0);
                Position = UDim2.fromOffset(4, 251);
                Size = UDim2.new(1, -8, 0, 15);
                ZIndex = 19;
                Parent = PickerFrameInner;
            });

            TransparencyBoxInner = Library:Create('Frame', {
                BackgroundColor3 = ColorPicker.Value;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 19;
                Parent = TransparencyBoxOuter;
            });

            Library:AddToRegistry(TransparencyBoxInner, { BorderColor3 = 'OutlineColor' });

            Library:Create('ImageLabel', {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 1, 0);
                Image = 'http://www.roblox.com/asset/?id=12978095818';
                ZIndex = 20;
                Parent = TransparencyBoxInner;
            });

            TransparencyCursor = Library:Create('Frame', { 
                BackgroundColor3 = Color3.new(1, 1, 1);
                AnchorPoint = Vector2.new(0.5, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(0, 1, 1, 0);
                ZIndex = 21;
                Parent = TransparencyBoxInner;
            });
        end;

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 14);
            Position = UDim2.fromOffset(5, 5);
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            Text = ColorPicker.Title,--Info.Default;
            TextWrapped = false;
            ZIndex = 16;
            Parent = PickerFrameInner;
        });


        local ContextMenu = {}
        do
            ContextMenu.Options = {}
            ContextMenu.Container = Library:Create('Frame', {
                BorderColor3 = Color3.new(),
                ZIndex = 14,

                Visible = false,
                Parent = ScreenGui
            })

            ContextMenu.Inner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.fromScale(1, 1);
                ZIndex = 15;
                Parent = ContextMenu.Container;
            });

            Library:Create('UIListLayout', {
                Name = 'Layout',
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = ContextMenu.Inner;
            });

            Library:Create('UIPadding', {
                Name = 'Padding',
                PaddingLeft = UDim.new(0, 4),
                Parent = ContextMenu.Inner,
            });

            local function updateMenuPosition()
                ContextMenu.Container.Position = UDim2.fromOffset(
                    (DisplayFrame.AbsolutePosition.X + DisplayFrame.AbsoluteSize.X) + 4,
                    DisplayFrame.AbsolutePosition.Y + 1
                )
            end

            local function updateMenuSize()
                local menuWidth = 60
                for i, label in next, ContextMenu.Inner:GetChildren() do
                    if label:IsA('TextLabel') then
                        menuWidth = math.max(menuWidth, label.TextBounds.X)
                    end
                end

                ContextMenu.Container.Size = UDim2.fromOffset(
                    menuWidth + 8,
                    ContextMenu.Inner.Layout.AbsoluteContentSize.Y + 4
                )
            end

            DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(updateMenuPosition)
            ContextMenu.Inner.Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(updateMenuSize)

            task.spawn(updateMenuPosition)
            task.spawn(updateMenuSize)

            Library:AddToRegistry(ContextMenu.Inner, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            function ContextMenu:Show()
                self.Container.Visible = true
            end

            function ContextMenu:Hide()
                self.Container.Visible = false
            end

            function ContextMenu:AddOption(Str, Callback)
                if type(Callback) ~= 'function' then
                    Callback = function() end
                end

                local Button = Library:CreateLabel({
                    Active = false;
                    Size = UDim2.new(1, 0, 0, 15);
                    TextSize = 13;
                    Text = Str;
                    ZIndex = 16;
                    Parent = self.Inner;
                    TextXAlignment = Enum.TextXAlignment.Left,
                });

                Library:OnHighlight(Button, Button, 
                    { TextColor3 = 'AccentColor' },
                    { TextColor3 = 'FontColor' }
                );

                Button.InputBegan:Connect(function(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return
                    end

                    Callback()
                end)
            end

            ContextMenu:AddOption('Copy color', function()
                Library.ColorClipboard = ColorPicker.Value
                Library:Notify('Copied color!', 2)
            end)

            ContextMenu:AddOption('Paste color', function()
                if not Library.ColorClipboard then
                    return Library:Notify('You have not copied a color!', 2)
                end
                ColorPicker:SetValueRGB(Library.ColorClipboard)
            end)


            ContextMenu:AddOption('Copy HEX', function()
                pcall(setclipboard, ColorPicker.Value:ToHex())
                Library:Notify('Copied hex code to clipboard!', 2)
            end)

            ContextMenu:AddOption('Copy RGB', function()
                pcall(setclipboard, table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', '))
                Library:Notify('Copied RGB values to clipboard!', 2)
            end)

        end

        Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(Highlight, { BackgroundColor3 = 'AccentColor'; });
        Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });

        Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(RgbBoxBase.Frame, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(RgbBox, { TextColor3 = 'FontColor', });
        Library:AddToRegistry(HueBox, { TextColor3 = 'FontColor', });

        local SequenceTable = {};

        for Hue = 0, 1, 0.1 do
            table.insert(SequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)));
        end;

        local HueSelectorGradient = Library:Create('UIGradient', {
            Color = ColorSequence.new(SequenceTable);
            Rotation = 90;
            Parent = HueSelectorInner;
        });

        HueBox.FocusLost:Connect(function(enter)
            if enter then
                local success, result = pcall(Color3.fromHex, HueBox.Text)
                if success and typeof(result) == 'Color3' then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(result)
                end
            end

            ColorPicker:Display()
        end)

        RgbBox.FocusLost:Connect(function(enter)
            if enter then
                local r, g, b = RgbBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
                if r and g and b then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(Color3.fromRGB(r, g, b))
                end
            end

            ColorPicker:Display()
        end)

        function ColorPicker:Display()
            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib);
            SatVibMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1);

            Library:Create(DisplayFrame, {
                BackgroundColor3 = ColorPicker.Value;
                BackgroundTransparency = ColorPicker.Transparency;
                BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
            });

            if TransparencyBoxInner then
                TransparencyBoxInner.BackgroundColor3 = ColorPicker.Value;
                TransparencyCursor.Position = UDim2.new(1 - ColorPicker.Transparency, 0, 0, 0);
            end;

            CursorOuter.Position = UDim2.new(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0);
            HueCursor.Position = UDim2.new(0, 0, ColorPicker.Hue, 0);

            HueBox.Text = '#' .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', ')

            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value);
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value);
        end;

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func;
            Func(ColorPicker.Value)
        end;

        function ColorPicker:Show()
            for Frame, Val in next, Library.OpenedFrames do
                if Frame.Name == 'Color' then
                    Frame.Visible = false;
                    Library.OpenedFrames[Frame] = nil;
                end;
            end;

            PickerFrameOuter.Visible = true;
            Library.OpenedFrames[PickerFrameOuter] = true;
        end;

        function ColorPicker:Hide()
            PickerFrameOuter.Visible = false;
            Library.OpenedFrames[PickerFrameOuter] = nil;
        end;

        function ColorPicker:SetValue(HSV, Transparency)
            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3]);

            ColorPicker.Transparency = Transparency or 0;
            ColorPicker:SetHSVFromRGB(Color);
            ColorPicker:Display();
        end;

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Transparency or 0;
            ColorPicker:SetHSVFromRGB(Color);
            ColorPicker:Display();
        end;

        SatVibMap.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinX = SatVibMap.AbsolutePosition.X;
                    local MaxX = MinX + SatVibMap.AbsoluteSize.X;
                    local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                    local MinY = SatVibMap.AbsolutePosition.Y;
                    local MaxY = MinY + SatVibMap.AbsoluteSize.Y;
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                    ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX);
                    ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY));
                    ColorPicker:Display();

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        HueSelectorInner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinY = HueSelectorInner.AbsolutePosition.Y;
                    local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y;
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                    ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY));
                    ColorPicker:Display();

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        DisplayFrame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if PickerFrameOuter.Visible then
                    ColorPicker:Hide()
                else
                    ContextMenu:Hide()
                    ColorPicker:Show()
                end;
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                ContextMenu:Show()
                ColorPicker:Hide()
            end
        end);

        if TransparencyBoxInner then
            TransparencyBoxInner.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local MinX = TransparencyBoxInner.AbsolutePosition.X;
                        local MaxX = MinX + TransparencyBoxInner.AbsoluteSize.X;
                        local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                        ColorPicker.Transparency = 1 - ((MouseX - MinX) / (MaxX - MinX));

                        ColorPicker:Display();

                        RenderStepped:Wait();
                    end;

                    Library:AttemptSave();
                end;
            end);
        end;

        Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    ColorPicker:Hide();
                end;

                if not Library:IsMouseOverFrame(ContextMenu.Container) then
                    ContextMenu:Hide()
                end
            end;

            if Input.UserInputType == Enum.UserInputType.MouseButton2 and ContextMenu.Container.Visible then
                if not Library:IsMouseOverFrame(ContextMenu.Container) and not Library:IsMouseOverFrame(DisplayFrame) then
                    ContextMenu:Hide()
                end
            end
        end))

        ColorPicker:Display();
        ColorPicker.DisplayFrame = DisplayFrame

        Options[Idx] = ColorPicker;

        return self;
    end;

function Funcs:AddKeyPicker(Idx, Info)
    local ParentObj = self;
    local ToggleLabel = self.TextLabel;
    local Container = self.Container;

    assert(Info.Default, 'AddKeyPicker: Missing default value.');

    local KeyPicker = {
        Value = Info.Default;
        Toggled = false;
        Mode = Info.Mode or 'Toggle'; -- Always, Toggle, Hold
        Type = 'KeyPicker';
        Callback = Info.Callback or function(Value) end;
        ChangedCallback = Info.ChangedCallback or function(New) end;
        SyncToggleState = Info.SyncToggleState or false;
    };

    if KeyPicker.SyncToggleState then
        Info.Modes = { 'Toggle' }
        Info.Mode = 'Toggle'
    end

    local PickOuter = Library:Create('Frame', {
        BackgroundColor3 = Color3.new(0, 0, 0);
        BorderColor3 = Color3.new(0, 0, 0);
        Size = UDim2.new(0, 28, 0, 15);
        ZIndex = 6;
        Parent = ToggleLabel;
    });

    local PickInner = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 7;
        Parent = PickOuter;
    });

    Library:AddToRegistry(PickInner, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });

    local DisplayLabel = Library:CreateLabel({
        Size = UDim2.new(1, 0, 1, 0);
        TextSize = 13;
        Text = Info.Default;
        TextWrapped = true;
        ZIndex = 8;
        Parent = PickInner;
    });

    local ModeSelectOuter = Library:Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
        Size = UDim2.new(0, 60, 0, 45 + 2);
        Visible = false;
        ZIndex = 14;
        Parent = ScreenGui;
    });

    ToggleLabel:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
        ModeSelectOuter.Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
    end);

    local ModeSelectInner = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 15;
        Parent = ModeSelectOuter;
    });

    Library:AddToRegistry(ModeSelectInner, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });

    Library:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = ModeSelectInner;
    });

    local ContainerLabel = Library:CreateLabel({
        TextXAlignment = Enum.TextXAlignment.Left;
        Size = UDim2.new(1, 0, 0, 18);
        TextSize = 13;
        Visible = false;
        ZIndex = 110;
        Parent = Library.KeybindContainer;
    },  true);

    local Modes = Info.Modes or { 'Always', 'Toggle', 'Hold' };
    local ModeButtons = {};

    for Idx, Mode in next, Modes do
        local ModeButton = {};

        local Label = Library:CreateLabel({
            Active = false;
            Size = UDim2.new(1, 0, 0, 15);
            TextSize = 13;
            Text = Mode;
            ZIndex = 16;
            Parent = ModeSelectInner;
        });

        function ModeButton:Select()
            for _, Button in next, ModeButtons do
                Button:Deselect();
            end;

            KeyPicker.Mode = Mode;

            Label.TextColor3 = Library.AccentColor;
            Library.RegistryMap[Label].Properties.TextColor3 = 'AccentColor';

            ModeSelectOuter.Visible = false;
        end;

        function ModeButton:Deselect()
            KeyPicker.Mode = nil;

            Label.TextColor3 = Library.FontColor;
            Library.RegistryMap[Label].Properties.TextColor3 = 'FontColor';
        end;

        Label.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                ModeButton:Select();
                Library:AttemptSave();
            end;
        end);

        if Mode == KeyPicker.Mode then
            ModeButton:Select();
        end;

        ModeButtons[Mode] = ModeButton;
    end;

    function KeyPicker:Update()
        -- Если используется волновой дисплей, НЕ показываем оригинальный
        if Info.NoUI or (not Info.NoUI and Library.WaveSystem) then
            return;
        end;

        local State = KeyPicker:GetState();

        ContainerLabel.Text = string.format('[%s] %s (%s)', KeyPicker.Value, Info.Text, KeyPicker.Mode);
        ContainerLabel.Visible = true;
        ContainerLabel.TextColor3 = State and Library.AccentColor or Library.FontColor;

        Library.RegistryMap[ContainerLabel].Properties.TextColor3 = State and 'AccentColor' or 'FontColor';

        local YSize = 0
        local XSize = 0

        for _, Label in next, Library.KeybindContainer:GetChildren() do
            if Label:IsA('TextLabel') and Label.Visible then
                YSize = YSize + 18;

                if (Label.TextBounds.X > XSize) then
                    XSize = Label.TextBounds.X
                end
            end;
        end;

        Library.KeybindFrame.Size = UDim2.new(0, math.max(XSize + 10, 210), 0, YSize + 23)
    end;

    function KeyPicker:GetState()
        if KeyPicker.Mode == 'Always' then
            return true;
        elseif KeyPicker.Mode == 'Hold' then
            if KeyPicker.Value == 'None' then
                return false;
            end

            local Key = KeyPicker.Value;

            if Key == 'MB1' or Key == 'MB2' then
                return Key == 'MB1' and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                    or Key == 'MB2' and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2);
            else
                return InputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value]);
            end;
        else
            return KeyPicker.Toggled;
        end;
    end;

    function KeyPicker:SetValue(Data)
        local Key, Mode = Data[1], Data[2];
        DisplayLabel.Text = Key;
        KeyPicker.Value = Key;
        ModeButtons[Mode]:Select();
        KeyPicker:Update();
    end;

    function KeyPicker:OnClick(Callback)
        KeyPicker.Clicked = Callback
    end

    function KeyPicker:OnChanged(Callback)
        KeyPicker.Changed = Callback
        Callback(KeyPicker.Value)
    end

    if ParentObj.Addons then
        table.insert(ParentObj.Addons, KeyPicker)
    end

    function KeyPicker:DoClick()
        if ParentObj.Type == 'Toggle' and KeyPicker.SyncToggleState then
            ParentObj:SetValue(not ParentObj.Value)
        end

        Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
        Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)
    end

    local Picking = false;

    PickOuter.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
            Picking = true;
            DisplayLabel.Text = '';

            local Break;
            local Text = '';

            task.spawn(function()
                while (not Break) do
                    if Text == '...' then
                        Text = '';
                    end;

                    Text = Text .. '.';
                    DisplayLabel.Text = Text;

                    wait(0.4);
                end;
            end);

            wait(0.2);

            local Event;
            Event = InputService.InputBegan:Connect(function(Input)
                local Key;

                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    Key = Input.KeyCode.Name;
                elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Key = 'MB1';
                elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Key = 'MB2';
                end;

                Break = true;
                Picking = false;

                DisplayLabel.Text = Key;
                KeyPicker.Value = Key;

                Library:SafeCallback(KeyPicker.ChangedCallback, Input.KeyCode or Input.UserInputType)
                Library:SafeCallback(KeyPicker.Changed, Input.KeyCode or Input.UserInputType)

                Library:AttemptSave();

                Event:Disconnect();
            end);
        elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
            ModeSelectOuter.Visible = true;
        end;
    end);

    Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
        if (not Picking) then
            if KeyPicker.Mode == 'Toggle' then
                local Key = KeyPicker.Value;

                if Key == 'MB1' or Key == 'MB2' then
                    if Key == 'MB1' and Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Key == 'MB2' and Input.UserInputType == Enum.UserInputType.MouseButton2 then

                        KeyPicker.Toggled = not KeyPicker.Toggled
                        KeyPicker:DoClick()
                    end;
                elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                    if Input.KeyCode.Name == Key then
                        KeyPicker.Toggled = not KeyPicker.Toggled;
                        KeyPicker:DoClick()
                    end;
                end;
            end;

            KeyPicker:Update();
        end;

        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize;

            if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                ModeSelectOuter.Visible = false;
            end;
        end;
    end))

    Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
        if (not Picking) then
            KeyPicker:Update();
        end;
    end))

    KeyPicker:Update();

    -- ============================================
    -- ИНТЕГРАЦИЯ С ВОЛНОВЫМ ДИСПЛЕЕМ
    -- ============================================
    
    if not Info.NoUI and Info.Text and Library.WaveSystem then
        local icon = "key"
        local lowerText = string.lower(Info.Text)
        
        if string.find(lowerText, "esp") or string.find(lowerText, "box") or string.find(lowerText, "tracer") then
            icon = "eye"
        elseif string.find(lowerText, "aim") then
            icon = "target"
        elseif string.find(lowerText, "health") or string.find(lowerText, "hp") then
            icon = "heart"
        elseif string.find(lowerText, "fly") or string.find(lowerText, "speed") then
            icon = "zap"
        elseif string.find(lowerText, "menu") or string.find(lowerText, "setting") then
            icon = "settings"
        elseif string.find(lowerText, "lock") or string.find(lowerText, "safe") then
            icon = "lock"
        elseif string.find(lowerText, "weapon") or string.find(lowerText, "gun") then
            icon = "sword"
        end
        
        local keyText = Info.Default or "None"
        if type(keyText) == "string" then
            if keyText == "LeftShift" then keyText = "LShift"
            elseif keyText == "RightShift" then keyText = "RShift"
            elseif keyText == "LeftControl" then keyText = "LCtrl"
            elseif keyText == "RightControl" then keyText = "RCtrl"
            elseif keyText == "LeftAlt" then keyText = "LAlt"
            elseif keyText == "RightAlt" then keyText = "RAlt"
            end
        end
        
        Library:AddKeybind(Info.Text, keyText, false, icon)
        
        task.spawn(function()
            while task.wait(0.1) do
                if Library.Unloaded then break end
                local state = KeyPicker:GetState()
                Library:UpdateKeybindState(Info.Text, state)
            end
        end)
    end

    Options[Idx] = KeyPicker;

    return self;
end;



    BaseAddons.__index = Funcs;
    BaseAddons.__namecall = function(Table, Key, ...)
        return Funcs[Key](...);
    end;
end;

local BaseGroupbox = {};

do
    local Funcs = {};

    function Funcs:AddBlank(Size)
        local Groupbox = self;
        local Container = Groupbox.Container;

        Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, Size);
            ZIndex = 1;
            Parent = Container;
        });
    end;

    function Funcs:AddLabel(Text, DoesWrap)
        local Label = {};

        local Groupbox = self;
        local Container = Groupbox.Container;

        local TextLabel = Library:CreateLabel({
            Size = UDim2.new(1, -4, 0, 15);
            TextSize = 14;
            Text = Text;
            TextWrapped = DoesWrap or false,
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        });

        if DoesWrap then
            local Y = select(2, Library:GetTextBounds(Text, Library.Font, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
            TextLabel.Size = UDim2.new(1, -4, 0, Y)
        else
            Library:Create('UIListLayout', {
                Padding = UDim.new(0, 4);
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = TextLabel;
            });
        end

        Label.TextLabel = TextLabel;
        Label.Container = Container;

        function Label:SetText(Text)
            TextLabel.Text = Text

            if DoesWrap then
                local Y = select(2, Library:GetTextBounds(Text, Library.Font, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
                TextLabel.Size = UDim2.new(1, -4, 0, Y)
            end

            Groupbox:Resize();
        end

        if (not DoesWrap) then
            setmetatable(Label, BaseAddons);
        end

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        return Label;
    end;

    function Funcs:AddButton(...)
        -- TODO: Eventually redo this
        local Button = {};
        local function ProcessButtonParams(Class, Obj, ...)
            local Props = select(1, ...)
            if type(Props) == 'table' then
                Obj.Text = Props.Text
                Obj.Func = Props.Func
                Obj.DoubleClick = Props.DoubleClick
                Obj.Tooltip = Props.Tooltip
            else
                Obj.Text = select(1, ...)
                Obj.Func = select(2, ...)
            end

            assert(type(Obj.Func) == 'function', 'AddButton: `Func` callback is missing.');
        end

        ProcessButtonParams('Button', Button, ...)

        local Groupbox = self;
        local Container = Groupbox.Container;

        local function CreateBaseButton(Button)
            local Outer = Library:Create('Frame', {
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(1, -4, 0, 20);
                ZIndex = 5;
            });

            local Inner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 6;
                Parent = Outer;
            });

            local Label = Library:CreateLabel({
                Size = UDim2.new(1, 0, 1, 0);
                TextSize = 14;
                Text = Button.Text;
                ZIndex = 6;
                Parent = Inner;
            });

            Library:Create('UIGradient', {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                });
                Rotation = 90;
                Parent = Inner;
            });

            Library:AddToRegistry(Outer, {
                BorderColor3 = 'Black';
            });

            Library:AddToRegistry(Inner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });

            Library:OnHighlight(Outer, Outer,
                { BorderColor3 = 'AccentColor' },
                { BorderColor3 = 'Black' }
            );

            return Outer, Inner, Label
        end

        local function InitEvents(Button)
            local function WaitForEvent(event, timeout, validator)
                local bindable = Instance.new('BindableEvent')
                local connection = event:Once(function(...)

                    if type(validator) == 'function' and validator(...) then
                        bindable:Fire(true)
                    else
                        bindable:Fire(false)
                    end
                end)
                task.delay(timeout, function()
                    connection:disconnect()
                    bindable:Fire(false)
                end)
                return bindable.Event:Wait()
            end

            local function ValidateClick(Input)
                if Library:MouseIsOverOpenedFrame() then
                    return false
                end

                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return false
                end

                return true
            end

            Button.Outer.InputBegan:Connect(function(Input)
                if not ValidateClick(Input) then return end
                if Button.Locked then return end

                if Button.DoubleClick then
                    Library:RemoveFromRegistry(Button.Label)
                    Library:AddToRegistry(Button.Label, { TextColor3 = 'AccentColor' })

                    Button.Label.TextColor3 = Library.AccentColor
                    Button.Label.Text = 'Are you sure?'
                    Button.Locked = true

                    local clicked = WaitForEvent(Button.Outer.InputBegan, 0.5, ValidateClick)

                    Library:RemoveFromRegistry(Button.Label)
                    Library:AddToRegistry(Button.Label, { TextColor3 = 'FontColor' })

                    Button.Label.TextColor3 = Library.FontColor
                    Button.Label.Text = Button.Text
                    task.defer(rawset, Button, 'Locked', false)

                    if clicked then
                        Library:SafeCallback(Button.Func)
                    end

                    return
                end

                Library:SafeCallback(Button.Func);
            end)
        end

        Button.Outer, Button.Inner, Button.Label = CreateBaseButton(Button)
        Button.Outer.Parent = Container

        InitEvents(Button)

        function Button:AddTooltip(tooltip)
            if type(tooltip) == 'string' then
                Library:AddToolTip(tooltip, self.Outer)
            end
            return self
        end


        function Button:AddButton(...)
            local SubButton = {}

            ProcessButtonParams('SubButton', SubButton, ...)

            self.Outer.Size = UDim2.new(0.5, -2, 0, 20)

            SubButton.Outer, SubButton.Inner, SubButton.Label = CreateBaseButton(SubButton)

            SubButton.Outer.Position = UDim2.new(1, 3, 0, 0)
            SubButton.Outer.Size = UDim2.fromOffset(self.Outer.AbsoluteSize.X - 2, self.Outer.AbsoluteSize.Y)
            SubButton.Outer.Parent = self.Outer

            function SubButton:AddTooltip(tooltip)
                if type(tooltip) == 'string' then
                    Library:AddToolTip(tooltip, self.Outer)
                end
                return SubButton
            end

            if type(SubButton.Tooltip) == 'string' then
                SubButton:AddTooltip(SubButton.Tooltip)
            end

            InitEvents(SubButton)
            return SubButton
        end

        if type(Button.Tooltip) == 'string' then
            Button:AddTooltip(Button.Tooltip)
        end

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        return Button;
    end;

    function Funcs:AddDivider()
        local Groupbox = self;
        local Container = self.Container

        local Divider = {
            Type = 'Divider',
        }

        Groupbox:AddBlank(2);
        local DividerOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 5);
            ZIndex = 5;
            Parent = Container;
        });

        local DividerInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DividerOuter;
        });

        Library:AddToRegistry(DividerOuter, {
            BorderColor3 = 'Black';
        });

        Library:AddToRegistry(DividerInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Groupbox:AddBlank(9);
        Groupbox:Resize();
    end

    function Funcs:AddInput(Idx, Info)
        assert(Info.Text, 'AddInput: Missing `Text` string.')

        local Textbox = {
            Value = Info.Default or '';
            Numeric = Info.Numeric or false;
            Finished = Info.Finished or false;
            Type = 'Input';
            Callback = Info.Callback or function(Value) end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local InputLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 15);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        });

        Groupbox:AddBlank(1);

        local TextBoxOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 20);
            ZIndex = 5;
            Parent = Container;
        });

        local TextBoxInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = TextBoxOuter;
        });

        Library:AddToRegistry(TextBoxInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:OnHighlight(TextBoxOuter, TextBoxOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, TextBoxOuter)
        end

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = TextBoxInner;
        });

        local Container = Library:Create('Frame', {
            BackgroundTransparency = 1;
            ClipsDescendants = true;

            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);

            ZIndex = 7;
            Parent = TextBoxInner;
        })

        local Box = Library:Create('TextBox', {
            BackgroundTransparency = 1;

            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromScale(5, 1),

            Font = Library.Font;
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
            PlaceholderText = Info.Placeholder or '';

            Text = Info.Default or '';
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;

            ZIndex = 7;
            Parent = Container;
        });

        Library:ApplyTextStroke(Box);

        function Textbox:SetValue(Text)
            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength);
            end;

            if Textbox.Numeric then
                if (not tonumber(Text)) and Text:len() > 0 then
                    Text = Textbox.Value
                end
            end

            Textbox.Value = Text;
            Box.Text = Text;

            Library:SafeCallback(Textbox.Callback, Textbox.Value);
            Library:SafeCallback(Textbox.Changed, Textbox.Value);
        end;

        if Textbox.Finished then
            Box.FocusLost:Connect(function(enter)
                if not enter then return end

                Textbox:SetValue(Box.Text);
                Library:AttemptSave();
            end)
        else
            Box:GetPropertyChangedSignal('Text'):Connect(function()
                Textbox:SetValue(Box.Text);
                Library:AttemptSave();
            end);
        end

        -- https://devforum.roblox.com/t/how-to-make-textboxes-follow-current-cursor-position/1368429/6
        -- thank you nicemike40 :)

        local function Update()
            local PADDING = 2
            local reveal = Container.AbsoluteSize.X

            if not Box:IsFocused() or Box.TextBounds.X <= reveal - 2 * PADDING then
                -- we aren't focused, or we fit so be normal
                Box.Position = UDim2.new(0, PADDING, 0, 0)
            else
                -- we are focused and don't fit, so adjust position
                local cursor = Box.CursorPosition
                if cursor ~= -1 then
                    -- calculate pixel width of text from start to cursor
                    local subtext = string.sub(Box.Text, 1, cursor-1)
                    local width = TextService:GetTextSize(subtext, Box.TextSize, Box.Font, Vector2.new(math.huge, math.huge)).X

                    -- check if we're inside the box with the cursor
                    local currentCursorPos = Box.Position.X.Offset + width

                    -- adjust if necessary
                    if currentCursorPos < PADDING then
                        Box.Position = UDim2.fromOffset(PADDING-width, 0)
                    elseif currentCursorPos > reveal - PADDING - 1 then
                        Box.Position = UDim2.fromOffset(reveal-width-PADDING-1, 0)
                    end
                end
            end
        end

        task.spawn(Update)

        Box:GetPropertyChangedSignal('Text'):Connect(Update)
        Box:GetPropertyChangedSignal('CursorPosition'):Connect(Update)
        Box.FocusLost:Connect(Update)
        Box.Focused:Connect(Update)

        Library:AddToRegistry(Box, {
            TextColor3 = 'FontColor';
        });

        function Textbox:OnChanged(Func)
            Textbox.Changed = Func;
            Func(Textbox.Value);
        end;

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        Options[Idx] = Textbox;

        return Textbox;
    end;

    function Funcs:AddToggle(Idx, Info)
        assert(Info.Text, 'AddInput: Missing `Text` string.')

        local Toggle = {
            Value = Info.Default or false;
            Type = 'Toggle';

            Callback = Info.Callback or function(Value) end;
            Addons = {},
            Risky = Info.Risky,
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local ToggleOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 13, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(ToggleOuter, {
            BorderColor3 = 'Black';
        });

        local ToggleInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = ToggleOuter;
        });

        Library:AddToRegistry(ToggleInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local ToggleLabel = Library:CreateLabel({
            Size = UDim2.new(0, 216, 1, 0);
            Position = UDim2.new(1, 6, 0, 0);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 6;
            Parent = ToggleInner;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 4);
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ToggleLabel;
        });

        local ToggleRegion = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(0, 170, 1, 0);
            ZIndex = 8;
            Parent = ToggleOuter;
        });

        Library:OnHighlight(ToggleRegion, ToggleOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        function Toggle:UpdateColors()
            Toggle:Display();
        end;

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, ToggleRegion)
        end

        function Toggle:Display()
            ToggleInner.BackgroundColor3 = Toggle.Value and Library.AccentColor or Library.MainColor;
            ToggleInner.BorderColor3 = Toggle.Value and Library.AccentColorDark or Library.OutlineColor;

            Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and 'AccentColor' or 'MainColor';
            Library.RegistryMap[ToggleInner].Properties.BorderColor3 = Toggle.Value and 'AccentColorDark' or 'OutlineColor';
        end;

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func;
            Func(Toggle.Value);
        end;

        function Toggle:SetValue(Bool)
            Bool = (not not Bool);

            Toggle.Value = Bool;
            Toggle:Display();

            for _, Addon in next, Toggle.Addons do
                if Addon.Type == 'KeyPicker' and Addon.SyncToggleState then
                    Addon.Toggled = Bool
                    Addon:Update()
                end
            end

            Library:SafeCallback(Toggle.Callback, Toggle.Value);
            Library:SafeCallback(Toggle.Changed, Toggle.Value);
            Library:UpdateDependencyBoxes();
        end;

        ToggleRegion.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                Toggle:SetValue(not Toggle.Value) -- Why was it not like this from the start?
                Library:AttemptSave();
            end;
        end);

        if Toggle.Risky then
            Library:RemoveFromRegistry(ToggleLabel)
            ToggleLabel.TextColor3 = Library.RiskColor
            Library:AddToRegistry(ToggleLabel, { TextColor3 = 'RiskColor' })
        end

        Toggle:Display();
        Groupbox:AddBlank(Info.BlankSize or 5 + 2);
        Groupbox:Resize();

        Toggle.TextLabel = ToggleLabel;
        Toggle.Container = Container;
        setmetatable(Toggle, BaseAddons);

        Toggles[Idx] = Toggle;

        Library:UpdateDependencyBoxes();

        return Toggle;
    end;

    function Funcs:AddSlider(Idx, Info)
        assert(Info.Default, 'AddSlider: Missing default value.');
        assert(Info.Text, 'AddSlider: Missing slider text.');
        assert(Info.Min, 'AddSlider: Missing minimum value.');
        assert(Info.Max, 'AddSlider: Missing maximum value.');
        assert(Info.Rounding, 'AddSlider: Missing rounding value.');

        local Slider = {
            Value = Info.Default;
            Min = Info.Min;
            Max = Info.Max;
            Rounding = Info.Rounding;
            MaxSize = 232;
            Type = 'Slider';
            Callback = Info.Callback or function(Value) end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        if not Info.Compact then
            Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                ZIndex = 5;
                Parent = Container;
            });

            Groupbox:AddBlank(3);
        end

        local SliderOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(SliderOuter, {
            BorderColor3 = 'Black';
        });

        local SliderInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = SliderOuter;
        });

        Library:AddToRegistry(SliderInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local Fill = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderColor3 = Library.AccentColorDark;
            Size = UDim2.new(0, 0, 1, 0);
            ZIndex = 7;
            Parent = SliderInner;
        });

        Library:AddToRegistry(Fill, {
            BackgroundColor3 = 'AccentColor';
            BorderColor3 = 'AccentColorDark';
        });

        local HideBorderRight = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Position = UDim2.new(1, 0, 0, 0);
            Size = UDim2.new(0, 1, 1, 0);
            ZIndex = 8;
            Parent = Fill;
        });

        Library:AddToRegistry(HideBorderRight, {
            BackgroundColor3 = 'AccentColor';
        });

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 14;
            Text = 'Infinite';
            ZIndex = 9;
            Parent = SliderInner;
        });

        Library:OnHighlight(SliderOuter, SliderOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, SliderOuter)
        end

        function Slider:UpdateColors()
            Fill.BackgroundColor3 = Library.AccentColor;
            Fill.BorderColor3 = Library.AccentColorDark;
        end;

        function Slider:Display()
            local Suffix = Info.Suffix or '';

            if Info.Compact then
                DisplayLabel.Text = Info.Text .. ': ' .. Slider.Value .. Suffix
            elseif Info.HideMax then
                DisplayLabel.Text = string.format('%s', Slider.Value .. Suffix)
            else
                DisplayLabel.Text = string.format('%s/%s', Slider.Value .. Suffix, Slider.Max .. Suffix);
            end

            local X = math.ceil(Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, Slider.MaxSize));
            Fill.Size = UDim2.new(0, X, 1, 0);

            HideBorderRight.Visible = not (X == Slider.MaxSize or X == 0);
        end;

        function Slider:OnChanged(Func)
            Slider.Changed = Func;
            Func(Slider.Value);
        end;

        local function Round(Value)
            if Slider.Rounding == 0 then
                return math.floor(Value);
            end;


            return tonumber(string.format('%.' .. Slider.Rounding .. 'f', Value))
        end;

        function Slider:GetValueFromXOffset(X)
            return Round(Library:MapValue(X, 0, Slider.MaxSize, Slider.Min, Slider.Max));
        end;

        function Slider:SetValue(Str)
            local Num = tonumber(Str);

            if (not Num) then
                return;
            end;

            Num = math.clamp(Num, Slider.Min, Slider.Max);

            Slider.Value = Num;
            Slider:Display();

            Library:SafeCallback(Slider.Callback, Slider.Value);
            Library:SafeCallback(Slider.Changed, Slider.Value);
        end;

        SliderInner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                local mPos = Mouse.X;
                local gPos = Fill.Size.X.Offset;
                local Diff = mPos - (Fill.AbsolutePosition.X + gPos);

                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local nMPos = Mouse.X;
                    local nX = math.clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize);

                    local nValue = Slider:GetValueFromXOffset(nX);
                    local OldValue = Slider.Value;
                    Slider.Value = nValue;

                    Slider:Display();

                    if nValue ~= OldValue then
                        Library:SafeCallback(Slider.Callback, Slider.Value);
                        Library:SafeCallback(Slider.Changed, Slider.Value);
                    end;

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        Slider:Display();
        Groupbox:AddBlank(Info.BlankSize or 6);
        Groupbox:Resize();

        Options[Idx] = Slider;

        return Slider;
    end;

    function Funcs:AddDropdown(Idx, Info)
        if Info.SpecialType == 'Player' then
            Info.Values = GetPlayersString();
            Info.AllowNull = true;
        elseif Info.SpecialType == 'Team' then
            Info.Values = GetTeamsString();
            Info.AllowNull = true;
        end;

        assert(Info.Values, 'AddDropdown: Missing dropdown value list.');
        assert(Info.AllowNull or Info.Default, 'AddDropdown: Missing default value. Pass `AllowNull` as true if this was intentional.')

        if (not Info.Text) then
            Info.Compact = true;
        end;

        local Dropdown = {
            Values = Info.Values;
            Value = Info.Multi and {};
            Multi = Info.Multi;
            Type = 'Dropdown';
            SpecialType = Info.SpecialType; -- can be either 'Player' or 'Team'
            Callback = Info.Callback or function(Value) end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local RelativeOffset = 0;

        if not Info.Compact then
            local DropdownLabel = Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                ZIndex = 5;
                Parent = Container;
            });

            Groupbox:AddBlank(3);
        end

        for _, Element in next, Container:GetChildren() do
            if not Element:IsA('UIListLayout') then
                RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
            end;
        end;

        local DropdownOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 20);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(DropdownOuter, {
            BorderColor3 = 'Black';
        });

        local DropdownInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DropdownOuter;
        });

        Library:AddToRegistry(DropdownInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = DropdownInner;
        });

        local DropdownArrow = Library:Create('ImageLabel', {
            AnchorPoint = Vector2.new(0, 0.5);
            BackgroundTransparency = 1;
            Position = UDim2.new(1, -16, 0.5, 0);
            Size = UDim2.new(0, 12, 0, 12);
            Image = 'http://www.roblox.com/asset/?id=6282522798';
            ZIndex = 8;
            Parent = DropdownInner;
        });

        local ItemList = Library:CreateLabel({
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            TextSize = 14;
            Text = '--';
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = true;
            ZIndex = 7;
            Parent = DropdownInner;
        });

        Library:OnHighlight(DropdownOuter, DropdownOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, DropdownOuter)
        end

        local MAX_DROPDOWN_ITEMS = 8;

        local ListOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            ZIndex = 20;
            Visible = false;
            Parent = ScreenGui;
        });

        local function RecalculateListPosition()
            ListOuter.Position = UDim2.fromOffset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.Size.Y.Offset + 1);
        end;

        local function RecalculateListSize(YSize)
            ListOuter.Size = UDim2.fromOffset(DropdownOuter.AbsoluteSize.X, YSize or (MAX_DROPDOWN_ITEMS * 20 + 2))
        end;

        RecalculateListPosition();
        RecalculateListSize();

        DropdownOuter:GetPropertyChangedSignal('AbsolutePosition'):Connect(RecalculateListPosition);

        local ListInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListOuter;
        });

        Library:AddToRegistry(ListInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local Scrolling = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            CanvasSize = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListInner;

            TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
            BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',

            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.AccentColor,
        });

        Library:AddToRegistry(Scrolling, {
            ScrollBarImageColor3 = 'AccentColor'
        })

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 0);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Scrolling;
        });

        function Dropdown:Display()
            local Values = Dropdown.Values;
            local Str = '';

            if Info.Multi then
                for Idx, Value in next, Values do
                    if Dropdown.Value[Value] then
                        Str = Str .. Value .. ', ';
                    end;
                end;

                Str = Str:sub(1, #Str - 2);
            else
                Str = Dropdown.Value or '';
            end;

            ItemList.Text = (Str == '' and '--' or Str);
        end;

        function Dropdown:GetActiveValues()
            if Info.Multi then
                local T = {};

                for Value, Bool in next, Dropdown.Value do
                    table.insert(T, Value);
                end;

                return T;
            else
                return Dropdown.Value and 1 or 0;
            end;
        end;

        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values;
            local Buttons = {};

            for _, Element in next, Scrolling:GetChildren() do
                if not Element:IsA('UIListLayout') then
                    Element:Destroy();
                end;
            end;

            local Count = 0;

            for Idx, Value in next, Values do
                local Table = {};

                Count = Count + 1;

                local Button = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Middle;
                    Size = UDim2.new(1, -1, 0, 20);
                    ZIndex = 23;
                    Active = true,
                    Parent = Scrolling;
                });

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                local ButtonLabel = Library:CreateLabel({
                    Active = false;
                    Size = UDim2.new(1, -6, 1, 0);
                    Position = UDim2.new(0, 6, 0, 0);
                    TextSize = 14;
                    Text = Value;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 25;
                    Parent = Button;
                });

                Library:OnHighlight(Button, Button,
                    { BorderColor3 = 'AccentColor', ZIndex = 24 },
                    { BorderColor3 = 'OutlineColor', ZIndex = 23 }
                );

                local Selected;

                if Info.Multi then
                    Selected = Dropdown.Value[Value];
                else
                    Selected = Dropdown.Value == Value;
                end;

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value];
                    else
                        Selected = Dropdown.Value == Value;
                    end;

                    ButtonLabel.TextColor3 = Selected and Library.AccentColor or Library.FontColor;
                    Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and 'AccentColor' or 'FontColor';
                end;

                ButtonLabel.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local Try = not Selected;

                        if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                        else
                            if Info.Multi then
                                Selected = Try;

                                if Selected then
                                    Dropdown.Value[Value] = true;
                                else
                                    Dropdown.Value[Value] = nil;
                                end;
                            else
                                Selected = Try;

                                if Selected then
                                    Dropdown.Value = Value;
                                else
                                    Dropdown.Value = nil;
                                end;

                                for _, OtherButton in next, Buttons do
                                    OtherButton:UpdateButton();
                                end;
                            end;

                            Table:UpdateButton();
                            Dropdown:Display();

                            Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                            Library:SafeCallback(Dropdown.Changed, Dropdown.Value);

                            Library:AttemptSave();
                        end;
                    end;
                end);

                Table:UpdateButton();
                Dropdown:Display();

                Buttons[Button] = Table;
            end;

            Scrolling.CanvasSize = UDim2.fromOffset(0, (Count * 20) + 1);

            local Y = math.clamp(Count * 20, 0, MAX_DROPDOWN_ITEMS * 20) + 1;
            RecalculateListSize(Y);
        end;

        function Dropdown:SetValues(NewValues)
            if NewValues then
                Dropdown.Values = NewValues;
            end;

            Dropdown:BuildDropdownList();
        end;

        function Dropdown:OpenDropdown()
            ListOuter.Visible = true;
            Library.OpenedFrames[ListOuter] = true;
            DropdownArrow.Rotation = 180;
        end;

        function Dropdown:CloseDropdown()
            ListOuter.Visible = false;
            Library.OpenedFrames[ListOuter] = nil;
            DropdownArrow.Rotation = 0;
        end;

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func;
            Func(Dropdown.Value);
        end;

        function Dropdown:SetValue(Val)
            if Dropdown.Multi then
                local nTable = {};

                for Value, Bool in next, Val do
                    if table.find(Dropdown.Values, Value) then
                        nTable[Value] = true
                    end;
                end;

                Dropdown.Value = nTable;
            else
                if (not Val) then
                    Dropdown.Value = nil;
                elseif table.find(Dropdown.Values, Val) then
                    Dropdown.Value = Val;
                end;
            end;

            Dropdown:BuildDropdownList();

            Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value);
        end;

        DropdownOuter.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if ListOuter.Visible then
                    Dropdown:CloseDropdown();
                else
                    Dropdown:OpenDropdown();
                end;
            end;
        end);

        InputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    Dropdown:CloseDropdown();
                end;
            end;
        end);

        Dropdown:BuildDropdownList();
        Dropdown:Display();

        local Defaults = {}

        if type(Info.Default) == 'string' then
            local Idx = table.find(Dropdown.Values, Info.Default)
            if Idx then
                table.insert(Defaults, Idx)
            end
        elseif type(Info.Default) == 'table' then
            for _, Value in next, Info.Default do
                local Idx = table.find(Dropdown.Values, Value)
                if Idx then
                    table.insert(Defaults, Idx)
                end
            end
        elseif type(Info.Default) == 'number' and Dropdown.Values[Info.Default] ~= nil then
            table.insert(Defaults, Info.Default)
        end

        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Info.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index];
                end

                if (not Info.Multi) then break end
            end

            Dropdown:BuildDropdownList();
            Dropdown:Display();
        end

        Groupbox:AddBlank(Info.BlankSize or 5);
        Groupbox:Resize();

        Options[Idx] = Dropdown;

        return Dropdown;
    end;

    function Funcs:AddDependencyBox()
        local Depbox = {
            Dependencies = {};
        };
        
        local Groupbox = self;
        local Container = Groupbox.Container;

        local Holder = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, 0);
            Visible = false;
            Parent = Container;
        });

        local Frame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 1, 0);
            Visible = true;
            Parent = Holder;
        });

        local Layout = Library:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Frame;
        });

        function Depbox:Resize()
            Holder.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y);
            Groupbox:Resize();
        end;

        Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            Depbox:Resize();
        end);

        Holder:GetPropertyChangedSignal('Visible'):Connect(function()
            Depbox:Resize();
        end);

        function Depbox:Update()
            for _, Dependency in next, Depbox.Dependencies do
                local Elem = Dependency[1];
                local Value = Dependency[2];

                if Elem.Type == 'Toggle' and Elem.Value ~= Value then
                    Holder.Visible = false;
                    Depbox:Resize();
                    return;
                end;
            end;

            Holder.Visible = true;
            Depbox:Resize();
        end;

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in next, Dependencies do
                assert(type(Dependency) == 'table', 'SetupDependencies: Dependency is not of type `table`.');
                assert(Dependency[1], 'SetupDependencies: Dependency is missing element argument.');
                assert(Dependency[2] ~= nil, 'SetupDependencies: Dependency is missing value argument.');
            end;

            Depbox.Dependencies = Dependencies;
            Depbox:Update();
        end;

        Depbox.Container = Frame;

        setmetatable(Depbox, BaseGroupbox);

        table.insert(Library.DependencyBoxes, Depbox);

        return Depbox;
    end;

    BaseGroupbox.__index = Funcs;
    BaseGroupbox.__namecall = function(Table, Key, ...)
        return Funcs[Key](...);
    end;
end;

-- ПОЛНОСТЬЮ РАБОЧАЯ ВОЛНОВАЯ СИСТЕМА С ЦВЕТАМИ ИЗ LIBRARY
-- Все волны работают + FPS/Ping + иконки Lucide + отдельные цвета
-- Заменяет секцию "-- < Create other UI elements >"

local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local Stats = game:GetService('Stats')
local HttpService = game:GetService('HttpService')

-- ============================================
-- ДОБАВЬ ЭТИ ЦВЕТА В СТРУКТУРУ LIBRARY
-- ============================================

-- ✨ НОВЫЕ ЦВЕТА ДЛЯ ВАТЕРМАРКА (добавь в Library = {})
Library.WatermarkProjectColor = Library.WatermarkProjectColor or Color3.fromRGB(180, 100, 220)
Library.WatermarkGeneralColor = Library.WatermarkGeneralColor or Color3.fromRGB(255, 255, 255)

-- ============================================
-- ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ЦВЕТАМИ
-- ============================================

-- Защита от циклических вызовов
Library._ColorUpdateInProgress = false

function Library:SetWatermarkProjectColor(color)
    if self._ColorUpdateInProgress then return end
    self._ColorUpdateInProgress = true
    
    self.WatermarkProjectColor = color
    if self.WaveSystem and self.WaveSystem.ProjectLetters then
        for _, letter in pairs(self.WaveSystem.ProjectLetters) do
            if letter.Label then
                letter.Label.TextColor3 = color
            end
        end
    end
    
    self._ColorUpdateInProgress = false
end

function Library:SetWatermarkGeneralColor(color)
    if self._ColorUpdateInProgress then return end
    self._ColorUpdateInProgress = true
    
    self.WatermarkGeneralColor = color
    
    -- Применяем ко всем элементам кроме Project Name
    if self.WaveSystem then
        -- Никнейм
        if self.WaveSystem.NicknameLetters then
            for _, letter in pairs(self.WaveSystem.NicknameLetters) do
                if letter.Label then
                    letter.Label.TextColor3 = color
                end
            end
        end
        
        -- FPS текст (не цифры)
        if self.WaveSystem.FPSLetters then
            for _, letter in pairs(self.WaveSystem.FPSLetters) do
                if letter.Label and not letter.IsDigit then
                    letter.Label.TextColor3 = color
                end
            end
        end
        
        -- Пинг текст (не цифры)
        if self.WaveSystem.PingLetters then
            for _, letter in pairs(self.WaveSystem.PingLetters) do
                if letter.Label and not letter.IsDigit then
                    letter.Label.TextColor3 = color
                end
            end
        end
        
        -- Время
        if self.WaveSystem.TimeLetters then
            for _, letter in pairs(self.WaveSystem.TimeLetters) do
                if letter.Label then
                    letter.Label.TextColor3 = color
                end
            end
        end
        
        -- Кейбинды заголовок
        if self.WaveSystem.KeybindHeaderLetters then
            for _, letter in pairs(self.WaveSystem.KeybindHeaderLetters) do
                if letter.Label then
                    letter.Label.TextColor3 = color
                end
            end
        end
        
        -- Кейбинды элементы
        for _, item in pairs(self.WaveSystem.KeybindItems or {}) do
            if item.NameLabel then
                item.NameLabel.TextColor3 = color
            end
            if item.KeyLabel then
                item.KeyLabel.TextColor3 = color
            end
        end
        
        -- Разделители
        if self.WaveSystem.Container then
            for _, child in pairs(self.WaveSystem.Container:GetChildren()) do
                if child:IsA("TextLabel") and child.Text == "|" then
                    child.TextColor3 = color
                end
            end
        end
        
        -- Иконки
        if self.WaveSystem.IconLabel then
            self.WaveSystem.IconLabel.TextColor3 = color
        end
        if self.WaveSystem.PaletteIcon then
            if self.WaveSystem.PaletteIcon.ClassName == "ImageLabel" then
                self.WaveSystem.PaletteIcon.ImageColor3 = color
            else
                self.WaveSystem.PaletteIcon.TextColor3 = color
            end
        end
    end
    
    self._ColorUpdateInProgress = false
end


function Library:SetWatermarkTheme(themeName)
    if self._ColorUpdateInProgress then return end
    self._ColorUpdateInProgress = true
    
    if themeName == "purple" then
        self.WatermarkProjectColor = Color3.fromRGB(180, 100, 220)
        self.WatermarkGeneralColor = Color3.fromRGB(255, 255, 255)
    elseif themeName == "blue" then
        self.WatermarkProjectColor = Color3.fromRGB(100, 150, 255)
        self.WatermarkGeneralColor = Color3.fromRGB(255, 255, 255)
    elseif themeName == "green" then
        self.WatermarkProjectColor = Color3.fromRGB(100, 220, 150)
        self.WatermarkGeneralColor = Color3.fromRGB(255, 255, 255)
    elseif themeName == "red" then
        self.WatermarkProjectColor = Color3.fromRGB(255, 100, 120)
        self.WatermarkGeneralColor = Color3.fromRGB(255, 255, 255)
    elseif themeName == "accent" then
        self.WatermarkProjectColor = self.AccentColor
        self.WatermarkGeneralColor = Color3.fromRGB(255, 255, 255)
    end
    
    -- Применяем цвета без вызова функций (избегаем циклов)
    if self.WaveSystem then
        if self.WaveSystem.ProjectLetters then
            for _, letter in pairs(self.WaveSystem.ProjectLetters) do
                if letter.Label then
                    letter.Label.TextColor3 = self.WatermarkProjectColor
                end
            end
        end
        -- Применяем общий цвет ко всем остальным элементам
        self:SetWatermarkGeneralColor(self.WatermarkGeneralColor)
    end
    
    self._ColorUpdateInProgress = false
end

function Library:GetPingColor(ping)
    if ping < 100 then
        return self.WatermarkPingGoodColor
    elseif ping < 200 then
        return self.WatermarkPingMediumColor
    else
        return self.WatermarkPingBadColor
    end
end
-- ============================================
-- СИСТЕМА ИКОНОК LUCIDE
-- ============================================

local FetchIcons, Icons = pcall(function()
    return (loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua")) :: () -> any)()
end)

function Library:GetIcon(IconName: string)
    if not FetchIcons then
        local IconMap = {
            ["palette"] = "🎨",
            ["eye"] = "👁️",
            ["target"] = "🎯",
            ["zap"] = "⚡",
            ["settings"] = "⚙️",
            ["shield"] = "🛡️",
            ["sword"] = "⚔️",
            ["heart"] = "❤️",
            ["star"] = "⭐",
            ["home"] = "🏠",
            ["user"] = "👤",
            ["key"] = "🔑",
            ["lock"] = "🔒",
            ["unlock"] = "🔓",
        }
        return IconMap[IconName] or "🔧"
    end
    
    local Success, Icon = pcall(Icons.GetAsset, IconName)
    if not Success then
        return nil
    end
    return Icon
end

function Library:GetCustomIcon(IconName: string)
    if string.match(IconName, "^rbxassetid://") or string.match(IconName, "^http") then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
            Custom = true,
        }
    else
        return Library:GetIcon(IconName)
    end
end

function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
    if typeof(Table) ~= "table" then
        return Template
    end
    
    for k, v in Template do
        if typeof(k) == "number" then
            continue
        end
        
        if typeof(v) == "table" then
            Table[k] = Library:Validate(Table[k], v)
        elseif Table[k] == nil then
            Table[k] = v
        end
    end
    
    return Table
end
-- ============================================
-- ВОЛНОВАЯ СИСТЕМА
-- ============================================

Library.WaveSystem = {
    -- Элементы
    Container = nil,
    IconLabel = nil,
    ProjectLetters = {},
    NicknameLetters = {},
    FPSLetters = {},
    PingLetters = {},
    TimeLetters = {},
    
    -- Кейбинды
    PaletteIcon = nil,
    HeaderSeparator = nil,
    KeybindHeaderLetters = {},
    KeybindItems = {},
    
    -- Волны
    ProjectWave = {pos = 0, speed = 0.08, width = 3, intensity = 0.2},
    NicknameWave = {pos = 0, speed = 0.07, width = 3.5, intensity = 0.18},
    FPSWave = {pos = 0, speed = 0.06, width = 2.5, intensity = 0.15},
    PingWave = {pos = 0, speed = 0.055, width = 2.5, intensity = 0.15},
    TimeWave = {pos = 0, speed = 0.045, width = 4, intensity = 0.12},
    KeybindHeaderWave = {pos = 0, speed = 0.065, width = 3, intensity = 0.18},
    
    -- Состояние
    IsAnimating = false,
    Connections = {},
    LastFPS = 0,
    LastPing = 0,
    LastTime = "",
    LastFPSText = "",
    LastPingText = "",
    LastTimeText = "",
    FrameCounter = 0,
    UpdateInterval = 60,
    LastUpdateTime = 0, -- Защита от частых обновлений
    
    -- Позиции
    FPSStartX = 0,
    PingStartX = 0,
    TimeStartX = 0,
}

-- ============================================
-- < Create other UI elements >
-- ============================================

do
    Library.NotificationArea = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 0, 0, 40);
        Size = UDim2.new(0, 300, 0, 200);
        ZIndex = 100;
        Parent = ScreenGui;
    });
    
    Library:Create('UIListLayout', {
        Padding = UDim.new(0, 4);
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = Library.NotificationArea;
    });
    
    -- ВАТЕРМАРК
    local WatermarkOuter = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 100, 0, -32);
        Size = UDim2.new(0, 600, 0, 30);
        ZIndex = 200;
        Visible = false;
        Parent = ScreenGui;
    });
    
    local WatermarkInner = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(8, 8, 12);
        BackgroundTransparency = 0.3;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 201;
        Parent = WatermarkOuter;
    });
    local WatermarkCorner = Library:Create('UICorner', {
        CornerRadius = UDim.new(0, 8);
        Parent = WatermarkInner;
    });
    
    local WatermarkGradient = Library:Create('UIGradient', {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.1, 0),
            NumberSequenceKeypoint.new(0.9, 0),
            NumberSequenceKeypoint.new(1, 0.2),
        });
        Parent = WatermarkInner;
    });
    
    Library.WaveSystem.Container = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 10, 0, 5);
        Size = UDim2.new(1, -20, 1, -10);
        ZIndex = 202;
        Parent = WatermarkInner;
    });
    
    Library.Watermark = WatermarkOuter;
    Library:MakeDraggable(Library.Watermark);
    
    -- КЕЙБИНДЫ
    local KeybindOuter = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 10, 0.5, 0);
        Size = UDim2.new(0, 200, 0, 30);
        Visible = false;
        ZIndex = 100;
        Parent = ScreenGui;
    });
    
    local KeybindInner = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(8, 8, 12);
        BackgroundTransparency = 0.3;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = KeybindOuter;
    });
    
    local KeybindCorner = Library:Create('UICorner', {
        CornerRadius = UDim.new(0, 8);
        Parent = KeybindInner;
    });
    
    local KeybindGradient = Library:Create('UIGradient', {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.1, 0),
            NumberSequenceKeypoint.new(0.9, 0),
            NumberSequenceKeypoint.new(1, 0.2),
        });
        Parent = KeybindInner;
    });
    
    local KeybindHeaderContainer = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 0, 0, 3);
        Size = UDim2.new(1, 0, 0, 18);
        ZIndex = 102;
        Parent = KeybindInner;
    });
    local KeybindContainer = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 8, 0, 23);
        Size = UDim2.new(1, -16, 1, -26);
        ZIndex = 102;
        Parent = KeybindInner;
    });
    
    Library:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 1.5);
        Parent = KeybindContainer;
    });
    
    Library.KeybindFrame = KeybindOuter;
    Library.KeybindContainer = KeybindContainer;
    Library.KeybindHeaderContainer = KeybindHeaderContainer;
    Library:MakeDraggable(KeybindOuter);
end;

-- ============================================
-- СОЗДАНИЕ ЭЛЕМЕНТОВ ВАТЕРМАРКА
-- ============================================

function Library.WaveSystem:CreateElements()
    for _, child in pairs(self.Container:GetChildren()) do
        child:Destroy()
    end
    
    local currentX = 0
    local spacing = 8
    local customFont = Enum.Font.GothamBold
    
    -- 1. ИКОНКА МОЛНИИ
    self.IconLabel = Library:CreateLabel({
        Position = UDim2.new(0, currentX, 0, 0);
        Size = UDim2.new(0, 18, 1, 0);
        Text = "⚡";
        TextSize = 15;
        TextColor3 = Library.WatermarkGeneralColor; -- ✨ ИЗ LIBRARY
        TextXAlignment = Enum.TextXAlignment.Center;
        Font = customFont;
        ZIndex = 203;
        Parent = self.Container;
    });
    currentX = currentX + 22
    
    -- 2. PROJECT RADIANT
    local projectName = "Project Radiant"
    self.ProjectLetters = {}
    for i = 1, #projectName do
        local char = projectName:sub(i, i)
        local letterFrame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, currentX, 0, 0);
            Size = UDim2.new(0, 9, 1, 0);
            ZIndex = 203;
            Parent = self.Container;
        });
        
        local letterLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            Text = char;
            TextSize = 14;
            TextColor3 = Library.WatermarkProjectColor; -- ✨ ИЗ LIBRARY
            TextXAlignment = Enum.TextXAlignment.Center;
            Font = customFont;
            ZIndex = 204;
            Parent = letterFrame;
        });
        
        self.ProjectLetters[i] = {
            Frame = letterFrame,
            Label = letterLabel,
            OriginalPos = currentX,
            OriginalSize = 9,
            Character = char,
        }
        currentX = currentX + 9
    end
    currentX = currentX + spacing * 2
    -- Разделитель 1
    Library:CreateLabel({
        Position = UDim2.new(0, currentX, 0, 0);
        Size = UDim2.new(0, 8, 1, 0);
        Text = "|";
        TextSize = 14;
        TextColor3 = Library.WatermarkSeparatorColor; -- ✨ ИЗ LIBRARY
        TextXAlignment = Enum.TextXAlignment.Center;
        Font = customFont;
        ZIndex = 203;
        Parent = self.Container;
    });
    currentX = currentX + 12
    
    -- 3. НИКНЕЙМ
    local playerName = Players.LocalPlayer.Name
    if #playerName > 12 then
        playerName = playerName:sub(1, 10) .. ".."
    end
    
    self.NicknameLetters = {}
    for i = 1, #playerName do
        local char = playerName:sub(i, i)
        local letterFrame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, currentX, 0, 0);
            Size = UDim2.new(0, 8, 1, 0);
            ZIndex = 203;
            Parent = self.Container;
        });
        
        local letterLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            Text = char;
            TextSize = 14;
            TextColor3 = Library.WatermarkGeneralColor; -- ✨ ИЗ LIBRARY
            TextXAlignment = Enum.TextXAlignment.Center;
            Font = customFont;
            ZIndex = 204;
            Parent = letterFrame;
        });
        
        self.NicknameLetters[i] = {
            Frame = letterFrame,
            Label = letterLabel,
            OriginalPos = currentX,
            OriginalSize = 8,
            Character = char,
        }
        currentX = currentX + 8
    end
    currentX = currentX + spacing * 2
    
    -- Разделитель 2
    Library:CreateLabel({
        Position = UDim2.new(0, currentX, 0, 0);
        Size = UDim2.new(0, 8, 1, 0);
        Text = "|";
        TextSize = 14;
        TextColor3 = Library.WatermarkSeparatorColor; -- ✨ ИЗ LIBRARY
        TextXAlignment = Enum.TextXAlignment.Center;
        Font = customFont;
        ZIndex = 203;
        Parent = self.Container;
    });
    currentX = currentX + 12
    
    -- 4. FPS
    self.FPSStartX = currentX
    self.FPSLetters = {}
    self:CreateFPSText("60 FPS")
    currentX = currentX + 50
    -- Разделитель 3
    Library:CreateLabel({
        Position = UDim2.new(0, currentX, 0, 0);
        Size = UDim2.new(0, 8, 1, 0);
        Text = "|";
        TextSize = 14;
        TextColor3 = Library.WatermarkSeparatorColor; -- ✨ ИЗ LIBRARY
        TextXAlignment = Enum.TextXAlignment.Center;
        Font = customFont;
        ZIndex = 203;
        Parent = self.Container;
    });
    currentX = currentX + 12
    
    -- 5. ПИНГ
    self.PingStartX = currentX
    self.PingLetters = {}
    self:CreatePingText("50 MS")
    currentX = currentX + 45
    
    -- Разделитель 4
    Library:CreateLabel({
        Position = UDim2.new(0, currentX, 0, 0);
        Size = UDim2.new(0, 8, 1, 0);
        Text = "|";
        TextSize = 14;
        TextColor3 = Library.WatermarkSeparatorColor; -- ✨ ИЗ LIBRARY
        TextXAlignment = Enum.TextXAlignment.Center;
        Font = customFont;
        ZIndex = 203;
        Parent = self.Container;
    });
    currentX = currentX + 12
    
    -- 6. ВРЕМЯ
    self.TimeStartX = currentX
    self.TimeLetters = {}
    self:CreateTimeText("00:00:00")
    currentX = currentX + 70
    
    Library.Watermark.Size = UDim2.new(0, math.max(currentX + 20, 400), 0, 30)
end

-- ============================================
-- СОЗДАНИЕ FPS ТЕКСТА
-- ============================================

function Library.WaveSystem:CreateFPSText(text)
    if self.LastFPSText == text and #self.FPSLetters > 0 then
        return
    end
    self.LastFPSText = text
    
    for _, letter in pairs(self.FPSLetters) do
        if letter.Frame then letter.Frame:Destroy() end
    end
    self.FPSLetters = {}
    
    local currentX = self.FPSStartX
    local customFont = Enum.Font.GothamBold
    
    for i = 1, #text do
        local char = text:sub(i, i)
        local isDigit = tonumber(char) ~= nil
        
        local letterFrame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, currentX, 0, 0);
            Size = UDim2.new(0, 7, 1, 0);
            ZIndex = 203;
            Parent = self.Container;
        });
        local letterLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            Text = char;
            TextSize = 14;
            -- ✨ ИСПОЛЬЗУЕМ ЦВЕТА ИЗ LIBRARY
            TextColor3 = isDigit and Library.WatermarkFPSColor or Library.WatermarkFPSTextColor;
            TextXAlignment = Enum.TextXAlignment.Center;
            Font = customFont;
            ZIndex = 204;
            Parent = letterFrame;
        });
        
        self.FPSLetters[i] = {
            Frame = letterFrame,
            Label = letterLabel,
            OriginalPos = currentX,
            OriginalSize = 7,
            Character = char,
            IsDigit = isDigit,
        }
        currentX = currentX + 7
    end
end

-- ============================================
-- СОЗДАНИЕ ПИНГ ТЕКСТА
-- ============================================

function Library.WaveSystem:CreatePingText(text, pingValue)
    if self.LastPingText == text and #self.PingLetters > 0 then
        if pingValue then
            local pingColor = Library:GetPingColor(pingValue)
            for _, letter in pairs(self.PingLetters) do
                if letter.IsDigit and letter.Label then
                    letter.BaseColor = pingColor
                    letter.Label.TextColor3 = pingColor
                end
            end
        end
        return
    end
    self.LastPingText = text
    
    for _, letter in pairs(self.PingLetters) do
        if letter.Frame then letter.Frame:Destroy() end
    end
    self.PingLetters = {}
    
    local currentX = self.PingStartX
    local customFont = Enum.Font.GothamBold
    
    local pingColor = Library.WatermarkPingGoodColor
    if pingValue then
        pingColor = Library:GetPingColor(pingValue)
    end
    
    for i = 1, #text do
        local char = text:sub(i, i)
        local isDigit = tonumber(char) ~= nil
        
        local letterFrame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, currentX, 0, 0);
            Size = UDim2.new(0, 7, 1, 0);
            ZIndex = 203;
            Parent = self.Container;
        });
        
        local letterLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            Text = char;
            TextSize = 14;
            -- ✨ ИСПОЛЬЗУЕМ ЦВЕТА ИЗ LIBRARY
            TextColor3 = isDigit and pingColor or Library.WatermarkPingTextColor;
            TextXAlignment = Enum.TextXAlignment.Center;
            Font = customFont;
            ZIndex = 204;
            Parent = letterFrame;
        });
        self.PingLetters[i] = {
            Frame = letterFrame,
            Label = letterLabel,
            OriginalPos = currentX,
            OriginalSize = 7,
            Character = char,
            IsDigit = isDigit,
            BaseColor = pingColor,
        }
        currentX = currentX + 7
    end
end

-- ============================================
-- СОЗДАНИЕ ВРЕМЯ ТЕКСТА
-- ============================================

function Library.WaveSystem:CreateTimeText(text)
    if self.LastTimeText == text and #self.TimeLetters > 0 then
        return
    end
    self.LastTimeText = text
    
    for _, letter in pairs(self.TimeLetters) do
        if letter.Frame then letter.Frame:Destroy() end
    end
    self.TimeLetters = {}
    
    local currentX = self.TimeStartX
    local customFont = Enum.Font.GothamBold
    
    for i = 1, #text do
        local char = text:sub(i, i)
        
        local letterFrame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, currentX, 0, 0);
            Size = UDim2.new(0, 8, 1, 0);
            ZIndex = 203;
            Parent = self.Container;
        });
        
        local letterLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            Text = char;
            TextSize = 14;
            TextColor3 = Library.WatermarkTimeColor; -- ✨ ИЗ LIBRARY
            TextXAlignment = Enum.TextXAlignment.Center;
            Font = customFont;
            ZIndex = 204;
            Parent = letterFrame;
        });
        
        self.TimeLetters[i] = {
            Frame = letterFrame,
            Label = letterLabel,
            OriginalPos = currentX,
            OriginalSize = 8,
            Character = char,
        }
        currentX = currentX + 8
    end
end

-- ============================================
-- СОЗДАНИЕ ЗАГОЛОВКА КЕЙБИНДОВ
-- ============================================

function Library.WaveSystem:CreateKeybindHeader()
    for _, child in pairs(Library.KeybindHeaderContainer:GetChildren()) do
        child:Destroy()
    end
    
    local currentX = 8
    local customFont = Enum.Font.GothamBold
    -- 1. ИКОНКА PALETTE
    local paletteIconData = Library:GetIcon("palette")
    if type(paletteIconData) == "table" and paletteIconData.Url then
        self.PaletteIcon = Library:Create('ImageLabel', {
            Position = UDim2.new(0, currentX, 0, 2);
            Size = UDim2.new(0, 16, 0, 16);
            Image = paletteIconData.Url;
            ImageRectOffset = paletteIconData.ImageRectOffset;
            ImageRectSize = paletteIconData.ImageRectSize;
            ImageColor3 = Library.KeybindIconColor; -- ✨ ИЗ LIBRARY
            BackgroundTransparency = 1;
            ZIndex = 103;
            Parent = Library.KeybindHeaderContainer;
        });
    else
        self.PaletteIcon = Library:CreateLabel({
            Position = UDim2.new(0, currentX, 0, 0);
            Size = UDim2.new(0, 16, 1, 0);
            Text = type(paletteIconData) == "string" and paletteIconData or "🎨";
            TextSize = 14;
            TextColor3 = Library.KeybindIconColor; -- ✨ ИЗ LIBRARY
            TextXAlignment = Enum.TextXAlignment.Center;
            Font = customFont;
            ZIndex = 103;
            Parent = Library.KeybindHeaderContainer;
        });
    end
    currentX = currentX + 20
    
    -- 2. РАЗДЕЛИТЕЛЬ
    self.HeaderSeparator = Library:CreateLabel({
        Position = UDim2.new(0, currentX, 0, 0);
        Size = UDim2.new(0, 8, 1, 0);
        Text = "|";
        TextSize = 14;
        TextColor3 = Library.KeybindSeparatorColor; -- ✨ ИЗ LIBRARY
        TextXAlignment = Enum.TextXAlignment.Center;
        Font = customFont;
        ZIndex = 103;
        Parent = Library.KeybindHeaderContainer;
    });
    currentX = currentX + 12
    
    -- 3. "KEYBINDS"
    local headerText = "Keybinds"
    self.KeybindHeaderLetters = {}
    local containerWidth = Library.KeybindHeaderContainer.AbsoluteSize.X or 180
    local remainingWidth = containerWidth - currentX - 8
    local letterWidth = 9
    local textWidth = #headerText * letterWidth
    local textStartX = currentX + (remainingWidth - textWidth) / 2
    
    for i = 1, #headerText do
        local char = headerText:sub(i, i)
        
        local letterFrame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, textStartX + (i-1) * letterWidth, 0, 0);
            Size = UDim2.new(0, letterWidth, 1, 0);
            ZIndex = 103;
            Parent = Library.KeybindHeaderContainer;
        });
        
        local letterLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            Text = char;
            TextSize = 14;
            TextColor3 = Library.KeybindHeaderColor; -- ✨ ИЗ LIBRARY
            TextXAlignment = Enum.TextXAlignment.Center;
            Font = customFont;
            ZIndex = 104;
            Parent = letterFrame;
        });
        self.KeybindHeaderLetters[i] = {
            Frame = letterFrame,
            Label = letterLabel,
            OriginalPos = textStartX + (i-1) * letterWidth,
            OriginalSize = letterWidth,
            Character = char,
        }
    end
end

-- ============================================
-- ПРИМЕНЕНИЕ ВОЛНЫ
-- ============================================

function Library.WaveSystem:ApplyWave(letters, wave, waveColor, normalColor)
    for i, letter in pairs(letters) do
        if not letter.Frame or not letter.Frame.Parent or not letter.Label or not letter.Label.Parent then
            continue
        end
        
        local distance = math.abs(i - wave.pos)
        local intensity = math.max(0, 1 - (distance / wave.width))
        
        if intensity > 0.05 then
            local scale = 1 + (intensity * 0.5)
            local shake = math.sin(tick() * 20) * intensity * 7
            
            local glowIntensity = intensity * 255
            local glowColor = Color3.fromRGB(
                math.min(255, normalColor.R * 255 + glowIntensity),
                math.min(255, normalColor.G * 255 + glowIntensity),
                math.min(255, normalColor.B * 255 + glowIntensity)
            )
            
            TweenService:Create(letter.Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, letter.OriginalSize * scale, 1, 0),
                Position = UDim2.new(0, letter.OriginalPos, 0, 0),
                Rotation = shake,
            }):Play()
            
            TweenService:Create(letter.Label, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                TextColor3 = glowColor,
                Rotation = shake,
                TextStrokeTransparency = 0.5,
                TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
            }):Play()
        else
            TweenService:Create(letter.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, letter.OriginalSize, 1, 0),
                Position = UDim2.new(0, letter.OriginalPos, 0, 0),
                Rotation = 0,
            }):Play()
            
            TweenService:Create(letter.Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                TextColor3 = normalColor,
                Rotation = 0,
                TextStrokeTransparency = 1,
            }):Play()
        end
    end
end

function Library.WaveSystem:ApplyWaveWithColors(letters, wave)
    for i, letter in pairs(letters) do
        if not letter.Frame or not letter.Frame.Parent or not letter.Label or not letter.Label.Parent then
            continue
        end
        
        local distance = math.abs(i - wave.pos)
        local intensity = math.max(0, 1 - (distance / wave.width))
        
        local waveColor, normalColor
        if letter.IsDigit then
            normalColor = letter.BaseColor or Library.WatermarkFPSColor
            waveColor = Color3.fromRGB(
                math.min(255, normalColor.R * 255 + 100),
                math.min(255, normalColor.G * 255 + 100),
                math.min(255, normalColor.B * 255 + 100)
            )
        else
            waveColor = Color3.fromRGB(180, 180, 180)
            normalColor = Library.WatermarkFPSTextColor
        end
        if intensity > 0.05 then
            local scale = 1 + (intensity * 0.5)
            local shake = math.sin(tick() * 20) * intensity * 7
            
            local glowIntensity = intensity * 255
            local glowColor = Color3.fromRGB(
                math.min(255, normalColor.R * 255 + glowIntensity),
                math.min(255, normalColor.G * 255 + glowIntensity),
                math.min(255, normalColor.B * 255 + glowIntensity)
            )
            
            TweenService:Create(letter.Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, letter.OriginalSize * scale, 1, 0),
                Position = UDim2.new(0, letter.OriginalPos, 0, 0),
                Rotation = shake,
            }):Play()
            
            TweenService:Create(letter.Label, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                TextColor3 = glowColor,
                Rotation = shake,
                TextStrokeTransparency = 0.5,
                TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
            }):Play()
        else
            TweenService:Create(letter.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, letter.OriginalSize, 1, 0),
                Position = UDim2.new(0, letter.OriginalPos, 0, 0),
                Rotation = 0,
            }):Play()
            
            TweenService:Create(letter.Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                TextColor3 = normalColor,
                Rotation = 0,
                TextStrokeTransparency = 1,
            }):Play()
        end
    end
end

-- ============================================
-- ОБНОВЛЕНИЕ ВОЛН
-- ============================================

function Library.WaveSystem:UpdateWaves()
    if not self.IsAnimating then return end
    
    if not self.Container or not self.Container.Parent then
        return
    end
    
    -- Защита от слишком частых обновлений
    local currentTime = tick()
    if self.LastUpdateTime and (currentTime - self.LastUpdateTime) < 0.016 then -- ~60 FPS
        return
    end
    self.LastUpdateTime = currentTime
    
    self.FrameCounter = self.FrameCounter + 1
    
    -- Обновляем позиции волн
    self.ProjectWave.pos = self.ProjectWave.pos + self.ProjectWave.speed
    self.NicknameWave.pos = self.NicknameWave.pos + self.NicknameWave.speed
    self.FPSWave.pos = self.FPSWave.pos + self.FPSWave.speed
    self.PingWave.pos = self.PingWave.pos + self.PingWave.speed
    self.TimeWave.pos = self.TimeWave.pos + self.TimeWave.speed
    self.KeybindHeaderWave.pos = self.KeybindHeaderWave.pos + self.KeybindHeaderWave.speed
    
    -- Сброс волн
    local resetBuffer = 4
    if self.ProjectWave.pos > #self.ProjectLetters + resetBuffer then
        self.ProjectWave.pos = -resetBuffer
    end
    if self.NicknameWave.pos > #self.NicknameLetters + resetBuffer then
        self.NicknameWave.pos = -resetBuffer
    end
    if self.FPSWave.pos > #self.FPSLetters + resetBuffer then
        self.FPSWave.pos = -resetBuffer
    end
    if self.PingWave.pos > #self.PingLetters + resetBuffer then
        self.PingWave.pos = -resetBuffer
    end
    if self.TimeWave.pos > #self.TimeLetters + resetBuffer then
        self.TimeWave.pos = -resetBuffer
    end
    if self.KeybindHeaderWave.pos > #self.KeybindHeaderLetters + resetBuffer then
        self.KeybindHeaderWave.pos = -resetBuffer
    end
    -- ✨ ПРИМЕНЯЕМ ВОЛНЫ С ЦВЕТАМИ ИЗ LIBRARY (с защитой от ошибок)
    pcall(function()
        if #self.ProjectLetters > 0 then
            self:ApplyWave(self.ProjectLetters, self.ProjectWave, 
                Color3.fromRGB(220, 150, 255), Library.WatermarkProjectColor)
        end
    end)
    
    pcall(function()
        if #self.NicknameLetters > 0 then
            self:ApplyWave(self.NicknameLetters, self.NicknameWave, 
                Color3.fromRGB(220, 220, 220), Library.WatermarkNicknameColor)
        end
    end)
    
    pcall(function()
        if #self.FPSLetters > 0 then
            self:ApplyWaveWithColors(self.FPSLetters, self.FPSWave)
        end
    end)
    
    pcall(function()
        if #self.PingLetters > 0 then
            self:ApplyWaveWithColors(self.PingLetters, self.PingWave)
        end
    end)
    
    pcall(function()
        if #self.TimeLetters > 0 then
            self:ApplyWave(self.TimeLetters, self.TimeWave, 
                Color3.fromRGB(160, 160, 160), Library.WatermarkTimeColor)
        end
    end)
    
    pcall(function()
        if #self.KeybindHeaderLetters > 0 then
            self:ApplyWave(self.KeybindHeaderLetters, self.KeybindHeaderWave, 
                Color3.fromRGB(255, 255, 255), Library.KeybindHeaderColor)
        end
    end)
    
    -- Волны на ON/OFF в кейбиндах (с защитой от ошибок)
    pcall(function()
        for _, item in pairs(self.KeybindItems) do
            if item.StateLetters and item.Frame and item.Frame.Parent then
                local stateWave = {pos = self.KeybindHeaderWave.pos, speed = 0.065, width = 2, intensity = 0.15}
                local waveColor = item.State and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
                local normalColor = item.State and Library.KeybindStateOnColor or Library.KeybindStateOffColor
                self:ApplyWave(item.StateLetters, stateWave, waveColor, normalColor)
            end
        end
    end)
    
    -- Анимация иконки palette (с защитой от ошибок)
    pcall(function()
        if self.PaletteIcon and self.PaletteIcon.Parent then
            local pulse = math.sin(tick() * 2) * 0.1 + 1
            if self.PaletteIcon.ClassName == "ImageLabel" then
                local colorIntensity = math.sin(tick() * 1.5) * 0.3 + 0.7
                TweenService:Create(self.PaletteIcon, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                    Size = UDim2.new(0, 16 * pulse, 0, 16 * pulse),
                    ImageColor3 = Color3.fromRGB(
                        Library.KeybindIconColor.R * 255 * colorIntensity,
                        Library.KeybindIconColor.G * 255 * colorIntensity,
                        Library.KeybindIconColor.B * 255
                    ),
                }):Play()
            else
                self.PaletteIcon.TextSize = 14 * pulse
            end
        end
    end)
    
    -- Обновляем статистику
    if self.FrameCounter % self.UpdateInterval == 0 then
        self:UpdateStats()
    end
end

-- ============================================
-- ОБНОВЛЕНИЕ СТАТИСТИКИ
-- ============================================

function Library.WaveSystem:UpdateStats()
    -- FPS
    local currentFPS = math.floor(workspace:GetRealPhysicsFPS())
    if currentFPS ~= self.LastFPS then
        self.LastFPS = currentFPS
        self:CreateFPSText(tostring(currentFPS) .. " FPS")
    end
    
    -- Пинг с цветовой индикацией
    local success, currentPing = pcall(function()
        return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    
    if success and currentPing ~= self.LastPing then
        self.LastPing = currentPing
        -- ✨ ПЕРЕДАЕМ ЗНАЧЕНИЕ ПИНГА ДЛЯ ПРАВИЛЬНОГО ЦВЕТА
        self:CreatePingText(tostring(currentPing) .. " MS", currentPing)
    end
    -- Время
    local gameTime = math.floor(workspace.DistributedGameTime)
    local hours = math.floor(gameTime / 3600)
    local minutes = math.floor((gameTime % 3600) / 60)
    local seconds = gameTime % 60
    local currentTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    
    if currentTime ~= self.LastTime then
        self.LastTime = currentTime
        self:CreateTimeText(currentTime)
    end
end

-- ============================================
-- СОЗДАНИЕ КЕЙБИНДА
-- ============================================

function Library.WaveSystem:CreateKeybindItem(name, key, state, iconName)
    local keybindFrame = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 0, 15);
        ZIndex = 103;
        Parent = Library.KeybindContainer;
    });
    
    local customFont = Enum.Font.GothamBold
    local iconLabel = nil
    local nameStartX = 0
    
    if iconName then
        local iconData = Library:GetIcon(iconName)
        if type(iconData) == "table" and iconData.Url then
            iconLabel = Library:Create('ImageLabel', {
                Position = UDim2.new(0, 0, 0, 1);
                Size = UDim2.new(0, 12, 0, 12);
                Image = iconData.Url;
                ImageRectOffset = iconData.ImageRectOffset;
                ImageRectSize = iconData.ImageRectSize;
                ImageColor3 = Color3.fromRGB(120, 120, 120);
                BackgroundTransparency = 1;
                ZIndex = 104;
                Parent = keybindFrame;
            });
        else
            iconLabel = Library:CreateLabel({
                Position = UDim2.new(0, 0, 0, 0);
                Size = UDim2.new(0, 12, 1, 0);
                Text = type(iconData) == "string" and iconData or "🔧";
                TextSize = 10;
                TextColor3 = Color3.fromRGB(120, 120, 120);
                TextXAlignment = Enum.TextXAlignment.Center;
                Font = customFont;
                ZIndex = 104;
                Parent = keybindFrame;
            });
        end
        nameStartX = 16
    end
    
    local containerWidth = 180
    local availableWidth = containerWidth - nameStartX
    
    -- Название кейбинда
    local nameLabel = Library:CreateLabel({
        Position = UDim2.new(0, nameStartX, 0, 0);
        Size = UDim2.new(0, availableWidth * 0.4, 1, 0);
        Text = name;
        TextSize = 10;
        TextColor3 = Library.KeybindNameColor; -- ✨ ИЗ LIBRARY
        TextXAlignment = Enum.TextXAlignment.Left;
        Font = customFont;
        ZIndex = 104;
        Parent = keybindFrame;
    });
    
    -- Клавиша
    local keyLabel = Library:CreateLabel({
        Position = UDim2.new(0, nameStartX + availableWidth * 0.55, 0, 0);
        Size = UDim2.new(0, availableWidth * 0.2, 1, 0);
        Text = key;
        TextSize = 9;
        TextColor3 = Library.KeybindKeyColor; -- ✨ ИЗ LIBRARY
        TextXAlignment = Enum.TextXAlignment.Center;
        Font = customFont;
        ZIndex = 104;
        Parent = keybindFrame;
    });
    -- ON/OFF состояние
    local stateText = state and "ON" or "OFF"
    local stateLetters = {}
    local stateStartX = nameStartX + availableWidth * 0.85
    
    for i = 1, #stateText do
        local char = stateText:sub(i, i)
        local letterFrame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, stateStartX + (i-1) * 8, 0, 0);
            Size = UDim2.new(0, 8, 1, 0);
            ZIndex = 104;
            Parent = keybindFrame;
        });
        
        local letterLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            Text = char;
            TextSize = 10;
            -- ✨ ИСПОЛЬЗУЕМ ЦВЕТА ИЗ LIBRARY
            TextColor3 = state and Library.KeybindStateOnColor or Library.KeybindStateOffColor;
            TextXAlignment = Enum.TextXAlignment.Center;
            Font = customFont;
            ZIndex = 105;
            Parent = letterFrame;
        });
        
        stateLetters[i] = {
            Frame = letterFrame,
            Label = letterLabel,
            OriginalPos = stateStartX + (i-1) * 8,
            OriginalSize = 8,
            Character = char,
        }
    end
    
    table.insert(self.KeybindItems, {
        Frame = keybindFrame,
        IconLabel = iconLabel,
        NameLabel = nameLabel,
        KeyLabel = keyLabel,
        StateLetters = stateLetters,
        Name = name,
        Key = key,
        State = state,
        Icon = iconName,
    })
    
    self:UpdateKeybindVisibility()
    return keybindFrame
end

-- ============================================
-- ОБНОВЛЕНИЕ РАЗМЕРА КЕЙБИНДОВ
-- ============================================

function Library.WaveSystem:UpdateKeybindVisibility()
    local keybindCount = #self.KeybindItems
    if keybindCount > 0 then
        local newHeight = 26 + (keybindCount * 16.5)
        
        TweenService:Create(Library.KeybindFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, newHeight)
        }):Play()
        
        for i, item in ipairs(self.KeybindItems) do
            if item.IconLabel then
                if item.IconLabel.ClassName == "ImageLabel" then
                    item.IconLabel.ImageTransparency = 1
                else
                    item.IconLabel.TextTransparency = 1
                end
            end
            item.NameLabel.TextTransparency = 1
            item.KeyLabel.TextTransparency = 1
            for _, letter in pairs(item.StateLetters) do
                letter.Label.TextTransparency = 1
            end
            
            task.delay(i * 0.05, function()
                if item.IconLabel then
                    if item.IconLabel.ClassName == "ImageLabel" then
                        TweenService:Create(item.IconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 0
                        }):Play()
                    else
                        TweenService:Create(item.IconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextTransparency = 0
                        }):Play()
                    end
                end
                TweenService:Create(item.NameLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0
                }):Play()
                TweenService:Create(item.KeyLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0
                }):Play()
                for _, letter in pairs(item.StateLetters) do
                    TweenService:Create(letter.Label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0
                    }):Play()
                end
            end)
        end
    else
        TweenService:Create(Library.KeybindFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 200, 0, 24)
        }):Play()
    end
end
-- ============================================
-- ЗАПУСК И ОСТАНОВКА
-- ============================================

function Library.WaveSystem:Start()
    if self.IsAnimating then return end
    
    self:CreateElements()
    self:CreateKeybindHeader()
    self.IsAnimating = true
    self.FrameCounter = 0
    
    self.Connections.Wave = RunService.Heartbeat:Connect(function()
        self:UpdateWaves()
    end)
    
    print("🌊 Волновая система запущена!")
end

function Library.WaveSystem:Stop()
    self.IsAnimating = false
    for _, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    self.Connections = {}
end

-- ============================================
-- ФУНКЦИИ LIBRARY
-- ============================================

function Library:SetWatermarkVisibility(Bool)
    if Library.Watermark then
        if Bool then
            Library.Watermark.Visible = true;
            Library.Watermark.Size = UDim2.new(0, 50, 0, 30)
            Library.Watermark.Position = UDim2.new(0, 100 + 200, 0, -32)
            
            TweenService:Create(Library.Watermark, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 30),
                Position = UDim2.new(0, 100, 0, -32)
            }):Play()
            
            Library.WaveSystem:Start()
        else
            TweenService:Create(Library.Watermark, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 50, 0, 30),
                Position = UDim2.new(0, 100 + 200, 0, -32)
            }):Play()
            
            task.delay(0.4, function()
                Library.Watermark.Visible = false;
            end)
            
            Library.WaveSystem:Stop()
        end
    end
end;

function Library:SetWatermark(Text, EnableWave)
    if EnableWave ~= false then
        Library.WaveSystem:Start()
        Library:SetWatermarkVisibility(true)
    else
        if Library.Watermark then
            Library.Watermark.Visible = true
        end
    end
end;

function Library:SetKeybindVisibility(Bool)
    if Library.KeybindFrame then
        if Bool then
            Library.KeybindFrame.Visible = true;
            Library.KeybindFrame.Size = UDim2.new(0, 50, 0, 10)
            
            for _, child in pairs(Library.KeybindFrame:GetDescendants()) do
                if child:IsA("TextLabel") then
                    child.TextTransparency = 1
                elseif child:IsA("ImageLabel") then
                    child.ImageTransparency = 1
                end
            end
            
            TweenService:Create(Library.KeybindFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 200, 0, 24)
            }):Play()
            
            task.delay(0.2, function()
                for _, child in pairs(Library.KeybindFrame:GetDescendants()) do
                    if child:IsA("TextLabel") then
                        TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            TextTransparency = 0
                        }):Play()
                    elseif child:IsA("ImageLabel") then
                        TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            ImageTransparency = 0
                        }):Play()
                    end
                end
            end)
            
            Library.WaveSystem:CreateKeybindHeader()
            Library.WaveSystem:UpdateKeybindVisibility()
        else
            for _, child in pairs(Library.KeybindFrame:GetDescendants()) do
                if child:IsA("TextLabel") then
                    TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        TextTransparency = 1
                    }):Play()
                elseif child:IsA("ImageLabel") then
                    TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        ImageTransparency = 1
                    }):Play()
                end
            end
            
            task.delay(0.2, function()
                TweenService:Create(Library.KeybindFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 50, 0, 10)
                }):Play()
            end)
            
            task.delay(0.5, function()
                Library.KeybindFrame.Visible = false;
            end)
        end
    end
end;
function Library:AddKeybind(name, key, state, iconName)
    return Library.WaveSystem:CreateKeybindItem(name, key, state, iconName)
end;

function Library:RemoveKeybind(name)
    for i, item in ipairs(Library.WaveSystem.KeybindItems) do
        if item.Name == name then
            item.Frame:Destroy()
            table.remove(Library.WaveSystem.KeybindItems, i)
            Library.WaveSystem:UpdateKeybindVisibility()
            break
        end
    end
end;

function Library:UpdateKeybindState(name, state)
    for _, item in ipairs(Library.WaveSystem.KeybindItems) do
        if item.Name == name then
            local oldState = item.State
            item.State = state
            
            -- Пересоздаем буквы ON/OFF
            for _, letter in pairs(item.StateLetters) do
                letter.Frame:Destroy()
            end
            
            local stateText = state and "ON" or "OFF"
            local stateLetters = {}
            local containerWidth = 180
            local availableWidth = containerWidth - (item.Icon and 16 or 0)
            local stateStartX = (item.Icon and 16 or 0) + availableWidth * 0.85
            
            for i = 1, #stateText do
                local char = stateText:sub(i, i)
                local letterFrame = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, stateStartX + (i-1) * 8, 0, 0);
                    Size = UDim2.new(0, 8, 1, 0);
                    ZIndex = 104;
                    Parent = item.Frame;
                });
                
                local letterLabel = Library:CreateLabel({
                    Size = UDim2.new(1, 0, 1, 0);
                    Text = char;
                    TextSize = 10;
                    -- ✨ ИСПОЛЬЗУЕМ ЦВЕТА ИЗ LIBRARY
                    TextColor3 = state and Library.KeybindStateOnColor or Library.KeybindStateOffColor;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    Font = Enum.Font.GothamBold;
                    ZIndex = 105;
                    Parent = letterFrame;
                });
                
                stateLetters[i] = {
                    Frame = letterFrame,
                    Label = letterLabel,
                    OriginalPos = stateStartX + (i-1) * 8,
                    OriginalSize = 8,
                    Character = char,
                }
            end
            
            item.StateLetters = stateLetters
            
            -- Анимация подсветки при изменении состояния
            if oldState ~= state then
                local highlightColor = state and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
                local normalColor = Library.KeybindNameColor
                
                TweenService:Create(item.NameLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextColor3 = highlightColor,
                    TextSize = 11,
                }):Play()
                
                TweenService:Create(item.KeyLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextColor3 = highlightColor,
                    TextSize = 10,
                }):Play()
                
                task.delay(0.5, function()
                    TweenService:Create(item.NameLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextColor3 = normalColor,
                        TextSize = 10,
                    }):Play()
                    TweenService:Create(item.KeyLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextColor3 = Library.KeybindKeyColor,
                        TextSize = 9,
                    }):Play()
                end)
                
                if item.IconLabel then
                    if item.IconLabel.ClassName == "ImageLabel" then
                        TweenService:Create(item.IconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageColor3 = highlightColor,
                            Size = UDim2.new(0, 14, 0, 14),
                        }):Play()
                        task.delay(0.5, function()
                            TweenService:Create(item.IconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                ImageColor3 = Color3.fromRGB(120, 120, 120),
                                Size = UDim2.new(0, 12, 0, 12),
                            }):Play()
                        end)
                    else
                        TweenService:Create(item.IconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextColor3 = highlightColor,
                            TextSize = 11,
                        }):Play()
                        task.delay(0.5, function()
                            TweenService:Create(item.IconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                TextColor3 = Color3.fromRGB(120, 120, 120),
                                TextSize = 10,
                            }):Play()
                        end)
                    end
                end
            end
            break
        end
    end
end;
-- ============================================
-- УВЕДОМЛЕНИЯ
-- ============================================

function Library:Notify(Text, Time)
    local XSize, YSize = Library:GetTextBounds(Text, Library.Font, 14);
    YSize = YSize + 7
    
    local NotifyOuter = Library:Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 100, 0, 10);
        Size = UDim2.new(0, 0, 0, YSize);
        ClipsDescendants = true;
        ZIndex = 100;
        Parent = Library.NotificationArea;
    });
    
    local NotifyInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = NotifyOuter;
    });
    
    Library:AddToRegistry(NotifyInner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    }, true);
    
    local InnerFrame = Library:Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 102;
        Parent = NotifyInner;
    });
    
    local Gradient = Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
            ColorSequenceKeypoint.new(1, Library.MainColor),
        });
        Rotation = -90;
        Parent = InnerFrame;
    });
    
    Library:AddToRegistry(Gradient, {
        Color = function()
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            });
        end
    });
    
    local NotifyLabel = Library:CreateLabel({
        Position = UDim2.new(0, 4, 0, 0);
        Size = UDim2.new(1, -4, 1, 0);
        Text = Text;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 103;
        Parent = InnerFrame;
    });
    
    local LeftColor = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = UDim2.new(0, -1, 0, -1);
        Size = UDim2.new(0, 3, 1, 2);
        ZIndex = 104;
        Parent = NotifyOuter;
    });
    
    Library:AddToRegistry(LeftColor, {
        BackgroundColor3 = 'AccentColor';
    }, true);
    
    pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.4, true);
    
    task.spawn(function()
        wait(Time or 5);
        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);
        wait(0.4);
        NotifyOuter:Destroy();
    end);
end;

-- ============================================
-- ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ УПРАВЛЕНИЯ ВОЛНАМИ
-- ============================================

function Library:SetWaveSpeed(speed)
    if Library.WaveSystem then
        local multiplier = speed / 0.08 -- Базовая скорость
        Library.WaveSystem.ProjectWave.speed = 0.08 * multiplier
        Library.WaveSystem.NicknameWave.speed = 0.07 * multiplier
        Library.WaveSystem.FPSWave.speed = 0.06 * multiplier
        Library.WaveSystem.PingWave.speed = 0.055 * multiplier
        Library.WaveSystem.TimeWave.speed = 0.045 * multiplier
        Library.WaveSystem.KeybindHeaderWave.speed = 0.065 * multiplier
    end
end

function Library:SetWaveIntensity(intensity)
    if Library.WaveSystem then
        Library.WaveSystem.ProjectWave.intensity = intensity
        Library.WaveSystem.NicknameWave.intensity = intensity * 0.9
        Library.WaveSystem.FPSWave.intensity = intensity * 0.75
        Library.WaveSystem.PingWave.intensity = intensity * 0.75
        Library.WaveSystem.TimeWave.intensity = intensity * 0.6
        Library.WaveSystem.KeybindHeaderWave.intensity = intensity * 0.9
    end
end

function Library:SetWaveWidth(width)
    if Library.WaveSystem then
        Library.WaveSystem.ProjectWave.width = width
        Library.WaveSystem.NicknameWave.width = width * 1.17
        Library.WaveSystem.FPSWave.width = width * 0.83
        Library.WaveSystem.PingWave.width = width * 0.83
        Library.WaveSystem.TimeWave.width = width * 1.33
        Library.WaveSystem.KeybindHeaderWave.width = width
    end
end

function Library:ResetWaveSettings()
    if Library.WaveSystem then
        Library.WaveSystem.ProjectWave = {pos = 0, speed = 0.08, width = 3, intensity = 0.2}
        Library.WaveSystem.NicknameWave = {pos = 0, speed = 0.07, width = 3.5, intensity = 0.18}
        Library.WaveSystem.FPSWave = {pos = 0, speed = 0.06, width = 2.5, intensity = 0.15}
        Library.WaveSystem.PingWave = {pos = 0, speed = 0.055, width = 2.5, intensity = 0.15}
        Library.WaveSystem.TimeWave = {pos = 0, speed = 0.045, width = 4, intensity = 0.12}
        Library.WaveSystem.KeybindHeaderWave = {pos = 0, speed = 0.065, width = 3, intensity = 0.18}
    end
end

-- ============================================
-- АВТОМАТИЧЕСКАЯ ИНТЕГРАЦИЯ KEYPICKER
-- ============================================

-- Перехватываем создание KeyPicker для автоматического добавления в кейбинды
local OriginalAddKeyPicker = nil

function Library:AutoIntegrateKeyPickers()
    if not OriginalAddKeyPicker then
        -- Находим оригинальную функцию AddKeyPicker
        for _, tab in pairs(self.OpenedFrames or {}) do
            if tab.AddKeyPicker then
                OriginalAddKeyPicker = tab.AddKeyPicker
                break
            end
        end
        
        if OriginalAddKeyPicker then
            -- Заменяем функцию на нашу версию
            local function NewAddKeyPicker(self, Idx, Info)
                local KeyPicker = OriginalAddKeyPicker(self, Idx, Info)
                
                -- Автоматически добавляем в кейбинды при создании
                if Info and Info.Text and KeyPicker then
                    task.spawn(function()
                        wait(0.1) -- Небольшая задержка для инициализации
                        
                        local keybindName = Info.Text or "Unknown"
                        local currentKey = KeyPicker.State or "None"
                        local isToggled = false
                        
                        -- Определяем иконку по названию
                        local iconName = "key"
                        if string.find(keybindName:lower(), "esp") then
                            iconName = "eye"
                        elseif string.find(keybindName:lower(), "aim") then
                            iconName = "target"
                        elseif string.find(keybindName:lower(), "menu") then
                            iconName = "settings"
                        elseif string.find(keybindName:lower(), "fly") then
                            iconName = "zap"
                        end
                        
                        Library:AddKeybind(keybindName, currentKey, isToggled, iconName)
                        
                        -- Подключаем обновление состояния
                        if KeyPicker.Changed then
                            KeyPicker.Changed:Connect(function()
                                Library:UpdateKeybindState(keybindName, KeyPicker.Active or false)
                            end)
                        end
                    end)
                end
                
                return KeyPicker
            end
            
            -- Применяем новую функцию ко всем табам
            for _, tab in pairs(self.OpenedFrames or {}) do
                if tab.AddKeyPicker then
                    tab.AddKeyPicker = NewAddKeyPicker
                end
            end
        end
    end
end




function Library:CreateWindow(...)
    local Arguments = { ... }
    local Config = { AnchorPoint = Vector2.zero }

    if type(...) == 'table' then
        Config = ...;
    else
        Config.Title = Arguments[1]
        Config.AutoShow = Arguments[2] or false;
    end

    if type(Config.Title) ~= 'string' then Config.Title = 'No title' end
    if type(Config.TabPadding) ~= 'number' then Config.TabPadding = 0 end
    if type(Config.MenuFadeTime) ~= 'number' then Config.MenuFadeTime = 0.2 end

    if typeof(Config.Position) ~= 'UDim2' then Config.Position = UDim2.fromOffset(175, 50) end
    if typeof(Config.Size) ~= 'UDim2' then Config.Size = UDim2.fromOffset(550, 600) end

    if Config.Center then
        Config.AnchorPoint = Vector2.new(0.5, 0.5)
        Config.Position = UDim2.fromScale(0.5, 0.5)
    end

    local Window = {
        Tabs = {};
    };

    local Outer = Library:Create('Frame', {
        AnchorPoint = Config.AnchorPoint,
        BackgroundColor3 = Color3.new(0, 0, 0);
        BorderSizePixel = 0;
        Position = Config.Position,
        Size = Config.Size,
        Visible = false;
        ZIndex = 1;
        Parent = ScreenGui;
    });

    Library:MakeDraggable(Outer, 25);

    local Inner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 1;
        Parent = Outer;
    });

    Library:AddToRegistry(Inner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'AccentColor';
    });

    local WindowLabel = Library:CreateLabel({
        Position = UDim2.new(0, 7, 0, 0);
        Size = UDim2.new(0, 0, 0, 25);
        Text = Config.Title or '';
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 1;
        Parent = Inner;
    });

    local MainSectionOuter = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 8, 0, 25);
        Size = UDim2.new(1, -16, 1, -33);
        ZIndex = 1;
        Parent = Inner;
    });

    Library:AddToRegistry(MainSectionOuter, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });

    local MainSectionInner = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Color3.new(0, 0, 0);
        BorderMode = Enum.BorderMode.Inset;
        Position = UDim2.new(0, 0, 0, 0);
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 1;
        Parent = MainSectionOuter;
    });

    Library:AddToRegistry(MainSectionInner, {
        BackgroundColor3 = 'BackgroundColor';
    });

    local TabArea = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 8, 0, 8);
        Size = UDim2.new(1, -16, 0, 21);
        ZIndex = 1;
        Parent = MainSectionInner;
    });

    local TabListLayout = Library:Create('UIListLayout', {
        Padding = UDim.new(0, Config.TabPadding);
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = TabArea;
    });

    local TabContainer = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 8, 0, 30);
        Size = UDim2.new(1, -16, 1, -38);
        ZIndex = 2;
        Parent = MainSectionInner;
    });
    

    Library:AddToRegistry(TabContainer, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

    function Window:SetWindowTitle(Title)
        WindowLabel.Text = Title;
    end;

    function Window:AddTab(Name)
        local Tab = {
            Groupboxes = {};
            Tabboxes = {};
        };

        local TabButtonWidth = Library:GetTextBounds(Name, Library.Font, 16);

        local TabButton = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            Size = UDim2.new(0, TabButtonWidth + 8 + 4, 1, 0);
            ZIndex = 1;
            Parent = TabArea;
        });

        Library:AddToRegistry(TabButton, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        local TabButtonLabel = Library:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, -1);
            Text = Name;
            ZIndex = 1;
            Parent = TabButton;
        });

        local Blocker = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 1, 0);
            Size = UDim2.new(1, 0, 0, 1);
            BackgroundTransparency = 1;
            ZIndex = 3;
            Parent = TabButton;
        });

        Library:AddToRegistry(Blocker, {
            BackgroundColor3 = 'MainColor';
        });

        local TabFrame = Library:Create('Frame', {
            Name = 'TabFrame',
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            Visible = false;
            ZIndex = 2;
            Parent = TabContainer;
        });

        local LeftSide = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 8 - 1, 0, 8 - 1);
            Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2);
            CanvasSize = UDim2.new(0, 0, 0, 0);
            BottomImage = '';
            TopImage = '';
            ScrollBarThickness = 0;
            ZIndex = 2;
            Parent = TabFrame;
        });

        local RightSide = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0.5, 4 + 1, 0, 8 - 1);
            Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2);
            CanvasSize = UDim2.new(0, 0, 0, 0);
            BottomImage = '';
            TopImage = '';
            ScrollBarThickness = 0;
            ZIndex = 2;
            Parent = TabFrame;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Parent = LeftSide;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Parent = RightSide;
        });

        for _, Side in next, { LeftSide, RightSide } do
            Side:WaitForChild('UIListLayout'):GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                Side.CanvasSize = UDim2.fromOffset(0, Side.UIListLayout.AbsoluteContentSize.Y);
            end);
        end;

        function Tab:ShowTab()
            for _, Tab in next, Window.Tabs do
                Tab:HideTab();
            end;

            Blocker.BackgroundTransparency = 0;
            TabButton.BackgroundColor3 = Library.MainColor;
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'MainColor';
            TabFrame.Visible = true;
        end;

        function Tab:HideTab()
            Blocker.BackgroundTransparency = 1;
            TabButton.BackgroundColor3 = Library.BackgroundColor;
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'BackgroundColor';
            TabFrame.Visible = false;
        end;

        function Tab:SetLayoutOrder(Position)
            TabButton.LayoutOrder = Position;
            TabListLayout:ApplyLayout();
        end;

-- MATCHA STYLE GROUPBOX
-- Минималистичный, чистый дизайн как в скриншоте

local TweenService = game:GetService('TweenService')

function Tab:AddGroupbox(Info)
    local Groupbox = {};
    
    -- ОСНОВНОЙ КОНТЕЙНЕР (без лишних рамок)
    local BoxOuter = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(18, 18, 22); -- Темный фон
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 507);
        ClipsDescendants = false;
        ZIndex = 2;
        Parent = Info.Side == 1 and LeftSide or RightSide;
    });
    
    -- Закругленные углы
    local OuterCorner = Library:Create('UICorner', {
        CornerRadius = UDim.new(0, 4);
        Parent = BoxOuter;
    });
    
    -- МЯГКИЙ ГРАДИЕНТ НА ФОНЕ (сверху вниз)
    local BackgroundGradient = Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 24)), -- Чуть светлее сверху
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 20))  -- Чуть темнее снизу
        });
        Rotation = 90;
        Parent = BoxOuter;
    });
    
    -- ТОНКАЯ ЛИНИЯ АКЦЕНТА СВЕРХУ (как в Matcha)
    local TopAccent = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 2);
        ZIndex = 10;
        Parent = BoxOuter;
    });
    
    Library:AddToRegistry(TopAccent, {
        BackgroundColor3 = 'AccentColor';
    });
    
    local AccentCorner = Library:Create('UICorner', {
        CornerRadius = UDim.new(0, 4);
        Parent = TopAccent;
    });
    
    -- МЯГКИЙ ГРАДИЕНТ НА ЛИНИИ АКЦЕНТА (слева направо)
    local AccentGradient = Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(
                Library.AccentColor.R * 255 * 0.5,
                Library.AccentColor.G * 255 * 0.5,
                Library.AccentColor.B * 255 * 0.5
            )),
            ColorSequenceKeypoint.new(0.5, Library.AccentColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(
                Library.AccentColor.R * 255 * 0.5,
                Library.AccentColor.G * 255 * 0.5,
                Library.AccentColor.B * 255 * 0.5
            ))
        });
        Rotation = 0;
        Parent = TopAccent;
    });
    
    Library:AddToRegistry(AccentGradient, {
        Color = function()
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(
                    Library.AccentColor.R * 255 * 0.5,
                    Library.AccentColor.G * 255 * 0.5,
                    Library.AccentColor.B * 255 * 0.5
                )),
                ColorSequenceKeypoint.new(0.5, Library.AccentColor),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(
                    Library.AccentColor.R * 255 * 0.5,
                    Library.AccentColor.G * 255 * 0.5,
                    Library.AccentColor.B * 255 * 0.5
                ))
            });
        end
    });
    
    -- ЗАГОЛОВОК (минималистичный)
    local HeaderSection = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 0, 0, 2);
        Size = UDim2.new(1, 0, 0, 28);
        ZIndex = 5;
        Parent = BoxOuter;
    });
    
    -- Название по центру
    local GroupboxLabel = Library:CreateLabel({
        Size = UDim2.new(1, 0, 1, 0);
        TextSize = 15;
        Text = Info.Name;
        TextColor3 = Color3.fromRGB(220, 220, 220);
        TextXAlignment = Enum.TextXAlignment.Center;
        TextYAlignment = Enum.TextYAlignment.Center;
        Font = Enum.Font.GothamSemibold;
        ZIndex = 6;
        Parent = HeaderSection;
    });
    
    -- Тонкая разделительная линия
    local Divider = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(40, 40, 45);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 8, 1, -1);
        Size = UDim2.new(1, -16, 0, 1);
        ZIndex = 5;
        Parent = HeaderSection;
    });

    
    -- КОНТЕНТ СЕКЦИЯ
    local ContentSection = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 0, 0, 30);
        Size = UDim2.new(1, 0, 1, -30);
        ClipsDescendants = true;
        ZIndex = 4;
        Parent = BoxOuter;
    });
    
    -- SCROLLING FRAME (невидимый стандартный scrollbar)
    local ScrollFrame = Library:Create('ScrollingFrame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 0, 0, 0);
        Size = UDim2.new(1, -6, 1, 0);
        CanvasSize = UDim2.new(0, 0, 0, 0);
        ScrollBarThickness = 0;
        BorderSizePixel = 0;
        ScrollingEnabled = true;
        ZIndex = 5;
        Parent = ContentSection;
    });
    
    -- КАСТОМНЫЙ SCROLLBAR (тонкий и минималистичный)
    local ScrollBarTrack = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(30, 30, 35);
        BorderSizePixel = 0;
        Position = UDim2.new(1, -4, 0, 4);
        Size = UDim2.new(0, 2, 1, -8);
        Visible = false;
        ZIndex = 10;
        Parent = ContentSection;
    });
    
    local TrackCorner = Library:Create('UICorner', {
        CornerRadius = UDim.new(1, 0);
        Parent = ScrollBarTrack;
    });
    
    -- Ползунок
    local ScrollBarThumb = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = UDim2.new(0, 0, 0, 0);
        Size = UDim2.new(1, 0, 0, 50);
        ZIndex = 11;
        Parent = ScrollBarTrack;
    });
    
    Library:AddToRegistry(ScrollBarThumb, {
        BackgroundColor3 = 'AccentColor';
    });
    
    local ThumbCorner = Library:Create('UICorner', {
        CornerRadius = UDim.new(1, 0);
        Parent = ScrollBarThumb;
    });
    
    -- Обновление scrollbar
    local function UpdateScrollBar()
        local canvasSize = ScrollFrame.CanvasSize.Y.Offset;
        local frameSize = ScrollFrame.AbsoluteSize.Y;
        
        if canvasSize > frameSize + 10 then
            ScrollBarTrack.Visible = true;
            local thumbSize = math.max(20, (frameSize / canvasSize) * frameSize);
            ScrollBarThumb.Size = UDim2.new(1, 0, 0, thumbSize);
            local scrollPercent = ScrollFrame.CanvasPosition.Y / (canvasSize - frameSize);
            local maxThumbPos = frameSize - thumbSize - 8;
            ScrollBarThumb.Position = UDim2.new(0, 0, 0, 4 + scrollPercent * maxThumbPos);
        else
            ScrollBarTrack.Visible = false;
        end
    end
    
    ScrollFrame:GetPropertyChangedSignal('CanvasPosition'):Connect(UpdateScrollBar);
    ScrollFrame:GetPropertyChangedSignal('CanvasSize'):Connect(UpdateScrollBar);
    ScrollFrame:GetPropertyChangedSignal('AbsoluteSize'):Connect(UpdateScrollBar);

    
    -- Контейнер для элементов
    local Container = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 8, 0, 4);
        Size = UDim2.new(1, -16, 1, 0);
        ClipsDescendants = false;
        ZIndex = 6;
        Parent = ScrollFrame;
    });
    
    Library:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 4);
        Parent = Container;
    });
    
    Container:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Container.AbsoluteSize.Y + 8);
        UpdateScrollBar();
    end);
    
    -- HOVER ЭФФЕКТ на заголовке
    HeaderSection.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            TweenService:Create(GroupboxLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                TextColor3 = Library.AccentColor
            }):Play();
            TweenService:Create(TopAccent, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, 3)
            }):Play();
        end
    end);
    
    HeaderSection.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            TweenService:Create(GroupboxLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                TextColor3 = Color3.fromRGB(220, 220, 220)
            }):Play();
            TweenService:Create(TopAccent, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, 2)
            }):Play();
        end
    end);
    
    function Groupbox:Resize()
        local ContentSize = 0;
        local ElementCount = 0;
        
        for _, Element in next, Groupbox.Container:GetChildren() do
            if (not Element:IsA('UIListLayout')) and Element.Visible then
                ContentSize = ContentSize + Element.Size.Y.Offset;
                ElementCount = ElementCount + 1;
            end;
        end;
        
        if ElementCount > 1 then
            ContentSize = ContentSize + (4 * (ElementCount - 1));
        end;
        
        ContentSize = math.max(ContentSize, 40);
        local MaxHeight = 450;
        local ActualHeight = math.min(ContentSize, MaxHeight);
        
        BoxOuter.Size = UDim2.new(1, 0, 0, 30 + ActualHeight + 8);
        ContentSection.Size = UDim2.new(1, 0, 0, ActualHeight + 8);
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentSize + 8);
        
        task.wait(0.05);
        UpdateScrollBar();
    end;
    
    Groupbox.Container = Container;
    setmetatable(Groupbox, BaseGroupbox);
    Groupbox:AddBlank(2);
    Groupbox:Resize();
    
    Tab.Groupboxes[Info.Name] = Groupbox;
    return Groupbox;
end;

function Tab:AddLeftGroupbox(Name)
    return Tab:AddGroupbox({ Side = 1; Name = Name; });
end;

function Tab:AddRightGroupbox(Name)
    return Tab:AddGroupbox({ Side = 2; Name = Name; });
end;


        TabButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Tab:ShowTab();
            end;
        end);

        -- This was the first tab added, so we show it by default.
        if #TabContainer:GetChildren() == 1 then
            Tab:ShowTab();
        end;

        Window.Tabs[Name] = Tab;
        return Tab;
    end;

    local ModalElement = Library:Create('TextButton', {
        BackgroundTransparency = 1;
        Size = UDim2.new(0, 0, 0, 0);
        Visible = true;
        Text = '';
        Modal = false;
        Parent = ScreenGui;
    });

    local TransparencyCache = {};
    local Toggled = false;
    local Fading = false;

    function Library:Toggle()
        if Fading then
            return;
        end;

        local FadeTime = Config.MenuFadeTime;
        Fading = true;
        Toggled = (not Toggled);
        ModalElement.Modal = Toggled;

        if Toggled then
            -- A bit scuffed, but if we're going from not toggled -> toggled we want to show the frame immediately so that the fade is visible.
            Outer.Visible = true;

            task.spawn(function()
                -- TODO: add cursor fade?
                local State = InputService.MouseIconEnabled;

                local Cursor = Drawing.new('Triangle');
                Cursor.Thickness = 1;
                Cursor.Filled = true;
                Cursor.Visible = true;

                local CursorOutline = Drawing.new('Triangle');
                CursorOutline.Thickness = 1;
                CursorOutline.Filled = false;
                CursorOutline.Color = Color3.new(0, 0, 0);
                CursorOutline.Visible = true;

                while Toggled and ScreenGui.Parent do
                    InputService.MouseIconEnabled = false;

                    local mPos = InputService:GetMouseLocation();

                    Cursor.Color = Library.AccentColor;

                    Cursor.PointA = Vector2.new(mPos.X, mPos.Y);
                    Cursor.PointB = Vector2.new(mPos.X + 16, mPos.Y + 6);
                    Cursor.PointC = Vector2.new(mPos.X + 6, mPos.Y + 16);

                    CursorOutline.PointA = Cursor.PointA;
                    CursorOutline.PointB = Cursor.PointB;
                    CursorOutline.PointC = Cursor.PointC;

                    RenderStepped:Wait();
                end;

                InputService.MouseIconEnabled = State;

                Cursor:Remove();
                CursorOutline:Remove();
            end);
        end;

        for _, Desc in next, Outer:GetDescendants() do
            local Properties = {};

            if Desc:IsA('ImageLabel') then
                table.insert(Properties, 'ImageTransparency');
                table.insert(Properties, 'BackgroundTransparency');
            elseif Desc:IsA('TextLabel') or Desc:IsA('TextBox') then
                table.insert(Properties, 'TextTransparency');
            elseif Desc:IsA('Frame') or Desc:IsA('ScrollingFrame') then
                table.insert(Properties, 'BackgroundTransparency');
            elseif Desc:IsA('UIStroke') then
                table.insert(Properties, 'Transparency');
            end;

            local Cache = TransparencyCache[Desc];

            if (not Cache) then
                Cache = {};
                TransparencyCache[Desc] = Cache;
            end;

            for _, Prop in next, Properties do
                if not Cache[Prop] then
                    Cache[Prop] = Desc[Prop];
                end;

                if Cache[Prop] == 1 then
                    continue;
                end;

                TweenService:Create(Desc, TweenInfo.new(FadeTime, Enum.EasingStyle.Linear), { [Prop] = Toggled and Cache[Prop] or 1 }):Play();
            end;
        end;

        task.wait(FadeTime);

        Outer.Visible = Toggled;

        Fading = false;
    end

    Library:GiveSignal(InputService.InputBegan:Connect(function(Input, Processed)
        if type(Library.ToggleKeybind) == 'table' and Library.ToggleKeybind.Type == 'KeyPicker' then
            if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Library.ToggleKeybind.Value then
                task.spawn(Library.Toggle)
            end
        elseif Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and (not Processed)) then
            task.spawn(Library.Toggle)
        end
    end))

    if Config.AutoShow then task.spawn(Library.Toggle) end

    Window.Holder = Outer;

    return Window;
end;

local function OnPlayerChange()
    local PlayerList = GetPlayersString();

    for _, Value in next, Options do
        if Value.Type == 'Dropdown' and Value.SpecialType == 'Player' then
            Value:SetValues(PlayerList);
        end;
    end;
end;

Players.PlayerAdded:Connect(OnPlayerChange);
Players.PlayerRemoving:Connect(OnPlayerChange);

getgenv().Library = Library
return Library
