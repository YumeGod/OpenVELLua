local cmdticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")

local function visibleElements()
    ui.set_visible(cmdticks, true)
end

client.set_event_callback("run_command", visibleElements)