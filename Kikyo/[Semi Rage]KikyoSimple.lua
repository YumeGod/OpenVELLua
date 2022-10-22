


-------------
-----FFI-----
-------------

local ffi = require("ffi")
 
ffi.cdef [[ 
	typedef void***(__thiscall* FindHudElement_t)(void*, const char*); 
	typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...); 
]]
	script = { 
		signature_gHud = "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09", 
		signature_FindElement = "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28", 
	}
	match = client.find_signature("client_panorama.dll", script.signature_gHud) or error("sig1 not found")
	hud = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("hud is nil")
	helement_match = client.find_signature("client_panorama.dll", script.signature_FindElement) or error("FindHudElement not found")
	hudchat = ffi.cast("FindHudElement_t", helement_match)(hud, "CHudChat") or error("CHudChat not found")
	chudchat_vtbl = hudchat[0] or error("CHudChat instance vtable is nil")
	print_to_chat = ffi.cast("ChatPrintf_t", chudchat_vtbl[27])
function print_chat(text)
	print_to_chat(hudchat, 0, 0, text)
end

-------------------
-----VARIABLES-----
-------------------

bit_band, print, func, select, type, xpcall, pairs = bit.band, print, func, select, type, xpcall, pairs

local inds = {"Anti-aim state", "Autowall", "Body aim", "Triggermagnet", "FOV", "Minimum Damage", "Resolver Override"}

local hp_values = {
[0] = "Auto", [1] = "1", [2] = "2", [3] = "3", [4] = "4", [5] = "5", [6] = "6", [7] = "7", [8] = "8", [9] = "9", [10] = "10", [11] = "11", [12] = "12", [13] = "13", [14] = "14", [15] = "15", [16] = "16", [17] = "17", [18] = "18", [19] = "19", [20] = "20", [21] = "21", [22] = "22", [23] = "23", [24] = "24", [25] = "25", [26] = "26", [27] = "27", [28] = "28", [29] = "29", [30] = "30", [31] = "31", [32] = "32", [33] = "33", [34] = "34", [35] = "35", [36] = "36", [37] = "37", [38] = "38", [39] = "39", [40] = "40", [41] = "41", [42] = "42", [43] = "43", [44] = "44", [45] = "45", [46] = "46", [47] = "47", [48] = "48", [49] = "49", [50] = "50", [51] = "51", [52] = "52", [53] = "53", [54] = "54", [55] = "55", [56] = "56", [57] = "57", [58] = "58", [59] = "59", [60] = "60", [61] = "61", [62] = "62", [63] = "63", [64] = "64", [65] = "65", [66] = "66", [67] = "67", [68] = "68", [69] = "69", [70] = "70", [71] = "71", [72] = "72", [73] = "73", [74] = "74", [75] = "75", [76] = "76", [77] = "77", [78] = "78", [79] = "79", [80] = "80", [81] = "81", [82] = "82", [83] = "83", [84] = "84", [85] = "85", [86] = "86", [87] = "87", [88] = "88", [89] = "89", [90] = "90", [91] = "91", [92] = "92", [93] = "93", [94] = "94", [95] = "95", [96] = "96", [97] = "97", [98] = "98", [99] = "99", [100] = "100", [101] = "HP+1", [102] = "HP+2", [103] = "HP+3" ,[104] = "HP+4", [105] = "HP+5", [106] = "HP+6", [107] = "HP+7", [108] = "HP+8", [109] = "HP+9", [110] = "HP+10", [111] = "HP+11", [112] = "HP+12", [113] = "HP+13", [114] = "HP+14", [115] = "HP+15", [116] = "HP+16", [117] = "HP+17", [118] = "HP+18", [119] = "HP+19", [120] = "HP+20", [121] = "HP+21", [122] = "HP+22", [123] = "HP+23", [124] = "HP+24", [125] = "HP+25", [126] = "HP+26",
}

local edge_count = { [1] = 7, [2] = 12, [3] = 15, [4] = 19, [5] = 23, [6] = 28, [7] = 35, [8] = 39 }

adaptive_weapons = {
    ["Global"] = {},
    ["Auto"] = { 11, 38 },
    ["Awp"] = { 9 },
    ["Scout"] = { 40 },
    ["Desert Eagle"] = { 1 },
    ["Revolver"] = { 64 },
    ["Pistol"] = { 2, 3, 4, 30, 32, 36, 61, 63 },
    ["Rifle"] = { 7, 8, 10, 13, 16, 39, 60 },
    --["Submachine gun"]  = {17, 19, 24, 26, 33, 34},
    --["Machine gun"]     = {14, 28},
    --["Shotgun"]         = {25, 27, 29, 35},
}

local adaptive = { }
local references = { }
local callbacks = { }
local bruteforce_ents = { }
local saved_enable = { }
local active_config = "Global"
local weapon_id_lookup_table
local run_command

PI = 3.14159265358979323846
DEG_TO_RAD = PI / 180.0
RAD_TO_DEG = 180.0 / PI
local angle = 0

local canManual
local target
local targetx
local targety
local targetz
local screenposx
local screenposy

--------------
-----MATH-----
--------------

function get_closest_player_to_crosshair(lx, ly, lz, pitch, yaw)
    local fx, fy, fz = angle_to_vec(pitch, yaw)
    local enemy_players = entity.get_players(true)
    local nearest_player = nil
    local nearest_player_fov = math.huge
    for i = 1, #enemy_players do
        local enemy_ent = enemy_players[i]
        local fov_to_player = calculate_fov_to_player(enemy_ent, lx, ly, lz, fx, fy, fz)
        if fov_to_player <= nearest_player_fov then
            nearest_player = enemy_ent
            nearest_player_fov = fov_to_player
        end
    end
    return nearest_player, nearest_player_fov
end

