local options = { "Text", "Username", "Time", "Velocity", "KDR", "FPS", "Ping" }
local styles = { "Gamesense", "Custom", "Dump", "Dump 2", "Trash" }
local w, h = client.screen_size()
local frametimes = {}
local fps_prev = 0
local value_prev = {}
local last_update_time = 0
local gui = {
    enable = ui.new_checkbox("lua", "a", "Watermark"),
    accent = ui.new_color_picker("lua", "a", "accent", 127, 176, 0, 255),
    style = ui.new_combobox("lua", "a", "\n", styles),
    option = ui.new_multiselect("lua", "a", "\n\n", options),
    header = ui.new_checkbox("lua", "a", "Header")
}
local draw = {
    box = renderer.rectangle,
    line = renderer.line,
    text = renderer.text,
    measure_text = renderer.measure_text,
    gradient = renderer.gradient
}
local wnd = {
    x = database.read("ks_x") or w - 10,
    y = database.read("ks_y") or 10,
    dragging = false
}
local widths = {
    ["Text"] = 65,
    ["Username"] = 10,
    ["Time"] = 40,
    ["Velocity"] = 50,
    ["KDR"] = 50,
	["FPS"] = 40,
	["Ping"] = 40,
}

local function intersect(x, y, w, h, debug) 
    local cx, cy = ui.mouse_position()
    debug = debug or false
    if debug then 
        renderer.rectangle(x, y, w, h, 255, 0, 0, 50)
    end
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function contains(table, val) --thanks sapphyrus
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

local function accumulate_fps()
	local rt, ft = globals.realtime(), globals.absoluteframetime()

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
	if math.abs(fps - fps_prev) > 4 or time_since_update > 1 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end

	return math.floor(fps + 0.5)
end

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function container_gs(x, y, w, h, header) --gamesense container
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0,6,1 do
        draw.box(x+i, y+i, w-(i*2), 29-(i*2), c[i+1], c[i+1], c[i+1], 255)
    end

    if header == true then
        draw.gradient(x + 7, y + 7, w/2, 1, 59, 175, 222, 255, 202, 70, 205, 255, true)
        draw.gradient(x + w/2, y + 7, w/2 - 7, 1, 202, 70, 205, 255, 201, 227, 58, 255, true)
    end
end

local function container_custom(x, y, w, h, header) --custom container
    draw.box(x, y, w, h, 46, 43, 50, 200)

    if header == true then
        draw.gradient(x + 2, y + 2, w/2, 1, 59, 175, 222, 255, 202, 70, 205, 255, true)
        draw.gradient(x + (w/2) - 1, y + 2, (w/2) - 2, 1, 202, 70, 205, 255, 201, 227, 58, 255, true)
    end
end

local function container_dump(x, y, w, h)
    draw.box(x, y, w, h, 207, 106, 128, 110)
end

local function container_oc(x, y, w, h, header) --oneclap (dump2) container
    local r, g, b, a = ui.get(gui.accent)
    draw.box(x, y, w, h, 56, 53, 60, 255)

    if header == true then
        draw.box(x, y, w, 3, r, g, b, a)
    end
end

local function container_weirddump(x, y, w, h, header) --xDDDDD container
    local r, g, b, a = ui.get(gui.accent)
    draw.box(x, y, w, h, 100, 100, 100, 150)
    draw.line(x - 1, y - 1, (w+x), y - 1, 0, 0, 0, 255)
    draw.line(x - 1, (h+y), (w+x), (h+y), 0, 0, 0, 255)
    draw.line(x - 1, y - 1, x - 1, (h+y), 0, 0, 0, 255)
    draw.line((w+x), y - 1, (w+x), (h+y), 0, 0, 0, 255)

    if header == true then
        draw.box(x + 1, y + 1, w - 2, 1, r, g, b, a)
    end
end

local function menu_things()
    local enable_check = ui.get(gui.enable)
    ui.set_visible(gui.style, enable_check)
    ui.set_visible(gui.option, enable_check)
    ui.set_visible(gui.header, enable_check)
end

ui.set_callback(gui.enable, menu_things)
menu_things()

