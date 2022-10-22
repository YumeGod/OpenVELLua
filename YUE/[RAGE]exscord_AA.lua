namerr = "Yue"
user = "我爱Yue"
function lua_log(...)
    client.color_log(234, 237, 37, "[" .. namerr .. "]\0")
    local argIndex = 1
    while select(argIndex, ...) ~= nil do
        client.color_log(126, 215, 135, " ", select(argIndex, ...), "\0")
        argIndex = argIndex + 1
    end
    client.color_log(126, 215, 135, " ")
end

----------------------------------------------------------------------------------
client.color_log(255, 255, 255, "---------------------------------------------------------------------------")
lua_log("You're welcome,", user, ", Fuck you ")
client.color_log(255, 255, 255, "---------------------------------------------------------------------------")
----------------------------------------------------------------------------------
client.log("     Get good Get gamesense")
client.color_log(0, 255, 216, "[gamesense] ♛Yue.CFG♛")
client.color_log(0, 255, 216, "[gamesense] Auto buy lua : 2020/05/25")
client.log("Wrapper Enabling...")



require "bit"

-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_set_event_callback, ui_get, ui_set, ui_new_checkbox, ui_new_combobox, ui_new_slider, ui_reference, ui_set_visible = client.set_event_callback, ui.get, ui.set, ui.new_checkbox, ui.new_combobox, ui.new_slider, ui.reference, ui.set_visible

-- local enable = ui_reference("AA", "Anti-aimbot angles", "Enabled")
-- local pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch")
-- local yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base")
-- local yaw, yaw_slider = ui_reference("AA", "Anti-aimbot angles", "Yaw")
-- local yaw_jitter, yaw_jitter_slider = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")
-- local byaw, byaw_slider = ui_reference("AA", "Anti-aimbot angles", "Body yaw")
-- local freestand = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
-- local lby = ui_reference("AA", "Anti-aimbot angles", "Lower body yaw target")
-- local yaw_limit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit")

-- local enable_custom_aa = ui_new_checkbox("AA", "Anti-aimbot angles", "Enable custom AA")
-- local custom_aa_cond = ui_new_combobox("AA", "Anti-aimbot angles", "Condition", {"Stand", "Move", "Air", "Slow walk"})

-- local stand = {
	-- enable = ui_new_checkbox("AA", "Anti-aimbot angles", "Enabled [stand]"),
	-- pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [stand]", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
	-- yaw_base = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [stand]", {"Local view", "At targets"}),
	-- yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [stand]", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	-- yaw_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_yaw_slider", -180, 180, 0),
	-- yaw_jitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [stand]", {"Off", "Offset", "Center", "Random"}),
	-- yaw_jitter_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_yaw_jitter_slider", -180, 180, 0),
	-- byaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw [stand]", {"Off", "Opposite", "Jitter", "Static"}),
	-- byaw_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_byaw_slider", -180, 180, 0),
	-- byaw_target = ui_new_checkbox("AA", "Anti-aimbot angles", "Freestanding body yaw [stand]"),
	-- lby = ui_new_combobox("AA", "Anti-aimbot angles", "Lower body yaw target [stand]", {"Off", "Sway", "Opposite", "Eye yaw"}),
	-- yaw_limit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [stand]", 0, 60, 60, true, "°"),
-- }

-- local move = {
	-- enable = ui_new_checkbox("AA", "Anti-aimbot angles", "Enabled [move]"),
	-- pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [move]", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
	-- yaw_base = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [move]", {"Local view", "At targets"}),
	-- yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [move]", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	-- yaw_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_yaw_slider", -180, 180, 0),
	-- yaw_jitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [move]", {"Off", "Offset", "Center", "Random"}),
	-- yaw_jitter_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_yaw_jitter_slider", -180, 180, 0),
	-- byaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw [move]", {"Off", "Opposite", "Jitter", "Static"}),
	-- byaw_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_byaw_slider", -180, 180, 0),
	-- byaw_target = ui_new_checkbox("AA", "Anti-aimbot angles", "Freestanding body yaw [move]"),
	-- lby = ui_new_combobox("AA", "Anti-aimbot angles", "Lower body yaw target [move]", {"Off", "Sway", "Opposite", "Eye yaw"}),
	-- yaw_limit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [move]", 0, 60, 60, true, "°"),
-- }

-- local air = {
	-- enable = ui_new_checkbox("AA", "Anti-aimbot angles", "Enabled [air]"),
	-- pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [air]", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
	-- yaw_base = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [air]", {"Local view", "At targets"}),
	-- yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [air]", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	-- yaw_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_yaw_slider", -180, 180, 0),
	-- yaw_jitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [air]", {"Off", "Offset", "Center", "Random"}),
	-- yaw_jitter_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_yaw_jitter_slider", -180, 180, 0),
	-- byaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw [air]", {"Off", "Opposite", "Jitter", "Static"}),
	-- byaw_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_byaw_slider", -180, 180, 0),
	-- byaw_target = ui_new_checkbox("AA", "Anti-aimbot angles", "Freestanding body yaw [air]"),
	-- lby = ui_new_combobox("AA", "Anti-aimbot angles", "Lower body yaw target [air]", {"Off", "Sway", "Opposite", "Eye yaw"}),
	-- yaw_limit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [air]", 0, 60, 60, true, "°"),
