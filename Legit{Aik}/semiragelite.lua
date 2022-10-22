local js = panorama.open()
local api = js.MyPersonaAPI
local name = api.GetName()

client.color_log(180, 238, 0, '---[ SEMIRAGE ]---')
client.color_log(255, 255, 255, 'Welcome back ' .. name .. '!')
client.color_log(255, 255, 255, 'Last update: 17 Aug 2020.')
client.color_log(180, 238, 0, '------------------')

local ffi = require('ffi')

ffi.cdef [[
    typedef bool(__thiscall* lgts)(float, float, float, float, float, float, short);
    typedef void***(__thiscall* FindHudElement_t)(void*, const char*); 
	typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...); 
]]

local signature = '\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F\x57'
local signature_gHud = '\xB9\xCC\xCC\xCC\xCC\x88\x46\x09'
local signature_FindElement = '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28'
local match = client.find_signature('client.dll', signature) or error('client_find_signature fucked up')
local line_goes_through_smoke = ffi.cast('lgts', match) or error('ffi.cast fucked up')
local match = client.find_signature('client.dll', signature_gHud) or error('signature not found')
local hud = ffi.cast('void**', ffi.cast('char*', match) + 1)[0] or error('hud is nil')
local helement_match = client.find_signature('client.dll', signature_FindElement) or error('FindHudElement not found')
local hudchat = ffi.cast('FindHudElement_t', helement_match)(hud, 'CHudChat') or error('CHudChat not found')
local chudchat_vtbl = hudchat[0] or error('CHudChat instance vtable is nil')
local print_to_chat = ffi.cast('ChatPrintf_t', chudchat_vtbl[27])

local function print_chat(text)
    print_to_chat(hudchat, 0, 0, text)
end

local vars = {
    rage = {
        fire = false,
        penetration = false,
        penetration2 = false,
        autofactor = nil,
        max_fov = nil,
        min_fov = nil,
        dynamicfov_new_fov = 0,
        bool_in_fov = false,
        closest_enemy = nil,
        visible_hitboxes = 0,
        nearest_player = nil,
        nearest_player_fov = nil
    },

    misc = {
        name = false
    },
}

local w, h = client.screen_size()
local x, y = w / 2, h / 2
local angle = 0
local bruteforce_manual
PI = 3.14159265358979323846
DEG_TO_RAD = PI / 180.0
RAD_TO_DEG = 180.0 / PI

local weapon_classes = {
    ['CWeaponG3SG1'] = 'Snipers',
	['CWeaponSCAR20'] = 'Snipers',
	['CWeaponAWP'] = 'Snipers',
	['CWeaponSSG08'] = 'Snipers',
	['CDEagle'] = 'Deagle',
	['CWeaponFiveSeven'] = 'Pistols',
	['CWeaponHKP2000'] = 'Pistols',
	['CWeaponP250'] = 'Pistols',
	['CWeaponGlock'] = 'Pistols',
	['CWeaponElite'] = 'Pistols',
	['CWeaponTec9'] = 'Pistols',
	['CAK47'] = 'Others',
	['CWeaponAug'] = 'Others',
	['CWeaponFamas'] = 'Others',
	['CWeaponGalilAR'] = 'Others',
	['CWeaponM4A1'] = 'Others',
	['CWeaponSG556'] = 'Others',
	['CWeaponMP7'] = 'Others',
	['CWeaponMP9'] = 'Others',
	['CWeaponBizon'] = 'Others',
	['CWeaponP90'] = 'Others',
	['CWeaponUMP45'] = 'Others',
	['CWeaponM249'] = 'Others',
	['CWeaponNegev'] = 'Others',
	['CWeaponMag7'] = 'Others',
	['CWeaponNOVA'] = 'Others',
	['CWeaponSawedoff'] = 'Others',
	['CWeaponXM1014'] = 'Others',
}

local improvements_modes = {
    'Snipers',
    'Deagle', 
    'Pistols',
    'Others'
}

local improvements_nades = {
    'Smoke',
    'Flash'
}

local dynamicfov_modes = {
    'Snipers',
    'Deagle', 
    'Pistols',
    'Others'
}

local penetration_modes = {
    'On hotkey',
    'Visible'
}

local indicators_types = {
    'Default',
    'Crosshair'
}