local function contains(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

function angle_to_vec(pitch, yaw)
    local pitch_rad, yaw_rad = DEG_TO_RAD * pitch, DEG_TO_RAD * yaw
    local sp, cp, sy, cy = math.sin(pitch_rad), math.cos(pitch_rad), math.sin(yaw_rad), math.cos(yaw_rad)
    return cp * cy, cp * sy, -sp
end

function vec3_normalize(x, y, z)
    local len = math.sqrt(x * x + y * y + z * z)
    if len == 0 then
        return 0, 0, 0
    end
    local r = 1 / len
    return x * r, y * r, z * r
end

function vec3_dot(ax, ay, az, bx, by, bz)
    return ax * bx + ay * by + az * bz
end

function calculate_fov_to_player(ent, lx, ly, lz, fx, fy, fz)
    local px, py, pz = entity.get_prop(ent, "m_vecOrigin")
    local dx, dy, dz = vec3_normalize(px - lx, py - ly, lz - lz)
    local dot_product = vec3_dot(dx, dy, dz, fx, fy, fz)
    local cos_inverse = math.acos(dot_product)
    return RAD_TO_DEG * cos_inverse
end

function collect_keys(tbl, sort)
    local keys = {}
    sort = sort or true
    for k in pairs(tbl) do
        keys[#keys + 1] = k
    end
    if sort then
        table.sort(keys)
    end
    return keys
end

local function get_items(tbl)
    local items = {}
    local n = 0

    for k,v in pairs(tbl) do
        n = n + 1
        items[n]=k
    end
    table.sort(items)
    return items
end

function table_contains(tbl, value)
    for i = 1, #tbl do
        if tbl[i] == value then
            return true
        end
    end
    return false
end

function create_lookup_table(tbl)
    local result = {}
    for name, weapon_ids in pairs(tbl) do
        for i = 1, #weapon_ids do
            result[weapon_ids[i]] = name
        end
    end
    return result
end

function update_menu(visible)
    ui.set(adaptive_config2, active_config)
    if visible then
    end
end

run_command = function()
    local local_player = entity.get_local_player()
    local weapon_entindex = entity.get_player_weapon(local_player)
    local item_definition_index = bit.band(65535, entity.get_prop(weapon_entindex, "m_iItemDefinitionIndex"))
    local config_name = weapon_id_lookup_table[item_definition_index] or "Global"
    if config_name ~= active_config then
        active_config = config_name
        local options = ui.get(adaptive_options2)
        if table_contains(options, "Log") then
            print(active_config, " config loaded.")
        end
        update_menu(table_contains(options, "Visible"))
    end
end

function init()
    weapon_id_lookup_table = create_lookup_table(adaptive_weapons)
    for name, reference in pairs(references) do
        set_callback(reference, update_settings)
    end
    for config, items in pairs(adaptive) do
        for name, reference in pairs(items) do
            ui.set_callback(reference, handle_adaptive_config)
        end
    end
    client.set_event_callback("run_command", run_command)
end

init()

function is_player_visible(local_player, lx, ly, lz, ent)
    local visible_hitboxes = 0
    local visible_hitbox_threshold = ui.get(legit_pen_threshold_ref)
    for i = 0, 18 do
        local ex, ey, ez = entity.hitbox_position(ent, i)
        local _, entindex = client.trace_line(local_player, lx, ly, lz, ex, ey, ez)
        if entindex == ent then
            visible_hitboxes = visible_hitboxes + 1
        end
    end
    return visible_hitboxes >= visible_hitbox_threshold
end

local function inArr(tab, val)
    for index, value in ipairs(tab) do
        if value == val then return true end
    end
    return false
end

function normalize(angle)
    while angle > 180 do
        angle = angle - 360
    end
    while angle < -180 do
        angle = angle + 360
    end
    return angle
end

local clamp_angles = function(angle)
    angle = angle % 360
    angle = (angle + 360) % 360
    if angle > 180 then
        angle = angle - 360
    end
    return angle
end

skeet_tag_name = "Kikyo"
clan_tag_prev = ""

--------------------
-----REFERENCES-----
--------------------

ragebot, ragebotmode = ui.reference("RAGE", "Aimbot", "Enabled")
rage_selection = ui.reference("RAGE", "Aimbot", "Target hitbox")
autowall = ui.reference("RAGE", "Aimbot", "Automatic penetration")
rageautofire = ui.reference("RAGE", "Aimbot", "Automatic fire")
hitchance = ui.reference("RAGE", "Aimbot", "Minimum hit chance")
min_dmg = ui.reference("RAGE", "Aimbot", "Minimum damage")
FOVS5 = ui.reference("RAGE", "Aimbot", "Maximum FOV")
silent = ui.reference("RAGE", "Aimbot", "Silent aim")
missed_due = ui.reference("RAGE", "Aimbot", "Log misses due to spread")
aacorrect = ui.reference("RAGE", "OTHER", "Anti-aim correction")
removerecoil = ui.reference("RAGE", "Other", "Remove recoil")
doubletap_reff = ui.reference("RAGE", "Other", "Double tap")
dp_a = ui.reference("RAGE", "Other", "Duck peek assist")
force_body_aim = ui.reference("RAGE", "Other", "Force body aim")

aaenabler = ui.reference("AA", "Anti-aimbot angles", "Enabled")
pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
yaw, yaw_num = ui.reference("AA", "Anti-aimbot angles", "Yaw")
yaw_jitter = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
body, body_num = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
freestand_body_yaw_hide = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
lby, _´ = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
edge_yaw_hide = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
freestand_hide, bind_freestand_hide = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
fakelag_enable, fakelag_key = ui.reference("AA", "Fake lag", "Enabled")
ref_fakelag_enable = ui.reference("AA", "Fake lag", "Limit")
variance = ui.reference("AA", "Fake lag", "Variance")
amount = ui.reference("AA", "Fake lag", "Amount")
checkbox_reference, hotkey_reference = ui.reference("AA", "Other", "Slow motion")
slowmot_type = ui.reference("AA", "Other", "Slow motion type")
onshotaa = ui.reference("AA", "Other", "On shot anti-aim")

legitbot, legitbotmode = ui.reference("LEGIT", "Aimbot", "Enabled")

trans = ui.reference("VISUALS", "Effects", "Transparent props")
preticle = ui.reference("VISUALS", "Other ESP", "Penetration reticle")
brightness, adjustment = ui.reference("VISUALS", "Effects", "Brightness adjustment")
thirdpersonk, forcethirdpkey = ui.reference("VISUALS", "Effects", "Force third person (alive)")
thirdpersondead = ui.reference("VISUALS", "Effects", "Force third person (dead)")

nameSteal = ui.reference("Misc", "Miscellaneous", "Steal player name")
default_reference = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")
infiniteduck = ui.reference("MISC", "Movement", "Infinite duck")

selectedplayer = ui.reference("PLAYERS", "Players", "Player list")
resetlist = ui.reference("PLAYERS", "Players", "Reset all")
applyall = ui.reference("PLAYERS", "Adjustments", "Apply to all")
forcebody = ui.reference("PLAYERS", "Adjustments", "Force body yaw")
body_slider = ui.reference("PLAYERS", "Adjustments", "Force body yaw value")
correction_active = ui.reference("PLAYERS", "adjustments", "Correction active")

----------------------
-----UI ADDITIONS-----
----------------------

legitAA = ui.new_checkbox("AA", "Anti-aimbot angles", "Legit anti-aim")
legitAAbase = ui.new_combobox("AA", "Anti-aimbot angles", "\n aa_legit_base", "Manual", "Dynamic")
LegitAAHotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "Anti-aim switch key", true)
LegitAABreaker = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-aim mode", "Maximum", "Smart", "Low desync", "1°", "Jitter")
ui_indicator_combobox4 = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-aim indicator", "Metro")
ui_indicator_color_picker4 = ui.new_color_picker("AA", "Anti-aimbot angles", "Indicator colour", "0", "115", "255", "255")
enableaawm = ui.new_checkbox("AA", "Anti-aimbot angles", "Jitter AA while slow walking")

label_start_A = ui.new_label("LUA", "A", "---[Kikyo Gamesense]---")
adaptive_options2 = ui.new_multiselect("LUA", "A", "[KY] Log Config change", "Log", "Visible")

adaptive_mindmg_box = ui.new_checkbox("LUA", "A", "[KY]  Adaptive Weapon minimum damage")
adaptive_config2 = ui.new_combobox("LUA", "A", "\n dmg weapons", collect_keys(adaptive_weapons))
-----DEFAULT DMG
adaptive_mindmg_auto_normal = ui.new_slider("LUA", "A", "[KY] Auto Minimum damage", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_awp_normal = ui.new_slider("LUA", "A", "[KY]  AWP Minimum damage", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_deagle_normal = ui.new_slider("LUA", "A", "[KY] Deagle Minimum damage", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_global_normal = ui.new_slider("LUA", "A", "[KY] Global Minimum damage", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_pistol_normal = ui.new_slider("LUA", "A", "[KY] Pistol Minimum damage", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_revo_normal = ui.new_slider("LUA", "A", "[KY] Revolver Minimum damage", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_rifle_normal = ui.new_slider("LUA", "A", "[KY] Rifle Minimum damage", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_scout_normal = ui.new_slider("LUA", "A", "[KY Scout Minimum damage", 0, 126, 0, true, "", 1, hp_values)
-----OVERRIDE DMG
adaptive_mindmg_auto = ui.new_slider("LUA", "A", "[KY] Auto Minimum damage Override", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_awp = ui.new_slider("LUA", "A", "[KY] AWP Minimum damage Override", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_deagle = ui.new_slider("LUA", "A", "[KY] Deagle Minimum damage Override", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_global = ui.new_slider("LUA", "A", "[KY] Global Minimum damage Override", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_pistol = ui.new_slider("LUA", "A", "[KY] Pistol Minimum damage Override", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_revo = ui.new_slider("LUA", "A", "[KY] Revolver Minimum damage Override", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_rifle = ui.new_slider("LUA", "A", "[KY] Rifle Minimum damage Override", 0, 126, 0, true, "", 1, hp_values)
adaptive_mindmg_scout = ui.new_slider("LUA", "A", "[KY] Scout Minimum damage Override", 0, 126, 0, true, "", 1, hp_values)

adaptive_mindmg_hotkey = ui.new_hotkey("LUA", "A", "[KY] Scout Minimum damage Override", true)

dynamicfov_enable = ui.new_checkbox("LUA", "A", "[KY] Dynamic FOV")
dynamicfov_weapons = ui.new_combobox("LUA", "A", "\n", "Pistols", "Rifles", "Snipers", "Other")
dynamicfov_auto_factor = ui.new_slider("LUA", "A", "[KY] Dynamic FOV Auto Factor", 0, 250, 100, true, "x", 0.01)
-----PISTOLS
dynamicfov_minpistol = ui.new_slider("LUA", "A", "[KY] Pistol Dynamic FOV Min", 1, 180, 3, true, "°", 1)
dynamicfov_maxpistol = ui.new_slider("LUA", "A", "[KY] Pistol Dynamic FOV Max", 1, 180, 8, true, "°", 1)
-----RIFLES
dynamicfov_minrifle = ui.new_slider("LUA", "A", "[KY] Rifle Dynamic FOV Min", 1, 180, 3, true, "°", 1)
dynamicfov_maxrifle = ui.new_slider("LUA", "A", "[KY] Rifle Dynamic FOV Max", 1, 180, 10, true, "°", 1)
-----SNIPERS
dynamicfov_minscope = ui.new_slider("LUA", "A", "[KY] Snipers Dynamic FOV Min", 1, 180, 3, true, "°", 1)
dynamicfov_maxscope = ui.new_slider("LUA", "A", "[KY] Snipers Dynamic FOV Max", 1, 180, 8, true, "°", 1)
-----OTHER
dynamicfov_minother = ui.new_slider("LUA", "A", "[KY] Other Dynamic FOV Min", 1, 180, 3, true, "°", 1)
dynamicfov_maxother = ui.new_slider("LUA", "A", "[KY] Other Dynamic FOV Max", 1, 180, 10, true, "°", 1)

tm_cb = ui.new_checkbox("LUA", "A", "[KY] Triggermagnet")
rageautofiremagnet = ui.new_hotkey("LUA", "A", "[KY] Triggermagnet", true)
autowalltoggle = ui.new_checkbox("LUA", "A", "[KY] Toggle autowall")
autowalltoggle_key = ui.new_hotkey("LUA", "A", "[KY] Toggle AutoWall", true)
legitautowall = ui.new_checkbox("LUA", "A", "[KY] Legit autowall")
legit_pen_threshold_ref = ui.new_slider("LUA", "A", "[KY] Autowall when X hitboxes visible", 0, 18, 2, true)
overridebutton = ui.new_checkbox("LUA", "A", "[KY] Resolver")
overridekey = ui.new_hotkey("LUA", "A", "[KY] Override key: Right/Left/Off")
flag_enable = ui.new_checkbox("LUA", "A", "[KY] Override Flags")
flag_color = ui.new_color_picker("LUA", "A", "\n flags")
disaa_fd = ui.new_checkbox("LUA", "A", "[KY] Disable Anti-aim while fake ducking")
label_end_A = ui.new_label("LUA", "A", "---[Kikyo Gamesense]---")

label_start_misc = ui.new_label("MISC", "Miscellaneous", "---[Kikyo Gamesense]---")
enabled_reference = ui.new_checkbox("MISC", "Miscellaneous", "[KY] Kikyo tag")
indicators = ui.new_multiselect("MISC", "Miscellaneous", "[KY] Indicators", inds)
move_indicators = ui.new_checkbox("MISC", "Miscellaneous", "[KY] Move Indicators")
move_indicators_slider = ui.new_slider("MISC", "Miscellaneous", "[KY] Move Indicators", 0, 10, 0)
miss_log = ui.new_checkbox("MISC", "Miscellaneous", "[KY] Log misses")
namespam_box = ui.new_checkbox("MISC", "Miscellaneous", "[KY] Name spam")
-----NAME SPAM
local name_saved = false

local spambuttonbutton =  ui.new_button("MISC", "Miscellaneous", "Gamesense > ALL", function()
    local local_player = entity.get_local_player()
    if not name_saved then
        original_name = entity.get_player_name(local_player)
        name_saved = true
    end
    ui.set(nameSteal, true)
    client.set_cvar("name", " Gamesense > ALL")
    client.delay_call(0.15, client.set_cvar, "name", "Gamesense > ALL")
    client.delay_call(0.3, client.set_cvar, "name",  "Gamesense > ALL")
    client.delay_call(0.45, client.set_cvar, "name", "Gamesense > ALL")
    client.delay_call(0.6, client.set_cvar, "name", original_name)
    if original_name == entity.get_player_name(local_player) then
        name_saved = false
    end
end)
label_end_misc = ui.new_label("MISC", "Miscellaneous", "---[Kikyo Gamesense]---")

--------------------------
-----VISIBLE SETTINGS-----
--------------------------

ui.set_visible(adaptive_options2, false)


-----AA SHIT
local function rrrrr()
	if ui.get(legitAA) then
		ui.set_visible(aaenabler, false)
		ui.set_visible(pitch, false)
		ui.set_visible(yaw_base, false)
		ui.set_visible(yaw, false)
		ui.set_visible(yaw_jitter, false)
		ui.set_visible(body, false)
		ui.set_visible(yaw_num, false)
		ui.set_visible(body_num, false)
		ui.set_visible(freestand_body_yaw_hide, false)
		ui.set_visible(lby, false)
		ui.set_visible(edge_yaw_hide, false)
		ui.set_visible(freestand_hide, false)
		ui.set_visible(bind_freestand_hide, false)
		ui.set_visible(limit, false)
		ui.set_visible(slowmot_type, false)
		ui.set_visible(onshotaa, false)
	else
		ui.set_visible(aaenabler, true)
		ui.set_visible(pitch, true)
		ui.set_visible(yaw_base, true)
		ui.set_visible(yaw, true)
		ui.set_visible(yaw_jitter, true)
		ui.set_visible(body, true)
		ui.set_visible(yaw_num, true)
		ui.set_visible(body_num, true)
		ui.set_visible(freestand_body_yaw_hide, true)
		ui.set_visible(lby, true)
		ui.set_visible(edge_yaw_hide, true)
		ui.set_visible(freestand_hide, true)
		ui.set_visible(bind_freestand_hide, true)
		ui.set_visible(limit, true)
		ui.set_visible(slowmot_type, true)
		ui.set_visible(onshotaa, true)
	end
end

-----ADAPTIVE DAMAGE
local function damagevisible()

	damageenable = ui.get(adaptive_mindmg_box)
	adaptiveweapon = ui.get(adaptive_config2)
	
	ui.set_visible(adaptive_config2, damageenable)
	ui.set_visible(adaptive_mindmg_hotkey, damageenable)
	ui.set_visible(adaptive_mindmg_auto_normal, damageenable and adaptiveweapon == "Auto")
	ui.set_visible(adaptive_mindmg_auto, damageenable and adaptiveweapon == "Auto")
	ui.set_visible(adaptive_mindmg_awp_normal, damageenable and adaptiveweapon == "Awp")
	ui.set_visible(adaptive_mindmg_awp, damageenable and adaptiveweapon == "Awp")
	ui.set_visible(adaptive_mindmg_deagle_normal, damageenable and adaptiveweapon == "Desert Eagle")
	ui.set_visible(adaptive_mindmg_deagle, damageenable and adaptiveweapon == "Desert Eagle")
	ui.set_visible(adaptive_mindmg_global_normal, damageenable and adaptiveweapon == "Global")
	ui.set_visible(adaptive_mindmg_global, damageenable and adaptiveweapon == "Global")
	ui.set_visible(adaptive_mindmg_pistol_normal, damageenable and adaptiveweapon == "Pistol")
	ui.set_visible(adaptive_mindmg_pistol, damageenable and adaptiveweapon == "Pistol")
	ui.set_visible(adaptive_mindmg_revo_normal, damageenable and adaptiveweapon == "Revolver")
	ui.set_visible(adaptive_mindmg_revo, damageenable and adaptiveweapon == "Revolver")
	ui.set_visible(adaptive_mindmg_rifle_normal, damageenable and adaptiveweapon == "Rifle")
	ui.set_visible(adaptive_mindmg_rifle, damageenable and adaptiveweapon == "Rifle")
	ui.set_visible(adaptive_mindmg_scout_normal, damageenable and adaptiveweapon == "Scout")
	ui.set_visible(adaptive_mindmg_scout, damageenable and adaptiveweapon == "Scout")
end
ui.set_callback(adaptive_mindmg_box, damagevisible)
ui.set_callback(adaptive_config2, damagevisible)
damagevisible()

-----DYNAMIC FOV
local function dynamicvisible()
	
	fovenable = ui.get(dynamicfov_enable)
	weaponselect = ui.get(dynamicfov_weapons)
	
    ui.set_visible(dynamicfov_auto_factor, fovenable)
    ui.set_visible(dynamicfov_weapons, fovenable)
    ui.set_visible(dynamicfov_minpistol, fovenable and weaponselect == "Pistols")
    ui.set_visible(dynamicfov_maxpistol, fovenable and weaponselect == "Pistols")
    ui.set_visible(dynamicfov_minrifle, fovenable and weaponselect == "Rifles")
    ui.set_visible(dynamicfov_maxrifle, fovenable and weaponselect == "Rifles")
    ui.set_visible(dynamicfov_minscope, fovenable and weaponselect == "Snipers")
    ui.set_visible(dynamicfov_maxscope, fovenable and weaponselect == "Snipers")
    ui.set_visible(dynamicfov_minother, fovenable and weaponselect == "Other")
    ui.set_visible(dynamicfov_maxother, fovenable and weaponselect == "Other")
end

-----RESOLVER
local function resolvervisible()

	resolverenable = ui.get(overridebutton)
	flagenable = ui.get(flag_enable)
	
    ui.set_visible(overridekey, resolverenable)
	ui.set_visible(flag_enable, resolverenable)
	ui.set_visible(flag_color, resolverenable)
end

-----AUTOWALL
local function autowallvisible()
	
	awall = ui.get(autowalltoggle)
	
	ui.set_visible(legitautowall, awall)
	ui.set_visible(legit_pen_threshold_ref, awall)
end

-----INDICATORS
local function indicatorvisible()
	
	moveinds = ui.get(move_indicators)
	
	ui.set_visible(move_indicators_slider, moveinds)
end

client.set_event_callback("paint", indicatorvisible)
client.set_event_callback("paint", damagevisible)
client.set_event_callback("paint", autowallvisible)
client.set_event_callback("paint", resolvervisible)
client.set_event_callback("paint", dynamicvisible)
client.set_event_callback("paint", rrrrr)

indicatorvisible()
damagevisible()
autowallvisible()
dynamicvisible()
resolvervisible()
rrrrr()

-------------------
-----FUNCTIONS-----
-------------------

----------LOGS----------
local function on_aim_miss(e)
	if ui.get(miss_log) then
		ui.set(missed_due, false)
	local reason
	local entityHealth = entity.get_prop(e.target, "m_iHealth")
	if (entityHealth == nil) or (entityHealth <= 0) then
		print_chat(" \x01[\x0CKikyo\x01] The player was killed prior to your shot being able to land")
		return	
	end
    if e.reason == "?" then
    	reason = "resolver"
    else
    	reason = e.reason
    end
	print_chat(" \x01[\x0CGamesense\x01] Missed shot due to " .. reason)
	end
end
client.set_event_callback('aim_miss', on_aim_miss)

----------TRIGGERMAGNET----------
local function on_paint()
	if ui.get(tm_cb, true) then
	local width, height = client.screen_size()
    if ui.get(rageautofiremagnet, true) then
        ui.set(rageautofire, true)
		ui.set(ragebotmode, "Always on")
    else
        ui.set(rageautofire, false)
		ui.set(ragebotmode, "On hotkey")
	end
	end
end
client.set_event_callback("paint", on_paint)

----------CLAN TAG----------
local function time_to_ticks(time)
    return math.floor(time / globals.tickinterval() + .5)
end

local function gamesense_anim(text, indices)
    local text_anim = "               " .. text .. "                      " 
    local tickinterval = globals.tickinterval()
    local tickcount = globals.tickcount() + time_to_ticks(client.latency())
    local i = tickcount / time_to_ticks(0.3)
    i = math.floor(i % #indices)
    i = indices[i+1]+1
    return string.sub(text_anim, i, i+15)
end

local function run_tag_animation()
    if ui.get(enabled_reference) then
        local clan_tag = gamesense_anim("Kikyo", {0, 1, 2, 3, 4, 5, 6, 9, 10, 11 ,12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28})
        if clan_tag ~= clan_tag_prev then
            client.set_clan_tag(clan_tag)
        end
        clan_tag_prev = clan_tag
    end
end

client.set_event_callback("run_command", function(c)
    chokedcmds = c.chokedcommands 
end)

local was_enabled = false
local function on_run_command(c)
    if ui.get(enabled_reference) then
        if (chokedcmds == 0) or not (entity.is_alive(entity.get_local_player())) then
            run_tag_animation()
            was_enabled = true
        end
    elseif (not ui.get(enabled_reference) and not ui.get(default_reference)) and was_enabled then
        client.set_clan_tag("\0")
        was_enabled = false
    end
end
client.set_event_callback("paint", on_run_command)

----------DAMAGE OVERRIDE----------
local function mindmgovr()

	local mindmgbox = ui.get(adaptive_mindmg_box)
	local weaponbox = ui.get(adaptive_config2)
	
	-----AUTO
	if mindmgbox == true and weaponbox == "Auto" and ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_auto))
	elseif mindmgbox == true and weaponbox == "Auto" and not ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_auto_normal))
	end
	-----AWP
	if mindmgbox == true and weaponbox == "Awp" and ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_awp))
	elseif mindmgbox == true and weaponbox == "Awp" and not ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_awp_normal))
	end
	-----DEAGLE
	if mindmgbox == true and weaponbox == "Desert Eagle" and ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_deagle))
	elseif mindmgbox == true and weaponbox == "Desert Eagle" and not ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_deagle_normal))
	end
	-----GLOBAL
	if mindmgbox == true and weaponbox == "Global" and ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_global))
	elseif mindmgbox == true and weaponbox == "Global" and not ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_global_normal))
	end
	-----PISTOL
	if mindmgbox == true and weaponbox == "Pistol" and ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_pistol))
	elseif mindmgbox == true and weaponbox == "Pistol" and not ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_pistol_normal))
	end
	-----REVOLVER
	if mindmgbox == true and weaponbox == "Revolver" and ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_revo))
	elseif mindmgbox == true and weaponbox == "Revolver" and not ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_revo_normal))
	end
	-----RIFLE
	if mindmgbox == true and weaponbox == "Rifle" and ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_rifle))
	elseif mindmgbox == true and weaponbox == "Rifle" and not ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_rifle_normal))
	end
	-----SCOUT
	if mindmgbox == true and weaponbox == "Scout" and ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_scout))
	elseif mindmgbox == true and weaponbox == "Scout" and not ui.get(adaptive_mindmg_hotkey) then
		ui.set(min_dmg, ui.get(adaptive_mindmg_scout_normal))
	end
