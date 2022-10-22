local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop
local entity_is_alive = entity.is_alive
local ui_set = ui.set
local ui_get = ui.get
local ui_ref = ui.reference
local set_event_callback = client.set_event_callback

local menu = {
    active = ui.new_checkbox("RAGE", "Other", "Enable jump scout"),
    air_strafe_ref = ui_ref("MISC", "Movement", "Air strafe")
}

set_event_callback("setup_command", function(ctx)
    if not ui_get(menu.active) then return end
    local ply = entity_get_local_player()

    if entity_is_alive(ply) then
        local velocity_x, velocity_y = entity_get_prop(ply, "m_vecVelocity")
        local velocity = math.sqrt(velocity_x^2 + velocity_y^2)

        if velocity < 5 and ui_get(menu.air_strafe_ref) then
            ui_set(menu.air_strafe_ref, false)
        elseif velocity > 5 and not ui_get(menu.air_strafe_ref) then
            ui_set(menu.air_strafe_ref, true)
        end
    end
end)