local indicators_modes = {
    'Resolver',
    'FOV',
    'FAKE',
    'Automatic fire',
    'Automatic penetration',
    'Force body aim',
    'Minimum damage'
}

local flags_modes = {
    'FAKE',
    'Resolver'
}

local references = {
    rage = {
        enabled = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
        fire = ui.reference('RAGE', 'Aimbot', 'Automatic fire'),
        penetration = ui.reference('RAGE', 'Aimbot', 'Automatic penetration'),
        mindmg = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
        fov = ui.reference('RAGE', 'Aimbot', 'Maximum FOV'),
        bodyaim = ui.reference('RAGE', 'Other', 'Force body aim'),
        miss = ui.reference('RAGE', 'Aimbot', 'Log misses due to spread'),
    },

    aa = {
        enabled = { ui.reference('AA', 'Anti-aimbot angles', 'Enabled') },
    },

    misc = {
        namesteal = ui.reference('MISC', 'Miscellaneous', 'Steal player name'),
    },

    players = {
        body_yaw = ui.reference('PLAYERS', 'Adjustments', 'Force body yaw'),
        body_yaw_slider = { ui.reference('PLAYERS', 'Adjustments', 'Force body yaw value') },
        lists = ui.reference('PLAYERS', 'Players', 'Player list'),
	    whitelist = ui.reference('PLAYERS', 'Adjustments', 'Add to whitelist'),
        reset_all = ui.reference('PLAYERS', 'Players', 'Reset all'),
        apply_all = ui.reference('PLAYERS', 'Adjustments', 'Apply to all'),
    },
}

local menu = {
    rage = {
        enabled = ui.new_checkbox('RAGE', 'Other', 'SEMI RAGE'),
        improvements = ui.new_checkbox('RAGE', 'Other', 'Improvements'),
        improvements_mode = { ui.new_multiselect('RAGE', 'Other', 'Aimbot improvements', improvements_modes) },
        improvements_hotkey = ui.new_hotkey('RAGE', 'Other', '\nAimbot improvements modes', true, 0x01),
        improvements_nades = { ui.new_multiselect('RAGE', 'Other', 'Disable aimbot', improvements_nades) },
        fire = ui.new_checkbox('RAGE', 'Other', 'Automatic fire'),
        fire_hotkey = ui.new_hotkey('RAGE', 'Other', 'Automatic fire', true),
        penetration = ui.new_checkbox('RAGE', 'Other', 'Automatic penetration'),
        penetration_hotkey = ui.new_hotkey('RAGE', 'Other', 'Automatic penetration', true),
        penetration_mode = { ui.new_multiselect('RAGE', 'Other', '\nPenetration modes', penetration_modes) },
        penetreation_slider = ui.new_slider('RAGE', 'Other', 'when X hitboxes visible', 0, 12, 2, true),
        dynamicfov = ui.new_checkbox('RAGE', 'Other', 'Dynamic FOV'),
        dynamicfov_mode = { ui.new_combobox('RAGE', 'Other', '\nDynamic FOV modes', dynamicfov_modes) },
        dynamicfov_autofactor = ui.new_slider('RAGE', 'Other', 'Dynamic FOV auto factor', 0, 250, 100, true, 'x', 0.01),
        dynamicfov_min_snipers = ui.new_slider('RAGE', 'Other', 'Snipers Dynamic FOV min', 1, 180, 3, true, '°', 1),
        dynamicfov_max_snipers = ui.new_slider('RAGE', 'Other', 'Snipers Dynamic FOV max', 1, 180, 10, true, '°', 1),
        dynamicfov_min_deagle = ui.new_slider('RAGE', 'Other', 'Deagle Dynamic FOV min', 1, 180, 3, true, '°', 1),
        dynamicfov_max_deagle = ui.new_slider('RAGE', 'Other', 'Deagle Dynamic FOV max', 1, 180, 10, true, '°', 1),
        dynamicfov_min_pistols = ui.new_slider('RAGE', 'Other', 'Pistols Dynamic FOV min', 1, 180, 3, true, '°', 1),
        dynamicfov_max_pistols = ui.new_slider('RAGE', 'Other', 'Pistols Dynamic FOV max', 1, 180, 10, true, '°', 1),
        dynamicfov_min_others = ui.new_slider('RAGE', 'Other', 'Others Dynamic FOV min', 1, 180, 3, true, '°', 1),
        dynamicfov_max_others = ui.new_slider('RAGE', 'Other', 'Others Dynamic FOV max', 1, 180, 10, true, '°', 1),
        resolver = ui.new_checkbox('RAGE', 'Other', 'Resolver'),
        resolver_hotkey = ui.new_hotkey('RAGE', 'Other', '\nResolver', true),
    },

    visuals = {
        enabled = ui.new_checkbox('VISUALS', 'Other ESP', 'SEMI VISUALS'),
        indicators = ui.new_checkbox('VISUALS', 'Other ESP', 'Indicators'),
        indicators_type = { ui.new_combobox('VISUALS', 'Other ESP', '\nIndicators types', indicators_types) },
        indicators_mode = { ui.new_multiselect('VISUALS', 'Other ESP', 'Indicators modes', indicators_modes) },
        flags = ui.new_checkbox('VISUALS', 'Other ESP', 'Flags'),
        flags_mode = { ui.new_multiselect('VISUALS', 'Other ESP', '\nFlags modes', flags_modes) },
    },

    misc = {
        enabled = ui.new_checkbox('MISC', 'Miscellaneous', 'SEMI MISC'),
        logs = ui.new_checkbox('MISC', 'Miscellaneous', 'Log misses'),
        spam = ui.new_button('MISC', 'Miscellaneous', 'GAMESENSE > ALL', function()
            local player = entity.get_local_player()
            if not vars.misc.name then
                name = entity.get_player_name(player)
                vars.misc.name = true
            end
            ui.set(references.misc.namesteal, true)
            client.set_cvar('name', 'GAMESENSE > ALL')
            client.delay_call(0.15, client.set_cvar, 'name', 'GAMESENSE > ALL')
            client.delay_call(0.3, client.set_cvar, 'name', 'GAMESENSE > ALL')
            client.delay_call(0.45, client.set_cvar, 'name', 'GAMESENSE > ALL')
            client.delay_call(0.6, client.set_cvar, 'name', name)
            if name == entity.get_player_name(player) then
                vars.misc.name = false
            end
        end)
    },
}