end
client.set_event_callback("paint", mindmgovr)

----------AUTOWALL----------
-----ON KEY
client.set_event_callback("setup_command", function(cmd)
    if ui.get(autowalltoggle_key) then
		autowallvar1 = true
	else
		autowallvar1 = false
	end
end)

-----LEGIT AUTOWALL
function on_run_command()
    local maximum_fov = ui.get(FOVS5)
    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    local lx, ly, lz = entity.get_prop(local_player, "m_vecOrigin")
    local nearest_player, nearest_player_fov = get_closest_player_to_crosshair(lx, ly, lz, pitch, yaw)
    local view_offset = entity.get_prop(local_player, "m_vecViewOffset[2]")
    local lz = lz + view_offset
    if nearest_player ~= nil and nearest_player_fov <= maximum_fov and ui.get(autowalltoggle, true) and ui.get(legitautowall, true) then
        autowallvar2 = is_player_visible(local_player, lx, ly, lz, nearest_player)
    else
        autowallvar2 = false
    end
end
client.set_event_callback("run_command", on_run_command)

-----AUTOWALL HANDLER
function AWHandler()
    if ui.get(autowalltoggle, true) then
    else
        return
    end
    if autowallvar1 or autowallvar2 then
        ui.set(autowall, true)
    else
        ui.set(autowall, false)
    end
