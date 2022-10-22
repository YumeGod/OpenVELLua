local ui_lby_auto = ui.reference("AA","Anti-aimbot angles", "Freestanding body yaw")
local script = {
    menu_loc = { "LUA", "B" },
    condition = "Standing"
}
function script:call_menu(func, name, label, ...)
    if ( type(func) ~= "function" ) then
        error("Debug:error")
        return
    end
    local final_name = name ~= nil and name .. "\n" .. label or "\n" .. label
    return func(self.menu_loc[1], self.menu_loc[2], final_name, ...)
end
local conditions = script:call_menu(ui.new_combobox, "Nai-Anti Aim", "ea_cond", "Standing", "Moving", "Slow Walking", "Jumping")

local configurations = {
    ["Standing"] = {
        mode = script:call_menu(ui.new_combobox, nil, "ea_standing_mode", "Static", "Jitter"),
        real_offset = script:call_menu(ui.new_slider, "Static desync %", "ea_standing_real_offset", 0, 100, 90, true, "%", 1, {[0] = "0", [100] = "100"}),  
        jitter_offset = script:call_menu(ui.new_slider, "Jitter desync %", "ea_standing_jitter_offset", 0, 100, 50, true, "%", 1, {[0] = "0", [100] = "100"}),       
    },

    ["Moving"] = {
        mode = script:call_menu(ui.new_combobox, nil, "ea_moving_mode", "Static", "Jitter"),
        real_offset = script:call_menu(ui.new_slider, "Static desync %", "ea_moving_real_offset", 0, 100, 90, true, "%", 1, {[0] = "0", [100] = "100"}),
        jitter_offset = script:call_menu(ui.new_slider, "Jitter desync %", "ea_standing_jitter_offset", 0, 100, 50, true, "%", 1, {[0] = "0", [100] = "100"}),
    },

    ["Slow Walking"] = {
        mode = script:call_menu(ui.new_combobox, nil, "ea_walking_mode", "Static", "Jitter"),
        real_offset = script:call_menu(ui.new_slider, "Static desync %", "ea_walking_real_offset", 0, 100, 90, true, "%", 1, {[0] = "0", [100] = "100"}),
        jitter_offset = script:call_menu(ui.new_slider, "Jitter desync %", "ea_walking_jitter_offset", 0, 100, 50, true, "%", 1, {[0] = "0", [100] = "100"}),
    },

    ["Jumping"] = {
        mode = script:call_menu(ui.new_combobox, nil, "ea_jumping_mode", "Static", "Jitter"),
        real_offset = script:call_menu(ui.new_slider, "Static desync %", "ea_jumping_real_offset", 0, 100, 90, true, "%", 1, {[0] = "0", [100] = "100"}),
        jitter_offset = script:call_menu(ui.new_slider, "Jitter desync %", "ea_jumping_jitter_offset", 0, 100, 50, true, "%", 1, {[0] = "0", [100] = "100"}),
        switch = script:call_menu(ui.new_checkbox, "Jitter Body", "ea_jumping_switch")
    }
}

local manual_antiaim = {
    invert = script:call_menu(ui.new_hotkey, "Invert key", "ea_manual_invert", false),
    left = script:call_menu(ui.new_hotkey, "Body left", "ea_manual_left", false),
    right = script:call_menu(ui.new_hotkey, "Body right", "ea_manual_right", false),
    state = script:call_menu(ui.new_slider, nil, "state", 0, 2, 0),
    bools = {left = false, right = false, invert = false},
    inverted = false,
    jumping = false,
    shooting = false,
    last_shot = 0,
    last_ground_state = false,
    last_shoot_state = false
}
local handle_visibility = function( )
    local enabled = 1
    ui.set_visible(conditions, enabled)
    for label, elem in pairs(manual_antiaim) do
        if( type(elem) == "number" and label ~= "last_shot" ) then
            ui.set_visible(elem, enabled)
        end
    end
    ui.set_visible(manual_antiaim.state, false)
    for cond, _ in pairs(configurations) do 
        local is_jitter = ui.get(configurations[cond]["mode"]) == "Jitter"
        local draw_cond = ui.get(conditions) == cond
        for label, elem in pairs(configurations[cond]) do
            ui.set_visible(elem, true and draw_cond)
            if label == "jitter_offset" then
                ui.set_visible(elem, enabled and draw_cond and is_jitter)
            end
        end
    end
end
local set_callbacks = function( )
    ui.set_callback(conditions, handle_visibility)
    for cond, _ in pairs(configurations) do
        ui.set_callback(configurations[cond]["mode"], handle_visibility)
    end
end
handle_visibility()
set_callbacks()
local ref_yaw, ref_yaw_val = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local ref_jitter, ref_jitter_val = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local ref_body, ref_body_val = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local ref_lby = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local ref_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local ref_sm, ref_sm_key = ui.reference("AA", "Other", "Slow motion")
local ref_fakelag = ui.reference("AA", "Fake lag", "Enabled")
local multi_exec = function(func, table)
    for k, v in pairs(table) do
        func(k, v)
    end
end
local velocity = function(player)
    local x, y, z = entity.get_prop(player, "m_vecVelocity");
    return math.sqrt(
        x * x + y * y
    );