-- }

-- local slow_walk = {
	-- enable = ui_new_checkbox("AA", "Anti-aimbot angles", "Enabled [slow walk]"),
	-- pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch [slow walk]", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
	-- yaw_base = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base [slow walk]", {"Local view", "At targets"}),
	-- yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw [slow walk]", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	-- yaw_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_yaw_slider", -180, 180, 0),
	-- yaw_jitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter [slow walk]", {"Off", "Offset", "Center", "Random"}),
	-- yaw_jitter_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_yaw_jitter_slider", -180, 180, 0),
	-- byaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw [slow walk]", {"Off", "Opposite", "Jitter", "Static"}),
	-- byaw_slider = ui_new_slider("AA", "Anti-aimbot angles", "\n stand_byaw_slider", -180, 180, 0),
	-- byaw_target = ui_new_checkbox("AA", "Anti-aimbot angles", "Freestanding body yaw [slow walk]"),
	-- lby = ui_new_combobox("AA", "Anti-aimbot angles", "Lower body yaw target [slow walk]", {"Off", "Sway", "Opposite", "Eye yaw"}),
	-- yaw_limit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit [slow walk]", 0, 60, 60, true, "°"),
-- }

-- local function set_aa_by_condition()
	-- if not ui_get(enable_custom_aa) then
		-- return
	-- end
	
	-- local x, y, z = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
	-- local fl_speed = math.sqrt(x^2 + y^2)
	
	-- local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
	
	-- local slow_mo, slow_mo_key = ui.reference("AA", "Other", "Slow motion")
	
	-- local is_slow_walk = ui.get(slow_mo) and ui.get(slow_mo_key)
	
	-- if flags == 256 then
		-- ui_set(enable, ui.get(air.enable))
		-- ui_set(pitch, ui.get(air.pitch))
		-- ui_set(yaw_base, ui.get(air.yaw_base))
		-- ui_set(yaw, ui.get(air.yaw))
		-- ui.set(yaw_slider, ui.get(air.yaw_slider))
		-- ui.set(yaw_jitter, ui.get(air.yaw_jitter))
		-- ui.set(yaw_jitter_slider, ui.get(air.yaw_jitter_slider))
		-- ui.set(byaw, ui.get(air.byaw))
		-- ui.set(byaw_slider, ui.get(air.byaw_slider))
		-- ui.set(freestand, ui.get(air.byaw_target))
		-- ui.set(lby, ui.get(air.lby))
		-- ui.set(yaw_limit, ui.get(air.yaw_limit))
	-- elseif fl_speed < 10 then 
		-- ui_set(enable, ui.get(stand.enable))
		-- ui_set(pitch, ui.get(stand.pitch))
		-- ui_set(yaw_base, ui.get(stand.yaw_base))
		-- ui_set(yaw, ui.get(stand.yaw))
		-- ui.set(yaw_slider, ui.get(stand.yaw_slider))
		-- ui.set(yaw_jitter, ui.get(stand.yaw_jitter))
		-- ui.set(yaw_jitter_slider, ui.get(stand.yaw_jitter_slider))
		-- ui.set(byaw, ui.get(stand.byaw))
		-- ui.set(byaw_slider, ui.get(stand.byaw_slider))
		-- ui.set(freestand, ui.get(stand.byaw_target))
		-- ui.set(lby, ui.get(stand.lby))
		-- ui.set(yaw_limit, ui.get(stand.yaw_limit))
	-- elseif is_slow_walk then
		-- ui_set(enable, ui.get(slow_walk.enable))
		-- ui_set(pitch, ui.get(slow_walk.pitch))
		-- ui_set(yaw_base, ui.get(slow_walk.yaw_base))
		-- ui_set(yaw, ui.get(slow_walk.yaw))
		-- ui.set(yaw_slider, ui.get(slow_walk.yaw_slider))
		-- ui.set(yaw_jitter, ui.get(slow_walk.yaw_jitter))
		-- ui.set(yaw_jitter_slider, ui.get(slow_walk.yaw_jitter_slider))
		-- ui.set(byaw, ui.get(slow_walk.byaw))
		-- ui.set(byaw_slider, ui.get(slow_walk.byaw_slider))
		-- ui.set(freestand, ui.get(slow_walk.byaw_target))
		-- ui.set(lby, ui.get(slow_walk.lby))
		-- ui.set(yaw_limit, ui.get(slow_walk.yaw_limit))
	-- else
		-- ui_set(enable, ui.get(move.enable))
		-- ui_set(pitch, ui.get(move.pitch))
		-- ui_set(yaw_base, ui.get(move.yaw_base))
		-- ui_set(yaw, ui.get(move.yaw))
		-- ui.set(yaw_slider, ui.get(move.yaw_slider))
		-- ui.set(yaw_jitter, ui.get(move.yaw_jitter))
		-- ui.set(yaw_jitter_slider, ui.get(move.yaw_jitter_slider))
		-- ui.set(byaw, ui.get(move.byaw))
		-- ui.set(byaw_slider, ui.get(move.byaw_slider))
		-- ui.set(freestand, ui.get(move.byaw_target))
		-- ui.set(lby, ui.get(move.lby))
		-- ui.set(yaw_limit, ui.get(move.yaw_limit))
	-- end
