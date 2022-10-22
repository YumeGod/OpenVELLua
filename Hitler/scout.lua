--lua fix and update by Hitler Q3487510691
local ui_new_checkbox = ui.new_checkbox
local client_set_event_callback = client.set_event_callback
local scout_enabled = ui_new_checkbox("MISC", "Movement", "Jump Scout")
local find, get, set = ui.reference, ui.get, ui.set
local set_event = client.set_event_callback
local get_prop, get_local = entity.get_prop, entity.get_local_player
local air_strafe = find("Misc", "Movement", "Air strafe")
client.color_log(0, 255, 127, "Jump Scout by Hitler Q3487510691")
local function on_enabled_change()
set_event("setup_command", function(c)
    local vel_x, vel_y = get_prop(get_local(), "m_vecVelocity")
    local vel = math.sqrt(vel_x^2 + vel_y^2)
    
    if c.in_jump and vel < 5 then
        if ui.get(scout_enabled) then
        set(air_strafe, false)
        end
    else
        if ui.get(scout_enabled) then
        set(air_strafe, true)
        end
    end
end) 
end
ui.set_callback(scout_enabled, on_enabled_change)