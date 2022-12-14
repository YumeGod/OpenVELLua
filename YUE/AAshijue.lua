--local variables for API. Automatically generated by https://github.com/simpleavaster/gslua/blob/master/authors/sapphyrus/generate_api.lua 
local client_latency, client_log, client_draw_rectangle, client_draw_circle_outline, client_userid_to_entindex, client_draw_indicator, client_draw_gradient, client_set_event_callback, client_screen_size, client_eye_position = client.latency, client.log, client.draw_rectangle, client.draw_circle_outline, client.userid_to_entindex, client.draw_indicator, client.draw_gradient, client.set_event_callback, client.screen_size, client.eye_position 
local client_draw_circle, client_color_log, client_delay_call, client_draw_text, client_visible, client_exec, client_trace_line, client_set_cvar = client.draw_circle, client.color_log, client.delay_call, client.draw_text, client.visible, client.exec, client.trace_line, client.set_cvar 
local client_world_to_screen, client_draw_hitboxes, client_get_cvar, client_draw_line, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.world_to_screen, client.draw_hitboxes, client.get_cvar, client.draw_line, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float 
local entity_get_local_player, entity_is_enemy, entity_get_player_name, entity_get_steam64, entity_get_bounding_box, entity_get_all, entity_set_prop, entity_get_player_weapon = entity.get_local_player, entity.is_enemy, entity.get_player_name, entity.get_steam64, entity.get_bounding_box, entity.get_all, entity.set_prop, entity.get_player_weapon 
local entity_hitbox_position, entity_get_prop, entity_get_players, entity_get_classname = entity.hitbox_position, entity.get_prop, entity.get_players, entity.get_classname 
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers 
local ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_is_menu_open, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.is_menu_open, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get 
local math_ceil, math_tan, math_log10, math_randomseed, math_cos, math_sinh, math_random, math_huge, math_pi, math_max, math_atan2, math_ldexp, math_floor, math_sqrt, math_deg, math_atan, math_fmod = math.ceil, math.tan, math.log10, math.randomseed, math.cos, math.sinh, math.random, math.huge, math.pi, math.max, math.atan2, math.ldexp, math.floor, math.sqrt, math.deg, math.atan, math.fmod 
local math_acos, math_pow, math_abs, math_min, math_sin, math_frexp, math_log, math_tanh, math_exp, math_modf, math_cosh, math_asin, math_rad = math.acos, math.pow, math.abs, math.min, math.sin, math.frexp, math.log, math.tanh, math.exp, math.modf, math.cosh, math.asin, math.rad 
local table_maxn, table_foreach, table_sort, table_remove, table_foreachi, table_move, table_getn, table_concat, table_insert = table.maxn, table.foreach, table.sort, table.remove, table.foreachi, table.move, table.getn, table.concat, table.insert 
local string_find, string_format, string_rep, string_gsub, string_len, string_gmatch, string_dump, string_match, string_reverse, string_byte, string_char, string_upper, string_lower, string_sub = string.find, string.format, string.rep, string.gsub, string.len, string.gmatch, string.dump, string.match, string.reverse, string.byte, string.char, string.upper, string.lower, string.sub 
--end of local variables 


local real_ref=ui.new_checkbox("VISUALS", "Player ESP","Show Real")
local real_color_reference = ui.new_color_picker("VISUALS", "Player ESP", "Real Color", 0, 173, 55, 255)
local lby_ref=ui.new_checkbox("VISUALS", "Player ESP","Show Lby")
local lby_color_reference = ui.new_color_picker("VISUALS", "Player ESP", "LBY Color", 251, 0, 0, 255)
local long = ui.new_slider("VISUALS", "Player ESP", "Distance", 1, 100, 40, true)
local screen_width, screen_height = client.screen_size()

local function on_paint(ctx)
		local local_player = entity_get_local_player()

		if local_player == nil then
			return
		end

		if entity_get_prop(local_player, "m_lifeState") ~= 0 then
			return
		end

		local locationX, locationY, locationZ = client_eye_position()
		locationZ = locationZ - entity_get_prop(local_player, "m_vecViewOffset[2]") - 1

		local x,y=client.screen_size()
		local length=ui.get(long)

		if ui.get(real_ref) or ui.get(lby_ref)then
			renderer.circle_outline(x/2, y/2, 0, 0, 0, 155, length, 0, 1, 5)
		end
			
		if ui.get(real_ref) then
				local real_r, real_g, real_b, real_a = ui_get(real_color_reference)				
				local headX, headY, headZ = entity_hitbox_position(local_player, 0)
				local deltaX, deltaY = headX-locationX, headY-locationY
				local realYaw = math_deg(math_atan2(deltaY, deltaX))
				local _, cameraYaw = client_camera_angles()					
				renderer.circle_outline(x/2, y/2,real_r, real_g, real_b, real_a, length,cameraYaw - realYaw - 110,0.1, 5)				
		     end
		
			
			
			if  ui.get(lby_ref) then
				local lby_r, lby_g, lby_b, lby_a = ui_get(lby_color_reference)				
				local lbyYaw = entity_get_prop(entity_get_local_player(), "m_flLowerBodyYawTarget")
				local _, cameraYaw = client_camera_angles()				
				renderer.circle_outline(x/2, y/2,lby_r, lby_g, lby_b, lby_a, length,cameraYaw - lbyYaw - 110,0.1, 5)
				
			 end
			
			
	return			
end

client.set_event_callback("paint", on_paint)