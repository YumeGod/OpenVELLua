local ref_plist = ui.reference("PLAYERS", "Players", "Player list")
local ref_pref_baim = ui.reference("PLAYERS", "Adjustments", "Override prefer body aim")
local options = ui.new_multiselect("RAGE", 'Other' , "Prefer stomach aim","Backwards/Forwards","Moving targets","Slow targets","Shooting","x2 HP","<x HP","Big desync","Walking jitter desync","Always on")
local headaim_options = ui.new_multiselect("RAGE", 'Other' , "Prefer head aim","Sideways targets","Crouching targets","Fast targets","Shooting","Small desync")
local force_options = ui.new_multiselect("RAGE", 'Other' , "Force body aim", "Backwards/Forwards","Sideways targets","Slow targets","Shooting","x1 HP", "x2 HP","<x HP","Walking jitter desync","1 miss","2 miss")
local indicator = ui.new_checkbox("RAGE", 'Other',"Indicator")
local reset_misses = ui.new_checkbox("RAGE", 'Other' , "Automatically reset misses")
local predictive_baim = ui.new_checkbox("RAGE", 'Other' , "Predictive body aim")
local ref_desync = ui.new_slider("RAGE", 'Other' , "Desync limit",290,580,290,true,"掳",0.1)
local range_slider = ui.new_slider("RAGE", 'Other' , "Range",1,70,30,true,"掳")
local jitter_sensitivity = ui.new_slider("RAGE", 'Other' , "Jitter Sensitivity",1,10,6,true)
local ref_hp_slider = ui.new_slider("RAGE", 'Other' , "HP",1,100)
local fakelag_slider = ui.new_slider("RAGE", 'Other' , "Headaim fakelag ammount",0,14)
local reset_hotkey = ui.new_hotkey("RAGE", 'Other' , "Reset enemy")
local force_hotkey = ui.new_hotkey("RAGE", 'Other' , "Force body aim nearest")
local ref_min_damage = ui.reference("RAGE", "Aimbot", "Minimum damage")
ui.set_visible(range_slider,false)
ui.set_visible(ref_desync,false)
ui.set_visible(ref_hp_slider,false)
ui.set_visible(jitter_sensitivity,false)
ui.set_visible(fakelag_slider,false)
local missLogs = {}
local simTimes = {}
local oldSimTimes = {}
local chokes = {}
local cached_plist
for i=1, 64 do
	missLogs[i] = 0
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

local function vector_angles(x1, y1, z1, x2, y2, z2) -- @sapphyrus
    --https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/mathlib/mathlib_base.cpp#L535-L563
    local origin_x, origin_y, origin_z
    local target_x, target_y, target_z
    if x2 == nil then
        target_x, target_y, target_z = x1, y1, z1
        origin_x, origin_y, origin_z = client.eye_position()
        if origin_x == nil then
            return
        end
    else
        origin_x, origin_y, origin_z = x1, y1, z1
        target_x, target_y, target_z = x2, y2, z2
    end
 
    --calculate delta of vectors
    local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z
 
    if delta_x == 0 and delta_y == 0 then
        return (delta_z > 0 and 270 or 90), 0
    else
        --calculate yaw
        local yaw = math.deg(math.atan2(delta_y, delta_x))
 
        --calculate pitch
        local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
        local pitch = math.deg(math.atan2(-delta_z, hyp))
 
        return pitch, yaw
    end
end

local function normalise_angle(angle)
	angle =  angle % 360 
	angle = (angle + 360) % 360
	if (angle > 180)  then
		angle = angle - 360
	end
	return angle
end

local function is_moving(index)
	local x,y,z = entity.get_prop(index, "m_vecVelocity")
	return math.sqrt(x * x + y * y + z * z) > 1.0
end

local function ent_speed(index)
	local x,y,z = entity.get_prop(index, "m_vecVelocity")
	return math.sqrt(x * x + y * y + z * z)
end

local function ent_speed_2d(index)
	local x,y,z = entity.get_prop(index, "m_vecVelocity")
	return math.sqrt(x * x + y * y)
end


