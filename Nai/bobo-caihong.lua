local ffi = require("ffi")
local type=type;local setmetatable=setmetatable;local tostring=tostring;local a=math.pi;local b=math.min;local c=math.max;local d=math.deg;local e=math.rad;local f=math.sqrt;local g=math.sin;local h=math.cos;local i=math.atan;local j=math.acos;local k=math.fmod;local l={}l.__index=l;function Vector3(m,n,o)if type(m)~="number"then m=0.0 end;if type(n)~="number"then n=0.0 end;if type(o)~="number"then o=0.0 end;m=m or 0.0;n=n or 0.0;o=o or 0.0;return setmetatable({x=m,y=n,z=o},l)end;function l.__eq(p,q)return p.x==q.x and p.y==q.y and p.z==q.z end;function l.__unm(p)return Vector3(-p.x,-p.y,-p.z)end;function l.__add(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x+q.x,p.y+q.y,p.z+q.z)elseif r=="table"and s=="number"then return Vector3(p.x+q,p.y+q,p.z+q)elseif r=="number"and s=="table"then return Vector3(p+q.x,p+q.y,p+q.z)end end;function l.__sub(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x-q.x,p.y-q.y,p.z-q.z)elseif r=="table"and s=="number"then return Vector3(p.x-q,p.y-q,p.z-q)elseif r=="number"and s=="table"then return Vector3(p-q.x,p-q.y,p-q.z)end end;function l.__mul(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x*q.x,p.y*q.y,p.z*q.z)elseif r=="table"and s=="number"then return Vector3(p.x*q,p.y*q,p.z*q)elseif r=="number"and s=="table"then return Vector3(p*q.x,p*q.y,p*q.z)end end;function l.__div(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x/q.x,p.y/q.y,p.z/q.z)elseif r=="table"and s=="number"then return Vector3(p.x/q,p.y/q,p.z/q)elseif r=="number"and s=="table"then return Vector3(p/q.x,p/q.y,p/q.z)end end;function l.__tostring(p)return"( "..p.x..", "..p.y..", "..p.z.." )"end;function l:clear()self.x=0.0;self.y=0.0;self.z=0.0 end;function l:unpack()return self.x,self.y,self.z end;function l:length_2d_sqr()return self.x*self.x+self.y*self.y end;function l:length_sqr()return self.x*self.x+self.y*self.y+self.z*self.z end;function l:length_2d()return f(self:length_2d_sqr())end;function l:length()return f(self:length_sqr())end;function l:dot(t)return self.x*t.x+self.y*t.y+self.z*t.z end;function l:cross(t)return Vector3(self.y*t.z-self.z*t.y,self.z*t.x-self.x*t.z,self.x*t.y-self.y*t.x)end;function l:dist_to(t)return(t-self):length()end;function l:is_zero(u)u=u or 0.001;if self.x<u and self.x>-u and self.y<u and self.y>-u and self.z<u and self.z>-u then return true end;return false end;function l:normalize()local v=self:length()if v<=0.0 then return 0.0 end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v;return v end;function l:normalize_no_len()local v=self:length()if v<=0.0 then return end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v end;function l:normalized()local v=self:length()if v<=0.0 then return Vector3()end;return Vector3(self.x/v,self.y/v,self.z/v)end;function clamp(w,x,y)if w<x then return x elseif w>y then return y end;return w end;function normalize_angle(z)local A;local B;B=tostring(z)if B=="nan"or B=="inf"then return 0.0 end;if z>=-180.0 and z<=180.0 then return z end;A=k(k(z+360.0,360.0),360.0)if A>180.0 then A=A-360.0 end;return A end;function vector_to_angle(C)local v;local D;local E;v=C:length()if v>0.0 then D=d(i(-C.z,v))E=d(i(C.y,C.x))else if C.x>0.0 then D=270.0 else D=90.0 end;E=0.0 end;return Vector3(D,E,0.0)end;function angle_forward(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))return Vector3(G*I,G*H,-F)end;function angle_right(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(-1.0*J*F*I+-1.0*K*-H,-1.0*J*F*H+-1.0*K*I,-1.0*J*G)end;function angle_up(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(K*F*I+-J*-H,K*F*H+-J*I,K*G)end;function get_FOV(L,M,N)local O;local P;local Q;local R;P=angle_forward(L)Q=(N-M):normalized()R=j(P:dot(Q)/Q:length())return c(0.0,d(R))end
ffi.cdef[[
    typedef struct  {
		float x;
		float y;
		float z;	
	}vec3_t;
    struct beam_info_t {
        int			m_type;
        void* m_start_ent;
        int			m_start_attachment;
        void* m_end_ent;
        int			m_end_attachment;
        vec3_t		m_start;
        vec3_t		m_end;
        int			m_model_index;
        const char	*m_model_name;
        int			m_halo_index;
        const char	*m_halo_name;
        float		m_halo_scale;
        float		m_life;
        float		m_width;
        float		m_end_width;
        float		m_fade_length;
        float		m_amplitude;
        float		m_brightness;
        float		m_speed;
        int			m_start_frame;
        float		m_frame_rate;
        float		m_red;
        float		m_green;
        float		m_blue;
        bool		m_renderable;
        int			m_num_segments;
        int			m_flags;
        vec3_t		m_center;
        float		m_start_radius;
        float		m_end_radius;
    };
    typedef void (__thiscall* draw_beams_t)(void*, void*);
    typedef void*(__thiscall* create_beam_points_t)(void*, struct beam_info_t&);
]]

local render_beams_signature = "\xB9\xCC\xCC\xCC\xCC\xA1\xCC\xCC\xCC\xCC\xFF\x10\xA1\xCC\xCC\xCC\xCC\xB9"
local match = client.find_signature("client_panorama.dll", render_beams_signature) or error("render_beams_signature not found")
local render_beams = ffi.cast('void**', ffi.cast("char*", match) + 1)[0] or error("render_beams is nil") 
local render_beams_class = ffi.cast("void***", render_beams)
local render_beams_vtbl = render_beams_class[0]

local draw_beams = ffi.cast("draw_beams_t", render_beams_vtbl[6]) or error("couldn't cast draw_beams_t", 2)
local create_beam_points = ffi.cast("create_beam_points_t", render_beams_vtbl[12]) or error("couldn't cast create_beam_points_t", 2)

local local_player_bullet_beams = ui.new_checkbox("visuals", "Effects", "Local player bullet beams")
local local_player_bullet_beams_color = ui.new_color_picker("visuals", "Effects", "Local player bullet beams color", 150, 130, 255, 255)
local local_player_bullet_beams_style = ui.new_combobox("visuals", "effects", "\nstyle", {"Skeet", "Beam", "Bubble"})
local local_player_bullet_beams_thickness = ui.new_slider("visuals", "effects", "Tracer thickness", 0, 50, 20,  true, nil, .1)
local local_player_beam_life = ui.new_slider("visuals", "effects", "Beam life", 1, 10)


local enemy_bullet_beams = ui.new_checkbox("visuals", "Effects", "Enemy player bullet beams")
local enemy_bullet_beams_color = ui.new_color_picker("visuals", "Effects", "Enemy player bullet beams color", 150, 130, 255, 255)
local enemy_bullet_beams_style = ui.new_combobox("visuals", "effects", "\nenemystyle", {"Skeet", "Beam", "Bubble"})
local enemy_bullet_beams_thickness = ui.new_slider("visuals", "effects", "Enemy tracer thickness", 0, 50, 20,  true, nil, .1)
local enemy_beam_life = ui.new_slider("visuals", "effects", "Enemy beam life", 1, 10)



local local_player_trails = ui.new_checkbox("visuals", "Effects", "Local player trails")
local local_player_trails_color = ui.new_color_picker("visuals", "Effects", "Local player trails color", 150, 130, 255, 255)
local rainbow = ui.new_checkbox("visuals", "Effects", "Local player rainbow trail")
local local_player_trails_height = ui.new_slider("visuals", "effects", "Trail height", 1, 100, 20)
local local_player_trails_thickness = ui.new_slider("visuals", "effects", "Trail thickness", 0, 50, 20,  true, nil, .1)
local local_player_trails_life = ui.new_slider("visuals", "effects", "Trail life", 1, 10)


local get_local_player = entity.get_local_player
local get_prop = entity.get_prop
local userid_to_entindex = client.userid_to_entindex
local eye_position = client.eye_position
local bor = bit.bor
local new = ffi.new
local get = ui.get






local function updateMenu()
	ui.set_visible(local_player_trails_thickness, get(local_player_trails))
	ui.set_visible(local_player_trails_color, get(local_player_trails))
	ui.set_visible(rainbow, get(local_player_trails))
	ui.set_visible(local_player_trails_height, get(local_player_trails))
	ui.set_visible(local_player_trails_life, get(local_player_trails))
	

	ui.set_visible(enemy_bullet_beams_color, get(enemy_bullet_beams))
	ui.set_visible(enemy_bullet_beams_style, get(enemy_bullet_beams))
	ui.set_visible(enemy_bullet_beams_thickness, get(enemy_bullet_beams))
	ui.set_visible(enemy_beam_life, get(enemy_bullet_beams))
	

	ui.set_visible(local_player_bullet_beams_color, get(local_player_bullet_beams))
	ui.set_visible(local_player_bullet_beams_style, get(local_player_bullet_beams))
	ui.set_visible(local_player_bullet_beams_thickness, get(local_player_bullet_beams))
	ui.set_visible(local_player_beam_life, get(local_player_bullet_beams))
end
updateMenu()

ui.set_callback(local_player_trails, function() updateMenu() end)
ui.set_callback(enemy_bullet_beams, function() updateMenu() end)
ui.set_callback(local_player_bullet_beams, function() updateMenu() end)

local function create_beams(beamtype, startpos,endpos, red, green, blue, alpha, thicc, dalife)
    local beam_info = new("struct beam_info_t")
    beam_info.m_type = 0x00
    beam_info.m_model_index = -1
    beam_info.m_halo_scale = 0

    beam_info.m_life = dalife
    beam_info.m_fade_length = 1

    beam_info.m_width = thicc -- multiplication is faster than division
    beam_info.m_end_width = thicc -- multiplication is faster than division
	
	beam_info.m_model_name = beamtype
    

    beam_info.m_amplitude = 2.3
    beam_info.m_speed = 0.2

    beam_info.m_start_frame = 0
    beam_info.m_frame_rate = 0

    beam_info.m_red = red 
    beam_info.m_green = green
    beam_info.m_blue = blue
    beam_info.m_brightness = alpha

    beam_info.m_num_segments = 2
    beam_info.m_renderable = true

    beam_info.m_flags = bor(0x00000100 + 0x00000200 + 0x00008000)

    beam_info.m_start = startpos
    beam_info.m_end = endpos

    local beam = create_beam_points(render_beams_class, beam_info) 
    if beam ~= nil then 
        draw_beams(render_beams, beam)
    end
end




local function hsv_to_rgb(h, s, v, a)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255, a * 255
end

local function func_rgb_rainbowize(frequency, rgb_split_ratio)
    local r, g, b, a = hsv_to_rgb(globals.realtime() * frequency, 1, 1, 1)

    r = r * rgb_split_ratio
    g = g * rgb_split_ratio
    b = b * rgb_split_ratio

    return r, g, b
end


	

client.set_event_callback("paint", function(c)
	if get(local_player_trails)  and entity.is_alive(entity.get_local_player()) then
	
		local vx,vy,vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
		local flVelocity = math.sqrt(vx ^ 2 + vy ^ 2 )
		local u = math.sqrt(vz^2)
		--client.log(u)
		if (flVelocity >= 10 or u >= 1) then
			local onground = (bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1)
			local pos = Vector3(entity.get_prop(entity.get_local_player(), "m_vecAbsOrigin"))
			local pos2 = Vector3(entity.get_prop(entity.get_local_player(), "m_vecAbsOrigin"))
			local height = get(local_player_trails_height)
			pos2.z = pos2.z + height
			local r,g,b,a = get(local_player_trails_color)
			if (get(rainbow)) then
					r, g, b = func_rgb_rainbowize(1, 1)
					create_beams("sprites/physbeam.vmt",pos,pos2, r,g,b,a, get(local_player_trails_thickness), get(local_player_trails_life))
			else
				create_beams("sprites/physbeam.vmt",pos,pos2, r,g,b,a, get(local_player_trails_thickness), get(local_player_trails_life))
			end
		end
	end
end)





local oldTick = 0
client.set_event_callback("bullet_impact", function(e)
	if (oldTick < globals.tickcount()) then
		oldTick = globals.tickcount()
		local beamtype = "sprites/purplelaser1.vmt" 
		if get(local_player_bullet_beams_style) == "Skeet" then 
			beamtype = "sprites/purplelaser1.vmt"    
		elseif get(local_player_bullet_beams_style) == "Beam" then 
			beamtype = "sprites/physbeam.vmt"
		elseif get(local_player_bullet_beams_style) == "Bubble" then 
			beamtype = "sprites/bubble.vmt"
		end
		if userid_to_entindex(e.userid) == get_local_player() and get(local_player_bullet_beams) then 
			local r,g,b,a = get(local_player_bullet_beams_color)
			create_beams(beamtype, {e.x, e.y, e.z},Vector3(eye_position()), r, g, b, a, get(local_player_bullet_beams_thickness), get(local_player_beam_life))
		end
	end
	if userid_to_entindex(e.userid) ~= get_local_player() and get(enemy_bullet_beams) and entity.is_enemy(userid_to_entindex(e.userid)) then 
		local er,eg,eb,ea = get(enemy_bullet_beams_color)
		local ebeamtype = "sprites/purplelaser1.vmt" 
		if get(enemy_bullet_beams_style) == "Skeet" then 
			ebeamtype = "sprites/purplelaser1.vmt"    
		elseif get(enemy_bullet_beams_style) == "Beam" then 
			ebeamtype = "sprites/physbeam.vmt"
		elseif get(enemy_bullet_beams_style) == "Bubble" then 
			ebeamtype = "sprites/bubble.vmt"
		end
		create_beams(ebeamtype, {e.x, e.y, e.z},Vector3(entity.hitbox_position(client.userid_to_entindex(e.userid), 13)), er,eg,eb,ea, get(enemy_bullet_beams_thickness), get(enemy_beam_life))
	end
end)

client.set_event_callback("player_connect_full", function(e)
	if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
		return
	end
    oldTick = 0
end)