end
local handle_condition = function(cm)
    local local_player = entity.get_local_player( )

    if not local_player or not entity.is_alive(local_player) then
        return
    end

    local flags = entity.get_prop(local_player, "m_fFlags")

    if bit.band(flags, 1) ~= 1 or (cm and cm.in_jump == 1) then script.condition = "Jumping" else
        if velocity(local_player) > 2 then
            if ui.get(ref_sm) and ui.get(ref_sm_key) then
                script.condition = "Slow Walking"
            else
                script.condition = "Moving"
            end
            return
        end
        script.condition = "Standing"
    end
end
function manual_antiaim:handle_keybinds( ) 
    local left_state, right_state, invert_state = ui.get(self.left), ui.get(self.right), ui.get(self.invert)
    local current = ui.get(self.state)

    if( 
        left_state == self.bools.left and 
        right_state == self.bools.right and
        invert_state == self.bools.invert
    ) then 
        return end
    
    self.bools.left = left_state
    self.bools.right = right_state 
    self.bools.invert = invert_state
    if( invert_state ) then
        self.inverted = not self.inverted
        local cond = script.condition
        if( ui.get(configurations["Jumping"].switch) and cond == "Jumping" ) then
            self.last_ground_state = not self.last_ground_state
        end
    end
    if( ( left_state and current == 1 ) or ( right_state and current == 2 ) ) then
        ui.set(self.state, 0)
        return
    end
    if( left_state and current ~= 1 ) then
        ui.set(self.state, 1)
    end
    if( right_state and current ~= 2 ) then
        ui.set(self.state, 2)
    end
end
function manual_antiaim:update( )
    local current = ui.get(self.state)
    local player = entity.get_local_player( )
    if( not player or not entity.is_alive( player ) ) then
        return
    end
    self:handle_keybinds( )
    local _cond = script.condition
    local aa_data = { 
        mode = ui.get(configurations[_cond].mode),

        perc = ui.get(configurations[_cond].real_offset),
        alt_perc = 50,
        jitter_perc = ui.get(configurations[_cond].jitter_offset)
    }
    local yaw_val = function(state, data)
        if( state == 0 ) then
            return data.perc * -0.2
        end
        if self.inverted then
            return current == 1 and 90 or -90
        else
            return current == 1 and -90 or 90
        end
        return state == 0 and data.alt_perc * -0.58 or data.alt_perc * 0.58
    end
    local jitter_val = aa_data.jitter_perc * 0.2
    local lby = function(cond) 
        if( cond == "Standing" ) then  
                return globals.tickcount() % 64 < 2 and "Eye yaw" or "Opposite"
        end
        return "Opposite"
    end
    if( _cond ~= "Jumping" ) then
        if( ui.get(configurations["Jumping"].switch) and self.jumping ) then
            self.inverted = self.last_ground_state
        end
        self.jumping = false
    end
    if( _cond == "Jumping" ) then
        if( ui.get(configurations["Jumping"].switch) ) then
            if( not self.jumping ) then
                self.last_ground_state = self.inverted
            end
            self.inverted = globals.tickcount() % 4 < 2 and true or false
        end
        self.jumping = true
    end
    multi_exec(ui.set, {
        [ref_yaw_val] = self.inverted and -yaw_val(current, aa_data) or yaw_val(current, aa_data),
        [ref_jitter] = aa_data.mode == "Jitter" and "Offset" or "Off",
        [ref_jitter_val] = jitter_val,
        [ref_body] = "Static",
        [ref_body_val] = self.inverted and 40 or -40,
        [ref_lby] = lby(_cond),
        [ref_limit] = _cond == "Slow Walking" and 23 or 60
    })
end
function manual_antiaim:on_fire( )
    self.last_shot = globals.curtime()
end

function manual_antiaim:on_shot( cm )
    if( cm.in_attack == 1 or globals.curtime() - self.last_shot < 0.5 ) then
        if( not self.shooting ) then
            self.shooting = true
            self.last_shoot_state = self.inverted
            self.inverted = not self.inverted
        ui.set(ui_lby_auto, true)
        end
        return
    end

    if( self.shooting ) then
        self.shooting = false
        self.inverted = self.last_shoot_state
    end
end
client.set_event_callback("setup_command", function(cm)
 
    handle_condition( cm )
    manual_antiaim:update( )
end)
local arrow=ui.new_label("lua","b","Arrow/Indicator Color")
local colorpicker=ui.new_color_picker("lua","b","Arrow Color", 255, 105, 180, 255)
client.set_event_callback("paint", function()
    local yawbase=ui.get(ref_body_val)
    local x, y = client.screen_size( )
    local r, g, b = ui.get(colorpicker)
    local alpha = 1 + math.sin(math.abs(-math.pi + (globals.curtime() * (1 / 0.5)) % (math.pi * 2))) * 200
    renderer.indicator(r,g,b,alpha,"☆NaiのAnti-Aim★")
    if yawbase <0 then
    renderer.text(x/2-90, y/2-15, r,g,b,alpha, "C+", 0, "✪")
    else
    renderer.text(x/2+70, y/2-15, r,g,b,alpha, "C+", 0, "✪")
    renderer.indicator(r,g,b,aplha,"123")
    end
end)
client.set_event_callback("setup_command", function()
   
    
end)

