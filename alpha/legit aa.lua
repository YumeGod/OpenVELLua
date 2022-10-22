local bodyyaw, bodyyaw_val = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local low_body = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local fake_yaw = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local slow_enabled, slowwalk_key = ui.reference("AA", "Other", "Slow motion")

local enabled_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "Enabled Legit Anti-Aim")
local while_condition = ui.new_combobox("AA", "Anti-aimbot angles", "While Condition","While Weapons","While Status")
local weapons_acitve_visible = ui.new_combobox("AA", "Anti-aimbot angles", "Weapons Selection","Auto","AWP", "Scout", "Pistol", "Rifle", "SMG", "Heavy", "R8 Revolver", "Eagle")
local status_acitve_visible = ui.new_combobox("AA", "Anti-aimbot angles", "Status Selection","Standing","Moving", "Crouching", "Slow Motion", "Shooting")
local invert_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "Invert AntiAim")

local indicator_status = ui.new_combobox("AA", "Anti-aimbot angles", "Indicator Types","Circle","Arrows")
local arrows_status = ui.new_combobox("AA", "Anti-aimbot angles", "Arrows Types", "Default", "Triangle", "Circle Arrows", "Fish Spear", "Pair Arrows", "Pair Arrows 2", "Barroom", "Classic", "OneTap V2", "TranSparent", "Round", "Dick", "Square", "Stars", "Caresses", "Carabiner", "Special", "Crooked Arrow", "Circle", "Ribbon 1", "Ribbon 2", "Ribbon 3", "Ribbon 4", "Shadows", "Double Arrows", "Misc", "Mathematical Arrow", "Cross Arrowhead", "Triangles Arrows", "Triangles Arrows 2")
local arrow_distance = ui.new_slider("AA", "Anti-aimbot angles", "Arrow distance", 0, 100, 10 ,true, "%")
local real_arrows_label = ui.new_label("AA", "Anti-aimbot angles", "Real Arrows Color")
local real_arrows_p = ui.new_color_picker("AA", "Anti-aimbot angles", "Real Color_S", 255, 255, 255, 255)
local fake_arrows_label = ui.new_label("AA", "Anti-aimbot angles", "Fake Arrows Color")
local fake_arrows_p = ui.new_color_picker("AA", "Anti-aimbot angles", "Fake Color_S", 0, 255, 255, 255)
local circle_color_label = ui.new_label("AA", "Anti-aimbot angles", "Circle Color")
local circle_color_p = ui.new_color_picker("AA", "Anti-aimbot angles", "Circle Color_S", 0, 115, 255, 255)
local fakelag_resert = ui.new_checkbox("AA", "Anti-aimbot angles", "Fakelag Cycle Resert")

local lby_status_ref = ui.new_combobox("AA", "Anti-aimbot angles", "Lua-Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break")
local lby_break_speed_ref = ui.new_slider("AA", "Anti-aimbot angles", "Lua-Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1)

ui.set_visible(lby_break_speed_ref,false)
ui.set_visible(lby_status_ref,false)
ui.set_visible(fakelag_resert,false)
ui.set(invert_hotkey,"Toggle")
require("bit")

local shot_circle, rv_circle = 0, 0
local fix_out, fix_in, time_fix = -0.42, 0, 0


local player_active_weapons = {
    ["AWP"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[AWP]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[AWP]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[AWP]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[AWP]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[AWP]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[AWP]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },

    ["Auto"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Auto]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Auto]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Auto]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Auto]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Auto]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Auto]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },


    ["Scout"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Scout]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Scout]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Scout]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Scout]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Scout]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Scout]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },


    ["Rifle"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Rifle]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Rifle]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Rifle]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Rifle]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Rifle]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Rifle]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },


    ["SMG"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[SMG]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[SMG]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[SMG]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[SMG]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[SMG]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[SMG]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },


    ["Heavy"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Heavy]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Heavy]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Heavy]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Heavy]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Heavy]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Heavy]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },


    ["Pistol"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Pistol]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Pistol]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Pistol]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Pistol]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Pistol]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Pistol]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },


    ["R8 Revolver"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[R8 Revolver]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[R8 Revolver]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[R8 Revolver]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[R8 Revolver]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[R8 Revolver]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[R8 Revolver]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },


    ["Eagle"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Eagle]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Eagle]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Eagle]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Eagle]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Eagle]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Eagle]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },
}

