local vector = require("vector")
local function contains(tbl, val)
    if not tbl or type(tbl) ~= "table" then
        error("[contains] tbl is not a valid table.")
        return false
    end

    for i=1, #tbl do
        if tbl[i] == val then 
            return true
        end
    end
    return false
end

local function multi_exec(func, list)
    if func == nil then
        return
    end
    
    for ref, val in pairs(list) do
        func(ref, val)
    end
end

local damage_labels = { [0] = "Auto" }
for i = 1, 126 do
    damage_labels[i] = i <= 100 and tostring(i) or "HP+" .. tostring(i - 100)
end

local rage = {
    ["enabled"]         = ui.reference("RAGE", "Aimbot", "Enabled"),
    ["selection"]       = ui.reference("RAGE", "Aimbot", "Target selection"),
    ["hitbox"]          = ui.reference("RAGE", "Aimbot", "Target hitbox"),
    ["multipoint"]      ={ui.reference("RAGE", "Aimbot", "Multi-point")},
    ["multipoint_scale"]= ui.reference("RAGE", "Aimbot", "Multi-point scale"),
    ["prefersafe"]      = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
    ["forcesafe"]       = ui.reference("RAGE", "Aimbot", "Force safe point"),
    ["forcesafe_limbs"] = ui.reference("RAGE", "Aimbot", "Force safe point on limbs"),
    ["autofire"]        = ui.reference("RAGE", "Aimbot", "Automatic fire"),
    ["autopenetration"] = ui.reference("RAGE", "Aimbot", "Automatic penetration"),
    ["silent"]          = ui.reference("RAGE", "Aimbot", "Silent aim"),
    ["hitchance"]       = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    ["damage"]          = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    ["aimstep"]         = ui.reference("RAGE", "Aimbot", "Reduce aim step"),
    ["fov"]             = ui.reference("RAGE", "Aimbot", "Maximum FOV"),
    ["log_spread"]      = ui.reference("RAGE", "Aimbot", "Log misses due to spread"),
    ["mitigations"]     = ui.reference("RAGE", "Aimbot", "Low FPS mitigations"),
    ["Autoscope"]       = ui.reference("RAGE", "Aimbot", "Automatic scope"),
    ["recoil"]          = ui.reference("RAGE", "Other", "Remove recoil"),
    ["boost"]           = ui.reference("RAGE", "Other", "Accuracy boost"),
    ["delay_shot"]      = ui.reference("RAGE", "Other", "Delay shot"),
    ["quickstop"]       = ui.reference("RAGE", "Other", "Quick stop"),
    ["qs_options"]      = ui.reference("RAGE", "Other", "Quick stop options"),
    ["correction"]      = ui.reference("RAGE", "Other", "Anti-aim correction"),
    ["preferbody"]      = ui.reference("RAGE", "Other", "Prefer body aim"),
    ["disablers"]       = ui.reference("RAGE", "Other", "Prefer body aim disablers"),
    ["doubletap"]       = ui.reference("RAGE", "Other", "Double tap"),
    ["doubletap_mode"]  = ui.reference("RAGE", "Other", "Double tap mode"),
}
local current_weapon = ui.new_combobox("LUA", "A", "Selected weapon", "AWP", "Auto-sniper", "Scout", "Rifle", "Revolver", "Deagle", "Pistol", "Other")

local weapon_list = {["AWP"] = {id = {9}}, ["Auto-sniper"] = {id = {11, 38}}, ["Scout"] = {id = {40}}, ["Rifle"] = {id = {7, 8, 10, 13, 16, 39, 60}}, ["Revolver"] = {id = {64}}, ["Deagle"] = {id = {1}}, ["Pistol"] = {id = {2, 3, 4, 30, 32, 36, 61, 63}}, ["Other"] = {id = {}}}
local weapon_filter = {"AWP", "Scout", "Revolver"}
local active_weapon = ""

local double_tap = false

