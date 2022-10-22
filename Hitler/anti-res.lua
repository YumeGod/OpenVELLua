local ui_get = ui.get
local ui_set = ui.set


local scrsize_x, scrsize_y = client.screen_size()
local center_x, center_y = scrsize_x / 2, scrsize_y / 2
local client_latency, client_set_clan_tag, client_draw_indicator, client_log, client_draw_rectangle, client_world_to_screen, client_draw_circle_outline, client_timestamp, client_draw_circle = client.latency, client.set_clan_tag, client.draw_indicator, client.log, client.draw_rectangle, client.world_to_screen, client.draw_circle_outline, client.timestamp, client.draw_circle
local aa_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled")
local x_slider = ui.new_slider("VISUALS", "Other ESP", "Fake indicator X offset", 0, 200, 200)
local y_slider = ui.new_slider("VISUALS", "Other ESP", "Fake indicator Y offset", 0, 200, 20)
local angle = 0
client.color_log(255, 215, 0, "Anti-Res by Hitler Q3487510691")


local get_local_player, get_prop = entity.get_local_player, entity.get_prop

local min, abs, sqrt, floor = math.min, math.abs, math.sqrt, math.floor

local yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local yaw,slider = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local low_ref = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local fakelim = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local lowbodytarget = ui.reference("AA", "Anti-aimbot angles", "lower body yaw target")
local _, yawst = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local _, yawjt = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local check = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-Res")
local combo = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-Res mode", { "Opposite", "Random", "Step" })
local ab_range = ui.new_slider("AA", "Anti-aimbot angles", "Anti-Res range", 1, 100, 32)
local check4 = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-Res lower body yaw mode" , { "Off", "Random", "Switch" })
local bodyyaw_range = ui.new_slider("AA", "Anti-aimbot angles", "Anti-Res body yaw", 0, 180, 9)
local jitteryaw_range = ui.new_slider("AA", "Anti-aimbot angles", "Anti-Res jitter", 0, 180, 25)
local check2 = ui.new_multiselect("AA", "Anti-aimbot angles", "Anti-Res Safe Shot", { "Flip body yaw","Change yaw limit","Change lower body yaw" })
local check3 = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-Res Air Jitter")
local airjitteryaw_range = ui.new_slider("AA", "Anti-aimbot angles", "Anti-Res Air jitter", 1, 180, 54)
local check9 = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-Res Smart speed jitter")
local safe_range = ui.new_slider("AA", "Anti-aimbot angles", "Anti-Res Desync Max", 0, 60, 60)
local safe1_range = ui.new_slider("AA", "Anti-aimbot angles", "Anti-Res Desync Min", 0, 60, 45)
local left_key = ui.new_hotkey("AA", "Anti-aimbot angles","Anti-Res Left")
local right_key = ui.new_hotkey("AA", "Anti-aimbot angles","Anti-Res Right")
local back_key = ui.new_hotkey("AA", "Anti-aimbot angles","Anti-Res Reset")
local autodir = false

function table_contains(tbl, value)
    for i = 1, #tbl do
        if tbl[i] == value then
            return true
        end
    end
    return false
end

local function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

