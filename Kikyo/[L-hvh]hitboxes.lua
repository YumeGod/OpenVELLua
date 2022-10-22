local globals_realtime = globals.realtime
local globals_curltime = globals.curltime
local globals_frametime = globals.frametime
local globals_absolute_frametime = globals.absoluteframetime
local globals_maxplayers = globals.maxplayers
local globals_tickcount = globals.tickcount
local globals_tickinterval = globals.tickinterval
local globals_mapname = globals.mapname

local client_set_event_callback = client.set_event_callback
local client_console_log = client.log
local client_console_cmd = client.exec
local client_userid_to_entindex = client.userid_to_entindex
local client_get_cvar = client.get_cvar
local client_draw_debug_text = client.draw_debug_text
local client_draw_hitboxes = client.draw_hitboxes
local client_draw_indicator = client.draw_indicator
local client_random_int = client.random_int
local client_random_float = client.random_float
local client_draw_text = client.draw_text
local client_draw_rectangle = client.draw_rectangle
local client_draw_line = client.draw_line
local client_draw_gradient = client.draw_gradient
local client_draw_cricle = client.draw_circle
local client_draw_circle_outline = client.draW_circle_outline
local client_world_to_screen = client.world_to_screen
local client_screen_size = client.screen_size
local client_visible = client.visible
local client_delay_call = client.delay_call
local client_latency = client.latency
local client_camera_angles = client.camera_angles
local client_trace_line = client.trace_line
local client_eye_position = client.eye_posistion

local entity_get_local_player = entity.get_local_player
local entity_get_all = entity.get_all
local entity_get_players = entity.get_players
local entity_get_classname = entity.get_classname
local entity_set_prop = entity.set_prop
local entity_get_prop = entity.get_prop
local entity_is_enemy = entity.is_enemy
local entity_get_player_name = entity.get_player_name
local entity_get_player_weapon = entity.get_player_weapon
local entity_hitbox_position = entity.hitbox_position
local entity_get_steam64 = entity.get_steam64

local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_new_combobox = ui.new_combobox
local ui_new_multiselect = ui.new_multiselect
local ui_new_hotkey = ui.new_hotkey
local ui_new_button = ui.new_button
local ui_new_color_picker = ui.new_color_picker
local ui_reference = ui.reference
local ui_set = ui.set
local ui_get = ui.get
local ui_set_callback = ui.set_callback
local ui_set_visible = ui.set_visible
local ui_is_menu_open = ui.is_menu_open

local math_floor = math.floor
local math_random = math.random
local meth_sqrt = math.sqrt
local table_insert = table.insert
local table_remove = table.remove
local table_size = table.getn
local table_sort = table.sort
local string_format = string.format
local bit_band = bit.band

--[[

    Author: NmChris
    Version: 1.0
    Functionality: Draws hit boxes

    Change log:
        N/A

    To-Do:
        - Add fade out

]]--

-- Menu
local menu = {

    draw_hitbox = ui_new_checkbox("VISUALS", "Colored models", "Draw hitboxes"),
    hitbox_hit = ui_new_combobox("VISUALS", "Colored models", "Damage hitbox mode", "Disabled", "Hitbox", "Full body"),
    hitbox_hit_color = ui_new_color_picker("VISUALS", "Colored models", "Hitbox hit color", 255, 255, 255),
    hitbox_hit_duration = ui_new_slider("VISUALS", "Colored models", "Hitbox hit duration", 1, 10, 1, true),
    hitbox_death = ui_new_combobox("VISUALS", "Colored models", "Death hitbox mode", "Disabled", "Hitbox", "Full body"),
    hitbox_death_color = ui_new_color_picker("VISUALS", "Colored models", "Hitbox death color", 255, 255, 255),
    hitbox_death_duration = ui_new_slider("VISUALS", "Colored models", "Hitbox death duration", 1, 10, 1, true)

}

