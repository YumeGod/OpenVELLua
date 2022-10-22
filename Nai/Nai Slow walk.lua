local checkbox_reference, hotkey_reference = ui.reference("AA", "Other", "Slow motion")
local limit_reference = ui.new_slider("AA", "Other", "Slow motion limit【BY Naijiang】", 10, 57, 50, 57, "", 1, {[57] = "Max"})
local math_sqrt = math.sqrt

local function modify_velocity(cmd, goalspeed)
	if goalspeed <= 0 then
		return
	end
	
	local minimalspeed = math_sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))
	
	if minimalspeed <= 0 then
		return
	end
	
	if cmd.in_duck == 1 then
		goalspeed = goalspeed * 2.94117647 -- wooo cool magic number
	end
	
	if minimalspeed <= goalspeed then
		return
	end
	
	local speedfactor = goalspeed / minimalspeed
	cmd.forwardmove = cmd.forwardmove * speedfactor
	cmd.sidemove = cmd.sidemove * speedfactor
end

local function on_setup_cmd(cmd)	
	local checkbox = ui.get(checkbox_reference)
	local hotkey = ui.get(hotkey_reference)
	local limit = ui.get(limit_reference)
	
	if limit >= 57 then
		return
	end
	
	if checkbox and hotkey then
		modify_velocity(cmd, limit)
	end
end

client.set_event_callback('setup_command', on_setup_cmd)