local function body_yaw(entityindex)
	bodyyaw = entity.get_prop(entityindex, "m_flPoseParameter", 11)
	if bodyyaw ~= nil then
		bodyyaw = bodyyaw * 120 - 60
	else
		return nil
	end
	return bodyyaw
end

local function get_body_yaw(entityindex)
	_, model_yaw = entity.get_prop(entityindex, "m_angAbsRotation")
	_, eye_yaw = entity.get_prop(entityindex, "m_angEyeAngles")
	return normalise_angle(model_yaw - eye_yaw)
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

local function vec3_normalize(x, y, z)
	local len = math.sqrt(x * x + y * y + z * z)
	if len == 0 then
		return 0, 0, 0
	end
	local r = 1 / len
	return x*r, y*r, z*r
end

local function vec3_dot(ax, ay, az, bx, by, bz)
	return ax*bx + ay*by + az*bz
end

local function angle_to_vec(pitch, yaw)
	local p, y = math.rad(pitch), math.rad(yaw)
	local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
	return cp*cy, cp*sy, -sp
end

local function ent_speed(index)
	local x,y,z = entity.get_prop(index, "m_vecVelocity")
	if x == nil then
		return 0
	end
	return math.sqrt(x * x + y * y + z * z)
end

-- ent: entity index of target player
-- vx,vy,vz: local player view direction
-- lx,ly,lz: local player origin
local function get_fov_cos(ent, vx,vy,vz, lx,ly,lz)
	local ox,oy,oz = entity.get_prop(ent, "m_vecOrigin")
	if ox == nil then
		return -1
	end

	-- get direction to player
	local dx,dy,dz = vec3_normalize(ox-lx, oy-ly, oz-lz)
	return vec3_dot(dx,dy,dz, vx,vy,vz)
end
local function vec_length(x,y,z)
	temp = x*x + y*y + z*z 
	if temp < 0 then 
		return 0
	else
		return math.sqrt(temp)
	end
end

local closest_player = 0

local function vec3_normalize(x, y, z)
	local len = math.sqrt(x * x + y * y + z * z)
	if len == 0 then
		return 0, 0, 0
	end
	local r = 1 / len
	return x*r, y*r, z*r
end

local function vec3_dot(ax, ay, az, bx, by, bz)
	return ax*bx + ay*by + az*bz
end

local function angle_to_vec(pitch, yaw)
	local p, y = math.rad(pitch), math.rad(yaw)
	local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
	return cp*cy, cp*sy, -sp
end

local function ent_speed(index)
	local x,y,z = entity.get_prop(index, "m_vecVelocity")
	if x == nil then
		return 0
	end
	return math.sqrt(x * x + y * y + z * z)
end

-- ent: entity index of target player
-- vx,vy,vz: local player view direction
-- lx,ly,lz: local player origin
local function get_fov_cos(ent, vx,vy,vz, lx,ly,lz)
	local ox,oy,oz = entity.get_prop(ent, "m_vecOrigin")
	if ox == nil then
		return -1
	end

	-- get direction to player
	local dx,dy,dz = vec3_normalize(ox-lx, oy-ly, oz-lz)
	return vec3_dot(dx,dy,dz, vx,vy,vz)
end
local function vec_length(x,y,z)
	temp = x*x + y*y + z*z 
	if temp < 0 then 
		return 0
	else
		return math.sqrt(temp)
	end
end

local function comp_angle(sx,sy,sz,dsx,dsy,dsz)
	local dx,dy,dz = sx-dsx,sy-dsy,sz-dsz
	local rx,ry,rz = math.asin((dz / vec_length(dx,dy,dz)) * radpi), (math.atan(dy / dx) * radpi) , 0
	if dx > 0.0 then
		ry = ry + 180.0
	end
	return ry
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
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

local function is_auto_vis(local_player,lx,ly,lz,px,py,pz)

	entindex,dmg = client.trace_bullet(local_player,lx,ly,lz,px,py,pz)
	
	if entindex == nil then
		return false
	end
	
	if entindex == local_player then
		return false
	end
	
	if not entity.is_enemy(entindex) then
		return false
	end
	
	if dmg >=  5 then
		return true
	else
		return false
	end
end

