-- Copyright (c) 2019 Localplayer
-- See the file LICENSE for copying permission.
-- Priortize targets v1.0
-- Prioritize a player with a specific flag

--VECTOR LIBRARY
local type=type;local setmetatable=setmetatable;local tostring=tostring;local a=math.pi;local b=math.min;local c=math.max;local d=math.deg;local e=math.rad;local f=math.sqrt;local g=math.sin;local h=math.cos;local i=math.atan;local j=math.acos;local k=math.fmod;local l={}l.__index=l;function Vector3(m,n,o)if type(m)~="number"then m=0.0 end;if type(n)~="number"then n=0.0 end;if type(o)~="number"then o=0.0 end;m=m or 0.0;n=n or 0.0;o=o or 0.0;return setmetatable({x=m,y=n,z=o},l)end;function l.__eq(p,q)return p.x==q.x and p.y==q.y and p.z==q.z end;function l.__unm(p)return Vector3(-p.x,-p.y,-p.z)end;function l.__add(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x+q.x,p.y+q.y,p.z+q.z)elseif r=="table"and s=="number"then return Vector3(p.x+q,p.y+q,p.z+q)elseif r=="number"and s=="table"then return Vector3(p+q.x,p+q.y,p+q.z)end end;function l.__sub(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x-q.x,p.y-q.y,p.z-q.z)elseif r=="table"and s=="number"then return Vector3(p.x-q,p.y-q,p.z-q)elseif r=="number"and s=="table"then return Vector3(p-q.x,p-q.y,p-q.z)end end;function l.__mul(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x*q.x,p.y*q.y,p.z*q.z)elseif r=="table"and s=="number"then return Vector3(p.x*q,p.y*q,p.z*q)elseif r=="number"and s=="table"then return Vector3(p*q.x,p*q.y,p*q.z)end end;function l.__div(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x/q.x,p.y/q.y,p.z/q.z)elseif r=="table"and s=="number"then return Vector3(p.x/q,p.y/q,p.z/q)elseif r=="number"and s=="table"then return Vector3(p/q.x,p/q.y,p/q.z)end end;function l.__tostring(p)return"( "..p.x..", "..p.y..", "..p.z.." )"end;function l:clear()self.x=0.0;self.y=0.0;self.z=0.0 end;function l:unpack()return self.x,self.y,self.z end;function l:length_2d_sqr()return self.x*self.x+self.y*self.y end;function l:length_sqr()return self.x*self.x+self.y*self.y+self.z*self.z end;function l:length_2d()return f(self:length_2d_sqr())end;function l:length()return f(self:length_sqr())end;function l:dot(t)return self.x*t.x+self.y*t.y+self.z*t.z end;function l:cross(t)return Vector3(self.y*t.z-self.z*t.y,self.z*t.x-self.x*t.z,self.x*t.y-self.y*t.x)end;function l:dist_to(t)return(t-self):length()end;function l:is_zero(u)u=u or 0.001;if self.x<u and self.x>-u and self.y<u and self.y>-u and self.z<u and self.z>-u then return true end;return false end;function l:normalize()local v=self:length()if v<=0.0 then return 0.0 end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v;return v end;function l:normalize_no_len()local v=self:length()if v<=0.0 then return end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v end;function l:normalized()local v=self:length()if v<=0.0 then return Vector3()end;return Vector3(self.x/v,self.y/v,self.z/v)end;function clamp(w,x,y)if w<x then return x elseif w>y then return y end;return w end;function normalize_angle(z)local A;local B;B=tostring(z)if B=="nan"or B=="inf"then return 0.0 end;if z>=-180.0 and z<=180.0 then return z end;A=k(k(z+360.0,360.0),360.0)if A>180.0 then A=A-360.0 end;return A end;function vector_to_angle(C)local v;local D;local E;v=C:length()if v>0.0 then D=d(i(-C.z,v))E=d(i(C.y,C.x))else if C.x>0.0 then D=270.0 else D=90.0 end;E=0.0 end;return Vector3(D,E,0.0)end;function angle_forward(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))return Vector3(G*I,G*H,-F)end;function angle_right(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(-1.0*J*F*I+-1.0*K*-H,-1.0*J*F*H+-1.0*K*I,-1.0*J*G)end;function angle_up(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(K*F*I+-J*-H,K*F*H+-J*I,K*G)end;function get_FOV(L,M,N)local O;local P;local Q;local R;P=angle_forward(L)Q=(N-M):normalized()R=j(P:dot(Q)/Q:length())return c(0.0,d(R))end
--region gs_api
--region Client
local client_camera_angles, client_latency, client_screen_size, client_set_event_callback, entity_get_local_player, entity_get_player_resource, entity_get_player_weapon, entity_get_prop, entity_hitbox_position, entity_is_alive, globals_chokedcommands, globals_curtime, globals_tickcount, globals_tickinterval, math_abs, math_ceil, math_floor, math_max, math_min, renderer_gradient, renderer_indicator, renderer_load_svg, renderer_measure_text, renderer_rectangle, renderer_text, renderer_texture, table_insert, tonumber, unpack, pairs, type = client.camera_angles, client.latency, client.screen_size, client.set_event_callback, entity.get_local_player, entity.get_player_resource, entity.get_player_weapon, entity.get_prop, entity.hitbox_position, entity.is_alive, globals.chokedcommands, globals.curtime, globals.tickcount, globals.tickinterval, math.abs, math.ceil, math.floor, math.max, math.min, renderer.gradient, renderer.indicator, renderer.load_svg, renderer.measure_text, renderer.rectangle, renderer.text, renderer.texture, table.insert, tonumber, unpack, pairs, type

local dragging = (function() local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider("LUA","A",u.." window position",0,x,v/j*x)local z=ui.new_slider("LUA","A","\n"..u.." window position y",0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;client.set_event_callback("paint",function()c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end)function a.drag(q,r,A,B,C,D,E)if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end;if E then end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
local ui_lib = (function() local function a(b,c,d,e)c=c or""d=d or 1;e=e or#b;local f=""for g=d,e do f=f..c..tostring(b[g])end;return f end;local function h(b,i)for g=1,#b do if b[g]==i then return true end end;return false end;local function j(k,...)if not k then error(a({...}),3)end end;local function l(b)local m,n=false,false;for o,k in pairs(b)do if type(o)=="number"then m=true else n=true end end;return m,n end;local p=globals.realtime()local q={}local r={}local s={}local function t(b)local u=false;for o,k in pairs(b)do if getmetatable(k)==s then u=true end end;return u end;local function v(k,w)return k~=q[w].default end;local function x(k)return#k>0 end;function s.__index(w,o)if q[w]~=nil and type(o)=="string"and o:sub(1,1)~="_"then return q[w][o]or r[o]end end;function s.__call(w,...)local y={...}if globals.realtime()==p and#y==1 and type(y[1])=="table"then local z={}local A=y[1]local B=false;local C=false;local D={}for o,k in pairs(A)do if type(o)~="number"then D[o]=k;C=true end end;if A[1]~=nil and(type(A[1])~="table"or not t(A[1]))then D[1]=A[1]B=true;if type(D[1])~="table"then D[1]={D[1]}end end;if C then table.insert(z,D)end;for g=B and 2 or 1,#A do if t(A[g])then table.insert(z,A[g])end end;for g=1,#z do local E=z[g]local k;if E[1]~=nil then k=E[1]end;for o,F in pairs(E)do if o~=1 then w:add_children(F,k,o)end end end;return w end;if#y==0 then return w:get()else local G,H=pcall(ui.set,y[1].reference,select(2,unpack(y)))end end;function s.__tostring(w)return"Menu item: "..w.tab.." - "..w.container.." - "..w.name end;function r.new(I,J,K,L,...)local y={...}local M,N;local O;if type(I)=="function"and I~=ui.reference then for o,k in pairs(ui)do if k==I and o:sub(1,4)=="new_"then O=o:sub(5,-1)end end;local G;G,M=pcall(I,J,K,L,unpack(y))if not G then error(M,2)end;N=I==ui.reference else M=I;N=true end;if O==nil then local k={pcall(ui.get,M)}if k[1]==false then O="button"else k={select(2,unpack(k))}if#k==1 then local P=type(k[1])if P=="string"then local G=pcall(ui.set,M,nil)ui.set(M,k[1])O=G and"textbox"or"combobox"elseif P=="number"then local G=pcall(ui.set,M,-9999999999999999)ui.set(M,k[1])O=G and"listbox"or"slider"elseif P=="boolean"then O="checkbox"elseif P=="table"then O="multiselect"end elseif#k>=2 and type(k[1])=="boolean"and type(k[2])=="number"then O="hotkey"elseif#k==4 then if type(k[1])=="number"and type(k[2])=="number"and type(k[3])=="number"and type(k[4])=="number"then O="color_picker"end end end end;local Q;if N==false and O~=nil then if O=="slider"then Q=y[3]or y[1]elseif O=="combobox"then Q=y[1][1]elseif O=="checkbox"then Q=false end end;local w={}q[w]={tab=J,container=K,name=L,reference=M,type=O,default=Q,visible=true,ui_callback=nil,callbacks={},is_gamesense_reference=N,children_values={},children_callbacks={}}if N==false and O~=nil then if O=="slider"then q[w].min=y[1]q[w].max=y[2]elseif O=="combobox"or O=="multiselect"or O=="listbox"then q[w].values=y[1]end end;return setmetatable(w,s)end;function r:set(...)local R={...}local S=q[self]local T={pcall(ui.set,S.reference,unpack(R))}end;function r:get()local S=q[self]return ui.get(S.reference)end;function r:contains(k)local S=q[self]if S.type=="multiselect"then return h(ui.get(S.reference),k)elseif S.type=="combobox"then return ui.get(S.reference)==k else error(string.format("Invalid type %s for contains",S.type),2)end end;function r:as_keys()local S=q[self]if S.type=="multiselect"then local k=ui.get(S.reference)local f={}for g=1,#k do f[k[g]]=true end;return f elseif S.type=="combobox"then return{[ui.get(S.reference)]=true}else error(string.format("Invalid type %s for as_keys",S.type),2)end end;function r:set_visible(U)local S=q[self]if S==nil then error("Invalid ui element",2)end;ui.set_visible(S.reference,U)S.visible=U end;function r:set_default(k)q[self].default=k;self:set(k)end;function r:add_children(V,W,o)local S=q[self]local X=type(W)=="function"if W==nil then W=true;if S.type=="boolean"then W=true elseif S.type=="combobox"then X=true;W=v elseif S.type=="multiselect"then X=true;W=x end end;if getmetatable(V)==s then V={V}end;for Y,F in pairs(V)do if X then q[F].parent_visible_callback=W else q[F].parent_visible_value=W end;self[o or F.reference]=F end;r._process_callbacks(self)end;function r:add_callback(Z)local S=q[self]table.insert(S.callbacks,Z)r._process_callbacks(self)end;r.set_callback=r.add_callback;function r:_process_callbacks()local S=q[self]if S.ui_callback==nil then local Z=function(M,_)local k=self:get()local a0=S.combo_elements;if a0~=nil and#a0>0 then local a1;for g=1,#a0 do local a2=a0[g]if#a2>0 then local a3={}for g=1,#a2 do if h(k,a2[g])then table.insert(a3,a2[g])end end;if#a3>1 then a1=a1 or k;for g=#a3,1,-1 do if h(S.value_prev,a3[g])and#a3>1 then table.remove(a3,g)end end;local a4=a3[1]for g=#a1,1,-1 do if a1[g]~=a4 and h(a2,a1[g])then table.remove(a1,g)end end elseif#a3==0 and not(a2.required==false)then a1=a1 or k;if S.value_prev~=nil then for g=1,#S.value_prev do if h(a2,S.value_prev[g])then table.insert(a1,S.value_prev[g])break end end end end end end;if a1~=nil then self:set(a1)end;S.value_prev=k;k=a1 or k end;for o,F in pairs(self)do local a5=q[F]local a6=false;if S.visible then if a5.parent_visible_callback~=nil then a6=a5.parent_visible_callback(k,self,F)elseif S.type=="multiselect"then local a7=type(a5.parent_visible_value)for g=1,#k do if a7 and h(a5.parent_visible_value,k[g])or a5.parent_visible_value==k[g]then a6=true;break end end elseif type(a5.parent_visible_value)=="table"then a6=a5.parent_visible_value[k]or h(a5.parent_visible_value,k)else a6=k==a5.parent_visible_value end end;ui.set_visible(a5.reference,a6)a5.visible=a6;if a5.ui_callback~=nil then a5.ui_callback(F)end end;for g=1,#S.callbacks do S.callbacks[g]()end end;ui.set_callback(S.reference,Z)S.ui_callback=Z end;S.ui_callback()end;local a8={}local a9={__index=function(Y,o)if a8[o]then return a8[o]end;local aa=o;if aa:sub(1,4)~="new_"then aa="new_"..aa end;if ui[aa]~=nil then local ab=ui[aa]return function(self,L,...)local y={...}local a0={}local ac=aa:sub(5,-1)local ad="Cannot create a "..ac..": "local w;if ab==ui.new_textbox and L==nil then L="\n"end;L=(self.prefix or"")..L..(self.suffix or"")if ab==ui.new_slider then local ae,af,ag,ah,ai,aj,ak=unpack(y)if type(ag)=="table"then local al=ag;ag=al.default;ah=al.show_tooltip;ai=al.unit;aj=al.scale;ak=al.tooltips end;if ag~=nil then end;if ai~=nil then end;ag=ag or nil;if ah==nil then ah=true end;ai=ai or nil;aj=aj or 1;ak=ak or nil;w=r.new(ui.new_slider,self.tab,self.container,L,ae,af,ag,ah,ai,aj,ak)elseif ab==ui.new_combobox or ab==ui.new_multiselect or ab==ui.new_listbox then local am={...}if#am==1 and type(am[1])=="table"then am=am[1]end;if ab==ui.new_multiselect then local an={}for g=1,#am do local I=am[g]if type(I)=="table"then table.insert(a0,I)for ao=1,#I do table.insert(an,I[ao])end else table.insert(an,I)end end;am=an end;for g=1,#am do local I=am[g]end;if ab==ui.new_multiselect then local G;G,w=pcall(r.new,ui.new_multiselect,self.tab,self.container,L,am)if not G then error(w,2)end end elseif ab==ui.new_hotkey then if y[1]==nil then y[1]=false end;local ap=unpack(y)elseif ab==ui.new_button then local Z=unpack(y)elseif ab==ui.new_color_picker then local aq,ar,as,at=unpack(y)end;if w==nil then local G;G,w=pcall(r.new,ab,self.tab,self.container,L,...)if not G then error(w,2)end end;self[q[w].reference]=w;if#a0>0 then q[w].combo_elements=a0;local au={}for g=1,#a0 do if not a0[g].required==false then table.insert(au,a0[g][1])end end;w:set(au)q[w].value_prev=au;r._process_callbacks(w)end;return w end end end}local av={RAGE={"Aimbot","Other"},AA={"Anti-aimbot angles","Fake lag","Other"},LEGIT={"Weapon type","Aimbot","Triggerbot","Other"},VISUALS={"Player ESP","Other ESP","Colored models","Effects"},MISC={"Miscellaneous","Settings","Lua","Other"},SKINS={"Weapon skin","Knife options","Glove options"},PLAYERS={"Players","Adjustments"},LUA={"A","B"}}for J,aw in pairs(av)do av[J]={}for g=1,#aw do av[J][aw[g]:lower()]=true end end;function a8.new(J,K)J=J:upper()return setmetatable({tab=J,container=K,items={}},a9)end;function a8.reference(J,K,L)if L==nil and type(J)=="table"and getmetatable(J)==a9 then L=K;J,K=J.tab,J.container end;local ax={pcall(ui.reference,J,K,L)}j(ax[1]==true,"Cannot reference a Gamesense menu item: the menu item does not exist.")local ay={select(2,unpack(ax))}local az={}for g=1,#ay do local M=ay[g]local w=r.new(M,J,K,L)table.insert(az,w)end;return unpack(az)end;local aA=setmetatable({},{__index=function(Y,o)if ui[o]~=nil and o~="new_string"and(o==ui.reference or o:sub(1,4)=="new_")then return function(...)local G,f=pcall(ui[o],...)if not G then error(f,2)end;return r.new(f,...)end end end})return setmetatable(a8,{__call=function(Y,...)return a8.new(...)end,__index=function(Y,aB)return r[aB]or aA[aB]or ui[aB]end}) end)()

local client = {
	latency = client.latency,
	log = client.log,
	userid_to_entindex = client.userid_to_entindex,
	set_event_callback = client.set_event_callback,
	screen_size = client.screen_size,
	eye_position = client.eye_position,
	color_log = client.color_log,
	delay_call = client.delay_call,
	visible = client.visible,
	exec = client.exec,
	trace_line = client.trace_line,
	draw_hitboxes = client.draw_hitboxes,
	camera_angles = client.camera_angles,
	draw_debug_text = client.draw_debug_text,
	random_int = client.random_int,
	random_float = client.random_float,
	trace_bullet = client.trace_bullet,
	find_signature = client.find_signature,
	scale_damage = client.scale_damage,
	timestamp = client.timestamp,
	set_clantag = client.set_clantag,
	system_time = client.system_time,
	reload_active_scripts = client.reload_active_scripts,
	draw_indicator = client.draw_indicator
}
--endregion

--region Entity
local entity = {
	get_local_player = entity.get_local_player,
	is_enemy = entity.is_enemy,
	hitbox_position = entity.hitbox_position,
	get_player_name = entity.get_player_name,
	get_steam64 = entity.get_steam64,
	get_bounding_box = entity.get_bounding_box,
	get_all = entity.get_all,
	set_prop = entity.set_prop,
	is_alive = entity.is_alive,
	get_player_weapon = entity.get_player_weapon,
	get_prop = entity.get_prop,
	get_origin = entity.get_origin,
	get_players = entity.get_players,
	get_classname = entity.get_classname,
	get_game_rules = entity.get_game_rules,
	get_player_resource = entity.get_prop,
	is_dormant = entity.is_dormant,
}
--endregion

--region Globals
local globals = {
	realtime = globals.realtime,
	absoluteframetime = globals.absoluteframetime,
	tickcount = globals.tickcount,
	curtime = globals.curtime,
	mapname = globals.mapname,
	tickinterval = globals.tickinterval,
	framecount = globals.framecount,
	frametime = globals.frametime,
	maxplayers = globals.maxplayers,
	lastoutgoingcommand = globals.lastoutgoingcommand,
}
--endregion

--region Ui
local ui = {
	new_slider = ui.new_slider,
	new_combobox = ui.new_combobox,
	reference = ui.reference,
	set_visible = ui.set_visible,
	is_menu_open = ui.is_menu_open,
	new_color_picker = ui.new_color_picker,
	set_callback = ui.set_callback,
	set = ui.set,
	new_checkbox = ui.new_checkbox,
	new_hotkey = ui.new_hotkey,
	new_button = ui.new_button,
	new_multiselect = ui.new_multiselect,
	get = ui.get,
	new_textbox = ui.new_textbox,
	mouse_position = ui.mouse_position
}
--endregion

--region Renderer
local renderer = {
	text = renderer.text,
	measure_text = renderer.measure_text,
	rectangle = renderer.rectangle,
	line = renderer.line,
	gradient = renderer.gradient,
	circle = renderer.circle,
	circle_outline = renderer.circle_outline,
	triangle = renderer.triangle,
	world_to_screen = renderer.world_to_screen,
	indicator = renderer.indicator,
	texture = renderer.texture,
	load_svg = renderer.load_svg
}
--endregion
--endregion
--region dependency: vectors_and_angles_1_1_0
--region math
function math.round(number, precision)
	local mult = 10 ^ (precision or 0)
	return math.floor(number * mult + 0.5) / mult
end
--endregion

--region angle
local angle_mt = {}
angle_mt.__index = angle_mt

--- Create a new vector object.
local function angle(p, y, r)
	p = type(p) == "number" and math.min(90, math.max(-90, p)) or 0
	y = type(y) == "number" and math.min(180, math.max(-180, y)) or 0
	r = type(r) == "number" and math.min(180, math.max(-180, r)) or 0

	return setmetatable(
		{
			p = p,
			y = y,
			r = r
		},
		angle_mt
	)
end
local ffi = require("ffi")

local line_goes_through_smoke

do
	local success, match = client.find_signature("client_panorama.dll", "\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F\x57")

	if success and match ~= nil then
		local lgts_type = ffi.typeof("bool(__thiscall*)(float, float, float, float, float, float, short);")

		line_goes_through_smoke = ffi.cast(lgts_type, match)
	end
end
--endregion

--region math
function math.round(number, precision)
	local mult = 10 ^ (precision or 0)

	return math.floor(number * mult + 0.5) / mult
end
--endregion

--region angle
--- @class angle_c
--- @field public p number Angle pitch.
--- @field public y number Angle yaw.
--- @field public r number Angle roll.
local angle_c = {}
local angle_mt = {
	__index = angle_c
}

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param angle angle_c
--- @param p_new number
--- @param y_new number
--- @param r_new number
--- @return void
angle_mt.__call = function(angle, p_new, y_new, r_new)
	p_new = p_new or angle.p
	y_new = y_new or angle.y
	r_new = r_new or angle.r

	angle.p = p_new
	angle.y = y_new
	angle.r = r_new
end

--- Create a new vector object.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
local function angle(p, y, r)
	return setmetatable(
		{
			p = p or 0,
			y = y or 0,
			r = r or 0
		},
		angle_mt
	)
end

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return void
function angle_c:set(p, y, r)
	p = p or self.p
	y = y or self.y
	r = r or self.r

	self.p = p
	self.y = y
	self.r = r
end

--- Offset the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return void
function angle_c:offset(p, y, r)
	p = self.p + p or 0
	y = self.y + y or 0
	r = self.r + r or 0

	self.p = self.p + p
	self.y = self.y + y
	self.r = self.r + r
end

--- Clone the angle object.
--- @return angle_c
function angle_c:clone()
	return setmetatable(
		{
			p = self.p,
			y = self.y,
			r = self.r
		},
		angle_mt
	)
end

--- Clone and offset the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
function angle_c:clone_offset(p, y, r)
	p = self.p + p or 0
	y = self.y + y or 0
	r = self.r + r or 0

	return angle(
		self.p + p,
		self.y + y,
		self.r + r
	)
end

--- Clone the angle and optionally override its coordinates.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
function angle_c:clone_set(p, y, r)
	p = p or self.p
	y = y or self.y
	r = r or self.r

	return angle(
		p,
		y,
		r
	)
end

--- Unpack the angle.
--- @return number, number, number
function angle_c:unpack()
	return self.p, self.y, self.r
end

--- Set the angle's euler angles to 0.
--- @return void
function angle_c:nullify()
	self.p = 0
	self.y = 0
	self.r = 0
end

--- Returns a string representation of the angle.
function angle_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Concatenates the angle in a string.
function angle_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Adds the angle to another angle.
function angle_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a + operand_b.p,
			operand_a + operand_b.y,
			operand_a + operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p + operand_b,
			operand_a.y + operand_b,
			operand_a.r + operand_b
		)
	end

	return angle(
		operand_a.p + operand_b.p,
		operand_a.y + operand_b.y,
		operand_a.r + operand_b.r
	)
end

--- Subtracts the angle from another angle.
function angle_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a - operand_b.p,
			operand_a - operand_b.y,
			operand_a - operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p - operand_b,
			operand_a.y - operand_b,
			operand_a.r - operand_b
		)
	end

	return angle(
		operand_a.p - operand_b.p,
		operand_a.y - operand_b.y,
		operand_a.r - operand_b.r
	)
end

--- Multiplies the angle with another angle.
function angle_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a * operand_b.p,
			operand_a * operand_b.y,
			operand_a * operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p * operand_b,
			operand_a.y * operand_b,
			operand_a.r * operand_b
		)
	end

	return angle(
		operand_a.p * operand_b.p,
		operand_a.y * operand_b.y,
		operand_a.r * operand_b.r
	)
end

--- Divides the angle by the another angle.
function angle_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a / operand_b.p,
			operand_a / operand_b.y,
			operand_a / operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p / operand_b,
			operand_a.y / operand_b,
			operand_a.r / operand_b
		)
	end

	return angle(
		operand_a.p / operand_b.p,
		operand_a.y / operand_b.y,
		operand_a.r / operand_b.r
	)
end

--- Raises the angle to the power of an another angle.
function angle_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			math.pow(operand_a, operand_b.p),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.r)
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			math.pow(operand_a.p, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.r, operand_b)
		)
	end

	return angle(
		math.pow(operand_a.p, operand_b.p),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.r, operand_b.r)
	)
