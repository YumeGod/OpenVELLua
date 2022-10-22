local enable = ui.new_checkbox("PLAYERS", "Adjustments", "Legit AA Resolver")
local player_list = ui.reference("PLAYERS", "Players", "Player list")
local force_body = ui.reference("PLAYERS", "Adjustments", "Force body yaw")
local body_slider = ui.reference("PLAYERS", "Adjustments", "Force body yaw value")
local saved_enable = { }


local client_register_esp_flag, entity_is_enemy, plist_get = client.register_esp_flag, entity.is_enemy, plist.get

client.color_log(0, 191, 255, "Legit AA Resolver by Hitler Q3487510691")

client_register_esp_flag("AA", 0, 191, 255, function(c)
	if entity_is_enemy(c) then
		return plist_get(c, "Force body yaw") and plist_get(c, "Force body yaw value") ~= 0
	end
end)

ui.set_callback(player_list, function()
    ui.set(enable, saved_enable[ui.get(player_list)] or false)
end)

ui.set_callback(enable, function()
    local plist = ui.get(player_list)
    if plist then
        saved_enable[plist] = ui.get(enable)
    end
end)

local function normalize(angle)
    while angle > 180 do
        angle = angle - 360
    end
    while angle < -180 do
        angle = angle + 360
    end

    return angle
end

client.set_event_callback("run_command", function()
    if not ui.is_menu_open() then
        client.update_player_list()
        for k, v in pairs(saved_enable) do
            if entity.is_enemy(k) then
                ui.set(player_list, k)
                if v then
                    local velocity = { entity.get_prop(k, "m_vecVelocity") }
                    if 1 > math.abs(math.sqrt(velocity[1]^2+velocity[2]^2)) then
                        ui.set(force_body, true)
                        ui.set(body_slider, -math.min(60, math.max(-60, normalize(entity.get_prop(k, "m_angEyeAngles[1]")-entity.get_prop(k, "m_flLowerBodyYawTarget")))))
                    end
                else
                    ui.set(body_slider, 0)
                    ui.set(force_body, false)
                end
            end
        end
    end
end)

client.set_event_callback("player_connect_full", function(c)
    if client.userid_to_entindex(c) == entity.get_local_player() then
        saved_enable = { }
    end
end)