local element_list = {
{["enabled"] = {["custom"] = false, ["type"] = ui.new_checkbox,["ref"] = rage.enabled,                     ["name"] = "Enabled",                       ["value"] = {}}}, 
{["selection"] = {["custom"] = false, ["type"] = ui.new_combobox,["ref"] = rage.selection,                 ["name"] = "Target selection",              ["value"] = {"Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"}}},
{["hitbox"] = {["custom"] = false, ["type"] = ui.new_multiselect,["ref"] = rage.hitbox,                    ["name"] = "Target hitbox",                 ["value"] = {{"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}}}},
{["dt_hitbox"] = {["custom"] = true, ["type"] = ui.new_multiselect,["ref"] = rage.hitbox,                  ["name"] = "DT Target hitbox",              ["value"] = {{"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}}}},
{["multipoint"] = {["custom"] = false, ["type"] = ui.new_multiselect,["ref"] = rage.multipoint[1],         ["name"] = "Multi-point",                   ["value"] = {{"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}}}},
{["dt_multipoint"] = {["custom"] = true, ["type"] = ui.new_multiselect,["ref"] = rage.multipoint[1],       ["name"] = "DT Multi-point",                ["value"] = {{"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}}}},
{["multipoint_strength"] = {["custom"] = false, ["type"] = ui.new_combobox,["ref"] = rage.multipoint[2],   ["name"] = "Multi-point strength",          ["value"] = {"Low", "Medium", "High"}}},
{["multipoint_scale"] = {["custom"] = false, ["type"] = ui.new_slider,["ref"] = rage.multipoint_scale,     ["name"] = "Multi-point scale",             ["value"] = {24, 100, 52, true, "%", 1, {[24] = "Auto"}}}},
{["dt_multipoint_scale"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = rage.multipoint_scale,   ["name"] = "DT multi-point scale",          ["value"] = {24, 100, 52, true, "%", 1, {[24] = "Auto"}}}},
{["prefersafe"] = {["custom"] = false, ["type"] = ui.new_checkbox,["ref"] = rage.prefersafe,               ["name"] = "Prefer safe point",             ["value"] = {}}},
{["forcesafe_limbs"] = {["custom"] = false, ["type"] = ui.new_checkbox,["ref"] = rage.forcesafe_limbs,     ["name"] = "Force safe point on limbs",     ["value"] = {}}},
{["preferbody"] = {["custom"] = false, ["type"] = ui.new_checkbox,["ref"] = rage.preferbody,               ["name"] = "Prefer body aim",               ["value"] = {}}},
{["preferbody_disablers"] = {["custom"] = false, ["type"] = ui.new_multiselect,["ref"] = rage.disablers,   ["name"] = "Prefer body aim disablers",     ["value"] = {{"Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage"}}}},
{["silent"] = {["custom"] = false, ["type"] = ui.new_checkbox,["ref"] = rage.silent,                       ["name"] = "Silent aim",                    ["value"] = {}}},
{["hitchance"] = {["custom"] = false, ["type"] = ui.new_slider,["ref"] = rage.hitchance,                   ["name"] = "Minimum hit chance",            ["value"] = {0, 100, 50, true, "%"}}},
{["air_hitchance"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = rage.hitchance,                ["name"] = "AIR Minimum hit chance",        ["value"] = {0, 100, 50, true, "%"}}},
{["dt_hitchance"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = rage.hitchance,                 ["name"] = "DT Minimum hit chance",         ["value"] = {0, 100, 50, true, "%"}}},
{["mindamage"] = {["custom"] = false, ["type"] = ui.new_slider,["ref"] = rage.damage,                      ["name"] = "Minimum damage",                ["value"] = {0, 126, 25, true, "", 1, damage_labels}}},
{["air_mindamage"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = rage.damage,                   ["name"] = "AIR Minimum damage",            ["value"] = {0, 126, 25, true, "", 1, damage_labels}}},
{["dt_mindamage"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = rage.damage,                    ["name"] = "DT Minimum damage",             ["value"] = {0, 126, 25, true, "", 1, damage_labels}}},
{["ov_mindamage"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = rage.damage,                    ["name"] = "OVERRIDE Minimum damage",       ["value"] = {0, 126, 25, true, "", 1, damage_labels}}},
{["ov_key"] = {["custom"] = true, ["type"] = ui.new_hotkey,["ref"] = nil,                                  ["name"] = "OVERRIDE key",                  ["value"] = {true}}},
{["mitigation"] = {["custom"] = false, ["type"] = ui.new_multiselect,["ref"] = rage.mitigations,           ["name"] = "Low FPS mitigations",           ["value"] = {{"Force low accuracy boost", "Disable multipoint: feet", "Disable multipoint: arms", "Disable multipoint: legs", "Disable hitbox: feet", "Force low multipoint", "Lower hit chance precision", "Limit targets per tick"}}}},
{["boost"] = {["custom"] = false, ["type"] = ui.new_combobox,["ref"] = rage.boost,                         ["name"] = "Accuracy boost",                ["value"] = {"Off", "Low", "Medium", "High", "Maximum"}}},
{["delay_shot"] = {["custom"] = false, ["type"] = ui.new_checkbox,["ref"] = rage.delay_shot,               ["name"] = "Delay shot",                    ["value"] = {}}},
{["quickstop"] = {["custom"] = false, ["type"] = ui.new_checkbox,["ref"] = rage.quickstop,                 ["name"] = "Quick stop",                    ["value"] = {}}},
{["quickstop_options"] = {["custom"] = false, ["type"] = ui.new_multiselect,["ref"] = rage.qs_options,     ["name"] = "Quick stop options",            ["value"] = {{"Early", "Slow motion", "Duck", "Move between shots", "Ignore molotov"}}}},
{["doubletap"] = {["custom"] = false, ["type"] = ui.new_checkbox,["ref"] = rage.doubletap,                 ["name"] = "Double tap",                    ["value"] = {}}},
{["doubletap_mode"] = {["custom"] = false, ["type"] = ui.new_combobox,["ref"] = rage.doubletap_mode,       ["name"] = "Double tap mode",               ["value"] = {"Offensive", "Defensive"}}},
{["forcebaim"] = {["custom"] = true, ["type"] = ui.new_multiselect,["ref"] = nil,                          ["name"] = "Force body aim conditions",     ["value"] = {"Lethal", "x2 HP", "Slow targets", "Shooting", "X Misses", "<x HP", "In air", "Crouching"}}},
{["preferbaim"] = {["custom"] = true, ["type"] = ui.new_multiselect,["ref"] = nil,                         ["name"] = "Prefer body aim conditions",    ["value"] = {"Lethal", "x2 HP", "Slow targets", "Shooting", "X Misses", "<x HP", "In air", "Crouching"}}},
{["preferhead"] = {["custom"] = true, ["type"] = ui.new_multiselect,["ref"] = nil,                         ["name"] = "Prefer head aim conditions",    ["value"] = {"Sideways", "Velocity", "Fast targets", "Crouching"}}},
{["velocity"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = nil,                                ["name"] = "Velocity under X",              ["value"] = {0, 300, 110}}},
{["misses"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = nil,                                  ["name"] = "X misses",                      ["value"] = {1, 6, 2}}},
{["hp"] = {["custom"] = true, ["type"] = ui.new_slider,["ref"] = nil,                                      ["name"] = "Below X HP",                    ["value"] = {0, 100, 20}}},
}

local function generate_weapons()
    local l, a, b = "LUA", "A", "B"
    for name in pairs(weapon_list) do
        for i=1, #element_list do
            for key, value in pairs(element_list[i]) do
                if contains(weapon_filter, name) then
                    if not (key == "doubletap" or key == "doubletap_mode" or key == "dt_hitbox" or key == "dt_multipoint" or key == "dt_multipoint_scale" or key == "dt_mindamage") then
                        --print("SPECIAL Inserting ", key, " into ", name)
                        weapon_list[name][key] = value.type(l, a, string.format("[%s] %s", name, value.name), unpack(value.value))
                        ui.set_visible(weapon_list[name][key], false)
                    end
                else
                    --print("Inserting ", key, " into ", name)
                    weapon_list[name][key] = value.type(l, a, string.format("[%s] %s", name, value.name), unpack(value.value))
                    ui.set_visible(weapon_list[name][key], false)
                end
            end
        end
    end
end

local function update_active_weapon()
    local LocalPlayer = entity.get_local_player()
    local weapon = entity.get_player_weapon(LocalPlayer)

    if not weapon or not LocalPlayer then
		return
    end
    
	local id = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
    local found = false
    for name, tbl in pairs(weapon_list) do
        if contains(tbl["id"], id) then
            active_weapon = name
            found = true
            break
        end
    end

    if not found then
        active_weapon = "Other"
        --client.log("Other")
    end
end

local function update_visibility()
    for name in pairs(weapon_list) do
        local visible = name == ui.get(current_weapon)
        for i=1, #element_list do
            for key, value in pairs(element_list[i]) do
                --client.log("KEY: ", key)
                if weapon_list[name][key] and weapon_list[name][key] ~= nil then
                    ui.set_visible(weapon_list[name][key], visible)
                end
            end
        end
    end
end
local pbaim = ui.reference("PLAYERS", "Adjustments", "Override prefer body aim")
local reason = {}
local misses = {}

client.set_event_callback("aim_miss", function (event)
    misses[event.target] = misses[event.target] + 1 or 1
end)

client.set_event_callback("round_start", function (event)
    reason = {}
    misses = {} 
end)

local function conditions()
    client.update_player_list()
    local config = weapon_list[active_weapon]
    for _, player in pairs(entity.get_players(true)) do
        if not (player == nil or entity.is_alive(player) == false or entity.get_player_weapon(player) == nil) then
            reason[player] = reason[player] or ""
            misses[player] = misses[player] or 0

            local me = entity.get_local_player()

            local _vx, _vy = entity.get_prop(player, "m_vecVelocity")
            local velocity = math.sqrt(_vx ^ 2 + _vy ^ 2)

            local health = entity.get_prop(player, "m_iHealth")
            local on_ground = bit.band(entity.get_prop(player, "m_fFlags"), 1)
            local standing = bit.band(entity.get_prop(player, "m_fFlags"), bit.lshift(1, 1)) == 0

            reason[player] = ""
            plist.set(player, "Override prefer body aim", "-")
            plist.set(player, "High priority", false)

            --[[
            {"Lethal", "x2 HP", "Slow targets", "Shooting", "X Misses", "<x HP", "In air", "Crouching"}}}, 
            {"Sideways", "Velocity", "Fast targets", "Crouching"}}},
            ]]

            if #ui.get(config["preferhead"]) > 0 then -- check head conditions
                local current_table = ui.get(config["preferhead"])
                local met = false

                if contains(current_table, "Velocity") and not met then
                    met = velocity <= ui.get(config["velocity"])
                end

                if contains(current_table, "Fast targets") and not met then
                    met = velocity >= 185
                end

                if contains(current_table, "Crouching") and not met then
                    met = not standing
                end

                if contains(current_table, "Sideways") and not met then
                    local player_position = vector(entity.get_prop(me, "m_vecOrigin"))
                    local player_eye = vector(client.camera_angles())
                    local enemy_pos = vector(entity.get_prop(player, "m_vecOrigin"))
                    local enemy_eye = vector(entity.get_prop(player, "m_angAbsRotation"))
                    local yaw_diff = math.abs(player_eye.y - enemy_eye.y)

                    met = yaw_diff >= 55 and yaw_diff <= 135
                end

                if met then
                    reason[player] = "HEAD"
                    plist.set(player, "Override prefer body aim", "Off")
                end
            end

            -- {"Lethal", "x2 HP", "Slow targets", "Shooting", "X Misses", "<x HP", "In air", "Crouching"}}}, 

            if #ui.get(config["preferbaim"]) > 0 then -- check baim conditions
                local current_table = ui.get(config["preferbaim"])
                local met = false

                if contains(current_table, "Lethal") then
                    met = health <= ui.get(config["mindamage"])
                end

                if contains(current_table, "x2 HP") and not met then
                    met = health <= ui.get(config["mindamage"]) * 2
                end

                if contains(current_table, "Slow targets") and not met then
                    met = velocity > 25 and velocity <= 135
                end

                if contains(current_table, "Shooting") and not met then
                    local is_shooting = globals.curtime() < (entity.get_prop(entity.get_player_weapon(player), "m_fLastShotTime") + 0.5)
                    met = is_shooting
                end

                if contains(current_table, "X Misses") and not met then
                    met = misses[player] >= ui.get(config["misses"])
                end

                if contains(current_table, "<x HP") and not met then
                    met = health <= ui.get(config["hp"])
                end

                if contains(current_table, "In Air") and not met then
                    met = not on_ground
                end

                if contains(current_table, "Crouching") and not met then
                    met = not standing
                end

                if met then
                    reason[player] = "PREFER"
                    plist.set(player, "Override prefer body aim", "On")
                end
            end

            -- {"Lethal", "x2 HP", "Slow targets", "Shooting", "X Misses", "<x HP", "In air", "Crouching"}}}, 

            if #ui.get(config["forcebaim"]) > 0 then -- check baim conditions
                local current_table = ui.get(config["forcebaim"])
                local met = false

                if contains(current_table, "Lethal") then
                    met = health <= ui.get(config["mindamage"])
                end

                if contains(current_table, "x2 HP") and not met then
                    met = health <= ui.get(config["mindamage"]) * 2
                end

                if contains(current_table, "Slow targets") and not met then
                    met = velocity > 25 and velocity <= 135
                end

                if contains(current_table, "Shooting") and not met then
                    local is_shooting = globals.curtime() < (entity.get_prop(entity.get_player_weapon(player), "m_fLastShotTime") + 0.3)
                    met = is_shooting
                end

                if contains(current_table, "X Misses") and not met then
                    met = misses[player] >= ui.get(config["misses"])
                end

                if contains(current_table, "<x HP") and not met then
                    met = health <= ui.get(config["hp"])
                end

                if contains(current_table, "In Air") and not met then
                    met = not on_ground
                end

                if contains(current_table, "Crouching") and not met then
                    met = not standing
                end

                if met then
                    reason[player] = "FORCE"
                    plist.set(player, "Override prefer body aim", "Force")
                end
            end

            -- do priority below
            local weapon = entity.get_player_weapon(player)
            local id = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)

            if (id == 9) then -- awp
                plist.set(player, "High priority", true)
            end
        end
    end
end
local dt, dt_key = ui.reference("RAGE", "Other","Double tap")
local in_air = false
client.set_event_callback("setup_command", function (cmd)
    in_air = cmd.in_jump == 1
end)

local function override_settings()
    update_active_weapon()
    update_visibility()
    conditions()

    local config = weapon_list[active_weapon]

    if #ui.get(config["hitbox"]) == 0 then
        ui.set(config["hitbox"], "Head")
    end

    double_tap = ui.get(dt) and ui.get(dt_key)

    local hitbox = ui.get(config["hitbox"])
    local multipoint = ui.get(config["multipoint"])
    local mp_scale = ui.get(config["multipoint_scale"])
    local damage = ui.get(config["mindamage"])
    local hitchance = ui.get(config["hitchance"])

    if not contains(weapon_filter, active_weapon) then
        if #ui.get(config["dt_hitbox"]) == 0 then
            ui.set(config["dt_hitbox"], "Head")
        end

        if double_tap then
            hitbox = ui.get(config["dt_hitbox"])
            multipoint = ui.get(config["dt_multipoint"])
            mp_scale = ui.get(config["dt_multipoint_scale"])
            damage = ui.get(config["dt_mindamage"])
            hitchance = ui.get(config["dt_hitchance"])
        end
    end

    damage = in_air and ui.get(config["air_mindamage"]) or damage
    hitchance = in_air and ui.get(config["air_hitchance"]) or hitchance

    if ui.get(config["ov_key"]) then
        damage = ui.get(config["ov_mindamage"])
    end

    ui.set(rage.correction, true)
    ui.set(rage.recoil, true)
    ui.set(rage.silent, true)
    ui.set(rage.autofire, true)
    ui.set(rage.autopenetration, true)
    ui.set(rage.aimstep, false)
    ui.set(rage.fov, 180)
    ui.set(rage.enabled, ui.get(config["enabled"]))
    ui.set(rage.selection, ui.get(config["selection"]))
    ui.set(rage.hitbox, hitbox)
    ui.set(rage.multipoint[1], multipoint)
    ui.set(rage.multipoint[3], ui.get(config["multipoint_strength"]))
    ui.set(rage.multipoint_scale, mp_scale)
    ui.set(rage.prefersafe, ui.get(config["prefersafe"]))
    ui.set(rage.forcesafe_limbs, ui.get(config["forcesafe_limbs"]))
    ui.set(rage.preferbody, ui.get(config["preferbody"]))
    ui.set(rage.disablers, ui.get(config["preferbody_disablers"]))
    ui.set(rage.hitchance, hitchance)
    ui.set(rage.damage, damage)
    ui.set(rage.mitigations, ui.get(config["mitigation"]))
    ui.set(rage.boost, ui.get(config["boost"]))
    ui.set(rage.delay_shot, ui.get(config["delay_shot"]))
    ui.set(rage.quickstop, ui.get(config["quickstop"]))
    ui.set(rage.qs_options, ui.get(config["quickstop_options"]))
    ui.set(rage.doubletap, not (contains(weapon_filter, active_weapon)) and ui.get(config["doubletap"]) or false)
    ui.set(rage.doubletap_mode, not (contains(weapon_filter, active_weapon)) and ui.get(config["doubletap_mode"]) or "Offensive")
end
client.set_event_callback("run_command", override_settings)
update_visibility()
generate_weapons()

client.set_event_callback("paint", function (ctx)
    local config = weapon_list[active_weapon]
    if not config then return end
    for _, player in pairs(entity.get_players(true)) do
        local bounding_box = {entity.get_bounding_box(player)}
        if #bounding_box == 5 and bounding_box[5] ~= 0 then --rave
            local center = bounding_box[1]+(bounding_box[3]-bounding_box[1])/2
            local r,g,b,a = 255,255,255,255

            if reason[player] == "HEAD" then
                r,g,b,a = 255, 0, 0, 255
            elseif reason[player] == "FORCE" then
                r,g,b,a = 255, 102, 255, 255
            elseif reason[player] == "BAIM" then
                r,g,b,a = 255, 255, 0, 255
            end
            renderer.text(center, bounding_box[2] - 20, r,g,b,a, "cb", 0, reason[player])
            if plist.get(player, "High priority") then
                renderer.text(center, bounding_box[2] - 30, 255, 255, 0, 255, "cb", 0, "HIGH PRIORITY")
            end
        end
    end
end)