local client_set_event_callback, ui_get, ui_new_checkbox, ui_reference, ui_set = client.set_event_callback, ui.get, ui.new_checkbox, ui.reference, ui.set
local rage_ref = ui_reference("RAGE", "Aimbot", "Enabled")
local Fix_legit = ui_new_checkbox("aa", "anti-aimbot angles", "Fixlegit")
local indicator = ui_new_checkbox("aa", "anti-aimbot angles", "ind")
local color = ui.new_color_picker("aa", "anti-aimbot angles", "Color", 0, 255,95,63,255)
local yaw, yaw_slider = ui.reference("aa", "anti-aimbot angles", "yaw")
local body_yaw, body_yaw_slider = ui.reference("aa", "anti-aimbot angles", "body yaw")
local lby_target = ui.reference("aa", "anti-aimbot angles", "lower body yaw target")
local flag_limit = ui.reference("aa", "fake lag", "Limit")
local enabled = ui.new_checkbox("aa", "anti-aimbot angles", "LegitAA")
local swap_sides = ui.new_hotkey("aa", "anti-aimbot angles", "LegitAA", true)
local set, get = ui.set, ui.get
local floor, min, sqrt = math.floor, math.min, math.sqrt
local get_prop, get_lp = entity.get_prop, entity.get_local_player

ui.set(swap_sides, "Toggle")
ui.set_callback(enabled, function(self)
    if get(self) then 
        set(yaw, "180")
        set(yaw_slider, 180)
        set(body_yaw, "Static")
        set(body_yaw_slider, -90)
        set(lby_target, "Opposite")
        set(flag_limit, 6)
    else
        set(yaw, "Off")
        set(yaw_slider, 0)
        set(body_yaw, "Off")
        set(body_yaw_slider, 0)
        set(lby_target, "Off")
    end
end)
local function length3d(self)
    return floor(min(10000, sqrt( 
		( self[1] * self[1] ) +
		( self[2] * self[2] ) +
		( self[3] * self[3] ))+ 0.5)
	)
end

local disabled_aa = false
client.set_event_callback("setup_command", function(cmd)
    if get(enabled) == false then return end
    local me = get_lp()
    local my_vel = length3d({get_prop(me, "m_vecVelocity")})

    if disabled_aa == false then
        if get(swap_sides) then
            set(yaw_slider, -180)
            set(body_yaw_slider, 90)
        else
            set(yaw_slider, 180)
            set(body_yaw_slider, -90)
        end
    end
end)

client.set_event_callback("paint", function()
    if get(enabled) == false or disabled_aa or get(indicator) == false then return end
	local x,y = client.screen_size()
	local cx, cy = x * 0.485, y * 0.485
	local daltaWidth, daltaHeight = renderer.measure_text("C+","}")
	local o, p, q, r = get(color)
    if get(body_yaw_slider) > 0 then 
        renderer.text(cx  - 100, cy, o, p, q, r, "C+", 0, "}")
		renderer.text(cx  + 156 - daltaWidth, cy, 255,95,63,60, "C+", 0, "{")
	else
		renderer.text(cx  - 100, cy, 255,95,63,60, "C+", 0, "{")
		renderer.text(cx  + 156 - daltaWidth, cy, o, p, q, r, "C+", 0, "}")
	end
end)
local function setup_command(cmd)
    if not ui_get(Fix_legit) then
        return
    end
    ui_set(rage_ref, cmd.in_attack ~= 1)
end

client_set_event_callback("setup_command", setup_command)


--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
local legitAA = enabled
local LegitAABreaker = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-aim mode", "Legit AAone")
local aaenabler = ui.reference("AA", "Anti-aimbot angles", "Enabled")
local lby, whocars = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local body, body_num = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local aaenabler = ui.reference("AA", "Anti-aimbot angles", "Enabled")
local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local yaw, yaw_num = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local yaw_jitter = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local function slot87()
	if ui.get(legitAA) then
		if ui.get(LegitAABreaker) == "Maximum" then
			ui.set(lby, "Opposite")
		elseif ui.get(LegitAABreaker) == "Smart" then
			ui.set(limit, 60)
			ui.set(lby, "Eye yaw")
		end
	else
		ui.set(lby, "Off")
	end
end
client.set_event_callback("run_command", function ()
	slot87()
end)
client.set_event_callback("paint", function ()
	if ui.get(legitAA) == false then
		return
	elseif ui.get(LegitAABreaker) == "Legit AAone" then
		ui.set(body, "Static")
	end
end)
local aa_switch = aaenabler
local time_calc = globals.curtime();
local lby_limit = 60;
local cycle = false;
client.set_event_callback("run_command", function ()
    -- uv0 AA_switch
    -- uv1 globals.curtime()
    -- uv2 initial 60
    -- uv3 initial false
        if not ui.get(legitAA, true) then
            aa_switch = false
            return
        end
        if ui.get(LegitAABreaker) == "Legit AAone" and time_calc <= globals.realtime() - 0.001 then
            ui.set(limit, lby_limit)
            if cycle == false then
                lby_limit = lby_limit - 1
                if lby_limit == 25 then
                    cycle = true
                end
            elseif cycle == true then
                lby_limit = lby_limit + 1
                if lby_limit == 60 then
                    cycle = false
                end
            end
            time_calc = globals.realtime()
        end

        if ui.get(LegitAABreaker) == "Legit AAone" and aa_switch == false then
            ui.set(lby, "Opposite")
            aa_switch = true
        elseif ui.get(LegitAABreaker) == "Legit AAone" and ui.get(lby) == "Opposite" and aa_switch == true then
            client.delay_call(1.3, ui.set, lby, "Eye yaw")
        elseif ui.get(LegitAABreaker) == "Legit AAone" and ui.get(lby) == "Eye yaw" and aa_switch == true then
            client.delay_call(1.3, ui.set, lby, "Opposite")
        end
    end)