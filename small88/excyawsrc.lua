require "bit"
local vector = require 'vector'
local ffi = require("ffi")
local js = panorama['open']()
local MyPersonaAPI, LobbyAPI, PartyListAPI, FriendsListAPI, GameStateAPI = js['MyPersonaAPI'], js['LobbyAPI'], js['PartyListAPI'], js['FriendsListAPI'], js['GameStateAPI']

-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_set_event_callback, ui_get, ui_set, ui_new_checkbox, ui_new_combobox, ui_new_slider, ui_reference, ui_set_visible = client.set_event_callback, ui.get, ui.set, ui.new_checkbox, ui.new_combobox, ui.new_slider, ui.reference, ui.set_visible


local notify = (function()
    local notify = {callback_registered = false, maximum_count = 7, data = {}, svg_texture = [[<svg id="Capa_1" enable-background="new 0 0 512 512" height="512" viewBox="0 0 512 512" width="512" xmlns="http://www.w3.org/2000/svg"><g><g><path d="m216.188 82.318h48.768v37.149h-48.768z" fill="#ffcbbe"/></g><g><path d="m250.992 82.318h13.964v37.149h-13.964z" fill="#fdad9d"/></g><g><ellipse cx="240.572" cy="47.717" fill="#ffcbbe" rx="41.682" ry="49.166" transform="matrix(.89 -.456 .456 .89 4.732 115.032)"/></g><g><path d="m277.661 28.697c-10.828-21.115-32.546-32.231-51.522-27.689 10.933 4.421 20.864 13.29 27.138 25.524 12.39 24.162 5.829 52.265-14.654 62.769-2.583 1.325-5.264 2.304-8.003 2.96 10.661 4.31 22.274 4.391 32.387-.795 20.483-10.504 27.044-38.607 14.654-62.769z" fill="#fdad9d"/></g><g><path d="m296.072 296.122h-111.001v-144.174c0-22.184 17.984-40.168 40.168-40.168h30.666c22.184 0 40.168 17.984 40.168 40.168v144.174z" fill="#95d6a4"/></g><g><path d="m256.097 111.78h-24.384c22.077 0 39.975 17.897 39.975 39.975v144.367h24.384v-144.367c0-22.077-17.897-39.975-39.975-39.975z" fill="#78c2a4"/></g><g><path d="m225.476 41.375c0-8.811 7.143-15.954 15.954-15.954h34.401c-13.036-21.859-38.163-31.469-57.694-21.453-19.846 10.177-26.623 36.875-15.756 60.503 12.755-.001 23.095-10.341 23.095-23.096z" fill="#756e78"/></g><g><path d="m252.677 25.421h23.155c-11.31-18.964-31.718-28.699-49.679-24.408 10.591 4.287 20.23 12.757 26.524 24.408z" fill="#665e66"/></g><g><path d="m444.759 453.15-28.194-9.144c-3.04-.986-5.099-3.818-5.099-7.014v-4.69l-2.986-8.22h-61.669l-2.986 8.22v34.22c0 8.628 6.994 15.622 15.622 15.622h81.993c5.94 0 10.755-4.815 10.755-10.755v-8.008c.001-4.662-3.002-8.793-7.436-10.231z" fill="#aa7a63"/></g><g><path d="m444.759 453.15-28.194-9.144c-3.04-.986-5.099-3.818-5.099-7.014v-4.69l-2.986-8.22h-25.91v12.911c0 3.196 2.059 6.028 5.099 7.014l28.194 9.144c4.434 1.438 7.437 5.569 7.437 10.23v8.008c0 5.94-4.815 10.755-10.755 10.755h28.896c5.94 0 10.755-4.815 10.755-10.755v-8.008c0-4.662-3.003-8.793-7.437-10.231z" fill="#986b54"/></g><g><path d="m343.827 344.798v87.505h67.64v-123.053c0-20.65-16.74-37.39-37.39-37.39h-189.006v33.212c0 19.014 15.414 34.428 34.428 34.428h119.03c2.926 0 5.298 2.372 5.298 5.298z" fill="#5766cb"/></g><g><path d="m382.571 309.25v123.052h28.896v-123.052c0-20.65-16.74-37.39-37.39-37.39h-28.896c20.65 0 37.39 16.74 37.39 37.39z" fill="#3d4fc3"/></g><g><g><path d="m437.268 512h-108.548c-8.244 0-14.928-6.684-14.928-14.928v-107.221c0-11.247-9.15-20.399-20.398-20.399h-123.543c-8.244 0-14.928-6.684-14.928-14.928v-150.17h-22.748c-8.244 0-14.928-6.684-14.928-14.928s6.684-14.928 14.928-14.928h37.676c8.244 0 14.928 6.684 14.928 14.928v150.17h108.616c27.71 0 50.254 22.545 50.254 50.255v92.293h93.619c8.244 0 14.928 6.684 14.928 14.928s-6.684 14.928-14.928 14.928z" fill="#756e78"/></g></g><g><g><path d="m437.268 482.144h-15.115c8.244 0 14.928 6.684 14.928 14.928s-6.683 14.928-14.928 14.928h15.115c8.244 0 14.928-6.684 14.928-14.928s-6.684-14.928-14.928-14.928z" fill="#665e66"/></g><g><path d="m328.534 389.851v83.296c0 4.969 4.028 8.997 8.997 8.997h6.118v-92.293c0-27.755-22.5-50.255-50.255-50.255h-15.114c27.71 0 50.254 22.545 50.254 50.255z" fill="#665e66"/></g><g><path d="m169.664 189.426v150.17h15.115v-150.17c0-8.244-6.684-14.928-14.928-14.928h-15.115c8.245 0 14.928 6.684 14.928 14.928z" fill="#665e66"/></g></g><g><g><path d="m171.702 511.498c-61.701 0-111.898-50.197-111.898-111.898s50.197-111.898 111.898-111.898 111.898 50.197 111.898 111.898-50.197 111.898-111.898 111.898zm0-193.94c-45.238 0-82.042 36.804-82.042 82.042s36.804 82.042 82.042 82.042 82.042-36.804 82.042-82.042-36.804-82.042-82.042-82.042z" fill="#756e78"/></g></g><g><g><path d="m243.485 313.833c16.3 19.444 26.131 44.485 26.131 71.783 0 61.701-50.197 111.898-111.898 111.898-27.298 0-52.339-9.831-71.783-26.131 20.543 24.504 51.364 40.115 85.767 40.115 61.701 0 111.898-50.197 111.898-111.898 0-34.403-15.61-65.225-40.115-85.767z" fill="#665e66"/></g></g><g><path d="m384.583 259.81 13.927 12.767c8.319 7.626 13.447 18.117 14.353 29.366l.509 6.316c.283 3.513-3.591 5.82-6.545 3.898l-45.845-29.834z" fill="#ffcbbe"/></g><g><path d="m413.372 308.259-.509-6.316c-.906-11.249-6.034-21.74-14.353-29.366l-13.927-12.767-7.744 7.387 5.869 5.38c8.319 7.626 13.447 18.117 14.353 29.366l.328 4.072 9.438 6.142c2.954 1.921 6.828-.386 6.545-3.898z" fill="#fdad9d"/></g><g><g><path d="m366.869 290.965c-1.448 1.448-3.783 1.589-5.341.26-8.038-6.857-18.146-10.594-28.827-10.594h-69.416c-31.072 0-56.26-25.188-56.26-56.26v-63.312c0-12.367 10.025-22.392 22.392-22.392 12.367 0 22.392 10.025 22.392 22.392v63.312c0 6.338 5.138 11.476 11.476 11.476h69.415c22.462 0 43.657 8.238 60.136 23.284 1.672 1.526 1.716 4.151.115 5.752z" fill="#95d6a4"/></g></g><g><path d="m392.836 259.13c-16.479-15.047-37.674-23.284-60.136-23.284h-69.416c-6.338 0-11.476-5.138-11.476-11.476v-63.312c0-12.367-10.025-22.392-22.392-22.392-3.429 0-6.676.773-9.581 2.151 5.315 4.094 8.743 10.518 8.743 17.746v74.508c0 6.338 5.138 11.476 11.476 11.476h69.416c22.462 0 43.657 8.238 60.136 23.284 1.672 1.526 1.716 4.151.115 5.752l-13.663 13.663c1.907 1.181 3.739 2.503 5.469 3.979 1.558 1.329 3.893 1.188 5.341-.26l26.082-26.082c1.602-1.602 1.558-4.226-.114-5.753z" fill="#78c2a4"/></g></g></svg>
]]}
    local svg_size = { w = 20, h = 20}
    local svg = renderer.load_svg(notify.svg_texture, svg_size.w, svg_size.h)
    function notify:register_callback()
        if self.callback_registered then return end
        client.set_event_callback('paint_ui', function()
            local screen = {client.screen_size()}
            local color = {15, 15, 15}
            local d = 5;
            local data = self.data;
            for f = #data, 1, -1 do
                data[f].time = data[f].time - globals.frametime()
                local alpha, h = 255, 0;
                local _data = data[f]
                if _data.time < 0 then
                    table.remove(data, f)
                else
                    local time_diff = _data.def_time - _data.time;
                    local time_diff = time_diff > 1 and 1 or time_diff;
                    if _data.time < 0.5 or time_diff < 0.5 then
                        h = (time_diff < 1 and time_diff or _data.time) / 0.5;
                        alpha = h * 255;
                        if h < 0.2 then
                            d = d + 15 * (1.0 - h / 0.2)
                        end
                    end
                    local text_data = {renderer.measure_text("dc", _data.draw)}
                    local screen_data = {
                        screen[1] / 2 - text_data[1] / 2 + 3, screen[2] - screen[2] / 100 * 17.4 + d
                    }
                    renderer.rectangle(screen_data[1] - 30, screen_data[2] - 22, text_data[1] + 60, 2, 83, 126, 242, alpha)
                    renderer.rectangle(screen_data[1] - 29, screen_data[2] - 20, text_data[1] + 58, 29, color[1], color[2],color[3], alpha <= 135 and alpha or 135)
                    renderer.line(screen_data[1] - 30, screen_data[2] - 22, screen_data[1] - 30, screen_data[2] - 20 + 30, 83, 126, 242, alpha <= 50 and alpha or 50)
                    renderer.line(screen_data[1] - 30 + text_data[1] + 60, screen_data[2] - 22, screen_data[1] - 30 + text_data[1] + 60, screen_data[2] - 20 + 30, 83, 126, 242, alpha <= 50 and alpha or 50)
                    renderer.line(screen_data[1] - 30, screen_data[2] - 20 + 30, screen_data[1] - 30 + text_data[1] + 60, screen_data[2] - 20 + 30, 83, 126, 242, alpha <= 50 and alpha or 50)
                    renderer.text(screen_data[1] + text_data[1] / 2 + 10, screen_data[2] - 5, 255, 255, 255, alpha, 'dc', nil, _data.draw)
                    renderer.texture(svg, screen_data[1] - svg_size.w/2 - 5, screen_data[2] - svg_size.h/2 - 5, svg_size.w, svg_size.h, 255, 255, 255, alpha)
                    d = d - 50
                end
            end
            self.callback_registered = true
        end)
    end
    function notify:paint(time, text)
        local timer = tonumber(time) + 1;
        for f = self.maximum_count, 2, -1 do
            self.data[f] = self.data[f - 1]
        end
        self.data[1] = {time = timer, def_time = timer, draw = text}
        self:register_callback()
    end
    return notify
end)()


