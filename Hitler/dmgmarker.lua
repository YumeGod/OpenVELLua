local init_time = client.timestamp()
local name = "dmgmarker"

local client_color_log = client.color_log 
local client_log = client.log
local client_error_log = client.error_log
local client_delay_call = client.delay_call
local client_set_event_callback = client.set_event_callback
local client_timestamp = client.timestamp
local client_userid_to_entindex = client.userid_to_entindex

local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop

local ui_get = ui.get
local ui_new_checkbox = ui.new_checkbox
local ui_set_callback = ui.set_callback
local ui_new_slider = ui.new_slider
local ui_new_color_picker = ui.new_color_picker
local ui_set_visible = ui.set_visible

local table_insert = table.insert 
local table_remove = table.remove
local table_concat = table.concat 
local math_floor = math.floor
local math_huge = math.huge
local math_sqrt = math.sqrt

local renderer_indicator = renderer.indicator 
local renderer_circle = renderer.circle
local renderer_world_to_screen = renderer.world_to_screen
local renderer_text = renderer.text


-----------------------------------------------------------------------------------------------------
--used instead of client_log to make logs easier to follow through other logs
local function lua_log(...) --inspired by sapphyrus' multicolorlog
	client_color_log(255, 179, 38, "[" .. name .. "]\0")
	local argIndex = 1
	while select(argIndex, ...) ~= nil do
		client_color_log(217, 217, 217, " ", select(argIndex, ...), "\0")
		argIndex = argIndex + 1
	end
	client_color_log(217, 217, 217, " ") -- this is needed to end the line
end

local function lua_error(...) 
	client_color_log(255, 179, 38, "[" .. name .. "]\0")
	client_error_log(...)
end

--https://snippets.bentasker.co.uk/page-1705231140-Check-if-table-has-element-LUA.html
local function table_contains(table, key) 
	for index, value in ipairs(table) do
		if value == key then return true end
	end
	return false
end

local function round(num, numDecimalPlaces) --lua wiki
	local mult = 10^(numDecimalPlaces or 0)
	return math_floor(num * mult + 0.5) / mult
end
-----------------------------------------------------------------------------------------------------

local own_dmgmark_enable = ui_new_checkbox("VISUALS", "Player ESP", "Damage Marker")
local own_dmgmark_color = ui_new_color_picker("VISUALS", "Player ESP", "Damage Marker Color", 255, 179, 38, 127)
local own_dmgmark_add = ui_new_checkbox("VISUALS", "Player ESP", "Damage Marker Add")
local own_dmgmark_fatal = ui_new_checkbox("VISUALS", "Player ESP", "Damage Marker Fatal")
local own_dmgmark_color_fatal = ui_new_color_picker("VISUALS", "Player ESP", "Damage Marker Color Fatal", 0, 220, 255, 191)
local own_dmgmark_size = ui_new_slider("VISUALS", "Player ESP", "Damage Marker Size", 0, 2, 1, true, nil, 1, {[0] = "small", [1] = "medium", [2] = "large"})
local own_dmgmark_time = ui_new_slider("VISUALS", "Player ESP", "Damage Marker Time", 0, 5000, 2500, true, "ms")
local own_dmgmark_fadeing = ui_new_slider("VISUALS", "Player ESP", "Damage Marker Fadeing", 1, 25, 10, true)

local var_dmgmark_enable
local var_dmgmark_color_red
local var_dmgmark_color_green
local var_dmgmark_color_blue
local var_dmgmark_color_alpha
local var_dmgmark_add
local var_dmgmark_fatal
local var_dmgmark_color_fatal_red
local var_dmgmark_color_fatal_green
local var_dmgmark_color_fatal_blue
local var_dmgmark_color_fatal_alpha
local var_dmgmark_size
local var_dmgmark_time 
local var_dmgmark_fadeing


