--local variables for API. Automatically generated by https://github.com/simpleavaster/gslua/blob/master/authors/sapphyrus/generate_api.lua 
local client_latency, client_set_clan_tag, client_log, client_draw_rectangle, client_draw_circle_outline, client_timestamp, client_draw_indicator, client_userid_to_entindex, client_world_to_screen, client_draw_gradient, client_set_event_callback = client.latency, client.set_clan_tag, client.log, client.draw_rectangle, client.draw_circle_outline, client.timestamp, client.draw_indicator, client.userid_to_entindex, client.world_to_screen, client.draw_gradient, client.set_event_callback 
local client_screen_size, client_draw_circle, client_trace_line, client_color_log, client_draw_text, client_delay_call, client_visible, client_exec, client_system_time = client.screen_size, client.draw_circle, client.trace_line, client.color_log, client.draw_text, client.delay_call, client.visible, client.exec, client.system_time 
local client_set_cvar, client_eye_position, client_draw_hitboxes, client_get_cvar, client_draw_line, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.set_cvar, client.eye_position, client.draw_hitboxes, client.get_cvar, client.draw_line, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float 
local entity_is_enemy, entity_is_dormant, entity_hitbox_position, entity_get_player_name, entity_get_steam64, entity_get_bounding_box, entity_get_all, entity_set_prop = entity.is_enemy, entity.is_dormant, entity.hitbox_position, entity.get_player_name, entity.get_steam64, entity.get_bounding_box, entity.get_all, entity.set_prop 
local entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname 
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers 
local ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_is_menu_open, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.is_menu_open, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get 
local math_ceil, math_tan, math_log10, math_randomseed, math_cos, math_sinh, math_random, math_huge, math_pi, math_max, math_atan2, math_ldexp, math_floor, math_sqrt, math_deg, math_atan, math_fmod = math.ceil, math.tan, math.log10, math.randomseed, math.cos, math.sinh, math.random, math.huge, math.pi, math.max, math.atan2, math.ldexp, math.floor, math.sqrt, math.deg, math.atan, math.fmod 
local math_acos, math_pow, math_abs, math_min, math_sin, math_frexp, math_log, math_tanh, math_exp, math_modf, math_cosh, math_asin, math_rad = math.acos, math.pow, math.abs, math.min, math.sin, math.frexp, math.log, math.tanh, math.exp, math.modf, math.cosh, math.asin, math.rad 
local table_maxn, table_foreach, table_sort, table_remove, table_foreachi, table_move, table_getn, table_concat, table_insert = table.maxn, table.foreach, table.sort, table.remove, table.foreachi, table.move, table.getn, table.concat, table.insert 
local string_find, string_format, string_rep, string_gsub, string_len, string_gmatch, string_dump, string_match, string_reverse, string_byte, string_char, string_upper, string_lower, string_sub = string.find, string.format, string.rep, string.gsub, string.len, string.gmatch, string.dump, string.match, string.reverse, string.byte, string.char, string.upper, string.lower, string.sub 
local client_trace_bullet = client.trace_bullet
local entity_get_local_player = entity.get_local_player
local client_scale_damage = client.scale_damage
local rcoutline, indicator, render_text = renderer.circle, renderer.indicator, renderer.text
--end of local variables

local getprop = entity.get_prop

--references
local ref_doubletap, ref_doubletapkey = ui_reference("RAGE", "Other", "Double tap")
local dtap_mode = ui.reference("RAGE", "Other", "Double tap mode")
local ref_dtreserve = ui_reference("RAGE", "Other", "Double tap fake lag limit")
local onshot, onshot_key = ui.reference("AA", "Other", "On shot anti-aim")
local ragebot, key = ui.reference("RAGE", "Aimbot", "Enabled")
local auto_fire = ui.reference("RAGE", "Aimbot", "Automatic fire")


local slow, slow_key = ui.reference("AA", "Other", "Slow motion")
local fl_enabled = ui.reference("AA", "Fake lag", "Enabled")
local aa_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled")
local body_yaw = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local lby = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local hit_chance = ui.reference("RAGE", "Aimbot", "Minimum hit chance")
local fake_duck = ui.reference("RAGE", "Other", "Duck peek assist")
local fl_enable, fl_key = ui.reference("AA", "Fake lag", "Enabled")

local maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")

client.color_log(255, 106, 106, "DT fix by Hitler Q3487510691")

local netprops = {
    tickbase = "m_nTickBase",
    nextattack = "m_flNextAttack",
    nextprimaryattack = "m_flNextPrimaryAttack",
    itemidx = "m_iItemDefinitionIndex"
}

--menu additions
local enabled = ui_new_checkbox("Rage", "Other", "Dynamic dt speed")
local settings = ui_new_multiselect("Rage", "Other", "Dynamic dt settings", { "Disable fakelag", "Latency", "Fps", "Local player lethal", "Distance", "Speed indicator"})