end

--- Performs modulo on the angle with another angle.
function angle_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a % operand_b.p,
			operand_a % operand_b.y,
			operand_a % operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p % operand_b,
			operand_a.y % operand_b,
			operand_a.r % operand_b
		)
	end

	return angle(
		operand_a.p % operand_b.p,
		operand_a.y % operand_b.y,
		operand_a.r % operand_b.r
	)
end

--- Perform a unary minus operation on the angle.
function angle_mt.__unm(operand_a)
	return angle(
		-operand_a.p,
		-operand_a.y,
		-operand_a.r
	)
end

--- Clamps the angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return void
function angle_c:round_zero()
	self.p = math.floor(self.p + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.r = math.floor(self.r + 0.5)
end

--- Round the angles.
--- @param precision number
function angle_c:round(precision)
	self.p = math.round(self.p, precision)
	self.y = math.round(self.y, precision)
	self.r = math.round(self.r, precision)
end

--- Clamps the angles to the nearest base.
--- @param base number
function angle_c:round_base(base)
	self.p = base * math.round(self.p / base)
	self.y = base * math.round(self.y / base)
	self.r = base * math.round(self.r / base)
end

--- Clamps the angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return angle_c
function angle_c:rounded_zero()
	return angle(
		math.floor(self.p + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.r + 0.5)
	)
end

--- Round the angles.
--- @param precision number
--- @return angle_c
function angle_c:rounded(precision)
	return angle(
		math.round(self.p, precision),
		math.round(self.y, precision),
		math.round(self.r, precision)
	)
end

--- Clamps the angles to the nearest base.
--- @param base number
--- @return angle_c
function angle_c:rounded_base(base)
	return angle(
		base * math.round(self.p / base),
		base * math.round(self.y / base),
		base * math.round(self.r / base)
	)
end
--endregion

--region vector
--- @class vector_c
--- @field public x number X coordinate.
--- @field public y number Y coordinate.
--- @field public z number Z coordinate.
local vector_c = {}
local vector_mt = {
	__index = vector_c,
}

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param vector vector_c
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
vector_mt.__call = function(vector, x_new, y_new, z_new)
	x_new = x_new or vector.x
	y_new = y_new or vector.y
	z_new = z_new or vector.z

	vector.x = x_new
	vector.y = y_new
	vector.z = z_new
end

--- Create a new vector object.
--- @param x number
--- @param y number
--- @param z number
--- @return vector_c
local function vector(x, y, z)
	return setmetatable(
		{
			x = x or 0,
			y = y or 0,
			z = z or 0
		},
		vector_mt
	)
end

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
function vector_c:set(x_new, y_new, z_new)
	x_new = x_new or self.x
	y_new = y_new or self.y
	z_new = z_new or self.z

	self.x = x_new
	self.y = y_new
	self.z = z_new
end

--- Offset the vector's coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return void
function vector_c:offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	self.x = self.x + x_offset
	self.y = self.y + y_offset
	self.z = self.z + z_offset
end

--- Clone the vector object.
--- @return vector_c
function vector_c:clone()
	return setmetatable(
		{
			x = self.x,
			y = self.y,
			z = self.z
		},
		vector_mt
	)
end

--- Clone the vector object and offset its coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return vector_c
function vector_c:clone_offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	return setmetatable(
		{
			x = self.x + x_offset,
			y = self.y + y_offset,
			z = self.z + z_offset
		},
		vector_mt
	)
end

--- Clone the vector and optionally override its coordinates.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return vector_c
function vector_c:clone_set(x_new, y_new, z_new)
	x_new = x_new or self.x
	y_new = y_new or self.y
	z_new = z_new or self.z

	return vector(
		x_new,
		y_new,
		z_new
	)
end

--- Unpack the vector.
--- @return number, number, number
function vector_c:unpack()
	return self.x, self.y, self.z
end

--- Set the vector's coordinates to 0.
--- @return void
function vector_c:nullify()
	self.x = 0
	self.y = 0
	self.z = 0
end

--- Returns a string representation of the vector.
function vector_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Concatenates the vector in a string.
function vector_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Returns true if the vector's coordinates are equal to another vector.
function vector_mt.__eq(operand_a, operand_b)
	return (operand_a.x == operand_b.x) and (operand_a.y == operand_b.y) and (operand_a.z == operand_b.z)
end

--- Returns true if the vector is less than another vector.
function vector_mt.__lt(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a < operand_b.x) or (operand_a < operand_b.y) or (operand_a < operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x < operand_b) or (operand_a.y < operand_b) or (operand_a.z < operand_b)
	end

	return (operand_a.x < operand_b.x) or (operand_a.y < operand_b.y) or (operand_a.z < operand_b.z)
end

--- Returns true if the vector is less than or equal to another vector.
function vector_mt.__le(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a <= operand_b.x) or (operand_a <= operand_b.y) or (operand_a <= operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x <= operand_b) or (operand_a.y <= operand_b) or (operand_a.z <= operand_b)
	end

	return (operand_a.x <= operand_b.x) or (operand_a.y <= operand_b.y) or (operand_a.z <= operand_b.z)
end

--- Add a vector to another vector.
function vector_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a + operand_b.x,
			operand_a + operand_b.y,
			operand_a + operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x + operand_b,
			operand_a.y + operand_b,
			operand_a.z + operand_b
		)
	end

	return vector(
		operand_a.x + operand_b.x,
		operand_a.y + operand_b.y,
		operand_a.z + operand_b.z
	)