local function table_contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local function angle_to_vec(pitch, yaw)
    local pitch_rad, yaw_rad = DEG_TO_RAD * pitch, DEG_TO_RAD * yaw
    local sp, cp, sy, cy = math.sin(pitch_rad), math.cos(pitch_rad), math.sin(yaw_rad), math.cos(yaw_rad)
    return cp * cy, cp * sy, -sp
end

local function vec3_normalize(x, y, z)
    local len = math.sqrt(x * x + y * y + z * z)
    if len == 0 then
        return 0, 0, 0
    end
    local r = 1 / len
    return x * r, y * r, z * r
end

local function vec3_dot(ax, ay, az, bx, by, bz)
    return ax * bx + ay * by + az * bz
end

local function calculate_fov(ent, lx, ly, lz, fx, fy, fz)
    local px, py, pz = entity.get_prop(ent, 'm_vecOrigin')
    local dx, dy, dz = vec3_normalize(px - lx, py - ly, lz - lz)
    local dot_product = vec3_dot(dx, dy, dz, fx, fy, fz)
    local cos_inverse = math.acos(dot_product)
    return RAD_TO_DEG * cos_inverse
end

local function player_visible(player, lx, ly, lz, ent)
    local visible_hitboxes = vars.rage.visible_hitboxes
    local visible_hitboxes = 0
    local visible_hitboxes_value = ui.get(menu.rage.penetreation_slider)
    for i = 0, 18 do
        local ex, ey, ez = entity.hitbox_position(ent, i)
        local _, entindex = client.trace_line(player, lx, ly, lz, ex, ey, ez)
        if entindex == ent then
            visible_hitboxes = visible_hitboxes + 1
        end
    end
    return visible_hitboxes >= visible_hitboxes_value
end

