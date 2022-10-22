--local variables for API. Automatically generated by https://github.com/simpleavaster/gslua/blob/master/authors/sapphyrus/generate_api.lua 
local client_latency, client_set_clan_tag, client_log, client_draw_rectangle, client_draw_indicator, client_draw_circle_outline, client_timestamp, client_world_to_screen, client_userid_to_entindex = client.latency, client.set_clan_tag, client.log, client.draw_rectangle, client.draw_indicator, client.draw_circle_outline, client.timestamp, client.world_to_screen, client.userid_to_entindex 
local client_draw_circle, client_draw_gradient, client_set_event_callback, client_screen_size, client_trace_line, client_draw_text, client_color_log = client.draw_circle, client.draw_gradient, client.set_event_callback, client.screen_size, client.trace_line, client.draw_text, client.color_log 
local client_system_time, client_delay_call, client_visible, client_exec, client_open_panorama_context, client_set_cvar, client_eye_position = client.system_time, client.delay_call, client.visible, client.exec, client.open_panorama_context, client.set_cvar, client.eye_position 
local client_draw_hitboxes, client_get_cvar, client_draw_line, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.draw_hitboxes, client.get_cvar, client.draw_line, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float 
local entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all = entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all 
local entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname 
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval 
local globals_framecount, globals_frametime, globals_maxplayers = globals.framecount, globals.frametime, globals.maxplayers 
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set 
local ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get 
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos 
local math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad 
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert 
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub 
local renderer_line, renderer_indicator, renderer_world_to_screen, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text = renderer.line, renderer.indicator, renderer.world_to_screen, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text 
--end of local variables 

local grenade_timer_reference = ui.new_multiselect("VISUALS", "Other ESP", "Grenades: Timer ", "Text", "Bar")
local smoke_radius_reference = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Smoke radius")
local smoke_radius_color_reference = ui.new_color_picker("VISUALS", "Other ESP", "Grenades: Smoke radius", 61, 147, 250, 180)
local molotov_radius_reference = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Molotov radius")
local molotov_radius_color_reference = ui.new_color_picker("VISUALS", "Other ESP", "Grenades: Molotov radius", 255, 63, 63, 190)
local molotov_team_reference = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Molotov team")

local legacy_timer_reference = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Timer")
local function on_legacy_timer_changed()
	if ui_get(legacy_timer_reference) and #ui_get(grenade_timer_reference) == 0 then
		ui_set(grenade_timer_reference, {"Text"})
		ui_set(legacy_timer_reference, false)
	end
end
ui.set_callback(legacy_timer_reference, on_legacy_timer_changed)
ui.set_visible(legacy_timer_reference, false)

--I hate having to do this
local smoke_radius_units = 125
local smoke_duration = 17.55
local molotov_duration = 7

local molotovs = {}
local molotovs_temp = {}
local molotovs_created_at = {}
local molotovs_cells = {}

local bar_enabled = true
local bar_width = 26

local MOVETYPE_NOCLIP = 8

local function distance(x1, y1, x2, y2)
	return math_sqrt((x2-x1)^2 + (y2-y1)^2)
end

local function contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then 
			return true
		end
	end
	return false
end

local function draw_bar(x, y, w, r, g, b, a, percentage, ltr, rev, outline)
	local ltr = ltr == nil and true or ltr
	local rev = rev == nil and false or rev
	local outline = outline == nil and true or outline

	local h = 4
	
	if not (outline and (w > 2 and h > 2) or (w > 0 or h > 0)) then
		error("Invalid arguments. Width and/or height too small")
	end

	local percentage = math_max(0, math_min(1, percentage))

	local x_inner, y_inner = x, y
	local w_inner, h_inner = w, h
	local x_inner_add, y_inner_add = 0, 0

	--outline makes inner rectangle smaller
	if outline then
		w_inner, h_inner = w_inner-2, h_inner-2
		x_inner, y_inner = x_inner+1, y_inner+1
	end

	local w_inner_prev = w_inner
	w_inner, h_inner = math_ceil(w_inner * percentage), h_inner

	--handle reverse bar
	if rev then
		x_inner_add = (w_inner_prev - w_inner)
	end

	--flip width and height if we're dealing with a vertical bar
	if not ltr then
		w, h = h, w
		w_inner, h_inner = h_inner, w_inner
		x_inner_add, y_inner_add = y_inner_add, x_inner_add
	end
	
	local outline_r, outline_b, outline_g, outline_a = 16, 16, 16, 170
	if outline then
		renderer_rectangle(x, y, w, h, outline_r, outline_b, outline_g, outline_a)
	end

	renderer_rectangle(x_inner+x_inner_add, y_inner+y_inner_add, w_inner, h_inner, r, g, b, a)

	return x_inner+x_inner_add, y_inner+y_inner_add, w_inner, h_inner
