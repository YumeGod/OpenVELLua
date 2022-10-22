local fakelag_ref = ui.reference("AA","Fake lag","Enabled")
local hideshot = ui.new_checkbox("AA","Fake lag","Hide Lag Shots")
local hideshot2 = ui.new_checkbox("AA","Fake lag","Adaptive Hide Lag Shots")
local dtreall = ui.new_checkbox("AA","Fake lag","Limit - Helper")
local dtreall2 = ui.new_checkbox("AA","Fake lag","Doubletap - Extra")
local Quickmxfl = ui.new_checkbox("AA","Fake lag","Quick Max Send")
local choose_ref = ui.new_combobox("AA", "Fake lag", "Fakelag Mode", { "Off", "Default HVH", "Default MMHVH","Default 60FL","Default DT","Switch HVH","Adaptive HVH","Adaptive MMHVH","Adaptive DT"})
local amount_ref = ui.reference("AA","Fake lag","Amount")
local variance_ref = ui.reference("AA","Fake lag","Variance")
local limit_ref = ui.reference("AA","Fake lag","Limit")
local refk_limit = ui.reference("aa", "Fake lag", "Limit")
local fakeduck_hotkey = ui.reference("RAGE", "Other", "Duck peek assist")
local min, abs, sqrt, floor = math.min, math.abs, math.sqrt, math.floor
local check = ui.new_combobox("AA","Fake lag","Old Fakelag",{"Off","Max send","Only choke","Custom choke","Adaptive choke"})
local get_local_player, get_prop = entity.get_local_player, entity.get_prop
local min, abs, sqrt, floor = math.min, math.abs, math.sqrt, math.floor
local speednumall = 0
local ref_dtreserve = ui.reference("RAGE", "Other", "Double tap fake lag limit")
local ref_onshotaa,ref_onshotkey = ui.reference("aa", "Other", "On shot anti-aim")
local ref_doubletap, ref_doubletapkey = ui.reference("RAGE", "Other", "Double tap")
local hold_aim = ui.new_checkbox("AA", "Other", "hold aim")
ui.set_visible(hold_aim, false)
local ui_get, ui_set, ui_ref, ui_new_checkbox, ui_new_hotkey, ui_new_combobox, ui_new_slider, ui_multiselect, ui_new_color_picker, ui_reference = ui.get, ui.set, ui.reference, ui.new_checkbox, ui.new_hotkey, ui.new_combobox, ui.new_slider, ui.new_multiselect, ui.new_color_picker, ui.reference
local ui_set_visible = ui.set_visible
local set_callback = ui.set_callback
--

--client
local client_log = client.log
local client_camera_angles = client.camera_angles
local client_trace_bullet = client.trace_bullet
local client_draw_text = client.draw_text
local client_screensize = client.screen_size
local set_event_callback = client.set_event_callback
local delay_call = client.delay_call
local client_trace_line = client.trace_line
--

--globals
local globals_curtime = globals.curtime
local globals_realtime = globals.realtime
local g_tickcount = globals.tickcount
local interval_per_tick = globals.tickinterval
--

--entity
local entity_is_alive = entity.is_alive
local get_prop = entity.get_prop
local get_local_player = entity.get_local_player
local entity_is_enemy = entity.is_enemy
local get_player_weapon = entity.get_player_weapon
local entity_get_player_weapon = entity.get_player_weapon
local entity_get_players = entity.get_players
local entity_hitbox_position = entity.hitbox_position


client.color_log(0, 255, 0, "FAKELAG-EXTRA by Hitler Q3487510691")
local test = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
ui.set_visible(test,false)
local more = ui.new_slider("AA", "Fake lag","FAKELAG MAX LOCK",1,62,17)

local weapons_ignored = {
    "CKnife",
    "CWeaponTaser",
    "CC4",
    "CHEGrenade",
    "CSmokeGrenade",
    "CMolotovGrenade",
    "CSensorGrenade",
    "CFlashbang",
    "CDecoyGrenade",
    "CIncendiaryGrenade"
}


