-- WARNING: it's not accurate

local accuracy_boost = ui.reference("RAGE", "Other", "Accuracy boost")

local entity_get_local_player = entity.get_local_player
local entity_get_players = entity.get_players
local entity_is_alive = entity.is_alive

local client_world_to_screen = client.world_to_screen
local entity_get_player_name = entity.get_player_name
local entity_get_bounding_box = entity.get_bounding_box
local renderer_line = renderer.line

local globals_tickinterval = globals.tickinterval
local globals_tickcount = globals.tickcount
local entity_is_dormant = entity.is_dormant
local entity_get_prop = entity.get_prop
local math_floor = math.floor
local ui_get = ui.get

local function time2ticks(TIME)
    return (0.5 + TIME / globals_tickinterval())
end

local function clamp(val, min, max)
    if val < min then val = min end
    if val > max then val = max end

    return val
end

local rad2deg = function(rad) return (rad * 180 / math.pi) end
local deg2rad = function(deg) return (deg * math.pi / 180) end

local function vec_substract(a, b)
    return {
        a[1] - b[1],
        a[2] - b[2],
        a[3] - b[3]
    }
end

local function vec_add(a, b)
    return {
        a[1] + b[1],
        a[2] + b[2],
        a[3] + b[3]
    }
end

local function length_sqr(x, y)
    return (x * x + y * y)
end

-- LAG COMP DATA

local lagcomp = {
    me = nil,
    maximum_ticks = 32,
    records = { },
    predicted = { }
}

function lagcomp:should_lag_compensate(player)
    if lagcomp.me == nil or ui_get(accuracy_boost) == "Off" then
        return false
    end

    if entity_is_dormant(player) --[[ or player == lagcomp.me ]] then
        return false
    end

    return true
end

function lagcomp:get_player_records(player)
    if player ~= nil and lagcomp.records[player] ~= nil then
        return lagcomp.records[player]
    end
end

function lagcomp:reset(player)
    lagcomp.records[player] = { }
    lagcomp.predicted[player] = { }
end