-- end

local function contains(table, val)
	for i=1, #table do
		if table[i] == val then
			return true
		end
	end

	return false
end

-- client_set_event_callback("paint", function()
	-- local should_draw_stand = ui_get(enable_custom_aa) and ui_get(custom_aa_cond) == "Stand"
	-- local should_draw_move = ui_get(enable_custom_aa) and ui_get(custom_aa_cond) == "Move"
	-- local should_draw_air = ui_get(enable_custom_aa) and ui_get(custom_aa_cond) == "Air"
	-- local should_draw_slow_walk = ui_get(enable_custom_aa) and ui_get(custom_aa_cond) == "Slow walk"

	-- ui_set_visible(enable, not ui_get(enable_custom_aa))
	-- ui_set_visible(pitch, not ui_get(enable_custom_aa))
	-- ui_set_visible(yaw_base, not ui_get(enable_custom_aa))
	-- ui_set_visible(yaw, not ui_get(enable_custom_aa))
	-- ui_set_visible(yaw_slider, not ui_get(enable_custom_aa))
	-- ui_set_visible(yaw_jitter, not ui_get(enable_custom_aa))
	-- ui_set_visible(yaw_jitter_slider, not ui_get(enable_custom_aa))
	-- ui_set_visible(byaw, not ui_get(enable_custom_aa))
	-- ui_set_visible(byaw_slider, not ui_get(enable_custom_aa))
	-- ui_set_visible(freestand, not ui_get(enable_custom_aa))
	-- ui_set_visible(lby, not ui_get(enable_custom_aa))
	-- ui_set_visible(yaw_limit, not ui_get(enable_custom_aa))

	-- ui_set_visible(stand.enable, should_draw_stand)
	-- ui_set_visible(stand.pitch, should_draw_stand)
	-- ui_set_visible(stand.yaw_base, should_draw_stand)
	-- ui_set_visible(stand.yaw, should_draw_stand)
	-- ui_set_visible(stand.yaw_slider, should_draw_stand)
	-- ui_set_visible(stand.yaw_jitter, should_draw_stand)
	-- ui_set_visible(stand.yaw_jitter_slider, should_draw_stand)
	-- ui_set_visible(stand.byaw, should_draw_stand)
	-- ui_set_visible(stand.byaw_slider, should_draw_stand)
	-- ui_set_visible(stand.byaw_target, should_draw_stand)
	-- ui_set_visible(stand.lby, should_draw_stand)
	-- ui_set_visible(stand.yaw_limit, should_draw_stand)

	-- ui_set_visible(move.enable, should_draw_move)
	-- ui_set_visible(move.pitch, should_draw_move)
	-- ui_set_visible(move.yaw_base, should_draw_move)
	-- ui_set_visible(move.yaw, should_draw_move)
	-- ui_set_visible(move.yaw_slider, should_draw_move)
	-- ui_set_visible(move.yaw_jitter, should_draw_move)
	-- ui_set_visible(move.yaw_jitter_slider, should_draw_move)
	-- ui_set_visible(move.byaw, should_draw_move)
	-- ui_set_visible(move.byaw_slider, should_draw_move)
	-- ui_set_visible(move.byaw_target, should_draw_move)
	-- ui_set_visible(move.lby, should_draw_move)
	-- ui_set_visible(move.yaw_limit, should_draw_move)

	-- ui_set_visible(air.enable, should_draw_air)
	-- ui_set_visible(air.pitch, should_draw_air)
	-- ui_set_visible(air.yaw_base, should_draw_air)
	-- ui_set_visible(air.yaw, should_draw_air)
	-- ui_set_visible(air.yaw_slider, should_draw_air)
	-- ui_set_visible(air.yaw_jitter, should_draw_air)
	-- ui_set_visible(air.yaw_jitter_slider, should_draw_air)
	-- ui_set_visible(air.byaw, should_draw_air)
	-- ui_set_visible(air.byaw_slider, should_draw_air)
	-- ui_set_visible(air.byaw_target, should_draw_air)
	-- ui_set_visible(air.lby, should_draw_air)
	-- ui_set_visible(air.yaw_limit, should_draw_air)

	-- ui_set_visible(slow_walk.enable, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.pitch, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.yaw_base, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.yaw, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.yaw_slider, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.yaw_jitter, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.yaw_jitter_slider, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.byaw, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.byaw_slider, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.byaw_target, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.lby, should_draw_slow_walk)
	-- ui_set_visible(slow_walk.yaw_limit, should_draw_slow_walk)
	
	-- set_aa_by_condition()
-- end)
client.color_log(234, 237, 37, "---------------------------------------------------------------------------")
client.color_log(255, 255, 255, "                  Thanks for downloading exscord AA!                      ")
client.color_log(183, 255, 11, "               Best skeet configs -> shoppy.gg/@Mishkat")
client.color_log(255, 0, 127, "    Join discord for newest lua updates: https://discord.gg/XxBqyXz ")
client.color_log(234, 237, 37, "---------------------------------------------------------------------------")