local value3 = 255
local state3 = false

function clamp(v, min, max)
	return math.max(math.min(v, max), min)
end

client.set_event_callback("run_command", function()
	local increment = (1 * globals.frametime()) * 255
	
	if (value3 ~= 0 and not state3) then
		value3 =  clamp(value3 - increment, 0, 255)
	end

	if (value3 ~= 255 and state3) then
		value3 = clamp(value3 + increment, 0, 255)
	end

	if (value3 == 0) then
		state3 = true
	end

	if (value3 == 255) then
		state3 = false
	end

end)


local function contains(table, val)
	for i=1, #table do
		if table[i] == val then
			return true
		end
	end

	return false
end

notify:paint(5, "[+] Connecting to the server...")
notify:paint(10, "[+] exscord has finished setup. Welcome, ")
notify:paint(15, "[+] Succsesfully loaded: exscord extensions beta")

local function multicolor_log(...)
	local args = {...}
	local len = #args
	for i=1, len do
		local arg = args[i]
		local r, g, b = unpack(arg)

		local msg = {}

		if #arg == 3 then
			table.insert(msg, " ")
		else
			for i=4, #arg do
				table.insert(msg, arg[i])
			end
		end
		msg = table.concat(msg)

		if len > i then
			msg = msg .. "\0"
		end

		client.color_log(r, g, b, msg)
	end
end

multicolor_log({0, 255, 0, '[+] '}, {255, 255, 255, 'Connecting to the server...'})
multicolor_log({0, 255, 0, '[+] '}, {255, 255, 255, 'exscord has finished setup.'}, {82, 127, 242, ' Welcome, '})
multicolor_log({0, 255, 0, '[+] '}, {255, 255, 255, 'Succsesfully loaded:'}, {82, 127, 242, ' exscord.yaw - beta 2.3'})

local label10 = ui.new_label("AA", "Anti-aimbot angles", "---------------------------------------------")
local label4 = ui.new_label("AA", "Anti-aimbot angles", "[exsyaw.lua] premium anti-aim lua")
local label5 = ui.new_label("AA", "Anti-aimbot angles", "For support contact -> mishkat#5314")
local label11 = ui.new_label("AA", "Anti-aimbot angles", "              Logged in as: ")
local label9 = ui.new_label("AA", "Anti-aimbot angles", "---------------------------------------------")
local enable_lua = ui.new_checkbox("AA", "Anti-aimbot angles", "enable exscord.yaw - beta 2.3")
local change_aa_on_key = ui.new_hotkey("AA", "Anti-aimbot angles", "[exscord] Dodge anti-aim mode")
local jitter_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "[exscord] Alternative jitter mode")
local legit_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "[exscord] Legit anti-aim on E")