local function on_paint()
    if ui.get(dtreall) then
        ui.set(test,ui.get(more))
    end
    if ui.get(fakelag_ref) and entity.is_alive(entity.get_local_player()) then
        local vx, vy = get_prop(get_local_player(), "m_vecVelocity")
        local speednum = floor(min(10000, sqrt(vx*vx + vy*vy) + 0.5))
        speednumall = speednum
    if ui.get(fakeduck_hotkey) == false then
        local local_player = entity.get_local_player()
       if local_player == nil or entity.get_prop(local_player, "m_lifeState") ~= 0 then 
	    return
       end
       local velocity_x, velocity_y, velocity_z  = entity.get_prop(local_player, "m_vecVelocity")
       local onground = velocity_z == 0
        if  ui.get(choose_ref) == "Off" then
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : Custom")
        elseif ui.get(choose_ref) == "Default HVH" then
            if ui.get(dtreall) then
                ui.set(more,17)
                if ui.get(dtreall2) then
                    cvar.cl_clock_correction:set_int(1)
                end
            end
            if onground == false then
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"7")
                ui.set(limit_ref,"15")
            elseif speednum > 3 then 
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"25")
                ui.set(limit_ref,"15")
            elseif speednum <= 3 then
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"20")
                ui.set(limit_ref,"10")
            end
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : DH")
        elseif ui.get(choose_ref) == "Default MMHVH" then
            if ui.get(dtreall) then
                ui.set(more,8)
                if ui.get(dtreall2) then
                    cvar.cl_clock_correction:set_int(1)
                end
            end
            if onground == false then
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"2")
                ui.set(limit_ref,"6")
            elseif speednum > 3 then
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"16")
                ui.set(limit_ref,"6")
            elseif speednum <= 3 then
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"3")
                ui.set(limit_ref,"6")
            end
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : DM")
        elseif ui.get(choose_ref) == "Default DT" then
            if ui.get(dtreall) then
                ui.set(more,18)
                if ui.get(dtreall2) then
                    cvar.cl_clock_correction:set_int(0)
                end
              end
            if onground == false then
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"7")
                ui.set(limit_ref,"15")
            elseif speednum > 3 then 
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"21")
                ui.set(limit_ref,"15")
            elseif speednum <= 3 then
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"13")
                ui.set(limit_ref,"10")
            end
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : DT")
        elseif ui.get(choose_ref) == "Default 60FL" then
            if ui.get(dtreall) then
                ui.set(more,62)
                if ui.get(dtreall2) then
                    cvar.cl_clock_correction:set_int(1)
                end
            end
            ui.set(amount_ref,"Maximum")
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : D6")
            ui.set(variance_ref,"5")
            ui.set(limit_ref,"60")
        elseif ui.get(choose_ref) == "Switch HVH" then
            if ui.get(dtreall) then
                ui.set(more,17)
                if ui.get(dtreall2) then
                    cvar.cl_clock_correction:set_int(1)
                end
            end
            if onground == false then
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"7")
                ui.set(limit_ref,"15")
            elseif speednum > 3 then
                ui.set(amount_ref,"Fluctuate")
                ui.set(variance_ref,"13")
                ui.set(limit_ref,"15")
            elseif speednum <= 3 then
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"21")
                ui.set(limit_ref,"10")
            end
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : SH")
        elseif ui.get(choose_ref) == "Adaptive HVH" then
            if ui.get(dtreall) then
                ui.set(more,17)
                if ui.get(dtreall2) then
                    cvar.cl_clock_correction:set_int(1)
                end
            end
            if onground == false then
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"7")
                ui.set(limit_ref,"15")
            elseif speednum > 3 then 
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"27")
                ui.set(limit_ref,"15")
            elseif speednum <= 3 then
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"9")
                ui.set(limit_ref,"11")
            end
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : AH")
        elseif ui.get(choose_ref) == "Adaptive MMHVH" then
            if ui.get(dtreall) then
                ui.set(more,8)
                if ui.get(dtreall2) then
                    cvar.cl_clock_correction:set_int(1)
                end
            end
            if onground == false then
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"2")
                ui.set(limit_ref,"6")
            elseif speednum > 3 then
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"16")
                ui.set(limit_ref,"6")
            elseif speednum <= 3 then
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"3")
                ui.set(limit_ref,"6")
            end
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : AM")
        elseif ui.get(choose_ref) == "Adaptive DT" then
            if ui.get(dtreall) then
                ui.set(more,18)
                if ui.get(dtreall2) then
                    cvar.cl_clock_correction:set_int(0)
                end
            end
            if onground == false then
                ui.set(amount_ref,"Maximum")
                ui.set(variance_ref,"7")
                ui.set(limit_ref,"15")
            elseif speednum > 3 then 
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"20")
                ui.set(limit_ref,"15")
            elseif speednum <= 3 then
                ui.set(amount_ref,"Dynamic")
                ui.set(variance_ref,"9")
                ui.set(limit_ref,"11")
            end
            renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : AD")
        end
    else
        if ui.get(choose_ref) ~= "Off" then
           ui.set(limit_ref,math.min(ui.get(more)-2,15))
           renderer.indicator(0, 0, 128, 255,"Hitler's FL-Mode : FD")
        end
    end
    end