local function is_damage_vis(local_player,lx,ly,lz,px,py,pz)

	entindex,dmg = client.trace_bullet(local_player,lx,ly,lz,px,py,pz)
	
	if entindex == nil then
		return false
	end
	
	if entindex == local_player then
		return false
	end
	
	if not entity.is_enemy(entindex) then
		return false
	end
	
	if dmg >=  ui.get(ref_min_damage) then
		return true
	else
		return false
	end
end

local function trace_positions(local_player,px,py,pz,px1,py1,pz1,lx2,ly2,lz2)
	if is_auto_vis(local_player,lx2,ly2,lz2,px,py,pz) then
		return true
	end
	if is_auto_vis(local_player,lx2,ly2,lz2,px1,py1,pz1) then
		return true
	end
	return false
end

local function is_auto_vis_enemy(enemy,lx,ly,lz,px,py,pz)

	entindex,dmg = client.trace_bullet(enemy,lx,ly,lz,px,py,pz)
	
	if entindex == nil then
		return false
	end
	if dmg >= 1 then
		return true
	end
	
	return false
end

local function trace_positions_enemy(eyeposx,eyeposy,eyeposz,lpx, lpy, lpz, lpx1, lpy1, lpz1 , lpx2, lpy2, lpz2,enemy_index)

	if is_auto_vis_enemy(enemy_index,eyeposx,eyeposy,eyeposz,lpx,lpy,lpz) then
		return true
	end
	if is_auto_vis_enemy(enemy_index,eyeposx,eyeposy,eyeposz,lpx1,lpy1,lpz1) then
		return true
	end
	if is_auto_vis_enemy(enemy_index,eyeposx,eyeposy,eyeposz,lpx2,lpy2,lpz2) then
		return true
	end
	
	return false
end

local history = {}
local jitter_delta = 15

local function detect_jitter(i)
	local length = #history[i]
	if length == nil then 
		return 
	end
	
	if length < 65 then
		return 
	end

	local count = 0
	
	for j=(length - 64), length do
	--if both or either body yaws are positive/negative, then we subtract
		if history[i][j] ~= nil and history[i][j - 1] ~= nil then
			if (history[i][j] > 0 and history[i][j - 1] > 0) or (history[i][j] < 0 and history[i][j - 1] < 0) then
				if math.abs((history[i][j] - history[i][j - 1])) > jitter_delta then
					count = count + 1
				end
			else
				--if xor, then we add
				if (history[i][j] > 0 and history[i][j - 1] < 0) or (history[i][j] < 0 and history[i][j - 1] > 0)  then 
					if math.abs((history[i][j] + history[i][j - 1])) > jitter_delta then
						count = count + 1
					end
				end
			end	
		end
	end
	
	if count >= (10 - ui.get(jitter_sensitivity)) then 
		return true
	else
		return false
	end
end

local player_preference = {}

