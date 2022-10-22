local GetUi = ui.get
local SetUi = ui.set
local NewSlider = ui.new_slider
local NewKey = ui.new_hotkey
local NewRef = ui.reference
local SetVisible = ui.set_visible
local AddEvent = client.set_event_callback
local math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad 
local client_draw_hitboxes, client_get_cvar, client_draw_line, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.draw_hitboxes, client.get_cvar, client.draw_line, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local client_latency, client_set_clan_tag, client_draw_indicator, client_log, client_draw_rectangle, client_world_to_screen, client_draw_circle_outline, client_timestamp, client_draw_circle = client.latency, client.set_clan_tag, client.draw_indicator, client.log, client.draw_rectangle, client.world_to_screen, client.draw_circle_outline, client.timestamp, client.draw_circle
local GetLocalPlayer = entity.get_local_player
local GetAll = entity.get_all
local GetProp = entity.get_prop
local pingspike_cb, _, pingspike_slider = NewRef("misc", "miscellaneous", "ping spike")
local new_pingspike_value = NewSlider("misc", "miscellaneous", "Value of Pingspike", 1, 200, 200)
local old_value = GetUi(pingspike_slider)
local diff_old = nil
local i

local should_change = 0
local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	if num >= 0 then return math.floor(num * mult + 0.5) / mult
	else return math.ceil(num * mult - 0.5) / mult end
end

AddEvent("run_command", function()

 local player_resource = GetAll("CCSPlayerResource")[1]
   if player_resource == nil then return end
   local ping = GetProp(player_resource, "m_iPing", GetLocalPlayer())
	
    if ping == nil then return end
	if ping > 0 then
		local slider = GetUi(new_pingspike_value)
		local diff = math_abs(slider - ping)
		if diff>=200 then
			diff = 200
		end
		if diff<=0 then
			diff = 1
		end
        SetUi(pingspike_slider, diff)
	end    
end)

-- credits to chay --

local time_start = globals.realtime()

local function rgb_percents(percentage)
    local r = 124 * 2 - 165 * percentage
    local g = 260 * percentage
    local b = 13
    return r, g, b
end

AddEvent("paint", function(ctx)

    if GetLocalPlayer() == nil then return end
    
    if diff_old == nil then
        diff_old = 0
    end
    
    local player_resource = GetAll("CCSPlayerResource")[1]
    if player_resource == nil then return end
    local ping = GetProp(player_resource, "m_iPing", GetLocalPlayer())
    if ping == nil then return end
    local maxping = GetUi(new_pingspike_value)
    if maxping == nil then return end
    local diff = math.floor(ping / maxping * 100)
    if diff == nil then return end
    
    if diff_old ~= diff and globals.realtime() - time_start > 0.03 then
        time_start = globals.realtime()
        if diff_old > diff then i = -1 else i = 1 end
        diff_old = diff_old + i
    end

    local r, g, b = rgb_percents(diff_old / 100)
    
    if diff < 75 and diff > 0 then
        r, g, b = rgb_percents(diff_old / 100)
    elseif diff >= 75 then
        r, g, b = 124, 195, 13
    elseif diff < 0 then
        r, g, b = 237, 27, 3
    end
    
    client.draw_indicator(ctx, r, g, b, 255, "EXT " .. ping)
end)