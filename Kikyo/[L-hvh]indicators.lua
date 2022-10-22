-- cache common functions
local renderer = renderer
local line, rectangle, text, measure_text = renderer.line, renderer.rectangle, renderer.text, renderer.measure_text
local get_screen_size, get_latency = client.screen_size, client.latency
local get_local_player, get_prop, get_hitboxpos, get_player_resource = entity.get_local_player, entity.get_prop, entity.hitbox_position, entity.get_player_resource
local min, max, abs, sqrt, floor = math.min, math.max, math.abs, math.sqrt, math.floor
local get, get_mousepos = ui.get, ui.mouse_position
local band = bit.band
local event_callback = client.set_event_callback

local wdei, hdei = get_screen_size( )
local scr = { w = wdei, h = hdei }
local menu_color = ui.reference( "misc", "settings", "menu color" )
local rm, gm, bm, am = ui.get( menu_color )
local choked_ticks = 0
local old_origin = { x=180, y=180, z=180 }
local old_simulation_time = 0
local fdk = ui.reference( "rage", "other", "duck peek assist" )
local dtap, dtk = ui.reference( "rage", "other", "double tap" )
local fbaim = ui.reference( "rage", "other", "force body aim" )
local mindmg = ui.reference( "rage", "aimbot", "minimum damage" )
local safep = ui.reference( "rage", "aimbot", "force safe point" )
local qpa, qpak = ui.reference( "rage", "other", "quick peek assist" )
local fl_am = ui.reference( "aa", "fake lag", "limit" )
local aa_enabled = ui.reference( "aa", "anti-aimbot angles", "enabled" )
local onshot, onshkey = ui.reference( "aa", "other", "on shot anti-aim" )
local fakep, fakeph = ui.reference( "aa", "other", "fake peek" )
local pings, pingsk, pingsa = ui.reference( "misc", "miscellaneous", "ping spike" )
local byaw = ui.reference( "aa", "anti-aimbot angles", "body yaw" )
local max_choked_ticks = ui.reference( "misc", "settings", "sv_maxusrcmdprocessticks" )
local angle = 0

local int = {
    enabled = ui.new_checkbox( "visuals", "other esp", "Indicators" ),
    color = ui.new_color_picker( "visuals", "other esp", "otindc_color", rm, gm, bm, am ),
    options = ui.new_multiselect( "visuals", "other esp", "\n", "Fakelag", "Lag compensation", "Double tap", "Fake duck", "Fake", "On-shot", "Head height", "Ping spike", "Force baim", "Minimum damage", "Safe point", "Quick peek", "Fake peek"),
    max_bar = ui.new_checkbox( "visuals", "other esp", "Maximum bar mode" ),
    statuss = ui.new_combobox( "visuals", "other esp", "Indication type", "Color", "Checkmark" ),
    statuss2 = ui.new_combobox( "visuals", "other esp", "Indication type (amount)", "Bars", "Slider" ),
    hide = ui.new_multiselect( "visuals", "other esp", "Hide", "OG indicators", "Container" )
}
local wnd = {
    x = database.read( "indc_x" ) or 15,
    y = database.read( "indc_y" ) or scr.h/2,
    dragging = false
}
local heights = {
    ["Fakelag"] = 21,
    ["Lag compensation"] = 15,
    ["Fake duck"] = 15,
    ["Double tap"] = 15,
    ["Fake"] = 21,
    ["On-shot"] = 15,
    ["Head height"] = 21,
    ["Ping spike"] = 15,
    ["Force baim"] = 15,
    ["Minimum damage"] = 15,
    ["Quick peek"] = 15,
    ["Safe point"] = 15,
    ["Fake peek"] = 15
}

local function copy_table( original ) -- http://lua-users.org/wiki/CopyTable
    local original_type = type( original )
    local copy
    if original_type == 'table' then
        copy = { }
        for original_key, original_value in next, original, nil do
            copy[ copy_table( original_key ) ] = copy_table( original_value )
        end
        setmetatable( copy, copy_table( getmetatable( original ) ) ) 
    else
        copy = original
    end
    return copy
end

local function tointeger( n )
    return floor( n + 0.5 )
end

local function vec_3( _x, _y, _z ) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end

local function on_ground( ent )
    if band( get_prop( get_local_player( ), "m_fFlags" ), 1 ) == 1 then return true end
    return false