local dt_data = {
    ticks = 0,
    target = 0,
}


local global_dtap = nil
local doubletap = { ui.reference('RAGE', 'Other', 'Double tap') }

client.set_event_callback('setup_command', function(c)
    if global_dtap ~= nil then
        ui.set(doubletap[1], global_dtap)
        global_dtap = nil
    end

    local me = entity.get_local_player()
    local m_vecvel = { entity.get_prop(me, 'm_vecVelocity') }
    local velocity = math.floor(math.sqrt(m_vecvel[1]^2 + m_vecvel[2]^2 + m_vecvel[3]^2) + 0.5)

    global_dtap = velocity <= 1 and ui.get(doubletap[1]) or global_dtap

    if global_dtap ~= nil then
        ui.set(doubletap[1], false)
    end
end)

client.set_event_callback('run_command', function()
    if global_dtap ~= nil then
        ui.set(doubletap[1], global_dtap)
        global_dtap = nil
    end
end)
--pasted
local frametimes = {}
local fps_prev = 0
local last_update_time = 0
local function accumulate_fps()
	local ft = globals_absoluteframetime()
	if ft > 0 then
		table_insert(frametimes, 1, ft)
	end

	local count = #frametimes
	if count == 0 then
		return 0
	end

	local i, accum = 0, 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end
	accum = accum / i
	while i < count do
		i = i + 1
		table_remove(frametimes)
	end
	
	local fps = 1 / accum
	local rt = globals_realtime()
	if math_abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end
	
	return math_floor(fps + 0.5)
end

local function contains(tab, val, sys)
    for index, value in ipairs(tab) do
        if sys == 1 and index == val then 
            return true
        elseif value == val then
            return true
        end
    end
    return false
end

local function rgb_percent(percentage)
    local red = 124 * 2 - 165 * percentage
    local green = 255 * percentage
    local blue = 13
    return red, green, blue
end

local function round(num, decimals)
    local mult = 10^(decimals or 0)
    return math_floor(num * mult + 0.5) / mult
end