local function get_closest_player(lx, ly, lz, pitch, yaw)
    local nearest_player = vars.rage.nearest_player
    local nearest_player_fov = vars.rage.nearest_player_fov

    local fx, fy, fz = angle_to_vec(pitch, yaw)
    local enemy_players = entity.get_players(true)
    local nearest_player = nil
    local nearest_player_fov = math.huge
    for i = 1, #enemy_players do
        local enemy_ent = enemy_players[i]
        local fov_to_player = calculate_fov(enemy_ent, lx, ly, lz, fx, fy, fz)
        if fov_to_player <= nearest_player_fov then
            nearest_player = enemy_ent
            nearest_player_fov = fov_to_player
        end
    end
    return nearest_player, nearest_player_fov
end

local function visibility_rage()
    local rage = ui.get(menu.rage.enabled)
    local improvements = ui.get(menu.rage.improvements)
    local fire = ui.get(menu.rage.fire)
    local penetration = ui.get(menu.rage.penetration)
    local dynamicfov = ui.get(menu.rage.dynamicfov)
    local dynamicfov_mode = ui.get(menu.rage.dynamicfov_mode[1])
    local resolver = ui.get(menu.rage.resolver)

    local penetration_hotkey = table_contains(ui.get(menu.rage.penetration_mode[1]), 'On hotkey')
    local penetration_visible = table_contains(ui.get(menu.rage.penetration_mode[1]), 'Visible')

    if rage then
        ui.set_visible(menu.rage.improvements, true)
        ui.set_visible(menu.rage.fire, true)
        ui.set_visible(menu.rage.penetration, true)
        ui.set_visible(menu.rage.dynamicfov, true)
        ui.set_visible(menu.rage.resolver, true)
    else
        ui.set_visible(menu.rage.improvements, false)
        ui.set_visible(menu.rage.fire, false)
        ui.set_visible(menu.rage.penetration, false)
        ui.set_visible(menu.rage.dynamicfov, false)
        ui.set_visible(menu.rage.resolver, false)
    end

    if improvements and rage then
        ui.set_visible(menu.rage.improvements_mode[1], true)
        ui.set_visible(menu.rage.improvements_hotkey, true)
        ui.set_visible(menu.rage.improvements_nades[1], true)
    else
        ui.set_visible(menu.rage.improvements_mode[1], false)
        ui.set_visible(menu.rage.improvements_hotkey, false)
        ui.set_visible(menu.rage.improvements_nades[1], false)
    end

    if fire and rage then
        ui.set_visible(menu.rage.fire_hotkey, true)
    else
        ui.set_visible(menu.rage.fire_hotkey, false)
    end

    if penetration and rage then
        ui.set_visible(menu.rage.penetration_mode[1], true)
        ui.set_visible(menu.rage.penetreation_slider, true)
    else
        ui.set_visible(menu.rage.penetration_mode[1], false)
        ui.set_visible(menu.rage.penetreation_slider, false)
    end

    if dynamicfov and rage then
        ui.set_visible(menu.rage.dynamicfov_mode[1], true)
        ui.set_visible(menu.rage.dynamicfov_autofactor, true)
    else
        ui.set_visible(menu.rage.dynamicfov_mode[1], false)
        ui.set_visible(menu.rage.dynamicfov_autofactor, false)
    end

    if resolver and rage then
        ui.set_visible(menu.rage.resolver_hotkey, true)
    else
        ui.set_visible(menu.rage.resolver_hotkey, false)
    end

    ui.set_visible(menu.rage.penetration_hotkey, penetration and penetration_hotkey and rage)
    ui.set_visible(menu.rage.penetreation_slider, penetration and penetration_visible and rage)
    ui.set_visible(menu.rage.dynamicfov_min_snipers, dynamicfov and dynamicfov_mode == 'Snipers' and rage)
    ui.set_visible(menu.rage.dynamicfov_max_snipers, dynamicfov and dynamicfov_mode == 'Snipers' and rage)
    ui.set_visible(menu.rage.dynamicfov_min_deagle, dynamicfov and dynamicfov_mode == 'Deagle' and rage)
    ui.set_visible(menu.rage.dynamicfov_max_deagle, dynamicfov and dynamicfov_mode == 'Deagle' and rage)
    ui.set_visible(menu.rage.dynamicfov_min_pistols, dynamicfov and dynamicfov_mode == 'Pistols' and rage)
    ui.set_visible(menu.rage.dynamicfov_max_pistols, dynamicfov and dynamicfov_mode == 'Pistols' and rage)
    ui.set_visible(menu.rage.dynamicfov_min_others, dynamicfov and dynamicfov_mode == 'Others' and rage)
    ui.set_visible(menu.rage.dynamicfov_max_others, dynamicfov and dynamicfov_mode == 'Others' and rage)
