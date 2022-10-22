local enable_fl = ui.reference("AA","Fake lag","Enabled")
local amount = ui.reference("AA","Fake lag","Amount")
local var = ui.reference("AA","Fake lag","Variance")
local limit = ui.reference("AA","Fake lag","Limit")
local ref_mindmg = ui.reference("RAGE", "Aimbot","Minimum Damage")
local slow,slow_key = ui.reference("AA","Other","Slow motion")
local dt,dt_key = ui.reference("Rage","Other","Double tap")
local fd = ui.reference("Misc","Movement","Infinite duck")
local fd_key = ui.reference("Rage","Other","Duck peek assist")
local cmdticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
ui.set(cmdticks,17)
local enable_coldlag = ui.new_checkbox("AA","Fake lag","Enabled Cold lag")

local extend_fixlag = ui.new_multiselect("AA","Fake lag","Extend fixed","Shot lag correction", "Double tap correction","Fake duck correction")
local dt_limit = ui.new_slider("AA","Fake lag","Double tap limit",1,15,1,true)
local extend_amount = ui.new_combobox("AA","Fake lag","Amount","Maximum","Adaptive","Random","Fluctuate","Alternative")

local normal_limit = ui.new_slider("AA","Fake lag","Normal limit",1,15,1,true)
local extend_target = ui.new_multiselect("AA","Fake lag","Target mode","Peek","Air")
local target_limit = ui.new_slider("AA","Fake lag","Target limit",1,15,1,true,"t")
ui.set_visible(target_limit,true)
local last_tick = 0
-- local
local peek_delay = 0
local random_limit = 1
local function contains(tab, val)
    for index, value in ipairs(ui.get(tab)) do
        if value == val then return true end
    end
    return false
end
local function vec_3( _x, _y, _z ) 
    return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end
local function ticks_to_time( ticks )
    return globals.tickinterval( ) * ticks
end 

local function time_to_ticks( input )
    return ( ( 0.5 + ( input ) / globals.tickinterval( ) ) )
end

local function peek( player )
    local velocity_prop_local = vec_3( entity.get_prop( entity.get_local_player( ), "m_vecVelocity" ) )
    local velocity_local = math.sqrt( velocity_prop_local.x * velocity_prop_local.x + velocity_prop_local.y * velocity_prop_local.y )
    
    local eye_position = vec_3( client.eye_position( ) )
    local predicted_eye_position = vec_3( eye_position.x + velocity_prop_local.x * ticks_to_time( ui.get(limit) ), eye_position.y + velocity_prop_local.y * ticks_to_time( ui.get(limit) ), eye_position.z + velocity_prop_local.z * ticks_to_time( ui.get(limit) ) )
    
    local velocity_prop = vec_3( entity.get_prop( player, "m_vecVelocity" ) )
    local velocity = math.sqrt( velocity_prop.x * velocity_prop.x + velocity_prop.y * velocity_prop.y )
    
    -- Predict their body position and fire an autowall trace to see if any damage can be dealt
    local body_origin = vec_3( entity.hitbox_position( player, 3 ) )
    local predicted_body_origin = vec_3( body_origin.x + velocity_prop.x * ticks_to_time( 16 ), body_origin.y + velocity_prop.y * ticks_to_time( 16 ), body_origin.z + velocity_prop.z * ticks_to_time( 16 ) ) 
    local trace_entity, damage = client.trace_bullet( entity.get_local_player( ), predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_body_origin.x, predicted_body_origin.y, predicted_body_origin.z )
            
    -- Check if damage can be dealt to their predicted body position
    if damage > 0 then
        return true
    end
    
    return false
end
local function on_paint(ctx)
	local entindex = entity.get_local_player()
	if entindex == nil then
		return
	end
	if not entity.is_alive(entindex) then
		return
	end	
	local players = entity.get_players(true)
	if players == nil then
		return
	end	
	local wx,wy = client.world_to_screen(ctx,lx2,ly2,lz2)		
	if wx == nil then 
		return
	end
	renderer.circle(wx,wy,17, 17, 17, 255, 4, 0, 1)
end
local function ui_visible()


    ui.set_visible(limit,not ui.get(enable_coldlag))
    ui.set_visible(amount,not ui.get(enable_coldlag))
    ui.set_visible(dt_limit,contains(extend_fixlag,"Double tap correction"))
    