local function on_paint(c)
	if has_value(ui.get(headaim_options),"Sideways targets") or has_value(ui.get(options),"Backwards/Forwards") or has_value(ui.get(force_options),"Backwards/Forwards") 
	or has_value(ui.get(force_options),"Sideways targets")  then
		ui.set_visible(range_slider,true)
	else
		ui.set_visible(range_slider,false)
	end

	if has_value(ui.get(options),"Big desync") or has_value(ui.get(headaim_options),"Small desync") then
		ui.set_visible(ref_desync,true)
	else
		ui.set_visible(ref_desync,false)
	end
	
	if has_value(ui.get(options),"Walking jitter desync") or has_value(ui.get(force_options),"Walking jitter desync") then
		ui.set_visible(jitter_sensitivity,true)
	else
		ui.set_visible(jitter_sensitivity,false)
	end
	
	if has_value(ui.get(options),"<x HP") or has_value(ui.get(force_options),"<x HP")  then
		ui.set_visible(ref_hp_slider,true)
	else
		ui.set_visible(ref_hp_slider,false)
	end
	-- getting nearest player
	
	local entindex = entity.get_local_player()
	if entindex == nil then
		return
	end
	
	local lx,ly,lz = entity.get_prop(entindex, "m_vecOrigin")
	if lx == nil then return end
	local players = entity.get_players(true)
	local pitch, yaw = client.camera_angles()
	local vx, vy, vz = angle_to_vec(pitch, yaw)
	
	-- start out with 180 degrees as the closest
	-- cos(deg2rad(180)) is -1
	local closest_fov_cos = -1

	for i=1, #players do
		entindex = players[i]

		local fov_cos = get_fov_cos(entindex, vx,vy,vz, lx,ly,lz)
		if fov_cos > closest_fov_cos then
			-- this player is closer to our crosshair
			closest_fov_cos = fov_cos
			closest_player = entindex
		end
	end


	-- drawing the indicator
	if not ui.get(indicator) then
		return
	end
	
	local local_player = entity.get_local_player()
	
	if local_player == nil then
		return
	end
	
	if not entity.is_alive(local_player) then
		return
	end

    local players = entity.get_players(true)
	
	if players == nil then
		return
	end
	
	-- getting eyeposition
	local lx,ly,lz = client.eye_position()
	
	if lx == nil then
		return
	end
	
	
	for i=1, #players do
		
        local player_index = players[i]
		
		if not entity.is_enemy(player_index) then
			return
		end
		
		local pos_x, pos_y, pos_z = entity.get_prop(player_index, "m_vecAbsOrigin")
		
        if pos_x == nil then
            return
        end
		
		local selected = player_preference[player_index]
		local r,g,b = 0
		if selected == "-" or selected == "Off" then
			selected = "HEAD"
			r,g,b = 255,0,0
			else if selected == "On" then
				selected = "PREFER"
				r,g,b = 255,165,0
				else if selected == "Force" then
					selected = "FORCE"
					r,g,b = 0,255,0
				end
			end
		end
		
		local x1, y1, x2 , y2 , mult = entity.get_bounding_box(player_index)
		if x1 ~= nil and mult > 0 then
			y1 = y1 - 17
			x1 = x1 + ((x2 - x1) / 2)
			if  y1 ~= nil then
				renderer.text(x1, y1, r, g, b, 255, "cb", 0, selected)
			end
		end
	end
	
	-- resetting the person we are aiming at, if the hotkey is held.
	
	if ui.get(reset_hotkey) then
		if closest_player ~= 0 then
			missLogs[closest_player] = 0
		end
	end

end
client.set_event_callback('paint', on_paint)

local headaim_delay = {}