end

local function visibility_visuals()
    local visuals = ui.get(menu.visuals.enabled)
    local indicators = ui.get(menu.visuals.indicators)
    local flags = ui.get(menu.visuals.flags)

    if visuals then
        ui.set_visible(menu.visuals.indicators, true)
        ui.set_visible(menu.visuals.flags, true)
    else
        ui.set_visible(menu.visuals.indicators, false)
        ui.set_visible(menu.visuals.flags, false)
    end

    if indicators and visuals then
        ui.set_visible(menu.visuals.indicators_type[1], true)
        ui.set_visible(menu.visuals.indicators_mode[1], true)
    else
        ui.set_visible(menu.visuals.indicators_type[1], false)
        ui.set_visible(menu.visuals.indicators_mode[1], false)
    end

    if flags and visuals then
        ui.set_visible(menu.visuals.flags_mode[1], true)
    else
        ui.set_visible(menu.visuals.flags_mode[1], false)
    end
end

local function visibility_misc()
    local misc = ui.get(menu.misc.enabled)
    
    if misc then
        ui.set_visible(menu.misc.logs, true)
        ui.set_visible(menu.misc.spam, true)
    else
        ui.set_visible(menu.misc.logs, false)
        ui.set_visible(menu.misc.spam, false)
    end
end

local function rage()
    local weapon = weapon_classes[entity.get_classname(entity.get_player_weapon(entity.get_local_player()))]
    local vars_fire = vars.rage.fire
    local vars_penetration = vars.rage.penetration
    local vars_penetration2 = vars.rage.penetration2

    local semirage = ui.get(menu.rage.enabled)
    local improvements = ui.get(menu.rage.improvements)
    local improvements_hotkey = ui.get(menu.rage.improvements_hotkey)
    local fire = ui.get(menu.rage.fire)
    local fire_hotkey = ui.get(menu.rage.fire_hotkey)
    local penetration = ui.get(menu.rage.penetration)
    local penetration_hotkey = ui.get(menu.rage.penetration_hotkey)

    local maximum_fov = ui.get(references.rage.fov)
    local player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    local lx, ly, lz = entity.get_prop(player, 'm_vecOrigin')
    local nearest_player, nearest_player_fov = get_closest_player(lx, ly, lz, pitch, yaw)
    local view_offset = entity.get_prop(player, 'm_vecViewOffset[2]')
    local lz = lz + view_offset

    local penetration_visible = table_contains(ui.get(menu.rage.penetration_mode[1]), 'Visible')

    if semirage and improvements and improvements_hotkey and table_contains(ui.get(menu.rage.improvements_mode[1]), weapon) or semirage and fire and fire_hotkey then
        vars.rage.fire = true
    else
        vars.rage.fire = false
    end

    if semirage and penetration and penetration_hotkey then
        vars.rage.penetration = true
    else
        vars.rage.penetration = false
    end

    if nearest_player ~= nil and nearest_player_fov <= maximum_fov and penetration and penetration_visible then
        vars_penetration2 = player_visible(player, lx, ly, lz, nearest_player)
    else
        vars_penetration2 = false
    end

    if vars_fire and fire and fire_hotkey then
        ui.set(references.rage.enabled[2], 'Always on')
        ui.set(references.rage.fire, true)
    else
        ui.set(references.rage.enabled[2], 'On hotkey')
        ui.set(references.rage.fire, false)
    end

    if vars_penetration2 or vars_penetration and penetration and penetration_hotkey then
        ui.set(references.rage.penetration, true)
    else
        ui.set(references.rage.penetration, false)
    end
end

