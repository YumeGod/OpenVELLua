local enable_anti       = ui.reference("aa", "anti-aimbot angles", "Enabled")
local pitch             = ui.reference("aa", "anti-aimbot angles", "Pitch")
local yawbase           = ui.reference("aa", "anti-aimbot angles", "Yaw base")
local yaw , yaw_sli     = ui.reference("aa", "anti-aimbot angles", "Yaw")
local jitter,jitter_sli = ui.reference("aa", "anti-aimbot angles", "Yaw jitter")
local body ,body_sli    = ui.reference("aa", "anti-aimbot angles", "Body yaw")
local freebody          = ui.reference("aa", "anti-aimbot angles", "Freestanding body yaw")
local lby               = ui.reference("aa", "anti-aimbot angles", "Lower body yaw target")
local lby_limit         = ui.reference("aa", "anti-aimbot angles", "Fake yaw limit")
local edge              = ui.reference("aa", "anti-aimbot angles", "Edge yaw")
local free,free_key     = ui.reference("aa", "anti-aimbot angles", "Freestanding")

local aim_step          = ui.reference("Rage","Aimbot","Reduce aim step")
local fakelag           = ui.reference("AA","Fake lag","Limit")

local active_legit      = ui.new_checkbox("AA","Anti-aimbot angles","Enable Legit Anti-aim")

local anti_state        = ui.new_combobox("AA","Anti-aimbot angles","Legit state","Normal","Static","Jitter")

local right_slider      = ui.new_slider("AA","Anti-aimbot angles","R - slider",0,60,0,true, "°", 1)
local left_slider       = ui.new_slider("AA","Anti-aimbot angles","L - slider",0,60,0,true, "°", 1)
local auto_switch       = ui.new_checkbox("AA","Anti-aimbot angles","Auto switch angles")
local switch_hotkey     = ui.new_hotkey("AA","Anti-aimbot angles","Switch angles")
local force_hotkey      = ui.new_hotkey("AA","Anti-aimbot angles","Force angles")

local manual_right_dir  = ui.new_hotkey("AA","Anti-aimbot angles","Right direction")
local manual_left_dir   = ui.new_hotkey("AA","Anti-aimbot angles","Left direction") 
local manual_backward_dir = ui.new_hotkey("AA","Anti-aimbot angles","Backward direction")
local manual_state      = ui.new_slider("AA","Anti-aimbot angles","\n",0,3,0)

local enable_indicator  = ui.new_checkbox("AA","Anti-aimbot angles","Enable indicator")

local enable_pulse = ui.new_checkbox("AA","Anti-aimbot angles","Pulse indicator")
local color_label = ui.new_label("AA","Anti-aimbot angles","Indicator color")
local ind_color = ui.new_color_picker("AA","Anti-aimbot angles","color picker 1",255,255,255,255)

local arrow_label = ui.new_label("AA","Anti-aimbot angles","Arrow color")
local arrow_color = ui.new_color_picker("AA","Anti-aimbot angles","color picker 2",123,23,255,255)
ui.set_visible(manual_state,false)
ui.set_visible(manual_backward_dir,false)
local delay_jitter = 0
local bind_system = {
    left = false,
    right = false,
    back = false,
}
	
function bind_system:update()	
    ui.set(manual_left_dir, "On hotkey")
    ui.set(manual_right_dir, "On hotkey")
    ui.set(manual_backward_dir, "On hotkey")
    local m_state = ui.get(manual_state)
    local left_state, right_state, backward_state = 
        ui.get(manual_left_dir), 
        ui.get(manual_right_dir),
        ui.get(manual_backward_dir)
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
local function new_ui_visible()
    ui.set_visible(pitch,false)
    ui.set_visible(yawbase,false)
    ui.set_visible(yaw,false)
    ui.set_visible(yaw_sli,false)
    ui.set_visible(jitter,false)
    ui.set_visible(jitter_sli,false)
    ui.set_visible(body,false)
    ui.set_visible(body_sli,false)
    ui.set_visible(freebody,false)
    ui.set_visible(lby,false)
    ui.set_visible(lby_limit,false)
    ui.set_visible(edge,false)
    ui.set_visible(free,false)
    ui.set_visible(free_key,false)

    ---------------------------------------------------------
    ui.set_visible(anti_state,ui.get(active_legit))
    ui.set_visible(right_slider,ui.get(anti_state) ~= "Normal" and ui.get(active_legit))
    ui.set_visible(left_slider,ui.get(anti_state) ~= "Normal" and ui.get(active_legit))
    ui.set_visible(auto_switch,ui.get(active_legit))

    ui.set_visible(switch_hotkey,not ui.get(auto_switch) and ui.get(active_legit))
    ui.set_visible(force_hotkey,ui.get(active_legit))
    ui.set_visible(manual_left_dir,ui.get(active_legit))
    ui.set_visible(manual_right_dir,ui.get(active_legit))

    ui.set_visible(enable_indicator,ui.get(active_legit))
    ui.set_visible(color_label,ui.get(enable_indicator) and ui.get(active_legit))
    ui.set_visible(ind_color,ui.get(enable_indicator) and ui.get(active_legit))
    ui.set_visible(enable_pulse,ui.get(enable_indicator) and ui.get(active_legit))

    ui.set_visible(arrow_color,ui.get(enable_indicator) and ui.get(active_legit))
    ui.set_visible(arrow_label,ui.get(enable_indicator) and ui.get(active_legit))

end