local enable_lua = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable anti-aims")
local at_target_in_air = ui.new_checkbox("AA", "Anti-aimbot angles", "Alternative yaw base in air")
local legit_aa_on_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Legit anti-aim (on key)")
local change_aa_on_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Dodge anti-aim mode (on key)")
local enable_manual = ui.new_checkbox("AA", "Anti-aimbot angles", "Manual anti-aim")

local vars = {
	manual_clr = ui.new_color_picker("AA", "Anti-aimbot angles", " \n Manual clr", 255, 255, 255, 255),
	pulsate = ui.new_checkbox("AA", "Anti-Aimbot angles", "Pulsate"),
	key_left = ui.new_hotkey("AA", "Anti-aimbot angles", "Left", false),
	key_right = ui.new_hotkey("AA", "Anti-aimbot angles", "Right", false),
	key_back = ui.new_hotkey("AA", "Anti-aimbot angles", "Back", false),
}

local indicator = {
	enable = ui.new_checkbox("AA", "Anti-Aimbot angles", "Show indicators"),
}

local screen_size_x, screen_size_y = 0

local ui_get = ui.get

local fs, fs_key, fs_cond = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local yaw, yaw_add = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local jitter, jitter2, jitter3 = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local body, body_add = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local lby = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local dt, dt2, dt3 = ui.reference("Rage", "Other", "Double tap")
local on_shot, on_shot2 = ui.reference("AA", "Other", "On shot anti-aim")
local fd = ui.reference("RAGE", "Other", "Duck peek assist")
local freestand_byaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local yaw_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")

local is_left, is_right, is_back = false
local left_pressed, right_pressed, back_pressed = false
local left_clicked, right_clicked, back_clicked = false
local left_state, right_state, back_state = 0
	
local function get_direction()
	if not entity.is_alive(entity.get_local_player()) then return end
namerr = "Yue"
user = "我爱Yue"
function lua_log(...)
    client.color_log(234, 237, 37, "[" .. namerr .. "]\0")
    local argIndex = 1
    while select(argIndex, ...) ~= nil do
        client.color_log(126, 215, 135, " ", select(argIndex, ...), "\0")
        argIndex = argIndex + 1
    end
    client.color_log(126, 215, 135, " ")
end

----------------------------------------------------------------------------------
client.color_log(255, 255, 255, "---------------------------------------------------------------------------")
lua_log("You're welcome,", user, ", Fuck you ")
client.color_log(255, 255, 255, "---------------------------------------------------------------------------")
----------------------------------------------------------------------------------
client.log("     Get good Get gamesense")
client.color_log(0, 255, 216, "[gamesense] ♛Yue.CFG♛")
client.color_log(0, 255, 216, "[gamesense] Auto buy lua : 2020/05/25")
client.log("Wrapper Enabling...")


	if ui.get(enable_manual) then
		if ui_get(vars.key_left) then
			left_pressed = true
			left_clicked = false
		elseif not ui_get(vars.key_left) and left_pressed then
			left_pressed =  false
			left_clicked = true
		else
			left_pressed =  false
			left_clicked =  false
		end
		
		if ui_get(vars.key_right) then
			right_pressed = true
			right_clicked = false
		elseif not ui_get(vars.key_right) and right_pressed then
			right_pressed =  false
			right_clicked = true
		else
			right_pressed  =  false
			right_clicked =  false
		end
		
		if ui_get(vars.key_back) then
			back_pressed = true
			back_clicked = false
		elseif not ui_get(vars.key_back) and back_pressed then
			back_pressed =  false
			back_clicked = true
		else
			back_pressed =  false
			back_clicked =  false
		end
		if back_clicked then
			if back_state == 3 then
				back_state = 0
				is_right = false
				is_left = false
				is_back = true
			else
				back_state = 3
				left_state = 0
				right_state = 0
				is_back = true
				is_right, is_left = false
			end
		elseif left_clicked then
			if left_state == 1 then
				left_state = 0
				is_left = false
				is_back = true
			else
				left_state = 1
				right_state = 0
				back_state = 0
				is_left = true
				is_right, is_back = false
			end
		elseif right_clicked then
			if right_state == 2 then
				right_state = 0
				is_right = false
				is_back = true
			else
				right_state = 2
				left_state = 0
				back_state = 0
				is_right = true
				is_left, is_back = false
			end
		end
	else
		is_left = false
		is_right = false
		is_back = true
		back_state = 3
		right_state = 0
		left_state = 0
	end
end

local function normalize_yaw(angle)
	angle = (angle % 360 + 360) % 360
	return angle > 180 and angle - 360 or angle
end

local value3 = 255
local state3 = false