end

--- Subtract a vector from another vector.
function vector_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a - operand_b.x,
			operand_a - operand_b.y,
			operand_a - operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x - operand_b,
			operand_a.y - operand_b,
			operand_a.z - operand_b
		)
	end

	return vector(
		operand_a.x - operand_b.x,
		operand_a.y - operand_b.y,
		operand_a.z - operand_b.z
	)
end

--- Multiply a vector with another vector.
function vector_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a * operand_b.x,
			operand_a * operand_b.y,
			operand_a * operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x * operand_b,
			operand_a.y * operand_b,
			operand_a.z * operand_b
		)
	end

	return vector(
		operand_a.x * operand_b.x,
		operand_a.y * operand_b.y,
		operand_a.z * operand_b.z
	)
end

--- Divide a vector by another vector.
function vector_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a / operand_b.x,
			operand_a / operand_b.y,
			operand_a / operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x / operand_b,
			operand_a.y / operand_b,
			operand_a.z / operand_b
		)
	end

	return vector(
		operand_a.x / operand_b.x,
		operand_a.y / operand_b.y,
		operand_a.z / operand_b.z
	)
end

--- Raised a vector to the power of another vector.
function vector_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			math.pow(operand_a, operand_b.x),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.z)
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			math.pow(operand_a.x, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.z, operand_b)
		)
	end

	return vector(
		math.pow(operand_a.x, operand_b.x),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.z, operand_b.z)
	)
end

--- Performs a modulo operation on a vector with another vector.
function vector_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a % operand_b.x,
			operand_a % operand_b.y,
			operand_a % operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x % operand_b,
			operand_a.y % operand_b,
			operand_a.z % operand_b
		)
	end

	return vector(
		operand_a.x % operand_b.x,
		operand_a.y % operand_b.y,
		operand_a.z % operand_b.z
	)
end

--- Perform a unary minus operation on the vector.
function vector_mt.__unm(operand_a)
	return vector(
		-operand_a.x,
		-operand_a.y,
		-operand_a.z
	)
end

--- Returns the vector's 2 dimensional length squared.
--- @return number
function vector_c:length2_squared()
	return (self.x * self.x) + (self.y * self.y);
end

--- Return's the vector's 2 dimensional length.
--- @return number
function vector_c:length2()
	return math.sqrt(self:length2_squared())
end

--- Returns the vector's 3 dimensional length squared.
--- @return number
function vector_c:length_squared()
	return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

--- Return's the vector's 3 dimensional length.
--- @return number
function vector_c:length()
	return math.sqrt(self:length_squared())
end

--- Returns the vector's dot product.
--- @param b vector_c
--- @return number
function vector_c:dot_product(b)
	return (self.x * b.x) + (self.y * b.y) + (self.z * b.z)
end

--- Returns the vector's cross product.
--- @param b vector_c
--- @return vector_c
function vector_c:cross_product(b)
	return vector(
		(self.y * b.z) - (self.z * b.y),
		(self.z * b.x) - (self.x * b.z),
		(self.x * b.y) - (self.y * b.x)
	)
end

--- Returns the 2 dimensional distance between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance2(destination)
	return (destination - self):length2()
end

--- Returns the 3 dimensional distance between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance(destination)
	return (destination - self):length()
end

--- Returns the distance on the X axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_x(destination)
	return math.abs(self.x - destination.x)
end

--- Returns the distance on the Y axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_y(destination)
	return math.abs(self.y - destination.y)
end

--- Returns the distance on the Z axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_z(destination)
	return math.abs(self.z - destination.z)
end