local function dynamicfov()
    local weapon = weapon_classes[entity.get_classname(entity.get_player_weapon(entity.get_local_player()))]

    local autofactor = vars.rage.autofactor
    local max_fov = vars.rage.max_fov
    local min_fov = vars.rage.min_fov
    local dynamicfov_new_fov = vars.rage.dynamicfov_new_fov
    local bool_in_fov = vars.rage.bool_in_fov
    local closest_enemy = vars.rage.closest_enemy

    if weapon == 'Snipers' then
        autofactor = ui.get(menu.rage.dynamicfov_autofactor)
        max_fov = ui.get(menu.rage.dynamicfov_max_snipers)
        min_fov = ui.get(menu.rage.dynamicfov_min_snipers)
    elseif weapon == 'Deagle' then
        autofactor = ui.get(menu.rage.dynamicfov_autofactor)
        max_fov = ui.get(menu.rage.dynamicfov_max_deagle)
        min_fov = ui.get(menu.rage.dynamicfov_min_deagle)
    elseif weapon == 'Pistols' then
        autofactor = ui.get(menu.rage.dynamicfov_autofactor)
        max_fov = ui.get(menu.rage.dynamicfov_max_pistols)
        min_fov = ui.get(menu.rage.dynamicfov_min_pistols)
    elseif weapon == 'Others' then
        autofactor = ui.get(menu.rage.dynamicfov_autofactor)
        max_fov = ui.get(menu.rage.dynamicfov_max_others)
        min_fov = ui.get(menu.rage.dynamicfov_min_others)
    end

    if autofactor == nil or max_fov == nil or min_fov == nil then
        return
    end

    local old_fov = ui.get(references.rage.fov)
    dynamicfov_new_fov = old_fov
    local enemy_players = entity.get_players(true)

    if min_fov > max_fov then
        local store_min_fov = min_fov
        min_fov = max_fov
        max_fov = store_min_fov
    end

    if #enemy_players ~= 0 then
        local own_x, own_y, own_z = client.eye_position()
        local own_pitch, own_yaw = client.camera_angles()
        local closest_enemy = nil
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
            local pitch_dif = math.abs(own_pitch - pitch ) % 360
            
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

            dynamicfov_new_fov = (3800 / real_distance) * (ui.get(menu.rage.dynamicfov_autofactor) * 0.01)

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

    if dynamicfov_new_fov ~= old_fov and weapon == 'Snipers' then
        ui.set(references.rage.fov, dynamicfov_new_fov)
    end

    if dynamicfov_new_fov ~= old_fov and weapon == 'Deagle' then
        ui.set(references.rage.fov, dynamicfov_new_fov)
    end

    if dynamicfov_new_fov ~= old_fov and weapon == 'Pistols' then
        ui.set(references.rage.fov, dynamicfov_new_fov)
    end

    if dynamicfov_new_fov ~= old_fov and weapon == 'Others' then
        ui.set(references.rage.fov, dynamicfov_new_fov)
    end

end