local function handle_menu()

    if ui_get(menu.draw_hitbox) == true then

        ui_set_visible(menu.hitbox_hit, true)
        ui_set_visible(menu.hitbox_death, true)

        if ui_get(menu.hitbox_hit) == "Disabled" then

            ui_set_visible(menu.hitbox_hit_color, false)
            ui_set_visible(menu.hitbox_hit_duration, false)

        else

            ui_set_visible(menu.hitbox_hit_color, true)
            ui_set_visible(menu.hitbox_hit_duration, true)

        end

        if ui_get(menu.hitbox_death) == "Disabled" then

            ui_set_visible(menu.hitbox_death_color, false)
            ui_set_visible(menu.hitbox_death_duration, false)

        else

            ui_set_visible(menu.hitbox_death_color, true)
            ui_set_visible(menu.hitbox_death_duration, true)

        end

    else

        ui_set_visible(menu.hitbox_hit, false)
        ui_set_visible(menu.hitbox_hit_color, false)
        ui_set_visible(menu.hitbox_hit_duration, false)
        ui_set_visible(menu.hitbox_death, false)
        ui_set_visible(menu.hitbox_death_color, false)
        ui_set_visible(menu.hitbox_death_duration, false)

    end

end

handle_menu()
ui_set_callback(menu.draw_hitbox, handle_menu)
ui_set_callback(menu.hitbox_hit, handle_menu)
ui_set_callback(menu.hitbox_death, handle_menu)

local function draw_hitbox(entindex, mode, hitgroup)

    local draw_group = nil
    local r, g, b, d = nil

    if mode == "Hitbox" then

        r, g, b = ui_get(menu.hitbox_hit_color)
        d = ui_get(menu.hitbox_hit_duration)

        if hitgroup == 1 then

            draw_group = {0, 1}
            client_draw_hitboxes(entindex, d, draw_group, r, g, b)

        elseif hitgroup == 2 then

            draw_group = {4, 5, 6}
            client_draw_hitboxes(entindex, d, draw_group, r, g, b)

        elseif hitgroup == 3 then

            draw_group = {2, 3}
            client_draw_hitboxes(entindex, d, draw_group, r, g, b)

        elseif hitgroup == 4 then

            draw_group = {13, 15, 16}
            client_draw_hitboxes(entindex, d, draw_group, r, g, b)

        elseif hitgroup == 5 then

            draw_group = {14, 17, 18}
            client_draw_hitboxes(entindex, d, draw_group, r, g, b)

        elseif hitgroup == 6 then

            draw_group = {7, 9, 11}
            client_draw_hitboxes(entindex, d, draw_group, r, g, b)

        elseif hitgroup == 7 then

            draw_group = {8, 10, 12}
            client_draw_hitboxes(entindex, d, draw_group, r, g, b)

        end

    elseif mode == "Full body" then

        r, g, b = ui_get(menu.hitbox_death_color)
        d = ui_get(menu.hitbox_death_duration)

        client_draw_hitboxes(entindex, d, 19, r, g, b)

    end

end

local function on_player_hurt(e)

    if ui_get(menu.draw_hitbox) == false then

        return

    end

    local victimEntIndex = client_userid_to_entindex(e.userid)
    local attackerEntIndex = client_userid_to_entindex(e.attacker)

    if victimEntIndex == nil or attackerEntIndex == nil then

        return

    end

    if attackerEntIndex == entity_get_local_player() then

        if e.health > 0 then

            if ui_get(menu.hitbox_hit) == "Disabled" then

                return

            elseif ui_get(menu.hitbox_hit) == "Hitbox" then

                draw_hitbox(victimEntIndex, "Hitbox", e.hitgroup)

            elseif ui_get(menu.hitbox_hit) == "Full body" then

                draw_hitbox(victimEntIndex, "Full body", e.hitgroup)

            end

        else

            if ui_get(menu.hitbox_death) == "Disabled" then

                return

            elseif ui_get(menu.hitbox_death) == "Hitbox" then

                draw_hitbox(victimEntIndex, "Hitbox", e.hitgroup)

            elseif ui_get(menu.hitbox_death) == "Full body" then

                draw_hitbox(victimEntIndex, "Full body", e.hitgroup)

            end

        end

    end

end

client_set_event_callback("player_hurt", on_player_hurt)