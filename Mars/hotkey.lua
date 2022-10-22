local ui_get, ui_set = ui.get, ui.set
local ui_is_menu_open = ui.is_menu_open
local globals_frametime = globals.frametime
local renderer_rectangle = renderer.rectangle
local measure_text = renderer.measure_text
local renderer_text = renderer.text

local dragging = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui.new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()

local GLOBAL_ALPHA = 0
local m_active, references = { }, { }
local hotkey_modes = { 'holding', 'toggled', 'disabled' }

local hotkeys_dragging = dragging.new('Keybinds', 100, 200)
local active = ui.new_checkbox('CONFIG', 'Presets', 'Hotkey list')
local color_picker = ui.new_color_picker('CONFIG', 'Presets', 'Hotkey list color picker', 89, 119, 239, 165)

local function item_count(tab)
    if tab == nil then return 0 end
    if #tab == 0 then
        local val = 0
        for k in pairs(tab) do
            val = val + 1
        end

        return val
    end

    return #tab
end

local function create_item(tab, container, name, arg, cname)
    local collected = { }
    local reference = { ui.reference(tab, container, name) }

    for i=1, #reference do
        if i <= arg then
            collected[i] = reference[i]
        end
    end

    references[cname or name] = collected
end

local create_custom_item = function(req, ref)
    local reference_if_exists = function(...)
        if pcall(ui.reference, ...) then
             return true
        end
    end

    local get_script_name = function()
        local funca, err = pcall(function() GS_THROW_ERROR() end)
        return (not funca and err:match("\\(.*):(.*):") or nil)
    end

    if not reference_if_exists(ref[1], ref[2], ref[3]) then
        if pcall(require, req) and reference_if_exists(ref[1], ref[2], ref[3]) then
            create_item(unpack(ref))
        else
            client.log(string.format('%s: Unable to reference - %s (%s.lua/ljbc)', get_script_name(), ref[3], req))
        end
    else
        create_item(unpack(ref))
    end
end

local g_paint_handler = function()
    local master_switch = ui_get(active)
    local is_menu_open = ui_is_menu_open()
    local frames = 8 * globals_frametime()

    local latest_item = false
    local maximum_offset = 0

    for c_name, c_ref in pairs(references) do
        local item_active = true

        local items = item_count(c_ref)
        local state = { ui_get(c_ref[items]) }

        if items > 1 then
            item_active = ui_get(c_ref[1])
        end

        if item_active and state[2] ~= 0 and (state[2] == 3 and not state[1] or state[2] ~= 3 and state[1]) then
            latest_item = true

            if m_active[c_name] == nil then
                m_active[c_name] = {
                    mode = '', alpha = 0, offset = 0, active = true
                }
            end

            local text_width = measure_text(nil, c_name)

            m_active[c_name].active = true
            m_active[c_name].offset = text_width
            m_active[c_name].mode = hotkey_modes[state[2]]
            m_active[c_name].alpha = m_active[c_name].alpha + frames

            if m_active[c_name].alpha > 1 then
                m_active[c_name].alpha = 1
            end
        elseif m_active[c_name] ~= nil then
            m_active[c_name].active = false
            m_active[c_name].alpha = m_active[c_name].alpha - frames

            if m_active[c_name].alpha <= 0 then
                m_active[c_name] = nil
            end
        end

        if m_active[c_name] ~= nil and m_active[c_name].offset > maximum_offset then
            maximum_offset = m_active[c_name].offset
        end
    end

    if is_menu_open and not latest_item then
        local case_name = 'Menu toggled'
        local text_width = measure_text(nil, case_name)

        latest_item = true
        maximum_offset = maximum_offset < text_width and text_width or maximum_offset

        m_active[case_name] = {
            active = true,
            offset = text_width,
            mode = '~',
            alpha = 1,
        }
    end

    local text = 'keybinds'
    local x, y = hotkeys_dragging:get()
    local r, g, b, a = ui_get(color_picker)

    local height_offset = 23
    local w, h = 75 + maximum_offset, 50

    renderer_rectangle(x, y, w, 2, r, g, b, GLOBAL_ALPHA*255)
    renderer_rectangle(x, y + 2, w, 18, 17, 17, 17, GLOBAL_ALPHA*a)

    renderer_text(x - measure_text(nil, text) / 2 + w/2, y + 4, 255, 255, 255, GLOBAL_ALPHA*255, '', 0, text)

    for c_name, c_ref in pairs(m_active) do
        local key_type = '[' .. c_ref.mode .. ']'

        renderer_text(x + 5, y + height_offset, 255, 255, 255, GLOBAL_ALPHA*c_ref.alpha*255, '', 0, c_name)
        renderer_text(x + w - measure_text(nil, key_type) - 5, y + height_offset, 255, 255, 255, GLOBAL_ALPHA*c_ref.alpha*255, '', 0, key_type)

        height_offset = height_offset + 15
    end

    hotkeys_dragging:drag(w, (3 + (15 * item_count(m_active))) * 2)

    if master_switch and item_count(m_active) > 0 and latest_item then
        GLOBAL_ALPHA = GLOBAL_ALPHA + frames; if GLOBAL_ALPHA > 1 then GLOBAL_ALPHA = 1 end
    else
        GLOBAL_ALPHA = GLOBAL_ALPHA - frames; if GLOBAL_ALPHA < 0 then GLOBAL_ALPHA = 0 end 
    end

    if is_menu_open then
        m_active['Menu toggled'] = nil
    end
