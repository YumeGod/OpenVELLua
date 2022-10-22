--TODO: indicators ( FAKE, PREDICTION | DT, ON SHOT AA | SP, FD, BAIM )

-- Debugging
--local inspect = require("inspect")

local cur_alpha    = 255
local target_alpha = 0
local max_alpha    = 255
local min_alpha    = 0
local speed        = 0.04

local fake_string = "FAKE"
local prediction_string = "PREDICTION"
local double_tap_string = "DT"
local on_shot_antiaim_string = "HIDE"
local force_safe_point_string = "SECURE"
local duck_peek_assist_string = "DUCK"
local force_body_aim_string = "BAIM"

-- Controls table
local controls = {
    -- First priority indicators

    -- FAKE (required ragebot, anti-aimbot and body yaw to be on)
    rage_enabled            = ui.reference("rage", "aimbot", "enabled"),
    anti_aimbot_enabled     = ui.reference("aa", "anti-aimbot angles", "enabled"),
    body_yaw_type           = ui.reference("aa", "anti-aimbot angles", "body yaw"),
    fake_show               = ui.new_checkbox("lua", "a", 'Draw fake indicator'),
    fake_label              = ui.new_label("lua", "a", "Fake indicator"),
    fake_color              = ui.new_color_picker("lua", "a", "fake indicator color", 255, 255, 255, 255),
    fake_pulse              = ui.new_checkbox("lua", "a", "Fake indicator alpha animation"),

    -- Prediction
    prediction_show         = ui.new_checkbox("lua", "a", 'Draw prediction indicator'),
    prediction_label        = ui.new_label("lua", "a", "Prediction indicator"),
    prediction_color        = ui.new_color_picker("lua", "a", "prediction indicator color", 255, 255, 255, 255),
    prediction_pulse        = ui.new_checkbox("lua", "a", "Prediction indicator alpha animation"),

    -- Second priority indicators

    -- Double tap
    double_tap_enabled      = ui.reference("rage", "other", "double tap"),
    double_tap_key          = select(2, ui.reference("rage", "other", "double tap")),
    double_tap_time         = 0,
    double_tap              = false,
    double_tap_alpha        = 0,
    double_tap_draw         = false,
    double_tap_show         = ui.new_checkbox("lua", "a", "Draw double tap indicator"),
    double_tap_label        = ui.new_label("lua", "a", "Double tap indicator"),
    double_tap_color        = ui.new_color_picker("lua", "a", "double tap indicator color", 255, 255, 255, 255),
    double_tap_label2       = ui.new_label("lua", "a", "Double tap indicator inactive color"),
    double_tap_color2       = ui.new_color_picker("lua", "a", "double tap off"),
    double_tap_pulse        = ui.new_checkbox("lua", "a", "Double tap indicator alpha animation"),

    -- On shot anti-aim
    on_shot_antiaim_enabled = ui.reference("aa", "other", "on shot anti-aim"),
    on_shot_antiaim_key     = select(2, ui.reference("aa", "other", "on shot anti-aim")),
    on_shot_antiaim_time    = 0,
    on_shot_antiaim         = false,
    on_shot_antiaim_alpha   = 0,
    on_shot_antiaim_draw    = false,
    on_shot_antiaim_show    = ui.new_checkbox("lua", "a", "Draw on shot anti-aim indicator"),
    on_shot_antiaim_label   = ui.new_label("lua", "a", "On shot anti-aim indicator"),
    on_shot_antiaim_color   = ui.new_color_picker("lua", "a", "on shot anti-aim indicator color", 255, 255, 255, 255),
    on_shot_antiaim_pulse   = ui.new_checkbox("lua", "a", "On shot anti-aim indicator alpha animation"),

    -- Third priority indicators (should be sorted by time)

    -- Force body aim
    force_body_aim_key      = ui.reference("rage", "other", "force body aim"),
    force_body_aim_time     = 0,
    force_body_aim          = false,
    force_body_aim_alpha    = 0,
    force_body_aim_draw     = false,
    force_body_aim_show     = ui.new_checkbox("lua", "a", "Draw force body aim indicator"),
    force_body_aim_label    = ui.new_label("lua", "a", "Force body aim indicator"),
    force_body_aim_color    = ui.new_color_picker("lua", "a", "force body aim indicator color", 255, 255, 255, 255),
    force_body_aim_pulse    = ui.new_checkbox("lua", "a", "Force body aim indicator alpha animation"),

    -- Force safe point
    force_safe_point_key    = ui.reference("rage", "aimbot", "force safe point"),
    force_safe_point_time   = 0,
    force_safe_point        = false,
    force_safe_point_alpha  = 0,
    force_safe_point_draw   = false,
    force_safe_point_show   = ui.new_checkbox("lua", "a", "Draw force safe point indicator"),
    force_safe_point_label  = ui.new_label("lua", "a", "Force safe point indicator"),
    force_safe_point_color  = ui.new_color_picker("lua", "a", "force safe point indicator color", 255, 255, 255, 255),
    force_safe_point_pulse  = ui.new_checkbox("lua", "a", "Force safe point indicator alpha animation"),

    -- Duck peek assist & Infinite duck
    infinite_duck_enabled   = ui.reference("misc", "movement", "infinite duck"),
    duck_peek_assist_key    = ui.reference("rage", "other", "duck peek assist"),
    duck_peek_assist_time   = 0,
    duck_peek_assist        = false,
    duck_peek_assist_alpha  = 0,
    duck_peek_assist_draw   = false,
    duck_peek_assist_show   = ui.new_checkbox("lua", "a", "Draw duck peek assist indicator"),
    duck_peek_assist_label  = ui.new_label("lua", "a", "Duck peek assist indicator"),
    duck_peek_assist_color  = ui.new_color_picker("lua", "a", "duck peek assist indicator color", 255, 255, 255, 255),
    duck_peek_assist_pulse  = ui.new_checkbox("lua", "a", "Duck peek assist indicator alpha animation"),

    y_offset                = ui.new_slider("lua", "a", "Indicators Y offset", -60, 60, 24, true, "px"),
    separator               = ui.new_slider("lua", "a", "Indicators separator value", 8, 24, 12, true, "px")
}