local function visuals()
    local penetration = ui.get(references.rage.penetration)
    local fire = ui.get(references.rage.fire)

    local semivisuals = ui.get(menu.visuals.enabled)
    local indicators = ui.get(menu.visuals.indicators)
    local flags = ui.get(menu.visuals.flags)
    local resolver = ui.get(menu.rage.resolver)
    local body_yaw = ui.get(references.players.body_yaw)
    local body_yaw_slider = ui.get(references.players.body_yaw_slider[1])
    local antiaim = ui.get(references.aa.enabled[1])
    local fov = ui.get(references.rage.fov)
    local penetration_hotkey = ui.get(menu.rage.penetration_hotkey)
    local bodyaim = ui.get(references.rage.bodyaim)

    local indicators_type = ui.get(menu.visuals.indicators_type[1])

    local indicators_mode_resolver = table_contains(ui.get(menu.visuals.indicators_mode[1]), 'Resolver')
    local indicators_mode_fake = table_contains(ui.get(menu.visuals.indicators_mode[1]), 'FAKE')
    local indicators_mode_fov = table_contains(ui.get(menu.visuals.indicators_mode[1]), 'FOV')
    local indicators_mode_fire = table_contains(ui.get(menu.visuals.indicators_mode[1]), 'Automatic fire')
    local indicators_mode_penetration = table_contains(ui.get(menu.visuals.indicators_mode[1]), 'Automatic penetration')
    local indicators_mode_bodyaim = table_contains(ui.get(menu.visuals.indicators_mode[1]), 'Force body aim')
    local indicators_mode_mindmg = table_contains(ui.get(menu.visuals.indicators_mode[1]), 'Minimum damage')

    if indicators and indicators_mode_fake and entity.is_alive(entity.get_local_player()) and antiaim then
        local color = { 255-(angle*2.29824561404), angle*3.42105263158, angle*0.22807017543 }
		local y = renderer.indicator(color[1], color[2], color[3], 255, 'FAKE')+20
		local x = 87
		renderer.circle_outline(x, y, 0, 0, 0, 155, 10, 0, 1, 6)
        renderer.circle_outline(x, y, color[1], color[2], color[3], 255, 9, 0, angle*0.01754385964, 4)
    end

    if indicators and indicators_mode_fov then
        renderer.indicator(180, 238, 0, 255, 'FOV: ', fov, '°')
    end

    if indicators and indicators_mode_mindmg then
        renderer.indicator(255, 255, 255, 255, 'DMG: ', ui.get(references.rage.mindmg))
    end

    if (indicators_type == 'Default') then
        if indicators and indicators_mode_resolver and resolver then
            if body_yaw_slider == 60 and body_yaw then
                renderer.indicator(152, 204, 0, 255, 'R:RIGHT')
            elseif body_yaw_slider == -60 and body_yaw then
                renderer.indicator(152, 204, 0, 255, 'R:LEFT')
            elseif body_yaw_slider == 0 then    
                renderer.indicator(152, 204, 0, 255, 'R:OFF')
            end
        end

        if indicators and indicators_mode_fire and fire then
            renderer.indicator(180, 238, 0, 255, 'TM')
        end

        if indicators and indicators_mode_penetration and penetration then
            renderer.indicator(180, 238, 0, 255, 'AW')
        end

        if indicators and indicators_mode_bodyaim and bodyaim then
            renderer.indicator(180, 238, 0, 255, 'BAIM')
        end
    elseif (indicators_type == 'Crosshair') then
        if indicators and indicators_mode_resolver and resolver then
            if body_yaw_slider == 60 and body_yaw then
                renderer.text(x, y + 60, 180, 238, 0, 255, 'dcb', 0, 'R:RIGHT')
            elseif body_yaw_slider == -60 and body_yaw then
                renderer.text(x, y + 60, 180, 238, 0, 255, 'dcb', 0, 'R:LEFT')
            elseif body_yaw_slider == 0 then    
                renderer.text(x, y + 60, 180, 238, 0, 255, 'dcb', 0, 'R:OFF')
            end
        end

        if indicators and indicators_mode_fire and fire then
            renderer.text(x, y + 30, 180, 238, 0, 255, 'dcb', 0, 'TM')
        else
            renderer.text(x, y + 30, 0, 0, 0, 50, 'dcb', 0, 'TM')
        end

        if indicators and indicators_mode_penetration and penetration then
            renderer.text(x, y + 40, 180, 238, 0, 255, 'dcb', 0, 'AW')
        else
            renderer.text(x, y + 40, 0, 0, 0, 50, 'dcb', 0, 'AW')
        end

        if indicators and indicators_mode_bodyaim and bodyaim then
            renderer.text(x, y + 50, 180, 238, 0, 255, 'dcb', 0, 'BAIM')
        else
            renderer.text(x, y + 50, 0, 0, 0, 50, 'dcb', 0, 'BAIM')
        end
    end
end

local function body_yaw()
    local resolver = ui.get(menu.rage.resolver)
    local body_yaw = ui.get(references.players.body_yaw_slider[1])

    if resolver == false then
        return
    end

    if body_yaw == 0 and bruteforce_manual == true then
        ui.set(references.players.body_yaw, true)
        ui.set(references.players.body_yaw_slider[1], 60)
        ui.set(references.players.apply_all, true)
        bruteforce_manual = false
    end
    if body_yaw == 60 and bruteforce_manual == true then
        ui.set(references.players.body_yaw, true)
        ui.set(references.players.body_yaw_slider[1], -60)
        ui.set(references.players.apply_all, true)
        bruteforce_manual = false
    end
    if body_yaw == -60 and bruteforce_manual == true then
        ui.set(references.players.body_yaw, false)
        ui.set(references.players.body_yaw_slider[1], 0)
        ui.set(references.players.apply_all, true)
        bruteforce_manual = false
    end
end