local function run_command(cmd)
	local local_player = entity.get_local_player()
	
	if local_player == nil then
		return
	end
	
	if not entity.is_alive(local_player) then
		return
	end

    local players = entity.get_players(true)
	
	if players == nil then
		return
	end
	
	-- getting eyeposition
	local lx,ly,lz = client.eye_position()
	
	if lx == nil then
		return
	end
	
	local lpx, lpy, lpz = entity.hitbox_position(local_player, 0) -- head
	local lpx1, lpy1, lpz1 = entity.hitbox_position(local_player, 4) -- upper chest
	local lpx2, lpy2, lpz2 = entity.hitbox_position(local_player, 2) -- pelvis
	
    cached_plist = ui.get(ref_plist)
	
	
	local active_weapon = entity.get_prop(local_player, "m_hActiveWeapon")
		
	if active_weapon == nil then
		return
	end
		
	local idx = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
		
	if idx == nil then 
		return
	end
		
	local item = bit.band(idx, 0xFFFF)
		
	if item == nil then
		return
	end
	
	for i=1, #players do
		
        local player_index = players[i]
		local pos_x, pos_y, pos_z = entity.get_prop(player_index, "m_vecAbsOrigin")
		
        if pos_x ~= nil then
		
			local t = body_yaw(player_index)
			
			if t ~= nil then
				if history[player_index] == nil then
					history[player_index] = {}
				end
				list_len = #history[player_index]
				history[player_index][list_len+ 1] = t --push back their body yaw
			end
			
			if not entity.is_dormant(player_index) and entity.is_alive(player_index) then
			
				ui.set(ref_plist, player_index) -- target this player_index
				ui.set(ref_pref_baim, "-")
				
				local selected_options = ui.get(options)
				local forced = false
				local prefer = false
				local head = false
				
				
				if item == 31 then
					--client.log("zeus force")
					ui.set(ref_pref_baim, "Force")
					forced = true
				end
				if not forced then
				-- baim options
					if ui.get(ref_pref_baim) ~= "On" then
						if has_value(selected_options,"Backwards/Forwards") then
							local pitch, yaw = vector_angles(pos_x, pos_y, pos_z, lx,ly,lz)
							local _,model_yaw = entity.get_prop(player_index, "m_angEyeAngles")
							local delta = math.abs(normalise_angle(yaw - model_yaw))
							if delta > 90 + ui.get(range_slider) or delta < 90 - ui.get(range_slider) then
								ui.set(ref_pref_baim, "On")
								prefer = true
							end
						end
						if has_value(selected_options,"Moving targets") and not prefer then
							if is_moving(player_index) then
								ui.set(ref_pref_baim, "On")
								prefer = true
							end
						end
						if has_value(selected_options,"Slow targets") and not prefer then
							if ent_speed(player_index) > 1.0 and ent_speed(player_index) < 80 then
								ui.set(ref_pref_baim, "On")
								prefer = true
							end
						end
						if has_value(selected_options,"x2 HP") and not prefer then
							if  is_x_shots(local_player,player_index,2) then
								ui.set(ref_pref_baim, "On")
								prefer = true
							end
						end
						if has_value(selected_options,"<x HP") and not prefer then
							if entity.get_prop(player_index,"m_iHealth") <= ui.get(ref_hp_slider) then
								ui.set(ref_pref_baim, "On")
								prefer = true
							end
						end
						if has_value(selected_options,"Shooting") and not prefer then
							local wep = entity.get_player_weapon(player_index)
							if wep ~= nil then
								local last_shot = entity.get_prop(wep,"m_fLastShotTime")
								if (last_shot + 0.500) > globals.curtime() then
									ui.set(ref_pref_baim, "On")
									prefer = true
								end
							end
						end
						if has_value(selected_options,"Big desync") and not prefer then
							local t = max_desync(player_index)
							if t > ui.get(ref_desync) / 10 then
								ui.set(ref_pref_baim, "On")
								prefer = true
							end
						end
						if has_value(selected_options,"Walking jitter desync") and not prefer then
							if ent_speed(player_index) > 2.0 and ent_speed(player_index) < 100 then
								if detect_jitter(player_index) then
									ui.set(ref_pref_baim, "On")
									prefer = true
								end
							end
						end
						if has_value(selected_options,"Always on") and not prefer then
							ui.set(ref_pref_baim, "On")
							prefer = true
						end
					end

					
				-- headaim overrides baim so we call it after
					local selected_options = ui.get(headaim_options)
					if ui.get(ref_pref_baim) ~= "Off" then
						if has_value(selected_options,"Sideways targets") then
							local pitch, yaw = vector_angles(pos_x, pos_y, pos_z, lx,ly,lz)
							local _,model_yaw = entity.get_prop(player_index, "m_angEyeAngles")
							local delta = math.abs(normalise_angle(yaw - model_yaw))
							if delta < 90 + ui.get(range_slider) and delta > 90 - ui.get(range_slider) then
								ui.set(ref_pref_baim, "Off") -- headaim sideways
								head = true
							end
						end
						if has_value(selected_options,"Crouching targets") and not head then
							local duck_ammount = entity.get_prop(player_index, "m_flDuckAmount")
							if duck_ammount >= 0.7 then
								ui.set(ref_pref_baim, "Off")
								head = true
							end
						end
						if has_value(selected_options,"Fast targets") and not head then
							if ent_speed(player_index) > 170 then
								ui.set(ref_pref_baim, "Off")
								head = true
							end
						end
						if has_value(selected_options,"Small desync") and not head  then
							local t = max_desync(player_index)
							if t <= ui.get(ref_desync) / 10 then
								ui.set(ref_pref_baim, "Off")
								head = true
							end
						end
						if has_value(selected_options,"Shooting") and not head then
							local wep = entity.get_player_weapon(player_index)
							if wep ~= nil then
								local last_shot = entity.get_prop(wep,"m_fLastShotTime")
								if (last_shot + 0.500) > globals.curtime() then
									ui.set(ref_pref_baim, "Off")
									head = true
								end
							end
						end
					end
				
				
					local selected_options = ui.get(force_options)
				
					-- Force baim options

					if ui.get(ref_pref_baim) ~= "Force" then
						if has_value(selected_options,"Backwards/Forwards") then
							local pitch, yaw = vector_angles(pos_x, pos_y, pos_z, lx,ly,lz)
							local _,model_yaw = entity.get_prop(player_index, "m_angEyeAngles")
							local delta = math.abs(normalise_angle(yaw - model_yaw))
							if delta > 90 + ui.get(range_slider) or delta < 90 - ui.get(range_slider) then
									ui.set(ref_pref_baim, "Force")
									forced = true
							end
						end
						if has_value(selected_options,"Sideways targets") and not forced then
							local pitch, yaw = vector_angles(pos_x, pos_y, pos_z, lx,ly,lz)
							local _,model_yaw = entity.get_prop(player_index, "m_angEyeAngles")
							local delta = math.abs(normalise_angle(yaw - model_yaw))
							if delta < 90 + ui.get(range_slider) and delta > 90 - ui.get(range_slider) then
								if ent_speed(player_index) > 10 then
									ui.set(ref_pref_baim, "Force")
									forced = true
								end
							end
						end
						if has_value(selected_options,"Slow targets") and not forced then
							if ent_speed(player_index) > 1.0 and ent_speed(player_index) < 80 then
								ui.set(ref_pref_baim, "Force")
								forced = true
							end
						end
						if has_value(selected_options,"x1 HP") and not forced then
							if is_x_shots(local_player,player_index,1) then
								ui.set(ref_pref_baim, "Force")
								forced = true
							end
						end
						if has_value(selected_options,"<x HP") and not forced then
							if entity.get_prop(player_index,"m_iHealth") <= ui.get(ref_hp_slider) then
								ui.set(ref_pref_baim, "Force")
								forced = true
							end
						end
						if has_value(selected_options,"1 miss") and not forced then
							if missLogs[player_index] >= 1 then
								ui.set(ref_pref_baim, "Force")
								forced = true
							end
						end
						if has_value(selected_options,"2 miss") and not forced then
							if missLogs[player_index] >= 2 then
								ui.set(ref_pref_baim, "Force")
								forced = true
							end
						end
						if has_value(selected_options,"x2 HP")  and not forced then
							if is_x_shots(local_player,player_index,2) then
								ui.set(ref_pref_baim, "Force")
								forced = true
							end
						end
						if has_value(selected_options,"Shooting") and not forced then
							local wep = entity.get_player_weapon(player_index)
							if wep ~= nil then
								local last_shot = entity.get_prop(wep,"m_fLastShotTime")
								if (last_shot + 0.500) > globals.curtime() then
									ui.set(ref_pref_baim, "Force")
									forced = true
								end
							end
						end
						if has_value(selected_options,"Walking jitter desync") then
							if ent_speed(player_index) > 1.0 and ent_speed(player_index) < 100 then
								if detect_jitter(player_index) then
									ui.set(ref_pref_baim, "Force")
									forced = true
								end
							end
						end
					end
				end
				
				--	local can1shot = is_x_shots(local_player,player_index,1)
				--	local trace1x,trace1y,trace1z = entity.hitbox_position(player_index, 0) -- head
				--	local can_hit_head = is_damage_vis(local_player,lx,ly,lz,trace1x,trace1y,trace1z)
					
				--		client.log(string.format('head:%s body:%s',can_hit_head,can1shot))
						--client.log(stomach_is_visible[player_index])
				--		if can_hit_head and not can1shot then
				--			--client.log("forced")
				--			ui.set(ref_pref_baim, "Force")
				--			forced = true
				--end

					-- force stomach aim if their foot is stomach is visble soon, but their feet are visible now
					-- prevents shooting toes on fast peekers, lets you shoot toes everywhere else normally
				--	if ui.get(smart_footaim) then
						-- tracing from their foot instead of eyeposition
				--		local trace1x,trace1y,trace1z = entity.hitbox_position(player_index, 11) -- left ankle
				--		local trace2x,trace2y,trace2z = entity.hitbox_position(player_index, 12) -- right ankle
				--		
				--		local can_hit_current = trace_positions(local_player,trace1x,trace1y,trace1z,trace2x,trace2y,trace2z,lx,ly,lz)

				--		if is_moving(player_index) then
				--			--extrapolate them if they're moving
				--			trace1x,trace1y,trace1z = extrapolate_position(trace1x,trace1y,trace1z,10,player_index)
				--			trace2x,trace2y,trace2z = extrapolate_position(trace2x,trace2y,trace2z,10,player_index)
				--		end
				--		
				--		if (trace_positions_enemy(trace1x,trace1y,trace1z,lpx, lpy, lpz, lpx1, lpy1, lpz1 , lpx2, lpy2, lpz2, player_index) or
				--		trace_positions_enemy(trace2x,trace2y,trace2z,lpx, lpy, lpz, lpx1, lpy1, lpz1 , lpx2, lpy2, lpz2, player_index)) and not can_hit_current then
				--			ui.set(ref_pref_baim, "Force")
				--		end
				--	end
				
					player_preference[player_index] = ui.get(ref_pref_baim)
					if not forced then
						local entindex = entity.get_local_player()
						if entindex == nil then
							return
						end
						
						local lx,ly,lz = entity.get_prop(entindex, "m_vecOrigin")
						if lx == nil then return end
						local players = entity.get_players(true)
						local pitch, yaw = client.camera_angles()
						local vx, vy, vz = angle_to_vec(pitch, yaw)
						
						-- start out with 180 degrees as the closest
						-- cos(deg2rad(180)) is -1
						local closest_fov_cos = -1

						for i=1, #players do
							entindex = players[i]

							local fov_cos = get_fov_cos(entindex, vx,vy,vz, lx,ly,lz)
							if fov_cos > closest_fov_cos then
								-- this player is closer to our crosshair
								closest_fov_cos = fov_cos
								closest_player = entindex
							end
						end
						
				
						
						if ui.get(force_hotkey) then
							if closest_player ~= 0 then
								if closest_player == player_index then
									ui.set(ref_plist, closest_player)
									ui.set(ref_pref_baim, "Force")
									player_preference[closest_player] = "Force"
									forced = true
								end
							end
						end
					end
			end
		end
	end
	
	if cached_plist ~= nil then -- restore plist so people can click
		ui.set(ref_plist,cached_plist)
	end
	