end
client.set_event_callback("paint", AWHandler)

----------SCRIPTLOCK----------
client.color_log(255, 0, 0, "-----------------------------")
client.color_log(255, 0, 0, "Welcome! Kikyo Gamesense User")
client.color_log(255, 0, 0, "有问题请联系 QQ68373133")
client.color_log(255, 0, 0, "-----------------------------")

----------DYNAMIC LEGIT AA----------
local world_to_screen = function(x, y, z, func)
    local x, y = renderer.world_to_screen(x, y, z)
    if x ~= nil and y ~= nil then
        func(x, y)
    end
end

local leftdamage = 0
local rightdamage = 0
local rad2deg = function(rad)
    return (rad * 180 / math.pi)
end
local deg2rad = function(deg)
    return (deg * math.pi / 180)
end
local trace_line = function(entity, start, _end)
    return client.trace_line(entity, start.x, start.y, start.z, _end.x, _end.y, _end.z)
end

local screenx, screeny = client.screen_size()

local vector = function(x, y, z)
    x = x ~= nil and x or 0
    y = y ~= nil and y or 0
    z = z ~= nil and z or 0

    return {
        ["x"] = x,
        ["y"] = y,
        ["z"] = z
    }
end

local vector_add = function(vector1, vector2)
    return {
        ["x"] = vector1.x + vector2.x,
        ["y"] = vector1.y + vector2.y,
        ["z"] = vector1.z + vector2.z
    }
