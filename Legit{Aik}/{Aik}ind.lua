--DRAGGABLE
local _draggable = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider("LUA","A",u.." window position",0,x,v/j*x)local z=ui.new_slider("LUA","A","\n"..u.." window position y",0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()

--SCRIPT
local script = {
    _debug = false,

    menu = { "config", "Presets" },

    indicator_options = { "Fake lag", "Desync", "Accuracy", "Speed", "Head height", "Ping spike", "Damage" },
    exceptions = { "knife", "hegrenade", "inferno", "flashbang", "decoy", "smokegrenade" }
}

function script:call(func, name, ...)
    if func == nil then
        return
    end

    local end_name = name[2] or ""

    if name[1] ~= nil then
        end_name = end_name ~= "" and (string.format("%s ", end_name)) or end_name
        end_name = string.format("%s\n%s", end_name, name[1])
    end

    return func(self.menu[1], self.menu[2], end_name, ...)
end

--CONTROLS
local enabled = script:call(ui.new_checkbox, { "enabled" , "Enable custom indicators" })
local clr_bg = script:call(ui.new_color_picker, { "clr_bg", "bg_color" }, 10, 10, 10, 248)

local lbl_clr1 = script:call(ui.new_label, { "lbl_clr1", "Box primary color" })
local clr1 = script:call(ui.new_color_picker, { "clr1", "clr1" }, 215, 48, 48, 220)

local lbl_ac1 = script:call(ui.new_label, { "lbl_ac1", "Indicator bar accent" })
local ac1 = script:call(ui.new_color_picker, { "ac1", "ac1" }, 217, 161, 161, 2)

local lbl_ac2 = script:call(ui.new_label, { "lbl_ac2", "Secondary indicator accent" })
local ac2 = script:call(ui.new_color_picker, { "ac2", "ac2" }, 215, 48, 48, 220)

local ind_enabled = script:call(ui.new_checkbox, { "ind_enabled" , "Display custom indicators" })
local ind_options = script:call(ui.new_multiselect, { "ind_options" , "Indicator options" }, script.indicator_options)
local ind_remove = script:call(ui.new_checkbox, { "ind_remove" , "Remove default indicators" })

local key_enabled = script:call(ui.new_checkbox, { "key_enabled" , "Display key status" })

--REFERENCE
local force_safe = ui.reference("rage", "Aimbot", "Force safe point")
local minimum_damage = ui.reference("rage", "Aimbot", "Minimum damage")
local quick_peek = { ui.reference("rage", "Other", "Quick peek assist") }
local resolver_or = ui.reference("rage", "Other", "Anti-aim correction override")
local force_baim = ui.reference("rage", "Other", "Force body aim")
local duck_peek = ui.reference("rage", "Other", "Duck peek assist")
local doubletap = { ui.reference("rage", "Other", "Double tap") }
local doubletap_mode = ui.reference("rage", "Other", "Double tap mode")

local onshot = { ui.reference("aa", "Other", "On shot anti-aim") }
local slowmotion = { ui.reference("aa", "Other", "Slow motion") }
local freestanding = { ui.reference("aa", "Anti-aimbot angles", "Freestanding") }

local ping_spike = { ui.reference("misc", "Miscellaneous", "Ping spike") }
local edge_jump = { ui.reference("misc", "Movement", "Jump at edge") }

local maxprocessticks = ui.reference("misc", "Settings", "sv_maxusrcmdprocessticks")

--VARS
local size = {
    x = 310,
    y = 100 }
local shots = {
    hit = 0,
    miss = 0 }
local choked = 0
local region = _draggable.new("Indicators", 310, 100)
local c_font = renderer.create_font("Small Fonts", 11, 400, {0x010, 0x200})

--#region HELPERS

local multi_exec = function(func, list)
    if func == nil then
        return false                            
    end
    
    for ref, val in pairs(list) do
        func(ref, val)
    end
end

local contains = function(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    
    return false
end

local vec_3 = function(_x, _y, _z) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end

local get_tbl_count = function(tbl)
    local count = 0

    for _ in pairs(tbl) do
        count = count + 1 
    end

    return count
end

--#endregion

--#region EVENTS
local on_player_hurt = function(e)
    local victim = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)
    local me = entity.get_local_player()

    if (entity.is_enemy(victim) and attacker == me) then
        for i = 1, #script.exceptions do
            if e.weapon == script.exceptions[i] then
                return
            end
        end

        shots.hit = shots.hit + 1
    end
end

local on_aim_miss = function(e)
    shots.miss = shots.miss + 1
end

local on_player_connect_full = function(e)
    if (client.userid_to_entindex(e.userid) ~= entity.get_local_player()) then
        return
    end

    shots.miss, shots.hit = 0, 0
end

local on_setup_command = function(c)
    choked = c.chokedcommands
end

local remove_indicators = function()
    for i = 0, 50 do
        renderer.indicator(0, 0, 0, 0, "...")
    end
end

local on_paint = function()
    local me = entity.get_local_player()

    if ui.get(ind_remove) then
        remove_indicators()
    end

    local x, y = region:get()
    local bgr, bgg, bgb, bga = ui.get(clr_bg)
    local mr, mg, mb, ma = ui.get(clr1)
    local a1r, a1g, a1b, a1a = ui.get(ac1)
    local a2r, a2g, a2b, a2a = ui.get(ac2)

    local sliders = { }
    local key_states = { }

    if ui.get(ind_enabled) then
        if (contains(ui.get(ind_options), "Fake lag")) then
            sliders[#sliders + 1] = {
                fill = math.min(choked / (ui.get(maxprocessticks) -2)),
                lbl = "chk: ",
                val = tostring(choked)
            }
        end

        if (contains(ui.get(ind_options), "Desync")) then
            local _bodyyaw = entity.get_prop(me, "m_flPoseParameter", 11) * 116 - 58
            sliders[#sliders + 1] = {
                fill = math.abs(_bodyyaw) / 58,
                lbl = "dsy: ",
                val = tostring(math.floor(_bodyyaw))
            }
        end

        if (contains(ui.get(ind_options), "Accuracy")) then
            local acc = shots.hit / (shots.miss + shots.hit)

            if (acc ~= acc) then
                acc = 1
            end
            
            sliders[#sliders + 1] = {
                fill = acc,
                lbl = "hit: ",
                val = tostring(math.floor(acc * 100)) .. "%"
            }
        end

        if (contains(ui.get(ind_options), "Speed")) then
            local vel = vec_3(entity.get_prop(me, "m_vecVelocity"))
            local speed = math.sqrt(vel.x^2 + vel.y^2)

            sliders[#sliders + 1] = {
                fill = math.min(1, speed / 300),
                lbl = "spd: ",
                val = tostring(math.floor(speed))
            }
        end

        if (contains(ui.get(ind_options), "Head height")) then
            local duck_amount = entity.get_prop(me, "m_flDuckAmount")

            if duck_amount == 0 then
                duck_amount = 1
            elseif duck_amount == 1 then
                duck_amount = 0
            end

            sliders[#sliders + 1] = {
                fill = duck_amount,
                lbl = "hgt: ",
                val = ""
            }
        end

        if (contains(ui.get(ind_options), "Ping spike")) then
            local ping_extra = tonumber(entity.get_prop(entity.get_player_resource(), "m_iPing", me) or 0)-client.latency()*1000-5
            local ping = math.min(1, math.max(0, ping_extra / ui.get(ping_spike[3])))
            
            sliders[#sliders + 1] = {
                fill = ping,
                lbl = "ping: ",
                val = tostring(ping_extra)
            }
        end

        if (contains(ui.get(ind_options), "Damage")) then
            local dmg = math.min(ui.get(minimum_damage) / 100, 1)

            if (dmg ~= dmg) then
                dmg = 1
            end
            
            sliders[#sliders + 1] = {
                fill = dmg,
                lbl = "dmg: ",
                val = tostring(ui.get(minimum_damage))
            }
        end

        local lbl_sz = 22

        renderer.draw_filled_rect(x, y , size.x / 2 - 1, 20 + (get_tbl_count(sliders) * 14), bgr, bgg, bgb, bga)
        renderer.draw_filled_rect(x, y + 16, size.x / 2 - 1, 1, mr, mg, mb, ma)
        renderer.draw_text(x + 4, y + 3, 255, 255, 255, 255, c_font, "indicators")

        for i = 1, #sliders do 
            local val_sz = renderer.get_text_size(c_font, sliders[i].val)

            renderer.draw_text(x + 4, y + (i * 14) + 5, 255, 255, 255, 255, c_font, sliders[i].lbl)
            renderer.draw_filled_rect(x + lbl_sz + 4, y + (i * 14) + 8, (size.x / 2 - 5) - (11 + lbl_sz), 6, a1r, a1g, a1b, a1a)
            renderer.draw_filled_gradient_rect(x + lbl_sz + 5, y + (i * 14) + 9, ((size.x / 2 - 1) - (12 + lbl_sz)) * sliders[i].fill, 4, a1r, a1g, a1b, a1a, a2r, a2g, a2b, a2a, true)
            renderer.draw_text(x + ((size.x / 2 - 1) - val_sz - 10), y + (i * 14) + 5, 255, 255, 255, 255, c_font, sliders[i].val)
        end
    end

    if ui.get(key_enabled) then
        if ui.get(onshot[1]) and ui.get(onshot[2]) then
            key_states[#key_states + 1] = "hide shots"
        end

        if ui.get(doubletap[1]) and ui.get(doubletap[2]) then
            key_states[#key_states + 1] = "double tap"
        end

        if ui.get(freestanding[1]) and ui.get(freestanding[2]) then
            key_states[#key_states + 1] = "freestanding"
        end

        if ui.get(force_baim) then
            key_states[#key_states + 1] = "force baim"
        end

        if ui.get(force_safe) then
            key_states[#key_states + 1] = "force safety"
        end

        if ui.get(duck_peek) then
            key_states[#key_states + 1] = "fake duck"
        end
        
        renderer.draw_filled_rect(x + (size.x / 2 + 1 ), y, (size.x / 2 - 55), 20 + (get_tbl_count(key_states) * 14), bgr, bgg, bgb, bga)
        renderer.draw_filled_rect(x + (size.x / 2 + 1 ), y + 16, (size.x / 2 - 55), 1, mr, mg, mb, ma)
        renderer.draw_text(x + (size.x / 2 + 1 ) + 4, y + 3, 255, 255, 255, 255, c_font, "key states")
    
        for i = 1, #key_states do
            renderer.draw_text(x + (size.x / 2 + 1) + 4, y + (i * 14) + 5, 255, 255, 255, 255, c_font, key_states[i])
        end
    end

    region:drag(size.x, 20 + (get_tbl_count(sliders) * 14))
end

--#endregion

--#region VISIBILITY
local update_visibility = function()
    local script_state = ui.get(enabled)
    local ind_state = ui.get(ind_enabled)

    multi_exec(ui.set_visible, {
        [clr_bg] = script_state,

        [lbl_clr1] = script_state,
        [clr1] = script_state,
        [lbl_ac1] = script_state,
        [ac1] = script_state,
        [lbl_ac2] = script_state,
        [ac2] = script_state,

        [ind_enabled] = script_state,
        [ind_options] = script_state and ind_state,
        [ind_remove] = script_state and ind_state,

        [key_enabled] = script_state
    })
end
--#endregion

--INITIALIZATION
local script_toggled = function()
    local state = ui.get(enabled)

    update_visibility()

    local update_callback = state and client.set_event_callback or client.unset_event_callback
    
    update_callback("player_hurt", on_player_hurt)
    update_callback("aim_miss", on_aim_miss)
    update_callback("player_connect_full", on_player_connect_full)
    update_callback("setup_command", on_setup_command)
    update_callback("paint", on_paint)
end

script_toggled()
ui.set_callback(enabled, script_toggled)
ui.set_callback(ind_enabled, script_toggled)