local should_swap = false
local it = 0
local angles = { 47, -55, -22, 42, 28, -52, -25, 58 }
client.set_event_callback("bullet_impact", function(c)
    if ui.get(check) and entity.is_alive(entity.get_local_player()) then
        local ent = client.userid_to_entindex(c.userid)
        if not entity.is_dormant(ent) and entity.is_enemy(ent) then
            local ent_shoot = { entity.get_prop(ent, "m_vecOrigin") }
            ent_shoot[3] = ent_shoot[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
            local player_head = { entity.hitbox_position(entity.get_local_player(), 0) }
            local closest = GetClosestPoint(ent_shoot, { c.x, c.y, c.z }, player_head)
            local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
            local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
        
            if math.abs(delta_2d) < ui.get(ab_range) then
                it = it + 1
                should_swap = true
            end
        end
    end
end)

client.set_event_callback("run_command", function(c)
    if ui.get(check) and should_swap then
        local _combo = ui.get(combo)
        if _combo == "Opposite" then
            ui.set(slider, -ui.get(slider))
        elseif _combo == "Random" then
            ui.set(slider, math.random(-60, 60))
        elseif _combo == "Step" then
            if autodir == true then 
                return
            elseif autodir == false then
                ui.set(slider, angles[(it%8)+1])
                if ui.get(safe1_range) <= ui.get(safe_range) then
                ui.set(fakelim, client.random_int(ui.get(safe1_range),ui.get(safe_range)))
                end
                ui.set(yawst, client.random_int(-ui.get(bodyyaw_range),ui.get(bodyyaw_range)))
                ui.set(yawjt, client.random_int(-ui.get(jitteryaw_range),ui.get(jitteryaw_range)))
                if ui.get(check4) == "Random" then
                    local randomnumber = client.random_int(1,2)
                    if randomnumber == 1 then
                        ui.set(low_ref,"Opposite")
                    elseif randomnumber == 2 then
                        ui.set(low_ref,"Eye yaw")
                    end
                elseif ui.get(check4) == "Switch" then
                    if ui.get(low_ref) == "Opposite" then
                        ui.set(low_ref,"Eye yaw")
                    else
                        ui.set(low_ref,"Opposite")
                    end
                end
            end
        end
        should_swap = false
    end
end)

client.set_event_callback("player_spawn",  function(c)
    if ui.get(check)  then
        local _combo = ui.get(combo)
        if _combo == "Opposite" then
            ui.set(slider, -ui.get(slider))
        elseif _combo == "Random" then
            ui.set(slider, math.random(-60, 60))
        elseif _combo == "Step" then
            if autodir == true then 
                return
            elseif autodir == false then
                it = it + 1
                should_swap = true
                ui.set(slider, angles[(it%8)+1])
                if ui.get(safe1_range) <= ui.get(safe_range) then
                ui.set(fakelim, client.random_int(ui.get(safe1_range),ui.get(safe_range)))
                end
                ui.set(yawst, client.random_int(-ui.get(bodyyaw_range),ui.get(bodyyaw_range)))
                ui.set(yawjt, client.random_int(-ui.get(jitteryaw_range),ui.get(jitteryaw_range)))
                if ui.get(check4) == "Random" then
                    local randomnumber = client.random_int(1,2)
                    if randomnumber == 1 then
                        ui.set(low_ref,"Opposite")
                    elseif randomnumber == 2 then
                        ui.set(low_ref,"Eye yaw")
                    end
                elseif ui.get(check4) == "Switch" then
                    if ui.get(low_ref) == "Opposite" then
                        ui.set(low_ref,"Eye yaw")
                    else
                        ui.set(low_ref,"Opposite")
                    end
                end
            end
        end
    end
end)
client.set_event_callback("setup_command", function(c)
	if c.chokedcommands == 0 then
		if c.in_use == 1 then
			angle = 0
		else
			angle = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))
		end
	end
end)



client.set_event_callback("aim_fire",function(c)
    if ui.get(check) then
        local _combo = ui.get(combo)
        if _combo == "Opposite" and  table_contains(ui.get(check2),"Flip body yaw") then
            ui.set(slider, -ui.get(slider))
        elseif _combo == "Random" and table_contains(ui.get(check2),"Flip body yaw") then
            ui.set(slider, math.random(-60, 60))
        elseif _combo == "Step" then
            if autodir == true then 
                return
            elseif autodir == false then
                if table_contains(ui.get(check2),"Flip body yaw") then
                it = it + 1
                should_swap = true
                ui.set(slider, angles[(it%8)+1])
                end
            end
        end
        if  table_contains(ui.get(check2), "Change yaw limit") then
            if ui.get(safe1_range) <= ui.get(safe_range) then
            ui.set(fakelim, client.random_int(ui.get(safe1_range),ui.get(safe_range)))
            end
            ui.set(yawst, client.random_int(-ui.get(bodyyaw_range),ui.get(bodyyaw_range)))
            ui.set(yawjt, client.random_int(-ui.get(jitteryaw_range),ui.get(jitteryaw_range)))
        end
        if table_contains(ui.get(check2),"Change lower body yaw") then
            if ui.get(low_ref) == "Opposite" then
                ui.set(low_ref,"Eye yaw")
            else
                ui.set(low_ref,"Opposite")
            end
        end
    end
end)