local player_status_cond = {
    ["Standing"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Standing]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Standing]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Standing]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Standing]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Standing]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Standing]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },

    ["Moving"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Moving]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Moving]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Moving]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Moving]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Moving]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Moving]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },

    ["Crouching"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Crouching]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Crouching]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Crouching]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Crouching]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Crouching]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Crouching]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },


    ["Slow Motion"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Slow Motion]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Slow Motion]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Slow Motion]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Slow Motion]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Slow Motion]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Slow Motion]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },

    ["Shooting"] = {
        ["body_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Shooting]Body Yaw","Static","Jitter","Opposite"),
        ["bodyyaw"] = ui.new_slider("AA", "Anti-aimbot angles", "[Shooting]Body Yaw Slider", -180, 180, 90, true,"°", 1),
        ["lby_status"] = ui.new_combobox("AA", "Anti-aimbot angles", "[Shooting]Lower Body Yaw Targets","Off","Sway","Eye yaw","Opposite","Lua-Half Sway","Lua-Full Sway","Lua-Break"),
        ["lby_break_speed"] = ui.new_slider("AA", "Anti-aimbot angles", "[Shooting]Lower Body Yaw Break Speed", 0, 100, 50, true,"°", 1),
        ["jitter_min"] = ui.new_slider("AA", "Anti-aimbot angles", "[Shooting]Fake Limit Min", 0, 60, 60, true,"°", 1),
        ["jitter_max"] = ui.new_slider("AA", "Anti-aimbot angles", "[Shooting]Fake Limit Max", 0, 60, 60, true,"°", 1),
    },
}

local function visible_table(val, bool)
	for key, v in pairs(val) do
		ui.set_visible(v, bool)
	end
end

local lag_info = {
    current_phase = 1,
    prev_choked = 15
}


local resert_shift ={{
	lag_break_cycle = true
},
{
	lag_break_cycle = false
}
}

client.set_event_callback("setup_command", function(cmd)
	if not ui.get(enabled_aa) then
		return
	end

	local localplayer = entity.get_local_player()
	local _vx, _vy = entity.get_prop(localplayer, "m_vecVelocity")
	local velocity = math.sqrt(_vx^2 + _vy^2) 

	if cmd.chokedcommands < lag_info.prev_choked then
		lag_info.current_phase = lag_info.current_phase + 1
		if lag_info.current_phase > #resert_shift then
			lag_info.current_phase = 1
		end
	end

	ui.set(fakelag_resert, resert_shift[lag_info.current_phase].lag_break_cycle)
	lag_info.prev_choked = cmd.chokedcommands
end)


local function player_weapons(c)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) or not ui.get(enabled_aa) then
		return
	end

	local active_weapon = entity.get_prop(local_player, "m_hActiveWeapon")
	if active_weapon == nil then
		return
	end

	local weapon_real_active = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
	if weapon_real_active == nil then
		return
	end

	local active_weapons_coder = bit.band(weapon_real_active, 0xFFFF)
	if active_weapons_coder == 11 or active_weapons_coder == 38 then
		real_active_weapons = "Auto"
	elseif active_weapons_coder == 9 then
		real_active_weapons = "AWP"
	elseif active_weapons_coder == 40 then
		real_active_weapons = "Scout"
	elseif active_weapons_coder == 2 or active_weapons_coder == 3 or active_weapons_coder == 4 or active_weapons_coder == 30 or active_weapons_coder == 32 or active_weapons_coder == 36 or active_weapons_coder == 61 or active_weapons_coder == 63 then
		real_active_weapons = "Pistol"
	elseif active_weapons_coder == 7 or active_weapons_coder == 8  or active_weapons_coder == 10 or active_weapons_coder == 13 or active_weapons_coder == 16 or active_weapons_coder == 39 then
		real_active_weapons = "Rifle"
	elseif active_weapons_coder == 17 or active_weapons_coder == 19  or active_weapons_coder == 24 or active_weapons_coder == 26 or active_weapons_coder == 33 or active_weapons_coder == 34 then
		real_active_weapons = "SMG"
	elseif active_weapons_coder == 64 then
		real_active_weapons = "R8 Revolver"
	elseif active_weapons_coder == 1 then
		real_active_weapons = "Eagle"
	elseif active_weapons_coder == 14 or active_weapons_coder == 28 then
		real_active_weapons = "Heavy"
	end