--- Returns true if the vector is within the given distance to another vector.
--- @param destination vector_c
--- @param distance number
--- @return boolean
function vector_c:in_range(destination, distance)
	return self:distance(destination) <= distance
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return void
function vector_c:round_zero()
	self.x = math.floor(self.x + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.z = math.floor(self.z + 0.5)
end

--- Round the vector's coordinates.
--- @param precision number
--- @return void
function vector_c:round(precision)
	self.x = math.round(self.x, precision)
	self.y = math.round(self.y, precision)
	self.z = math.round(self.z, precision)
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return void
function vector_c:round_base(base)
	self.x = base * math.round(self.x / base)
	self.y = base * math.round(self.y / base)
	self.z = base * math.round(self.z / base)
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return vector_c
function vector_c:rounded_zero()
	return vector(
		math.floor(self.x + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.z + 0.5)
	)
end

--- Round the vector's coordinates.
--- @param precision number
--- @return vector_c
function vector_c:rounded(precision)
	return vector(
		math.round(self.x, precision),
		math.round(self.y, precision),
		math.round(self.z, precision)
	)
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return vector_c
function vector_c:rounded_base(base)
	return vector(
		base * math.round(self.x / base),
		base * math.round(self.y / base),
		base * math.round(self.z / base)
	)
end

--- Normalize the vector.
--- @return void
function vector_c:normalize()
	local length = self:length()

	-- Prevent possible divide-by-zero errors.
	if (length ~= 0) then
		self.x = self.x / length
		self.y = self.y / length
		self.z = self.z / length
	else
		self.x = 0
		self.y = 0
		self.z = 1
	end
end

--- Returns the normalized length of a vector.
--- @return number
function vector_c:normalized_length()
	return self:length()
end

--- Returns a copy of the vector, normalized.
--- @return vector_c
function vector_c:normalized()
	local length = self:length()

	if (length ~= 0) then
		return vector(
			self.x / length,
			self.y / length,
			self.z / length
		)
	else
		return vector(0, 0, 1)
	end
end

--- Returns a new 2 dimensional vector of the original vector when mapped to the screen, or nil if the vector is off-screen.
--- @return vector_c
function vector_c:to_screen(only_within_screen_boundary)
	local x, y = renderer.world_to_screen(self.x, self.y, self.z)

	if (x == nil or y == nil) then
		return nil
	end

	if (only_within_screen_boundary == true) then
		local screen_x, screen_y = client.screen_size()

		if (x < 0 or x > screen_x or y < 0 or y > screen_y) then
			return nil
		end
	end

	return vector(x, y)
end

--- Returns the magnitude of the vector, use this to determine the speed of the vector if it's a velocity vector.
--- @return number
function vector_c:magnitude()
	return math.sqrt(
		math.pow(self.x, 2) +
			math.pow(self.y, 2) +
			math.pow(self.z, 2)
	)
end

--- Returns the angle of the vector in regards to another vector.
--- @param destination vector_c
--- @return angle_c
function vector_c:angle_to(destination)
	-- Calculate the delta of vectors.
	local delta_vector = vector(destination.x - self.x, destination.y - self.y, destination.z - self.z)

	-- Calculate the yaw.
	local yaw = math.deg(math.atan2(delta_vector.y, delta_vector.x))

	-- Calculate the pitch.
	local hyp = math.sqrt(delta_vector.x * delta_vector.x + delta_vector.y * delta_vector.y)
	local pitch = math.deg(math.atan2(-delta_vector.z, hyp))

	return angle(pitch, yaw)
end

--- Lerp to another vector.
--- @param destination vector_c
--- @param percentage number
--- @return vector_c
function vector_c:lerp(destination, percentage)
	return self + (destination - self) * percentage
end

--- Internally divide a ray.
--- @param source vector_c
--- @param destination vector_c
--- @param m number
--- @param n number
--- @return vector_c
local function vector_internal_division(source, destination, m, n)
	return vector((source.x * n + destination.x * m) / (m + n),
		(source.y * n + destination.y * m) / (m + n),
		(source.z * n + destination.z * m) / (m + n))
end

--- Returns the result of client.trace_line between two vectors.
--- @param destination vector_c
--- @param skip_entindex number
--- @return number, number|nil
function vector_c:trace_line_to(destination, skip_entindex)
	skip_entindex = skip_entindex or -1

	return client.trace_line(
		skip_entindex,
		self.x,
		self.y,
		self.z,
		destination.x,
		destination.y,
		destination.z
	)
end

--- Trace line to another vector and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param skip_entindex number
--- @return number, number, vector_c
function vector_c:trace_line_impact(destination, skip_entindex)
	skip_entindex = skip_entindex or -1

	local fraction, eid = client.trace_line(skip_entindex, self.x, self.y, self.z, destination.x, destination.y, destination.z)
	local impact = self:lerp(destination, fraction)

	return fraction, eid, impact
end

--- Trace line to another vector, skipping any entity indices returned by the callback and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param callback fun(eid: number): boolean
--- @param max_traces number
--- @return number, number, vector_c
function vector_c:trace_line_skip_indices(destination, max_traces, callback)
	max_traces = max_traces or 10

	local fraction, eid = 0, -1
	local impact = self
	local i = 0

	while (max_traces >= i and fraction < 1 and ((eid > -1 and callback(eid)) or impact == self)) do
		fraction, eid, impact = impact:trace_line_impact(destination, eid)
		i = i + 1
	end

	return self:distance(impact) / self:distance(destination), eid, impact
end

--- Traces a line from source to destination and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param skip_classes table
--- @param skip_distance number
--- @return number, number
function vector_c:trace_line_skip_class(destination, skip_classes, skip_distance)
	local should_skip = function(index, skip_entity)
		local class_name = entity.get_classname(index) or ""
		for i in 1, #skip_entity do
			if class_name == skip_entity[i] then
				return true
			end
		end

		return false
	end

	local angles = self:angle_to(destination)
	local direction = angles:to_forward_vector()

	local last_traced_position = self

	while true do  -- Start tracing.
		local fraction, hit_entity = last_traced_position:trace_line_to(destination)

		if fraction == 1 and hit_entity == -1 then  -- If we didn't hit anything.
			return 1, -1  -- return nothing.
		else  -- BOIS WE HIT SOMETHING.
			if should_skip(hit_entity, skip_classes) then  -- If entity should be skipped.
				-- Set last traced position according to fraction.
				last_traced_position = vector_internal_division(self, destination, fraction, 1 - fraction)

				-- Add a little gap per each trace to prevent inf loop caused by intersection.
				last_traced_position = last_traced_position + direction * skip_distance
			else  -- That's the one I want.
				return fraction, hit_entity, self:lerp(destination, fraction)
			end
		end
	end
end

--- Returns the result of client.trace_bullet between two vectors.
--- @param eid number
--- @param destination vector_c
--- @return number|nil, number
function vector_c:trace_bullet_to(destination, eid)
	return client.trace_bullet(
		eid,
		self.x,
		self.y,
		self.z,
		destination.x,
		destination.y,
		destination.z
	)
end

--- Returns the vector of the closest point along a ray.
--- @param ray_start vector_c
--- @param ray_end vector_c
--- @return vector_c
function vector_c:closest_ray_point(ray_start, ray_end)
	local to = self - ray_start
	local direction = ray_end - ray_start
	local length = direction:length()

	direction:normalize()

	local ray_along = to:dot_product(direction)

	if (ray_along < 0) then
		return ray_start
	elseif (ray_along > length) then
		return ray_end
	end

	return ray_start + direction * ray_along
end

--- Returns a point along a ray after dividing it.
--- @param ray_end vector_c
--- @param ratio number
--- @return vector_c
function vector_c:ray_divided(ray_end, ratio)
	return (self * ratio + ray_end) / (1 + ratio)
end

--- Returns a ray divided into a number of segments.
--- @param ray_end vector_c
--- @param segments number
--- @return table<number, vector_c>
function vector_c:ray_segmented(ray_end, segments)
	local points = {}

	for i = 0, segments do
		points[i] = vector_internal_division(self, ray_end, i, segments - i)
	end

	return points
end

--- Returns the best source vector and destination vector to draw a line on-screen using world-to-screen.
--- @param ray_end vector_c
--- @param total_segments number
--- @return vector_c|nil, vector_c|nil
function vector_c:ray(ray_end, total_segments)
	total_segments = total_segments or 128

	local segments = {}
	local step = self:distance(ray_end) / total_segments
	local angle = self:angle_to(ray_end)
	local direction = angle:to_forward_vector()

	for i = 1, total_segments do
		table.insert(segments, self + (direction * (step * i)))
	end

	local src_screen_position = vector(0, 0, 0)
	local dst_screen_position = vector(0, 0, 0)
	local src_in_screen = false
	local dst_in_screen = false

	for i = 1, #segments do
		src_screen_position = segments[i]:to_screen()

		if src_screen_position ~= nil then
			src_in_screen = true

			break
		end
	end

	for i = #segments, 1, -1 do
		dst_screen_position = segments[i]:to_screen()

		if dst_screen_position ~= nil then
			dst_in_screen = true

			break
		end
	end

	if src_in_screen and dst_in_screen then
		return src_screen_position, dst_screen_position
	end

	return nil
end

--- Returns true if the ray goes through a smoke. False if not.
--- @param ray_end vector_c
--- @return boolean
function vector_c:ray_intersects_smoke(ray_end)
	if (line_goes_through_smoke == nil) then
		error("Unsafe scripts must be allowed in order to use vector_c:ray_intersects_smoke")
	end

	return line_goes_through_smoke(self.x, self.y, self.z, ray_end.x, ray_end.y, ray_end.z, 1)
end

--- Returns true if the vector lies within the boundaries of a given 2D polygon. The polygon is a table of vectors. The Z axis is ignored.
--- @param polygon table<any, vector_c>
--- @return boolean
function vector_c:inside_polygon2(polygon)
	local odd_nodes = false
	local polygon_vertices = #polygon
	local j = polygon_vertices

	for i = 1, polygon_vertices do
		if (polygon[i].y < self.y and polygon[j].y >= self.y or polygon[j].y < self.y and polygon[i].y >= self.y) then
			if (polygon[i].x + (self.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < self.x) then
				odd_nodes = not odd_nodes
			end
		end

		j = i
	end

	return odd_nodes
end

--- Draws a world circle with an origin of the vector. Code credited to sapphyrus.
--- @param radius number
--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @param accuracy number
--- @param width number
--- @param outline number
--- @param start_degrees number
--- @param percentage number
--- @return void
function vector_c:draw_circle(radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
	local accuracy = accuracy ~= nil and accuracy or 3
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1

	local screen_x_line_old, screen_y_line_old

	for rot = start_degrees, percentage * 360, accuracy do
		local rot_temp = math.rad(rot)
		local lineX, lineY, lineZ = radius * math.cos(rot_temp) + self.x, radius * math.sin(rot_temp) + self.y, self.z
		local screen_x_line, screen_y_line = renderer.world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~= nil and screen_x_line_old ~= nil then

			for i = 1, width do
				local i = i - 1

				renderer.line(screen_x_line, screen_y_line - i, screen_x_line_old, screen_y_line_old - i, r, g, b, a)
			end

			if outline then
				local outline_a = a / 255 * 160

				renderer.line(screen_x_line, screen_y_line - width, screen_x_line_old, screen_y_line_old - width, 16, 16, 16, outline_a)

				renderer.line(screen_x_line, screen_y_line + 1, screen_x_line_old, screen_y_line_old + 1, 16, 16, 16, outline_a)
			end
		end

		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

--- Performs math.min on the vector.
--- @param value number
--- @return void
function vector_c:min(value)
	self.x = math.min(value, self.x)
	self.y = math.min(value, self.y)
	self.z = math.min(value, self.z)
end

--- Performs math.max on the vector.
--- @param value number
--- @return void
function vector_c:max(value)
	self.x = math.max(value, self.x)
	self.y = math.max(value, self.y)
	self.z = math.max(value, self.z)
end

--- Performs math.min on the vector and returns the result.
--- @param value number
--- @return void
function vector_c:minned(value)
	return vector(
		math.min(value, self.x),
		math.min(value, self.y),
		math.min(value, self.z)
	)
end

--- Performs math.max on the vector and returns the result.
--- @param value number
--- @return void
function vector_c:maxed(value)
	return vector(
		math.max(value, self.x),
		math.max(value, self.y),
		math.max(value, self.z)
	)
end
--endregion

--region angle_vector_methods
--- Returns a forward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_forward_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))

	return vector(cp * cy, cp * sy, -sp)
end

--- Return an up vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_up_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Return a right vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_right_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a backward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_backward_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))

	return -vector(cp * cy, cp * sy, -sp)
end

--- Return a left vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_left_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return -vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a down vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_down_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return -vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Calculate where a vector is in a given field of view.
--- @param source vector_c
--- @param destination vector_c
--- @return number
function angle_c:fov_to(source, destination)
	local fwd = self:to_forward_vector()
	local delta = (destination - source):normalized()
	local fov = math.acos(fwd:dot_product(delta) / delta:length())

	return math.max(0.0, math.deg(fov))
end

--- Returns the degrees bearing of the angle's yaw.
--- @param precision number
--- @return number
function angle_c:bearing(precision)
	local yaw = 180 - self.y + 90
	local degrees = (yaw % 360 + 360) % 360

	degrees = degrees > 180 and degrees - 360 or degrees

	return math.round(degrees + 180, precision)
end

--- Returns the yaw appropriate for renderer circle's start degrees.
--- @return number
function angle_c:start_degrees()
	local yaw = self.y
	local degrees = (yaw % 360 + 360) % 360

	degrees = degrees > 180 and degrees - 360 or degrees

	return degrees + 180
end

--- Returns a copy of the angles normalized and clamped.
--- @return number
function angle_c:normalize()
	local pitch = self.p

	if (pitch < -89) then
		pitch = -89
	elseif (pitch > 89) then
		pitch = 89
	end

	local yaw = self.y

	while yaw > 180 do
		yaw = yaw - 360
	end

	while yaw < -180 do
		yaw = yaw + 360
	end

	return angle(pitch, yaw, 0)
end

--- Normalizes and clamps the angles.
--- @return number
function angle_c:normalized()
	if (self.p < -89) then
		self.p = -89
	elseif (self.p > 89) then
		self.p = 89
	end

	local yaw = self.y

	while yaw > 180 do
		yaw = yaw - 360
	end

	while yaw < -180 do
		yaw = yaw + 360
	end

	self.y = yaw
	self.r = 0
end
--endregion

--region functions
--- Draws a polygon to the screen.
--- @param polygon table<number, vector_c>
--- @return void
function vector_c.draw_polygon(polygon, r, g, b, a, segments)
	for id, vertex in pairs(polygon) do
		local next_vertex = polygon[id + 1]

		if (next_vertex == nil) then
			next_vertex = polygon[1]
		end

		local ray_a, ray_b = vertex:ray(next_vertex, (segments or 64))

		if (ray_a ~= nil and ray_b ~= nil) then
			renderer.line(
				ray_a.x, ray_a.y,
				ray_b.x, ray_b.y,
				r, g, b, a
			)
		end
	end
end

--- Returns the eye position of a player.
--- @param eid number
--- @return vector_c
function vector_c.eye_position(eid)
	local origin = vector(entity.get_origin(eid))
	local duck_amount = entity.get_prop(eid, "m_flDuckAmount") or 0

	origin.z = origin.z + 46 + (1 - duck_amount) * 18

	return origin
end
--endregion
--endregion
--- Clone the angle object.
function angle_mt:clone()
	return angle(self.p, self.y, self.r)
end

--- Unpack the angle.
function angle_mt:unpack()
	return self.p, self.y, self.r
end

--- Set the angle's euler angles to 0.
function angle_mt:nullify()
	self.p = 0
	self.y = 0
	self.r = 0
end

