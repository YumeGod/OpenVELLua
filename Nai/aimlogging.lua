local notify = require "notify"

local aimbotlog_enable = ui.new_checkbox("Rage", "Other", "Advanced aimbot logging")
local on_fire_enable = ui.new_checkbox("Rage", "Other", "Fire log")
local on_fire_colour = ui.new_color_picker("Rage", "Other", "Fire log", 147, 112, 219, 255)
local on_miss_enable = ui.new_checkbox("Rage", "Other", "Miss log")
local on_miss_colour = ui.new_color_picker("Rage", "Other", "Miss log", 255, 253, 166, 255)
local on_damage_enable = ui.new_checkbox("Rage", "Other", "Damage log")
local on_damage_colour = ui.new_color_picker("Rage", "Other", "Damage log", 100, 149, 237, 255)

local function handle_menu()
	if ui.get(aimbotlog_enable) then
		ui.set_visible(on_fire_enable, true)
		ui.set_visible(on_fire_colour, true)
		ui.set_visible(on_miss_enable, true)
		ui.set_visible(on_miss_colour, true)
		ui.set_visible(on_damage_enable, true)
		ui.set_visible(on_damage_colour, true)
	else
		ui.set_visible(on_fire_enable, false)
		ui.set_visible(on_fire_colour, false)
		ui.set_visible(on_miss_enable, false)
		ui.set_visible(on_miss_colour, false)
		ui.set_visible(on_damage_enable, false)
		ui.set_visible(on_damage_colour, false)
	end
end
handle_menu()
ui.set_callback(aimbotlog_enable, handle_menu)

client.set_event_callback("paint", function()
    notify:listener()
end)

local function on_aim_fire(e)
    if ui.get(aimbotlog_enable) and ui.get(on_fire_enable) and e ~= nil then
    	local r, g, b = ui.get(on_fire_colour)
        local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local tickrate = client.get_cvar("cl_cmdrate") or 64
        local target_name = entity.get_player_name(e.target)
        local ticks = math.floor((e.backtrack * tickrate) + 0.5)
        local flags = {
        e.teleported and 't' or '',
        e.interpolated and 'i' or '',
        e.extrapolated and 'e' or '',
        e.boosted and 'b' or '',
        e.high_priority and 'h' or ''
    	}

        notify.setup_color({ r, g, b })
        notify.add(5, false,
        { 255, 255, 255, "fired at " },
        { r, g, b, string.lower(target_name) },
        { 255, 255, 255, "'s " },
        { r, g, b, group },
        { 255, 255, 255, " for " },
        { r, g, b, e.damage },
        { 255, 255, 255, " damage (" },
        { r, g, b, "hc: " .. string.format("%d", e.hit_chance) },
        { 255, 255, 255, "%, " },
        { r, g, b, "bt: " .. e.backtrack },
        { 255, 255, 255, " (" },
        { r, g, b, ticks .. "tks" },
        { 255, 255, 255, "), " },
        { r, g, b, "flgs: " .. table.concat(flags) },
        { 255, 255, 255, ")" })
    end
end

local function on_player_hurt(e)
	if ui.get(aimbotlog_enable) and ui.get(on_damage_enable) then
    local attacker_id = client.userid_to_entindex(e.attacker)
    if attacker_id == nil then
        return
    end

    if attacker_id ~= entity.get_local_player() then
        return
    end

    local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local target_id = client.userid_to_entindex(e.userid)
    local target_name = entity.get_player_name(target_id)

    local rhp = ""
    if e.health <= 0 then
        rhp = rhp .. " *dead*"
    end

    local r, g, b = ui.get(on_damage_colour)
        notify.setup_color({ r, g, b })
        notify.add(5, false,
        { 255, 255, 255, "hit " },
        { r, g, b, string.lower(target_name) },
        { 255, 255, 255, "'s " },
        { r, g, b, group },
        { 255, 255, 255, " for " },
        { r, g, b, e.dmg_health },
        { 255, 255, 255, " damage (" },
        { r, g, b, e.health .. " remaining" },
        { 255, 255, 255, ")" },
        { 255, 255, 255, rhp })
    end
end

local function on_aim_miss(e)
	if ui.get(aimbotlog_enable) and ui.get(on_miss_enable) and e ~= nil then
	local r, g, b = ui.get(on_miss_colour)
    local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local target_name = entity.get_player_name(e.target)
    local reason
    if e.reason == "?" then
    	reason = "resolver"
    else
    	reason = e.reason
    end

        notify.setup_color({ r, g, b })
        notify.add(5, false,
        { 255, 255, 255, "missed " },
        { r, g, b, string.lower(target_name) },
        { 255, 255, 255, "'s " },
        { r, g, b, group },
        { 255, 255, 255, " due to " },
        { r, g, b, reason })
    end
end

client.set_event_callback('aim_fire', on_aim_fire)
client.set_event_callback('player_hurt', on_player_hurt)
client.set_event_callback('aim_miss', on_aim_miss)