end

local function contains( tbl, val )
    for i = 1, #tbl do
        if tbl[ i ] == val then return true end
    end
    return false
end

local function intersect( x, y, w, h ) 
    local cx, cy = get_mousepos( )
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end
local function conta( x, y, w, h )
    local r, g, b, a = ui.get( int.color )
    if contains( ui.get( int.hide ), "Container" ) == false then
        rectangle( x, y, w, h, 30, 30, 30, 200 )
        rectangle( x+1, y+1, w-2, 1, r, g, b, 255 )
    end
end
local function rendind( x, y, max, value, size, r, g, b, a, name )
    if ui.get( int.statuss2 ) == "Bars" then
        if value > 1 then value = value + 1 end
        if value+1 > max then value = max+1 end
        for i=1, max do
            rectangle( x+( size+2 )*i-( size+2 ), y+12, size, 5, 15, 15, 15, 150 )
        end
        for i=1, value do
            if i < value then i = i+1 end
            rectangle( x+( size+2 )*i-( size+2 )*2, y+12, size, 5, r, g, b, 180 )
        end
    elseif ui.get( int.statuss2 ) == "Slider" then
        if value-2 > max then value = max end
        if value-2 < 0 then value = 2 end
        rectangle( x, y+12, max, 5, 15, 15, 15, 150 )
        rectangle( x+1, y+13, value-2, 3, r, g, b, 150 )
    end
    if name ~= "" and name ~= " " and name ~= nil then
        text( x, y-1, 255, 255, 255, 255, "-", 0, name )
    end
end
local function renstatus( x, y, size, state, type )
    local r, g, b, a = ui.get( int.color )
    line( state and x-size/2 or x-size/2, state and y-size/2 or y-size, state and x or x+size/2, y, state and r or 255, state and g or 20, state and b or 0, 255 )
    line( state and x-1 or x-size/2, y, state and x+size-2 or x+size/2, state and y-size-1 or y-size, state and r or 255, state and g or 20, state and b or 0, 255 )
end
local render = { container = conta, indication = rendind, status = renstatus }

local function menu( )
    ui.set_visible( int.options, ui.get( int.enabled ) )
    ui.set_visible( int.statuss, ui.get( int.enabled ) )
    ui.set_visible( int.max_bar, ui.get( int.enabled ) )
    ui.set_visible( int.hide, ui.get( int.enabled ) )
    ui.set_visible( int.statuss2, ui.get( int.enabled ) )
end

ui.set_callback( int.enabled, menu )
menu( )

event_callback( "setup_command", function( cmd ) 
    choked_ticks = cmd.chokedcommands/2 > 2 and cmd.chokedcommands or 0 
    local origin = vec_3( get_prop( get_local_player( ), "m_vecOrigin" ) )
    local simulation_time = get_prop( get_local_player( ), "m_flSimulationTime" )
    if ( simulation_time ~= old_simulation_time ) then
        origin_delta = vec_3( origin.x - old_origin.x, origin.y - old_origin.y, origin.z - old_origin.z )
        old_origin = copy_table( origin )
	    old_simulation_time = simulation_time
    end
    if cmd.chokedcommands == 0 then
		angle = cmd.in_use == 0 and ui.get( aa_enabled ) and ui.get( byaw ) ~= "Off" and min( 57, abs( get_prop( get_local_player( ), "m_flPoseParameter", 11 )*120-60 ) ) or 0
	end
end )