function lagcomp:update_player_record_data(player)
    if player == nil then
        return
    end

    local player_record = lagcomp.records[player]
    local sim_time = entity_get_prop(player, "m_flSimulationTime")

    if player_record == nil then
        lagcomp.records[player] = { }
        player_record = lagcomp.records[player]
    end

    if sim_time > 0 and (#player_record == 0 or (#player_record > 0 and player_record[1].simulation_time ~= sim_time)) then
        local new_record = {
            origin = { entity_get_prop(player, "m_vecOrigin") },
            velocity = { entity_get_prop(player, "m_vecVelocity") },
            m_angAngles  = { entity_get_prop(player, "m_angEyeAngles") },

            m_vecMins = { entity_get_prop(player, "m_vecMins") },
            m_vecMaxs = { entity_get_prop(player, "m_vecMaxs") },

            simulation_time = entity_get_prop(player, "m_flSimulationTime"),

            on_ground = (entity_get_prop(player, "m_vecVelocity[2]")^2 > 0),
            m_iTickCount = globals_tickcount()
        }

        for i = lagcomp.maximum_ticks, 2, -1 do 
            lagcomp.records[player][i] = lagcomp.records[player][i-1]
        end

        lagcomp.records[player][1] = new_record
    end
end

function lagcomp:simulate_movement(data)
    local sv_gravity = cvar.sv_gravity:get_int()
    local sv_jump_impulse = cvar.sv_jump_impulse:get_int()
    local gravity_per_tick = sv_gravity * globals_tickinterval()

    local predicted_origin = data.origin

    --[[
        if data.on_ground then
            data.velocity[3] = data.velocity[3] - gravity_per_tick
        end
    ]]

    predicted_origin = vec_add(predicted_origin, {
        data.velocity[1] * globals_tickinterval(),
        data.velocity[2] * globals_tickinterval(),
        data.velocity[3] * globals_tickinterval()
    })

    local fraction = client.trace_line(-1, data.origin[1], data.origin[2], data.origin[3], predicted_origin[1], predicted_origin[2], predicted_origin[3])

    if fraction == 1 then
        data.origin = predicted_origin
    end

    local fraction = client.trace_line(-1, data.origin[1], data.origin[2], data.origin[3], data.origin[1], data.origin[2], data.origin[3] - 2)
    data.on_ground = fraction == 0

    return data
end

function lagcomp:predict_player(player, current_record, next_record)
    if not lagcomp:should_lag_compensate(player) then
        return
    end

    local simulation_data = {
        entity = player,
        simulation_time = current_record.simulation_time,
        origin = current_record.origin,
        velocity = current_record.velocity,
        on_ground = current_record.on_ground
    }

    local simulation_time_delta = current_record.m_iTickCount - next_record.m_iTickCount
    local simulation_tick_delta = clamp(simulation_time_delta, 1, 15)

    if simulation_tick_delta > 0 then
        local ticks_left = simulation_tick_delta

        repeat
            simulation_data = lagcomp:simulate_movement(simulation_data)
            simulation_data.simulation_time = simulation_data.simulation_time + globals_tickinterval()

            ticks_left = ticks_left - 1
        until (ticks_left == 0)

        return simulation_data
    end
end

client.set_event_callback("net_update_end", function()
    lagcomp.me = entity_get_local_player()

    if not lagcomp.me or not entity_is_alive(lagcomp.me) then
        return
    end

    local player = entity.get_players(true)

    for i = 1, #player do
        local player = player[i]

        if not lagcomp:should_lag_compensate(player) then
            lagcomp:reset(player)
        else
            lagcomp:update_player_record_data(player)
        end
    end
end)

local function ray_predicted(c, player, data)
    if data == nil or player == nil then
        return
    end

    local min = vec_add({ entity_get_prop(player, "m_vecMins") }, data.origin)
    local max = vec_add({ entity_get_prop(player, "m_vecMaxs") }, data.origin)
    
    local points =
    {
        {min[1], min[2], min[3]},
        {min[1], max[2], min[3]},
        {max[1], max[2], min[3]},
        {max[1], min[2], min[3]},
        {min[1], min[2], max[3]},
        {min[1], max[2], max[3]},
        {max[1], max[2], max[3]},
        {max[1], min[2], max[3]},
    }
    
    local edges = {
        {0, 1}, {1, 2}, {2, 3}, {3, 0},
        {5, 6}, {6, 7}, {1, 4}, {4, 8},
        {0, 4}, {1, 5}, {2, 6}, {3, 7},
        {5, 8}, {7, 8}, {3, 4}
    }

    for i = 1, #edges do
        if points[edges[i][1]] ~= nil and points[edges[i][2]] ~= nil then
            local p1 = { client_world_to_screen(c, points[edges[i][1]][1], points[edges[i][1]][2], points[edges[i][1]][3]) }
            local p2 = { client_world_to_screen(c, points[edges[i][2]][1], points[edges[i][2]][2], points[edges[i][2]][3]) }

            renderer_line(p1[1], p1[2], p2[1], p2[2], 47, 117, 221, 220)
        end
    end

    local origin = { entity_get_prop(player, "m_vecOrigin") }
    local st1 = { client_world_to_screen(c, origin[1], origin[2], origin[3]) }
    local st2 = { client_world_to_screen(c, min[1], min[2], min[3]) }

    if st1[1] ~= nil and st2[1] ~= nil then
        renderer_line(st1[1], st1[2], st2[1], st2[2], 47, 117, 221, 220)
    end

    local name = entity_get_player_name(player)
    local y_additional = name == "" and -8 or 0
    local x1, y1, x2, y2, a_multiplier = entity_get_bounding_box(player)

    if x1 ~= nil and entity_is_alive(player) and a_multiplier > 0 then
        local x_center = x1 + (x2-x1)/2

        if x_center ~= nil then
            local alpha = (a_multiplier * 255)

            client.draw_text(c, x_center, y1 - 15 + y_additional, 255, 45, 45, alpha > 220 and 220 or alpha, "c-", 0, "LAG COMP BREAKER")
        end
    end
end

client.set_event_callback("paint", function(c)
    local player = entity.get_players(true)

    if not entity_is_alive(lagcomp.me) then
        return
    end

    for i = 1, #player do
        local ent = player[i]

        if not lagcomp:should_lag_compensate(ent) then
            return
        end

        local records = lagcomp:get_player_records(ent)
        if records == nil then
            return
        end

        local current_record, next_record =
            records[1],
            records[2]

        if current_record == nil or next_record == nil then
            return
        end

        local diff_origin = vec_substract(current_record.origin, next_record.origin)
        local teleport_distance = length_sqr(diff_origin[1], diff_origin[2])

        local vel_x, vel_y = current_record.velocity[1], current_record.velocity[2]
        local abs_velocity = math.floor(math.min(10000, math.sqrt(vel_x*vel_x + vel_y*vel_y) + 0.5))

        if abs_velocity > 280 and length_sqr(diff_origin[1], diff_origin[2]) > 4096 then
            local predicted_data = lagcomp:predict_player(ent, current_record, next_record)

            if predicted_data ~= nil then
                lagcomp.predicted[ent] = predicted_data
                ray_predicted(c, ent, lagcomp.predicted[ent])
            end
        end
    end
end)