local shit = false
client.set_event_callback("paint", function()
	if ui.get(enable_lua) then
		if not shit then
            notify:paint(20, "[+] Anti-aim was successfully setuped. Enjoy, ")
			shit = true
		end
	else shit = false end
	
end)

local vars = {
    enable = ui.new_checkbox('AA', 'anti-aimbot angles', '[exscord] Manual anti-aim'),
	key_left = ui.new_hotkey("AA", "Anti-aimbot angles", "[exscord] Manual Left <", false),
	key_right = ui.new_hotkey("AA", "Anti-aimbot angles", "[exscord] Manual Right >", false),
	key_back = ui.new_hotkey("AA", "Anti-aimbot angles", "[exscord] Manual Back V", false),
}

local auto_invert = ui.new_checkbox("AA", "Anti-aimbot angles", "[exscord] Automatic inverter")
local anti_brute = ui.new_multiselect("AA", "Anti-aimbot angles", "[exscord] Anti-bruteforce", {"On hit", "On miss", "On shot"})
local indicator_style = ui.new_combobox("AA", "Anti-aimbot angles", "[exscord] Anti-aim indication style", {"Off", "Circle", "Arrows", "Line"})
local aa_legs = ui.new_checkbox("AA", "anti-aimbot angles", "[exscord] Better leg movement")
local aa_enabled = ui.new_checkbox('AA', 'anti-aimbot angles', '[exscord] Anti-aim indication')

---- stuff for indicators --------------
local slider_limit = ui.reference('aa', 'fake lag', 'limit')

-- Keybinds
local hotkey_force_safe_point = ui.reference('rage', 'aimbot', 'force safe point')
local hotkey_force_body_aim = ui.reference('rage', 'other', 'force body aim')
local hotkey_duck_peek_assist = ui.reference('rage', 'other', 'duck peek assist')
local checkbox_double_tap, hotkey_double_tap = ui.reference('rage', 'other', 'double tap')
local checkbox_on_shot, hotkey_on_shot = ui.reference('aa', 'other', 'On shot anti-aim')
local hotkey_fake_peek = ui.reference('aa', 'other', 'Fake peek')
local checkbox_force_third_person, hotkey_force_third_person = ui.reference('visuals', 'effects', 'force third person (alive)')

-- Adding new menu elements 
local screen_width, screen_height = client.screen_size()
local label7 = ui.new_label('lua', 'b', "---------------------------------------")
local checkbox_nemesis_indicators_enabled = ui.new_checkbox('lua', 'b', '[exscord] Nemesis indicators')
local color_picker_nemesis_indicators = ui.new_color_picker('lua', 'b', '[exscord] \nNemesis indicators color', 255, 150, 255, 255)
local slider_position_x = ui.new_slider('lua', 'b', '\nx position', 0, screen_width, 15, true, 'px')
local slider_position_y = ui.new_slider('lua', 'b', '\ny position', 0, screen_height, screen_height / 2.3, true, 'px')
local label8 = ui.new_label('lua', 'b', "---------------------------------------")
---- stuff for indicators --------------

local indicator = {
	enable = ui.new_checkbox("AA", "Anti-Aimbot angles", "[exscord] Crosshair Indicators"),
}

local screen_size_x, screen_size_y = 0

--local ui_get = ui.get

local fs, fs_key, fs_cond = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local yaw, yaw_add = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local jitter, jitter2, jitter3 = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local body, body_add = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local lby = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local dt, dt2, dt3 = ui.reference("Rage", "Other", "Double tap")
local on_shot, on_shot2 = ui.reference("AA", "Other", "On shot anti-aim")
local fp, fp2 = ui.reference("AA", "Other", "Fake peek")
local fd = ui.reference("RAGE", "Other", "Duck peek assist")
local freestand_byaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local yaw_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")

local is_left, is_right, is_back = false
local left_pressed, right_pressed, back_pressed = false
local left_clicked, right_clicked, back_clicked = false
local left_state, right_state, back_state = 0
	
local function get_direction()
	if not entity.is_alive(entity.get_local_player()) then return end

	if ui_get(vars.key_left) then
		left_pressed = true
		left_clicked = false
	elseif not ui_get(vars.key_left) and left_pressed then
		left_pressed =  false
		left_clicked = true
	else
		left_pressed =  false
		left_clicked =  false
	end
	
	if ui_get(vars.key_right) then
		right_pressed = true
		right_clicked = false
	elseif not ui_get(vars.key_right) and right_pressed then
		right_pressed =  false
		right_clicked = true
	else
		right_pressed  =  false
		right_clicked =  false
	end
	
	if ui_get(vars.key_back) then
		back_pressed = true
		back_clicked = false
	elseif not ui_get(vars.key_back) and back_pressed then
		back_pressed =  false
		back_clicked = true
	else
		back_pressed =  false
		back_clicked =  false
	end
	if back_clicked then
		if back_state == 3 then
			back_state = 0
			is_right = false
			is_left = false
			is_back = true
		else
			back_state = 3
			left_state = 0
			right_state = 0
			is_back = true
			is_right, is_left = false
		end
	elseif left_clicked then
		if left_state == 1 then
			left_state = 0
			is_left = false
			is_back = true
		else
			left_state = 1
			right_state = 0
			back_state = 0
			is_left = true
			is_right, is_back = false
		end
	elseif right_clicked then
		if right_state == 2 then
			right_state = 0
			is_right = false
			is_back = true
		else
			right_state = 2
			left_state = 0
			back_state = 0
			is_right = true
			is_left, is_back = false
		end
	end
end

local function normalize_yaw(angle)
	angle = (angle % 360 + 360) % 360
	return angle > 180 and angle - 360 or angle
end

local color_table = {
    {0, 124, 195, 13, 255},
    {0.125, 176, 205, 10, 255},
    {0.25, 213, 201, 19, 255},
    {0.375, 220, 169, 16, 255},
    {0.5, 228, 126, 10, 255},
    {0.625, 229, 104, 8, 255},
    {0.75, 235, 63, 6, 255},
    {0.875, 237, 27, 3, 255},
    {1, 255, 0, 0, 255}
}
 
local function get_color_by_float(float, pow)
    local float = math.min(math.max(float, 0.000001), 0.999999)
    local color_lower 
    local color_higher 
    local distance_lower = 1
    local distance_higher = 1
 
    for i = 1, #color_table do 
        local color = color_table[i]
        local color_float = color[1]
        if color_float == float then 
            return color[2], color[3], color[4], color[5]
        elseif color_float > float then 
            local distance = color_float - float 
            if distance < distance_higher then 
                color_higher = color 
                distance_higher = distance
            end
        elseif color_float < float then 
            local distance = float - color_float
            if distance < distance_lower then 
                color_lower = color 
                distance_lower = distance
            end
        end
    end
    distance_lower, distance_higher = distance_lower^pow, distance_higher^pow
    local distance_difference = distance_lower + distance_higher
    local red = (color_lower[2] * distance_higher + color_higher[2] * distance_lower) / distance_difference
    local green = (color_lower[3] * distance_higher + color_higher[3] * distance_lower) / distance_difference
    local blue = (color_lower[4] * distance_higher + color_higher[4] * distance_lower) / distance_difference
    local alpha = (color_lower[5] * distance_higher + color_higher[5] * distance_lower) / distance_difference
 
    return red, green, blue, alpha