ui.set_callback(controls.fake_show, function()
    local state = ui.get(controls.fake_show)
    ui.set_visible(controls.fake_label, state)
    ui.set_visible(controls.fake_color, state)
    ui.set_visible(controls.fake_pulse, state)
end)

ui.set_visible(controls.fake_label, ui.get(controls.fake_show))
ui.set_visible(controls.fake_color, ui.get(controls.fake_show))
ui.set_visible(controls.fake_pulse, ui.get(controls.fake_show))

ui.set_callback(controls.prediction_show, function()
    local state = ui.get(controls.prediction_show)
    ui.set_visible(controls.prediction_label, state)
    ui.set_visible(controls.prediction_color, state)
    ui.set_visible(controls.prediction_pulse, state)
end)

ui.set_visible(controls.prediction_label, ui.get(controls.prediction_show))
ui.set_visible(controls.prediction_color, ui.get(controls.prediction_show))
ui.set_visible(controls.prediction_pulse, ui.get(controls.prediction_show))

ui.set_callback(controls.double_tap_show, function()
    local state = ui.get(controls.double_tap_show)
    ui.set_visible(controls.double_tap_label, state)
    ui.set_visible(controls.double_tap_color, state)
    ui.set_visible(controls.double_tap_pulse, state)
end)

ui.set_visible(controls.double_tap_label, ui.get(controls.double_tap_show))
ui.set_visible(controls.double_tap_color, ui.get(controls.double_tap_show))
ui.set_visible(controls.double_tap_pulse, ui.get(controls.double_tap_show))

ui.set_callback(controls.on_shot_antiaim_show, function()
    local state = ui.get(controls.on_shot_antiaim_show)
    ui.set_visible(controls.on_shot_antiaim_label, state)
    ui.set_visible(controls.on_shot_antiaim_color, state)
    ui.set_visible(controls.on_shot_antiaim_pulse, state)
end)

ui.set_visible(controls.on_shot_antiaim_label, ui.get(controls.on_shot_antiaim_show))
ui.set_visible(controls.on_shot_antiaim_color, ui.get(controls.on_shot_antiaim_show))
ui.set_visible(controls.on_shot_antiaim_pulse, ui.get(controls.on_shot_antiaim_show))

ui.set_callback(controls.force_safe_point_show, function()
    local state = ui.get(controls.force_safe_point_show)
    ui.set_visible(controls.force_safe_point_label, state)
    ui.set_visible(controls.force_safe_point_color, state)
    ui.set_visible(controls.force_safe_point_pulse, state)
end)