client.set_event_callback("paint", function(c)
    if ui.get(check) and autodir == false and entity.is_alive(entity.get_local_player()) and ui.get(aa_enabled) then
        local vx, vy = get_prop(get_local_player(), "m_vecVelocity")
        local speednum = floor(min(10000, sqrt(vx*vx + vy*vy) + 0.5))
        if ui.get(check9) and speednum > 39 then
            ui.set(yaw,"Jitter")
        elseif ui.get(check9) then
           ui.set(yaw,"Static")
        end
    end
	if  ui.get(aa_enabled) and ui.get(yaw) ~= "Off" and entity.is_alive(entity.get_local_player()) and ui.get(check) then
		local color = { 255-(angle*2.29824561404), angle*3.42105263158, angle*0.22807017543 }
		local y = renderer.indicator(255, 140, 0, 255, "Hitler's Anti-Res")+ui.get(y_slider)
		local x = ui.get(x_slider)
		renderer.circle_outline(x, y, 0, 0, 0, 155, 10, 0, 1, 6)
		renderer.circle_outline(x, y, color[1], color[2], color[3], 255, 9, 0, angle*0.01754385964, 4)
    end
    if ui_get(left_key) and ui.get(check) then
        ui_set(yawst,-70)
        ui_set(yawjt,0)
        ui_set(slider,60)
        ui_set(fakelim,60)
        ui_set(yaw_base,"local view")
        ui.set(yaw,"Static")
        autodir = true
    elseif ui_get(right_key) and ui.get(check) then
           ui_set(yawst,110)
           ui_set(yawjt,0)
           ui_set(slider,60)
           ui_set(fakelim,60)
           ui_set(yaw_base,"local view")
           ui.set(yaw,"Static")
           autodir = true
    elseif ui_get(back_key) and ui.get(check) then
           ui_set(yawst,0)
           ui_set(yawjt,0)
           ui_set(slider,47)
           ui_set(yaw_base,"at targets")
           autodir = false
    end
    if ui.get(aa_enabled) and ui.get(yaw) ~= "Off" and entity.is_alive(entity.get_local_player()) and ui_get(yawst) == -70 and ui.get(check) then 
        renderer.indicator(191, 239, 255, 255, "Hitler's LEFT")
        client.draw_text(c, center_x - 110, center_y, 238, 238, 0, 255, "c+", 0, "⮜")
    elseif ui.get(aa_enabled) and ui.get(yaw) ~= "Off" and entity.is_alive(entity.get_local_player()) and ui_get(yawst) == 110 and ui.get(check) then
        client.draw_text(c, center_x + 110, center_y, 238, 238, 0, 255, "c+", 0, "⮞")
        renderer.indicator(191, 239, 255, 255, "Hitler's RIGHT")
    end
    if ui.get(check3) and entity.is_alive(entity.get_local_player()) and ui.get(check) then
        local local_player = entity.get_local_player()
       if local_player == nil or entity.get_prop(local_player, "m_lifeState") ~= 0 then 
	    return
       end
       local velocity_x, velocity_y, velocity_z  = entity.get_prop(local_player, "m_vecVelocity")
       local onground = velocity_z == 0
        if onground == false and autodir == false then
            
            local rdmset = client.random_int(1,2)
            if rdmset == 1 then
            ui_set(slider,ui.get(airjitteryaw_range))
            else
                ui_set(slider,-ui.get(airjitteryaw_range))
            end
        end
    end
end)