local function resolver()
    local resolver = ui.get(menu.rage.resolver)
    local resolver_hotkey = ui.get(menu.rage.resolver_hotkey)

    if not resolver then
        return
    end

    if resolver_hotkey then
        if bruteforce_manual == true then
            body_yaw()
            bruteforce_manual = false
        end
    else
        bruteforce_manual = true
    end
end

local function miss(e)
    local logs = ui.get(menu.misc.logs)

    if logs then
        ui.set(references.rage.miss, false)
        local reason
        local entityHealth = entity.get_prop(e.target, 'm_iHealth')
        if (entityHealth == nil) or (entityHealth <= 0) then
            print_chat('\x01[ \x04gamesense\x01 ] The player was killed prior to your shot being able to land')
            return	
        end
        if e.reason == '?' then
            reason = 'resolver'
        else
            reason = e.reason
        end
        print_chat('\x01[ \x04gamesense\x01 ] Missed shot due to ' .. reason)
    end
end
client.set_event_callback('aim_miss', miss)

client.set_event_callback('pre_render', function()
    visibility_rage()
    visibility_visuals()
    visibility_misc()
end)

client.set_event_callback('setup_command', function(c)
	if c.chokedcommands == 0 then
		if c.in_use == 1 then
			angle = 0
		else
			angle = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11)*120-60))
		end
	end
end)

client.set_event_callback('run_command', function()
	local smoke_check = table_contains(ui.get(menu.rage.improvements_nades[1]), 'Smoke')

	if smoke_check then
		client.update_player_list()
		local local_player = entity.get_local_player()
		local local_head = { entity.hitbox_position(local_player, 0) }
		for _, v in pairs(entity.get_players(true)) do
			ui.set(references.players.lists, v)
			local entity_head = { entity.hitbox_position(v, 0) }
			ui.set(references.players.whitelist, line_goes_through_smoke(local_head[1], local_head[2], local_head[3], entity_head[1], entity_head[2], entity_head[3], 1))
		end
	end
end)

client.set_event_callback('player_blind', function(e)
	local flash_check = table_contains(ui.get(menu.rage.improvements_nades[1]), 'Flash')

	local player = entity.get_local_player()
	local useridEnt = (client.userid_to_entindex(e.userid))

	if useridEnt == player and flash_check then
		client.delay_call(0.1, function()
		 local flash_duration = entity.get_prop(player, 'm_flFlashDuration')
		 	if flash_duration >= 1 then
				ui.set(references.rage.enabled[1], false)
				client.delay_call(flash_duration - 2, function() 
					ui.set(references.rage.enabled[1], true) 
				end)
			end
		end)
	end
end)

client.set_event_callback('paint', function()
    rage()
    dynamicfov()
    visuals()
    resolver()
end)


client.register_esp_flag('FAKE', 255, 255, 255, function(c)
    local flags = ui.get(menu.visuals.flags)
    local flags_mode_fake = table_contains(ui.get(menu.visuals.flags_mode[1]), 'FAKE')

    if entity.is_enemy(c) and flags and flags_mode_fake then
        return plist.get(c, 'Correction active')
    end
end)

client.register_esp_flag('RIGHT', 255, 0, 0, function(c)
    local body_yaw = ui.get(references.players.body_yaw_slider[1])
    local flags = ui.get(menu.visuals.flags)
    local flags_mode_fake = table_contains(ui.get(menu.visuals.flags_mode[1]), 'Resolver')

    if body_yaw == 60 then
        if entity.is_enemy(c) and flags and flags_mode_fake then
            return plist.get(c, 'Force body yaw value')
        end
    end
end)

client.register_esp_flag('LEFT', 255, 0, 0, function(c)
    local body_yaw = ui.get(references.players.body_yaw_slider[1])
    local flags = ui.get(menu.visuals.flags)
    local flags_mode_fake = table_contains(ui.get(menu.visuals.flags_mode[1]), 'Resolver')
       
    if body_yaw == -60 then
        if entity.is_enemy(c) and flags and flags_mode_fake then
            return plist.get(c, 'Force body yaw value')
        end
    end
end)

client.set_event_callback('shutdown', function()
    client.color_log(180, 238, 0, '---[ SEMIRAGE ]---')
    client.color_log(255, 255, 255, 'Goodbye ' .. name .. '!')
    client.color_log(180, 238, 0, '------------------')
    ui.set(references.players.reset_all, true)
end)