local function on_paint( )
    if ui.get( int.enabled ) ~= true then return end
    if contains( ui.get( int.hide ), "OG indicators" ) then
        for i = 1, 50 do
            renderer.indicator( 255, 255, 255, 0, i)
        end
    end

    local r, g, b, a = ui.get( int.color )
    local left_click = client.key_state( 0x01 )
    local cx, cy = get_mousepos( )
    local options = ui.get( int.options )
    local width, height = 116, 3

    local min_dmg = ui.get( mindmg )
    local origin = vec_3( get_prop( get_local_player( ), "m_vecOrigin" ) )
    local velocity_prop = vec_3( entity.get_prop( get_local_player( ), "m_vecVelocity" ) )
    local velocity = sqrt( velocity_prop.x * velocity_prop.x + velocity_prop.y * velocity_prop.y ) or 0
    local trace_fraction, trace_entity = client.trace_line( 1, origin.x, origin.y, origin.z, origin.x, origin.y, origin.z - 24.97 )
    local _, _, orig_z = get_prop( get_local_player( ), "m_vecAbsOrigin" )
    local _, _, head_z = get_hitboxpos( get_local_player( ), 0 )
    if orig_z ~= nil and head_z ~= nil then
        if head_z ~= head_z_old then
            head_z_old = head_z
            local duck_am = get_prop( get_local_player( ), "m_flDuckAmount" ) or 0
        end
    end
    local headp_delta = head_z - orig_z + ( duckam or 0 )*12 or 0
    local h_min, h_max = 55, 70
    local headp = max( 0, min( 1, 1-( headp_delta-h_min )/( headp_delta-h_max ) ) )
    if entity.is_alive( get_local_player( ) ) ~= true then 
        choked_ticks = 0 
        angle = 0
        headp = 0
    end
    local bar_max, bar_fake, bar_headh, bar_ticks = 9, tointeger( angle )/6.666666666666667, floor( 9*headp ), tointeger( choked_ticks/1.5 )
    local lc = { r = 255, g = 0, b = 0, state = false }
    local dt = { r = 255, g = 0, b = 0, state = false }
    local fk = { r = 255, g = 0, b = 0 }
    if entity.is_alive( get_local_player( ) ) then
        if trace_fraction < 1 and not on_ground( get_local_player( ) ) or velocity > 270 and origin_delta ~= nil then
            if sqrt( origin_delta.x * origin_delta.x + origin_delta.y * origin_delta.y ) > 64 then
                lc.r = r
                lc.g = g
                lc.b = b
                lc.state = true
            end
        end
    end
    if ui.get( dtap ) and ui.get( dtk ) then
        dt.r = r
        dt.g = g
        dt.b = b
        dt.state = true
    end
    if angle > 38 then
        fk.r = r
        fk.g = g
        fk.b = b
    elseif angle < 39 and angle > 15 then
        fk.r = 255
        fk.g = 150
        fk.b = 0
    end

    if ui.is_menu_open( ) then 
        if wnd.dragging and not left_click then
            wnd.dragging = false
        end
    
        if wnd.dragging and left_click then
            wnd.x = cx - wnd.drag_x
            wnd.y = cy - wnd.drag_y
        end
    
        if intersect( wnd.x, wnd.y, width, 25 ) and left_click then 
            wnd.dragging = true
            wnd.drag_x = cx - wnd.x
            wnd.drag_y = cy - wnd.y
        end
    end

    for i=1, #options do 
        option = options[ i ]
        if heights[ option ] ~= nil then
            height = height + heights[ option ]+1
        end
    end
    if ui.get( int.statuss2 ) == "Slider" then
        bar_max = width-10
    end

    if ui.get( int.max_bar ) then 
        bar_ticks = choked_ticks
        bar_fake = angle/4.285714285714286
        bar_headh = floor( 14*headp )
        width = 176
        bar_max = 14
    end
    if ui.get( int.statuss2 ) == "Slider" then
        width = 116
        bar_max = width-10
        bar_ticks = choked_ticks*8.285714285714286
        bar_fake = angle*1.93
        bar_headh = floor( bar_max*headp )
    end

    if ui.get( mindmg ) > 100 then 
        min_dmg = string.format( "HP  +  %s", ui.get( mindmg )-100 )
    elseif ui.get( mindmg ) == 0 then
        min_dmg = "AUTO"
    end

    local indic = { x = wnd.x + 5, y = wnd.y + 5 }
    render.container( wnd.x, wnd.y, width, height )
    for i=1, #options do
        option = options[ i ]
        if option == "Fakelag" then
            render.indication( indic.x, indic.y, bar_max, bar_ticks, 10, r, g, b, 255, string.format( "CHOKED  -  %s", choked_ticks ) )
        elseif option == "Lag compensation" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, lc.r, lc.g, lc.b, 255, "-", 0, "LAG COMPENSATION" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "LAG COMPENSATION" )
                render.status( indic.x+width-15, indic.y+8, 5, lc.state )
            end
        elseif option == "Fake duck" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, ui.get( fdk ) and on_ground( get_local_player( ) ) and r or 255, ui.get( fdk ) and on_ground( get_local_player( ) ) and g or 0, ui.get( fdk ) and on_ground( get_local_player( ) ) and b or 0, 255, "-", 0, "FAKE DUCK" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "FAKE DUCK" )
                render.status( indic.x+width-15, indic.y+8, 5, ui.get( fdk ) and on_ground( get_local_player( ) ) )
            end
        elseif option == "Double tap" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, dt.r, dt.g, dt.b, 255, "-", 0, "DOUBLE TAP" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "DOUBLE TAP" )
                render.status( indic.x+width-15, indic.y+8, 5, dt.state )
            end
        elseif option == "Fake" then
            render.indication( indic.x, indic.y, bar_max, bar_fake, 10, fk.r, fk.g, fk.b, 255, string.format( "FAKE  -  %s", tointeger( angle ) ) )
        elseif option == "On-shot" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, ui.get( aa_enabled ) and ui.get( onshot ) and ui.get( onshkey ) and r or 255, ui.get( aa_enabled ) and ui.get( onshot ) and ui.get( onshkey ) and g or 0, ui.get( aa_enabled ) and ui.get( onshot ) and ui.get( onshkey ) and b or 0, 255, "-", 0, "ON-SHOT" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "ON-SHOT" )
                render.status( indic.x+width-15, indic.y+8, 5, ui.get( aa_enabled ) and ui.get( onshot ) and ui.get( onshkey ) )
            end
        elseif option == "Head height" then
            render.indication( indic.x, indic.y, bar_max, bar_headh, 10, r, g, b, 255, "HEAD HEIGHT" )
        elseif option == "Ping spike" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, ui.get( pings ) and ui.get( pingsk ) and r or 255, ui.get( pings ) and ui.get( pingsk ) and g or 0, ui.get( pings ) and ui.get( pingsk ) and b or 0, 255, "-", 0, "PING" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "PING" )
                render.status( indic.x+width-15, indic.y+8, 5, ui.get( pings ) and ui.get( pingsk ) )
            end
        elseif option == "Force baim" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, ui.get( fbaim ) and r or 255, ui.get( fbaim ) and g or 0, ui.get( fbaim ) and b or 0, 255, "-", 0, "BAIM" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "BAIM" )
                render.status( indic.x+width-15, indic.y+8, 5, ui.get( fbaim ) )
            end
        elseif option == "Minimum damage" then
            text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "DAMAGE" )
            text( indic.x + width - 15 - measure_text( "-", min_dmg ), indic.y, 255, 255, 255, 255, "-", 0, min_dmg )
        elseif option == "Quick peek" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, ui.get( qpa ) and ui.get( qpak ) and r or 255, ui.get( qpa ) and ui.get( qpak ) and g or 0, ui.get( qpa ) and ui.get( qpak ) and b or 0, 255, "-", 0, "QUICK PEEK" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "QUICK PEEK" )
                render.status( indic.x+width-15, indic.y+8, 5, ui.get( qpa ) and ui.get( qpak ) )
            end
        elseif option == "Safe point" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, ui.get( safep ) and r or 255, ui.get( safep ) and g or 0, ui.get( safep ) and b or 0, 255, "-", 0, "SAFE-POINT" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "SAFE-POINT" )
                render.status( indic.x+width-15, indic.y+8, 5, ui.get( safep ) )
            end
        elseif option == "Fake peek" then
            if ui.get( int.statuss ) == "Color" then
                text( indic.x, indic.y, ui.get( fakep ) and ui.get( fakeph ) and r or 255, ui.get( fakep ) and ui.get( fakeph ) and g or 0, ui.get( fakep ) and ui.get( fakeph ) and b or 0, 255, "-", 0, "FAKE PEEK" )
            else
                text( indic.x, indic.y, 255, 255, 255, 255, "-", 0, "FAKE PEEK" )
                render.status( indic.x+width-15, indic.y+8, 5, ui.get( fakep ) and ui.get( fakeph ) )
            end
        end
        if heights[option] ~= nil then
            indic.y = indic.y + ( heights[ option ]+1 )
        end
    end
end

event_callback( "paint", on_paint )

event_callback( "shutdown", function( )
    database.write( "indc_x", wnd.x )
    database.write( "indc_y", wnd.y )
end )