end

local function is_player(entindex)
    return entity_get_classname(entindex) == "CCSPlayer"
end

local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage)
	local x = (x2 - x1) * percentage + x1
	local y = (y2 - y1) * percentage + y1
	local z = (z2 - z1) * percentage + z1
	return x, y, z
end

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

local function trace_line_skip(skip_function, x1, y1, z1, x2, y2, z2, max_traces)
    local max_traces = max_traces or 10
    local fraction, entindex_hit = 0, -1
    local x_hit, y_hit, z_hit = x1, y1, z1
    local skip_entindex = -1

    local i=1
    while (entindex_hit == -1 or (entindex_hit ~= 0 and skip_function(entindex_hit))) and 1 > fraction and max_traces >= i do
        fraction, entindex_hit = client_trace_line(entindex_hit, x_hit, y_hit, z_hit, x2, y2, z2)
        x_hit, y_hit, z_hit = lerp_pos(x_hit, y_hit, z_hit, x2, y2, z2, fraction)

        i = i + 1
    end

    local traveled_total = distance3d(x1, y1, z1, x_hit, y_hit, z_hit)
    local total_distance = distance3d(x1, y1, z1, x2, y2, z2)

    return traveled_total/total_distance, entindex_hit
end

local function draw_ground_circle_3d(x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
	local accuracy = accuracy ~= nil and accuracy or 3
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1

	local screen_x_line_old, screen_y_line_old
	for rot=start_degrees, percentage*360, accuracy do
		local rot_temp = math_rad(rot)
		local lineX, lineY, lineZ = radius * math_cos(rot_temp) + x, radius * math_sin(rot_temp) + y, z

		local distance = 256

		--local screen_x_line, screen_y_line = renderer_world_to_screen(lineX, lineY, lineZ+distance/2)
		--renderer.text(screen_x_line, screen_y_line-5, 255, 255, 255, 255, "c-", 0, "START")
		--local screen_x_line, screen_y_line = renderer_world_to_screen(lineX, lineY, lineZ-distance/2)
		--renderer.text(screen_x_line, screen_y_line-5, 255, 255, 255, 255, "c-", 0, "END")

		local fraction, entindex_hit = client_trace_line(-1, lineX, lineY, lineZ+distance/2, lineX, lineY, lineZ-distance/2)
		if fraction > 0 and 1 > fraction then
			lineZ = lineZ+distance/2-(distance * fraction)
		end

		local screen_x_line, screen_y_line = renderer_world_to_screen(lineX, lineY, lineZ)
		--renderer.text(screen_x_line, screen_y_line-5, 255, 255, 255, 255, "c-", 0, fraction)
		if screen_x_line ~=nil and screen_x_line_old ~= nil then
			for i=1, width do
				local i=i-1
				renderer_line(screen_x_line, screen_y_line-i, screen_x_line_old, screen_y_line_old-i, r, g, b, a)
			end
			if outline then
				local outline_a = a/255*160
				renderer_line(screen_x_line, screen_y_line-width, screen_x_line_old, screen_y_line_old-width, 16, 16, 16, outline_a)
				renderer_line(screen_x_line, screen_y_line+1, screen_x_line_old, screen_y_line_old+1, 16, 16, 16, outline_a)
			end
		end
		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

local function draw_circle_3d(x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
	local accuracy = accuracy ~= nil and accuracy or 3
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1

	local screen_x_line_old, screen_y_line_old
	for rot=start_degrees, percentage*360, accuracy do
		local rot_temp = math_rad(rot)
		local lineX, lineY, lineZ = radius * math_cos(rot_temp) + x, radius * math_sin(rot_temp) + y, z
		local screen_x_line, screen_y_line = renderer_world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~=nil and screen_x_line_old ~= nil then
			for i=1, width do
				local i=i-1
				renderer_line(screen_x_line, screen_y_line-i, screen_x_line_old, screen_y_line_old-i, r, g, b, a)
			end
			if outline then
				local outline_a = a/255*160
				renderer_line(screen_x_line, screen_y_line-width, screen_x_line_old, screen_y_line_old-width, 16, 16, 16, outline_a)
				renderer_line(screen_x_line, screen_y_line+1, screen_x_line_old, screen_y_line_old+1, 16, 16, 16, outline_a)
			end
		end
		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

local function lerp(a, b, percentage)
	return b + (b - a) * percentage
end

local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage)
	local x = (x2 - x1) * percentage + x1
	local y = (y2 - y1) * percentage + y1
	local z = (z2 - z1) * percentage + z1
	return x, y, z
end

local function is_molotov_burning(molotov)
	local fire_count = entity_get_prop(molotov, "m_fireCount")
	return fire_count ~= nil and fire_count > 0

	--for i=1, 64 do
	--	if entity_get_prop(molotov, "m_bFireIsBurning", i) == 1 then
	--		return true
	--	end
	--end
	--return false
end

local function on_player_connect_full(e)
	if client_userid_to_entindex(e.userid) == entity_get_local_player() then
		molotovs = {}
		molotovs_temp = {}
	end
end
client.set_event_callback("player_connect_full", on_player_connect_full)

local function on_run_command(e)
	if not ui_get(molotov_radius_reference) then
		return
	end

	--reset everything, get molotovs
	molotovs_temp = {}
	molotovs_cells = {}
	molotovs = entity_get_all("CInferno")

	if #molotovs == 0 then
		return
	end

	local curtime = globals_curtime()

	for i=1, #molotovs do
		local molotov = molotovs[i]
		if is_molotov_burning(molotov) then
			local origin_x, origin_y, origin_z = entity_get_prop(molotov, "m_vecOrigin")

			local cell_radius = 40
			local molotov_radius = 0
			local center_x, center_y, center_z

			local cells = {}
			local cells_checked = {}
			local highest_distance = 0
			local cell_max_1, cell_max_2

			--accumulate burning cells
			for i=1, 64 do
				if entity_get_prop(molotov, "m_bFireIsBurning", i) == 1 then
					local x_delta = entity_get_prop(molotov, "m_fireXDelta", i)
					local y_delta = entity_get_prop(molotov, "m_fireYDelta", i)
					local z_delta = entity_get_prop(molotov, "m_fireZDelta", i)
					table_insert(cells, {x_delta, y_delta, z_delta})
				end
			end

			for i=1, #cells do
				local cell = cells[i]
				local x_delta, y_delta, z_delta = unpack(cell)

				for i2=1, #cells do
					local cell2 = cells[i2]
					local distance = distance(x_delta, y_delta, cell2[1], cell2[2])
					if distance > highest_distance then
						highest_distance = distance
						cell_max_1 = cell
						cell_max_2 = cell2
					end
				end
			end

			if cell_max_1 ~= nil and cell_max_2 ~= nil then
				local x1, y1, z1 = origin_x+cell_max_1[1], origin_y+cell_max_1[2], origin_z+cell_max_1[3]
				local x2, y2, z2 = origin_x+cell_max_2[1], origin_y+cell_max_2[2], origin_z+cell_max_2[3]

				local center_x_delta, center_y_delta, center_z_delta = lerp_pos(cell_max_1[1], cell_max_1[2], cell_max_1[3], cell_max_2[1], cell_max_2[2], cell_max_2[3], 0.5)
				local center_x, center_y, center_z = origin_x+center_x_delta, origin_y+center_y_delta, origin_z+center_z_delta
				
				local radius = highest_distance/2+cell_radius

				molotovs_temp[molotov] = {center_x, center_y, center_z, radius}
				molotovs_cells[molotov] = cells
			end
		end
	end
end
client.set_event_callback("run_command", on_run_command)


local function on_paint()
	local smoke_radius = ui_get(smoke_radius_reference)
	local grenade_timer_value = ui_get(grenade_timer_reference)
	local grenade_timer = #grenade_timer_value > 0
	local molotov_team = ui_get(molotov_team_reference)
	local molotov_radius = ui_get(molotov_radius_reference)

	local local_player = entity_get_local_player()

	--make everything work while we're dead, dont really need to care about performance
	if local_player == nil or not entity_is_alive(local_player) or entity_get_prop(local_player, "m_MoveType") == MOVETYPE_NOCLIP then
		on_run_command()
	end

	if molotov_radius then
		local r, g, b, a = ui_get(molotov_radius_color_reference)

		for i=1, #molotovs do
			local molotov = molotovs[i]
			if molotovs_temp[molotov] ~= nil then
				local center_x, center_y, center_z, radius = unpack(molotovs_temp[molotov])
				local a_multiplier = 1

				if molotovs_created_at[grenade] ~= nil then
					local time_since_created = curtime - molotovs_created_at[grenade]
					a_multiplier = math_max(0, 1 - time_since_created / molotov_duration)
				end
				draw_circle_3d(center_x, center_y, center_z, radius, r, g, b, a*a_multiplier, 9, 1, true)
			end
		end
	end

	if smoke_radius or grenade_timer or molotov_team then
		local grenades = entity_get_all("CSmokeGrenadeProjectile")
		local tickcount = globals_tickcount()
		local tickinterval = globals_tickinterval()
		local curtime = globals_curtime()

		if grenade_timer or molotov_team then
			local molotovs_created_at_prev = molotovs_created_at
			molotovs_created_at = {}
			for i=1, #molotovs do
				local molotov = molotovs[i]
				if is_molotov_burning(molotov) then
					molotovs_created_at[molotov] = molotovs_created_at_prev[molotov] ~= nil and molotovs_created_at_prev[molotov] or curtime
					table_insert(grenades, molotov)
				end
			end
		end
	
		for i=1, #grenades do
			local grenade = grenades[i]
			local class_name = entity_get_classname(grenade)

			local text, wx, wy
			local percentage = 1
			if class_name == "CSmokeGrenadeProjectile" then
				local x, y, z = entity_get_prop(grenade, "m_vecOrigin")
				wx, wy = renderer_world_to_screen(x, y, z)
				local did_smoke_effect = entity_get_prop(grenade, "m_bDidSmokeEffect") == 1
				if wx ~= nil then

					if did_smoke_effect then
						local ticks_created = entity_get_prop(grenade, "m_nSmokeEffectTickBegin")
						if ticks_created ~= nil then
							local time_since_explosion = tickinterval * (tickcount - ticks_created)
							if time_since_explosion > 0 and smoke_duration-time_since_explosion > 0 then
								if grenade_timer then
									percentage = 1 - time_since_explosion / smoke_duration
									text = string_format("%.1f", smoke_duration-time_since_explosion)
								end
								if smoke_radius then
									local r, g, b, a = ui_get(smoke_radius_color_reference)
									local radius = smoke_radius_units
									if 0.3 > time_since_explosion then
										radius = radius * 0.6 + (radius * (time_since_explosion / 0.3))*0.4
										a = a * (time_since_explosion / 0.3)
									end
									if 1.0 > smoke_duration-time_since_explosion then
										radius = radius * (((smoke_duration-time_since_explosion) / 1.0)*0.3 + 0.7)
									end
									draw_circle_3d(x, y, z, radius, r, g, b, a*math_min(1, percentage*1.3), 9, 1, true)
								end
							end
						end
					end
				end
			elseif class_name == "CInferno" then
				if grenade_timer or molotov_team then
					local x, y, z = entity_get_prop(grenade, "m_vecOrigin")
					wx, wy = renderer_world_to_screen(x, y, z)
					if wx ~= nil then
						if grenade_timer then
							if molotovs_created_at[grenade] ~= nil then

								local time_since_created = curtime - molotovs_created_at[grenade]
								percentage = math_max(0, 1 - time_since_created / molotov_duration)
								text = string_format("%.1f", math_max(0, molotov_duration - time_since_created))
							end
						end
						if molotov_team then
							local thrower = entity_get_prop(grenade, "m_hOwnerEntity")
							local is_safe = false
							if thrower ~= nil and tonumber(client_get_cvar("mp_friendlyfire")) == 0 and thrower ~= local_player and not entity_is_enemy(thrower) then
								is_safe = true
							end
							if is_safe then
								renderer_text(wx-19, wy+5, 149, 184, 6, 255*percentage, nil, 0, "✔")
							else
								renderer_text(wx-19, wy+4, 230, 21, 21, 255*percentage, nil, 0, "❌")
							end
						end
					end
				end
			end
			if wx ~= nil and text ~= nil then
				--(x, y, w, r, g, b, a, percentage, ltr, rev, outline)
				local a = 255
				if 0.08 > percentage then
					a = a * percentage/0.08
				end
				if contains(grenade_timer_value, "Bar") then
					local y_additional = (contains(grenade_timer_value, "Bar") and contains(grenade_timer_value, "Text")) and 1 or 0
					local x_text, _, w_text, _ = draw_bar(wx-bar_width/2+1, wy+16+y_additional, bar_width, 255, 255, 255, a, percentage, true)
					if contains(grenade_timer_value, "Text") and 0.56 > percentage then
						renderer_text(x_text+w_text+5, wy+18+y_additional, 255, 255, 255, a*0.7, "c-", 150, text)
					end
				elseif contains(grenade_timer_value, "Text") then
					renderer_text(wx, wy+20, 255, 255, 255, math_max(30, percentage * 255), "c-", 150, text, "  S")
				end
			end
		end
	end
end
client.set_event_callback("paint", on_paint)