local function normalize_yaw(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return round(yaw)
end

local function calc_angle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
    local ydelta = localplayerypos - enemyypos
    local xdelta = localplayerxpos - enemyxpos
    local relativeyaw = math_atan( ydelta / xdelta )
    relativeyaw = normalize_yaw( relativeyaw * 180 / math_pi )
    if xdelta >= 0 then
        relativeyaw = normalize_yaw(relativeyaw + 180)
    end
    return relativeyaw
end

local function get_fov(enemy)
    local camerax, cameray, cameraz = client_camera_angles()
    local hx, hy, hz = entity_hitbox_position(enemy, "head_0")
    local lx, ly, lz = entity_hitbox_position(entity_get_local_player(), "head_0")

    local eyaw = calc_angle(lx, ly, hx, hy)

    local res = normalize_yaw(cameray - eyaw)

    if res ~= res then
        res = 0
    end

    return math_abs(res)
end

local function getdamage(enemy)
    local ex = { }
    local ey = { }
    local ez = { }
    ex[0], ey[0], ez[0] = entity_hitbox_position(enemy, 1)
    if ex[0] == nil then
        return 0
    end
    ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
    ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
    ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
    ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
    ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
    ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40

    local lx = { }
    local ly = { }
    local lz = { }
    lx[0], ly[0], lz[0] = entity_hitbox_position(entity.get_local_player(), "pelvis")
    if lx[0] == nil then
        return 0
    end
    lx[1], ly[1], lz[1] = lx[0] + 40, ly[0], lz[0]
    lx[2], ly[2], lz[2] = lx[0], ly[0] + 40, lz[0]
    lx[3], ly[3], lz[3] = lx[0] - 40, ly[0], lz[0]
    lx[4], ly[4], lz[4] = lx[0], ly[0] - 40, lz[0]
    lx[5], ly[5], lz[5] = lx[0], ly[0], lz[0] + 40
    lx[6], ly[6], lz[6] = lx[0], ly[0], lz[0] - 40

    local bestdamage = 0
    local cbestdamage = 0
    for i=0, 6 do
        for j=0, 6 do
            local _, damage = client_trace_bullet(enemy, ex[i], ey[i], ez[i], lx[j], ly[j], lz[j])
            if damage > cbestdamage then
                cbestdamage = damage
            end
        end
        if cbestdamage > bestdamage then
            bestdamage = cbestdamage
        end
    end
    return client_scale_damage(entity.get_local_player(), 3, bestdamage)
end

local weapon_idx = { [1] = 4, [2] = 4,[3] = 4,[4] = 4,[7] = 8,[8] = 8,[9] = 7,[10] = 8,[11] = 5,[13] = 8,[14] = 8,[16] = 8,[17] = 9,[19] = 9,[23] = 9,[24] = 9,[25] = 10,[26] = 9,[27] = 10,[28] = 8,[29] = 10,[30] = 4,[31] = 2,  [32] = 4,[33] = 9,[34] = 9,[35] = 10,[36] = 4,[38] = 5,[39] = 8,[40] = 6,[60] = 8,[61] = 4,[63] = 4,[64] = 3}
local config_names = { "Taser", "Heavy Pistol", "Pistol", "Auto", "Scout", "AWP", "Rifle", "SMG", "Shotgun" }

local disable_dt = ui_new_multiselect("RAGE", "Other", "Disable DT on", config_names)
local bit_band = bit.band
client_set_event_callback("setup_command", function(cmd)

    local plocal = entity_get_local_player()

    if not ui_get(enabled) then
        return
    end

    local fps = accumulate_fps()

    local weapon = entity_get_player_weapon(plocal)
    local weapon_id = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)

    local vvval = weapon_idx[weapon_id]
    if vvval ~= nil then
        local wpn = config_names[vvval - 1]
        if wpn ~= nil then
            local contained = contains(ui_get(disable_dt), wpn)
            ui_set(ref_doubletap, not contained)
        else
            ui_set(ref_doubletap, false)
        end
    else
        ui_set(ref_doubletap, false)
    end

    local dtspeed = 1

    local doubletap = ui_get(ref_doubletap) and ui_get(ref_doubletapkey)
    local onshot_aa = ui_get(onshot) and ui_get(onshot_key)

    local exploits = doubletap or onshot_aa

    local localhealth = entity_get_prop(plocal, "m_iHealth")

    local players = entity_get_players(true)

    local fov = 999
    local closestplayer = nil
	for i=1, #players do
		local cur_fov = get_fov(players[i])
		if cur_fov < fov then
			fov = cur_fov
			closestplayer = players[i]
		end
    end
    
	if closestplayer ~= nil and contains(ui_get(settings), "Distance") then
        local ex, ey, ez = entity_get_prop(closestplayer, "m_vecOrigin")
        if ex ~= nil then
            local lx, ly, lz = entity_get_prop(plocal, "m_vecOrigin")
            local dx, dy, dz = ex-lx, ey-ly, ez-lz
            local distance = math_sqrt(dx^2 + dy^2 + dz^2)
    
            dtspeed = math_max(math_min(round(distance / 500), 3), 1)
        end
    end

    if contains(ui_get(settings), "Latency") then
        local latency_inticks = math_floor(client_latency() / (globals_tickinterval() * 10))
        dtspeed = math_min(dtspeed + latency_inticks, 3)
    end

    if contains(ui_get(settings), "Fps") then
        if fps < 60 then
            dtspeed = 4
        end
    end

    if contains(ui_get(settings), "Local player lethal") then
        if closestplayer ~= nil then
            local damage = getdamage(closestplayer)
            if damage > localhealth then
                dtspeed = 1
            end
        end
    end

    ui_set(ref_dtreserve, dtspeed)

    if dtspeed ~= 1 or not doubletap then
        ui_set(slow_key, "On hotkey")
        dt_data.ticks = 0
        dt_data.target = 0
        return
    end

    if dt_data.ticks > 0 and dt_data.ticks <= ui_get(maxprocticks) and entity_is_alive(dt_data.target) then   

        ui_set(slow_key, "Always on")

        if cmd.chokedcommands == 1 then
            cmd.in_attack = 1
        end

        dt_data.ticks = dt_data.ticks + 1
    else
        ui_set(slow_key, "On hotkey")
        dt_data.ticks = 0
    end
end)

client_set_event_callback("paint", function(c)
    local plocal = entity_get_local_player()

    if plocal == nil or not entity_is_alive(plocal) then
		return
    end
    
    local doubletap = ui_get(ref_doubletap) and ui_get(ref_doubletapkey)
    if not ui_get(enabled) or not doubletap then
        return
    end

    if not contains(ui_get(settings), "Speed indicator") then
        return
    end

    local percentage = (ui_get(ref_dtreserve) / 10 - 1) * -1

    local r, g, b = rgb_percent(percentage)

    local y = indicator(r, g, b, 255, "Hitler's DT-Speed: " .. tostring(math.floor(percentage * 100 + 10)) .. "%")
end)

client_set_event_callback("aim_fire", function(e)
    local plocal = entity_get_local_player()
    
    local doubletap = ui_get(ref_doubletap) and ui_get(ref_doubletapkey) and not ui_get(fake_duck)

    if not doubletap then
        dt_data.ticks = 0
        dt_data.target = 0
        return
    end

    if dt_data.ticks > 0 then
        dt_data.ticks = 0
    else
        dt_data.ticks = 1
        dt_data.target = e.target
    end
end)