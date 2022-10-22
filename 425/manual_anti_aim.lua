--#region new controls
local enabled = ui.new_checkbox("AA", "Other", "Enable manual anti-aim")
local indicator_color = ui.new_color_picker("AA", "Other", "enable_manual_anti_aim", 130, 156, 212, 255)
local left_dir = ui.new_hotkey("AA", "Other", "Left direction")
local right_dir = ui.new_hotkey("AA", "Other", "Right direction")
local back_dir = ui.new_hotkey("AA", "Other", "Backwards direction")
local indicator_dist = ui.new_slider("AA", "Other", "Distance between arrows", 1, 100, 15, true, "px")
local manual_inactive_color = ui.new_color_picker("AA", "Other", "manual_inactive_color", 130, 156, 212, 255)
local manual_state = ui.new_slider("AA", "Other", "Manual direction", 0, 3, 0)
--#endregion /new controls
--#region references
local yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") }
--#endregion references
--#region helpers

local multi_exec = function(func, list)
    if func == nil then
        return
    end
    
    for ref, val in pairs(list) do
        func(ref, val)
    end
end

local compare = function(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    
    return false
end
--#endregion /helpers

local bind_system = {
    left = false,
    right = false,
    back = false,
}

function bind_system:update()
    ui.set(left_dir, "On hotkey")
    ui.set(right_dir, "On hotkey")
    ui.set(back_dir, "On hotkey")

    local m_state = ui.get(manual_state)

    local left_state, right_state, backward_state = 
        ui.get(left_dir), 
        ui.get(right_dir),
        ui.get(back_dir)

    if  left_state == self.left and 
        right_state == self.right and
        backward_state == self.back then
        return
    end

    self.left, self.right, self.back = 
        left_state, 
        right_state, 
        backward_state

    if (left_state and m_state == 1) or (right_state and m_state == 2) or (backward_state and m_state == 3) then
        ui.set(manual_state, 0)
        return
    end

    if left_state and m_state ~= 1 then
        ui.set(manual_state, 1)
    end

    if right_state and m_state ~= 2 then
        ui.set(manual_state, 2)
    end

    if backward_state and m_state ~= 3 then
        ui.set(manual_state, 3)
    end
end

local menu_callback = function(e, menu_call)
    local state = not ui.get(enabled) -- or (e == nil and menu_call == nil)
    multi_exec(ui.set_visible, {
        [indicator_color] = not state,
        [manual_inactive_color] = not state,
        [indicator_dist] = not state ,
        [left_dir] = not state,
        [right_dir] = not state,
        [back_dir] = not state,
        [manual_state] = false,
    })
end

ui.set_callback(enabled, menu_callback)

client.set_event_callback("setup_command", function(e)
    if not ui.get(enabled) then
        return
    end

    local direction = ui.get(manual_state)

    local manual_yaw = {
        [0] = 0,
        [1] = -90, [2] = 90,
        [3] = 0,
    }

    if direction == 1 or direction == 2 then
        ui.set(yaw_base, "Local view")
    else
        ui.set(yaw_base, "At targets")
    end

    ui.set(yaw[2], manual_yaw[direction])
end)

client.set_event_callback("paint", function()
    menu_callback(true, true)
    bind_system:update()

    local me = entity.get_local_player()
    
    if not entity.is_alive(me) or not ui.get(enabled) then
        return
    end

    if ui.get(enabled) then
        local w, h = client.screen_size()
        local r, g, b, a = ui.get(indicator_color)
        local r1, g1, b1, a1 = ui.get(manual_inactive_color)
        local m_state = ui.get(manual_state)
    
        local realtime = globals.realtime() % 3
        local distance = (w/2) / 210 * ui.get(indicator_dist)
        local alpha = math.floor(math.sin(realtime * 4) * (a/2-1) + a/2) or a
        -- ⯇ ⯈ ⯅ ⯆

        renderer.text(w/2 - distance, h / 2 - 1, r1, g1, b1, a1, "+c", 0, "⯇")
        renderer.text(w/2 + distance, h / 2 - 1, r1, g1, b1, a1, "+c", 0, "⯈")
        renderer.text(w/2, h / 2 + distance, r1, g1, b1, a1, "+c", 0, "⯆")
        
        if m_state == 1 then renderer.text(w/2 - distance, h / 2 - 1, r, g, b, a, "+c", 0, "⯇") end
        if m_state == 2 then renderer.text(w/2 + distance, h / 2 - 1, r, g, b, a, "+c", 0, "⯈") end
        if m_state == 3 or m_state == 0 then renderer.text(w/2, h / 2 + distance, r, g, b, a, "+c", 0, "⯆") end
    end
end)

