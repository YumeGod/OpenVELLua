local bit = require("bit")
local client_visible, entity_hitbox_position, math_abs, math_atan, table_remove = client.visible, entity.hitbox_position, math.abs, math.atan, table.remove
local ui_new_label, ui_reference, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_set, ui_get, ui_set_callback, ui_set_visible = ui.new_label, ui.reference, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.set, ui.get, ui.set_callback, ui.set_visible
local client_log, client_color_log, client_set_event_callback = client.log, client.color_log, client.set_event_callback
local entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_is_alive = entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.is_alive
local bit_band = bit.band
local client_screen_size, renderer_text = client.screen_size, renderer.text
local plist_set, plist_get = plist.set, plist.get



local localplayerteam = nil


local ui_get = ui.get
local ui_set = ui.set
local client_visible = client.visible
local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop
local client_world_to_screen = client.world_to_screen
local client_screen_size = client.screen_size
local entity_get_players = entity.get_players
local entity_hitbox_position = entity.hitbox_position 
local entity_is_enemy = entity.is_enemy

local config_names = { "Global", "Taser", "Heavy Pistol", "Pistol", "Auto", "Scout", "AWP", "Rifle", "SMG", "Shotgun" }
local weapon_idx = { [1] = 3, [2] = 4,[3] = 4,[4] = 4,[7] = 8,[8] = 8,[9] = 7,[10] = 8,[11] = 5,[13] = 8,[14] = 8,[16] = 8,[17] = 9,[19] = 9,[23] = 9,[24] = 9,[25] = 10,[26] = 9,[27] = 10,[28] = 8,[29] = 10,[30] = 4,[31] = 2,  [32] = 4,[33] = 9,[34] = 9,[35] = 10,[36] = 4,[38] = 5,[39] = 8,[40] = 6,[60] = 8,[61] = 4,[63] = 4,[64] = 3}

local stored_target = nil
local old_minimum_damage = 0

