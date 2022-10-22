local ui_get, ui_set, ui_reference = ui.get, ui.set, ui.reference
local ui_new_checkbox = ui.new_checkbox
local client_userid_to_entindex = client.userid_to_entindex
local fp_on_nade = ui.new_checkbox("VISUALS", "Effects", "Disable third person on grenade")
local entity_get_local_player = entity.get_local_player
local tp_ref = ui_reference("VISUALS", "Effects", "Force third person (alive)")

local function on_item_equip(e)
	local userid, item, canzoom, hassilencer, issilenced, hastracers, weptype = e.userid, e.item, e.canzoom, e.hassilencer, e.issilenced, e.hastracers, e.weptype

  	if userid == nil then
  	 return
     end
  	if not ui_get(fp_on_nade) then
  	 return
  	  end

      local entindex = client_userid_to_entindex(userid)
    	if entindex == entity_get_local_player() then
			
			if weptype == 9 then
			ui_set(tp_ref, false)

		else

			ui_set(tp_ref, true)

		end
    end
end
client.set_event_callback("item_equip", on_item_equip)