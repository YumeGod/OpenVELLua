local bit = require "bit"

-- cache common functions
local renderer = renderer
local gradient, rectangle, text, measure_text = renderer.gradient, renderer.rectangle, renderer.text, renderer.measure_text
local get_screen_size, get_latency, get_system_time = client.screen_size, client.latency, client.system_time
local get_absoluteframetime, get_tickinterval, get_realtime = globals.absoluteframetime, globals.tickinterval, globals.realtime
local get_local_player, get_prop, get_name, get_all = entity.get_local_player, entity.get_prop, entity.get_player_name, entity.get_all
local min, max, abs, sqrt, floor = math.min, math.max, math.abs, math.sqrt, math.floor
local band, bnot, bor = bit.band, bit.bnot, bit.bor

local frametimes = {}
local fps_prev = 0
local value_prev = {}
local last_update_time = 0

local wdei, hdei = get_screen_size()
local scr = { w = wdei, h = hdei }
local menu_color = ui.reference("misc", "settings", "menu color")
local rm, gm, bm, am = ui.get(menu_color)

local int = {
    enabled = ui.new_checkbox("visuals", "other esp", "Watermark"),
    color = ui.new_color_picker("visuals", "other esp", "watermark_color", rm, gm, bm, am),
    options = ui.new_multiselect("visuals", "other esp", "\n", "Watermark", "Username", "Time", "FPS", "Latency", "KDR", "Velocity", "Server tickrate")
}
local widths = {
    ["Watermark"] = 65,
    ["Username"] = 10,
    ["Time"] = 40,
    ["Velocity"] = 50,
    ["KDR"] = 50,
	["FPS"] = 40,
	["Latency"] = 35,
	["Server tickrate"] = 45
}

-- round to whole number
local function tointeger(n)
	return floor(n + 0.5)
end

local function accumulate_fps() -- stolen from estk
	local rt, ft = get_realtime(), get_absoluteframetime()

	if ft > 0 then
		table.insert(frametimes, 1, ft)
	end

	local count = #frametimes
	if count == 0 then
		return 0
	end

	local accum = 0
	local i = 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end

	accum = accum / i

	while i < count do
		i = i + 1
		table.remove(frametimes)
	end

	local fps = 1 / accum
	local time_since_update = rt - last_update_time
	if abs(fps - fps_prev) > 4 or time_since_update > 1 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end

	return floor(fps + 0.5)
end

local function contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then return true end
    end
    return false
end

local function container(x, y, w, h)
    local r, g, b, a = ui.get(int.color)
    rectangle(x, y, w, h, 30, 30, 30, 200)
    rectangle(x+1, y+1, w-2, 1, r, g, b, 255)
end
local draw = { container = container }
local function round(num, numdec)
	return floor(num * (10^(numdec or 0)) + 0.5) / 10^(numdec or 0)
end