local using_visible_dmg = false
local ref_minimum_damage = ui.reference("rage", "aimbot", "Minimum damage")
local ref_hitchance = ui.reference("rage", "aimbot", "Minimum hit chance")
local ref_prefer_body_aim = ui.reference("rage", "other", "Prefer body aim")
local custom_minimum_damage = ui.new_checkbox("rage", "aimbot", "Custom minimum damage")
local old_minimum_damage = ui.new_slider('rage', 'aimbot', 'Default minimum damage', 0, 126, 0)
local visible_minimum_damage = ui.new_slider('rage', 'aimbot', 'Visible minimum damage', 0, 126, 0)
local override_minimum_damage = ui.new_slider('rage', 'aimbot', 'Override damage', 0, 126, 0)
local cc9 = ui.new_label("rage", "aimbot","=============================")
local old_minimum_hitchance = ui.new_slider('rage', 'aimbot', 'Default minimum hitchance', 0, 100, 50)
local custom_noscope_hitchance = ui.new_checkbox("rage", "aimbot", "Custom noscope hitchance")
local noscope_minimum_hitchance = ui.new_slider('rage', 'aimbot', 'Noscope minimum hitchance', 0, 100, 44)
local custom_air = ui.new_checkbox("rage", "aimbot", "Custom Air Mode")
local air_minimum_damage = ui.new_slider('rage', 'aimbot', 'Air damage', 0, 126, 0)
local air_minimum_hitchance = ui.new_slider('rage', 'aimbot', 'Air hitchance', 0, 100, 50)
local hotkey = ui.new_hotkey('rage', 'aimbot', 'Override Damage Hotkey')
local indicatortype = ui.new_combobox("Rage", "aimbot", "indicator Type", {"None", "Simplified", "Full"})
--local key = ui.new_combobox("Rage", "Aimbot", "Force safe point key", "Always on","On hotkey","Toggle","Off hotkey")
--local fsp = ui.reference("Rage","Aimbot","Force safe point")
local safe_point_in_air = ui_new_checkbox("RAGE", "Aimbot", "Force safe point in air")
local lethal_high = ui.new_checkbox("rage", "Aimbot", "Priority shot lethal enemy")
local awp_high = ui.new_checkbox("rage", "Aimbot", "Priority shot awper enemy")
local antiaim_high = ui.new_checkbox("rage", "Aimbot", "Priority shot rage enemy")
local cc3 = ui.new_label("rage", "other","=================================")
local cc = ui.new_label("rage", "other","----------Dynamic Hitbox Extra by Hitler----------")
local predictive_baim = ui.new_checkbox("RAGE", 'Other' , "Predictive body aim")
local high_pitch = ui.new_checkbox("rage", "other", "Prefer high pitch enemy head")
local side_ways = ui.new_checkbox("rage", "other", "Prefer side way enemy head")
local small_desync = ui.new_checkbox("rage", "other", "Prefer inaccuracy enemy head")
local fast_speed = ui.new_checkbox("rage", "other", "Prefer fast enemy head")
local duck_head = ui.new_checkbox("rage", "other", "Prefer crouch enemy head")
local duck_head_T = ui.new_checkbox("rage", "other", "Prefer crouch T enemy head")
local duck_body = ui.new_checkbox("rage", "other", "Prefer crouch enemy body")
local duck_safe = ui.new_checkbox("rage", "other", "Force crouch enemy safe point")
local duck_bodyfs = ui.new_checkbox("rage", "other", "Force crouch enemy body")
local slow_speed_body = ui.new_checkbox("rage", "other", "Prefer slow enemy body")
local slow_speed_safe = ui.new_checkbox("rage", "other", "Force slow enemy safe point")
local slow_speed_bodyfs = ui.new_checkbox("rage", "other", "Force slow enemy body")
local x_hp_body = ui.new_slider('rage', "other", 'Prefer <X HP enemy body', 0, 100, 0)
local x_hp_bodyfs = ui.new_slider('rage', "other", 'Force <X HP enemy body', 0, 100, 0)
local x_hp_safe = ui.new_slider('rage', "other", 'Force <X HP enemy safe point', 0, 100, 0)
local x_shots_body = ui.new_slider('rage', "other", 'Prefer <X shots enemy body', 0, 5, 0)
local x_shots_bodyfs = ui.new_slider('rage', "other", 'Force <X shots enemy body', 0, 5, 0)
local x_shots_safe = ui.new_slider('rage', "other", 'Force <X shots enemy safe point', 0, 5, 0)
local aim_miss_body = ui.new_slider('rage', "other", 'Force X misses enemy body', 0, 10, 0)
local aim_miss_safe = ui.new_slider('rage', "other", 'Force X misses enemy safe point', 0, 10, 0)
local cc1 = ui.new_label("rage", "other","---------------------------------------------------------")
local cc4 = ui.new_label("rage", "other","=================================")
local enable_ref_pro = ui.new_checkbox("PLAYERS", "Adjustments", "Priority shot this enemy")
client.color_log(255, 255, 0, "Mindmg-Pro by Hitler Q3487510691")

local missLogs = {}
for i=1, 64 do
	missLogs[i] = 0
end

--//helpers
local function vec2_distance(f_x, f_y, t_x, t_y)
	local delta_x, delta_y = f_x - t_x, f_y - t_y
	return math.sqrt(delta_x*delta_x + delta_y*delta_y)
end

local function extrapolate_position(xpos,ypos,zpos,ticks,ent)
	x,y,z = entity.get_prop(ent, "m_vecVelocity")
	for i=0, ticks do
		xpos =  xpos + (x*globals.tickinterval())
		ypos =  ypos + (y*globals.tickinterval())
		zpos =  zpos + (z*globals.tickinterval()  + (9.81 * ((globals.tickinterval())* (globals.tickinterval()) / 2)))
	end
	return xpos,ypos,zpos
end

local function ent_speed(index)
	local x,y,z = entity.get_prop(index, "m_vecVelocity")
	if x == nil then
		return 0
	end
	return math.sqrt(x * x + y * y + z * z)
end