end

local vector_substract = function(vector1, vector2)
    return {
        ["x"] = vector1.x - vector2.x,
        ["y"] = vector1.y - vector2.y,
        ["z"] = vector1.z - vector2.z
    }
end

function slot136(slot0, slot1)
    for slot5 = 1, #slot0, 1 do
        if slot0[slot5] == slot1 then
            return true
        end
    end
    return false
end

function slot137(slot0, slot1)
    for slot5, slot6 in ipairs(slot0) do
        if slot6 == slot1 then
            return true, slot5
        end
    end
    return false
end

function slot138()
    if ui.get(otherref.tp_alive) and ui.get(otherref.tp_alive_key) then
        ui.set_visible(otherref.tp_dead, true)
    else
        ui.set_visible(otherref.tp_dead, false)
    end
end

local clamp_angles = function(angle)
    angle = angle % 360
    angle = (angle + 360) % 360
    if angle > 180 then
        angle = angle - 360
    end
    return angle
end

function LAASetup()
    if ui.get(legitAA) then
        if ui.get(legitAAbase) == "Manual" then
            ui.set_visible(LegitAAHotkey, true)
        elseif ui.get(legitAAbase) == "Dynamic" then
            ui.set_visible(LegitAAHotkey, false)
        end
    else
        ui.set_visible(LegitAAHotkey, false)
    end
end

function LAAFunc()
    -----LEGITAA
    local legita = ui.get(legitAA)
    local base = ui.get(legitAAbase)
    local aamoving = ui.get(enableaawm)
    ui.set_visible(LegitAABreaker, legita)
    ui.set_visible(legitAAbase, legita)
    ui.set_visible(ui_indicator_combobox4, legita)
    ui.set_visible(ui_indicator_color_picker4, legita)
    ui.set_visible(LegitAAHotkey, legita and base == "Manual")
    -----LEGITAA WHILE MOVING
    ui.set_visible(enableaawm, legita)
    if not ui.get(legitAA) then
        LAASetup()
        ui.set(yaw, "Off")
        ui.set(body, "Off")
        ui.set(freestand_hide, "-")
        ui.set(bind_freestand_hide, "On hotkey")
        ui.set(aaenabler, false)
    elseif ui.get(legitAA) then
        LAASetup()
        ui.set(yaw, "180")
        ui.set(yaw_num, 180)
        ui.set(body, "Static")
        ui.set(freestand_hide, "-")
        ui.set(bind_freestand_hide, "On hotkey")
        ui.set(aaenabler, true)
    end
end

LAAFunc()
ui.set_callback(legitAA, LAAFunc)
ui.set_callback(legitAAbase, LAAFunc)
ui.set_callback(LegitAAHotkey, LAAFunc)
ui.set_callback(LegitAABreaker, LAAFunc)

local get_atan = function(ent, eye_pos, camera)
    local data = { id = nil, dst = 2147483647, fov = 360 }
    local screenx, screeny = client_screen_size()
    local crosshair = screenx / 2, screeny / 2
    for i = 0, 19 do
        local hitbox = vector(entity.hitbox_position(ent, i))
        local ext = vector_substract(hitbox, eye_pos)
        local yaw = rad2deg(math.atan2(ext.y, ext.x))
        local pitchhide = -rad2deg(math.atan2(ext.z, math.sqrt(ext.x ^ 2 + ext.y ^ 2)))
        local yaw_dif = math.abs(camera.y % 360 - yaw % 360) % 360
        local pitchhide_dif = math.abs(camera.x - pitchhide) % 360
        if yaw_dif > 180 then
            yaw_dif = 360 - yaw_dif
        end
        local dst = math.sqrt(yaw_dif ^ 2 + pitchhide_dif ^ 2)
        local dstcorrect = math.sqrt(ext.x ^ 2 + ext.y ^ 2 + ext.z ^ 2)
        if dstcorrect < data.dst then
            data.dst = dstcorrect
            data.id = i
            data.fov = yaw - crosshair
        end
    end
    return data.id, data.dst, data.fov
end

local function getdistance()
    local get_players = entity.get_players(true)
    if #get_players == 0 then
        return
    end
    local eye_pos = vector(client.eye_position())
    local camera = vector(client.camera_angles())
    camera.z = z_pos ~= nil and 64 or camera.z
    local distance = math.huge
    local closest_enemy = nil
    local adv_fov = 1000
    local screenx, screeny = client_screen_size()
    local crosshair = screenx / 2, screeny / 2
    for i = 1, #get_players do
        local hitbox_id, dist, fov = get_atan(get_players[i], eye_pos, camera)
        if distance > dist then
            distance = dist
            hitbox = hitbox_id
            closest_enemy = get_players[i]
            adv_fov = fov
        end
    end
    return closest_enemy, hitbox, distance, adv_fov
end

function slot158()
    if ui.get(yaw) == "Off" then
        return
    end
    if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then
        return
    end
    local screenx, screeny = client.screen_size()
    local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_angEyeAngles")
    local divisor = screenx / 2
    local divisor2 = screeny / 2
    local size = 15 * cvar.cl_crosshairsize:get_float() * 0.67
    if ui.get(yaw_num) ~= 180 and ui.get(yaw_num) ~= -180 then
        render_text(divisor, divisor2, 255, 0, 0, 255, "c-", 0, "AA IS BROKEN, SET YAW SLIDER TO 180 OR -180")
        render_text(divisor, divisor2 + 10, 255, 0, 0, 255, "c-", 0, "CURRENT YAW: ", ly)
    end
end

function slot159()
    ui.set(pitch, "Off")
    ui.set(yaw_base, "Local view")
    ui.set(yaw, "180")
    ui.set(yaw_jitter, "Off")
    ui.set(edge_yaw_hide, false)
    ui.set(freestand_body_yaw_hide, false)
    ui.set(bind_freestand_hide, "On hotkey")
end

function slot160()
    if not ui.get(legitAA) or ui.get(dp_a) or ui.get(legitAAbase) == "Dynamic" or entity.get_local_player() == nil or entity.get_prop(entity.get_local_player(), "m_lifeState") ~= 0 then
        return
    end
    if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then
        return
    end
    local screenx, screeny = client.screen_size()
    local halfx = screenx / 2
    local halfy = screeny / 2
    if ui.get(legitAA) then
        if ui.get(legitAAbase) == "Manual" then
            ui.set_visible(LegitAAHotkey, true)
            ui.set(LegitAAHotkey, "Toggle")
            if ui.get(LegitAAHotkey) then
                slot159()
                ui.set(yaw_num, 180)
                ui.set(body_num, 90)
                slot94 = "LEFT"
            else
                slot159()
                ui.set(yaw_num, 180)
                ui.set(body_num, -90)
                slot94 = "RIGHT"
            end
        else
            ui.set_visible(LegitAAHotkey, false)
        end
    end
end

