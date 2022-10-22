local table_insert, table_remove = table.insert, table.remove
local draw_grad, draw_rect, draw_text, get_screen_size, get_latency = client.draw_gradient, client.draw_rectangle, client.draw_text, client.screen_size, client.latency
local globals_realtime, globals_absoluteframetime, globals_tickinterval = globals.realtime, globals.absoluteframetime, globals.tickinterval
local get_local_player, get_prop = entity.get_local_player, entity.get_prop
local min, abs, sqrt, floor = math.min, math.abs, math.sqrt, math.floor

local DYMACI_key = ui.new_checkbox("RAGE","OTHER","Dynamic FPS")
local combo2 = ui.new_combobox("RAGE","OTHER","Dynamic FPS Default Setting",{"Off", "Low", "Medium", "High", "Maximum"})
local combo = ui.new_combobox("RAGE","OTHER","Dynamic FPS Mode",{"Off","Low","Medium"})
local fpson = ui.new_slider("RAGE","OTHER","Dynamic FPS On Number",1,500,50)
local accbot = ui.reference("RAGE","OTHER","Accuracy boost")
local aimbot = ui.reference("RAGE","Aimbot","Enabled")

client.color_log(106, 90, 205, "Dynamic FPS by Hitler Q3487510691")

local frametimes = {}
local fps_prev = 0
local last_update_time = 0

local function accumulate_fps()
	local ft = globals_absoluteframetime()
	if ft > 0 then
		table_insert(frametimes, 1, ft)
	end

	local count = #frametimes
	if count == 0 then
		return 0
	end

	local i, accum = 0, 0
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
		table_remove(frametimes)
	end
	
	local fps = 1 / accum
	local rt = globals_realtime()
	if abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end
	
	return floor(fps + 0.5)
end

local function on_paint()
    local fps2 = accumulate_fps()
    if ui.get(DYMACI_key) and ui.get(aimbot) then
        local textbfb = ""
        if fps2 > ui.get(fpson) then
			ui.set(accbot,ui.get(combo2))
			textbfb = "Def"
        elseif fps2 > 0 then
			ui.set(accbot,ui.get(combo))
			textbfb = "Low"
		end
		renderer.indicator(0, 206, 209, 255,"Hitler's Dynamic FPS : ",textbfb)
    end
end


client.set_event_callback("paint", on_paint)