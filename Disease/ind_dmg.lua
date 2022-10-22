local mindmg = ui.reference("RAGE", "Aimbot", "Minimum damage")

client.set_event_callback("paint", function()
    local dmg = ui.get(mindmg)
    renderer.indicator(218, 112, 214, 193, "D1sease: "..((dmg > 100) and ("HP+"..(dmg-100)) or dmg))
end)