end
local freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
client.set_event_callback('setup_command', function(e)
	if ui.get(legit_aa) and client.key_state(0x45) then
		local weaponn = entity.get_player_weapon()
		if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
			if e.in_attack == 1 then
				e.in_attack = 0
				e.in_use = 1
			end
		else
			if e.chokedcommands == 0 then
				e.in_use = 0
			end
		end
		--ui.set(freestanding_body_yaw, true)
	end
end)

local do_it_once = false
local do_it_once2 = false
local do_it_once3 = false
local do_it_once4 = false
local do_it_once5 = false
local dormant = false
local reset_jitter = false
local function set_direction()
	local exp = ui.get(dt) and ui.get(dt2) or ui.get(on_shot) and ui.get(on_shot2)
	if not entity.is_alive(entity.get_local_player()) then return end

	local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
	if flags == 256 or is_back then
		ui.set(yaw_base, "At targets")
	else
		ui.set(yaw_base, "Local view")
	end

	if ui.get(legit_aa) and client.key_state(0x45) then
		ui.set(pitch, "Off")
		ui.set(yaw_add, 180)
		if ui.get(jitter_aa) then
			ui.set(body, "Jitter")
			ui.set(body_add, 90)
			ui.set(lby, "Eye yaw")
		else
			ui.set(body, "Static")
			ui.set(lby, exp and "Eye yaw" or "Opposite")
			ui.set(body_add, 180)
		end
		ui.set(yaw_base, "Local View")
		ui.set(freestanding_body_yaw, true)
		do_it_once2 = false
	else
	
		if ui.get(jitter_aa) then
			ui.set(body, "Jitter")
			ui.set(body_add, 90)
			ui.set(lby, "Eye yaw")
			reset_jitter = false
		else
			if not reset_jitter then
				ui.set(body, "Static")
				ui.set(body_add, 0)
				ui.set(lby, "Eye yaw")
				ui.set(yaw_add, 0)
				reset_jitter = true
			end
		end

		if not do_it_once2 then
			ui.set(pitch, "Minimal")
			ui.set(yaw_base, "Local view")
			ui.set(lby, "Eye yaw")
			ui.set(yaw_add, 0)
			ui.set(freestanding_body_yaw, false)
			do_it_once2 = true
		end
        
		if ui.get(change_aa_on_key) then
			ui.set(yaw_add, 9)
			ui.set(body, "Jitter")
			ui.set(body_add, 31)
			ui.set(lby, "Eye yaw")
			ui.set(yaw_limit, 32)
			do_it_once3 = false
		else	
			if not do_it_once3 then
				ui.set(yaw_add, 0)
				ui.set(yaw_limit, 60)
                ui.set(body, "Static")
                ui.set(lby, "Eye yaw")
				ui.set(body_add, 180)
				do_it_once3 = true
			end
        
            if ui.get(vars.enable) then
                if is_left then
                    ui.set(yaw_add, -90)
                    do_it_once = false
                elseif is_right then
                        ui.set(yaw_add, 90)
                    do_it_once = false
                elseif is_back then
                    if not do_it_once then
                            ui.set(yaw_add, 0)
                        do_it_once = true
                    end
                end
            end
		end
	end
end

function clamp(v, min, max)
	return math.max(math.min(v, max), min)
end

local set_once = false

local menu_clr = ui.reference("MISC", "Settings", "Menu color")

local min_dmg = ui.reference("RAGE", "Aimbot", "Minimum damage")
local sf =  ui.reference("RAGE", "Aimbot", "Force safe point")
local baim =  ui.reference("RAGE", "Other", "Force body aim")

local function player_is_on_esp(player)
    local players = entity.get_players(true)
    for _, v in pairs(players) do
        if v == player then
            return true
        end
    end
    return false
end 

local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

    return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
end

local function draw_indicator_circle(x, y, r, g, b, a, percentage, outline)
    local outline = outline == nil and true or outline
    local radius = 4
    local start_degrees = 0

    if outline then
        renderer.circle_outline(x, y, 0, 0, 0, 200, radius, start_degrees, 2, 4)
    end
    renderer.circle_outline(x, y, r, g, b, a, radius-1, start_degrees, percentage, 1.5)
end

local should_draw = false

local slider_double_tap_fake_lag_limit = ui.reference('rage', 'other', 'double tap fake lag limit')
local slider_sv_maxusrcmdprocessticks = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks")

local double_tap_started = false
local double_tap_started_tickcount = globals.tickcount()

local function get_near_target()
	local enemy_players = entity.get_players(true)
	if #enemy_players ~= 0 then
		local own_x, own_y, own_z = client.eye_position()
		local own_pitch, own_yaw = client.camera_angles()
		local closest_enemy = nil
		local closest_distance = 999999999

		for i = 1, #enemy_players do
			local enemy = enemy_players[i]
			local enemy_x, enemy_y, enemy_z = entity.get_prop(enemy, "m_vecOrigin")

			local x = enemy_x - own_x
			local y = enemy_y - own_y
			local z = enemy_z - own_z

			local yaw = ((math.atan2(y, x) * 200 / math.pi))
			local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 200 / math.pi)

			local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
			local pitch_dif = math.abs(own_pitch - pitch ) % 360

			if yaw_dif > 180 then yaw_dif = 360 - yaw_dif end
			local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))

			if closest_distance > real_dif then
				closest_distance = real_dif
				closest_enemy = enemy
			end
		end

		if closest_enemy ~= nil then
			return closest_enemy, closest_distance
		end
	end

	return nil, nil
end