--- Clamps the angle's angles to whole numbers. Equivalent to "angle:round" with no precision.
function angle_mt:round_zero()
	self.p = math.floor(self.p + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.r = math.floor(self.r + 0.5)
end

--- Round the angle's angles.
function angle_mt:round(precision)
	self.p = math.round(self.p, precision)
	self.y = math.round(self.y, precision)
	self.r = math.round(self.r, precision)
end

--- Clamps the angle's angles to the nearest base.
function angle_mt:round_base(base)
	self.p = base * math.round(self.p / base)
	self.y = base * math.round(self.y / base)
	self.r = base * math.round(self.r / base)
end

--- Clamps the angle's angles to whole numbers. Equivalent to "angle:round" with no precision.
function angle_mt:rounded_zero()
	return angle(
		math.floor(self.p + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.r + 0.5)
	)
end

--- Round the angle's angles.
function angle_mt:rounded(precision)
	return angle(
		math.round(self.p, precision),
		math.round(self.y, precision),
		math.round(self.r, precision)
	)
end

--- Clamps the angle's angles to the nearest base.
function angle_mt:rounded_base(base)
	return angle(
		base * math.round(self.p / base),
		base * math.round(self.y / base),
		base * math.round(self.r / base)
	)
end

--- Returns a string representation of the angle.
function angle_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Concatenates the angle in a string.
function angle_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Returns true if the angle is equal to another angle.
function angle_mt.__eq(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a == operand_b.p) and (operand_a == operand_b.y) and (operand_a == operand_b.r)
	end

	if (type(operand_b) == "number") then
		return (operand_a.p == operand_b) and (operand_a.y == operand_b) and (operand_a.r == operand_b)
	end

	return (operand_a.p == operand_b.p) and (operand_a.y == operand_b.y) and (operand_a.r == operand_b.r)
end

--- Returns true if the angle is less than another angle.
function angle_mt.__lt(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a < operand_b.p) and (operand_a < operand_b.y) and (operand_a < operand_b.r)
	end

	if (type(operand_b) == "number") then
		return (operand_a.p < operand_b) and (operand_a.y < operand_b) and (operand_a.r < operand_b)
	end

	return (operand_a.p < operand_b.p) and (operand_a.y < operand_b.y) and (operand_a.r < operand_b.r)
end

--- Returns true if the angle is less than or equal to another angle.
function angle_mt.__le(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a <= operand_b.p) and (operand_a <= operand_b.y) and (operand_a <= operand_b.r)
	end

	if (type(operand_b) == "number") then
		return (operand_a.p <= operand_b) and (operand_a.y <= operand_b) and (operand_a.r <= operand_b)
	end

	return (operand_a.p <= operand_b.p) and (operand_a.y <= operand_b.y) and (operand_a.r <= operand_b.r)
end

--- Adds the angle to another angle.
function angle_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a + operand_b.p,
			operand_a + operand_b.y,
			operand_a + operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p + operand_b,
			operand_a.y + operand_b,
			operand_a.r + operand_b
		)
	end

	return angle(
		operand_a.p + operand_b.p,
		operand_a.y + operand_b.y,
		operand_a.r + operand_b.r
	)
end

--- Subtracts the angle from another angle.
function angle_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a - operand_b.p,
			operand_a - operand_b.y,
			operand_a - operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p - operand_b,
			operand_a.y - operand_b,
			operand_a.r - operand_b
		)
	end

	return angle(
		operand_a.p - operand_b.p,
		operand_a.y - operand_b.y,
		operand_a.r - operand_b.r
	)
end

--- Multiplies the angle with another angle.
function angle_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a * operand_b.p,
			operand_a * operand_b.y,
			operand_a * operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p * operand_b,
			operand_a.y * operand_b,
			operand_a.r * operand_b
		)
	end

	return angle(
		operand_a.p * operand_b.p,
		operand_a.y * operand_b.y,
		operand_a.r * operand_b.r
	)
end

--- Divides the angle by the another angle.
function angle_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a / operand_b.p,
			operand_a / operand_b.y,
			operand_a / operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p / operand_b,
			operand_a.y / operand_b,
			operand_a.r / operand_b
		)
	end

	return angle(
		operand_a.p / operand_b.p,
		operand_a.y / operand_b.y,
		operand_a.r / operand_b.r
	)
end

--- Raises the angle to the power of an another angle.
function angle_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			math.pow(operand_a, operand_b.p),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.r)
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			math.pow(operand_a.p, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.r, operand_b)
		)
	end

	return angle(
		math.pow(operand_a.p, operand_b.p),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.r, operand_b.r)
	)
end

--- Performs modulo on the angle with another angle.
function angle_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a % operand_b.p,
			operand_a % operand_b.y,
			operand_a % operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p % operand_b,
			operand_a.y % operand_b,
			operand_a.r % operand_b
		)
	end

	return angle(
		operand_a.p % operand_b.p,
		operand_a.y % operand_b.y,
		operand_a.r % operand_b.r
	)
end

--- Performs a unary minus on the angle.
function angle_mt.__unm()
	self.p = -self.p
	self.y = -self.y
	self.r = -self.r
end
--endregion

--region vector
local vector_mt = {}
vector_mt.__index = vector_mt

--- Create a new vector object.
local function vector(x, y, z)
	x = type(x) == "number" and x or 0
	y = type(y) == "number" and y or 0
	z = type(z) == "number" and z or 0

	return setmetatable(
		{
			x = x,
			y = y,
			z = z
		},
		vector_mt
	)
end

--- Returns the bounding box of an entity or nil.
local function vector_bounding_box(eid)
	local x1, y1, x2, y2, a = entity.get_bounding_box(eid)

	if (a == 0) then
		return nil
	end

	return {
		left = x1,
		top = y1,
		right = x2,
		bottom = y2,
		alpha = a
	}
end

--- Returns the hitbox position or nil.
local function vector_hitbox_position(eid, hitbox)
	local x, y, z = entity.hitbox_position(eid, hitbox)

	if (x == nil or y == nil or z == nil) then
		return nil
	end

	return vector(x, y, z)
end

--- Clone the vector object.
function vector_mt:clone()
	return vector(self.x, self.y, self.z)
end

--- Unpack the vector.
function vector_mt:unpack()
	return self.x, self.y, self.z
end

--- Set the vector's coordinates to 0.
function vector_mt:nullify()
	self.x = 0
	self.y = 0
	self.z = 0
end

--- Returns a string representation of the vector.
function vector_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Concatenates the vector in a string.
function vector_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end


--- Returns true if the vector's coordinates are equal to another vector.
function vector_mt.__eq(operand_a, operand_b)
	return (operand_a.x == operand_b.x) and (operand_a.y == operand_b.y) and (operand_a.z == operand_b.z)
end

--- Returns true if the vector is less than another vector.
function vector_mt.__lt(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a < operand_b.x) and (operand_a < operand_b.y) and (operand_a < operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x < operand_b) and (operand_a.y < operand_b) and (operand_a.z < operand_b)
	end

	return (operand_a.x < operand_b.x) and (operand_a.y < operand_b.y) and (operand_a.z < operand_b.z)
end

--- Returns true if the vector is less than or equal to another vector.
function vector_mt.__le(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a <= operand_b.x) and (operand_a <= operand_b.y) and (operand_a <= operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x <= operand_b) and (operand_a.y <= operand_b) and (operand_a.z <= operand_b)
	end

	return (operand_a.x <= operand_b.x) and (operand_a.y <= operand_b.y) and (operand_a.z <= operand_b.z)
end

--- Add a vector to another vector.
function vector_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a + operand_b.x,
			operand_a + operand_b.y,
			operand_a + operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x + operand_b,
			operand_a.y + operand_b,
			operand_a.z + operand_b
		)
	end

	return vector(
		operand_a.x + operand_b.x,
		operand_a.y + operand_b.y,
		operand_a.z + operand_b.z
	)
end

--- Subtract a vector from another vector.
function vector_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a - operand_b.x,
			operand_a - operand_b.y,
			operand_a - operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x - operand_b,
			operand_a.y - operand_b,
			operand_a.z - operand_b
		)
	end

	return vector(
		operand_a.x - operand_b.x,
		operand_a.y - operand_b.y,
		operand_a.z - operand_b.z
	)
end

--- Multiply a vector with another vector.
function vector_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a * operand_b.x,
			operand_a * operand_b.y,
			operand_a * operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x * operand_b,
			operand_a.y * operand_b,
			operand_a.z * operand_b
		)
	end

	return vector(
		operand_a.x * operand_b.x,
		operand_a.y * operand_b.y,
		operand_a.z * operand_b.z
	)
end

--- Divide a vector by another vector.
function vector_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a / operand_b.x,
			operand_a / operand_b.y,
			operand_a / operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x / operand_b,
			operand_a.y / operand_b,
			operand_a.z / operand_b
		)
	end

	return vector(
		operand_a.x / operand_b.x,
		operand_a.y / operand_b.y,
		operand_a.z / operand_b.z
	)
end

--- Raised a vector to the power of another vector.
function vector_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			math.pow(operand_a, operand_b.x),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.z)
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			math.pow(operand_a.x, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.z, operand_b)
		)
	end

	return vector(
		math.pow(operand_a.x, operand_b.x),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.z, operand_b.z)
	)
end

--- Performs a modulo operation on a vector with another vector.
function vector_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a % operand_b.x,
			operand_a % operand_b.y,
			operand_a % operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x % operand_b,
			operand_a.y % operand_b,
			operand_a.z % operand_b
		)
	end

	return vector(
		operand_a.x % operand_b.x,
		operand_a.y % operand_b.y,
		operand_a.z % operand_b.z
	)
end

--- Perform a unary minus operation on the vector.
function vector_mt.__unm(operand_a)
	return vector(
		-operand_a.x,
		-operand_a.y,
		-operand_a.z
	)
end

--- Returns the vector's 2 dimensional length squared.
function vector_mt:length2_squared()
	return (self.x * self.x) + (self.y * self.y);
end

--- Return's the vector's 2 dimensional length.
function vector_mt:length2()
	return math.sqrt(self:length2_squared())
end

--- Returns the vector's 3 dimensional length squared.
function vector_mt:length_squared()
	return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

--- Return's the vector's 3 dimensional length.
function vector_mt:length()
	return math.sqrt(self:length_squared())
end

-- Returns the vector's dot product.
function vector_mt:dot_product(other_vector)
	return (self.x * other_vector.x) + (self.y * other_vector.y) + (self.z * other_vector.z)
end

-- Returns the vector's cross product.
function vector_mt:cross_product(other_vector)
	return vector_mt(
		(self.y * other_vector.z) - (self.z * other_vector.y),
		(self.z * other_vector.x) - (self.x * other_vector.z),
		(self.x * other_vector.y) - (self.y * other_vector.x)
	)
end

--- Returns the 2 dimensional distance between the vector and another vector.
function vector_mt:distance2(other_vector)
	return (other_vector - self):length2()
end

--- Returns the 3 dimensional distance between the vector and another vector.
function vector_mt:distance(other_vector)
	return (other_vector - self):length()
end

--- Returns the distance on the X axis between the vector and another vector.
function vector_mt:distanceX(other_vector)
	return math.abs(self.x - other_vector.x)
end

--- Returns the distance on the Y axis between the vector and another vector.
function vector_mt:distanceY(other_vector)
	return math.abs(self.y - other_vector.y)
end

--- Returns the distance on the Z axis between the vector and another vector.
function vector_mt:distanceZ(other_vector)
	return math.abs(self.z - other_vector.z)
end

--- Returns true if the vector is within the given distance to another vector.
function vector_mt:in_range(other_vector, distance)
	return self:distance(other_vector) <= distance
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
function vector_mt:round_zero()
	self.x = math.floor(self.x + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.z = math.floor(self.z + 0.5)
end

--- Round the vector's coordinates.
function vector_mt:round(precision)
	self.x = math.round(self.x, precision)
	self.y = math.round(self.y, precision)
	self.z = math.round(self.z, precision)
end

--- Clamps the vector's coordinates to the nearest base.
function vector_mt:round_base(base)
	self.x = base * math.round(self.x / base)
	self.y = base * math.round(self.y / base)
	self.z = base * math.round(self.z / base)
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
function vector_mt:rounded_zero()
	return vector(
		math.floor(self.x + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.z + 0.5)
	)
end

--- Round the vector's coordinates.
function vector_mt:rounded(precision)
	return vector(
		math.round(self.x, precision),
		math.round(self.y, precision),
		math.round(self.z, precision)
	)
end

--- Clamps the vector's coordinates to the nearest base.
function vector_mt:rounded_base(base)
	return vector(
		base * math.round(self.x / base),
		base * math.round(self.y / base),
		base * math.round(self.z / base)
	)
end

--- Normalize the vector.
function vector_mt:normalize()
	local length = self:length()

	if (length ~= 0) then  -- Preventing possible divide-by-zero error
		self.x = self.x / length
		self.y = self.y / length
		self.z = self.z / length
	else
		self.x = 0
		self.y = 0
		self.z = 1
	end
end

--- Returns the normalized length of a vector.
function vector_mt:normalized_length()
	return self:length()
end

--- Returns a copy of the vector, normalized.
function vector_mt:normalized()
	local length = self:length()

	if (length ~= 0) then
		return vector(
			self.x / length,
			self.y / length,
			self.z / length
		)
	else
		return vector(0, 0, 1)
	end
end

--- Returns a new 2 dimensional vector of the original vector when mapped to the screen, or nil if the operation fails.
function vector_mt:to_screen()
	local x, y = renderer.world_to_screen(self.x, self.y, self.z)

	if (x == nil or y == nil) then
		return nil
	end

	return vector(x, y)
end

--- Returns the magnitude of the vector, use this to determine the speed of the vector if it's a velocity vector.
function vector_mt:magnitude()
	return math.sqrt(
		math.pow(self.x, 2) +
		math.pow(self.y, 2) +
		math.pow(self.z, 2)
	)
end

--- Returns the euler angle of the vector in regards to another vector.
function vector_mt:angle_to(other_vector)
	-- Calculate the delta of vectors.
	local delta_vector = vector(other_vector.x - self.x, other_vector.y - self.y, other_vector.z - self.z)

	if (delta_vector.x == 0 and delta_vector.y == 0) then
		return angle((delta_vector.z > 0 and 270 or 90), 0)
	else
		-- Calculate the yaw.
		local yaw = math.deg(math.atan2(delta_vector.y, delta_vector.x))

		-- Calculate the pitch.
		local hyp = math.sqrt(delta_vector.x * delta_vector.x + delta_vector.y * delta_vector.y)
		local pitch = math.deg(math.atan2(-delta_vector.z, hyp))

		return angle(pitch, yaw)
	end
end

--- Draws a traceline between two vectors and returns the result.
function vector_mt:trace_line_to(other_vector, skip_entindex)
	skip_entindex = skip_entindex or 0

	return client.trace_line(
		skip_entindex,
		self.x,
		self.y,
		self.z,
		other_vector.x,
		other_vector.y,
		other_vector.z
	)
end

--- Calculates a bullet trajectory from one player to a vector.
function vector_mt:trace_bullet_to(from_player, other_vector)
	return client.trace_bullet(
		from_player,
		self.x,
		self.y,
		self.z,
		other_vector.x,
		other_vector.y,
		other_vector.z
	)
end
--endregion

--region angle_vector_methods
--- Returns all unit vectors of the angle. Use this to convert an angle into a cartesian direction.
function angle_mt:to_unit_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	local forward = vector(cp * cy, cp * sy, -sp)
	local right = vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
	local up = vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)

	return {
		forward = forward,
		right = right,
		up = up,
		backward = -forward,
		left = -right,
		bottom = -up
	}