end

local function oldfakelag(c)
    if speednumall >= 240 and ui.get(Quickmxfl) then
        c.allow_send_packet = c.chokedcommands >= ui.get(limit_ref)
    else
    if ui.get(check) == "Max send" then
        c.allow_send_packet = c.chokedcommands >= ui.get(limit_ref)
    elseif ui.get(check) == "Only choke" then
        c.allow_send_packet = false
    elseif ui.get(check) == "Custom choke" then
        c.allow_send_packet = c.chokedcommands >= (ui.get(limit_ref) - floor((ui.get(limit_ref)/100)*ui.get(variance_ref)))
    elseif ui.get(check) == "Adaptive choke" and speednumall >= 240 then
        c.allow_send_packet = c.chokedcommands >= (ui.get(limit_ref) - floor((ui.get(limit_ref)/100)*ui.get(variance_ref)))
    end
    end
end
client.set_event_callback("paint",on_paint)
client.set_event_callback("setup_command",oldfakelag)



local function tablecont(table, item)
    for i=1, #table do
        if table[i] == item then
            return true
        end
    end
    return false
end

local cache = { }
local data = {
    threshold = false,
    stored_last_shot = 0,
    stored_item = 0,
    onshot = 0,
}

local hotkey_modes = {
    [0] = "always on",
    [1] = "on hotkey",
    [2] = "toggle",
    [3] = "off hotkey"
}
local function is_dt()

    local dt = false

    local local_player = entity.get_local_player()

    if local_player == nil then
        return
    end

    if not entity.is_alive(local_player) then
        return
    end

    local active_weapon = entity.get_prop(local_player, "m_hActiveWeapon")

    if active_weapon == nil then
        return
    end

    nextAttack = entity.get_prop(local_player,"m_flNextAttack")
    nextShot = entity.get_prop(active_weapon,"m_flNextPrimaryAttack")
    nextShotSecondary = entity.get_prop(active_weapon,"m_flNextSecondaryAttack")

    if nextAttack == nil or nextShot == nil or nextShotSecondary == nil then
        return
    end

    nextAttack = nextAttack + 0.5
    nextShot = nextShot + 0.5
    nextShotSecondary = nextShotSecondary + 0.5

    if ui.get(ref_doubletap) and ui.get(ref_doubletapkey) then
        if math.max(nextShot,nextShotSecondary) < nextAttack then -- swapping
            if nextAttack - globals.curtime() > 0.00 then
                dt = false --client.draw_indicator(ctx, 255, 0, 0, 255, "DT")
            else
                dt = true --client.draw_indicator(ctx, 0, 255, 0, 255, "DT")
            end
        else -- shooting or just shot
            if math.max(nextShot,nextShotSecondary) - globals.curtime() > 0.00  then
                dt = false --client.draw_indicator(ctx, 255, 0, 0, 255, "DT")
            else
                if math.max(nextShot,nextShotSecondary) - globals.curtime() < 0.00  then
                    dt = true --client.draw_indicator(ctx, 0, 255, 0, 255, "DT")
                else
                    dt = true --client.draw_indicator(ctx, 0, 255, 0, 255, "DT")
                end
            end
        end
    end

    return dt