local function load_default_set()

    ui.set(aim_step,false)
    ui.set(pitch,"Off")
    ui.set(yawbase,"Local view")
    ui.set(yaw,"180")
    ui.set(jitter,"Off")
    ui.set(body,"Static")
    ui.set(freebody,ui.get(auto_switch) and not ui.get(force_hotkey))
    ui.set(edge,false)
    ui.set(free,"-")
    ui.set(free_key,"Hotkey")
    ui.set(fakelag,3)
    --[[ ui.set(lby_limit,58) ]]
end
local function set_anti(a,b,c,d)
    ui.set(yaw_sli,a)
    ui.set(body_sli,b)
    ui.set(lby,c)
    ui.set(lby_limit,d)
end
local function load_legit_set()

    if ui.get(anti_state) == "Normal"  then
        if ui.get(auto_switch) then
            set_anti(-180,-60,"Opposite",58)
        else
            if ui.get(switch_hotkey) then
                set_anti(-180,-60,"Opposite",58)
            else
                set_anti(180,60,"Opposite",58)
            end
        end
    end

    if ui.get(anti_state) == "Static" then
        if ui.get(auto_switch) then
            set_anti(-180,(ui.get(right_slider)+ui.get(left_slider))/-2,"Opposite",58)
        else
            if ui.get(switch_hotkey) then
                set_anti(180,-(ui.get(left_slider)),"Opposite",58)
                
            else
                set_anti(-180,ui.get(right_slider),"Opposite",58)
            end
        end
    end

    if ui.get(anti_state) == "Jitter" then
        if ui.get(auto_switch) then
            if globals.realtime() > delay_jitter then
                client.delay_call(0.1,function()set_anti(-180,-60 ,"Opposite",math.random((ui.get(right_slider) + ui.get(left_slider))/2,58))end)
                client.delay_call(0.2,function()set_anti(-180,-60,"Opposite",58)end)
                delay_jitter = globals.realtime() + 0.2
            end
        else
            if ui.get(switch_hotkey) then
                if globals.realtime() > delay_jitter then
                    client.delay_call(0.1,function()set_anti(-180,-(60 - ui.get(left_slider)),"Opposite",58)end)
                    client.delay_call(0.2,function()set_anti(-180,-60,"Opposite")end)
                    delay_jitter = globals.realtime() + 0.2
                end
            else
                if globals.realtime() > delay_jitter then
                    client.delay_call(0.1,function()set_anti(180,60 - ui.get(left_slider),"Opposite",58)end)
                    client.delay_call(0.2,function()set_anti(180,60,"Opposite",58)end)
                    delay_jitter = globals.realtime() + 0.2
                end
            end
        end
    end
    if ui.get(manual_state) == 1 then
        set_anti(-120,-60,"Opposite",58)
    elseif ui.get(manual_state) == 2 then
        set_anti(120,60,"Opposite",58)
    elseif ui.get(force_hotkey) then
        set_anti(170,27,"Opposite",58)
    end
end

client.set_event_callback("run_command",function(e)

    bind_system:update()
    new_ui_visible()

    if ui.get(active_legit) then
        ui.set(enable_anti,true)
    else
        return 
    end

    load_default_set()
    load_legit_set()

end)

client.set_event_callback("paint",function()
    if not ui.get(active_legit) then return end
    if not ui.get(enable_indicator) then return end


    local num_round = function(x, n)
        n = math.pow(10, n or 0); x = x * n
        x = x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
        return x / n
    end
    local w, h = client.screen_size()
    local x , y = w/2,h/2
    local me = entity.get_local_player()
    local body_pos = entity.get_prop(me, "m_flPoseParameter", 11) or 0
    local body_yaw = math.max(-60, math.min(60, num_round(body_pos*120-60+0.5, 1)))
    local anti_aim = ui.get(switch_hotkey) and "Right" or "Left"
    local alpha = 1 + math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 2))) * 219 
    local r,g,b,a = ui.get(ind_color)
    if ui.get(enable_pulse) then
        alpha = 1 + math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 2))) * 219
    else
        alpha = a     
    end
    if not ui.get(auto_switch) then
        renderer.text(x,y+20, r,g,b, alpha, "cb", nil, anti_aim)
    else
        renderer.text(x,y+20, r,g,b, alpha, "cb", nil, "Auto switch")
    end
    renderer.text(x,y+35, r,g,b, alpha, "cb", nil, "AA : "..ui.get(anti_state))
    renderer.text(x,y+50, r,g,b, alpha, "cb", nil, "Max : "..body_yaw)

    local arrow = ui.get(switch_hotkey) and "⯈" or "⯇"
    local arrow_x = ui.get(switch_hotkey) and x + 50 or x - 50
    local r_2,g_2,b_2,a_2 = ui.get(arrow_color)
    if not ui.get(auto_switch) then
        renderer.text(arrow_x,y, r_2,g_2,b_2,a_2, "c+", nil, arrow)
    end
end)

client.set_event_callback("shutdown",function()
    ui.set_visible(pitch,true)
    ui.set_visible(yawbase,true)
    ui.set_visible(yaw,true)
    ui.set_visible(yaw_sli,true)
    ui.set_visible(jitter,true)
    ui.set_visible(jitter_sli,true)
    ui.set_visible(body,true)
    ui.set_visible(body_sli,true)
    ui.set_visible(freebody,true)
    ui.set_visible(lby,true)
    ui.set_visible(lby_limit,true)
    ui.set_visible(edge,true)
    ui.set_visible(free,true)
    ui.set_visible(free_key,true)
end)