end

--- Returns a forward vector of the angle. Use this to convert an angle into a cartesian direction.
function angle_mt:to_forward_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))

	return vector(cp * cy, cp * sy, -sp)
end

--- Return an up vector of the angle. Use this to convert an angle into a cartesian direction.
function angle_mt:to_up_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Return a right vector of the angle. Use this to convert an angle into a cartesian direction.
function angle_mt:to_right_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a backward vector of the angle. Use this to convert an angle into a cartesian direction.
function angle_mt:to_backward_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))

	return -vector(cp * cy, cp * sy, -sp)
end

--- Return a left vector of the angle. Use this to convert an angle into a cartesian direction.
function angle_mt:to_left_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return -vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a down vector of the angle. Use this to convert an angle into a cartesian direction.
function angle_mt:to_down_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return -vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end
--endregion
--endregion

local player_last_shot_time = {}
local prefer_head
local prefer_baim
local force_baim
local force_safe
local lua_enabled = ui.new_checkbox("RAGE", "Other", "Prefer baim/head")
local remove_indicators = ui.new_checkbox("RAGE", "Other", "Remove indicators")
local wpn_list = {"Auto","Scout","Awp","Revolver","Deagle","Other Pistols"}
local show_priority = ui.new_checkbox("RAGE", "Other", "Show Priority")
local prediction_ticks = ui.new_slider("RAGE", "Other", "Prediction Ticks", 20, 60,45)
local prediction_ticks_skip = ui.new_slider("RAGE", "Other", "Prediction Ticks Interval", 1, 45,15)
local ref_dt,ref_dt_hotkey = ui.reference("RAGE" , "Other" , "Double tap")
local ref_ragebot_enabled = ui.reference("RAGE", "Aimbot", "Enabled")
local ref_ragebot_hc = ui.reference("RAGE", "Aimbot", "Minimum hit chance")
local ref_player_list = ui.reference("PLAYERS", "Players", "Player list")
local ref_priority = ui.reference("PLAYERS", "Adjustments", "High priority")
local ref_baim = ui.reference("PLAYERS", "Adjustments", "Override prefer body aim")
local ref_sp = ui.reference("PLAYERS", "Adjustments", "Override safe point")
local ref_fd_hotkey =  ui.reference("RAGE" , "Other" ,"Duck peek assist")
local ref_ns =  ui.reference("rage", "Aimbot", "Automatic scope")
local weapon_combo = ui.new_combobox("RAGE" , "Other" ,"Selected Weapon" , wpn_list)
local weapon_indexes = {
    Global       = { }, --/all other weapons: non selected and knifes, zeus, grenades etc
    AWP         = { 9 },
    Auto        = { 11, 38 },
    Scout       = { 40 },
    Revolver    = { 64 },
    Deagle      = { 1 },
    Pistol      = { 2, 3, 4, 30, 32, 36, 61, 63 },
    Zeus        = { 31 },
    --Rifle     = { 7, 8, 10, 13, 16, 39, 60 },
    --SMG       = { 17, 19, 24, 26, 33, 34 },
    --Heavy     = { 14, 28},
    --Shotgun   = { 25, 27, 29, 35 },
}

for i = 1 , #wpn_list do
	local wpn = wpn_list[i]
	local prefer_head = ui.new_multiselect("RAGE", "Other", wpn .. " prefer head conditions", "Lateral", "Flying", "Firing")
	local prefer_baim = ui.new_multiselect("RAGE", "Other", wpn .. " prefer body conditions","Inaccurate desync","Resolver issue", "2shot","3shot","Towards", "Slow", "Moving", "Crouching")
	local force_baim = ui.new_multiselect("RAGE", "Other", wpn .. " force body conditions", "Lethal", "Lethal x2", "Lethal x3", "High damage", "Peeking enemy","Getting peeked","DISABLE 1X","DISABLE 2X")
	local force_safe = ui.new_multiselect("RAGE", "Other", wpn .. " force safepoint conditions", "Noscope","Resolver miss","SP Lethal","SP Lethal x2","SP Lethal x3","SP High damage")
	ui.set_visible(prefer_baim,false)
	ui.set_visible(prefer_head,false)
	ui.set_visible(force_baim,false)
	ui.set_visible(force_safe,false)
end

ui.set_visible(show_priority, false)
ui.set_visible(prediction_ticks,false)
ui.set_visible(prediction_ticks_skip, false)
ui.set_visible(weapon_combo,false)
ui.set_visible(remove_indicators,false)

local a = {}    -- new array
local s= {}    -- new array
local safepoint = {}
local limited = {}
local shots = {}
local is_paster = {}
local player_last_shot_time = {}
for i=1, 66 do
	a[i] = ""
	s[i] = ""
	safepoint[i] = ""
	limited[i] = ""
	is_paster[i] = ""
end
local current_key = nil

local function contains_sha(table,item)
	return true
end

local should_run = true

local function contains(table, item)
    for i = 0, #table do
        if table[i] == item then
            return true
        end
    end

    return false
end
local function get_gun(index)
	if index == 11 or index == 38 then
		return "Auto"
	elseif index == 9 then
		return "Awp"
	elseif index == 1 then
		return "Deagle"
	elseif index == 64 then
		return "Revolver"
	elseif index == 40 then
		return "Scout"
	else
		return "Other Pistols"
	end
end
local function is_active(item)
	return contains(ui.get(prefer_head),item) or contains(ui.get(prefer_baim),item) or contains(ui.get(force_baim),item) or contains(ui.get(force_safe),item)
end
local function extrapolate(player , ticks , x,y,z )
	local xv,yv,zv =  entity.get_prop(player, "m_vecVelocity")
	local new_x = x + globals.tickinterval() * xv * ticks
	local new_y = y + globals.tickinterval() * yv * ticks
	local new_z = z + globals.tickinterval() * zv * ticks
	return new_x,new_y,new_z

end
local function set_priority_player(entity, status)
		if not contains_sha(steam_id_list,current_key)  then
			a = {}
			s = {}

		end
    ui.set(ref_player_list, entity)
    ui.set(ref_priority, status)
end
local function set_baim_player(entity, status)
    ui.set(ref_player_list, entity)
    ui.set(ref_baim, status)
		if not contains_sha(steam_id_list,current_key)  then
			a = {}
			s = {}

		end
end
local function set_sp_player(entity, status)
    ui.set(ref_player_list, entity)
    ui.set(ref_sp, status)
		if not contains_sha(steam_id_list,current_key)  then
			a = {}
			s = {}

		end
end
local function distance_3d(x1,y1,z1,x2,y2,z2)
	return math.sqrt( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) )
end
local function is_sideways(enemy,lx,ly,lz)
	if not contains_sha(steam_id_list,current_key)  then
		a = {}
		s = {}
	end
	local dx,dy,dz = (vector(lx,ly,lz):angle_to(vector(entity.get_origin(enemy))) -	angle(entity.get_prop(enemy, "m_angEyeAngles"))):unpack()
	local yaw_delta = math.abs(dy)
	--client.log(yaw_delta)
	if ((yaw_delta >= 80 and yaw_delta <= 100) or (yaw_delta >= 250 and yaw_delta <= 270) or (yaw_delta >= 430 and yaw_delta <= 460)) then
		 return true
	end
	return false
end
local function check_damage(player)
		if not should_run then return -1 end
    local highest_damage = 0
    local highest_entindex = -1
    local visible = false
    local target = 0
    local sp = false
		local can_shoot_head = false
    local cur_player = player
		local health = entity.get_prop(cur_player,"m_iHealth")
		local local_player = entity.get_local_player()
		local end_distance = 0
		local ox,oy,oz = entity.get_origin(cur_player)
		local lox,loy,loz = entity.get_origin(local_player)
		local lx,ly,lz = client.eye_position()
		local start_distance = distance_3d(lx,ly,lz ,ox,oy,oz)
		local is_sideways_enemy = false
		if not contains_sha(steam_id_list,current_key)  then
			a = {}
			s = {}
		end
    if not entity.get_prop(cur_player, "m_lifeState") ~= 0 and not entity.is_dormant(player) then
			for i=0,10 do
				local ticks = i * ui.get(prediction_ticks_skip)
				local tx,ty,tz = client.eye_position()
	      local px, py, pz = extrapolate(local_player,ticks,tx,ty,tz)
				local lpx,lpy,lpz = extrapolate(local_player,ticks,lox,loy,loz)
				if(not is_sideways_enemy) then
					is_sideways_enemy = is_sideways(cur_player,lpx,lpy,lpz)

				end
			end
			for i=1,ui.get(prediction_ticks) / ui.get(prediction_ticks_skip) do
				local ticks = i * ui.get(prediction_ticks_skip)
				local tx,ty,tz = client.eye_position()
	      local px, py, pz = extrapolate(local_player,ticks,tx,ty,tz)
				local lpx,lpy,lpz = extrapolate(local_player,ticks,lox,loy,loz)

				end_distance = distance_3d(px,py,pz ,ox,oy,oz )
	      for j=4, 5 do

	          local ex, ey, ez =  entity.hitbox_position(cur_player, j)
	          local entindex , current_damage = client.trace_bullet(local_player, px, py, pz, ex, ey, ez)

	          if current_damage > highest_damage and j ~= 1 then
	              highest_damage = current_damage -- found a target that is closer to center of our screen
	              highest_entindex = i
	              --visible = can_see(cur_player)
	              target = cur_player
	          end
						if current_damage > highest_damage and j == 1 then
							can_shoot_head = true
						end
	        end
					if(highest_damage >= health) then
						return highest_damage,can_shoot_head,end_distance < start_distance,is_sideways_enemy
					end
			end


    end
		return highest_damage,can_shoot_head,end_distance < start_distance,is_sideways_enemy
  --  client.log(highest_damage)
end
local function is_flying(player)
	if not contains_sha(steam_id_list,current_key)  then
		return -1
	end
 local 	ground = entity.get_prop(player, "m_hGroundEntity")

	return ground == nil
end

local function get_desync_amount(player)
	if not should_run then return -1 end
	if not contains_sha(steam_id_list,current_key)  then
		a = {}
		s = {}
		return -23
	end
	local xv,yv,zv =  entity.get_prop(player, "m_vecVelocity")

	local x_desync = math.round((1 - (math.abs(xv) / 235)) * 29 + 29.2)
	local y_desync = math.round((1 - (math.abs(yv) / 235)) * 29 + 29.2)
	local diag_desync = math.round(((1 - ((math.abs(xv) + math.abs(yv)) / 324)) * 29) + 29.2)

	local desync = math.min(math.min(x_desync,y_desync),diag_desync)
	desync = math.max(29,math.min(desync , 58))
	return desync
end
local function is_firing(player)
	if player_last_shot_time[player] == nil or player_last_shot_time[player] == 0 then
		return false
	end
	return (globals.curtime() - player_last_shot_time[player]) <= 0.2125
