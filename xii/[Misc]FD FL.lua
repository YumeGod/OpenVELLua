local fakelag = { ui.reference("AA", "Fake lag", "Enabled") }
local fakelag_limit = ui.reference("AA", "Fake lag", "Limit")
local fakeduck = ui.reference("Rage", "Other", "Duck peek assist")
local fdfl = ui.new_slider("AA", "Fake lag", "Fake lag on FD", 1, 14, 14)
local bool = true
local limit = 1
client.set_event_callback("net_update_end", function()
    if not ui.get(fakelag[1] or fakelag[2]) then return end
    if bool then
        limit = ui.get(fakelag_limit)
    end
    if ui.get(fakeduck) then
        bool = false
        ui.set(fakelag_limit, ui.get(fdfl))
    else
        bool = true
        ui.set(fakelag_limit, limit)
    end
end)