client.set_event_callback("run_command", function()
	local increment = (1 * globals.frametime()) * 255
	
	if (value3 ~= 0 and not state3) then
		value3 =  clamp(value3 - increment, 0, 255)
	end

	if (value3 ~= 255 and state3) then
		value3 = clamp(value3 + increment, 0, 255)
	end

	if (value3 == 0) then
		state3 = true
	end

	if (value3 == 255) then
		state3 = false
	end
end)
local side = 0
local function draw_direction(c)
	if not entity.is_alive(entity.get_local_player()) then return end

	if not ui.get(enable_manual) then
		return
	end

	local arrow_left, arrow_right, arrow_back
	local dist = 30
	
	local tempr1, tempg1, tempb1, tempa = ui.get(vars.manual_clr)
	local r = tempr1
	local g = tempg1
	local b = tempb1
	local a = ui.get(vars.pulsate) and value3 or tempa
	local r1, g1, b1, a1 = 50, 50, 50, 100
	
	arrow_left = "⯇"
	arrow_right = "⯈"
	arrow_back = "⯆"

	local scrsize_x, scrsize_y = client.screen_size()
	local center_x, center_y = scrsize_x / 2, scrsize_y / 2
	
	local local_player = entity.get_local_player()
	local body_yaw = -1
	local percentage = -1
	if local_player ~= nil then
		body_yaw = math.max(-60, math.min(60, math.floor((entity.get_prop(local_player, "m_flPoseParameter", 11) or 0)*120-60+0.5)))

		percentage = (math.max(-60, math.min(60, body_yaw*1.06))+60) / 120

		-- display reversed for backwards AAs
		local _, camera_yaw = client.camera_angles()
		local _, rot_yaw = entity.get_prop(local_player, "m_angAbsRotation")

		if camera_yaw ~= nil and rot_yaw ~= nil and 60 < math.abs(normalize_yaw(camera_yaw-(rot_yaw+body_yaw))) then
			percentage = 1-percentage
		end
	end
	
	side = body_yaw > 0 and -1 or 1
	
	--local side = ui.get(vars.enable_side_flip) and ui.get(vars.side_flip_key) and -1 or 1 or body_yaw > 0 and 1 or -1
	
	if side ~= 0 then
		if side == -1 then
			renderer.triangle(center_x + 41, center_y + 22, center_x + 38, center_y + 39, center_x  + 26, center_y + 39, r, g, b, a)
			renderer.triangle(center_x - 41, center_y + 22, center_x - 38, center_y + 39, center_x  - 26, center_y + 39, r1, g1, b1, a1)
		else
			renderer.triangle(center_x + 41, center_y + 22, center_x + 38, center_y + 39, center_x  + 26, center_y + 39, r1, g1, b1, a1)
			renderer.triangle(center_x - 41, center_y + 22, center_x - 38, center_y + 39, center_x  - 26, center_y + 39, r, g, b, a)
		end
	end
	
	if is_left then
		client.draw_text(c, center_x - dist - 4, center_y, r, g, b, a, "cb+", 0, arrow_left)
		client.draw_text(c, center_x + dist + 6, center_y, r1, g1, b1, a1, "cb+", 0, arrow_right)
		client.draw_text(c, center_x, center_y + dist + 5, r1, g1, b1, a1, "cb+", 0, arrow_back)
	elseif is_right then
		client.draw_text(c, center_x + dist + 6, center_y, r, g, b, a, "cb+", 0, arrow_right)
		client.draw_text(c, center_x - dist - 4, center_y, r1, g1, b1, a1, "cb+", 0, arrow_left)
		client.draw_text(c, center_x, center_y + dist + 5, r1, g1, b1, a1, "cb+", 0, arrow_back)
	elseif is_back and back_state == 3 then
		client.draw_text(c, center_x, center_y + dist + 5, r, g, b, a, "cb+", 0, arrow_back)
		client.draw_text(c, center_x - dist - 4, center_y, r1, g1, b1, a1, "cb+", 0, arrow_left)
		client.draw_text(c, center_x + dist + 6, center_y, r1, g1, b1, a1, "cb+", 0, arrow_right)
	else
		client.draw_text(c, center_x, center_y + dist + 5, r1, g1, b1, a1, "cb+", 0, arrow_back)
		client.draw_text(c, center_x - dist - 4, center_y, r1, g1, b1, a1, "cb+", 0, arrow_left)
		client.draw_text(c, center_x + dist + 6, center_y, r1, g1, b1, a1, "cb+", 0, arrow_right)
	end
end

local do_it_once = false
local do_it_once2 = false
local do_it_once3 = false

local function set_direction()
	if not entity.is_alive(entity.get_local_player()) then return end

	local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
	if ui.get(at_target_in_air) and flags == 256 then
		ui.set(yaw_base, "At targets")
	else
		ui.set(yaw_base, "Local view")
	end

	if ui.get(legit_aa_on_key) then
		ui.set(pitch, "Off")
		ui.set(yaw_add, 180)
		ui.set(yaw_base, "At targets")
		do_it_once2 = false
	else
	
		if not do_it_once2 then
			ui.set(pitch, "Minimal")
			ui.set(yaw_base, "Local view")
			ui.set(yaw_add, 0)
			do_it_once2 = true
		end
	
		if ui.get(change_aa_on_key) then
			ui.set(yaw_add, 15)
			ui.set(body, "Jitter")
			ui.set(body_add, 95)
			ui.set(lby, "Eye yaw")
			ui.set(yaw_limit, 59)
			do_it_once3 = false
		else	
			if not do_it_once3 then
				ui.set(yaw_add, 0)
				ui.set(yaw_limit, 60)
				ui.set(body, "Static")
				ui.set(body_add, 180)
				do_it_once3 = true
			end
		
			if is_left then
			-- if ui.get(enable_custom_aa) then
				-- ui.set(stand.yaw_slider, -90)
				-- ui.set(move.yaw_slider, -90)
				-- ui.set(air.yaw_slider, -90)
				-- ui.set(slow_walk.yaw_slider, -90)
			-- else
				ui.set(yaw_add, -90)
			--end
				do_it_once = false
			elseif is_right then
				-- if ui.get(enable_custom_aa) then
					-- ui.set(stand.yaw_slider, 90)
					-- ui.set(move.yaw_slider, 90)
					-- ui.set(air.yaw_slider, 90)
					-- ui.set(slow_walk.yaw_slider, 90)
				-- else
					ui.set(yaw_add, 90)
				--end
				do_it_once = false
			elseif is_back then
				if not do_it_once then
					-- if ui.get(enable_custom_aa) then
						-- ui.set(stand.yaw_slider, 0)
						-- ui.set(move.yaw_slider, 0)
						-- ui.set(air.yaw_slider, 0)
						-- ui.set(slow_walk.yaw_slider, 0)
					-- else
						ui.set(yaw_add, 0)
					--end
					do_it_once = true
				end
			end
		end
	end