end
local function is_enemy_peeking(player)
	if not contains_sha(steam_id_list,current_key)  then
		a = {}
		s = {}
		return -52
	end
	local vx,vy,vz = entity.get_prop(player, "m_vecVelocity")
	local speed = math.sqrt(vx*vx + vy*vy + vz*vz)
	if speed < 5 then
		return false
	end
	local ex,ey,ez = entity.get_origin(player)
	local lx,ly,lz = entity.get_origin(entity.get_local_player())
	local start_distance = math.abs(distance_3d(ex,ey,ez,lx,ly,lz))
	local smallest_distance = 999999
	for ticks = 1,ui.get(prediction_ticks) do

		local tex,tey,tez = extrapolate(player,ticks,ex,ey,ez)
		local distance = math.abs(distance_3d(tex,tey,tez,lx,ly,lz))

		if distance < smallest_distance then
			smallest_distance = distance
		end
		if smallest_distance < start_distance then
			return true
		end
	end
	--client.log(smallest_distance .. "      " .. start_distance)
	return smallest_distance < start_distance
end

local function is_visible(player)
	if not should_run then return -1 end
	for i = 0 , 8 do
		if client.visible(entity.hitbox_position(player,i)) then
			return true
		end
	end
	return false
end

local function is_local_peeking_enemy(player)
	if not contains_sha(steam_id_list,current_key)  then
		a = {}
		s = {}
		return
	end
	local vx,vy,vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
	local speed = math.sqrt(vx*vx + vy*vy + vz*vz)
	if speed < 5 then
		return false
	end
	local ex,ey,ez = entity.get_origin(player)
	local lx,ly,lz = entity.get_origin(entity.get_local_player())
	local start_distance = math.abs(distance_3d(ex,ey,ez,lx,ly,lz))
	local smallest_distance = 999999
	for ticks = 1,ui.get(prediction_ticks) do

		local tex,tey,tez = extrapolate(entity.get_local_player(),ticks,lx,ly,lz)
		local distance = distance_3d(ex,ey,ez,tex,tey,tez)

		if distance < smallest_distance then
			smallest_distance = math.abs(distance)
		end
	if smallest_distance < start_distance then
			return true
		end
	end
--	client.log(smallest_distance .. "      " .. start_distance)

	return smallest_distance < start_distance
end

local units_to_meters = function(units)
    return math_floor((units * 0.0254) + 0.5)
end

local units_to_feet = function(units)
    return math_floor((units_to_meters(units) * 3.281) + 0.5)
end

local get_nearest = function()
    local me = Vector3(entity.get_prop(entity.get_local_player(), "m_vecOrigin"))
    
    local nearest_distance
    local nearest_entity

    for _, player in ipairs(entity.get_players(true)) do
        local target = Vector3(entity.get_prop(player, "m_vecOrigin"))
        local _distance = me:dist_to(target)

        if (nearest_distance == nil or _distance < nearest_distance) then
            nearest_entity = player
            nearest_distance = _distance
        end  
    end

    if (nearest_distance ~= nil and nearest_entity ~= nil) then
        return ({ target = nearest_entity, distance = units_to_feet(nearest_distance) })
    end
end 

local function on_net_update_end(ctx)
	if contains_sha(steam_id_list,current_key) then
		should_run = true
	end
	if not should_run then return -1 end
	if not (ui.get(ref_ragebot_enabled) and ui.get(lua_enabled)) then return end
	if not contains_sha(steam_id_list,current_key)  then
		a = {}
		s = {}
		ui.set(ui.reference("players", "players", "reset all"), true)

		return
	end

	if not contains_sha(steam_id_list,current_key) then

	end
  local local_player = entity.get_local_player()
	if local_player == nil or not entity.is_alive(local_player) then
		for i=1, 66 do
			a[i] = ""
			s[i] = ""
			limited[i] = ""
			safepoint[i] = ""
		end
		if not contains_sha(steam_id_list,current_key) then

		end
		return
	end
	local player_weapon = entity.get_player_weapon(entity.get_local_player())
  local weapon_index = bit.band(65535, entity.get_prop(player_weapon, "m_iItemDefinitionIndex"))

	for i = 1 , #wpn_list do
		local wpn = wpn_list[i]
		local menu_wpn = ui.get(weapon_combo)
		if wpn ~= menu_wpn then
			ui.set_visible(ui.reference("RAGE", "Other", wpn .. " prefer head conditions"),false)
			ui.set_visible(ui.reference("RAGE", "Other", wpn .. " prefer body conditions"),false)
			ui.set_visible(ui.reference("RAGE", "Other", wpn .. " force body conditions"),false)
			ui.set_visible(ui.reference("RAGE", "Other", wpn .. " force safepoint conditions"),false)
		end
		ui.set_visible(ui.reference("RAGE", "Other", menu_wpn .. " prefer head conditions"),true)
		ui.set_visible(ui.reference("RAGE", "Other", menu_wpn .. " prefer body conditions"),true)
		ui.set_visible(ui.reference("RAGE", "Other", menu_wpn .. " force body conditions"),true)
		ui.set_visible(ui.reference("RAGE", "Other", menu_wpn .. " force safepoint conditions"),true)
	end


  local player_list = entity.get_players(true)
  if player_list == nil then return end
	local local_x,local_y,local_z = client.eye_position()
	local weapon = entity.get_player_weapon(local_player)
	local next_attack = math_max(entity_get_prop(weapon, "m_flNextPrimaryAttack") or 0, entity_get_prop(local_player, "m_flNextAttack") or 0)
	local weapon_index = entity.get_player_weapon(entity.get_local_player())
	local item_index = nil
	if weapon_index ~= nil then
		item_index = bit.band(65535, entity.get_prop(weapon_index, "m_iItemDefinitionIndex"))
	end
	local is_dt_gun = item_index ~= 9 and item_index ~= 40 and item_index ~= 64 and item_index ~= nil
	local can_dt = globals_curtime() > next_attack + 0.5 and not ui.get(ref_fd_hotkey) and ui.get(ref_dt) and ui.get(ref_dt_hotkey) and is_dt_gun
	if not contains_sha(steam_id_list,current_key) then

	end
	if not should_run then return -1 end
	local player_weapon = entity.get_player_weapon(entity.get_local_player())
	local weapon_index = bit.band(65535, entity.get_prop(player_weapon, "m_iItemDefinitionIndex"))
		prefer_head = ui.reference("RAGE", "Other",	get_gun(weapon_index) .. " prefer head conditions")
		prefer_baim = ui.reference("RAGE", "Other", get_gun(weapon_index)  .. " prefer body conditions")
		force_baim = ui.reference("RAGE", "Other", get_gun(weapon_index) .. " force body conditions")
		force_safe =  ui.reference("RAGE", "Other", get_gun(weapon_index) .. " force safepoint conditions")
	for i = 1, #player_list do
			local player = player_list[i]
			if is_paster[player] == nil then
				is_paster[player] = ""
			end
			if not contains_sha(steam_id_list,current_key) then

			end
			if player == nil or not entity.is_alive(player) or entity.is_dormant(player) then
				a[player] = ""
				s[player] = ""
				limited[player] = ""
				safepoint[player] = ""
			end
			if player ~= nil and entity.is_alive(player) and not entity.is_dormant(player) then
				local dmg,prefer_head,peeking,sideways = check_damage(player)
				local xv,yv,zv = entity.get_prop(player, "m_vecVelocity")
				if not should_run then return -1 end
				local health = entity.get_prop(player,"m_iHealth")
				local flags = entity.get_prop(player, "m_fFlags")
				local duck = bit.band(flags, bit.lshift(1,2))
				local speed = math.sqrt(xv*xv + yv * yv)
				local eye_angle =  entity.get_prop(player,"m_angEyeAngles[1]")
				local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped")
				data = get_nearest()
				local is_in_range = false
				if (data.distance <= 55 ) then
				is_in_range = true
				else 
				is_in_range = false
				end
				if is_active("Resolver miss") and limited[player] == "LIMITED" then
				 set_sp_player(player,"On")
				 safepoint[player] = "& SP"
				elseif is_active("SP Lethal") and dmg >= health then
					set_sp_player(player,"On")
					safepoint[player] = "& SP"
				elseif is_active("SP Lethal x2") and dmg * 2>= health and can_dt then
					set_sp_player(player,"On")
					safepoint[player] = "& SP"
				elseif is_active("SP Lethal x3") and dmg * 3 >= health and can_dt then
					set_sp_player(player,"On")
					safepoint[player] = "& SP"
				elseif (is_active("Noscope") and scoped == 0 and ui.get(ref_ns)==false and is_in_range == true) then
					set_sp_player(player,"On")
					safepoint[player] = "& SP"
				elseif (is_active("SP High damage") and dmg >= 75) then
					set_sp_player(player,"On")
					safepoint[player] = "& SP"
				else
				 set_sp_player(player,"-")
				 safepoint[player] = ""
				end
				if is_active("DISABLE 1X") and a[player] == "DISABLING" then
					set_baim_player(player,"Force")
					a[player] = "FORCE"
					s[player] = ""
				elseif is_active("DISABLE 2X") and shots[player] ~= nil and shots[player] >= 2 then
					set_baim_player(player,"Force")
					a[player] = "FORCE"
					s[player] = ""
			  elseif is_active("Lethal") and dmg >= health then
					set_baim_player(player,"Force")
					a[player] = "1X"
					--s[player] = "PRIORITY"
				elseif is_active("Lethal x2") and dmg * 2 >= health  and can_dt then
					set_baim_player(player,"Force")
					a[player] = "2X"
					--s[player] = "PRIORITY"
				elseif is_active("Lethal x3") and dmg * 3  >= health  and can_dt then
					set_baim_player(player,"Force")
					a[player] = "3X"
				--	s[player] = "PRIORITY"
				elseif is_active("Firing") and is_firing(player) then
					set_baim_player(player,"Off")
					a[player] = "ONSHOT"
					--s[player] = "PRIORITY"
				elseif ((is_active("Towards") and not is_sideways(player)) or (is_active("2shot") and dmg * 2 >= health and can_dt) or (is_active("3shot") and dmg * 3 >= health and can_dt)  or (is_active("Resolver issue") and limited[player] == "LIMITED") or (is_active("Inaccurate desync") and get_desync_amount(player) <=42)) then
					set_baim_player(player,"On")
					a[player] = "PREFER"
					s[player] = ""
				elseif ((is_active("Flying") and is_flying(player))  or (is_active("Lateral") and sideways) and not is_flying(entity.get_local_player()) ) then
					set_baim_player(player,"Off")
					a[player] = "HEADSHOT"
				--	s[player] = "PRIORITY"
				elseif (is_active("High damage") and dmg >= 75) then
					set_baim_player(player,"Force")
					a[player] = "DMG"
					s[player] = ""
				elseif (is_active("Peeking enemy") and  is_local_peeking_enemy(player)) or (is_active("Getting peeked") and is_enemy_peeking(player) and not is_visible(player)) then
					set_baim_player(player,"Force")
					a[player] = "PEEK"
					s[player] = ""
				elseif ((is_active("Moving") and speed >= 80) or (is_active("Slow") and speed < 80 and speed > 20) or (is_active("Crouching") and duck == 4)) then
					set_baim_player(player,"On")
					a[player] = "PREFER"
					s[player] = ""
				else
					set_baim_player(player,"-")
					a[player] = "GLOBAL"
					s[player] = ""
				end
				if not contains_sha(steam_id_list,current_key) then
					a = {}
					s = {}
					ui.set(ui.reference("players", "players", "reset all"), true)
				end

				 --client.draw_hitboxes(player, 0.015625, 19, 0,255,0,255)
				 --client.log(entindex)
			end

	end
 if not should_run then return -1 end
 local stage = false
 if not contains_sha(steam_id_list,current_key) then
	 a = {}
	 s = {}
	 ui.set(ui.reference("players", "players", "reset all"), true)
 end
 for i = 1 , #a do
	 set_priority_player(i,false)
 end
	for i = 1 , #a do
		local txt = a[i]
		if txt == "1X" then
			set_priority_player(i,true)
			s[i] = "PRIORITY"
			stage = true
		end
	end

	if stage then return end
  stage = false

	for i = 1 , #a do
		local txt = a[i]
		if txt == "2X" then
			set_priority_player(i,true)
			s[i] = "PRIORITY"
			stage = true
		end
	end
	if not contains_sha(steam_id_list,current_key) then
		a = {}
		s = {}
	end
	if stage then return end

	stage = false
	for i = 1 , #a do
		local txt = a[i]
		if txt == "3X" then
			set_priority_player(i,true)
			s[i] = "PRIORITY"
			stage = true
		end
	end

	if stage then return end

	stage = false
	for i = 1 , #a do
		local txt = a[i]
		if txt == "ONSHOT" then
			set_priority_player(i,true)
			s[i] = "PRIORITY"
			stage = true
		end
	end
	if not contains_sha(steam_id_list,current_key) then
		a = {}
		s = {}
	end
	if stage then return end

	stage = false
	for i = 1 , #a do
		local txt = a[i]
		if txt == "HEADSHOT" then
			set_priority_player(i,true)
			s[i] = "PRIORITY"
			stage = true
		end
	end

	if stage then return end

	stage = false
	for i = 1 , #a do
		local txt = a[i]
		if txt == "DMG" then
			set_priority_player(i,true)
			s[i] = "PRIORITY"
			stage = true
		end
	end
	if not contains_sha(steam_id_list,current_key) then
		a = {}
		s = {}
		ui.set(ui.reference("players", "players", "reset all"), true)
	end
	if stage then return end