end
local set_cache = function(self)
    if not ui.get(fakelag_ref) then return end

    local process = function(name, condition, should_call, VAR)
    
        local _cond = ui.get(condition)
        local _type = type(_cond)
    
        local value, mode = ui.get(condition)
        local finder = mode ~= nil and mode or (_type == "boolean" and tostring(_cond) or _cond)
        cache[name] = cache[name] ~= nil and cache[name] or finder
    
        if should_call then ui.set(condition, mode ~= nil and hotkey_modes[VAR] or VAR) else
            if cache[name] ~= nil then
                local _cache = cache[name]
                
                if _type == "boolean" then
                    if _cache == "true" then _cache = true end
                    if _cache == "false" then _cache = false end
                end
    
                ui.set(condition, mode ~= nil and hotkey_modes[_cache] or _cache)
                cache[name] = nil
            end
        end
    end

    process("refk_limit", refk_limit, (self == nil and false or self), 1)
end
client.set_event_callback("shutdown", set_cache)

client.set_event_callback("setup_command", function(cmd)
    if not ui.get(fakelag_ref) then return end
    if not ui.get(ref_onshotaa) then return end
    local me = get_local_player()
    local weapon = entity_get_player_weapon(me)
    local get_classname = entity.get_classname
    local duck_amount = get_prop(me, "m_flDuckAmount")
    local suprass_duck = duck_amount <= 0.78
    if weapon == nil or tablecont(weapons_ignored, get_classname(weapon)) then
        return
    end      

    local last_shot_time = get_prop(weapon, "m_fLastShotTime")
    local m_iItem = bit.band(get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)

    local limitation = function(cmd)
        --local choke11 = cmd.chokedcommands
        local doubletapping = is_dt()--ui.get(ref_doubletap) and ui.get(ref_doubletapkey) and (choke11 < ui.get(ref_dtreserve))
	    local onshotaa = ui.get(ref_onshotaa) and ui.get(ref_onshotkey) and not doubletapping
        local exploiting = doubletapping or onshotaa
        local passhide = (ui.get(hideshot2) and speednumall < 3) or ui.get(hideshot)
        if exploiting or not passhide then ui.set(hold_aim, true) return end
        ui.set(hold_aim, true)
        if ui.get(fakeduck_hotkey) then return false end 

        local in_accel = function()
            local x, y = get_prop(me, "m_vecVelocity")
        
            return math.sqrt(x^2 + y^2) ~= 0
        end

        local max_commands = in_accel() and 1 or 2

        if not data.threshold and last_shot_time ~= data.stored_last_shot then
            data.onshot = g_tickcount() + 3 
            if data.onshot > g_tickcount() then
                data.stored_last_shot = last_shot_time
                data.threshold = true
            end
            return true
        end

        if data.threshold and cmd.chokedcommands >= max_commands then
            data.threshold = false
            return true
        end   
        return false   
    end
    
    if data.stored_item ~= m_iItem then
        data.stored_last_shot = last_shot_time
        data.stored_item = m_iItem
    end
    set_cache(limitation(cmd))
end)