end

client.set_event_callback("paint", player_weapons)

local function player_condition(c)
	local local_player = entity.get_local_player()

	if not local_player or not entity.is_alive(local_player) or not ui.get(enabled_aa) then
		return
	end

	local vx, vy, vz = entity.get_prop(local_player, "m_vecVelocity")
	local fl_speed = math.sqrt((vx * vx) + (vy * vy))
	local onground = (bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1)
	local infiniteduck = (bit.band(entity.get_prop(local_player, "m_fFlags"), 2) == 2)
	local weapon = entity.get_player_weapon(local_player)
	local attack_next = entity.get_prop(weapon, "m_flNextPrimaryAttack")
	local tickbase = entity.get_prop(local_player, "m_nTickBase")
	local shooting_ready = (attack_next <= tickbase * globals.tickinterval() - 0.12)
	local slowwalking = ui.get(slow_enabled) and ui.get(slowwalk_key)


	if fl_speed < 5 and not slowwalking and onground and not infiniteduck and shooting_ready == true then 
		Player_State = "Standing"
	elseif fl_speed > 2 and not slowwalking and onground and not infiniteduck and shooting_ready == true then
		Player_State = "Moving"
	elseif fl_speed > 2 and slowwalking and onground and not infiniteduck and shooting_ready == true then
		Player_State = "Slow Motion"
	elseif infiniteduck and shooting_ready == true then
		Player_State = "Crouching"
	elseif shooting_ready == false then
		Player_State = "Shooting"
	end

	if ui.get(while_condition) == "While Weapons" then
		active_selection = player_active_weapons[real_active_weapons]
	elseif ui.get(while_condition) == "While Status" then
		active_selection = player_status_cond[Player_State]
	end

	if ui.get(bodyyaw_val) == "Opposite" then
		local body_pos = entity.get_prop(local_player, "m_flPoseParameter", 11)
		local body_yaw = math.max(-60, math.min(60, body_pos*120-60+0.5))
		local realbody_yaw = body_yaw / 60 * 100
		body_yaw_target = Player_State == "Shooting" and -realbody_yaw or realbody_yaw
	else
		body_yaw_target = ui.get(bodyyaw_val)
	end

end

client.set_event_callback("paint", player_condition)

client.set_event_callback("predict_command", function()
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) or not ui.get(enabled_aa) then
		return
	end

	ui.set(lby_status_ref,ui.get(active_selection["lby_status"]))
	ui.set(lby_break_speed_ref,ui.get(active_selection["lby_break_speed"]))
	if ui.get(lby_status_ref) == "Lua-Half Sway" then
		ui.set(low_body,globals.tickcount() % 100 > 1 and globals.tickcount() % 100 < ui.get(lby_break_speed_ref) and "Eye yaw" or "Opposite")
	elseif ui.get(lby_status_ref) == "Lua-Full Sway" then
		ui.set(low_body,globals.tickcount() % 100 > 1 and globals.tickcount() % 100 < ui.get(lby_break_speed_ref) and "Sway" or "Opposite")
	elseif ui.get(lby_status_ref) == "Lua-Break" then
		ui.set(low_body,globals.tickcount() % 100 > 1 and globals.tickcount() % 100 < ui.get(lby_break_speed_ref) and "Eye yaw" or "Opposite")
    		entity.set_prop(local_player, "m_flPoseParameter", body_yaw_target >= 1 and -100 or 100, 11)
	elseif ui.get(lby_status_ref) == "Off" then
		ui.set(low_body,"Off")
	elseif ui.get(lby_status_ref) == "Sway" then
		ui.set(low_body,"Sway")
	elseif ui.get(lby_status_ref) == "Eye yaw" then
		ui.set(low_body,"Eye yaw")
	elseif ui.get(lby_status_ref) == "Opposite" then
		ui.set(low_body,"Opposite")
	end
end)