local function menu_call()
	var_dmgmark_enable = ui_get(own_dmgmark_enable)
	var_dmgmark_color_red, var_dmgmark_color_green, var_dmgmark_color_blue, var_dmgmark_color_alpha = ui_get(own_dmgmark_color)
	var_dmgmark_add = ui_get(own_dmgmark_add)
	var_dmgmark_fatal = ui_get(own_dmgmark_fatal)
	var_dmgmark_color_fatal_red, var_dmgmark_color_fatal_green, var_dmgmark_color_fatal_blue, var_dmgmark_color_fatal_alpha = ui_get(own_dmgmark_color_fatal)
	var_dmgmark_size = ui_get(own_dmgmark_size) == 0 and "c-" or ui_get(own_dmgmark_size) == 1 and "c" or ui_get(own_dmgmark_size) == 2 and "c+" 
	var_dmgmark_time = ui_get(own_dmgmark_time)
	var_dmgmark_fadeing = ui_get(own_dmgmark_fadeing)

	ui_set_visible(own_dmgmark_add, var_dmgmark_enable)
	ui_set_visible(own_dmgmark_fatal, var_dmgmark_enable)
	ui_set_visible(own_dmgmark_color_fatal, var_dmgmark_enable)
	ui_set_visible(own_dmgmark_size, var_dmgmark_enable)
	ui_set_visible(own_dmgmark_time, var_dmgmark_enable)
	ui_set_visible(own_dmgmark_fadeing, var_dmgmark_enable)

end
ui_set_callback(own_dmgmark_enable, menu_call)
ui_set_callback(own_dmgmark_fatal, menu_call)
ui_set_callback(own_dmgmark_color_fatal, menu_call)
ui_set_callback(own_dmgmark_color, menu_call)
ui_set_callback(own_dmgmark_time, menu_call)
ui_set_callback(own_dmgmark_fadeing, menu_call)
ui_set_callback(own_dmgmark_add, menu_call)
ui_set_callback(own_dmgmark_size, menu_call)

menu_call()

-- table which holds data for every hit you did
local pre_datatable = {}
-- table which stores the positions for the painting stuff
local final_datatable = {}


local function on_paint()
	if var_dmgmark_enable then
		if #final_datatable ~= 0 then
			for i = 1, #final_datatable do
				if final_datatable[i] ~= nil then
					if client_timestamp() - final_datatable[i][4] > var_dmgmark_time then
						table_remove(final_datatable, i)
						i = i - 1
					end
				end
			end
			for i = 1, #final_datatable do
				local x = final_datatable[i][1]
				local y = final_datatable[i][2]
				local z = final_datatable[i][3]
				local time = final_datatable[i][4]
				local damage = final_datatable[i][5]
				local alive = final_datatable[i][6]

				local sx, sy = renderer_world_to_screen(x, y, z)
				if var_dmgmark_fatal and not alive then
					local alpha = var_dmgmark_color_fatal_alpha - var_dmgmark_color_fatal_alpha * ((client_timestamp() - time)^var_dmgmark_fadeing / var_dmgmark_time^var_dmgmark_fadeing)

					if sx ~= nil then
						renderer_text(sx, sy, var_dmgmark_color_fatal_red, var_dmgmark_color_fatal_green, var_dmgmark_color_fatal_blue, alpha, var_dmgmark_size, 0, damage)
					end
				else
					local alpha = var_dmgmark_color_alpha - var_dmgmark_color_alpha * ((client_timestamp() - time)^var_dmgmark_fadeing / var_dmgmark_time^var_dmgmark_fadeing)

					if sx ~= nil then
						renderer_text(sx, sy, var_dmgmark_color_red, var_dmgmark_color_green, var_dmgmark_color_blue, alpha, var_dmgmark_size, 0, damage)
					end
				end
			end
		end
	end
end