local function draw_crosshair_indicators()
    local add_value = 0
    local body_yaw = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11)
	if not body_yaw then return end

	local start_degrees = body_yaw >= 0.5 and 90 or 270

	local float = 1 - math.abs((body_yaw - 0.5) * 2)

	local r, g, b = get_color_by_float(float, 1)

	local w, h = client.screen_size()
    local x, y = w / 2, h / 2
    
    local percentage = 60 * (1 / 360)
    
    local camera_yaw = select(2, client.camera_angles())
    local rotation_yaw = select(2, entity.get_prop(entity.get_local_player(), 'm_angAbsRotation'))

    local gr, gg, gb, ga = 180, 180, 180, 150
    local c_r, c_g, c_b, c_a = 255, 0, 255, 255

    if ui.get(indicator_style) == "Circle" then
        renderer.circle_outline(x, y, 0, 0, 0, 100, 10, 0, 1, 5)
        renderer.circle_outline(x, y, r, g, b, 255, 9, start_degrees, 0.5, 3)
        renderer.circle_outline(x, y, r, g, b, 255, 19, camera_yaw - rotation_yaw - 120, percentage, 4)
    elseif ui.get(indicator_style) == "Arrows" then
        local target = get_near_target()
        if target ~= nil then
            renderer.text(x + 65, y - 3, 
                body_yaw > 0.5 and gr or c_r, 
                body_yaw > 0.5 and gg or c_g, 
                body_yaw > 0.5 and gb or c_b,  
                body_yaw > 0.5 and ga or c_a,  
            "cb+", 0, "⯈")

            renderer.text(x - 65, y - 3, 
                body_yaw > 0.5 and c_r or gr, 
                body_yaw > 0.5 and c_g or gg, 
                body_yaw > 0.5 and c_b or gb,  
                body_yaw > 0.5 and c_a or ga,  
            "cb+", 0, "⯇")
        end
     
    elseif ui.get(indicator_style) == "Line" then
        body_yaw = body_yaw * 120 - 60
    
        local first_r, first_g, first_b, first_a = 255, 0, 127, 0
        local second_r, second_g, second_b, second_a = 255, 0, 127, 255
    
        local line_width = math.abs(math.floor(body_yaw + 0.5))
    
        renderer.text(x, y + 30, 255, 255, 255, 255, 'c', 0, string.format('%s°', line_width))
    
        renderer.gradient(x - line_width, y + 40, line_width, 3, first_r, first_g, first_b, first_a, second_r, second_g, second_b, second_a, true)
        renderer.gradient(x, y + 40, line_width, 3, second_r, second_g, second_b, second_a, first_r, first_g, first_b, first_a, true)
    
        renderer.text(x, y + 50, 255, 255, 255, 255, 'c', 0, 'Anti-bruteforce')
    end

	if not ui.get(indicator.enable) then
		return
	end

	local style = "cb"

	--local aa_name = ui.get(change_aa_on_key) and "DODGE" or ui.get(legit_aa_on_key) and "LEGIT AA" or "IDEAL YAW"
	local crosshair_size = cvar.cl_crosshairsize:get_int()
	
	local position_value = ui.get(indicator_style) == "Line" and crosshair_size + 59 or crosshair_size + 30
	
	--local r, g, b, a = ui.get(indicator.color)

	local anim = ui.get(on_shot2) and "HIDE" or ui.get(dt) and "ANIM" or "ANIM"
	
    local ri, gi, bi, ai = 50, 50, 50, 255
    if ui.get(indicator_style) ~= "Line" then
        renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
            r, 
            g, 
            b, 
            value3,  
            style, 0, "PREDICTION") 
        add_value = add_value + 10
    end 

    local send_packet = globals.chokedcommands() == 0
    local tickcount = globals.tickcount()   

    local double_tap = ui.get(dt) and ui.get(dt2)

    if double_tap and send_packet then
        if not double_tap_started then
            double_tap_started_tickcount = tickcount
        end
        double_tap_started = true
    else
        double_tap_started_tickcount = tickcount
        double_tap_started = false
    end

    local sv_maxusrcmdprocessticks = ui.get(slider_sv_maxusrcmdprocessticks)
    local max_fake_lag_limit = sv_maxusrcmdprocessticks - 2

    local double_tap_fake_lag_limit = ui.get(slider_double_tap_fake_lag_limit)
    local max_double_tap_charged_ticks = math.max(1, math.min(15, max_fake_lag_limit - double_tap_fake_lag_limit))

    local charged_double_tap_ticks = tickcount - double_tap_started_tickcount

    local percentage = map(charged_double_tap_ticks, 1, max_double_tap_charged_ticks, 0, 1)

    if charged_double_tap_ticks ~= 0 then
        renderer.text(screen_size_x / 2 - 7, (screen_size_y / 2) + position_value + add_value,
		ui.get(dt) and ui.get(dt2) and 1 or 128, 
		ui.get(dt) and ui.get(dt2) and 255 or 11, 
		ui.get(dt) and ui.get(dt2) and 1 or 11, 
		ui.get(dt) and ui.get(dt2) and 255 or 255,  
        style, 0, "DT")
        
        draw_indicator_circle(screen_size_x / 2 + 7, (screen_size_y / 2) + position_value + add_value + 1, 1, 255, 1, 255, percentage)
    else
        renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		ui.get(dt) and ui.get(dt2) and 1 or 128, 
		ui.get(dt) and ui.get(dt2) and 255 or 11, 
		ui.get(dt) and ui.get(dt2) and 1 or 11, 
		ui.get(dt) and ui.get(dt2) and 255 or 255,  
		style, 0, "DT")
    end
    
	add_value = add_value + 10
	
	local side = ""
    if is_left then side = "LEFT"
    elseif is_right then side = "RIGHT"
    elseif is_back then side = "BACK"
    else side = "" end

    if side ~= "" then
        renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
            255, 
            255, 
            255, 
            255,  
            style, 0, side) 
        add_value = add_value + 10
    end
    local s = not ui.get(change_aa_on_key) or not ui.get(jitter_aa)
    if contains(ui.get(anti_brute), "On miss") and s then
        if should_draw then
            renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
            255,  
            255,  
            255,  
            255,  
            style, 0, "FORCING")
            add_value = add_value + 10
        end
    end

	if ui.get(on_shot) and ui.get(on_shot2) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		255,  
		102,  
		102,  
		255,  
		style, 0, "ON-SHOT")
		add_value = add_value + 10
	end
	if ui.get(fd) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
			255, 
			255, 
			255, 
			value3,  
			style, 0, "DUCK")
		add_value = add_value + 10
	end
	if ui.get(sf) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		128,  
		200,  
		0,  
		255,
		style, 0, "SAFE")
		add_value = add_value + 10
	end
	if ui.get(baim) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
			128,  
			240,  
			0,  
			255,  
			style, 0, "BAIM")
		add_value = add_value + 10
	end
end 

client.set_event_callback("paint", function(ctx)
	if not ui.get(enable_lua) then
		return
	end
	
	if not entity.is_alive(entity.get_local_player()) then return end

	local old_x, old_y = client.screen_size()	
	
	if screen_size_x ~= old_x or screen_size_y ~= old_y then
		screen_size_x = old_x
		screen_size_y = old_y
	end
	
	ui.set(vars.key_left, "On hotkey")
	ui.set(vars.key_right, "On hotkey")
	ui.set(vars.key_back, "On hotkey")
	
	draw_crosshair_indicators()
	get_direction()
	set_direction()
	
end)

local get_closeset_point = function(a, b, p)
    local a_to_p = { p[1] - a[1], p[2] - a[2] }
    local a_to_b = { b[1] - a[1], b[2] - a[2] }

    local atb2 = a_to_b[1]^2 + a_to_b[2]^2

    local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = atp_dot_atb / atb2
    
    return { a[1] + a_to_b[1]*t, a[2] + a_to_b[2]*t }
end

local should_swap = false
local it = 0