local function legitaa_subject(c)
	if not ui.get(enabled_aa) then
		ui.set_visible(invert_hotkey,false)
		ui.set_visible(indicator_status,false)
		ui.set_visible(arrows_status,false)
		ui.set_visible(circle_color_label,false)
		ui.set_visible(circle_color_p,false)
		ui.set_visible(arrow_distance,false)
		ui.set_visible(real_arrows_label,false)
		ui.set_visible(real_arrows_p,false)
		ui.set_visible(fake_arrows_label,false)
		ui.set_visible(fake_arrows_p,false)
		ui.set_visible(while_condition,false)
		ui.set_visible(weapons_acitve_visible,false)
		ui.set_visible(status_acitve_visible,false)
		visible_table(player_active_weapons["Auto"], false)
		visible_table(player_active_weapons["AWP"], false)
		visible_table(player_active_weapons["Scout"], false)
		visible_table(player_active_weapons["Pistol"], false)
		visible_table(player_active_weapons["Rifle"], false)
		visible_table(player_active_weapons["SMG"], false)
		visible_table(player_active_weapons["Heavy"], false)
		visible_table(player_active_weapons["R8 Revolver"], false)
		visible_table(player_active_weapons["Eagle"], false)
		visible_table(player_status_cond["Standing"], false)
		visible_table(player_status_cond["Moving"], false)
		visible_table(player_status_cond["Crouching"], false)
		visible_table(player_status_cond["Slow Motion"], false)
		visible_table(player_status_cond["Shooting"], false)
		return
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "Auto" then
		visible_table(player_active_weapons["Auto"], true)
	else
		visible_table(player_active_weapons["Auto"], false)
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "AWP" then
		visible_table(player_active_weapons["AWP"], true)
	else
		visible_table(player_active_weapons["AWP"], false)
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "Scout" then
		visible_table(player_active_weapons["Scout"], true)
	else
		visible_table(player_active_weapons["Scout"], false)
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "Pistol" then
		visible_table(player_active_weapons["Pistol"], true)
	else
		visible_table(player_active_weapons["Pistol"], false)
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "Rifle" then
		visible_table(player_active_weapons["Rifle"], true)
	else
		visible_table(player_active_weapons["Rifle"], false)
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "SMG" then
		visible_table(player_active_weapons["SMG"], true)
	else
		visible_table(player_active_weapons["SMG"], false)
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "Heavy" then
		visible_table(player_active_weapons["Heavy"], true)
	else
		visible_table(player_active_weapons["Heavy"], false)
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "R8 Revolver" then
		visible_table(player_active_weapons["R8 Revolver"], true)
	else
		visible_table(player_active_weapons["R8 Revolver"], false)
	end

	if ui.get(while_condition) == "While Weapons" and ui.get(weapons_acitve_visible) == "Eagle" then
		visible_table(player_active_weapons["Eagle"], true)
	else
		visible_table(player_active_weapons["Eagle"], false)
	end

	if ui.get(while_condition) == "While Status" and ui.get(status_acitve_visible) == "Standing" then
		visible_table(player_status_cond["Standing"], true)
	else
		visible_table(player_status_cond["Standing"], false)
	end

	if ui.get(while_condition) == "While Status" and ui.get(status_acitve_visible) == "Moving" then
		visible_table(player_status_cond["Moving"], true)
	else
		visible_table(player_status_cond["Moving"], false)
	end

	if ui.get(while_condition) == "While Status" and ui.get(status_acitve_visible) == "Crouching" then
		visible_table(player_status_cond["Crouching"], true)
	else
		visible_table(player_status_cond["Crouching"], false)
	end

	if ui.get(while_condition) == "While Status" and ui.get(status_acitve_visible) == "Slow Motion" then
		visible_table(player_status_cond["Slow Motion"], true)
	else
		visible_table(player_status_cond["Slow Motion"], false)
	end

	if ui.get(while_condition) == "While Status" and ui.get(status_acitve_visible) == "Shooting" then
		visible_table(player_status_cond["Shooting"], true)
	else
		visible_table(player_status_cond["Shooting"], false)
	end

		ui.set_visible(invert_hotkey,true)
		ui.set_visible(indicator_status,true)
		ui.set_visible(arrows_status,ui.get(indicator_status) == "Arrows" and true or false)
		ui.set_visible(real_arrows_label,ui.get(indicator_status) == "Arrows" and true or false)
		ui.set_visible(real_arrows_p,ui.get(indicator_status) == "Arrows" and true or false)
		ui.set_visible(fake_arrows_label,ui.get(indicator_status) == "Arrows" and true or false)
		ui.set_visible(fake_arrows_p,ui.get(indicator_status) == "Arrows" and true or false)
		ui.set_visible(circle_color_label,ui.get(indicator_status) == "Circle" and true or false)
		ui.set_visible(circle_color_p,ui.get(indicator_status) == "Circle" and true or false)


	if ui.get(while_condition) == "While Weapons" then
		ui.set_visible(weapons_acitve_visible,true)
		ui.set_visible(status_acitve_visible,false)
		visible_table(player_status_cond["Standing"], false)
		visible_table(player_status_cond["Moving"], false)
		visible_table(player_status_cond["Crouching"], false)
		visible_table(player_status_cond["Slow Motion"], false)
		visible_table(player_status_cond["Shooting"], false)
	elseif ui.get(while_condition) == "While Status" then
		ui.set_visible(status_acitve_visible,true)
		ui.set_visible(weapons_acitve_visible,false)
		visible_table(player_active_weapons["Auto"], false)
		visible_table(player_active_weapons["AWP"], false)
		visible_table(player_active_weapons["Scout"], false)
		visible_table(player_active_weapons["Pistol"], false)
		visible_table(player_active_weapons["Rifle"], false)
		visible_table(player_active_weapons["SMG"], false)
		visible_table(player_active_weapons["Heavy"], false)
		visible_table(player_active_weapons["R8 Revolver"], false)
		visible_table(player_active_weapons["Eagle"], false)
	end

	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	ui.set(bodyyaw,ui.get(active_selection["body_status"]))
	ui.set(bodyyaw_val,ui.get(invert_hotkey) and ui.get(active_selection["bodyyaw"]) or - ui.get(active_selection["bodyyaw"]))
	ui.set(fake_yaw,ui.get(fakelag_resert) and ui.get(active_selection["jitter_min"]) or ui.get(active_selection["jitter_max"]))
