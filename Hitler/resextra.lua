local safe_ref = ui.reference("PLAYERS", "Adjustments","Override safe point")
local baim_ref = ui.reference("PLAYERS", "Adjustments","Override prefer body aim")
local safekey = ui.new_checkbox("rage","other","Safe-Res")
local acckey = ui.new_checkbox("rage","other","Acc-Res")
local plist_ref = ui.reference("PLAYERS", "Players", "Player list")
local rageom = ui.reference("rage","aimbot","enabled")
local ref_minimum_damage = ui.reference("rage", "aimbot", "Minimum damage")
local health = 0
local ent = ""
local dmg2 = 0

client.color_log(127, 255, 0, "Res-Extra by Hitler Q3487510691")

client.register_esp_flag("Safe", 0, 238, 118, function(e)
    if not ui.get(acckey) then return end
    if not ui.get(safekey) then return end
	local pelvis = { entity.hitbox_position(e, "pelvis") }
	if #pelvis == 3 then
        local _, dmg = client.trace_bullet(entity.get_local_player(), pelvis[1], pelvis[2], pelvis[3], pelvis[1], pelvis[2], pelvis[3])
        health = entity.get_prop(e, "m_iHealth")
        ent = e
        dmg2 =dmg
        if ui.get(safekey) and entity.is_alive(entity.get_local_player()) then
         if not ui.is_menu_open() then
          if not (entity.get_prop(e, "m_iHealth") <= dmg/2*1.9 ) then
            ui.set(plist_ref,e)
            ui.set(safe_ref, "-")
          end
         end
        end
        if ui.get(acckey) and entity.is_alive(entity.get_local_player()) then
            if not ui.is_menu_open() then
            if (entity.get_prop(e, "m_iHealth") <= dmg/2*1.9 ) then
                ui.set(plist_ref,e)
                ui.set(baim_ref, "On")
            else
                ui.set(plist_ref,e)
                ui.set(baim_ref, "-")
            end
            end
          end
		return (entity.get_prop(e, "m_iHealth") <= dmg) 
	end
end)

local function on_paint()
    if ui.get(rageom) and entity.is_alive(entity.get_local_player()) then
        if ui.get(acckey) and ui.get(safekey) then
            renderer.indicator(127, 255, 0, 255,"Hitler's Res-Extra | Both")
        elseif ui.get(acckey) then
            renderer.indicator(127, 255, 0, 255,"Hitler's Res-Extra | Accuracy")
        elseif ui.get(safekey) then
            renderer.indicator(127, 255, 0, 255,"Hitler's Res-Extra | Safety")
        end
    end
end

local function on_fire(c)
    if ui.get(safekey) and entity.is_alive(entity.get_local_player()) then
        if not ui.is_menu_open() then
        if (health <= c.damage) and (health <= dmg2/2*1.9 ) then
         ui.set(plist_ref,ent)
         ui.set(safe_ref, "On")
        else
         ui.set(plist_ref,ent)
         ui.set(safe_ref, "-")
        end
        end
    end
end


client.set_event_callback("aim_fire",on_fire)
client.set_event_callback("paint",on_paint)