local on_bullet_impact = function(c)
    if not contains(ui.get(anti_brute), "On miss") then
        return
    end
    should_draw = false
    
    if entity.is_alive(entity.get_local_player()) then
        local ent = client.userid_to_entindex(c.userid)

        if not entity.is_dormant(ent) and entity.is_enemy(ent) then
            local ent_shoot = { entity.get_prop(ent, "m_vecOrigin") }

            ent_shoot[3] = ent_shoot[3] + entity.get_prop(ent, "m_vecViewOffset[2]")

            local player_head = { entity.hitbox_position(entity.get_local_player(), 0) }
            local closest = get_closeset_point(ent_shoot, { c.x, c.y, c.z }, player_head)
            local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
            local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
        
            if math.abs(delta_2d) < 125 then
                it = it + 1

                should_draw = true

                if should_swap == true then
                    should_swap = false
                else
                    should_swap = true
                end
            end
        end
    end
end

local on_player_hurt = function(e)
    if not contains(ui.get(anti_brute), "On hit") then
        return
    end

    local victim_userid, attacker_userid = e.userid, e.attacker
	local victim_entindex = client.userid_to_entindex(victim_userid)
    local attacker_entindex = client.userid_to_entindex(attacker_userid)
    
    local state = true

    if state and entity.is_enemy(attacker_entindex) and victim_entindex == entity.get_local_player() then
        if should_swap == true then
            should_swap = false
        else
            should_swap = true
        end
    end
end

client.set_event_callback('bullet_impact', on_bullet_impact)
client.set_event_callback('player_hurt', on_player_hurt)
client.set_event_callback("aim_fire", function()
    if not contains(ui.get(anti_brute), "On shot") then
        return
    end
    if should_swap == true then
        should_swap = false
    else
        should_swap = true
    end
end)

client.set_event_callback("run_command", function(c)
	if not ui.get(enable_lua) or ui.get(change_aa_on_key) or ui.get(jitter_aa) then
		return
    end
    
    if contains(ui.get(anti_brute), "-") then
        return
    end
	
	ui.set(body_add, should_swap and 141 or -141)
end)

local flip = false
function reset_antiaim_values()
	if ui.get(enable_lua) then
		flip  = true
	end

	if flip and not ui.get(enable_lua) then
		ui.set(pitch, "Down")
		ui.set(yaw, "180")
		ui.set(yaw_add, 0)
		ui.set(jitter, "Off")
		ui.set(jitter2, 0)
		ui.set(yaw_base, "Local view")
		ui.set(body, "Static")
		ui.set(body_add, 0)
		ui.set(lby, "Eye yaw")
		ui.set(freestand_byaw, false)
		ui.set(yaw_limit, 60)
		flip = false
	end
end

local legs_ref = ui.reference("AA", "OTHER", "leg movement")

local function legfucker()
  if ui.get(aa_legs) then
    local legs_int = math.random(0, 10)
    if legs_int <= 4 then
      ui.set(legs_ref, "always slide")
    end
    if legs_int == 0 then
      ui.set(legs_ref, "never slide")
    end
    if legs_int >= 5 then
      ui.set(legs_ref, "never slide")
    end
  end
end
client.set_event_callback('paint', legfucker)

local show_preset, show_def = true

local set_preset = ui.new_button("AA", "Anti-aimbot angles", "Set mishkat's preset", function()
    ui.set(legit_aa, true)
	ui.set(jitter_aa, true)
    ui.set(vars.enable, true)
    ui.set(auto_invert, false)
    ui.set(anti_brute, "On hit", "On miss")
    ui.set(indicator_style, "Line")
    ui.set(aa_legs, true)
    ui.set(aa_enabled, true)
    ui.set(indicator.enable, false)
    show_preset = false
    show_def = true
end)


local reset_preset = ui.new_button("AA", "Anti-aimbot angles", "Reset to default", function()
    ui.set(legit_aa, false)
    ui.set(vars.enable, false)
	ui.set(jitter_aa, false)
    ui.set(auto_invert, false)
    ui.set(anti_brute, "-")
    ui.set(indicator_style, "Off")
    ui.set(aa_legs, false)
    ui.set(aa_enabled, false)
    ui.set(indicator.enable, false)
    show_preset = true
    show_def = false
end)

function set_visible_on_elements()
	ui.set_visible(pitch, not ui.get(enable_lua))
	ui.set_visible(yaw, not ui.get(enable_lua))
	ui.set_visible(legs_ref, not ui.get(aa_legs))
	ui.set_visible(yaw_add, not ui.get(enable_lua))
	ui.set_visible(jitter, not ui.get(enable_lua))
	ui.set_visible(jitter2, not ui.get(enable_lua))
	ui.set_visible(yaw_base, not ui.get(enable_lua))
	ui.set_visible(body, not ui.get(enable_lua))
	ui.set_visible(body_add, not ui.get(enable_lua))
	ui.set_visible(lby, not ui.get(enable_lua))
	ui.set_visible(freestand_byaw, not ui.get(enable_lua))
	ui.set_visible(yaw_limit, not ui.get(enable_lua))
	reset_antiaim_values()

    ui.set_visible(aa_enabled, ui.get(enable_lua))
	ui.set_visible(label5, ui.get(enable_lua))
	ui.set_visible(label4, ui.get(enable_lua))
	ui.set_visible(label7, ui.get(enable_lua))
	ui.set_visible(label8, ui.get(enable_lua))
	ui.set_visible(label9, ui.get(enable_lua))
	ui.set_visible(label10, ui.get(enable_lua))
	ui.set_visible(label11, ui.get(enable_lua))
    ui.set_visible(jitter_aa, ui.get(enable_lua))
    ui.set_visible(legit_aa, ui.get(enable_lua))
    ui.set_visible(vars.enable, ui.get(enable_lua))
	ui.set_visible(vars.key_left, ui.get(enable_lua) and ui.get(vars.enable))
	ui.set_visible(vars.key_right, ui.get(enable_lua) and ui.get(vars.enable))
	ui.set_visible(vars.key_back, ui.get(enable_lua) and ui.get(vars.enable))
	ui.set_visible(aa_legs, ui.get(enable_lua))
	ui.set_visible(change_aa_on_key, ui.get(enable_lua))
	ui.set_visible(indicator.enable, ui.get(enable_lua))
	ui.set_visible(checkbox_nemesis_indicators_enabled, ui.get(enable_lua))
	ui.set_visible(color_picker_nemesis_indicators, ui.get(enable_lua))
	ui.set_visible(slider_position_x, ui.get(enable_lua))
    ui.set_visible(slider_position_y, ui.get(enable_lua))
    ui.set_visible(auto_invert, ui.get(enable_lua))
    ui.set_visible(anti_brute, ui.get(enable_lua))
    ui.set_visible(indicator_style, ui.get(enable_lua))
    ui.set_visible(set_preset, ui.get(enable_lua) and show_preset)
    ui.set_visible(reset_preset, ui.get(enable_lua) and show_def)

    ui.set(freestand_byaw, ui.get(enable_lua) and not ui.get(change_aa_on_key) and ui.get(auto_invert))
end