ui.set_visible(controls.force_safe_point_label, ui.get(controls.force_safe_point_show))
ui.set_visible(controls.force_safe_point_color, ui.get(controls.force_safe_point_show))
ui.set_visible(controls.force_safe_point_pulse, ui.get(controls.force_safe_point_show))

ui.set_callback(controls.duck_peek_assist_show, function()
    local state = ui.get(controls.duck_peek_assist_show)
    ui.set_visible(controls.duck_peek_assist_label, state)
    ui.set_visible(controls.duck_peek_assist_color, state)
    ui.set_visible(controls.duck_peek_assist_pulse, state)
end)

ui.set_visible(controls.duck_peek_assist_label, ui.get(controls.duck_peek_assist_show))
ui.set_visible(controls.duck_peek_assist_color, ui.get(controls.duck_peek_assist_show))
ui.set_visible(controls.duck_peek_assist_pulse, ui.get(controls.duck_peek_assist_show))

ui.set_callback(controls.force_body_aim_show, function()
    local state = ui.get(controls.force_body_aim_show)
    ui.set_visible(controls.force_body_aim_label, state)
    ui.set_visible(controls.force_body_aim_color, state)
    ui.set_visible(controls.force_body_aim_pulse, state)
end)

ui.set_visible(controls.force_body_aim_label, ui.get(controls.force_body_aim_show))
ui.set_visible(controls.force_body_aim_color, ui.get(controls.force_body_aim_show))
ui.set_visible(controls.force_body_aim_pulse, ui.get(controls.force_body_aim_show))

-- Indicators table
local first_priority    = {}
local second_priority   = {}
local third_priority    = {}

-- Utility functions
local function contains(tbl, value)
    for key, val in pairs(tbl) do
        if val.name == value then
            return true
        end
    end
    return false
end

local function remove(tbl, value)
    for key, val in pairs(tbl) do
        if val.name == value then
            table.remove(tbl, key)
        end
    end
end