end

function clamp(v, min, max)
	return math.max(math.min(v, max), min)
end

local set_once = false

local menu_clr = ui.reference("MISC", "Settings", "Menu color")

local min_dmg = ui.reference("RAGE", "Aimbot", "Minimum damage")
local sf =  ui.reference("RAGE", "Aimbot", "Force safe point")
local baim =  ui.reference("RAGE", "Other", "Force body aim")

local function draw_crosshair_indicators()
	local add_value = 0
	if not ui.get(indicator.enable) then
		return
	end
	local aa_name = ui.get(change_aa_on_key) and "DODGE" or ui.get(legit_aa_on_key) and "LEGIT AA" or "IDEAL YAW"
	local crosshair_size = cvar.cl_crosshairsize:get_int()
	
	local position_value = ui.get(enable_manual) and 60 or crosshair_size + 10
	
	--local r, g, b, a = ui.get(indicator.color)
	
	local ri, gi, bi, ai = 50, 50, 50, 255
	renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		255, 
		155, 
		47, 
		255,  
		"cb", 0, aa_name) 
	add_value = add_value + 10
	
	if side ~= 0 then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		255, 
		255, 
		255, 
		255,  
		"cb", 0, ui.get(fs) and ui.get(fs_key) and "FREESTANDING" or side == 1 and "LEFT" or "RIGHT") 
		add_value = add_value + 10
	end
	
	renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		ui.get(dt) and ui.get(dt2) and 1 or 213, 
		ui.get(dt) and ui.get(dt2) and 255 or 11, 
		ui.get(dt) and ui.get(dt2) and 1 or 11, 
		ui.get(dt) and ui.get(dt2) and 255 or value3,  
		"cb", 0, "DT")
	add_value = add_value + 10
	
	if ui.get(on_shot) and ui.get(on_shot2) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
			1, 
			255, 
			1, 
			255,  
			"cb", 0, "ON-SHOT")
		add_value = add_value + 10
	end
	if ui.get(fd) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
			255, 
			255, 
			255, 
			value3,  
			"cb", 0, "DUCK")
		add_value = add_value + 10
	end
	if ui.get(sf) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
			1, 
			255, 
			1, 
			255,  
			"cb", 0, "SAFE")
		add_value = add_value + 10
	end
	if ui.get(baim) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
			1,  
			255,  
			1,  
			255,  
			"cb", 0, "BODY")
		add_value = add_value + 10
	end
end

client.set_event_callback("paint", function(ctx)
	if not ui.get(enable_lua) then
		return
	end
	if not entity.is_alive(entity.get_local_player()) then return end

	local old_x, old_y = client.screen_size()	
	
	if screen_size_x ~= old_x or screen_size_y ~= old_y then
		screen_size_x = old_x
		screen_size_y = old_y
	end
	
	ui.set_visible(vars.key_left, ui.get(enable_manual))
	ui.set_visible(vars.key_right, ui.get(enable_manual))
	ui.set_visible(vars.key_back, ui.get(enable_manual))
	ui.set_visible(vars.manual_clr, ui.get(enable_manual))
	
	ui.set(vars.key_left, "On hotkey")
	ui.set(vars.key_right, "On hotkey")
	ui.set(vars.key_back, "On hotkey")
	
	draw_crosshair_indicators()
	get_direction()
	set_direction()
	draw_direction(ctx)
end)

local check = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-bruteforce")
local combo = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-bruteforce mode", { "Opposite", "Random", "Step" })
local ab_range = ui.new_slider("AA", "Anti-aimbot angles", "Anti-bruteforce range", 1, 100, 32)

local function GetClosestPoint(A, B, P)
	local a_to_p = { P[1] - A[1], P[2] - A[2] }
	local a_to_b = { B[1] - A[1], B[2] - A[2] }

	local atb2 = a_to_b[1]^2 + a_to_b[2]^2

	local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
	local t = atp_dot_atb / atb2
	
	return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

