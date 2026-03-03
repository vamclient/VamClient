local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local KeyAuth = loadstring(game:HttpGet("https://raw.githubusercontent.com/Authentication/KeyAuth/main/KeyAuth.lua", true))()
local name = "VaM Client";
local ownerid = "BNqEca2xSS";
local version = "1.0";

-- Load the working LimbExtender module from your old script
getgenv().le = getgenv().le or loadstring(game:HttpGet('https://raw.githubusercontent.com/AAPVdev/scripts/refs/heads/main/LimbExtender.lua'))()
local LimbExtender = getgenv().le
local le = LimbExtender({
    LISTEN_FOR_INPUT = false,
    USE_HIGHLIGHT = false,
})

local Window = Library:CreateWindow({
    Title = 'VaM Client',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

local Tabs = {
    TabCombat = Window:AddTab('Combat'),
}

local CombatGroupBoxLeft = Tabs.TabCombat:AddLeftGroupbox('Hitbox Extender')

CombatGroupBoxLeft:AddToggle('HBEToggle', {
    Text = 'Enabled',
    Default = false,
    Tooltip = 'Enables HBE',
    Callback = function(Value)
        print('VaM Client: HBE changed to', Value)
    end
})

local HBEDepbox = CombatGroupBoxLeft:AddDependencyBox()

HBEDepbox:AddSlider('LimbSizeSlider', {
    Text = 'Limb Size',
    Default = 5,
    Min = 1,
    Max = 25,
    Rounding = 1,
    HideMax = true,
})

HBEDepbox:AddSlider('HBETransparency', {
    Text = 'Transparency',
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    HideMax = true,
})

HBEDepbox:AddToggle('HBEFriendlyToggle', {
    Text = 'Ignore Team',
    Default = false,
    Tooltip = 'Disables HBE for your allies'
})

-- Dependencies
HBEDepbox:SetupDependencies({
    { Toggles.HBEToggle, true }
})

-- ─────────
-- HBE LOGIC
-- ─────────

Toggles.HBEToggle:OnChanged(function(enabled)
    if enabled then
        -- Apply current UI values to LimbExtender
        le:Set("LIMB_SIZE", Options.LimbSizeSlider.Value)
        le:Set("LIMB_TRANSPARENCY", Options.HBETransparency.Value)
        le:Set("TEAM_CHECK", Toggles.HBEFriendlyToggle.Value)   -- true = skip teammates
        le:Set("TARGET_LIMB", "Head")                            -- only heads
        le:Set("LIMB_CAN_COLLIDE", false)                        -- prevents physics issues
        le:Set("FORCEFIELD_CHECK", true)                         -- safety

        le:Toggle(true)   -- start the extender
    else
        le:Toggle(false)  -- stop + reset all modified limbs
    end
end)

-- Live sync when sliders/toggles change while enabled
Options.LimbSizeSlider:OnChanged(function()
    if Toggles.HBEToggle.Value then
        le:Set("LIMB_SIZE", Options.LimbSizeSlider.Value)
    end
end)

Options.HBETransparency:OnChanged(function()
    if Toggles.HBEToggle.Value then
        le:Set("LIMB_TRANSPARENCY", Options.HBETransparency.Value)
    end
end)

Toggles.HBEFriendlyToggle:OnChanged(function()
    if Toggles.HBEToggle.Value then
        le:Set("TEAM_CHECK", Toggles.HBEFriendlyToggle.Value)
    end
end)