local function on_paint()
	local width, height = 3, 18
	local p_res = get_all("CCSPlayerResource")[1]
	local options = ui.get(int.options)
	local latency = min(999, get_latency() * 1000)
	local fps = accumulate_fps()
	local r, g, b, a = ui.get(int.color)
	local me = get_local_player()
	local name = get_name(me)
	local vx, vy = get_prop(me, "m_vecVelocity")
	local hours, minutes, seconds, milliseconds = get_system_time()
	local timess = "AM"
	local velocity
	local kdr
	local resources = { get_kills = get_prop(p_res, "m_iKills", me), get_deaths = get_prop(p_res, "m_iDeaths", me) }
	if string.len(name) > 20 then name = string.sub(get_name(me), 0, 21) end

	if hours > 12 then 
		hours = hours-12
		timess = "PM"
	end
	if minutes < 10 then minutes = "0" .. minutes end

	if resources.get_deaths ~= 0 then
		local temp = resources.get_kills / resources.get_deaths
		kdr = round(temp, 2)
	elseif resources.get_kills ~= 0 then
		kdr = resources.get_kills
	else kdr = 0 end
	velocity = vx and tointeger(min(10000, sqrt(vx*vx + vy*vy))) or 0

    for i=1, #options do
		local option = options[i]
        if option == "FPS" then
            widths[option] = measure_text("", fps) + measure_text("-", "  FPS") + 9
		end
		if option == "Latency" then
            widths[option] = measure_text("", tointeger(latency)) + measure_text("-", "  PING") + 9
		end
		if option == "KDR" then
            widths[option] = measure_text("", kdr) + measure_text("-", "  KDR") + 9
		end
		if option == "Velocity" then
            widths[option] = measure_text("", velocity) + measure_text("-", "  U/T") + 9
		end
		if option == "Username" then
			widths[option] = measure_text("", name) + 9
		end
		if option == "Time" then
			widths[option] = measure_text("", hours .. ":" .. minutes .. timess) + 9
		end
		if option == "Server tickrate" then
			widths[option] = measure_text("", 1 / get_tickinterval()) + measure_text("-", "  TICKS") + 9
		end
        if widths[option] ~= nil then
            width = width + widths[option]
        end
	end
	local txt = { x = scr.w-width, y = 9 }

    if ui.get(int.enabled) then
		draw.container(scr.w-width-5, 5, width, height)
		for i=1, #options do
			local option = options[i]
			if option == "FPS" then
				local fpsc = { r, g, b, a = 255 }
				if fps < (1 / get_tickinterval()) then 
					fpsc.r = 255
					fpsc.g = 50
					fpsc.b = 50
				else
					fpsc.r = r
					fpsc.g = g
					fpsc.b = b
				end
				text(txt.x, txt.y, 255, 255, 255, 255, "", 0, fps)
				text(txt.x+measure_text("", fps), txt.y+3, fpsc.r, fpsc.g, fpsc.b, fpsc.a, "-", 0, "FPS")
			elseif option == "Username" then
				text(txt.x, txt.y, 255, 255, 255, 255, "", 0, name)
			elseif option == "Watermark" then
				text(txt.x, txt.y-1, 255, 255, 255, 255, "", 0, "Naiの")
				text(txt.x+measure_text("", "Naiの"), txt.y-1, r, g, b, 255, "", 0, "config")
			elseif option == "Latency" then
				local ping = { r, g, b, a = 255 }
				if latency > 60 then 
					ping.r = 255
					ping.g = 50
					ping.b = 50
				else
					ping.r = r
					ping.g = g
					ping.b = b
				end
				text(txt.x, txt.y, 255, 255, 255, 255, "", 0, tointeger(latency))
				text(txt.x+measure_text("", tointeger(latency)), txt.y+3, ping.r, ping.g, ping.b, ping.a, "-", 0, " PING")
			elseif option == "KDR" then
				local kdrc = { r, g, b, a = 255 }
				if resources.get_kills < resources.get_deaths then
					kdrc.r = 255
					kdrc.g = 50
					kdrc.b = 50
				else
					kdrc.r = r
					kdrc.g = g
					kdrc.b = b
				end
				text(txt.x, txt.y, 255, 255, 255, 255, "", 0, kdr)
				text(txt.x+measure_text("", kdr), txt.y+3, kdrc.r, kdrc.g, kdrc.b, kdrc.a, "-", 0, " KDR")
			elseif option == "Velocity" then
				text(txt.x, txt.y, 255, 255, 255, 255, "", 0, velocity)
				text(txt.x+measure_text("", velocity), txt.y+3, r, g, b, 255, "-", 0, " U/T")
			elseif option == "Time" then
				text(txt.x, txt.y, 255, 255, 255, 255, "", 0, hours)
				text(txt.x+measure_text("", hours), txt.y, 255, 255, 255, 255, "", 0, ":")
				text(txt.x+measure_text("", hours .. ":"), txt.y, 255, 255, 255, 255, "", 0, minutes)
				text(txt.x+measure_text("", hours .. ":" .. minutes), txt.y+3, r, g, b, 255, "-", 0, timess)
			elseif option == "Server tickrate" then
				text(txt.x, txt.y, 255, 255, 255, 255, "", 0, 1 / get_tickinterval())
				text(txt.x+measure_text("", 1 / get_tickinterval()), txt.y+3, r, g, b, 255, "-", 0, " TICKS")
			end

			if widths[option] ~= nil then
                txt.x = txt.x + widths[option]
			end
			if #options > i then
                text(txt.x-10, txt.y-1, 255, 255, 255, 255, "", 0, " | ")
            end
		end
    end

    if #options == 0 then return end
end

client.set_event_callback("paint", on_paint)