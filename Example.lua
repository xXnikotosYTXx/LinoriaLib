-- ПОЛНЫЙ ПРИМЕР ESP С ВОЛНОВОЙ СИСТЕМОЙ
-- Включает: Linoria GUI, ESP, Watermark с волнами, Keybinds

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ЗАМЕНИТЕ СЕКЦИЮ "-- < Create other UI elements >" В LIBRARY НА КОД ИЗ example-final-fixed-wave.lua
-- Здесь предполагается что вы уже это сделали

local Window = Library:CreateWindow({
    Title = 'ESP Cheat - Ultimate',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- ТАБЫ
local Tabs = {
    ESP = Window:AddTab('ESP'),
    Visual = Window:AddTab('Visual Effects'),
    Players = Window:AddTab('Players'),
    Settings = Window:AddTab('Settings'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- ============================================
-- ESP TAB
-- ============================================
local ESPBox = Tabs.ESP:AddLeftGroupbox('Box ESP')

ESPBox:AddToggle('EnableBoxESP', {
    Text = 'Enable Box ESP',
    Default = false,
    Tooltip = 'Show boxes around players',
    Callback = function(Value)
        -- Ваш код ESP
        print('Box ESP:', Value)
        Library:UpdateKeybindState('Box ESP', Value)
    end
})

ESPBox:AddToggle('EnableBoxOutline', {
    Text = 'Box Outline',
    Default = true,
    Tooltip = 'Add outline to boxes',
})

ESPBox:AddSlider('BoxThickness', {
    Text = 'Box Thickness',
    Default = 2,
    Min = 1,
    Max = 5,
    Rounding = 0,
    Compact = false,
})

ESPBox:AddLabel('Box Colors'):AddColorPicker('BoxColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Box Color',
})

local ESPText = Tabs.ESP:AddRightGroupbox('Text & Distance')

ESPText:AddToggle('EnableNames', {
    Text = 'Show Names',
    Default = false,
    Callback = function(Value)
        print('Names:', Value)
    end
})

ESPText:AddToggle('EnableHealth', {
    Text = 'Show Health Text',
    Default = false,
})

ESPText:AddToggle('EnableDistance', {
    Text = 'Show Distance',
    Default = false,
    Callback = function(Value)
        print('Distance:', Value)
        Library:UpdateKeybindState('Distance', Value)
    end
})

ESPText:AddSlider('NameTextSize', {
    Text = 'Name Text Size',
    Default = 14,
    Min = 10,
    Max = 20,
    Rounding = 0,
})

local ESPHealthbar = Tabs.ESP:AddLeftGroupbox('Healthbar')

ESPHealthbar:AddToggle('EnableHealthbar', {
    Text = 'Enable Healthbar',
    Default = false,
    Callback = function(Value)
        print('Healthbar:', Value)
        Library:UpdateKeybindState('Healthbar', Value)
    end
})

ESPHealthbar:AddDropdown('HealthbarPosition', {
    Values = { 'Left', 'Right', 'Top', 'Bottom' },
    Default = 1,
    Multi = false,
    Text = 'Healthbar Position',
})

ESPHealthbar:AddLabel('Low Health Color'):AddColorPicker('LowHealthColor', {
    Default = Color3.fromRGB(255, 0, 0),
    Title = 'Low Health',
})

ESPHealthbar:AddLabel('High Health Color'):AddColorPicker('HighHealthColor', {
    Default = Color3.fromRGB(0, 255, 0),
    Title = 'High Health',
})

local ESPTracers = Tabs.ESP:AddRightGroupbox('Tracers')

ESPTracers:AddToggle('EnableTracers', {
    Text = 'Enable Tracers',
    Default = false,
    Callback = function(Value)
        print('Tracers:', Value)
        Library:UpdateKeybindState('Tracers', Value)
    end
})

ESPTracers:AddDropdown('TracerOrigin', {
    Values = { 'Bottom', 'Center', 'Top' },
    Default = 1,
    Multi = false,
    Text = 'Tracer Origin',
})

ESPTracers:AddSlider('TracerThickness', {
    Text = 'Tracer Thickness',
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 0,
})

ESPTracers:AddLabel('Tracer Color'):AddColorPicker('TracerColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Tracer Color',
})

-- ============================================
-- VISUAL EFFECTS TAB
-- ============================================
local VisualGlow = Tabs.Visual:AddLeftGroupbox('Glow Effects')

VisualGlow:AddToggle('EnableGlow', {
    Text = 'Enable Glow',
    Default = false,
})

VisualGlow:AddSlider('GlowIntensity', {
    Text = 'Glow Intensity',
    Default = 1,
    Min = 0,
    Max = 2,
    Rounding = 1,
})

local VisualChams = Tabs.Visual:AddRightGroupbox('Chams')

VisualChams:AddToggle('EnableChams', {
    Text = 'Enable Chams',
    Default = false,
})

VisualChams:AddSlider('ChamsTransparency', {
    Text = 'Transparency',
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
})

-- ============================================
-- PLAYERS TAB
-- ============================================
local PlayerTargeting = Tabs.Players:AddLeftGroupbox('Targeting')

PlayerTargeting:AddToggle('TargetTeam', {
    Text = 'Target Team',
    Default = false,
})

PlayerTargeting:AddToggle('TargetFriends', {
    Text = 'Target Friends',
    Default = false,
})

PlayerTargeting:AddSlider('MaxDistance', {
    Text = 'Max Distance',
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Suffix = ' studs',
})

-- ============================================
-- SETTINGS TAB
-- ============================================
local SettingsWatermark = Tabs.Settings:AddLeftGroupbox('Watermark')

SettingsWatermark:AddToggle('ShowWatermark', {
    Text = 'Show Watermark',
    Default = true,
    Tooltip = 'Show watermark with wave animations',
    Callback = function(Value)
        Library:SetWatermarkVisibility(Value)
    end
})

SettingsWatermark:AddButton({
    Text = 'Start Wave System',
    Func = function()
        Library:SetWatermark('', true)
        Library:Notify('Wave system started!', 3)
    end,
    DoubleClick = false,
})

SettingsWatermark:AddSlider('WaveSpeed', {
    Text = 'Wave Speed',
    Default = 0.08,
    Min = 0.01,
    Max = 0.2,
    Rounding = 2,
    Callback = function(Value)
        Library:SetWaveSpeed(Value)
    end
})

SettingsWatermark:AddSlider('WaveIntensity', {
    Text = 'Wave Intensity',
    Default = 0.2,
    Min = 0.1,
    Max = 0.5,
    Rounding = 2,
    Callback = function(Value)
        Library:SetWaveIntensity(Value)
    end
})

SettingsWatermark:AddSlider('WaveWidth', {
    Text = 'Wave Width',
    Default = 3,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        Library:SetWaveWidth(Value)
    end
})

SettingsWatermark:AddSlider('StatsUpdateRate', {
    Text = 'Stats Update Rate',
    Default = 60,
    Min = 10,
    Max = 120,
    Rounding = 0,
    Suffix = ' frames',
    Callback = function(Value)
        Library:SetStatsUpdateInterval(Value)
    end
})

SettingsWatermark:AddButton({
    Text = 'Pause Waves',
    Func = function()
        Library:PauseWaves()
    end,
})

SettingsWatermark:AddButton({
    Text = 'Resume Waves',
    Func = function()
        Library:ResumeWaves()
    end,
})

local SettingsKeybinds = Tabs.Settings:AddRightGroupbox('Keybinds Display')

SettingsKeybinds:AddToggle('ShowKeybinds', {
    Text = 'Show Keybinds',
    Default = true,
    Tooltip = 'Show keybinds panel with wave animations',
    Callback = function(Value)
        Library:SetKeybindVisibility(Value)
    end
})

SettingsKeybinds:AddButton({
    Text = 'Add Test Keybinds',
    Func = function()
        Library:AddKeybind('Box ESP', 'F1', false, 'eye')
        Library:AddKeybind('Tracers', 'F2', false, 'target')
        Library:AddKeybind('Healthbar', 'F3', false, 'heart')
        Library:AddKeybind('Distance', 'F4', false, 'zap')
        Library:Notify('Test keybinds added!', 3)
    end,
})

SettingsKeybinds:AddButton({
    Text = 'Clear All Keybinds',
    Func = function()
        Library:RemoveKeybind('Box ESP')
        Library:RemoveKeybind('Tracers')
        Library:RemoveKeybind('Healthbar')
        Library:RemoveKeybind('Distance')
        Library:Notify('All keybinds cleared!', 3)
    end,
})

local SettingsPerformance = Tabs.Settings:AddLeftGroupbox('Performance')

SettingsPerformance:AddToggle('LowPerformanceMode', {
    Text = 'Low Performance Mode',
    Default = false,
    Tooltip = 'Reduce visual effects for better performance',
})

SettingsPerformance:AddSlider('RenderDistance', {
    Text = 'Render Distance',
    Default = 1000,
    Min = 100,
    Max = 2000,
    Rounding = 0,
    Suffix = ' studs',
})

-- ============================================
-- UI SETTINGS TAB
-- ============================================
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton({
    Text = 'Unload',
    Func = function()
        Library:Unload()
    end
})

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

-- ============================================
-- ИНИЦИАЛИЗАЦИЯ ВОЛНОВОЙ СИСТЕМЫ
-- ============================================

-- Запускаем волновую систему
Library:SetWatermark('', true)
print('🌊 Волновая система запущена!')

-- Показываем кейбинды
Library:SetKeybindVisibility(true)
print('🎨 Кейбинды показаны!')

-- Добавляем начальные кейбинды
task.delay(1, function()
    Library:AddKeybind('Box ESP', 'F1', false, 'eye')
    Library:AddKeybind('Tracers', 'F2', false, 'target')
    Library:AddKeybind('Healthbar', 'F3', false, 'heart')
    Library:AddKeybind('Distance', 'F4', false, 'zap')
    print('✅ Кейбинды добавлены!')
end)

-- Уведомление о загрузке
Library:Notify('ESP Cheat loaded successfully!', 5)

print('')
print('✅ СКРИПТ ЗАГРУЖЕН!')
print('🌊 Волновой ватермарк активен')
print('🎨 Кейбинды с волнами активны')
print('⚙️ Настройки доступны во вкладке Settings')
print('')
print('📝 ГОРЯЧИЕ КЛАВИШИ:')
print('F1 - Box ESP')
print('F2 - Tracers')
print('F3 - Healthbar')
print('F4 - Distance')
print('End - Открыть/закрыть меню')