client.set_event_callback("paint", function()
    local lp = entity.get_local_player()
    local lp_name = entity.get_player_name(lp)
    local p_res = entity.get_all("CCSPlayerResource")[1]
    local cx, cy = ui.mouse_position()
    local header_c = ui.get(gui.header)
    local opts = ui.get(gui.option)
    local style = ui.get(gui.style)
    local ping = math.min(999, client.latency() * 1000)
    local fps = accumulate_fps()
    local hours, minutes, seconds, milliseconds = client.system_time()
    hours, minutes = string.format("%02d", hours), string.format("%02d", minutes)
    local width = 13

    if #opts == 0 then
		return
	end

    for i=1, #opts do
        local opts_temp = opts[i]
        if opts_temp == "Username" then
			widths[opts_temp] = draw.measure_text(nil, entity.get_player_name(lp)) + 7
        end
        if opts_temp == "FPS" then
            widths[opts_temp] = draw.measure_text(nil, fps) + 25
        end
        if opts_temp == "Ping" then
            widths[opts_temp] = draw.measure_text(nil, round(ping, 0)) + 22
        end
		if widths[opts_temp] ~= nil then
			width = width + widths[opts_temp]
		end
	end
    if not ui.get(gui.enable) then return end

    if ui.is_menu_open() then 
        
        if wnd.dragging and not client.key_state(0x01) then
            wnd.dragging = false
        end
    
        if wnd.dragging and client.key_state(0x01) then
            wnd.x = cx - wnd.drag_x
            wnd.y = cy - wnd.drag_y
        end
    
        if intersect(wnd.x - width, wnd.y, width, 20) and client.key_state(0x01) then 
            wnd.dragging = true
            wnd.drag_x = cx - wnd.x
            wnd.drag_y = cy - wnd.y
        end

    end

    if style == "Gamesense" then
        local r, g, b, a = ui.get(gui.accent)
        local text = { x = wnd.x - width, y = wnd.y + 8 }

        if ui.get(gui.header) then
            container_gs(wnd.x - width, wnd.y, width, 22, true)
            text.y = text.y + 1
        else
            container_gs(wnd.x - width, wnd.y, width, 20, false)
        end

        if a < 30 then a = 30 end

        for i=1, #opts do

            local opts_temp = opts[i]
            if opts_temp == "Text" then
                draw.text(text.x + 10, text.y, 255, 255, 255, a, "", 0, "game")
                draw.text(text.x + draw.measure_text("", "game") + 10, text.y, r, g, b, a, "", 0, "sense")
            elseif opts_temp == "Username" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, entity.get_player_name(lp))
            elseif opts_temp == "Time" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, hours)
                draw.text(text.x + 24, text.y - 1, 255, 255, 255, a, "", 0, ":")
                draw.text(text.x + 28, text.y, r, g, b, a, "", 0, minutes)
            elseif opts_temp == "Velocity" then
                local vel = { y = entity.get_prop(lp, "m_vecVelocity"), x = entity.get_prop(lp, "m_vecVelocity") }
                if vel.x ~= nil then
                    local velocity = math.sqrt(vel.x*vel.x + vel.y*vel.y)
                    velocity = math.min(9999, velocity) + 0.2
                    velocity = round(velocity, 0)
                    draw.text(text.x + 9, text.y, r, g, b, a, "", 0, velocity)
                    draw.text(text.x + draw.measure_text("", velocity) + 10, text.y, 255, 255, 255, a, "", 0, "u/t")
                end
            elseif opts_temp == "KDR" then
                local lpe = { get_kills = entity.get_prop(p_res, "m_iKills", lp), get_deaths = entity.get_prop(p_res, "m_iDeaths", lp) }
                local kdr = 0
                if lpe.get_deaths ~= 0 then
                    local temp = lpe.get_kills / lpe.get_deaths
                    kdr = round(temp, 2)
                elseif lpe.get_kills ~= 0 then
                    kdr = lpe.get_kills
                end
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, kdr)
                draw.text(text.x + draw.measure_text("", kdr) + 10, text.y, 255, 255, 255, a, "", 0, "k/d")
            elseif opts_temp == "FPS" then
                fps = round(fps, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, fps)
                draw.text(text.x + draw.measure_text("", fps) + 11, text.y, 255, 255, 255, a, "", 0, "fps")
            elseif opts_temp == "Ping" then
                ping = round(ping, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, ping)
                draw.text(text.x + draw.measure_text("", ping) + 11, text.y, 255, 255, 255, a, "", 0, "ms")
            end

            if widths[opts_temp] ~= nil then
                text.x = text.x + widths[opts_temp]
            end

            if #opts > i then
                renderer.text(text.x, text.y, 255, 255, 255, a, nil, 0, " | ")
            end
        end

    elseif style == "Custom" then
        local r, g, b, a = ui.get(gui.accent)
        local text = { x = wnd.x - width, y = wnd.y + 4 }

        if ui.get(gui.header) then
            container_custom(wnd.x - width, wnd.y, width, 22, true)
            text.y = text.y + 1
        else
            container_custom(wnd.x - width, wnd.y, width, 20, false)
        end

        for i=1, #opts do

            local opts_temp = opts[i]
            if opts_temp == "Text" then
                draw.text(text.x + 6, text.y, 255, 255, 255, a, "", 0, "game")
                draw.text(text.x + draw.measure_text("", "game") + 6, text.y, r, g, b, a, "", 0, "sense")
            elseif opts_temp == "Username" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, entity.get_player_name(lp))
            elseif opts_temp == "Time" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, hours)
                draw.text(text.x + 24, text.y - 1, 255, 255, 255, a, "", 0, ":")
                draw.text(text.x + 28, text.y, r, g, b, a, "", 0, minutes)
            elseif opts_temp == "Velocity" then
                local vel = { y = entity.get_prop(lp, "m_vecVelocity"), x = entity.get_prop(lp, "m_vecVelocity") }
                if vel.x ~= nil then
                    local velocity = math.sqrt(vel.x*vel.x + vel.y*vel.y)
                    velocity = math.min(9999, velocity) + 0.2
                    velocity = round(velocity, 0)
                    draw.text(text.x + 9, text.y, r, g, b, a, "", 0, velocity)
                    draw.text(text.x + draw.measure_text("", velocity) + 10, text.y, 255, 255, 255, a, "", 0, "u/t")
                end
            elseif opts_temp == "KDR" then
                local lpe = { get_kills = entity.get_prop(p_res, "m_iKills", lp), get_deaths = entity.get_prop(p_res, "m_iDeaths", lp) }
                local kdr = 0
                if lpe.get_deaths ~= 0 then
                    local temp = lpe.get_kills / lpe.get_deaths
                    kdr = round(temp, 2)
                elseif lpe.get_kills ~= 0 then
                    kdr = lpe.get_kills
                end
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, kdr)
                draw.text(text.x + draw.measure_text("", kdr) + 10, text.y, 255, 255, 255, a, "", 0, "k/d")
            elseif opts_temp == "FPS" then
                fps = round(fps, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, fps)
                draw.text(text.x + draw.measure_text("", fps) + 11, text.y, 255, 255, 255, a, "", 0, "fps")
            elseif opts_temp == "Ping" then
                ping = round(ping, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, ping)
                draw.text(text.x + draw.measure_text("", ping) + 11, text.y, 255, 255, 255, a, "", 0, "ms")
            end

            if widths[opts_temp] ~= nil then
                text.x = text.x + widths[opts_temp]
            end

            if #opts > i then
                renderer.text(text.x, text.y, 255, 255, 255, a, nil, 0, " | ")
            end

        end
    
    elseif style == "Dump" then
        local r, g, b, a = ui.get(gui.accent)
        local text = { x = wnd.x - width, y = wnd.y + 5 }
        container_dump(wnd.x - width, wnd.y, width, 20, false)

        for i=1, #opts do

            local opts_temp = opts[i]
            if opts_temp == "Text" then
                draw.text(text.x + 6, text.y, 255, 255, 255, a, "", 0, "game")
                draw.text(text.x + draw.measure_text("", "game") + 6, text.y, r, g, b, a, "", 0, "sense")
            elseif opts_temp == "Username" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, entity.get_player_name(lp))
            elseif opts_temp == "Time" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, hours)
                draw.text(text.x + 24, text.y - 1, 255, 255, 255, a, "", 0, ":")
                draw.text(text.x + 28, text.y, r, g, b, a, "", 0, minutes)
            elseif opts_temp == "Velocity" then
                local vel = { y = entity.get_prop(lp, "m_vecVelocity"), x = entity.get_prop(lp, "m_vecVelocity") }
                if vel.x ~= nil then
                    local velocity = math.sqrt(vel.x*vel.x + vel.y*vel.y)
                    velocity = math.min(9999, velocity) + 0.2
                    velocity = round(velocity, 0)
                    draw.text(text.x + 9, text.y, r, g, b, a, "", 0, velocity)
                    draw.text(text.x + draw.measure_text("", velocity) + 10, text.y, 255, 255, 255, a, "", 0, "u/t")
                end
            elseif opts_temp == "KDR" then
                local lpe = { get_kills = entity.get_prop(p_res, "m_iKills", lp), get_deaths = entity.get_prop(p_res, "m_iDeaths", lp) }
                local kdr = 0
                if lpe.get_deaths ~= 0 then
                    local temp = lpe.get_kills / lpe.get_deaths
                    kdr = round(temp, 2)
                elseif lpe.get_kills ~= 0 then
                    kdr = lpe.get_kills
                end
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, kdr)
                draw.text(text.x + draw.measure_text("", kdr) + 10, text.y, 255, 255, 255, a, "", 0, "k/d")
            elseif opts_temp == "FPS" then
                fps = round(fps, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, fps)
                draw.text(text.x + draw.measure_text("", fps) + 11, text.y, 255, 255, 255, a, "", 0, "fps")
            elseif opts_temp == "Ping" then
                ping = round(ping, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, ping)
                draw.text(text.x + draw.measure_text("", ping) + 11, text.y, 255, 255, 255, a, "", 0, "ms")
            end

            if widths[opts_temp] ~= nil then
                text.x = text.x + widths[opts_temp]
            end

            if #opts > i then
                renderer.text(text.x, text.y, 255, 255, 255, a, nil, 0, " / ")
            end

        end

    elseif style == "Dump 2" then
        local r, g, b, a = ui.get(gui.accent)
        local text = { x = wnd.x - width, y = wnd.y + 4 }

        if ui.get(gui.header) then
            container_oc(wnd.x - width, wnd.y, width, 22, true)
            text.y = text.y + 1
        else
            container_oc(wnd.x - width, wnd.y, width, 20, false)
        end

        for i=1, #opts do

            local opts_temp = opts[i]
            if opts_temp == "Text" then
                draw.text(text.x + 6, text.y, 255, 255, 255, a, "", 0, "game")
                draw.text(text.x + draw.measure_text("", "game") + 6, text.y, r, g, b, a, "", 0, "sense")
            elseif opts_temp == "Username" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, entity.get_player_name(lp))
            elseif opts_temp == "Time" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, hours)
                draw.text(text.x + 24, text.y - 1, 255, 255, 255, a, "", 0, ":")
                draw.text(text.x + 28, text.y, r, g, b, a, "", 0, minutes)
            elseif opts_temp == "Velocity" then
                local vel = { y = entity.get_prop(lp, "m_vecVelocity"), x = entity.get_prop(lp, "m_vecVelocity") }
                if vel.x ~= nil then
                    local velocity = math.sqrt(vel.x*vel.x + vel.y*vel.y)
                    velocity = math.min(9999, velocity) + 0.2
                    velocity = round(velocity, 0)
                    draw.text(text.x + 9, text.y, r, g, b, a, "", 0, velocity)
                    draw.text(text.x + draw.measure_text("", velocity) + 10, text.y, 255, 255, 255, a, "", 0, "u/t")
                end
            elseif opts_temp == "KDR" then
                local lpe = { get_kills = entity.get_prop(p_res, "m_iKills", lp), get_deaths = entity.get_prop(p_res, "m_iDeaths", lp) }
                local kdr = 0
                if lpe.get_deaths ~= 0 then
                    local temp = lpe.get_kills / lpe.get_deaths
                    kdr = round(temp, 2)
                elseif lpe.get_kills ~= 0 then
                    kdr = lpe.get_kills
                end
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, kdr)
                draw.text(text.x + draw.measure_text("", kdr) + 10, text.y, 255, 255, 255, a, "", 0, "k/d")
            elseif opts_temp == "FPS" then
                fps = round(fps, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, fps)
                draw.text(text.x + draw.measure_text("", fps) + 11, text.y, 255, 255, 255, a, "", 0, "fps")
            elseif opts_temp == "Ping" then
                ping = round(ping, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, ping)
                draw.text(text.x + draw.measure_text("", ping) + 11, text.y, 255, 255, 255, a, "", 0, "ms")
            end

            if widths[opts_temp] ~= nil then
                text.x = text.x + widths[opts_temp]
            end

            if #opts > i then
                renderer.text(text.x, text.y, 255, 255, 255, a, nil, 0, " | ")
            end

        end

    elseif style == "Trash" then
        local r, g, b, a = ui.get(gui.accent)
        local text = { x = wnd.x - width, y = wnd.y + 4 }

        if ui.get(gui.header) then
            container_weirddump(wnd.x - width, wnd.y, width, 22, true)
            text.y = text.y + 1
        else
            container_weirddump(wnd.x - width, wnd.y, width, 20, false)
        end

        for i=1, #opts do

            local opts_temp = opts[i]
            if opts_temp == "Text" then
                draw.text(text.x + 6, text.y, 255, 255, 255, a, "", 0, "game")
                draw.text(text.x + draw.measure_text("", "game") + 6, text.y, r, g, b, a, "", 0, "sense")
            elseif opts_temp == "Username" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, entity.get_player_name(lp))
            elseif opts_temp == "Time" then
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, hours)
                draw.text(text.x + 24, text.y - 1, 255, 255, 255, a, "", 0, ":")
                draw.text(text.x + 28, text.y, r, g, b, a, "", 0, minutes)
            elseif opts_temp == "Velocity" then
                local vel = { y = entity.get_prop(lp, "m_vecVelocity"), x = entity.get_prop(lp, "m_vecVelocity") }
                if vel.x ~= nil then
                    local velocity = math.sqrt(vel.x*vel.x + vel.y*vel.y)
                    velocity = math.min(9999, velocity) + 0.2
                    velocity = round(velocity, 0)
                    draw.text(text.x + 9, text.y, r, g, b, a, "", 0, velocity)
                    draw.text(text.x + draw.measure_text("", velocity) + 10, text.y, 255, 255, 255, a, "", 0, "u/t")
                end
            elseif opts_temp == "KDR" then
                local lpe = { get_kills = entity.get_prop(p_res, "m_iKills", lp), get_deaths = entity.get_prop(p_res, "m_iDeaths", lp) }
                local kdr = 0
                if lpe.get_deaths ~= 0 then
                    local temp = lpe.get_kills / lpe.get_deaths
                    kdr = round(temp, 2)
                elseif lpe.get_kills ~= 0 then
                    kdr = lpe.get_kills
                end
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, kdr)
                draw.text(text.x + draw.measure_text("", kdr) + 10, text.y, 255, 255, 255, a, "", 0, "k/d")
            elseif opts_temp == "FPS" then
                fps = round(fps, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, fps)
                draw.text(text.x + draw.measure_text("", fps) + 11, text.y, 255, 255, 255, a, "", 0, "fps")
            elseif opts_temp == "Ping" then
                ping = round(ping, 0)
                draw.text(text.x + 9, text.y, r, g, b, a, "", 0, ping)
                draw.text(text.x + draw.measure_text("", ping) + 11, text.y, 255, 255, 255, a, "", 0, "ms")
            end

            if widths[opts_temp] ~= nil then
                text.x = text.x + widths[opts_temp]
            end

            if #opts > i then
                renderer.text(text.x, text.y, 255, 255, 255, a, nil, 0, " | ")
            end

        end

    end

end)