local function on_player_hurt(e)
	if var_dmgmark_enable then
		if client_userid_to_entindex(e.attacker) == entity_get_local_player() then
			if e.weapon == "inferno" then
				local targetX, targetY, targetZ = entity_get_prop(client_userid_to_entindex(e.userid), "m_vecOrigin")
				if var_dmgmark_add then
					for i = 1, #final_datatable do
						if final_datatable[i][7] == client_userid_to_entindex(e.userid) then
							final_datatable[i][4] = 0
							table_insert(final_datatable, {targetX, targetY, targetZ, client_timestamp(), e.dmg_health + final_datatable[i][5], e.health > 0, client_userid_to_entindex(e.userid)})
							return
						end
					end
				end
				table_insert(final_datatable, {targetX, targetY, targetZ, client_timestamp(), e.dmg_health, e.health > 0, client_userid_to_entindex(e.userid)})
			else
				if #pre_datatable ~= 0 then
					local best = math_huge
					local result = -1
					local targetX, targetY, targetZ = entity_get_prop(client_userid_to_entindex(e.userid), "m_vecOrigin")
					targetZ = targetZ + 38
					for i = 1, #pre_datatable do
						local impactX, impactY, impactZ = pre_datatable[i][1], pre_datatable[i][2], pre_datatable[i][3]
						local dist = (targetX - impactX)^2 + (targetY - impactY)^2 + (targetZ - impactZ)^2
						dist = math_sqrt(dist)
						if dist < best then
							best = dist
							result = i
						end
					end
					if result ~= -1 then
						if var_dmgmark_add then
							for i = 1, #final_datatable do
								if final_datatable[i][7] == client_userid_to_entindex(e.userid) then
									final_datatable[i][4] = 0
									table_insert(final_datatable, {pre_datatable[result][1], pre_datatable[result][2], pre_datatable[result][3], client_timestamp(), e.dmg_health + final_datatable[i][5], e.health > 0, client_userid_to_entindex(e.userid)})
									return
								end
							end
						end
						table_insert(final_datatable, {pre_datatable[result][1], pre_datatable[result][2], pre_datatable[result][3], client_timestamp(), e.dmg_health, e.health > 0, client_userid_to_entindex(e.userid)})
					else
						local targetX, targetY, targetZ = entity_get_prop(client_userid_to_entindex(e.userid), "m_vecOrigin")

						if var_dmgmark_add then
							for i = 1, #final_datatable do
								if final_datatable[i][7] == client_userid_to_entindex(e.userid) then
									final_datatable[i][4] = 0
									table_insert(final_datatable, {targetX, targetY, targetZ + 36, client_timestamp(), e.dmg_health + final_datatable[i][5], e.health > 0, client_userid_to_entindex(e.userid)})
									return
								end
							end
						end
						table_insert(final_datatable, {targetX, targetY, targetZ + 36, client_timestamp(), e.dmg_health, e.health > 0, client_userid_to_entindex(e.userid)})
					end
				else
					local targetX, targetY, targetZ = entity_get_prop(client_userid_to_entindex(e.userid), "m_vecOrigin")

				if var_dmgmark_add then
					for i = 1, #final_datatable do
						if final_datatable[i][7] == client_userid_to_entindex(e.userid) then
							final_datatable[i][4] = 0
							table_insert(final_datatable, {targetX, targetY, targetZ + 36, client_timestamp(), e.dmg_health + final_datatable[i][5], e.health > 0, client_userid_to_entindex(e.userid)})
							return
						end
					end
				end
				table_insert(final_datatable, {targetX, targetY, targetZ + 36, client_timestamp(), e.dmg_health, e.health > 0, client_userid_to_entindex(e.userid)})
				end
			end
		end
	end
end

local function on_bullet_impact(e)
	if var_dmgmark_enable then
		if client_userid_to_entindex(e.userid) == entity_get_local_player() then
			table_insert(pre_datatable, {e.x, e.y, e.z})
		end
	end
end

local function on_weapon_fire(e)
	if var_dmgmark_enable then
		if client_userid_to_entindex(e.userid) == entity_get_local_player() then
			pre_datatable = {}
		end 
	end
end

client_set_event_callback("paint", on_paint)
client_set_event_callback("player_hurt", on_player_hurt)
client_set_event_callback("bullet_impact", on_bullet_impact)
client_set_event_callback("weapon_fire", on_weapon_fire)


init_time = round(client_timestamp() - init_time, 2)

client_delay_call(1.0, function ()
	lua_log("loaded successfully in", init_time, "ms")
end)
client_delay_call(2.0, function ()
	lua_log("For bugfixes you can add me through discord - duke#0069")
end)