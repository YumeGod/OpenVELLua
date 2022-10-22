local vector = require "vector"

local entity_get_local_player   = entity.get_local_player
local entity_get_players        = entity.get_players
local entity_get_origin         = entity.get_origin
local entity_get_prop           = entity.get_prop
local client_latency            = client.latency
local globals_ticktinterval     = globals.tickinterval
local math_huge                 = math.huge
local math_floor                = math.floor
local math_max                  = math.max
local math_min                  = math.min
local ui_get                    = ui.get
local ui_set_callback           = ui.set_callback
local ui_set                    = ui.set

local blocking = false
local quick_stop = false
local unpressed = false

local enabled_ref
local hotkey_ref
local indicator_ref
local quick_stop_ref

local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

    return new_start < new_stop and math_max(math_min(value, new_stop), new_start) or math_max(math_min(value, new_start), new_stop)
end

local function on_setup_command(setup_command)
    blocking = false

    local latency = client_latency()
    local tickinterval = globals_ticktinterval()
    local latency_in_ticks = math_floor(latency / tickinterval + 0.5) * tickinterval

    local local_player = entity_get_local_player()
    local local_player_origin = vector(entity_get_origin(local_player))
    local local_player_velocity = vector(entity_get_prop(local_player, "m_vecVelocity"))
    local local_player_speed = local_player_velocity:length2d()

    local standalone_quick_stop_distance = map(local_player_speed, 0, 250, 0, 12)

    local closest_player
    local closest_distance = math_huge

    local players = entity_get_players()
    for _, player in pairs(players) do
        if player ~= local_player then
            local origin = vector(entity_get_origin(player))
            local distance = local_player_origin:dist2d(origin)

            if distance < closest_distance then
                closest_player = player
                closest_distance = distance
            end
        end
    end

    if closest_player and closest_distance < 64 then
        local origin = vector(entity_get_origin(closest_player))
        local velocity = vector(entity_get_prop(closest_player, "m_vecVelocity"))
    
        local server_origin = origin + velocity * latency_in_ticks

        local direction_vector = local_player_origin:to(server_origin)
        local direction_yaw = select(2, direction_vector:angles())

        local distance = local_player_origin:dist2d(server_origin)

        if ui_get(hotkey_ref) then
            ui_set(quick_stop_ref, true)
            blocking = ui_get(indicator_ref)

            setup_command.move_yaw      = direction_yaw

            if standalone_quick_stop_distance < distance then
                setup_command.forwardmove = 450
            end
            
            unpressed = false
        else
            -- revert quick stop state
            if not unpressed then
                ui_set(quick_stop_ref, quick_stop)
            end
            unpressed = true
        end
    end
end

local function on_paint()
    if blocking then
        renderer.indicator(200, 200, 200, 255, "BLOCK")
    end
end

local function on_enabled_ref(ref)
    local state = ui_get(ref)

    local update_callback = state and client.set_event_callback or client.unset_event_callback
    update_callback("setup_command", on_setup_command)
    update_callback("paint", on_paint)
end

local function init()
    enabled_ref     = ui.new_checkbox("misc", "movement", "Vertical blockbot")
    hotkey_ref      = ui.new_hotkey("misc", "movement", "Vertical blockbot", true)
    indicator_ref   = ui.new_checkbox("misc", "movement", "Vertical blockbot indicator")
    quick_stop_ref  = ui.reference("misc", "movement", "Standalone quick stop")

    quick_stop      = ui.get(quick_stop_ref)

    on_enabled_ref(enabled_ref)
    ui_set_callback(enabled_ref, on_enabled_ref)
    ui_set_callback(quick_stop_ref, function()
        if not ui_get(hotkey_ref) then
            quick_stop = ui_get(quick_stop_ref)
        end
    end)
end

init()