end
local function can_shoot()
    local wpn = entity.get_player_weapon(entity.get_local_player())
    local tick_base = entity.get_prop(entity.get_local_player(), "m_nTickBase") * globals.tickinterval()
    local next_att = entity.get_prop(wpn, "m_flNextAttack")
    if next_att == nil then
        next_att = 0
    else
        next_att = entity.get_prop(wpn, "m_flNextAttack")
    end
    
    if not wpn or not tick_base then
        return false
    end
    return entity.get_prop(wpn, "m_flNextPrimaryAttack") <= tick_base and next_att <= tick_base
end
local get_flags = function(cm)
    local state = "Default"
    local me = entity.get_local_player()

    local flags = entity.get_prop(me, "m_fFlags")
    local x, y, z = entity.get_prop(me, "m_vecVelocity")
    local velocity = math.floor(math.min(10000, math.sqrt(x^2 + y^2) + 0.5))

    if bit.band(flags, 1) ~= 1 or (cm and cm.in_jump == 1) then state = "Air" else
        if velocity > 1 then
            if ui.get(slow) and ui.get(slow_key) then 
                state = "Slow motion"
            else
                state = "Running"
            end
        else 
            state = "Default"
        end
    end
    return {
        velocity = velocity,
        state = state
    }
end
client.set_event_callback("setup_command", function(cmd)

    ui_visible()
    local enable = ui.get(enable_coldlag)
    local set_amount = ui.get(extend_amount)
    local enemies = entity.get_players(true)
    local me = entity.get_local_player()
    local peek_enable = false
    for i=1, #enemies do
        local player = enemies[i]
        if peek(player) then
            peek_enable = true
        end
    end
    local target_peek = peek_enable and contains(extend_target,"Peek")
    local target_jump = cmd.in_jump and contains(extend_target,"Air")
    local fd_fix = contains(extend_fixlag,"Fake duck correction") and ui.get(fd) and ui.get(fd_key)
    local dt_fix = contains(extend_fixlag,"Double tap correction") and ui.get(dt) and ui.get(dt_key)
    local shot_fix = contains(extend_fixlag,"Shot lag correction")
    local shot = not can_shoot()
    local flags = get_flags(cmd)
    local state = flags.state
    local vel = flags.velocity
    
    if not enable then return end
    if set_amount == "Maximum" and not target_peek then
        ui.set(amount,"Maximum")
        ui.set(limit,ui.get(normal_limit))
    elseif set_amount == "Adaptive" and not target_peek then 
        if vel > 40 then
            ui.set(amount,"Maximum")
            ui.set(limit,ui.get(normal_limit))
        else
            ui.set(amount,"Dynamic")
            ui.set(limit,ui.get(normal_limit))
        end
    elseif set_amount == "Random" and not target_peek then 
        ui.set(amount,"Maximum")
        if cmd.chokedcommands >= ui.get(limit) - 1 then
            random_limit = math.random(1,ui.get(normal_limit))
        end
        ui.set(limit,random_limit)
    elseif set_amount == "Fluctuate" and not target_peek then 
        ui.set(amount,"Fluctuate")
        random_flu = math.random(1,2)
        if cmd.chokedcommands >= ui.get(limit) then
            if random_flu == 1 then
                ui.set(limit,ui.get(normal_limit))
            elseif random_flu == 2 then
                ui.set(limit,1)
            end
        end
    elseif set_amount == "Alternative" and not target_peek then 

    end
    if dt_fix then
        ui.set(limit,ui.get(dt_limit))
    end
    if fd_fix then
        ui.set(limit,14)
    end  
    if target_peek then
        ui.set(limit,ui.get(target_limit))
    end
    if target_jump then
        ui.set(limit,ui.get(target_limit))
    end

    if shot_fix and shot then
        if globals.tickcount() >= last_tick then

            cmd.allow_send_packet = cmd.chokedcommands == ui.get(limit) 

            last_tick = globals.tickcount() + 2
        end
    else
        cmd.allow_send_packet = cmd.chokedcommands == ui.get(limit)
    end    
end)

client.set_event_callback("shutdown",function()

    ui.set_visible(limit,true)
    ui.set_visible(amount,true)

end)

--[[ client.set_event_callback("paint", function()

    renderer.indicator(255,255,255,255,real_choke)
    renderer.indicator(255,255,255,255,globals.tickinterval())
    
end) ]]