end

-- Callbacks
client.set_event_callback('paint', g_paint_handler)

-- Creating menu items
create_item('LEGIT', 'Aimbot', 'Enabled', 2, 'Legit aimbot')
create_item('LEGIT', 'Triggerbot', 'Enabled', 2, 'Legit triggerbot')

create_item('RAGE', 'Aimbot', 'Enabled', 2, 'Rage aimbot')
create_item('RAGE', 'Aimbot', 'Force safe point', 1, 'Safe point')

create_item('RAGE', 'Other', 'Quick stop', 2)
create_item('RAGE', 'Other', 'Quick peek assist', 2)
create_item('RAGE', 'Other', 'Force body aim', 1)
create_item('RAGE', 'Other', 'Duck peek assist', 1)
create_item('RAGE', 'Other', 'Double tap', 2)

create_item('RAGE', 'Other', 'Anti-aim correction override', 1, 'Resolver override')
create_item('AA', 'Anti-aimbot angles', 'Freestanding', 2)
create_item('AA', 'Other', 'Slow motion', 2)
create_item('AA', 'Other', 'On shot anti-aim', 2)
create_item('AA', 'Other', 'Fake peek', 2)

create_item('MISC', 'Movement', 'Z-Hop', 2)
create_item('MISC', 'Movement', 'Pre-speed', 2)
create_item('MISC', 'Movement', 'Blockbot', 2)
create_item('MISC', 'Movement', 'Jump at edge', 2)

create_item('MISC', 'Miscellaneous', 'Last second defuse', 1)
create_item('MISC', 'Miscellaneous', 'Free look', 1)

create_item('MISC', 'Miscellaneous', 'Ping spike', 2)
create_item('MISC', 'Miscellaneous', 'Automatic grenade release', 2, 'Grenade release')
create_item('VISUALS', 'Player ESP', 'Activation type', 1, 'Visuals')
local active = ui.new_checkbox('CONFIG', 'Presets', 'Watermark')
local color_picker = ui.new_color_picker('CONFIG', 'Presets', 'Watermark color picker', 89, 119, 239, 255)

local nickname = 'Small8'
local ctag = 'Skeet.cc'

-- Things
local ffi = require 'ffi'
local interface_ptr = ffi.typeof('void***')
local latency_ptr = ffi.typeof('float(__thiscall*)(void*, int)')

local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
local ivengineclient = ffi.cast(interface_ptr, rawivengineclient) or error('rawivengineclient is nil', 2)

local get_net_channel_info = ffi.cast('void*(__thiscall*)(void*)', ivengineclient[0][78]) or error('ivengineclient is nil')
local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')

local notes = (function(b)local c=function(d,e)local f={}for g in pairs(d)do table.insert(f,g)end;table.sort(f,e)local h=0;local i=function()h=h+1;if f[h]==nil then return nil else return f[h],d[f[h]]end end;return i end;local j={get=function(k)local l,m=0,{}for n,o in c(package.cnotes)do if o==true then l=l+1;m[#m+1]={n,l}end end;for p=1,#m do if m[p][1]==b then return k(m[p][2]-1)end end end,set_state=function(q)package.cnotes[b]=q;table.sort(package.cnotes)end,unset=function()client.unset_event_callback('shutdown',callback)end}client.set_event_callback('shutdown',function()if package.cnotes[b]~=nil then package.cnotes[b]=nil end end)if package.cnotes==nil then package.cnotes={}end;return j end)('a_watermark')

-- Local vars
local ui_get = ui.get
local string_format = string.format
local client_screen_size = client.screen_size
local client_system_time = client.system_time
local globals_tickinterval = globals.tickinterval
local renderer_measure_text = renderer.measure_text
local renderer_rectangle = renderer.rectangle
local renderer_text = renderer.text

local paint_handler = function()
    notes.set_state(ui_get(active))
    notes.get(function(id)
        local sys_time = { client_system_time() }
        local actual_time = string_format('%02d:%02d:%02d', sys_time[1], sys_time[2], sys_time[3])

        local text = string_format('%s | %s | %s', ctag, nickname, actual_time)

        if is_in_game(is_in_game) == true then
            local INetChannelInfo = ffi.cast(interface_ptr, get_net_channel_info(ivengineclient)) or error('netchaninfo is nil')
            local get_avg_latency = ffi.cast(latency_ptr, INetChannelInfo[0][10])
            local latency = get_avg_latency(INetChannelInfo, 0) * 1000
            local tick = 1/globals_tickinterval()

            text = string_format('%s | %s | delay: %dms | %dtick | %s', ctag, nickname, latency, tick, actual_time)
        end

        local r, g, b, a = ui_get(color_picker)
        local h, w = 18, renderer_measure_text(nil, text) + 8
        local x, y = client_screen_size(), 10 + (25*id)

        x = x - w - 10

        renderer_rectangle(x, y, w, 2, r, g, b, 255)
        renderer_rectangle(x, y + 2, w, h, 17, 17, 17, a)
        renderer_text(x+4, y + 4, 255, 255, 255, 255, '', 0, text)
    end)
end

client.set_event_callback('paint_ui', paint_handler)