local function do_legit_aa()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    local m_vecOrigin = vector(entity.get_prop(local_player, "m_vecOrigin"))
    local m_vecViewOffset = vector(entity.get_prop(local_player, "m_vecViewOffset"))
    local m_vecOrigin = vector_add(m_vecOrigin, m_vecViewOffset)
    local radius = 20 + 110 + 0.1
    local step = math.pi * 2.0 / edge_count[8]
    local camera = vector(client.camera_angles())
    local central = deg2rad(math.floor(camera.y + 0.5))
    local data = {
        fraction = 1,
        surpassed = false,
        angle = vector(0, 0, 0),
        var = 0,
        side = "LAST KNOWN"
    }
    for a = central, math.pi * 3.0, step do
        if a == central then
            central = clamp_angles(rad2deg(a))
            local trace_line = function(entity, start, _end)
                return client.trace_line(entity, start.x, start.y, start.z, _end.x, _end.y, _end.z)
            end
        end
        local clm = clamp_angles(central - rad2deg(a))
        local abs = math.abs(clm)
        if abs < 90 and abs > 1 then
            local side = "LAST KNOWN"
            local location = vector(
                    radius * math.cos(a) + m_vecOrigin.x,
                    radius * math.sin(a) + m_vecOrigin.y,
                    m_vecOrigin.z
            )
            local _fr, entindex = client.trace_line(local_player, m_vecOrigin.x, m_vecOrigin.y, m_vecOrigin.z, location.x, location.y, location.z)
            if math.floor(clm + 0.5) < -21 then
                side = "RIGHT"
            end
            if math.floor(clm + 0.5) > 21 then
                side = "LEFT"
            end
            local fr_info = {
                fraction = _fr,
                surpassed = (_fr < 1),
                angle = vector(0, clamp_angles(rad2deg(a)), 0),
                var = math.floor(clm + 0.5),
                side = side --[ 0 - center / 1 - right / 2 - left ]
            }
            if data.fraction > _fr then
                data = fr_info
            end
        end
    end
    return data
end

function dodynamic()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    local local_player = entity.get_local_player()
    local topX, topY, botX, botY, alpha = entity.get_bounding_box(client_draw_text, local_player)
    local origin = vector(entity.get_prop(local_player, "m_vecOrigin"))
    local collision = (entity.get_prop(local_player, "m_Collision"))
    local vecmin = vector(entity.get_prop(local_player, "m_vecMins"))
    local vecmax = vector(entity.get_prop(local_player, "m_vecMaxs"))
    local min = vector_add(vecmin, origin)
    local max = vector_add(vecmax, origin)
    if not ui.get(legitAA) or ui.get(dp_a) or ui.get(legitAAbase) == "Manual" then
        return
    end
    if ui.get(legitAA) and ui.get(legitAAbase) == "Dynamic" then
        if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then
            return
        end
        local data = do_legit_aa()
        if data == nil then
            return
        end
        if data.fraction < 1 then
            slot159()
            ui.set(body_num, data.var > 0 and 180 or -180)
            ui.set(yaw_num, -180)
        end
    end
end

local function fyls()
    if ui.get(legitAA) == false then
        return
    else
        if ui.get(LegitAABreaker) == "Smart" then
            ui.set(limit, 60)
            ui.set(body, "Static")
        elseif ui.get(LegitAABreaker) == "Maximum" then
            ui.set(limit, 60)
            ui.set(body, "Static")
		elseif ui.get(LegitAABreaker) == "Low desync" then
			ui.set(lby, "Opposite")
            ui.set(body, "Static")			
        elseif ui.get(LegitAABreaker) == "1°" then
            ui.set(limit, 1)
            ui.set(body, "Static")
        elseif ui.get(LegitAABreaker) == "Jitter" then
            ui.set(body, "Static")
        end
    end
end
client.set_event_callback("paint", fyls)

local player_is_alive
local spamtime = 0
local antiresolve
local delay_time = 0
local inverse_time = 0
local anti_resolve_timer = 0
local change_value = 60
local reached_lowest = false
local anti_resolve_timer = globals.curtime()


function anti_resolver3()
    if ui.get(legitAA, true) then
    else
        return
    end
    if ui.get(LegitAABreaker) == "Low desync" then ----- DON'T JUDGE :D
        if globals.realtime() - 0.003 >= anti_resolve_timer then
            ui.set(limit, change_value)
            if(reached_lowest == false) then
                change_value = change_value - 1
				if(change_value == 15) then
					reached_lowest = true
				end
            elseif(reached_lowest == true) then
                change_value = change_value + 1
				if(change_value == 35) then
					reached_lowest = false
				end                
            end          
            anti_resolve_timer = globals.realtime()
        end
    end
end
client.set_event_callback("run_command", anti_resolver3)


local function anti_resolver3()
    if ui.get(legitAA, true) then
    else
        return
    end
        if ui.get(LegitAABreaker) == "Jitter" then
        	ui.set(lby, "Opposite")
            if globals.realtime() >= anti_resolve_timer then
                client.delay_call(0.08, ui.set, limit, 60)
                client.delay_call(0.16, ui.set, limit, 2)

                anti_resolve_timer = globals.realtime() + 0.1
            end
        end
    end
client.set_event_callback("run_command", anti_resolver3)

before = false

local function movingaa()
    local x, y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local speed = math.sqrt(x^2 + y^2)
    if (ui.get(enableaawm, true) and ui.get(enableaawm) and ui.get(hotkey_reference) and before == false and speed > 5) then
        stored_aabreaker = ui.get(LegitAABreaker)
        stored_lby = ui.get(lby)
        ui.set(LegitAABreaker, "Jitter")
        before = true
    elseif (ui.get(enableaawm, true) and ui.get(enableaawm) and not ui.get(hotkey_reference) or speed < 5) and before == true then
        ui.set(LegitAABreaker, stored_aabreaker)
        ui.set(lby, stored_lby)
        before = false
    end
end
client.set_event_callback("run_command", movingaa)

function slot163()
    if ui.get(legitAA) then
        if ui.get(LegitAABreaker) == "Maximum" then
            ui.set(lby, "Opposite")
        elseif ui.get(LegitAABreaker) == "Smart" then
            ui.set(lby, "Eye yaw")
		elseif ui.get(LegitAABreaker) == "Low desync" then
			ui.set(lby, "Opposite")
		elseif ui.get(LegitAABreaker) == "1°" then
			ui.set(lby, "Sway")
		elseif ui.get(LegitAABreaker) == "Jitter" then
			ui.set(lby, "Opposite")
        end
    else
        ui.set(lby, "Off")
    end
end

client.set_event_callback("run_command", function()
    slot158()
    slot160()
end)

client.set_event_callback("paint", function(c)
    slot163()
    dodynamic()
end)

client.set_event_callback("game_newmap", function()
end)

----------AA INDICATOR----------
function on_paint(c)
    local scrsize_x, scrsize_y = client.screen_size()
    local center_x, center_y = scrsize_x / 2, scrsize_y / 2.003
    local indicator = ui.get(ui_indicator_combobox4)
    local indicator_r, indicator_g, indicator_b, indicator_a = ui.get(ui_indicator_color_picker4)
    if ui.get(body_num) == 90 and indicator == "Metro" and ui.get(legitAA) == true or ui.get(body_num) == 180 and indicator == "Metro" and ui.get(legitAA) == true then
        client.draw_text(c, center_x - 45, center_y, indicator_r, indicator_g, indicator_b, indicator_a, "c+", 0, "<")
    elseif ui.get(body_num) == -90 and indicator == "Metro" and ui.get(legitAA) == true or ui.get(body_num) == -180 and indicator == "Metro" and ui.get(legitAA) == true then
        client.draw_text(c, center_x + 45, center_y, indicator_r, indicator_g, indicator_b, indicator_a, "c+", 0, ">")
    end
	
end
err = client.set_event_callback("paint", on_paint)

----------DYNAMIC FOV----------

dynamicfov_new_fov = 0
bool_in_fov = false
closest_enemy = nil