-- Callback functions
client.set_event_callback("paint", function()

    if (cur_alpha < min_alpha + 2) then
        target_alpha = max_alpha
    elseif (cur_alpha > max_alpha - 2) then
        target_alpha = min_alpha
    end

    cur_alpha = cur_alpha + (target_alpha - cur_alpha) * speed * (globals.absoluteframetime() * 100)

    local x = select(1, client.screen_size()) / 2
    local y = select(2, client.screen_size()) / 2

    local separator = ui.get(controls.separator)
    local y_offset = ui.get(controls.y_offset)

    first_priority = {
        {name = fake_string, status = ui.get(controls.fake_show) and ui.get(controls.rage_enabled) and ui.get(controls.anti_aimbot_enabled) and ui.get(controls.body_yaw_type) ~= "Off"},
        {name = prediction_string, status = ui.get(controls.prediction_show)}
    }

    local curtime = globals.curtime()

    if ui.get(controls.double_tap_enabled) then
        if not controls.double_tap then
            controls.double_tap_time = curtime
        end
        controls.double_tap = true
    else
        if controls.double_tap then
            controls.double_tap_time = curtime
        end
        controls.double_tap = false
    end

    controls.double_tap_alpha = 10 * (controls.double_tap and math.min(0.1, curtime - controls.double_tap_time) or 0.1 - math.min(0.1, curtime - controls.double_tap_time))
    controls.double_tap_draw = controls.double_tap_alpha ~= 0

    if ui.get(controls.on_shot_antiaim_enabled) and ui.get(controls.on_shot_antiaim_key) then
        if not controls.on_shot_antiaim then
            controls.on_shot_antiaim_time = curtime
        end
        controls.on_shot_antiaim = true
    else
        if controls.on_shot_antiaim then
            controls.on_shot_antiaim_time = curtime
        end
        controls.on_shot_antiaim = false
    end

    controls.on_shot_antiaim_alpha = 10 * (controls.on_shot_antiaim and math.min(0.1, curtime - controls.on_shot_antiaim_time) or 0.1 - math.min(0.1, curtime - controls.on_shot_antiaim_time))
    controls.on_shot_antiaim_draw = controls.on_shot_antiaim_alpha ~= 0

    if controls.double_tap_draw and not contains(second_priority, double_tap_string) and ui.get(controls.double_tap_show) then
        table.insert(second_priority, {name = double_tap_string, alpha = controls.double_tap_alpha})
    elseif not controls.double_tap_draw or not ui.get(controls.double_tap_show) then
        remove(second_priority, double_tap_string)
        -- TODO: RED DOUBLE TAP IF OFF
    end

    if controls.on_shot_antiaim_draw and not contains(second_priority, on_shot_antiaim_string) and ui.get(controls.on_shot_antiaim_show) then
        table.insert(second_priority, {name = on_shot_antiaim_string, alpha = controls.on_shot_antiaim_alpha})
    elseif not controls.on_shot_antiaim_draw then
        remove(second_priority, on_shot_antiaim_string)
    end

    if ui.get(controls.force_body_aim_key) then
        if not controls.force_body_aim then
            controls.force_body_aim_time = curtime
        end
        controls.force_body_aim = true
    else
        if controls.force_body_aim then
            controls.force_body_aim_time = curtime
        end
        controls.force_body_aim = false
    end

    controls.force_body_aim_alpha = 10 * (controls.force_body_aim and math.min(0.1, curtime - controls.force_body_aim_time) or 0.1 - math.min(0.1, curtime - controls.force_body_aim_time))
    controls.force_body_aim_draw = controls.force_body_aim_alpha ~= 0

    if ui.get(controls.force_safe_point_key) then
        if not controls.force_safe_point then
            controls.force_safe_point_time = curtime
        end
        controls.force_safe_point = true
    else
        if controls.force_safe_point then
            controls.force_safe_point_time = curtime
        end
        controls.force_safe_point = false
    end

    controls.force_safe_point_alpha = 10 * (controls.force_safe_point and math.min(0.1, curtime - controls.force_safe_point_time) or 0.1 - math.min(0.1, curtime - controls.force_safe_point_time))
    controls.force_safe_point_draw = controls.force_safe_point_alpha ~= 0

    if ui.get(controls.duck_peek_assist_key) and ui.get(controls.infinite_duck_enabled) then
        if not controls.duck_peek_assist then
            controls.duck_peek_assist_time = curtime
        end
        controls.duck_peek_assist = true
    else
        if controls.duck_peek_assist then
            controls.duck_peek_assist_time = curtime
        end
        controls.duck_peek_assist = false
    end

    controls.duck_peek_assist_alpha = 10 * (controls.duck_peek_assist and math.min(0.1, curtime - controls.duck_peek_assist_time) or 0.1 - math.min(0.1, curtime - controls.duck_peek_assist_time))
    controls.duck_peek_assist_draw = controls.duck_peek_assist_alpha ~= 0

    if controls.force_body_aim_draw and not contains(third_priority, force_body_aim_string) and ui.get(controls.force_body_aim_show) then
        table.insert(third_priority, {name = force_body_aim_string, alpha = controls.force_body_aim_alpha})
    elseif not controls.force_body_aim_draw then
        remove(third_priority, force_body_aim_string)
    end

    if controls.force_safe_point_draw and not contains(third_priority, force_safe_point_string) and ui.get(controls.force_safe_point_show) then
        table.insert(third_priority, {name = force_safe_point_string, alpha = controls.force_safe_point_alpha})
    elseif not controls.force_safe_point_draw then
        remove(third_priority, force_safe_point_string)
    end

    if controls.duck_peek_assist_draw and not contains(third_priority, duck_peek_assist_string) and ui.get(controls.duck_peek_assist_show) then
        table.insert(third_priority, {name = duck_peek_assist_string, alpha = controls.duck_peek_assist_alpha})
    elseif not controls.duck_peek_assist_draw then
        remove(third_priority, duck_peek_assist_string)
    end

    local new_table = {}

    for index, indicator in pairs(first_priority) do
        if indicator.status then
            new_table[#new_table + 1] = indicator.name
        end
    end

    first_priority = new_table

    for index, indicator in pairs(new_table) do
        local r, g, b, a = 255, 255, 255, 255
        if indicator == fake_string then
            r, g, b, a = ui.get(controls.fake_color)
            if ui.get(controls.fake_pulse) then
                a = math.min(a, cur_alpha)
            end
        else
            r, g, b, a = ui.get(controls.prediction_color)
            if ui.get(controls.prediction_pulse) then
                a = math.min(a, cur_alpha)
            end
        end
        local position = index * separator - separator

        -- Drawing the text of the indicator
        renderer.text(x, y_offset + y + position, r, g, b, a, "cb", 0, indicator)
    end

    new_table = {}

    for index, indicator in pairs(second_priority) do
        local r, g, b, a = 255, 255, 255, 255
        if #second_priority == 2 then
            if indicator.name == double_tap_string then index = 1 else index = 2 end
        end
        index = index + #first_priority

        if indicator.name == double_tap_string then
            if ui.get(controls.double_tap_key) then
                r, g, b, a = ui.get(controls.double_tap_color)
            else
                r, g, b, a = ui.get(controls.double_tap_color2)
            end

            if ui.get(controls.double_tap_pulse) then
                a = math.min(a, cur_alpha)
            end
            indicator.alpha = controls.double_tap_alpha
        end

        if indicator.name == on_shot_antiaim_string then
            r, g, b, a = ui.get(controls.on_shot_antiaim_color)
            if ui.get(controls.on_shot_antiaim_pulse) then
                a = math.min(a, cur_alpha)
            end
            indicator.alpha = controls.on_shot_antiaim_alpha
        end

        local position = index * separator - separator
        
        -- Drawing the text of the indicator
        renderer.text(x, y_offset + y + position, r, g, b, a * indicator.alpha, "cb", 0, indicator.name)
    end

    for index, indicator in pairs(third_priority) do
        local r, g, b, a = 255, 255, 255, 255
        index = index + #first_priority + #second_priority

        if indicator.name == force_body_aim_string then
            r, g, b, a = ui.get(controls.force_body_aim_color)
            if ui.get(controls.force_body_aim_pulse) then
                a = math.min(a, cur_alpha)
            end
            indicator.alpha = controls.force_body_aim_alpha
        end

        if indicator.name == force_safe_point_string then
            r, g, b, a = ui.get(controls.force_safe_point_color)
            if ui.get(controls.force_safe_point_pulse) then
                a = math.min(a, cur_alpha)
            end
            indicator.alpha = controls.force_safe_point_alpha
        end

        if indicator.name == duck_peek_assist_string then
            r, g, b, a = ui.get(controls.duck_peek_assist_color)
            if ui.get(controls.duck_peek_assist_pulse) then
                a = math.min(a, cur_alpha)
            end
            indicator.alpha = controls.duck_peek_assist_alpha
        end

        local position = index * separator - separator
        
        -- Drawing the text of the indicator
        renderer.text(x, y_offset + y + position, r, g, b, a * indicator.alpha, "cb", 0, indicator.name)
    end
end)

local vector = require "vector"

-- >> local variables
local aind = {
    enabled = ui.new_multiselect("lua", "a", "Angle indicator", "Default circle", "Real", "Fake", "LBY"),
    rad = ui.new_slider("lua", "a", "Radius", 5, 35, 10),
    circle_acc = ui.new_slider("lua", "a", "Circle accuracy", 1, 30, 1, true, "", 0.1),
    d_lbl = ui.new_label("lua", "a", "Default circle color"),
    d_clr = ui.new_color_picker("lua", "a", "d_clr_22", 30, 30, 30, 255),
    r_lbl = ui.new_label("lua", "a", "Real color"),
    r_clr = ui.new_color_picker("lua", "a", "r_clr_22", 255, 255, 255, 255),
    f_lbl = ui.new_label("lua", "a", "Fake color"),
    f_clr = ui.new_color_picker("lua", "a", "f_clr_22", 255, 0, 0, 255),
    l_lbl = ui.new_label("lua", "a", "LBY color"),
    l_clr = ui.new_color_picker("lua", "a", "l_clr_22", 0, 150, 255, 255),
    diff_ren = ui.new_checkbox("lua", "a", "3D render in TP")
}
local w, h = client.screen_size()

-- >> local functions
local function draw_circle_3d(x, y, z, radius, degrees, start_at, r, g, b, a)
	local accuracy = ui.get(aind.circle_acc)/10
    local old = { x, y }
	for rot=start_at, degrees+start_at, accuracy do
		local rot_t = math.rad(rot)
		local line_ = vector(radius * math.cos(rot_t) + x, radius * math.sin(rot_t) + y, z)
        local current = { x, y }
        current.x, current.y = renderer.world_to_screen(line_.x, line_.y, line_.z)
		if current.x ~=nil and old.x ~= nil then
			renderer.line(current.x, current.y, old.x, old.y, r, g, b, a)
		end
		old.x, old.y = current.x, current.y
	end
end

local function is_thirdperson()
	local x, y, z = client.eye_position()
	local pitch, yaw = client.camera_angles()
	yaw = yaw - 180
	pitch, yaw = math.rad(pitch), math.rad(yaw)
    x = x + math.cos(yaw)*4
	y = y + math.sin(yaw)*4
	z = z + math.sin(pitch)*4
	local wx, wy = renderer.world_to_screen(x, y, z)
	return wx ~= nil
end

-- >> callbacks
local function on_paint()
    if entity.get_local_player() == nil or entity.is_alive(entity.get_local_player()) == false then return end
    local lp_pos = vector(entity.get_origin(entity.get_local_player()))
    local _, head_rot = entity.get_prop(entity.get_local_player(), "m_angAbsRotation");local _, fake_rot = entity.get_prop(entity.get_local_player(), "m_angEyeAngles");local lby_rot = entity.get_prop(entity.get_local_player(), "m_flLowerBodyYawTarget");local _, cam_rot = client.camera_angles()
    local c3d = { degrees=50, start_at=head_rot, start_at2=fake_rot, start_at3=lby_rot }
    local options = ui.get(aind.enabled);local radius_ = ui.get(aind.rad);local r_clr, f_clr, d_clr, l_clr = {ui.get(aind.r_clr)}, {ui.get(aind.f_clr)}, {ui.get(aind.d_clr)}, {ui.get(aind.l_clr)}

    for i=1, #options do
        opt = options[i]
        if opt == "Default circle" then
            if ui.get(aind.diff_ren) then
                if is_thirdperson() then
                    draw_circle_3d(lp_pos.x, lp_pos.y, lp_pos.z, radius_+2*i, 360, 0, d_clr[1], d_clr[2], d_clr[3], d_clr[4])
                else
                    renderer.circle_outline(w/2, h/2, d_clr[1], d_clr[2], d_clr[3], d_clr[4], radius_*2+4*i, 0, 1, 1)
                end
            else
                renderer.circle_outline(w/2, h/2, d_clr[1], d_clr[2], d_clr[3], d_clr[4], radius_*2+4*i, 0, 1, 1)
            end
        elseif opt == "Real" then
            if ui.get(aind.diff_ren) then
                if is_thirdperson() then
                    draw_circle_3d(lp_pos.x, lp_pos.y, lp_pos.z, radius_+2*i, c3d.degrees, c3d.start_at, r_clr[1], r_clr[2], r_clr[3], r_clr[4])
                else
                    c3d.start_at = cam_rot-c3d.start_at-120
                    renderer.circle_outline(w/2, h/2, r_clr[1], r_clr[2], r_clr[3], r_clr[4], radius_*2+4*i, c3d.start_at, 0.2, 1)
                end
            else
                c3d.start_at = cam_rot-c3d.start_at-120
                renderer.circle_outline(w/2, h/2, r_clr[1], r_clr[2], r_clr[3], r_clr[4], radius_*2+4*i, c3d.start_at, 0.2, 1)
            end
        elseif opt == "Fake" then
            if ui.get(aind.diff_ren) then
                if is_thirdperson() then
                    draw_circle_3d(lp_pos.x, lp_pos.y, lp_pos.z, radius_+2*i, c3d.degrees, c3d.start_at2, f_clr[1], f_clr[2], f_clr[3], f_clr[4])
                else
                    c3d.start_at2 = cam_rot-c3d.start_at2-120
                    renderer.circle_outline(w/2, h/2, f_clr[1], f_clr[2], f_clr[3], f_clr[4], radius_*2+4*i, c3d.start_at2, 0.2, 1)
                end
            else
                c3d.start_at2 = cam_rot-c3d.start_at2-120
                renderer.circle_outline(w/2, h/2, f_clr[1], f_clr[2], f_clr[3], f_clr[4], radius_*2+4*i, c3d.start_at2, 0.2, 1)
            end
        elseif opt == "LBY" then
            if ui.get(aind.diff_ren) then
                if is_thirdperson() then
                    draw_circle_3d(lp_pos.x, lp_pos.y, lp_pos.z, radius_+2*i, c3d.degrees, c3d.start_at3, l_clr[1], l_clr[2], l_clr[3], l_clr[4])
                else
                    c3d.start_at3 = cam_rot-c3d.start_at3-120
                    renderer.circle_outline(w/2, h/2, l_clr[1], l_clr[2], l_clr[3], l_clr[4], radius_*2+4*i, c3d.start_at3, 0.2, 1)
                end
            else
                c3d.start_at3 = cam_rot-c3d.start_at3-120
                renderer.circle_outline(w/2, h/2, l_clr[1], l_clr[2], l_clr[3], l_clr[4], radius_*2+4*i, c3d.start_at3, 0.2, 1)
            end
        end
    end
end
client.set_event_callback("paint", on_paint)