end

client.set_event_callback("paint", legitaa_subject)


client.set_event_callback("weapon_fire", function(e)
    local localplayer_shot = client.userid_to_entindex(e.userid)
    if localplayer_shot ~= entity.get_local_player() then return end
    if -fix_out < globals.realtime() * time_fix then fix_in = globals.realtime() + fix_out end 
end)

local function setMath(int, max, declspec)
    local int = (int > max and max or int)
    local tmp = max / int;
    local i = (declspec / tmp)
    i = (i >= 0 and math.floor(i + 0.5) or math.ceil(i - 0.5))
    return i
end

local function aa_indicator(c)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) or not ui.get(enabled_aa) then
		return
	end

	_x, _y = client.screen_size()
	y = _y / 2
	x = _x / 2

	if ui.get(arrows_status) == "Default" then
		arrows_left = "⮜"
		arrows_right = "⮞"
	elseif ui.get(arrows_status) == "Triangle" then
		arrows_left = "⭠"
		arrows_right = "⭢"
	elseif ui.get(arrows_status) == "Circle Arrows" then
		arrows_left = "⮈"
		arrows_right = "⮊"
	elseif ui.get(arrows_status) == "Fish Spear" then
		arrows_left = "↼"
		arrows_right = "⇀"
	elseif ui.get(arrows_status) == "Pair Arrows" then
		arrows_left = "⮄"
		arrows_right = "⮆"
	elseif ui.get(arrows_status) == "Pair Arrows 2" then
		arrows_left = "⇚"
		arrows_right = "⇛"
	elseif ui.get(arrows_status) == "Barroom" then
		arrows_left = "⭰"
		arrows_right = "⭲"
	elseif ui.get(arrows_status) == "Classic" then
		arrows_left = "<"
		arrows_right = ">"
	elseif ui.get(arrows_status) == "OneTap V2" then
		arrows_left = "◁"
		arrows_right = "▷"
	elseif ui.get(arrows_status) == "TranSparent" then
		arrows_left = "⮘"
		arrows_right = "⮚"
	elseif ui.get(arrows_status) == "Round" then
		arrows_left = "("
		arrows_right = ")"
	elseif ui.get(arrows_status) == "Dick" then
		arrows_left = "ꓷ"
		arrows_right = "D"
	elseif ui.get(arrows_status) == "Square" then
		arrows_left = "⍃"
		arrows_right = "⍄"
	elseif ui.get(arrows_status) == "Stars" then
		arrows_left = "★"
		arrows_right = "★"
	elseif ui.get(arrows_status) == "Caresses" then
		arrows_left = "⇷"
		arrows_right = "⇸"
	elseif ui.get(arrows_status) == "Carabiner" then
		arrows_left = "↩"
		arrows_right = "↪"
	elseif ui.get(arrows_status) == "Special" then
		arrows_left = "⤙"
		arrows_right = "⤚"
	elseif ui.get(arrows_status) == "Crooked Arrow" then
		arrows_left = "⭜"
		arrows_right = "⭝"
	elseif ui.get(arrows_status) == "Circle" then
		arrows_left = "↶"
		arrows_right = "↷"
	elseif ui.get(arrows_status) == "Ribbon 1" then
		arrows_left = "⮰"
		arrows_right = "⮱"
	elseif ui.get(arrows_status) == "Ribbon 2" then
		arrows_left = "⮲"
		arrows_right = "⮳"
	elseif ui.get(arrows_status) == "Ribbon 3" then
		arrows_left = "⮴"
		arrows_right = "⮵"
	elseif ui.get(arrows_status) == "Ribbon 4" then
		arrows_left = "⮶"
		arrows_right = "⮷"
	elseif ui.get(arrows_status) == "Shadows" then
		arrows_left = "◄"
		arrows_right = "►"
	elseif ui.get(arrows_status) == "Double Arrows" then
		arrows_left = "↞"
		arrows_right = "↠"
	elseif ui.get(arrows_status) == "Misc" then
		arrows_left = "◅"
		arrows_right = "▻"
	elseif ui.get(arrows_status) == "Mathematical Arrow" then
		arrows_left = "⥷"
		arrows_right = "⭃"
	elseif ui.get(arrows_status) == "Cross Arrowhead" then
		arrows_left = "⤪"
		arrows_right = "⤨"
	elseif ui.get(arrows_status) == "Triangles Arrows" then
		arrows_left = "◀"
		arrows_right = "▶"
	elseif ui.get(arrows_status) == "Triangles Arrows 2" then
		arrows_left = "⯇"
		arrows_right = "⯈"
	end

	fix_out = 0.32
	if fix_in > globals.realtime() then 
		shot_circle = (setMath(fix_in - globals.realtime(), fix_out , 40) * 0.004) 
	else 
		shot_circle = 0 
	end

	local h, w = 34, 200
	local alpha = 1 + math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 2))) * 219
	local circle_r, circle_g, circle_b, circle_a = ui.get(circle_color_p)
	local white_anim = shot_circle * 620
	local ind_r, ind_g, ind_b, ind_a = math.min(255, circle_r + white_anim), math.min(255, circle_g + white_anim),math.min(255, circle_b + white_anim), math.min(255, circle_a + white_anim)
	local scrsize_x, scrsize_y = client.screen_size()
	local cen_x, cen_y = (scrsize_x * 0.5), (scrsize_y * 0.5)
	time_fix = 255 * 0.04 * globals.frametime()

	local real_r,real_g,real_b,real_a = ui.get(real_arrows_p)
	local fake_r,fake_g,fake_b,fake_a = ui.get(fake_arrows_p)

	if body_yaw_target >= 1 and ui.get(indicator_status) == "Circle" then
		renderer.circle_outline(cen_x, cen_y + ui.get(arrow_distance), ind_r, ind_g, ind_b, alpha, 40, 295 - shot_circle * 362, 0.35 + shot_circle , 6)
	elseif body_yaw_target <= -1 and ui.get(indicator_status) == "Circle" then
		renderer.circle_outline(cen_x, cen_y - ui.get(arrow_distance), ind_r, ind_g, ind_b, alpha, 40, 120, 0.35 + shot_circle, 6)
	end

	if body_yaw_target >= 1 and ui.get(indicator_status) == "Arrows" then
		renderer.text(x - 15 - ui.get(arrow_distance), y, real_r,real_g,real_b,real_a, "c+", 0, arrows_left)
		renderer.text(x + 15 + ui.get(arrow_distance), y, fake_r,fake_g,fake_b,fake_a, "c+", 0, arrows_right)
	elseif body_yaw_target <= -1 and ui.get(indicator_status) == "Arrows" then
		renderer.text(x - 15 - ui.get(arrow_distance), y, fake_r,fake_g,fake_b,fake_a, "c+", 0, arrows_left)
		renderer.text(x + 15 + ui.get(arrow_distance), y, real_r,real_g,real_b,real_a, "c+", 0, arrows_right)
	end
end

client.set_event_callback("paint", aa_indicator)