-----PISTOLS
function dynamicfov_logicpistol()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    if ui.get(dynamicfov_enable, true) then
    else
        return
    end
    if ui.get(adaptive_config2) == "Desert Eagle" then
    elseif ui.get(adaptive_config2) == "Pistol" then
    elseif ui.get(adaptive_config2) == "Revolver" then
    else
        return
    end
    local old_fov = ui.get(FOVS5)
    dynamicfov_new_fov = old_fov
    local enemy_players = entity.get_players(true)
    local min_fov = ui.get(dynamicfov_minpistol)
    local max_fov = ui.get(dynamicfov_maxpistol)
    if min_fov > max_fov then
        local store_min_fov = min_fov
        min_fov = max_fov
        max_fov = store_min_fov
    end
    if #enemy_players ~= 0 then
        local own_x, own_y, own_z = client.eye_position()
        local own_pitch, own_yaw = client.camera_angles()
        closest_enemy = nil
        local closest_distance = 999999999
        for i = 1, #enemy_players do
            local enemy = enemy_players[i]
            local enemy_x, enemy_y, enemy_z = entity.hitbox_position(enemy, 0)
            local x = enemy_x - own_x
            local y = enemy_y - own_y
            local z = enemy_z - own_z
            local yaw = ((math.atan2(y, x) * 180 / math.pi))
            local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 180 / math.pi)
            local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
            local pitch_dif = math.abs(own_pitch - pitch) % 360
            if yaw_dif > 180 then
                yaw_dif = 360 - yaw_dif
            end
            local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))
            if closest_distance > real_dif then
                closest_distance = real_dif
                closest_enemy = enemy
            end
        end
        if closest_enemy ~= nil then
            local closest_enemy_x, closest_enemy_y, closest_enemy_z = entity.hitbox_position(closest_enemy, 0)
            local real_distance = math.sqrt(math.pow(own_x - closest_enemy_x, 2) + math.pow(own_y - closest_enemy_y, 2) + math.pow(own_z - closest_enemy_z, 2))
            dynamicfov_new_fov = (3800 / real_distance) * (ui.get(dynamicfov_auto_factor) * 0.01)
            if (dynamicfov_new_fov > max_fov) then
                dynamicfov_new_fov = max_fov
            elseif dynamicfov_new_fov < min_fov then
                dynamicfov_new_fov = min_fov
            end
        end
        dynamicfov_new_fov = math.floor(dynamicfov_new_fov + 0.5)
        if (dynamicfov_new_fov > closest_distance) then
            bool_in_fov = true
        else
            bool_in_fov = false
        end
    else
        dynamicfov_new_fov = min_fov
        bool_in_fov = false
    end
    if dynamicfov_new_fov ~= old_fov then
        ui.set(FOVS5, dynamicfov_new_fov)
    end
end

function on_paintpistol(ctx)
    dynamicfov_logicpistol()
end
client.set_event_callback("paint", on_paintpistol)

-----RILFELS
function dynamicfov_logicrifle()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    if ui.get(dynamicfov_enable, true) then
    else
        return
    end
    if ui.get(adaptive_config2) == "Rifle" then
    else
        return
    end
    local old_fov = ui.get(FOVS5)
    dynamicfov_new_fov = old_fov
    local enemy_players = entity.get_players(true)
    local min_fov = ui.get(dynamicfov_minrifle)
    local max_fov = ui.get(dynamicfov_maxrifle)
    if min_fov > max_fov then
        local store_min_fov = min_fov
        min_fov = max_fov
        max_fov = store_min_fov
    end
    if #enemy_players ~= 0 then
        local own_x, own_y, own_z = client.eye_position()
        local own_pitch, own_yaw = client.camera_angles()
        closest_enemy = nil
        local closest_distance = 999999999
        for i = 1, #enemy_players do
            local enemy = enemy_players[i]
            local enemy_x, enemy_y, enemy_z = entity.hitbox_position(enemy, 0)
            local x = enemy_x - own_x
            local y = enemy_y - own_y
            local z = enemy_z - own_z
            local yaw = ((math.atan2(y, x) * 180 / math.pi))
            local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 180 / math.pi)
            local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
            local pitch_dif = math.abs(own_pitch - pitch) % 360
            if yaw_dif > 180 then
                yaw_dif = 360 - yaw_dif
            end
            local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))
            if closest_distance > real_dif then
                closest_distance = real_dif
                closest_enemy = enemy
            end
        end
        if closest_enemy ~= nil then
            local closest_enemy_x, closest_enemy_y, closest_enemy_z = entity.hitbox_position(closest_enemy, 0)
            local real_distance = math.sqrt(math.pow(own_x - closest_enemy_x, 2) + math.pow(own_y - closest_enemy_y, 2) + math.pow(own_z - closest_enemy_z, 2))
            dynamicfov_new_fov = (3800 / real_distance) * (ui.get(dynamicfov_auto_factor) * 0.01)
            if (dynamicfov_new_fov > max_fov) then
                dynamicfov_new_fov = max_fov
            elseif dynamicfov_new_fov < min_fov then
                dynamicfov_new_fov = min_fov
            end
        end
        dynamicfov_new_fov = math.floor(dynamicfov_new_fov + 0.5)
        if (dynamicfov_new_fov > closest_distance) then
            bool_in_fov = true
        else
            bool_in_fov = false
        end
    else
        dynamicfov_new_fov = min_fov
        bool_in_fov = false
    end
    if dynamicfov_new_fov ~= old_fov then
        ui.set(FOVS5, dynamicfov_new_fov)
    end
end

function on_paintrifle(ctx)
    dynamicfov_logicrifle()
end
client.set_event_callback("paint", on_paintrifle)

-----SCOPED WEAPONS
function dynamicfov_logicscope()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    if ui.get(dynamicfov_enable, true) then
    else
        return
    end
    if ui.get(adaptive_config2) == "Awp" then
    elseif ui.get(adaptive_config2) == "Auto" then
    elseif ui.get(adaptive_config2) == "Scout" then
    else
        return
    end
    local old_fov = ui.get(FOVS5)
    dynamicfov_new_fov = old_fov
    local enemy_players = entity.get_players(true)
    local min_fov = ui.get(dynamicfov_minscope)
    local max_fov = ui.get(dynamicfov_maxscope)
    if min_fov > max_fov then
        local store_min_fov = min_fov
        min_fov = max_fov
        max_fov = store_min_fov
    end
    if #enemy_players ~= 0 then
        local own_x, own_y, own_z = client.eye_position()
        local own_pitch, own_yaw = client.camera_angles()
        closest_enemy = nil
        local closest_distance = 999999999
        for i = 1, #enemy_players do
            local enemy = enemy_players[i]
            local enemy_x, enemy_y, enemy_z = entity.hitbox_position(enemy, 0)
            local x = enemy_x - own_x
            local y = enemy_y - own_y
            local z = enemy_z - own_z
            local yaw = ((math.atan2(y, x) * 180 / math.pi))
            local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 180 / math.pi)
            local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
            local pitch_dif = math.abs(own_pitch - pitch) % 360
            if yaw_dif > 180 then
                yaw_dif = 360 - yaw_dif
            end
            local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))
            if closest_distance > real_dif then
                closest_distance = real_dif
                closest_enemy = enemy
            end
        end
        if closest_enemy ~= nil then
            local closest_enemy_x, closest_enemy_y, closest_enemy_z = entity.hitbox_position(closest_enemy, 0)
            local real_distance = math.sqrt(math.pow(own_x - closest_enemy_x, 2) + math.pow(own_y - closest_enemy_y, 2) + math.pow(own_z - closest_enemy_z, 2))
            dynamicfov_new_fov = (3800 / real_distance) * (ui.get(dynamicfov_auto_factor) * 0.01)
            if (dynamicfov_new_fov > max_fov) then
                dynamicfov_new_fov = max_fov
            elseif dynamicfov_new_fov < min_fov then
                dynamicfov_new_fov = min_fov
            end
        end
        dynamicfov_new_fov = math.floor(dynamicfov_new_fov + 0.5)
        if (dynamicfov_new_fov > closest_distance) then
            bool_in_fov = true
        else
            bool_in_fov = false
        end
    else
        dynamicfov_new_fov = min_fov
        bool_in_fov = false
    end
    if dynamicfov_new_fov ~= old_fov then
        ui.set(FOVS5, dynamicfov_new_fov)
    end
end

function on_paintscope(ctx)
    dynamicfov_logicscope()
end
client.set_event_callback("paint", on_paintscope)