local function ent_speed_2d(index)
	local x,y,z = entity.get_prop(index, "m_vecVelocity")
	return math.sqrt(x * x + y * y)
end


local function max_desync(entityindex)
	local spd = math.min(260, ent_speed_2d(entityindex))
	local walkfrac = math.max(0, math.min(1, spd / 135))
	local mult = 1 - 0.5*walkfrac
	local duckamnt = entity.get_prop(entityindex, "m_flDuckAmount")
	
	if duckamnt > 0 then
		local duckfrac = math.max(0, math.min(1, spd / 88))
		mult = mult + ((duckamnt * duckfrac) * (0.5 - mult))
	end
	
	return(58 * mult)
end

local function is_moving(index)
	local x,y,z = entity.get_prop(index, "m_vecVelocity")
	return math.sqrt(x * x + y * y + z * z) > 1.0
end

local function is_x_shots(local_player,target,shots)
	
	local px, py, pz = entity.hitbox_position(target, 6) -- middle chest
	local px1, py1, pz1 = entity.hitbox_position(target, 4) -- upper chest
	local px2, py2, pz2 = entity.hitbox_position(target, 2) -- pelvis
	local lx,ly,lz = client.eye_position()
	if is_moving(local_player) and ui.get(predictive_baim) then
		lx,ly,lz = extrapolate_position(lx,ly,lz,20,local_player)
	end
	
	for i=0, 2 do
	
		if i==0 then
			entindex,dmg = client.trace_bullet(local_player,lx,ly,lz,px,py,pz)
		else 
			if i==1 then
				entindex,dmg = client.trace_bullet(local_player,lx,ly,lz,px1,py1,pz1)
			else
				entindex,dmg = client.trace_bullet(local_player,lx,ly,lz,px2,py2,pz2)
			end
		end
		
		
		if entindex == nil then
			return false
		end
		
		if entindex == local_player then
			return false
		end
		
		if not entity.is_enemy(entindex) then
			return false
		end
		
		if dmg >= (entity.get_prop(target, "m_iHealth") / shots) then
			return true
		end
	end
	return false
end