client.set_event_callback("paint_menu", set_visible_on_elements)
client.set_event_callback("paint", set_visible_on_elements)

-------------------------- indicators ----------------
-- Uility functions
function renderer.outline_rectangle(x, y, w, h, r, g, b, a)
    renderer.rectangle(x, y, w, 1, r, g, b, a)
    renderer.rectangle(x + w - 1, y, 1, h, r ,g, b, a)
    renderer.rectangle(x, y + h - 1, w, 1, r, g, b, a)
    renderer.rectangle(x, y, 1, h, r, g, b, a)
end

local function draw_window(x, y, r, g, b, a, label, items, keybinds)
    local separator_height = 13
    local start_y = 19
    local line_width = 121

    local test_y = start_y + #items * separator_height

    -- Outline
    renderer.outline_rectangle(x, y, 200, test_y, 0, 0, 0, 255)

    -- Background
    renderer.rectangle(x, y, 200, test_y, 20, 20, 20, 150)

    -- Label
    renderer.gradient(x, y, 200, 17, 30, 30, 30, 255, 15, 15, 15, 255, false)
    renderer.rectangle(x + 1, y + 1, 198, 1, r, g, b, a)
    renderer.text(x + 100, y + 8, 255, 255, 255, 255, 'c-', 0, label)

    if keybinds then
        for key, indicator in pairs(items) do key = key - 1
            local text_y_offset = y + key * separator_height + start_y

            renderer.text(x + 3, text_y_offset, 255, 255, 255, 255, '-', 0, indicator.text)
            renderer.text(x + 193, text_y_offset, 255, 255, 255, 255, 'r-', 0, 'TOGGLED')
        end
    else
        for key, indicator in pairs(items) do key = key - 1
            local text_y_offset = y + key * separator_height + start_y

            renderer.text(x + 3, text_y_offset, 255, 255, 255, 255, '-', 0, indicator.text)
            renderer.rectangle(x + 75, text_y_offset + 2, line_width, 6, 25, 25, 25, 255)
            renderer.rectangle(x + 75, text_y_offset + 2, line_width * indicator.value, 6, r, g, b, a)
        end
    end

    return y + test_y
end

local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

    return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
end

client.set_event_callback('paint', function()
    if not ui.get(checkbox_nemesis_indicators_enabled) then return end

    local x, y = ui.get(slider_position_x), ui.get(slider_position_y)

    -- Indicators
    local indicators = {}

    local body_yaw = 0
    local speed = 0
    local chokedcommands = globals.chokedcommands()
    local standing_height = 0

    local local_player = entity.get_local_player()
    if entity.is_alive(local_player) then
        local new_body_yaw = entity.get_prop(local_player, 'm_flPoseParameter', 11)
        if new_body_yaw then
            new_body_yaw = math.abs(map(new_body_yaw, 0, 1, -60, 60))
            new_body_yaw = math.max(0, math.min(57, new_body_yaw))
        
            body_yaw = new_body_yaw / 57
        end

        local fake_lag_limit = ui.get(slider_limit)
        if chokedcommands then
            chokedcommands = chokedcommands / fake_lag_limit
        end

        local velocity = vector(entity.get_prop(local_player, 'm_vecVelocity'))

        if velocity then
            speed = math.min(1, velocity:length() / 240)
        end

        local head_position = vector(entity.hitbox_position(local_player, 0))
        local neck_position = vector(entity.hitbox_position(local_player, 1))

        local positions_dif = head_position.z - neck_position.z

        standing_height = map(positions_dif, 2.2, 4, 1, 0)
    end

    table.insert(indicators, {
        text = 'FAKE YAW',
        value = body_yaw
    })

    table.insert(indicators, {
        text = 'FAKE LAG',
        value = chokedcommands
    })

    table.insert(indicators, {
        text = 'SPEED',
        value = speed
    })

    table.insert(indicators, {
        text = 'STAND HEIGHT',
        value = standing_height
    })

    -- Keybinds
    local keybinds = {}

    local duck_peek_assist = ui.get(hotkey_duck_peek_assist)
    if duck_peek_assist then
        table.insert(keybinds, {
            text = 'FAKE DUCK'
        })
    end

    local double_tap = ui.get(checkbox_double_tap) and ui.get(hotkey_double_tap)
    if double_tap and not duck_peek_assist then
        table.insert(keybinds, {
            text = 'DOUBLE TAP'
        })
    end

    local force_safe_point = ui.get(hotkey_force_safe_point)
    if force_safe_point then
        table.insert(keybinds, {
            text = 'SAFE POINT'
        })
    end

    local force_body_aim = ui.get(hotkey_force_body_aim)
    if force_body_aim then
        table.insert(keybinds, {
            text = 'BODY AIM'
        })
    end
	
	local on_shot = ui.get(checkbox_on_shot) and ui.get(hotkey_on_shot)
    if on_shot and not duck_peek_assist then
        table.insert(keybinds, {
            text = 'ON-SHOT'
        })
    end

    local force_third_person = ui.get(checkbox_force_third_person) and ui.get(hotkey_force_third_person)
    if force_third_person then
        table.insert(keybinds, {
            text = 'THIRDPERSON'
        })
    end

    local r, g, b, a = ui.get(color_picker_nemesis_indicators)
   
    local indicators_window_y = draw_window(x, y, r, g, b, a, 'INDICATORS', indicators, false) 
    draw_window(x, indicators_window_y + 7, r, g, b, a, 'KEYBINDS', keybinds, true)
end)

local ffi = require 'ffi'

local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop
local entity_is_alive = entity.is_alive

local string_format = string.format
local globals_curtime = globals.curtime

local client_camera_angles = client.camera_angles
local client_screen_size = client.screen_size

local bit_band = bit.band
local bit_lshift = bit.lshift

local math_max = math.max
local math_min = math.min
local math_floor = math.floor
local math_abs = math.abs
local math_ceil = math.ceil
local math_sqrt = math.sqrt

local renderer_measure_text = renderer.measure_text
local renderer_rectangle = renderer.rectangle
local renderer_gradient = renderer.gradient
local renderer_text = renderer.text
local renderer_circle_outline = renderer.circle_outline

-- FFI INITIALIZATION
package.plugin_aain = true

local locals = {
    last_choke = 0,
    lby_next_think = 0,
}

local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')

ffi.cdef[[
    struct animation_layer_t {
        char pad20[24];
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        char pad20[8];
        float m_flCycle;
        void *m_pOwner;
        char pad_0038[ 4 ];
    };

    struct animstate_t { 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };
]]

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)