-----SCOPED WEAPONS
function dynamicfov_logicother()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    if ui.get(dynamicfov_enable, true) then
    else
        return
    end
    if ui.get(adaptive_config2) == "Global" then
    else
        return
    end
    local old_fov = ui.get(FOVS5)
    dynamicfov_new_fov = old_fov
    local enemy_players = entity.get_players(true)
    local min_fov = ui.get(dynamicfov_minother)
    local max_fov = ui.get(dynamicfov_maxother)
    if min_fov > max_fov then
        local store_min_fov = min_fov
        min_fov = max_fov
        max_fov = store_min_fov
    end
    if #enemy_players ~= 0 then
        local own_x, own_y, own_z = client.eye_position()
        local own_pitch, own_yaw = client.camera_angles()
        closest_enemy = nil
        local closest_distance = 999999999
        for i = 1, #enemy_players do
            local enemy = enemy_players[i]
            local enemy_x, enemy_y, enemy_z = entity.hitbox_position(enemy, 0)
            local x = enemy_x - own_x
            local y = enemy_y - own_y
            local z = enemy_z - own_z
            local yaw = ((math.atan2(y, x) * 180 / math.pi))
            local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 180 / math.pi)
            local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
            local pitch_dif = math.abs(own_pitch - pitch) % 360
            if yaw_dif > 180 then
                yaw_dif = 360 - yaw_dif
            end
            local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))
            if closest_distance > real_dif then
                closest_distance = real_dif
                closest_enemy = enemy
            end
        end
        if closest_enemy ~= nil then
            local closest_enemy_x, closest_enemy_y, closest_enemy_z = entity.hitbox_position(closest_enemy, 0)
            local real_distance = math.sqrt(math.pow(own_x - closest_enemy_x, 2) + math.pow(own_y - closest_enemy_y, 2) + math.pow(own_z - closest_enemy_z, 2))
            dynamicfov_new_fov = (3800 / real_distance) * (ui.get(dynamicfov_auto_factor) * 0.01)
            if (dynamicfov_new_fov > max_fov) then
                dynamicfov_new_fov = max_fov
            elseif dynamicfov_new_fov < min_fov then
                dynamicfov_new_fov = min_fov
            end
        end
        dynamicfov_new_fov = math.floor(dynamicfov_new_fov + 0.5)
        if (dynamicfov_new_fov > closest_distance) then
            bool_in_fov = true
        else
            bool_in_fov = false
        end
    else
        dynamicfov_new_fov = min_fov
        bool_in_fov = false
    end
    if dynamicfov_new_fov ~= old_fov then
        ui.set(FOVS5, dynamicfov_new_fov)
    end
end

function on_paintother(ctx)
    dynamicfov_logicother()
end
client.set_event_callback("paint", on_paintother)

----------RESOLVER----------
function reset_target(r)
    if ui.get(overridebutton, true) then
    else
        return
    end
    client.log(r)
    ui.set(selectedplayer, r)
    ui.set(forcebody, false)
    ui.set(body_slider, 0)
    ui.set(applyall, true)
end

function setbodyyaw()
    if ui.get(overridebutton, true) then
    else
        return
    end
    if ui.get(body_slider) == 0 and canManual == true then
        ui.set(forcebody, true)
        ui.set(body_slider, 60)
        ui.set(applyall, true)
        canManual = false
    end
    if ui.get(body_slider) == 60 and canManual == true then
        ui.set(forcebody, true)
        ui.set(body_slider, -60)
        ui.set(applyall, true)
        canManual = false
    end
    if ui.get(body_slider) == -60 and canManual == true then
        ui.set(forcebody, false)
        ui.set(body_slider, 0)
        ui.set(applyall, true)
        canManual = false
    end
end

function on_paint()
    if ui.get(overridebutton, true) then
    else
        return
    end
    if ui.get(overridekey) then
        if canManual == true then
            setbodyyaw()
            canManual = false
        end
    else
        canManual = true
    end
end
client.set_event_callback("paint", on_paint)

client.set_event_callback("run_command", function(c)
    if ui.get(overridebutton, true) and ui.get(flag_enable, true) then
    else
        return
    end
    if not ui.is_menu_open() then
        bruteforce_ents = { }
        client.update_player_list()
        for _, v in pairs(entity.get_players(true)) do
            if ui.get(body_slider) == -60 or ui.get(body_slider) == 60 then
                table.insert(bruteforce_ents, v)
                entity.set_prop(v, "m_flDetectedByEnemySensorTime")
            else
                entity.set_prop(v, "m_flDetectedByEnemySensorTime", 0)
            end
        end
    end
end)

client.set_event_callback("paint", function()
    if ui.get(overridebutton, true) and ui.get(flag_enable, true) then
    else
        return
    end
    local r, g, b, a = ui.get(flag_color)
    for _, v in pairs(bruteforce_ents) do
        local bounding_box = { entity.get_bounding_box(v) }
        if #bounding_box == 5 and bounding_box[5] ~= 0 then
            local center = bounding_box[1] + (bounding_box[3] - bounding_box[1]) / 2
            if ui.get(body_slider) == 60 then
                renderer.text(center, bounding_box[2] - 18, r, g, b, a * bounding_box[5], "bc", 0, "LEFT")
            elseif ui.get(body_slider) == -60 then
                renderer.text(center, bounding_box[2] - 18, r, g, b, a * bounding_box[5], "bc", 0, "RIGHT")
            end
        end
    end
end)


----------DISABLE AA WHILE FD----------
default = false

local function disable_aa_fd()
	if ui.get(disaa_fd) and ui.get(dp_a) and default == false then
		stored_aa = ui.get(legitAA)
		ui.set(legitAA, false)
		default = true
	elseif ui.get(disaa_fd) and not ui.get(dp_a) and default == true then
		ui.set(legitAA, stored_aa)
		default = false
	end
end
client.set_event_callback("paint", disable_aa_fd)	

----------INDICATORS----------
local function on_paint(c)
	if ui.get(move_indicators) then
		for i = 0, ui.get(move_indicators_slider) do
			renderer.indicator(255, 255, 255, 0, "Move")
		end
	end
	-----FAKE
	if inArr(ui.get(indicators), inds[1]) then
		if ui.get(aaenabler) and ui.get(body) ~= "Off" and entity.is_alive(entity.get_local_player()) then
			local color = { 255-(angle*2.29824561404), angle*3.42105263158, angle*0.22807017543 }
			renderer.indicator(color[1], color[2], color[3], 255, "FAKE")
		end
	end
	-----AUTOWALL
	local w, h = client.screen_size()
	local center = { w/2, h/2 }

	if inArr(ui.get(indicators), inds[2]) then
		if ui.get(autowall) then
			local y11 = (-1 >= 0) and (center[2] - -1) or (center[2] - -15)
			renderer.text(center[1], y11, 255, 0, 0, 255, "-cb", 0, "AUTOWALL")
		end
	end
	-----BODY AIM
	if inArr(ui.get(indicators), inds[3]) then
		if ui.get(force_body_aim, true) then
			renderer.indicator(152, 204, 0, 255, "BAIM")
		end
	end
	-----TRIGGERMAGNET
	if inArr(ui.get(indicators), inds[4]) then
		if ui.get(rageautofiremagnet) == true then
			renderer.indicator(152, 204, 0, 255, "TM")
		end
	end
	-----FOV
	if inArr(ui.get(indicators), inds[5]) then
		renderer.indicator(152, 204, 0, 255, "FOV: ", ui.get(FOVS5))
	end
	-----DAMAGE OVERRIDE
	if inArr(ui.get(indicators), inds[6]) then
        if ui.get(min_dmg) ~= 0 then
            renderer.indicator(255, 255, 255, 255, ui.get(min_dmg))
        elseif ui.get(min_dmg) == 0 then
            renderer.indicator(255, 255, 255, 255, "Auto")
        end
    end
	-----OVERRIDE RESOLVER
	if inArr(ui.get(indicators), inds[7]) then
        if ui.get(overridebutton, true) and ui.get(body_slider) == 60 then
            renderer.indicator(152, 204, 0, 255, "R:LEFT")
        elseif ui.get(overridebutton, true) and ui.get(body_slider) == -60 then
            renderer.indicator(152, 204, 0, 255, "R:RIGHT")
        elseif ui.get(overridebutton, true) and ui.get(body_slider) == 0 then
            renderer.indicator(152, 204, 0, 255, "R:OFF")
        end
    end
end
client.set_event_callback("paint", on_paint)

client.set_event_callback("setup_command", function(c)
	if c.chokedcommands == 0 then
		if c.in_use == 1 then
			angle = 0
		else
			angle = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))
		end
	end
end)

	-----WATERMARK