end

local function clear_misses(index)
	missLogs[index] = 0
end

client.set_event_callback("aim_miss", function(c)
	local options = ui.get(force_options)
	if c.reason ~= "spread" then
		local t = c.target
		if missLogs[t] == nil then
			missLogs[t] = 1
			if ui.get(reset_misses) then
				if has_value(options,"1 miss") then
					client.delay_call(5,clear_misses,t)
				end
			end
		else
			missLogs[t] = missLogs[t] + 1
			if ui.get(reset_misses) then
				if has_value(options,"2 miss") or has_value(options,"1 miss") then
					client.delay_call(5,clear_misses,t)
				end
			end
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
		player_preference[i] = ""
		cached_plist = nil
		closest_player = 0
	end
end)

client.set_event_callback("cs_game_disconnected", function(c) 
	ui.set(ui.reference("PLAYERS", "Players", "Reset all"), true)
	
	for i=1, 64 do
		missLogs[i] = 0
		player_preference[i] = ""
		cached_plist = nil
		closest_player = 0
	end
	
end)

client.set_event_callback("game_newmap", function(c) 
	ui.set(ui.reference("PLAYERS", "Players", "Reset all"), true)
	
	for i=1, 64 do
		missLogs[i] = 0
		player_preference[i] = ""
		cached_plist = nil
		closest_player = 0
	end
	
end)

client.set_event_callback("player_team", function(c)
	client.update_player_list()
end)

client.set_event_callback("round_prestart", function(c)
	client.update_player_list()
end)
client.set_event_callback('run_command', run_command)