local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or error('get_client_networkable_t is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)

local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

local seq_activity_sig = client.find_signature('client.dll','\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83') or error('error getting seq_activity')

local function get_model(b)if b then b=ffi.cast(classptr,b)local c=ffi.cast(crr_t,b[0][0])local d=c(b)or error('error getting client unknown',2)if d then d=ffi.cast(classptr,d)local e=ffi.cast(cr_t,d[0][5])(d)or error('error getting client renderable',2)if e then e=ffi.cast(classptr,e)return ffi.cast(gm_t,e[0][8])(e)or error('error getting model_t',2)end end end end
local function get_sequence_activity(b,c,d)b=ffi.cast(classptr,b)local e=get_studio_model(ivmodelinfo,get_model(c))if e==nil then return-1 end;local f=ffi.cast(gsa_t, seq_activity_sig)return f(b,e,d)end
local function get_anim_layer(b,c)c=c or 1;b=ffi.cast(classptr,b)return ffi.cast('struct animation_layer_t**',ffi.cast('char*',b)+0x2980)[0][c]end

local get_color = function(number, max, i)
    local Colors = {
        { 255, 0, 0 }, { 237, 27, 3 }, { 235, 63, 6 }, { 229, 104, 8 },
        { 228, 126, 10 }, { 220, 169, 16 }, { 213, 201, 19 }, { 176, 205, 10 }, { 124, 195, 13 }
    }

    local math_num = function(int, max, declspec)
        local int = (int > max and max or int)
        local tmp = max / int;

        if not declspec then declspec = max end

        local i = (declspec / tmp)
        i = (i >= 0 and math_floor(i + 0.5) or math_ceil(i - 0.5))

        return i
    end

    i = math_num(number, max, #Colors)

    return
        Colors[i <= 1 and 1 or i][1], 
        Colors[i <= 1 and 1 or i][2],
        Colors[i <= 1 and 1 or i][3],
        i
end

local normalize_yaw = function(angle)
    angle = (angle % 360 + 360) % 360
    return angle > 180 and angle - 360 or angle
end

local g_lby_controller = function(c)
    local curtime = globals_curtime()
    local me = entity_get_local_player()

    local lpent = get_client_entity(ientitylist, me)
    local lpentnetworkable = get_client_networkable(ientitylist, me)

    local user_ptr = ffi.cast(classptr, lpent)
    local animstate_ptr = ffi.cast("char*", user_ptr) + 0x3914
    local me_animstate = ffi.cast("struct animstate_t**", animstate_ptr)[0]

    local is_on_ground = function(player)
        local m_fFlags = entity_get_prop(player, 'm_fFlags')
        local on_ground = bit_band(m_fFlags, bit_lshift(1, 0)) == 1

        return on_ground
    end

    locals.last_choke = c.chokedcommands

    if lpent == nil or lpentnetworkable == nil or me_animstate == nil then 
        return
    end

    -- print(' ')

    for i=1, 12 do
        local layer = get_anim_layer(lpent, i)

        if layer.m_pOwner ~= nil then
            local act = get_sequence_activity(lpent, lpentnetworkable, layer.m_nSequence)

            if act ~= -1 then
                -- print(string_format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle))
            end

            if c.chokedcommands == 0 then
                locals.lby_can_update = is_on_ground(me) and me_animstate.m_flSpeed2D <= 1.0
            end

            if not locals.lby_can_update then
                locals.lby_next_think = curtime + 0.22
            elseif act == 979 then
                if layer.m_flWeight >= 0.0 and layer.m_flCycle <= 0.070000 then
                    if locals.lby_next_think < curtime then
                        locals.lby_next_think = curtime + 1.1
                    end
                elseif layer.m_flWeight == 0 and layer.m_flCycle <= 0.070000 then
                    locals.lby_can_update = false
                end
            end
        end
    end
end

--region retarded gay nigga shit
local notes_pos = function(b)
    local c=function(d,e)
        local f={}
        for g in pairs(d) do 
            table.insert(f,g)
        end;
        table.sort(f,e)
        local h=0;
        local i=function()
            h=h+1;
            if f[h]==nil then 
                return nil 
            else 
                return f[h],d[f[h]]
            end 
        end;
        return i 
    end;
    
    local j={
        get=function(k)
            local l,m=0,{}
            for n,o in c(package.cnotes) do 
                if o==true then 
                    l=l+1;m[#m+1]={n,l}
                end 
            end;
            for p=1,#m do 
                if m[p][1]==b then 
                    return k(m[p][2]-1)
                end 
            end 
        end,
        
        set_state=function(q)
            package.cnotes[b]=q;
            table.sort(package.cnotes)
        end,
        unset=function()
            client.unset_event_callback('shutdown',callback)
        end
    }
    
    client.set_event_callback('shutdown',function()
        if package.cnotes[b]~=nil then package.cnotes[b]=nil end
    end)
    
    if package.cnotes==nil then 
        package.cnotes={}
    end;

    return j 
end
--endregion

local note = notes_pos 'exscord'
local g_paint_handler = function()
    note.set_state(false)

    local me = entity_get_local_player()

    local _, camera_yaw = client_camera_angles()
    local _, rotation = entity_get_prop(me, 'm_angAbsRotation')
    local body_pos = entity_get_prop(me, "m_flPoseParameter", 11) or 0
    
    local body_yaw = math_max(-60, math_min(60, body_pos*120-60+0.5))
    body_yaw = (body_yaw < 1 and body_yaw > 0.0001) and math_floor(body_yaw, 1) or body_yaw

    if camera_yaw ~= nil and rotation ~= nil and 60 < math_abs(normalize_yaw(camera_yaw-(rotation+body_yaw))) then
        body_yaw = -body_yaw
    end

    local enabled = ui_get(aa_enabled)
    local success, _, data2 = pcall(ui.reference, 'CONFIG', 'Presets', 'Watermark')

    local is_active = ui_get(aa_enabled) and entity_is_alive(me)

    if not is_active then
        locals = {
            last_choke = 0,
            lby_next_think = 0,
        }
    end

    local abs_yaw = math_abs(body_yaw)
    local r, g, b, a = get_color(abs_yaw, 30)
    local side = body_yaw < 0 and '>' or (body_yaw > 0.999 and '<' or '-')

    if not is_active then
        return
    end

    note.set_state(true)
    note.get(function(id)
        local timer = (locals.lby_next_think - globals_curtime()) / 1.1 * 1
        local add_text = (locals.lby_can_update and timer >= 0) and '     ' or ''

        local text = string_format('exscord | %sfake (%.1f°)', add_text, abs_yaw)
        local h, w = 17, renderer_measure_text(nil, text) + 8
        local x, y = client_screen_size(), 10 + (25*id)
        
        local alpha = (success and ({ ui_get(data2) })[4] or 255)

        x = x - w - 10

        renderer_rectangle(x-3, y, 2, h, 255, 255, 255, 255)
        renderer_gradient(x-1, y, (w+1) / 2, h, 0, 0, 0, 25, 17, 17, 17, alpha, true)
        renderer_gradient(x-1 + w/2, y, (w+1) / 2, h, 17, 17, 17, alpha, 0, 0, 0, 25, true)
        renderer_text(x+4, y + 2, 255, 255, 255, 255, "", 0, text)

        if locals.lby_can_update and timer >= 0 then
            renderer_circle_outline(x+57, y + 8.5, 89, 255, 255, 255, 5, 0, timer, 2)
        end
    end)
end

client.set_event_callback('setup_command', g_lby_controller)
client.set_event_callback('paint', g_paint_handler)
------------------- ------- indicators ----------------
 