local function normalize_yaw(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end

local function calc_angle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
	local ydelta = localplayerypos - enemyypos
	local xdelta = localplayerxpos - enemyxpos
    local relativeyaw = math_atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
    return relativeyaw
end

local function clear_misses(index)
	missLogs[index] = 0
end

local function get_all_player_positions(ctx, screen_width, screen_height, enemies_only)
	local player_indexes = {}
	local player_positions = {}

	local players = entity_get_players(enemies_only) -- true = enemies only
	if #players == 0 then
		return
	end

	for i=1, #players do
		local player = players[i]

		local px, py, pz = entity_get_prop(player, "m_vecOrigin")
		local vz = entity_get_prop(player, "m_vecViewOffset[2]")

		if pz ~= nil and vz ~= nil then
            pz = pz + (vz*0.5)

            local sx, sy = client_world_to_screen(ctx, px, py, pz)
            if sx ~= nil and sy ~= nil then
                if sx >= 0 and sx <= screen_width and sy >= 0 and sy <= screen_height then 
					player_indexes[#player_indexes+1] = player
                    player_positions[#player_positions+1] = {sx, sy}
                end
            end
		end
	end
	
	return player_indexes, player_positions
end

local function check_fov(ctx)
    local screen_width, screen_height = client_screen_size()
    local screen_center_x, screen_center_y = screen_width*0.5, screen_height*0.5
	local fov_limit = 250 --this value is in pixels	
	
	if get_all_player_positions(ctx, screen_width, screen_height, true) == nil then
		return
	end
	local enemy_indexes, enemy_coords = get_all_player_positions(ctx, screen_width, screen_height, true)
	
	if #enemy_indexes <= 0 then
		return true
	end
	
	if #enemy_coords == 0 then
		return true
	end
	
	local closest_fov = 133337
	local closest_entindex = 133337

	for i=1, #enemy_coords do
		local x = enemy_coords[i][1]
		local y = enemy_coords[i][2]

		local current_fov = vec2_distance(x, y, screen_center_x, screen_center_y)
		if current_fov < closest_fov then
			closest_fov = current_fov -- found a target that is closer to center of our screen
			closest_entindex = enemy_indexes[i]
		end
	end

	return closest_fov > fov_limit, closest_entindex
end

local function can_see(ent)	
    for i=0, 18 do
		if client_visible(entity_hitbox_position(ent, i)) then
			return true
		end
	end
	return false
end

local function on_paint(ctx)
	
	if not ui.get(custom_minimum_damage) then
		return
	end
	
	
	
	if ui_get(custom_air) then
       local local_player = entity_get_local_player()
       if local_player == nil or entity_get_prop(local_player, "m_lifeState") ~= 0 then 
	    return
       end
       local velocity_x, velocity_y, velocity_z  = entity_get_prop(local_player, "m_vecVelocity")
       local onground = velocity_z == 0
       if onground == false then
	    ui_set(ref_minimum_damage,  ui.get(air_minimum_damage))
	    ui_set(ref_hitchance,  ui.get(air_minimum_hitchance))
	    client.draw_indicator(c, 255,255,0,255, "Hitler's Air Mode ☁" )
		return
	   end
	end

	local local_entindex = entity_get_local_player()
	local IsScoped = entity.get_prop(local_entindex, "m_bIsScoped") ~= 0 and true or false

	
	if ui.get(custom_noscope_hitchance) and not IsScoped then
		ui_set(ref_hitchance,ui.get(noscope_minimum_hitchance))
	elseif ui.get(custom_noscope_hitchance) and IsScoped or ui.get(custom_air) then
		ui_set(ref_hitchance,ui.get(old_minimum_hitchance))
	end
	
	if entity_get_prop(local_entindex, "m_lifeState") ~= 0 then
		using_visible_dmg = false
		
		return
	end
	
	local enemy_visible, enemy_entindex = check_fov(ctx)
	if enemy_entindex == nil then
		ui_set(ref_minimum_damage,  ui.get(old_minimum_damage))
		return
	end
	
	if enemy_visible and enemy_entindex ~= nil and stored_target ~= enemy_entindex then
		stored_target = enemy_entindex
	end
	
	local visible = can_see(enemy_entindex)
	if visible then
		using_visible_dmg = true
		ui_set(ref_minimum_damage,  ui.get(visible_minimum_damage))
	else 
		using_visible_dmg = false
		ui_set(ref_minimum_damage,  ui.get(old_minimum_damage))
	end
	stored_target = enemy_entindex
	
	
	
end

local function run_adjustments()

    local plocal = entity_get_local_player()

    if not entity_is_alive(plocal) or not ui_get(custom_minimum_damage) then
        return
    end


    local players = entity_get_players(true)

    local lox, loy, loz = entity_get_prop(plocal, "m_vecOrigin")

    for i=1, #players do

        local idx = players[i]

        
		local pitch, yaw, roll = entity_get_prop(idx, "m_angEyeAngles")
        local enemy_manual_high, enemy_awp_high, enemy_antiaim_high, enemy_lethal_high, enemy_duck_head_T, enemy_x_shots_body, enemy_x_shots_bodyfs, enemy_x_shots_safe, enemy_x_hp_body, enemy_x_hp_bodyfs, enemy_x_hp_safe, enemy_duck_safe, enemy_duck_body, enemy_duck_head, enemy_duck_bodyfs, enemy_high_pitch, enemy_side_ways, enemy_small_desync, enemy_in_air_safe, misses_x_shot_body, misses_x_shot_safe, enemy_fast_speed, enemy_slow_speed_body, enemy_slow_speed_safe, enemy_slow_speed_bodyfs = false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false

        if ui.get(high_pitch) then
            if pitch ~= nil then
                enemy_high_pitch = pitch < 10
            end
        end

        if ui.get(side_ways) then
            local eox, eoy, eoz = entity_get_prop(idx, "m_vecOrigin")
            if eox ~= nil and yaw ~= nil then

                local at_targets = normalize_yaw(calc_angle(lox, loy, eox, eoy) + 180)
                local left_delta = math_abs(normalize_yaw(yaw - (at_targets - 90)))
                local right_delta = math_abs(normalize_yaw(yaw - (at_targets + 90)))
                enemy_side_ways = left_delta < 30 or right_delta < 30
            end
		end
		
		if ui.get(small_desync) then
			local t = max_desync(idx)
			enemy_small_desync = t < 28
		end

		if ui.get(safe_point_in_air) then
			enemy_in_air_safe = (bit.band(entity_get_prop(idx, "m_fFlags"), 1) == 0)
		end

		if ui.get(aim_miss_body) > 0 then
			misses_x_shot_body = missLogs[idx] >= ui.get(aim_miss_body)
		end

		if ui.get(aim_miss_safe) > 0 then
			misses_x_shot_safe = missLogs[idx] >= ui.get(aim_miss_safe)
		end

		if ui.get(fast_speed) then
			enemy_fast_speed = ent_speed(idx) > 137 
		end

		if ui.get(slow_speed_body) then
			enemy_slow_speed_body = (ent_speed(idx) > 1.0 and ent_speed(idx) < 80)
		end

		if ui.get(slow_speed_safe) then
			enemy_slow_speed_safe = (ent_speed(idx) > 1.0 and ent_speed(idx) < 80)
		end

		if ui.get(slow_speed_bodyfs) then
			enemy_slow_speed_bodyfs = (ent_speed(idx) > 1.0 and ent_speed(idx) < 80)
		end

		if ui.get(duck_head) then
			local duck_ammount = entity.get_prop(idx, "m_flDuckAmount")
			enemy_duck_head = duck_ammount >= 0.7
		end

		if ui.get(duck_head_T) then
			local team = entity_get_prop(idx,"m_iTeamNum")
			if team == 2 then
			    local duck_ammount = entity.get_prop(idx, "m_flDuckAmount")
			    enemy_duck_head_T = duck_ammount >= 0.7
			end
		end

		if ui.get(duck_body) then
			local duck_ammount = entity.get_prop(idx, "m_flDuckAmount")
			enemy_duck_body = duck_ammount >= 0.7
		end

		if ui.get(duck_safe) then
			local duck_ammount = entity.get_prop(idx, "m_flDuckAmount")
			enemy_duck_safe = duck_ammount >= 0.7
		end

		if ui.get(duck_bodyfs) then
			local duck_ammount = entity.get_prop(idx, "m_flDuckAmount")
			enemy_duck_bodyfs = duck_ammount >= 0.7
		end

		if ui.get(x_shots_body) > 0 then
			enemy_x_shots_body = is_x_shots(plocal,idx,ui.get(x_shots_body))
		end 

		if ui.get(x_shots_bodyfs) > 0 then
			enemy_x_shots_bodyfs = is_x_shots(plocal,idx,ui.get(x_shots_bodyfs))
		end 

		if ui.get(x_shots_safe) > 0 then
			enemy_x_shots_safe = is_x_shots(plocal,idx,ui.get(x_shots_safe))
		end 

		if ui.get(awp_high) then
			local weapon = entity_get_player_weapon(idx)
            if weapon ~= nil then
                local weapon_id = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
                enemy_awp_high = (config_names[weapon_idx[weapon_id]] == "AWP")
			end
		end

		if ui.get(lethal_high) then
			enemy_lethal_high = is_x_shots(plocal,idx,1)
		end

		if ui.get(antiaim_high) then
			enemy_antiaim_high = plist_get(idx ,"Correction active")
		end 

		enemy_manual_high = plist_get(idx ,"Priority shot this enemy")
		enemy_x_hp_body = entity.get_prop(idx,"m_iHealth") <= ui.get(x_hp_body)
		enemy_x_hp_bodyfs = entity.get_prop(idx,"m_iHealth") <= ui.get(x_hp_bodyfs)
		enemy_x_hp_safe = entity.get_prop(idx,"m_iHealth") <= ui.get(x_hp_safe)

		local enemy_baim = enemy_high_pitch or enemy_side_ways or enemy_small_desync or enemy_duck_head or enemy_duck_head_T
		local enemy_safe =  enemy_in_air_safe or misses_x_shot_safe or enemy_slow_speed_safe or enemy_duck_safe or enemy_x_hp_safe or enemy_x_shots_safe
		local enemy_prefer_baim = enemy_slow_speed_body or enemy_duck_body or enemy_x_hp_body or enemy_x_shots_body
		local enemy_force_baim = misses_x_shot_body or enemy_duck_bodyfs or enemy_x_hp_bodyfs or enemy_x_shots_bodyfs
		local enemy_highpro = enemy_awp_high or enemy_lethal_high or enemy_antiaim_high or enemy_manual_high
		local baim_ref = "-"
		if enemy_force_baim then
			baim_ref = "Force"
		elseif enemy_baim then
			baim_ref = "Off"
		elseif enemy_prefer_baim and not ui.get(ref_prefer_body_aim) then
			baim_ref = "On"
		end
		plist_set(idx, "High priority", enemy_highpro)
		plist_set(idx, "Override prefer body aim", baim_ref)
		plist_set(idx, "Override safe point", enemy_safe and "On" or "-")
    end

end

client_set_event_callback("paint", run_adjustments)

client.set_event_callback("paint", function(c) 
	if ui.get(custom_minimum_damage) then
		if ui.get(hotkey) then
		ui_set(ref_minimum_damage,  ui.get(override_minimum_damage))
		else
			on_paint()	
		end	
	end
	local dmgvis = ""
	if ui.get(ref_minimum_damage) <= 100 and ui.get(ref_minimum_damage) >= 1 then
		dmgvis = ui.get(ref_minimum_damage)
	elseif ui.get(ref_minimum_damage) < 1 then
		dmgvis = "Auto"
	elseif ui.get(ref_minimum_damage) > 100 then
		dmgvis = "HP+" .. (ui.get(ref_minimum_damage) - 100)
	end
	if ui.get(indicatortype) == "Full" then
	client.draw_indicator(c, 255,20,147, 255, "Hitler's DMG -> " .. dmgvis)
	elseif ui.get(indicatortype) == "Simplified" and ui.get(hotkey) then
		client.draw_indicator(c, 191,62,255,255, "Hitler's Override Mode" )
	end
	--local pitch, yaw, roll = entity_get_prop(entity_get_local_player(), "m_angEyeAngles")
	--client.draw_indicator(c, 255,20,147, 255, "Hitler's Pitch -> " .. pitch)
	--ui.set(fsp, ui.get(key))
end)

client.set_event_callback("aim_miss", function(c)
	if c.reason ~= "spread" then
		local t = c.target
		if missLogs[t] == nil then
			missLogs[t] = 1
			client.delay_call(5,clear_misses,t)
		else
			missLogs[t] = missLogs[t] + 1
			client.delay_call(5,clear_misses,t)
		end
	end
end)

client.set_event_callback("player_hurt", function(c)
	local i = client.userid_to_entindex(c.userid)
	if c.health == 0 then
		missLogs[i] = 0
	end
end)

client.set_event_callback("round_end", function(c)
	for i=1, 64 do
		missLogs[i] = 0
	end
end)

client.set_event_callback("cs_game_disconnected", function(c) 
	ui.set(ui.reference("PLAYERS", "Players", "Reset all"), true)
	
	for i=1, 64 do
		missLogs[i] = 0
	end
	
end)

client.set_event_callback("game_newmap", function(c) 
	ui.set(ui.reference("PLAYERS", "Players", "Reset all"), true)
	
	for i=1, 64 do
		missLogs[i] = 0
	end
	
end)

client.set_event_callback("player_team", function(c)
	client.update_player_list()
	local plocal = entity_get_local_player()
	if client.userid_to_entindex(c.userid) ~= plocal then return end
	client.log(c.team)

end)

client.set_event_callback("round_prestart", function(c)
	client.update_player_list()
end)

