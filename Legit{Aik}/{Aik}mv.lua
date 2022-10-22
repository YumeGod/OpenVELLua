local position = ui.new_slider("MISC", "Settings", "Reposition Indicators", 1, 40, 1, true, "x")

local function on_paint()
	for i = ui.get(position),1,-1 
	do 
	   renderer.indicator(255,255,255,0,i)
	end	
end



local eventcallback = client.set_event_callback('paint', on_paint)