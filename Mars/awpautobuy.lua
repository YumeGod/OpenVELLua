local ui_get = ui.get
local console_cmd = client.exec

local auto_buy_awp = ui.new_checkbox("MISC", "Miscellaneous", "Auto buy AWP")

local function on_round_prestart(e)
	if ui_get(auto_buy_awp) then
		console_cmd("buy awp")
	end
end

client.set_event_callback("round_prestart", on_round_prestart)