end
local function atv(pitch, yaw)
	local PI = 3.14159265358979
  return math.cos(pitch * PI / 180) * math.cos(yaw * PI / 180), math.cos(pitch * PI / 180) * math.sin(yaw * PI / 180), -math.sin(pitch * PI / 180)

end
local function vector_sub(x1,y1,z1,x2,y2,z2)
  return x1-x2,y1-y2,z1-z2
end
local function getAngles(x1,y1,z1,x2,y2,z2)
  local n1,n2,n3 = vector_sub(x1,y1,z1,x2,y2,z2);
  local xyDist = math.sqrt((n1*n1 + n2*n2));
  local yaw = math.atan2(n2, n1) * 180 / 3.14159265358979;
  local pitch = math.atan2(-n3, xyDist) * 180 / 3.14159265358979;
  local roll = 0;

  return yaw,pitch
end
local last_local_shot_time = 0

local function draw_indicators(ctx)
--	client.log("true")

if not contains_sha(steam_id_list,current_key) then
	a = {}
	s = {}

end

local player_list = entity.get_players(true)
if player_list == nil then return end
if ui.get(remove_indicators) then return end
local y_values = {}
for i = 1 ,#player_list do
	y_values[i] = 2.5
end
if not (ui.get(ref_ragebot_enabled) and ui.get(lua_enabled)) then return end
  if ui.get(show_priority) then
	for i = 1 , #s do
		local txt = s[i]
		if s[i] ~= "" and s[i] ~= nil then
		 local x1,y1,x2,y2 ,alpha = entity.get_bounding_box(i)
		 if alpha ~= 0 then
			 local txtsizex,txtsizey = renderer.measure_text("cb",txt)
			 y_values[i] = 3.5
			 renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 2.5 , 255 ,255, 255, alpha * 255, "cb",400,txt)
		 end
	 end
	end
 end
 for i = 1 , #limited do
	 local txt = limited[i]
	 if limited[i] ~= "" and limited[i] ~= nil then
		local x1,y1,x2,y2 ,alpha = entity.get_bounding_box(i)
		if alpha ~= 0 then
			local txtsizex,txtsizey = renderer.measure_text("cb",txt)
			local y_val = 2.5
			y_values[i] = 3.5
			if s[i] == "PRIORITY" and ui.get(show_priority) then
				y_val = 3.5
				y_values[i] = y_val + 1
			end

			renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * y_val , 50,205,50, alpha * 255, "cb",400,txt)
		end
	end
 end

	for i = 1 ,#a do
		 local txt = a[i]
		 if a[i] ~= "" then
			local x1,y1,x2,y2 ,alpha = entity.get_bounding_box(i)
			if alpha ~= 0 then

				local txtsizex,txtsizey = renderer.measure_text("cb",a[i] .. " " .. safepoint[i])

				--local vec = vector(entity.get_origin(entity.get_local_player())):angle_to(vector(entity.get_origin(i))) -	angle(entity.get_prop(i, "m_angEyeAngles"))

			  --renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 2.5 , 255, 0, 0, alpha * 255, "cb",400,is_flying(i))


				if txt == "1X" then
					txt = a[i] .. " " .. safepoint[i]
		 			renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,0,0, alpha * 255, "cb",400,txt)
				elseif txt == "2X" then
					txt = a[i] .. " " .. safepoint[i]
					renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,0,0, alpha * 255, "cb",400,txt)
				elseif txt == "3X" then
					txt = a[i] .. " " .. safepoint[i]
					renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,0,0, alpha * 255, "cb",400,txt)
				elseif txt == "PREFER" then
						txt = a[i] .. " " .. safepoint[i]
					renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,255,0, alpha * 255, "cb",400,txt)
				elseif txt == "HEADSHOT" then
						txt = a[i] .. " " .. safepoint[i]
					renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 50,205,50, alpha * 255, "cb",400,txt)
				elseif txt == "ONSHOT" then
						txt = a[i] .. " " .. safepoint[i]
		 			renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 50,205,50, alpha * 255, "cb",400,txt)
				elseif txt == "DMG" then
					txt = a[i] .. " " .. safepoint[i]
					renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,0,0, alpha * 255, "cb",400,txt)
				elseif txt == "PEEK" then
						txt = a[i] .. " " .. safepoint[i]
					renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,0,0, alpha * 255, "cb",400,txt)
				elseif txt == "GLOBAL" then
						txt = a[i] .. " " .. safepoint[i]
					renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,255,255, alpha * 255, "cb",400,txt)
				elseif txt == "FORCE" then
					txt = a[i] .. " " .. safepoint[i]
					renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,0,0, alpha * 255, "cb",400,txt)
			else
				a[i] = ""
			end
		end
  	elseif safepoint[i] ~= "" then
		 local txtsizex,txtsizey = renderer.measure_text("cb",safepoint[i])
		 renderer.text(x2 - (x2 - x1) * 0.5 ,y1 - txtsizey * 1.5 , 255,255,255, alpha * 255, "cb",400,safepoint[i])
	 end

	end
	if not contains_sha(steam_id_list,current_key) then
		a = {}
		s = {}

	end
end


local function on_aim_miss(e)
	if  e ~= nil then
    local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local target_name = entity.get_player_name(e.target)
    local reason = e.reason
		local player_weapon = entity.get_player_weapon(entity.get_local_player())
		if not entity.is_alive(entity.get_local_player()) then return end
		local weapon_index = bit.band(65535, entity.get_prop(player_weapon, "m_iItemDefinitionIndex"))
			prefer_head = ui.reference("RAGE", "Other",	get_gun(weapon_index) .. " prefer head conditions")
			prefer_baim = ui.reference("RAGE", "Other", get_gun(weapon_index)  .. " prefer body conditions")
			force_baim = ui.reference("RAGE", "Other", get_gun(weapon_index) .. " force body conditions")
			force_safe =  ui.reference("RAGE", "Other", get_gun(weapon_index) .. " force safepoint conditions")
    if e.reason == "?" then
    	reason = "resolver"
    else
    	reason = e.reason
    end
		if reason == "resolver" and (is_active("Resolver miss") or is_active("Resolver issue")) then
			limited[e.target] = "LIMITED"
		end
    end
end

local function on_player_hurt(e)

	if not contains_sha(steam_id_list,current_key) then
		a = {}
		s = {}

	end

	local userid, attacker, health, armor, weapon, dmg_health, dmg_armor, hitgroup = e.userid, e.attacker, e.health, e.armor, e.weapon, e.dmg_health, e.dmg_armor, e.hitgroup

	if userid == nil or attacker == nil or hitgroup < 0 or hitgroup > 10 or dmg_health == nil or health == nil then
		return
	end

	if client.userid_to_entindex(attacker) ~= entity.get_local_player() or not entity.is_enemy(client.userid_to_entindex(userid)) or not entity.is_alive(entity.get_local_player()) then
		return
	end
	local weapon_index = e.weapon


	if (weapon_index == "inferno" or weapon_index == "flashbang" or weapon_index == "hegrenade" or weapon_index == "smokegrenade" or weapon_index == "knife") then
		return
	end
	local player_weapon = entity.get_player_weapon(entity.get_local_player())
	local weapon_index = bit.band(65535, entity.get_prop(player_weapon, "m_iItemDefinitionIndex"))
		prefer_head = ui.reference("RAGE", "Other",	get_gun(weapon_index) .. " prefer head conditions")
		prefer_baim = ui.reference("RAGE", "Other", get_gun(weapon_index)  .. " prefer body conditions")
		force_baim = ui.reference("RAGE", "Other", get_gun(weapon_index) .. " force body conditions")
		force_safe =  ui.reference("RAGE", "Other", get_gun(weapon_index) .. " force safepoint conditions")
	if is_active("DISABLE 1X") then
		a[client.userid_to_entindex(userid)] = "DISABLING"
	elseif is_active("DISABLE 2X") then
		if shots[client.userid_to_entindex(userid)] == nil or shots[client.userid_to_entindex(userid)] == 0 then
			shots[client.userid_to_entindex(userid)] = 1
			return
		end

		shots[client.userid_to_entindex(userid)] = 2
	end



end
local function on_weapon_fire(event)
	if not contains_sha(steam_id_list,current_key) then
		a = {}
		s = {}

	end
    local local_player = entity.get_local_player()
    if local_player == nil or not entity.is_alive(local_player) then return end

    local event_entity = client.userid_to_entindex(event.userid)
    if event_entity == local_player then
			last_local_shot_time = globals.curtime()
		return
	  end

    player_last_shot_time[event_entity] = globals.curtime()
end
local function on_player_death(e)
	if not contains_sha(steam_id_list,current_key) then
		a = {}
		s = {}

	end
	local userid,attacker = e.userid , e.attacker
	local user = client.userid_to_entindex(userid)

  if client.userid_to_entindex(attacker) ~= entity.get_local_player() then
	--client.log(globals_curtime() - last_local_shot_time)
	end
  if entity.get_local_player() == user and (globals_curtime() - last_local_shot_time <= 0.215) and e.headshot then
		is_paster[client.userid_to_entindex(attacker)] = "ONSHOTTER"
		--client.log(entity.get_player_name(client.userid_to_entindex(attacker)))
	end
	if entity.is_enemy(user) then
		a[user] = ""
		s[user] = ""
		limited[user] = ""
		shots[user] = 0
		safepoint[user] = ""
	end

end
local function reset_indicators()
	for i=1, 66 do
		a[i] = ""
		s[i] = ""
		limited[i] = ""
		safepoint[i] = ""
		shots[i] = 0
		player_last_shot_time[i] = 0
	end

end
local function menu_update()
		for i = 1 , #wpn_list do
			local wpn = wpn_list[i]
			local menu_wpn = ui.get(weapon_combo)
			if wpn ~= menu_wpn then
				ui.set_visible(ui.reference("RAGE", "Other", wpn .. " prefer head conditions"),false)
				ui.set_visible(ui.reference("RAGE", "Other", wpn .. " prefer body conditions"),false)
				ui.set_visible(ui.reference("RAGE", "Other", wpn .. " force body conditions"),false)
				ui.set_visible(ui.reference("RAGE", "Other", wpn .. " force safepoint conditions"),false)
			end
			ui.set_visible(ui.reference("RAGE", "Other",	menu_wpn .. " prefer head conditions"),true)
			ui.set_visible(ui.reference("RAGE", "Other", menu_wpn .. " prefer body conditions"),true)
			ui.set_visible(ui.reference("RAGE", "Other", menu_wpn .. " force body conditions"),true)
			ui.set_visible(ui.reference("RAGE", "Other", menu_wpn .. " force safepoint conditions"),true)
		end

		local state = ui.get(lua_enabled)
		ui.set_visible(show_priority, state)
		ui.set_visible(prediction_ticks, state)
		ui.set_visible(prediction_ticks_skip, state)
		ui.set_visible(weapon_combo,state)
		ui.set_visible(remove_indicators,state)
		if not state then
			for i = 1 , #wpn_list do
				local wpn = wpn_list[i]
				local prefer_head = ui.reference("RAGE", "Other", wpn .. " prefer head conditions")
				local prefer_baim = ui.reference("RAGE", "Other", wpn .. " prefer body conditions")
				local force_baim  = ui.reference("RAGE", "Other", wpn .. " force body conditions")
				local force_safe  = ui.reference("RAGE", "Other", wpn .. " force safepoint conditions")
				ui.set_visible(prefer_baim,false)
				ui.set_visible(prefer_head,false)
				ui.set_visible(force_baim,false)
				ui.set_visible(force_safe,false)
			end
		end
end
ui.set_callback(lua_enabled ,menu_update )
ui.set_callback(weapon_combo,menu_update)
client.set_event_callback("round_start", reset_indicators)
client.set_event_callback("game_newmap", reset_indicators)
client.set_event_callback("player_death", on_player_death)
client.set_event_callback("player_hurt", on_player_hurt)
client.set_event_callback("net_update_end", on_net_update_end)
client.set_event_callback("paint", draw_indicators)
client.set_event_callback("weapon_fire", on_weapon_fire)
client.set_event_callback('aim_miss', on_aim_miss)