local should_swap = false
local it = 0
local angles = { 60, 20, -60 }
client.set_event_callback("bullet_impact", function(c)
	if not ui.get(enable_lua) or ui.get(change_aa_on_key) then
		return
	end
	if ui.get(check) and entity.is_alive(entity.get_local_player()) then
		local ent = client.userid_to_entindex(c.userid)
		if not entity.is_dormant(ent) and entity.is_enemy(ent) then
			local ent_shoot = { entity.get_prop(ent, "m_vecOrigin") }
			ent_shoot[3] = ent_shoot[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
			local player_head = { entity.hitbox_position(entity.get_local_player(), 0) }
			local closest = GetClosestPoint(ent_shoot, { c.x, c.y, c.z }, player_head)
			local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
			local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
		
			if math.abs(delta_2d) < ui.get(ab_range) then
				it = it + 1
				should_swap = true
			end
		end
	end
end)

client.set_event_callback("run_command", function(c)
	if not ui.get(enable_lua) or ui.get(change_aa_on_key) then
		return
	end
	-- if ui.get(enable_custom_aa) then
		-- if ui.get(check) and should_swap then
			-- local _combo = ui.get(combo)
			-- if _combo == "Opposite" then
				-- ui.set(stand.byaw_slider,-ui.get(stand.byaw_slider))
				-- ui.set(move.byaw_slider, -ui.get(stand.byaw_slider))
				-- ui.set(air.byaw_slider, -ui.get(stand.byaw_slider))
				-- ui.set(slow_walk.byaw_slider, -ui.get(stand.byaw_slider))
			-- elseif _combo == "Random" then
				-- ui.set(stand.byaw_slider,math.random(-60, 60))
				-- ui.set(move.byaw_slider, math.random(-60, 60))
				-- ui.set(air.byaw_slider, math.random(-60, 60))
				-- ui.set(slow_walk.byaw_slider, math.random(-60, 60))
			-- elseif _combo == "Step" then
				-- ui.set(stand.byaw_slider,angles[(it%3)+1])
				-- ui.set(move.byaw_slider, angles[(it%3)+1])
				-- ui.set(air.byaw_slider, angles[(it%3)+1])
				-- ui.set(slow_walk.byaw_slider, angles[(it%3)+1])
			-- end
			-- should_swap = false
		-- end
	-- else
		if ui.get(check) and should_swap then
			local _combo = ui.get(combo)
			if _combo == "Opposite" then
				ui.set(body_add, -ui.get(body_add))
			elseif _combo == "Random" then
				ui.set(body_add, math.random(-60, 60))
			elseif _combo == "Step" then
				ui.set(body_add, angles[(it%3)+1])
			end
			should_swap = false
		end
		--end
end)

---region menu
-- Create my menu elements
local enable = ui.new_checkbox("AA", "Anti-aimbot angles", "Reversed freestanding")
local mode = ui.new_combobox("AA", "Anti-aimbot angles", "Mode", { "Hide real", "Hide fake" })
local smart = ui.new_checkbox("AA", "Anti-aimbot angles", "Smart mode")

-- And reference the ones I'll be using
local ref_body_freestanding = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local ref_body_yaw, ref_body_yaw_offset = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local ref_fake_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
---endregion

---region locals
-- Create the table where all my info will be stored
local data = {
	side = 1,
	last_side = 0,

	last_hit = 0,
	hit_side = 0
}
---endёregion

---region functions
local on_setup_command = function(cmd)
	if not ui.get(enable_lua) or ui.get(change_aa_on_key) then
		return
	end

	-- Get local player
	local me = entity.get_local_player()

	-- If our local player is invalid or if we're dead, return
	if not me or entity.get_prop(me, "m_lifeState") ~= 0 then
		return
	end
	
	 -- Disable the cheat's built-in freestanding
	-- if ui.get(enable_custom_aa) then
		-- ui.set(stand.byaw_target, false)
		-- ui.set(move.byaw_target, false)
		-- ui.set(air.byaw_target, false)
		-- ui.set(slow_walk.byaw_target, false)
	-- else
		ui.set(ref_body_freestanding, false)
	--end
	
	-- Get the server's current time
	local now = globals.curtime()

	-- Check if our smart mode behaviour is done
	if data.hit_side ~= 0 and now - data.last_hit > 5 then
		-- If so, set the last side to '0' so the anti-aim updates
		data.last_side = 0

		-- And reset the smart mode info
		data.last_hit = 0
		data.hit_side = 0
	end

	-- Get what mode our freestanding is using
	local _mode = ui.get(mode)

	-- Get some properties
	local x, y, z = client.eye_position()
	local _, yaw = client.camera_angles()

	-- Create a table where the trace data will be stored
	local trace_data = {left = 0, right = 0}

	for i = yaw - 90, yaw + 90, 30 do
		-- I don't know an alternative for continue so..
		-- Don't do any calculations if the current angle is equal to our yaw
		-- This means that this is the center point and thus it doesn't contribute to the calculations
		if i ~= yaw then
			-- Convert our yaw to radians in order to do further calculations
			local rad = math.rad(i)

			-- Calculate our destination point
			local px, py, pz = x + 256 * math.cos(rad), y + 256 * math.sin(rad), z

			-- Trace a line from our eye position to the previously calculated point
			local fraction = client.trace_line(me, x, y, z, px, py, pz)
			local side = i < yaw and "left" or "right"

			-- Add the trace's fraction to the trace table
			trace_data[side] = trace_data[side] + fraction
		end
	end

	-- Get which side has the lowest fraction amount, which means that it is closer to us.
	data.side = trace_data.left < trace_data.right and 1 or 2

	-- If our side didn't change from the last tick then there's no need to update our anti-aim
	if data.side == data.last_side then
		return
	end

	-- If it did change, then update our cached side to do further checks
	data.last_side = data.side

	-- Check if we should override our side due to the smart mode
	if data.hit_side ~= 0 then
		data.side = data.hit_side == 1 and 2 or 1
	end

	-- Get the fake angle's maximum length and calculate what our next body offset should be
	local limit = ui.get(ref_fake_limit)
	-- if ui.get(custom_aa_cond) == "Stand" then
		-- limit = ui.get(stand.yaw_limit)
	-- elseif ui.get(custom_aa_cond) == "Move" then
		-- limit = ui.get(move.yaw_limit)
	-- elseif ui.get(custom_aa_cond) == "Air" then
		-- limit = ui.get(air.yaw_limit)
	-- elseif ui.get(custom_aa_cond) == "Slow walk" then
		-- limit = ui.get(slow_walk.yaw_limit)
	-- end
	local lby = _mode == "Hide real" and (data.side == 1 and limit or -limit) or (data.side == 1 and -limit or limit)

	-- Update our body yaw settings
	
	-- if ui.get(enable_custom_aa) then
		-- ui.set(stand.byaw, "Static")
		-- ui.set(stand.byaw_slider, lby)
	
		-- ui.set(move.byaw, "Static")
		-- ui.set(move.byaw_slider, lby)
		
		-- ui.set(air.byaw, "Static")
		-- ui.set(air.byaw_slider, lby)
		
		-- ui.set(slow_walk.byaw, "Static")
		-- ui.set(slow_walk.byaw_slider, lby)
	-- else
		ui.set(ref_body_yaw, "Static")
		ui.set(ref_body_yaw_offset, lby)
	--end
end

local on_player_hurt = function(e)
	if not ui.get(enable_lua) or ui.get(change_aa_on_key) then
		return
	end

	-- Check if smart mode is disabled
	if not ui.get(smart) then
		return
	end

	-- Get the event's entities
	local me = entity.get_local_player()
	local userid, attacker = client.userid_to_entindex(e.userid), client.userid_to_entindex(e.attacker)

	-- Check if we're the one who got hurt and not the one who hurt us
	if me == userid and me ~= attacker then
		-- If so, set the last side to '0' so the anti-aim updates
		data.last_side = 0

		-- Update our smart mode info
		data.last_hit = globals.curtime()
		data.hit_side = data.side
	end
end

local handle_menu_visibility = function(self)
	-- Get if the script is enabled and determine if we should set or unset the callbacks
	local enabled = ui.get(self)
	local callback = enabled and client.set_event_callback or client.unset_event_callback

	-- Update the other elements' visibility
	ui.set_visible(mode, enabled)
	ui.set_visible(smart, enabled)

-- Register/Unregister our callbacks
	callback("setup_command", on_setup_command)
	callback("player_hurt", on_player_hurt)
end

-- Execute this whenever the script is first enabled
handle_menu_visibility(enable)
---endregion

---region callbacks
-- Register the UI callbacks
ui.set_callback(enable, handle_menu_visibility)
ui.set_callback(mode, function(self)
	-- Set the last side to '0' so the anti-aim updates
	data.last_side = 0
end)
---endregion

client.set_event_callback("paint_menu", function()
	ui.set_visible(enable_manual, ui.get(enable_lua))
	ui.set_visible(at_target_in_air, ui.get(enable_lua))
	ui.set_visible(legit_aa_on_key, ui.get(enable_lua))
	ui.set_visible(change_aa_on_key, ui.get(enable_lua))
	ui.set_visible(check, ui.get(enable_lua))
	ui.set_visible(combo, ui.get(enable_lua) and ui.get(check))
	ui.set_visible(ab_range, ui.get(enable_lua)and ui.get(check))
	ui.set_visible(enable, ui.get(enable_lua))
	ui.set_visible(mode, ui.get(enable_lua) and ui.get(enable))
	ui.set_visible(smart, ui.get(enable_lua)and ui.get(enable))
	ui.set_visible(vars.manual_clr, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(vars.pulsate, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(vars.key_left, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(vars.key_right, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(vars.key_back, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(indicator.enable, ui.get(enable_lua))
end)

client.set_event_callback("paint", function()
	ui.set_visible(enable_manual, ui.get(enable_lua))
	ui.set_visible(at_target_in_air, ui.get(enable_lua))
	ui.set_visible(legit_aa_on_key, ui.get(enable_lua))
	ui.set_visible(change_aa_on_key, ui.get(enable_lua))
	ui.set_visible(check, ui.get(enable_lua))
	ui.set_visible(combo, ui.get(enable_lua) and ui.get(check))
	ui.set_visible(ab_range, ui.get(enable_lua)and ui.get(check))
	ui.set_visible(enable, ui.get(enable_lua))
	ui.set_visible(mode, ui.get(enable_lua) and ui.get(enable))
	ui.set_visible(smart, ui.get(enable_lua)and ui.get(enable))
	ui.set_visible(vars.manual_clr, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(vars.pulsate, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(vars.key_left, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(vars.key_right, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(vars.key_back, ui.get(enable_lua) and ui.get(enable_manual))
	ui.set_visible(indicator.enable, ui.get(enable_lua))
end)