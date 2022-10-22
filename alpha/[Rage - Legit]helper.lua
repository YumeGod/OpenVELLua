-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_camera_angles, client_color_log, client_delay_call, client_error_log, client_exec, client_eye_position, client_log, client_screen_size, client_set_event_callback, client_unset_event_callback, client_userid_to_entindex, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_set_prop, globals_curtime, globals_realtime, globals_mapname, globals_tickinterval, math_abs, math_ceil, math_floor, math_max, math_min, math_sqrt, renderer_circle, renderer_circle_outline, renderer_line, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_format, table_concat, table_insert, table_remove, table_sort, ui_get, ui_new_button, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_new_textbox, ui_reference, ui_set, ui_set_callback, loadstring, tostring, assert, require, ui_set_visible, setmetatable, type, pairs, ipairs, pcall, error, tonumber, select, unpack = client.camera_angles, client.color_log, client.delay_call, client.error_log, client.exec, client.eye_position, client.log, client.screen_size, client.set_event_callback, client.unset_event_callback, client.userid_to_entindex, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.set_prop, globals.curtime, globals.realtime, globals.mapname, globals.tickinterval, math.abs, math.ceil, math.floor, math.max, math.min, math.sqrt, renderer.circle, renderer.circle_outline, renderer.line, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.format, table.concat, table.insert, table.remove, table.sort, ui.get, ui.new_button, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.new_textbox, ui.reference, ui.set, ui.set_callback, loadstring, tostring, assert, require, ui.set_visible, setmetatable, type, pairs, ipairs, pcall, error, tonumber, select, unpack

-- super small json pretty print
-- based on https://github.com/bungle/lua-resty-prettycjson/blob/master/lib/resty/prettycjson.lua and https://github.com/bungle/lua-resty-prettycjson/blob/master/lib/resty/prettycjson.lua
local json_encode_pretty
do local a,b,c,d,e=string.byte,string.find,string.format,string.gsub,string.match;local f,g,h=table.concat,string.sub,string.rep;local i,j=1/0,-1/0;local k='[^ -!#-[%]^-\255]'local l;do local n,o;local p,q;local function r(n)q[p]=tostring(n)p=p+1 end;local s=e(tostring(0.5),'[^0-9]')local t=e(tostring(12345.12345),'[^0-9'..s..']')if s=='.'then s=nil end;local u;if s or t then u=true;if s and b(s,'%W')then s='%'..s end;if t and b(t,'%W')then t='%'..t end end;local v=function(w)if j<w and w<i then local x=tostring(w)if u then if t then x=d(x,t,'')end;if s then x=d(x,s,'.')end end;q[p]=x;p=p+1;return end;error('invalid number')end;local y;local z={['"']='\\"',['\\']='\\\\',['\b']='\\b',['\f']='\\f',['\n']='\\n',['\r']='\\r',['\t']='\\t',__index=function(_,B)return c('\\u00%02X',a(B))end}setmetatable(z,z)local function C(x)q[p]='"'if b(x,k)then x=d(x,k,z)end;q[p+1]=x;q[p+2]='"'p=p+3 end;local function D(E)local F=E[0]if type(F)=='number'then q[p]='['p=p+1;for G=1,F do y(E[G])q[p]=','p=p+1 end;if F>0 then p=p-1 end;q[p]=']'else F=E[1]if F~=nil then q[p]='['p=p+1;local G=2;repeat y(F)F=E[G]if F==nil then break end;G=G+1;q[p]=','p=p+1 until false;q[p]=']'else q[p]='{'p=p+1;local F=p;for H,n in pairs(E)do C(H)q[p]=':'p=p+1;y(n)q[p]=','p=p+1 end;if p>F then p=p-1 end;q[p]='}'end end;p=p+1 end;local I={boolean=r,number=v,string=C,table=D}setmetatable(I,I)function y(n)if n==o then q[p]='null'p=p+1;return end;return I[type(n)](n)end;function l(J,K)n,o=J,K;p,q=1,{}y(n)return f(q)end;function json_encode_pretty(n,L,M,N)local x,O=l(n)if not x then return x,O end;L,M,N=L or"\n",M or"\t",N or" "local p,G,H,w,P,Q,R=1,0,0,#x,{},nil,nil;local S=g(N,-1)=="\n"for T=1,w do local B=g(x,T,T)if not R and(B=="{"or B=="[")then P[p]=Q==":"and f{B,L}or f{h(M,G),B,L}G=G+1 elseif not R and(B=="}"or B=="]")then G=G-1;if Q=="{"or Q=="["then p=p-1;P[p]=f{h(M,G),Q,B}else P[p]=f{L,h(M,G),B}end elseif not R and B==","then P[p]=f{B,L}H=-1 elseif not R and B==":"then P[p]=f{B,N}if S then p=p+1;P[p]=h(M,G)end else if B=='"'and Q~="\\"then R=not R and true or nil end;if G~=H then P[p]=h(M,G)p,H=p+1,G end;P[p]=B end;Q,p=B,p+1 end;return f(P)end end end

local ordered_table = {}
do local b={}local c={}function ordered_table.insert(d,e,f)if f==nil then ordered_table.remove(d,e)else if d[b][e]==nil then d[c][#d[c]+1]=e end;d[b][e]=f end end;local function g(d,f)for h,i in ipairs(d)do if f==i then return h end end end;function ordered_table.remove(d,e)local j=d[b]local f=j[e]if f~=nil then local k=d[c]table.remove(k,assert(g(k,e)))j[e]=nil end;return f end;function ordered_table.pairs(d)local h=0;return function()h=h+1;local l=d[c][h]if l~=nil then return l,d[b][l]end end end;ordered_table.__newindex=ordered_table.insert;ordered_table.__len=function(d)return#d[c]end;ordered_table.__pairs=ordered_table.pairs;ordered_table.__index=function(d,e)return d[b][e]end;function ordered_table:new(m)m=m or{}local n={}local o={}local d={[c]=n,[b]=o}local p=#m;if p%2~=0 then error("key: "..tostring(m[#m]).." is missing value",2)end;for h=1,p/2 do local e=m[h*2-1]local f=m[h*2]if o[e]~=nil then error("duplicated key:"..tostring(e),2)end;n[#n+1]=e;o[e]=f end;return setmetatable(d,self)end;setmetatable(ordered_table,{__call=ordered_table.new}) end

local package_loaded = package.loaded

local vector3, vector2
do
	local vector = (function() local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,pcall,t,u,v,w,error,type,tonumber,setmetatable=client.camera_angles,client.draw_debug_text,client.eye_position,client.trace_bullet,client.trace_line,entity.get_local_player,math.abs,math.acos,math.atan,math.atan2,math.cos,math.deg,math.fmod,math.max,math.min,math.rad,math.random,math.sin,math.sqrt,pcall,renderer.line,renderer.text,renderer.world_to_screen,string.char,error,type,tonumber,setmetatable;local x=require"ffi"local y,z=x.sizeof,x.istype;local A=x.typeof("struct { float x, y, z; }")local B=x.typeof("struct { float x, y; }")local C=1/0;local function D(E,F)if not E then error(F,4)end end;local function G(H,I,J)return o(n(H,I),J)end;local function K(L)if L~=L or L==C then return 0 elseif L>=-180 and L<=180 then return L end;local M=m(m(L+360,360),360)return M>180 and M-360 or M end;local N={}local O={__index=N}local P={}local Q;local function R(E)return z(A,E)end;local function S(E)if R(E)then return E:unpack()elseif type(E)=="number"then return E,E,E else error("Invalid arguments",3)end end;local function T(E,U)D(R(E),(U or"self").." has to be vector3")end;local V={}local W={__index=V}local X;local function Y(E)return z(B,E)end;local function Z(_)if Y(_)then return _:unpack()elseif type(_)=="number"then return _,_ else error("Invalid arguments")end end;function O:__eq(_)local a0,a1=R(self),R(_)if a0 and a1 then return self.x==_.x and self.y==_.y and self.z==_.z elseif a0 or a1 then return false else print("fail")end end;function O:__unm()T(self)return Q(-self.x,-self.y,-self.z)end;function O:__add(_)T(self)local a2,a3,a4=S(_)return Q(self.x+a2,self.y+a3,self.z+a4)end;function O:__sub(_)T(self)local a2,a3,a4=S(_)return Q(self.x-a2,self.y-a3,self.z-a4)end;function O:__mul(_)T(self)local a2,a3,a4=S(_)return Q(self.x*a2,self.y*a3,self.z*a4)end;function O:__div(_)T(self)local a2,a3,a4=S(_)return Q(self.x/a2,self.y/a3,self.z/a4)end;function O:__tostring()T(self)return"("..self.x..", "..self.y..", "..self.z..")"end;function O.__call(a5,a2,a3,a4)return Q(a2,a3,a4)end;function N:clear()self.x,self.y,self.z=0,0,0 end;function N:unpack()return self.x,self.y,self.z end;function N:dup()return Q(self:unpack())end;N.clone=N.dup;function N:set(a2,a3,a4)if R(a2)then a2,a3,a4=a2:unpack()end;self.x=a2;self.y=a3;self.z=a4 end;function N:scale(a6)self:set(self.x*a6,self.y*a6,self.z*a6)return self end;function N:length_sqr()return self.x*self.x+self.y*self.y+self.z*self.z end;function N:length_2d_sqr()return self.x*self.x+self.y*self.y end;function N:length()return s(self:length_sqr())end;function N:length_2d()return s(self:length_2d_sqr())end;function N:dot(_)return self.x*_.x+self.y*_.y+self.z*_.z end;function N:cross(_)return Q(self.y*_.z-self.z*_.y,self.z*_.x-self.x*_.z,self.x*_.y-self.y*_.x)end;function N:dist_to(_)return(_-self):length()end;function N:dist_to_2d(_)return(_-self):length_2d()end;function N:normalize()local a7=self:length()if a7==0 then return 0 else self:scale(1/a7)return a7 end end;function N:normalize_2d()local a7=self:length_2d()if a7==0 then return 0 else self:scale(1/a7)return a7 end end;function N:normalized()local a7=self:length()if a7==0 then return Q()end;return self/a7 end;function N:lerp(_,a8)return self+(_-self)*a8 end;function N:vector_to_angle(_)local a9,aa=self,_;if _==nil then a9,aa=N(client.eye_position()),self end;local ab,ac,ad=aa.x-a9.x,aa.y-a9.y,aa.z-a9.z;if ab==0 and ac==0 then return X(ad>0 and 270 or 90,0)else local ae=l(j(ac,ab))local af=s(ab*ab+ac*ac)local ag=l(j(-ad,af))return X(ag,ae)end end;N.vector_angles=N.vector_to_angle;function N:trace_line(_,ah)ah=ah or-1;local ai,aj,ak=self:unpack()local al,am=e(ah,ai,aj,ak,_:unpack())local an=self:lerp(_,al)return al,am,an end;function N:trace_line_skip(_,ao,ap)ap=ap or 10;local al,am=0,-1;local an=self;local aq=0;while ap>=aq and al<1 and(am>-1 and ao(am)or an==self)do al,am,an=an:trace_line(_,am)aq=aq+1 end;local al=self:dist_to(an)/self:dist_to(_)return al,am,an end;function N:trace_bullet(_,ar)ar=ar or f()local ai,aj,ak=self:unpack()return d(ar,ai,aj,ak,_:unpack())end;function N:normalize_angles()self.x=n(-89,o(89,self.x))self.y=K(self.y)self.z=0 end;function N:to_screen()return v(self:unpack())end;function N:draw_text(as,at,au,av,aw,...)local ax,ay=self:to_screen()if ax~=nil then u(ax,ay,as,at,au,av,"c"..(aw or""),0,...)return true end;return false end;function N:draw_debug_text(az,aA,as,at,au,av,...)b(self.x,self.y,self.z,az,aA,as,at,au,av,...)end;function N:draw_line(_,as,at,au,av,aB)aB=aB or 1;as,at,au,av=as or 255,at or 255,au or 255,av or 255;local aC,aD=self:to_screen()local aE,aF=_:to_screen()if aC~=nil and aE~=nil then for aq=1,aB do local aG=aq-1;t(aC,aD-aG,aE,aF-aG,as,at,au,av)t(aC-aG,aD,aE-aG,aF,as,at,au,av)end end;return aC~=nil and aE~=nil end;function N.angle_forward(L)if L==nil then error("angle cannot be nil",2)end;local ag,ae=p(L.x),p(L.y)local aH,aI=r(ag),k(ag)local aJ,aK=r(ae),k(ae)return Q(aI*aK,aI*aJ,-aH)end;function N.angle_right(L)local ag,ae,aL=p(L.x),p(L.y),R(L)and p(L.z)or 0;local aH,aI=r(ag),k(ag)local aJ,aK=r(ae),k(ae)local aM,aN=r(aL),k(aL)return Q(-1.0*aM*aH*aK+-1.0*aN*-aJ,-1.0*aM*aH*aJ+-1.0*aN*aK,-1.0*aM*aI)end;function N.angle_up(L)local ag,ae,aL=p(L.x),p(L.y),R(L)and p(L.z)or 0;local aH,aI=r(ag),k(ag)local aJ,aK=r(ae),k(ae)local aM,aN=r(aL),k(aL)return Q(aN*aH*aK+-aM*-aJ,aN*aH*aJ+-aM*aK,aN*aI)end;function N.angle_to_vectors(L)return N.angle_forward(L),N.angle_right(L),N.angle_up(L)end;local function aO(aP,aQ)local aR=m(aP-aQ,360)if aP>aQ then if aR>=180 then aR=aR-360 end else if aR<=-180 then aR=aR+360 end end;return aR end;local function aS(aT,E,aU)aT=K(aT)E=K(E)local aR=aT-E;if aU<0 then aU=-aU end;if aR<-180 then aR=aR+360 elseif aR>180 then aR=aR-360 end;if aR>aU then E=E+aU elseif aR<-aU then E=E-aU else E=aT end;return E end;Q=x.metatype(A,O)function W:__eq(_)return Y(_)and self.x==_.x and self.y==_.y end;function W:__unm(_)return X(-self.x,-self.y)end;function W:__add(_)local a2,a3=Z(_)return X(self.x+a2,self.y+a3)end;function W:__sub(_)local a2,a3=Z(_)return X(self.x-a2,self.y-a3)end;function W:__mul(_)local a2,a3=Z(_)return X(self.x*a2,self.y*a3)end;function W:__div(_)local a2,a3=Z(_)return X(self.x/a2,self.y/a3)end;function W:__tostring()return"("..self.x..", "..self.y..")"end;function W.__call(a5,a2,a3)return X(a2,a3)end;function V:clear()self.x,self.y=0,0 end;function V:unpack()return self.x,self.y end;function V:dup()return X(self:unpack())end;V.clone=V.dup;function V:set(a2,a3,a4)if Y(a2)then a2,a3=a2:unpack()end;self.x=a2;self.y=a3 end;function V:scale(a6)self:set(self.x*a6,self.y*a6)return self end;function V:length_sqr()return self.x*self.x+self.y*self.y end;function V:rad()return X(p(self.x),p(self.y))end;function V:deg()return X(l(self.x),l(self.y))end;V.length_2d_sqr=V.length_sqr;function V:length()return s(self:length_sqr())end;V.length_2d=V.length;function V:dist_to(_)return(_-self):length()end;V.dist_to_2d=V.dist_to;function V:normalize()local a7=self:length()if a7==0 then return 0 else self:scale(1/a7)return a7 end end;function V:dot(_)return self.x*_.x+self.y*_.y end;function V:perp()return X(-self.y,self.x)end;function V:normalize_angles()self.x=n(-89,o(89,self.x))self.y=K(self.y)end;X=x.metatype(B,W)setmetatable(N,{__call=function(a5,a2,a3,a4)if R(a2)or Y(a2)then a2,a3,a4=a2:unpack()a4=a4 or 0 end;a2,a3,a4=tonumber(a2),tonumber(a3),tonumber(a4)if a2==nil or a3==nil or a4==nil then return end;return Q(a2,a3,a4)end})setmetatable(V,{__call=function(a5,a2,a3)if R(a2)or Y(a2)then a2,a3=a2:unpack()end;a2,a3=tonumber(a2),tonumber(a3)if a2==nil or a3==nil then return end;return X(a2,a3)end})return setmetatable({vector3=N,vector2=V,normalize_angle=K,angle_diff=aO,angle_approach=aS,clamp=G},{__call=function()return N,V end,__index=function(aV,aW)if type(aW)=="string"then return aV[aW:lower()]end end}) end)()

	vector3, vector2 = vector.vector3, vector.vector2
end
local db = database.read("helper") or {}
db["local_locations"] = db["local_locations"] or {}

local function get(module)
	return module.get()
end

local data_weapon, weapon_prev, reload_data, last_weapon_switch, data_map = {}

local function reset_cvar(cvar)
	local val = tonumber(cvar:get_string())
	cvar:set_raw_int(val)
	cvar:set_raw_float(val)
end
local function lerp(a, b, percentage)
	return a + (b - a) * percentage
end
local function table_contains(tbl, val)
	for i = 1, #tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end
local function chunk_string(str, size)
	if size > str:len() then
		return {str}
	end

	local output = {}
	local pattern = string.rep(".", size);
	str = str:gsub(pattern, function(part)
		table.insert(output, part)
		return ""
	end)

	if(#str > 0) then
		table.insert(output, str)
	end

	return output
end
local function gsub(str, res, rep)
	return str:gsub(".", function(c)
		return c == res and rep or c
	end)
end
local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	if num >= 0 then return math_floor(num * mult + 0.5) / mult
	else return math_ceil(num * mult - 0.5) / mult end
end

local console_prefix = {183, 232, 16, "[gamesense] "}
local MOVETYPE_NOCLIP = 8
local dist_max = 1100
local dist_max_sqr = dist_max^2
local wx_offset_vec = vector3(0, 0, 20)
local land_offsets_vec = {
	vector3(0, 0, 12),
	vector3(0, 12, 0),
	vector3(12, 0, 0)
}

local helper_debug = false
local cvar_sensitivity = cvar.sensitivity
local MOVE_PREPARE, MOVE_THROW, MOVE_DONE = 1, 2, 3
local airstrafe_reference = ui.reference("MISC", "Movement", "Air strafe")
local quick_peek_assist_reference = ui.reference("MISC", "Movement", "Easy strafe")
local infinite_duck_reference = ui.reference("MISC", "Movement", "Infinite duck")
local brightness_adjustment_reference = ui.reference("VISUALS", "Effects", "Brightness adjustment")

local enabled_reference = ui.new_checkbox("VISUALS", "Other ESP", "Helper")
local hotkey_reference = ui.new_hotkey("VISUALS", "Other ESP", "Helper hotkey", true)
local types_reference = ui.new_multiselect("VISUALS", "Other ESP", "\nHelper types\nv2", {
	"Grenade: Smoke",
	"Grenade: Flashbang",
	"Grenade: High Explosive",
	"Grenade: Molotov",
	"Wallbang",
	"HvH: Location",
	"HvH: Area",
	"Movement"
})
local color_reference = ui.new_color_picker("VISUALS", "Other ESP", "Helper color", 120, 120, 255, 255)
local aimbot_reference = ui.new_combobox("VISUALS", "Other ESP", "Aim at locations", {"Off", "Legit (Smooth)", "Legit (Silent)", "Rage"})
local ignore_visibility_reference = ui.new_checkbox("VISUALS", "Other ESP", "Show locations behind walls")
local saving_enabled_reference = ui.new_checkbox("LUA", "B", "Helper saving")
local saving_hotkey_reference = ui.new_hotkey("LUA", "B", "Helper saving hotkey", true)
local saving_from_reference = ui.new_textbox("LUA", "B", "From")
local saving_to_reference = ui.new_textbox("LUA", "B", "To")
local saving_type_reference = ui.new_combobox("LUA", "B", "Type", {
	"Grenade",
	"Wallbang: Legit",
	"HvH: Location",
	"Movement"
})
local saving_properties_reference = ui.new_multiselect("LUA", "B", "Properties", {
	"Jump",
	"Run",
	"Walk",
	"Tickrate",
	"Destroy"
})
local saving_run_direction_reference = ui.new_combobox("LUA", "B", "Run duration / direction", {"Forward", "Left", "Right", "Back"})
local saving_run_duration_reference = ui.new_slider("LUA", "B", "\nRun duration", 1, 256, 20, true, "t")

local data_all = {}

setmetatable(data_all, {
	__metatable = false,
	__pairs = function(tbl, map)
		local preset_next = {["de_train"]="de_cache_old",["de_cache_old"]="de_dust2",["de_dust2"]="de_nuke",["de_nuke"]="de_cbble",["de_cbble"]="de_inferno",["de_inferno"]="de_overpass",["de_overpass"]="de_mirage",["de_mirage"]="aim_ag_texture2",["aim_ag_texture2"]="de_austria",["de_austria"]="de_vertigo",["de_vertigo"]="de_abbey",["de_abbey"]="de_shortdust",["de_shortdust"]="gd_rialto",["gd_rialto"]="de_cache",["de_cache"]="cs_office",["cs_office"]="cs_italy",["cs_italy"]="de_dust"}

		local function iter(tbl, k)
			if preset_next[k] then
				return preset_next[k], tbl[preset_next[k]]
			end
		end

		-- Return an iterator function, the table, starting point
		return iter, tbl, "de_train"
	end,
	__index = function(_, map)
		local array_to_key = {"from", "to", "type", "weapon", "x", "y", "z", "pitch", "yaw", "id"}

		local locations_data = {}
		if map == "de_train" then locations_data={{"Connector","Blue train","grenade","weapon_smokegrenade",1078.0,-753.979,-223.906,-45.804,143.152,"stwmbf_17",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=6.38},{"A1","Break Room","grenade","weapon_smokegrenade",1021.097,-254.989,-215.906,-38.495,154.562,"stwmbf_560",["throwType"]="NORMAL",["flyDuration"]=5.39},{"T Spawn","A Train","grenade","weapon_smokegrenade",-660.665,1157.718,-216.906,-43.198,-44.553,"stwmbf_415",["throwType"]="NORMAL",["flyDuration"]=6.2},{"T Long","A2","grenade","weapon_smokegrenade",1535.969,1775.969,-223.906,-9.818,-112.487,"stwmbf_419",["throwType"]="RUN",["flyDuration"]=4.02},{"T Spawn","Bomb train / Connector","grenade","weapon_smokegrenade",-627.773,1261.742,-216.306,-44.32,-53.549,"stwmbf_27",["throwType"]="NORMAL",["flyDuration"]=6.41},{"T Spawn","Bomb train","grenade","weapon_smokegrenade",-526.628,1325.407,-86.839,-26.417,-57.329,"stwmbf_24",["throwType"]="NORMAL",["flyDuration"]=4.55},{"B Stairs","Connector","grenade","weapon_smokegrenade",-653.999,-479.969,16.094,-41.597,-8.42,"stwmbf_449",["throwType"]="NORMAL",["flyDuration"]=6.81},{"White halls","Bomb train / Connector","grenade","weapon_smokegrenade",-655.969,-399.893,16.094,-46.003,10.891,"stwmbf_559",["throwType"]="NORMAL",["throwStrength"]=0.5,["flyDuration"]=5.8},{"Boilers","Connector","grenade","weapon_smokegrenade",-1160.0,-1048.002,-95.906,-11.023,5.091,"stwmbf_22",["throwType"]="RUN",["flyDuration"]=5.88},{"T Spawn","Bomb train","grenade","weapon_smokegrenade",-453.358,1286.285,-86.491,-25.131,-58.731,"stwmbf_25",["throwType"]="NORMAL",["flyDuration"]=4.17},{"White halls","Green train","grenade","weapon_smokegrenade",-613.162,-583.969,16.094,-44.023,53.456,"stwmbf_19",["throwType"]="NORMAL",["flyDuration"]=5.6},{"White halls","Ivy","grenade","weapon_smokegrenade",-655.999,-449.669,16.094,-38.578,27.88,"stwmbf_18",["throwType"]="NORMAL",["flyDuration"]=6.01},{"T Spawn","Blue train / Red train","grenade","weapon_smokegrenade",-645.479,1697.722,-209.906,-41.565,-65.087,"stwmbf_26",["throwType"]="NORMAL",["flyDuration"]=6.81},{"B Stairs","Ivy / Green Train","grenade","weapon_smokegrenade",-640.028,-583.97,16.094,-44.699,32.218,"stwmbf_417",["throwType"]="NORMAL",["flyDuration"]=5.99},{"Boilers","H2 / Bomb train","grenade","weapon_smokegrenade",-1155.979,-1301.504,-95.906,-15.858,38.883,"stwmbf_20",["throwType"]="RUN",["flyDuration"]=5.09},{"T Spawn","Electric box","grenade","weapon_smokegrenade",-645.469,1697.723,-209.909,-42.06,-72.309,"stwmbf_29",["throwType"]="NORMAL",["flyDuration"]=5.38},{"T Long","Ivy","grenade","weapon_smokegrenade",1388.426,1446.0,-223.906,-6.188,-95.525,"stwmbf_418",["throwType"]="NORMAL",["flyDuration"]=2.74},{"T Spawn","Connector","grenade","weapon_smokegrenade",-448.615,1236.031,-86.839,-29.766,-58.442,"stwmbf_558",["throwType"]="NORMAL",["flyDuration"]=5.8},{"T Spawn","Green train","grenade","weapon_smokegrenade",-803.572,388.279,-215.906,-21.022,13.709,"stwmbf_28",["throwType"]="NORMAL",["flyDuration"]=3.56},{"T Spawn","Blue train","grenade","weapon_smokegrenade",-555.031,1262.031,-212.532,-68.097,-50.974,"stwmbf_30",["throwType"]="NORMAL",["flyDuration"]=6.0},{"Boilers","B Upper","grenade","weapon_smokegrenade",-1055.969,-1607.969,-151.906,-9.076,-21.029,"stwmbf_21",["throwType"]="NORMAL",["flyDuration"]=2.76},{"Boilers","H2 Lower","grenade","weapon_smokegrenade",-1159.978,-1088.113,-95.91,-6.832,13.308,"stwmbf_23",["throwType"]="NORMAL",["flyDuration"]=4.77},{"T Spawn","Electric box","grenade","weapon_smokegrenade",-481.866,1725.012,-209.906,-45.937,-78.791,"stwmbf_327",["throwType"]="NORMAL",["flyDuration"]=5.59},{"T Spawn","Red Train / Green Train","grenade","weapon_smokegrenade",-838.162,1268.024,-222.906,-37.605,-42.065,"stwmbf_416",["throwType"]="NORMAL",["flyDuration"]=4.57},{"Connector","Bombsite A","grenade","weapon_flashbang",400.031,-420.031,-211.778,-28.859,-89.675,"stwmbf_561",["throwType"]="RUN"},{"Upper","Boilers","grenade","weapon_flashbang",-799.033,-1731.971,-127.906,-13.036,0.828,"stwmbf_562",["throwType"]="RUN",["runDuration"]=10},{"Bombsite B","Boilers","grenade","weapon_flashbang",50.86,-1023.915,-164.558,-23.86,-179.213,"stwmbf_274",["throwType"]="NORMAL"},{"Boilers","Ladder","grenade","weapon_molotov",-989.219,-1637.979,-151.906,-10.66,-19.426,"stwmbf_420",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=2.15},{"Break Room","Blue Train / Green Train","grenade","weapon_molotov",-790.029,375.929,-215.906,-11.271,27.333,"stwmbf_563",["throwType"]="RUN",["flyDuration"]=2.04},{"Break Room","Electric Box","grenade","weapon_molotov",-750.761,304.031,-215.906,-3.054,51.948,"stwmbf_564",["throwType"]="RUNJUMP",["flyDuration"]=2.39},{"T Spawn","Connector","wallbang","weapon_wallbang",-939.969,767.969,-215.969,0.054,-37.25,"custom_211",["landX"]=-673.881,["landY"]=-1224.61,["landZ"]=-165.969,["flyDuration"]=3.141},{"Popdog","Default","grenade","weapon_molotov",-647.969,-427.969,-215.969,-9.719,22.875,"custom_212",["throwType"]="NORMAL"},{"B Tunnel","B Bombsite","grenade","weapon_molotov",-1083.085,-1019.485,-55.969,-10.439,-1.101,"custom_391",["tickrate"]=64,["throwType"]="NORMAL",["flyDuration"]=1.969,["landX"]=180.538,["landY"]=-1045.464,["landZ"]=-164.502},{"B Tunnel","Back of B","grenade","weapon_molotov",-1072.908,-964.694,-55.969,-6.435,-11.042,"custom_392",["tickrate"]=64,["throwType"]="NORMAL",["flyDuration"]=2.047,["landX"]=243.828,["landY"]=-1211.434,["landZ"]=-279.996},{"Connector","Middle","grenade","weapon_molotov",616.563,-398.253,-215.969,-21.736,142.992,"custom_393",["tickrate"]=64,["throwType"]="NORMAL",["flyDuration"]=2.047,["landX"]=-720.214,["landY"]=609.362,["landZ"]=-215.969},{"Connector","Middle","grenade","weapon_molotov",674.083,-114.957,-215.969,-15.129,-171.893,"custom_394",["tickrate"]=64,["throwType"]="RUN",["flyDuration"]=2.063,["landX"]=-465.039,["landY"]=-327.102,["landZ"]=-215.969},{"Middle","Heaven","grenade","weapon_molotov",-559.025,503.161,-220.558,-30.802,-29.294,"custom_395",["tickrate"]=64,["throwType"]="RUN",["flyDuration"]=1.953,["landX"]=890.274,["landY"]=-309.938,["landZ"]=42.031},{"Connector","Olof","grenade","weapon_molotov",553.224,-410.207,-215.969,-20.392,118.568,"custom_396",["tickrate"]=64,["throwType"]="RUN",["flyDuration"]=2.063,["landX"]=-130.585,["landY"]=595.595,["landZ"]=-216},{"Middle","Stop Sign","grenade","weapon_molotov",-886.716,560.323,-215.969,-22.222,-11.088,"custom_397",["tickrate"]=64,["throwType"]="RUN",["flyDuration"]=2.063,["landX"]=895.721,["landY"]=210.908,["landZ"]=-194.112},{"Train 1","Ivy","grenade","weapon_flashbang",1000.552,485.868,-219.969,-8.609,177.693,"custom_398",["tickrate"]=64,["throwType"]="RUN",["flyDuration"]=1.656,["landX"]=1323.209,["landY"]=511.555,["landZ"]=-196.234},{"Big Ramp","B Bombsite","grenade","weapon_molotov",1083.88,-1725.087,-209.138,-13.985,162.526,"custom_399",["tickrate"]=64,["throwType"]="RUN",["flyDuration"]=2.047,["landX"]=-145.087,["landY"]=-1338.2,["landZ"]=-279.99},{"B Entrance","B Default","grenade","weapon_molotov",1404.764,-877.095,-319.969,-18.933,-177.455,"custom_400",["tickrate"]=64,["throwType"]="RUN",["flyDuration"]=2.063,["landX"]=-345.051,["landY"]=-954.882,["landZ"]=-351.969},{"Tunnel 1","A Plant","grenade","weapon_molotov",1178.96,479.209,-218.37,-12.32,-158.411,"custom_408",["throwType"]="RUN",["runDuration"]=14,["landX"]=635.161,["landY"]=81.924,["landZ"]=-134.82},{"Connector","A Site","grenade","weapon_molotov",-240.005,676.23,-215.969,-27.874,-34.519,"custom_409",["throwType"]="NORMAL",["landX"]=699.714,["landY"]=35.028,["landZ"]=-46.142},{"Connector","A Site","grenade","weapon_molotov",-235.918,417.898,-215.969,-18.865,-24.022,"custom_410",["throwType"]="NORMAL"},{"Electrical Box","A Site","grenade","weapon_molotov",-266.765,41.218,-215.969,-20.876,-0.085,"custom_411",["throwType"]="NORMAL",["landX"]=715.454,["landY"]=40.74,["landZ"]=-44.153},{"A Site","Electrical Box","grenade","weapon_molotov",634.971,-79.568,-128.768,-8.867,174.934,"custom_412",["throwType"]="RUN",["runDuration"]=9,["landX"]=-186.748,["landY"]=49.844,["landZ"]=-216},{"Electrical Box","Sniper's Nest","grenade","weapon_molotov",-249.081,61.395,-215.969,-32.25,-20.021,"custom_413",["throwType"]="NORMAL",["duck"]=true,["landX"]=758.865,["landY"]=-309.705,["landZ"]=42.031},{"Connector","A Site","grenade","weapon_molotov",-103.19,418.969,-215.969,-6.532,-53.903,"custom_414",["throwType"]="JUMP",["landX"]=465.242,["landY"]=-58.152,["landZ"]=-47.945},{"A Site","Sniper's Nest","grenade","weapon_molotov",-194.538,678.491,-215.969,-8.303,-48.332,"custom_415",["throwType"]="JUMP",["landX"]=687.883,["landY"]=-309.517,["landZ"]=40.031},{"T Main","Connector","wallbang_hvh","weapon_wallbang",-865.354,608.882,-215.969,0.693,-34.21,"custom_416"},{"T Spawn","Connector","grenade","weapon_smokegrenade",-367.969,1236.013,-136.949,-29.943,-54.572,"custom_451",["throwType"]="JUMP",["landX"]=1061.857,["landY"]=-776.262,["landZ"]=-253.973},{"T Main","Bomb Train","grenade","weapon_hegrenade",-915.591,625.355,-215.969,-17.722,-23.445,"custom_452",["throwType"]="RUN",["landX"]=503.142,["landY"]=10.133,["landZ"]=-90.936}} end
		if map == "de_cache_old" then locations_data={{"T Spawn","Connector","grenade","weapon_smokegrenade",1810.817,865.969,1676.912,-9.405,-157.949,"stwmbf_41",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=5.19},{"Boost Boxes","Quad Stack","grenade","weapon_smokegrenade",1037.031,513.005,1613.55,-51.794,127.469,"stwmbf_92",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=7.83},{"Truck","Vents","grenade","weapon_smokegrenade",-996.98,1440.232,1691.182,-33.182,-46.327,"stwmbf_39",["throwType"]="RUN",["flyDuration"]=4.05},{"Heaven","B Halls","grenade","weapon_smokegrenade",-617.969,-764.969,1796.031,12.638,6.434,"stwmbf_113",["throwType"]="NORMAL",["duck"]=false,["flyDuration"]=3.54},{"Connector","Connector (Oneway)","grenade","weapon_smokegrenade",-367.031,116.566,1663.094,-0.199,-170.006,"stwmbf_337",["throwType"]="NORMAL",["flyDuration"]=3.35},{"Vent","Vent (Oneway)","grenade","weapon_smokegrenade",425.969,-418.997,1614.094,-20.18,83.583,"stwmbf_338",["throwType"]="NORMAL",["flyDuration"]=1.52},{"NBK","Main","grenade","weapon_smokegrenade",-50.013,2261.969,1687.094,-18.613,-64.613,"stwmbf_451",["throwType"]="NORMAL",["flyDuration"]=3.76},{"Heaven","B Halls","grenade","weapon_smokegrenade",-461.031,-764.969,1796.094,-0.908,35.265,"stwmbf_38",["throwType"]="NORMAL",["flyDuration"]=3.96},{"Truck","Main","grenade","weapon_smokegrenade",-782.198,1110.0,1689.44,-9.703,24.964,"stwmbf_110",["throwType"]="NORMAL",["flyDuration"]=3.35},{"Quad boxes","Main","grenade","weapon_smokegrenade",-429.969,2261.986,1718.094,-1.766,-30.807,"stwmbf_450",["throwType"]="NORMAL",["flyDuration"]=2.54},{"T Spawn","Spool","grenade","weapon_smokegrenade",2156.584,-182.969,1613.484,-22.078,161.944,"stwmbf_268",["throwType"]="JUMP",["flyDuration"]=5.77},{"Long","Safe / Quad Boxes","grenade","weapon_smokegrenade",1319.997,1355.521,1701.094,-49.913,157.243,"stwmbf_424",["throwType"]="NORMAL",["flyDuration"]=5.79},{"Toxic","Generator","grenade","weapon_smokegrenade",827.948,-1463.969,1614.094,-25.823,165.042,"stwmbf_40",["throwType"]="NORMAL",["flyDuration"]=3.35},{"Long A","NBK","grenade","weapon_smokegrenade",1319.969,1520.396,1701.094,-57.767,161.425,"stwmbf_103",["throwType"]="NORMAL",["flyDuration"]=5.79},{"Long A","Forklift / Default","grenade","weapon_smokegrenade",1269.969,1612.969,1751.582,-62.998,-175.316,"stwmbf_95",["throwType"]="NORMAL",["flyDuration"]=5.99},{"Long","Connector","grenade","weapon_smokegrenade",1160.711,715.842,1613.094,-31.335,-153.089,"stwmbf_413",["throwType"]="NORMAL",["flyDuration"]=3.96},{"Long A","Forklift","grenade","weapon_smokegrenade",1230.754,1612.969,1701.965,-74.514,-173.895,"stwmbf_94",["throwType"]="NORMAL",["flyDuration"]=9.44},{"Long A","Default","grenade","weapon_smokegrenade",1319.998,1601.9,1737.545,-47.685,-174.765,"stwmbf_93",["throwType"]="NORMAL",["flyDuration"]=5.79},{"Squeaky","NBK","grenade","weapon_smokegrenade",139.012,2106.278,1688.031,9.371,-28.1,"stwmbf_111",["throwType"]="NORMAL",["duck"]=false,["flyDuration"]=1.55,["accurateMove"]=false},{"Squeaky","Forklift / Default","grenade","weapon_smokegrenade",139.031,2197.969,1688.094,-6.04,-60.836,"stwmbf_112",["throwType"]="RUN",["flyDuration"]=2.94},{"T Spawn","Middle","grenade","weapon_smokegrenade",2643.454,12.69,1613.094,-11.832,-179.062,"stwmbf_114",["throwType"]="RUNJUMP",["flyDuration"]=6.11,["runDuration"]=24},{"Toxic","Hell","grenade","weapon_smokegrenade",960.031,-1463.969,1644.094,-26.401,162.852,"stwmbf_336",["throwType"]="NORMAL",["flyDuration"]=4.55,["viewAnglesDistanceMax"]=0.1},{"Boost Boxes","Boost Boxes (Oneway)","grenade","weapon_smokegrenade",1037.031,513.031,1613.55,-49.138,104.64,"stwmbf_231",["throwType"]="NORMAL",["flyDuration"]=4.35},{"Toxic","Default","grenade","weapon_smokegrenade",827.971,-1463.969,1614.094,-21.995,162.191,"stwmbf_267",["throwType"]="NORMAL",["flyDuration"]=3.94},{"B Halls","Ventsroom","grenade","weapon_smokegrenade",837.744,-872.016,1614.094,-15.362,177.851,"stwmbf_101",["throwType"]="NORMAL",["flyDuration"]=3.52},{"Long A","Balcony","grenade","weapon_smokegrenade",1319.993,1578.757,1701.094,-50.903,-167.316,"stwmbf_102",["throwType"]="NORMAL",["flyDuration"]=5.79},{"Garage","Middle Roof side","grenade","weapon_smokegrenade",1711.974,463.988,1614.094,-10.676,-167.3,"stwmbf_97",["throwType"]="NORMAL",["flyDuration"]=3.35},{"Garage","Middle Spool side","grenade","weapon_smokegrenade",1711.969,-71.969,1614.094,-10.561,161.185,"stwmbf_98",["throwType"]="NORMAL",["flyDuration"]=3.35},{"New box","B Hall","grenade","weapon_flashbang",204.969,-1114.011,1659.094,-44.501,112.792,"stwmbf_423",["throwType"]="JUMP"},{"Ventsroom","B Halls","grenade","weapon_flashbang",5.553,-418.999,1614.094,-17.391,53.037,"stwmbf_85",["throwType"]="NORMAL"},{"Heaven","Bombsite B","grenade","weapon_flashbang",-633.976,-379.969,1620.094,-41.63,-58.866,"stwmbf_87",["throwType"]="NORMAL",["throwStrength"]=0.5},{"NBK","Bombsite A","grenade","weapon_flashbang",89.985,2244.983,1687.094,-71.181,-93.483,"stwmbf_89",["throwType"]="NORMAL"},{"Sandbags","Middle","grenade","weapon_flashbang",114.969,-107.322,1631.719,-16.913,-84.2,"stwmbf_106",["throwType"]="NORMAL",["duck"]=true},{"Quad boxes","Main","grenade","weapon_flashbang",-358.535,2147.728,1687.094,-17.54,2.04,"stwmbf_328",["throwType"]="NORMAL"},{"Elektro","Main","grenade","weapon_flashbang",-482.99,1441.98,1687.094,-15.857,11.925,"stwmbf_430",["throwType"]="NORMAL"},{"Main","Bombsite A","grenade","weapon_flashbang",767.0,1117.012,1702.094,-26.021,117.367,"stwmbf_105",["throwType"]="NORMAL",["throwStrength"]=0.5},{"B Halls","Checkers","grenade","weapon_flashbang",808.283,-1173.969,1614.094,-9.571,132.693,"stwmbf_340",["throwType"]="RUN"},{"B Halls","B Main","grenade","weapon_flashbang",1481.585,-729.985,1614.094,-16.715,-165.485,"stwmbf_290",["throwType"]="NORMAL"},{"B Halls","Bombsite B / Ventsroom","grenade","weapon_flashbang",879.802,-872.031,1614.094,-14.157,177.893,"stwmbf_86",["throwType"]="NORMAL"},{"Garage","Middle","grenade","weapon_flashbang",1737.197,215.031,1614.031,-9.058,154.28,"stwmbf_88",["throwType"]="RUN"},{"B Halls","Bombsite B","grenade","weapon_flashbang",1113.969,-1173.969,1614.094,-11.089,151.7,"stwmbf_339",["throwType"]="NORMAL"},{"Squeaky","Quad Boxes","grenade","weapon_flashbang",480.969,2080.031,1702.088,-10.906,119.347,"stwmbf_467",["throwType"]="NORMAL"},{"Truck","Safe","grenade","weapon_molotov",-905.036,1031.002,1693.963,-23.497,43.064,"stwmbf_408",["throwType"]="NORMAL",["flyDuration"]=2.03},{"Sandbags","Boost","grenade","weapon_molotov",11.759,-148.995,1613.094,-32.655,38.675,"stwmbf_108",["throwType"]="NORMAL",["flyDuration"]=2.06},{"Long","Sandbags","grenade","weapon_molotov",1350.703,975.997,1618.094,2.59,-140.584,"stwmbf_429",["throwType"]="RUNJUMP",["flyDuration"]=2.38,["runDuration"]=9},{"Toxic","Bombsite B","grenade","weapon_molotov",1121.208,-1455.969,1616.885,-26.136,174.923,"stwmbf_90",["throwType"]="NORMAL",["flyDuration"]=2.05},{"Toxic","Generator","grenade","weapon_molotov",827.969,-1463.969,1614.094,-26.087,167.349,"stwmbf_91",["throwType"]="NORMAL",["flyDuration"]=2.06},{"Long A","Vent","grenade","weapon_molotov",1319.996,1412.382,1701.031,-20.964,-116.073,"stwmbf_107",["throwType"]="RUN",["flyDuration"]=2.28},{"Toxic","Generator","grenade","weapon_molotov",907.65,-1228.031,1614.094,-23.876,-179.772,"stwmbf_407",["throwType"]="NORMAL",["flyDuration"]=2.06},{"Toxic","Spray boxes","grenade","weapon_molotov",609.002,-1463.969,1614.031,-32.968,140.434,"stwmbf_109",["throwType"]="NORMAL",["flyDuration"]=2.06},{"Vent entrance","Sandbags","grenade","weapon_molotov",605.021,-75.337,1687.386,-24.338,-171.55,"stwmbf_452",["throwType"]="NORMAL",["throwStrength"]=0.5,["flyDuration"]=1.99},{"Vent entrance","Spools","grenade","weapon_molotov",605.005,-149.969,1689.036,-6.584,133.538,"stwmbf_453",["throwType"]="NORMAL",["flyDuration"]=1.37},{"Corner","Vent","grenade","weapon_smokegrenade",-996.969,1440.25,1691.18,-12.773,-47.085,"custom_1",["tickrate"]=64,["throwType"]="JUMP"},{"Wood Panels","Highway","grenade","weapon_smokegrenade",1810.82,865.999,1676.91,-39.669,176.759,"custom_2",["tickrate"]=64,["throwType"]="JUMP"},{"Skull","Quad","grenade","weapon_smokegrenade",1319.91,1412.39,1701.09,-55.381,155.922,"custom_3",["tickrate"]=64,["throwType"]="NORMAL"},{"Boost Boxes","Forklift","grenade","weapon_smokegrenade",1037.04,513.031,1613.55,-44.638,112.031,"custom_4",["tickrate"]=64,["throwType"]="JUMP"},{"Fence","B Bombsite","grenade","weapon_smokegrenade",730.498,-1463.97,1614.09,-30.884,161.23,"custom_5",["tickrate"]=64,["throwType"]="NORMAL"},{"Long A","Default","grenade","weapon_smokegrenade",1230.76,1612.99,1701.97,-61.6,-176.367,"custom_6",["tickrate"]=64,["throwType"]="NORMAL"},{"Vent","Z","grenade","weapon_hegrenade",605.031,-149.969,1689.04,15.556,168.976,"custom_7",["throwType"]="JUMP"},{"Vent room","Vent","grenade","weapon_molotov",-411.969,-418.969,1614.09,-18.96,8.874,"custom_8",["throwType"]="NORMAL"},{"Vent","Under Vent","grenade","weapon_molotov",568.969,-164.64,1748.09,4.088,-130.003,"custom_9",["throwType"]="NORMAL"},{"Toxic","Default","grenade","weapon_molotov",960.007,-1463.97,1644.09,-24.868,171.447,"custom_10",["throwType"]="NORMAL"},{"Spray boxes","Heaven","grenade","weapon_smokegrenade",204.969,-1458.97,1659.09,-17.294,128.952,"custom_11",["tickrate"]=64,["throwType"]="NORMAL"},{"Spray boxes","Heaven","grenade","weapon_molotov",204.969,-1458.98,1659.09,-17.918,131.368,"custom_12",["throwType"]="NORMAL"},{"Heaven","Spray boxes","grenade","weapon_molotov",-530.345,-528.969,1731.46,-11.889,-62.316,"custom_13",["throwType"]="NORMAL"},{"T Spawn Car","Z","grenade","weapon_smokegrenade",1776.27,867.486,1618.35,-17.687,-156.009,"custom_14",["tickrate"]=64,["throwType"]="JUMP"},{"Boost","Z","grenade","weapon_smokegrenade",1018.02,593.727,1737,-10.554,-157.868,"custom_15",["tickrate"]=64,["throwType"]="NORMAL",["duck"]=true},{"Spray boxes","CT","grenade","weapon_smokegrenade",204.969,-1458.97,1659.09,-54.587,138.486,"custom_16",["tickrate"]=64,["throwType"]="NORMAL"},{"B Hall","CT","grenade","weapon_smokegrenade",376.41,-819.089,1614.09,-14.623,137.173,"custom_17",["tickrate"]=64,["throwType"]="RUN"},{"B Hall","Heaven","grenade","weapon_smokegrenade",272.78,-748.37,1614.03,-33.28,137.4,"custom_18",["tickrate"]=64,["throwType"]="NORMAL"},{"Long A","A Balcony","grenade","weapon_smokegrenade",1319.99,1339.23,1701.09,-60.658,-178.654,"custom_19",["tickrate"]=64,["throwType"]="NORMAL"},{"Long A","Highway Side of A","grenade","weapon_smokegrenade",1320,1612.98,1779.31,-49.907,-174.262,"custom_20",["tickrate"]=64,["throwType"]="NORMAL"},{"Garage","Sandbags","grenade","weapon_molotov",833.031,326.987,1614.09,-16.542,-151.03,"custom_21",["throwType"]="NORMAL"},{"Garage","Middle","grenade","weapon_flashbang",1762.03,318.361,1614.03,-11.199,-176.684,"custom_22",["throwType"]="NORMAL"},{"B Hall","B Main","grenade","weapon_flashbang",956.565,-1174,1614.09,-12.684,144.284,"custom_23",["throwType"]="NORMAL"},{"Squeaky","Car","wallbang","weapon_wallbang",1240.97,2011.97,1702.093,0.38,-155.95,"custom_73",["landX"]=-2005.484,["landY"]=-334.487,["landZ"]=-128.89,["flyDuration"]=1.516},{"Front of B","NBK","wallbang","weapon_wallbang",1319.97,1239.42,1690.353,0.81,149.15,"custom_74",["landX"]=-523.841,["landY"]=-1508.03,["landZ"]=-37.969,["flyDuration"]=7.391},{"Middle","Whitebox","wallbang","weapon_wallbang",1118.01,-151.48,1614.09,-1.77,150.66,"custom_75",["landX"]=242.927,["landY"]=-1542.742,["landZ"]=-173.969,["flyDuration"]=4.344},{"Middle","Z","wallbang","weapon_wallbang",833.03,63.97,1614.093,-1.75,-179.5,"custom_77"},{"CT","Hall (Right wall)","wallbang","weapon_wallbang",-667.03,-820.01,1614.093,0,-1.85,"custom_78"},{"CT","Vent","wallbang","weapon_wallbang_light",-1077.97,-380,1614.093,-3.78,4.51,"custom_81"},{"T Spawn","Z","grenade","weapon_smokegrenade",3309.969,367.969,1621.939,-15.117,-174.669,"custom_174",["tickrate"]=64,["throwType"]="RUNJUMP"},{"T Spawn","Whitebox","grenade","weapon_smokegrenade",3309.969,-214.969,1636.031,-24.657,166.85,"custom_175",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=19},{"T Spawn","Quad","grenade","weapon_smokegrenade",2321.125,270.031,1613.029,-33.1,152.525,"custom_176",["tickrate"]=64,["throwType"]="RUNJUMP"},{"Toxic","B Bombsite","grenade","weapon_smokegrenade",1173.969,-1455.969,1617.945,-29.459,167.101,"custom_177",["tickrate"]=64,["throwType"]="NORMAL"},{"T Spawn Car","Default","grenade","weapon_smokegrenade",1823.127,640.969,1613.031,-45.474,153.884,"custom_178",["tickrate"]=64,["throwType"]="JUMP"},{"Middle","Vent Room","grenade","weapon_flashbang",496.496,48.814,1765.178,-39.865,-117.678,"custom_179",["throwType"]="NORMAL"},{"Middle","Z","grenade","weapon_smokegrenade",698.969,-149.988,1646.755,-20.868,174.805,"custom_180",["tickrate"]=64,["throwType"]="NORMAL"},{"Vent room","Heaven","grenade","weapon_smokegrenade",-38.09,-418.969,1614.031,-33.694,-148.169,"custom_181",["tickrate"]=64,["throwType"]="NORMAL"},{"Heaven","B Bombsite","grenade","weapon_flashbang",-461.022,-499.422,1678.525,-30.062,-145.912,"custom_182",["throwType"]="NORMAL"},{"Boost","Whitebox","grenade","weapon_molotov",1018.675,513.001,1736.515,-10.583,-177.069,"custom_197",["throwType"]="NORMAL",["duck"]=true,["landX"]=-295.951,["landY"]=-456.84,["landZ"]=-165.969,["flyDuration"]=8.219},{"Middle","Highway","grenade","weapon_smokegrenade",782.969,-135.921,1620.109,-0.4,143.631,"custom_198",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=20,["landX"]=-661.198,["landY"]=-1579.831,["landZ"]=-165.969,["flyDuration"]=9.609},{"Middle","Highway","grenade","weapon_smokegrenade",513.031,-55.969,1709.604,-32.363,133.154,"custom_199",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-882.139,["landY"]=-2422.489,["landZ"]=-149.811,["flyDuration"]=7.422},{"Highway","Quad","grenade","weapon_molotov",-332.969,466.035,1615.08,-24.74,89.412,"custom_200",["throwType"]="RUN",["landX"]=128.745,["landY"]=-1627.565,["landZ"]=-169.969,["flyDuration"]=9.438},{"Z","Boost","grenade","weapon_molotov",-552.969,-121.969,1663.031,5.236,26.196,"custom_201",["throwType"]="RUNJUMP",["runDuration"]=30},{"Heaven","Vent room","grenade","weapon_smokegrenade",-617.969,-507.806,1709.398,-25.103,-45.921,"custom_216",["throwType"]="NORMAL"},{"Heaven","B Bombsite (Oneway)","grenade","weapon_smokegrenade",-686.879,-287.874,1614.031,-28.007,-60.98,"custom_289",["throwType"]="NORMAL"},{"B Main","B Main","grenade","weapon_smokegrenade",1288.27,-661.685,1614.031,-17.879,-135.31,"custom_313",["throwType"]="NORMAL",["landX"]=-108.026,["landY"]=-81.103,["landZ"]=11778.031,["flyDuration"]=3.922},{"Main","Car","grenade","weapon_molotov",599.144,1658.47,1702.031,-18.05,-158.963,"custom_351",["throwType"]="RUN",["flyDuration"]=1.945,["landX"]=-881.236,["landY"]=1088.059,["landZ"]=1745.294},{"Car","Forklift","grenade","weapon_molotov",-1003.763,1037.318,1687.542,-10.416,15.234,"custom_352",["throwType"]="RUN",["flyDuration"]=1.68,["landX"]=253.339,["landY"]=1415.931,["landZ"]=1727.031},{"Toxic","B Bombsite Default","grenade","weapon_molotov",907.602,-1228.087,1614.031,-26.309,-161.285,"custom_353",["throwType"]="RUN",["runDuration"]=5,["flyDuration"]=2.055,["landX"]=-256.421,["landY"]=-1309.855,["landZ"]=1659.031},{"Highway","Squeaky","grenade","weapon_molotov",-332.969,466.031,1615.08,-27.472,72.672,"custom_354",["throwType"]="RUN",["runDuration"]=8,["flyDuration"]=2.055,["landX"]=189.271,["landY"]=2038.488,["landZ"]=1687.031},{"Main Entrance","Vent","grenade","weapon_molotov",1268.756,1053.589,1635.781,-27.245,-121.477,"custom_355",["throwType"]="RUN",["runDuration"]=1,["flyDuration"]=2.055,["landX"]=532.432,["landY"]=-149.074,["landZ"]=1743.031},{"Boost","Sandbags","grenade","weapon_molotov",897.066,722.394,1857.6,-4.455,-136.745,"custom_356",["throwType"]="RUN",["flyDuration"]=2.055,["landX"]=41.803,["landY"]=-99.413,["landZ"]=1613},{"Heaven","Spray Boxes","grenade","weapon_molotov",-832.225,-42.589,1614.031,-20.291,-59.581,"custom_357",["throwType"]="RUN",["flyDuration"]=2.055,["landX"]=37.385,["landY"]=-1422.289,["landZ"]=1659.031},{"Heaven","Default","grenade","weapon_molotov",-593.568,-614.699,1784.137,-6.953,-28.278,"custom_358",["throwType"]="RUN",["flyDuration"]=2.016,["landX"]=-164.654,["landY"]=-1258.689,["landZ"]=1661.031},{"Heaven","Vent room","grenade","weapon_molotov",-617.969,-764.969,1796.031,-3.434,14.633,"custom_359",["throwType"]="RUN",["flyDuration"]=2.039,["landX"]=-102.717,["landY"]=-430.699,["landZ"]=1614.031},{"Heaven","Main (Oneway)","grenade","weapon_smokegrenade",-589.636,-710.964,1796.031,14.417,2.542,"custom_360",["throwType"]="RUN",["flyDuration"]=2.734,["landX"]=338.718,["landY"]=-654.816,["landZ"]=1616.012},{"Bombsite","Toxic","grenade","weapon_molotov",-238.977,-1458.969,1720.666,-15.098,12.559,"custom_361",["throwType"]="NORMAL",["flyDuration"]=2.047,["landX"]=1040.136,["landY"]=-1245.899,["landZ"]=1612.795},{"Main","Heaven","grenade","weapon_molotov",324.497,-756.348,1614.031,-35.35,140.979,"custom_362",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=1.461,["landX"]=-337.073,["landY"]=-681.556,["landZ"]=1798.031},{"Main","NBK","grenade","weapon_molotov",727.766,1463.672,1702.031,-8.003,144.469,"custom_363",["throwType"]="RUN",["flyDuration"]=1.75,["landX"]=32.344,["landY"]=2256.637,["landZ"]=1689.017},{"Main","Quad","grenade","weapon_molotov",727.766,1463.672,1702.031,-10.614,141.007,"custom_364",["throwType"]="RUN",["flyDuration"]=2.016,["landX"]=-408.685,["landY"]=2145.016,["landZ"]=1689.029},{"Main","Electric","grenade","weapon_molotov",496.903,1762.269,1702.03,-19.781,-139.813,"custom_365",["throwType"]="NORMAL",["flyDuration"]=2.047,["landX"]=-206.348,["landY"]=924.609,["landZ"]=1683.048},{"Forklift","Barrels","grenade","weapon_molotov",379.844,1452.796,1687.031,-19.667,-158.176,"custom_366",["throwType"]="NORMAL",["duck"]=true,["flyDuration"]=1.125,["landX"]=-32.816,["landY"]=1287.546,["landZ"]=1689.031},{"Car","Default","grenade","weapon_molotov",-855.936,1024.589,1762.427,-13.14,46.785,"custom_367",["throwType"]="NORMAL",["flyDuration"]=1.625,["landX"]=-149.375,["landY"]=1776.581,["landZ"]=1816.031},{"Highway","Default","grenade","weapon_molotov",-290.053,641.5,1642.555,-9.819,81.976,"custom_368",["throwType"]="RUN",["flyDuration"]=1.586,["landX"]=-196.354,["landY"]=1800.256,["landZ"]=1689.031},{"Car","Boost","grenade","weapon_molotov",-776.557,1113.518,1687.704,-15.544,31.715,"custom_369",["throwType"]="RUN",["runDuration"]=6,["flyDuration"]=1.844,["landX"]=429.253,["landY"]=1912.739,["landZ"]=1744.809},{"Barrels","Main","grenade","weapon_flashbang",-212.122,1257.455,1687.031,-9.451,46.536,"custom_370",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=1.641,["landX"]=584.038,["landY"]=1602.467,["landZ"]=1721.068},{"Middle","Z","grenade","weapon_flashbang",-894.138,24.618,1614.031,-14.928,45.628,"custom_371",["throwType"]="RUN",["flyDuration"]=1.656,["landX"]=-372.904,["landY"]=-3.746,["landZ"]=1684.04},{"Heaven","Main","grenade","weapon_flashbang",-332.073,-729.983,1796.031,5.449,42.562,"custom_372",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=1.648,["landX"]=319.541,["landY"]=-781.693,["landZ"]=1644.476},{"Main","Vent Room Box","grenade","weapon_molotov",668.21,-1016.195,1614.031,-5.733,142.375,"custom_373",["throwType"]="RUN",["flyDuration"]=1.492,["landX"]=-411.207,["landY"]=-286.647,["landZ"]=1616.031},{"B Short","White Box","grenade","weapon_smokegrenade",1330.999,-418.969,1614.031,-69.494,144.972,"custom_374",["throwType"]="RUN",["runDuration"]=2,["flyDuration"]=5.18,["landX"]=-30.015,["landY"]=437.223,["landZ"]=1713.01},{"Middle","Z","wallbang","weapon_wallbang",1711.998,62.188,1614.031,-1.364,-179.615,"custom_375"},{"T Spawn","Whitebox","grenade","weapon_smokegrenade",2643.454,12.69,1613.094,-25.103,171.485,"custom_376",["throwType"]="RUNJUMP",["runDuration"]=27,["landX"]=-43.459,["landY"]=499.493,["landZ"]=1675.0},{"T Spawn","Z","wallbang","weapon_wallbang",3309.97,62.97,1621.031,-0.65,-179.89,"custom_377"}} end
		if map == "de_dust2" then locations_data={{"T Spawn","Xbox","grenade","weapon_smokegrenade",-402.982,-1051.972,105.27,-9.2,87.513,"stwmbf_565",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=5.78},{"Outside long","Xbox","grenade","weapon_smokegrenade",757.076,-347.969,8.031,-13.944,117.892,"stwmbf_570",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=6.8,["accurateMove"]=false},{"Xbox","CT Spawn","grenade","weapon_smokegrenade",-275.031,1345.379,-122.658,-35.695,131.279,"stwmbf_586",["tickrate"]=64,["throwType"]="NORMAL",["flyDuration"]=4.98},{"Long","Long Doors","grenade","weapon_smokegrenade",1624.519,1710.172,1.091,-28.464,-136.489,"stwmbf_574",["throwType"]="NORMAL",["flyDuration"]=4.56},{"Car","Long Doors","grenade","weapon_smokegrenade",1638.61,2000.938,1.031,-35.821,-127.203,"stwmbf_596",["throwType"]="NORMAL",["flyDuration"]=5.17},{"Middle doors","Long Doors","grenade","weapon_smokegrenade",-489.997,1647.031,-121.542,-50.341,-40.049,"stwmbf_609",["throwType"]="NORMAL",["flyDuration"]=5.77},{"Long (Car)","Long Doors","grenade","weapon_smokegrenade",1752.05,2046.933,0.307,-33.43,-130.546,"stwmbf_571",["throwType"]="NORMAL",["flyDuration"]=4.98},{"CT Middle","Back plateau","grenade","weapon_smokegrenade",-1037.721,2102.031,-5.986,-50.556,146.461,"stwmbf_611",["throwType"]="NORMAL",["duck"]=true,["flyDuration"]=6.59,["accurateMove"]=false},{"CT Middle","Upper Tunnel","grenade","weapon_smokegrenade",-985.453,2553.224,1.267,-26.764,-143.848,"stwmbf_572",["throwType"]="NORMAL",["flyDuration"]=3.75},{"CT Spawn","Lower tunnels / Xbox","grenade","weapon_smokegrenade",-242.031,2278.888,-119.994,-32.687,-123.649,"stwmbf_580",["throwType"]="NORMAL",["flyDuration"]=5.19},{"Window","Car","grenade","weapon_smokegrenade",-1273.969,2575.969,70.397,-69.087,-114.275,"stwmbf_576",["throwType"]="NORMAL",["flyDuration"]=6.2},{"Elevator","Short","grenade","weapon_smokegrenade",1004.969,2379.969,27.468,-10.114,-150.985,"stwmbf_628",["throwType"]="NORMAL",["flyDuration"]=2.34},{"Scaffold","B Tunnel","grenade","weapon_smokegrenade",-1122.031,2691.802,88.1,-22.952,-135.229,"stwmbf_616",["throwType"]="NORMAL",["flyDuration"]=4.36},{"Catwalk","CT Spawn","grenade","weapon_smokegrenade",-149.031,1176.798,-0.532,-15.049,129.475,"stwmbf_581",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=5.0},{"Top middle","Xbox","grenade","weapon_smokegrenade",53.136,308.031,0.446,-38.38,129.093,"stwmbf_584",["throwType"]="RUN",["flyDuration"]=5.0},{"Outside long","Xbox","grenade","weapon_smokegrenade",229.131,112.498,5.103,-40.624,108.758,"stwmbf_583",["throwType"]="NORMAL",["flyDuration"]=5.58},{"Outside long","Long","grenade","weapon_smokegrenade",222.664,-87.978,9.031,-46.267,48.164,"stwmbf_592",["throwType"]="NORMAL",["flyDuration"]=5.78},{"Blue","CT Spawn","grenade","weapon_smokegrenade",516.031,984.268,1.497,-56.051,88.86,"stwmbf_614",["throwType"]="NORMAL",["flyDuration"]=9.44},{"Stairs","CT Spawn","grenade","weapon_smokegrenade",427.361,1749.969,4.221,-78.095,57.979,"stwmbf_624",["throwType"]="NORMAL",["flyDuration"]=6.58},{"Long","Cross","grenade","weapon_smokegrenade",982.189,906.575,0.243,-23.364,43.653,"stwmbf_566",["throwType"]="RUN",["flyDuration"]=4.56,["runDuration"]=40},{"Short","CT Spawn","grenade","weapon_smokegrenade",189.972,1334.016,1.084,-15.576,66.111,"stwmbf_595",["throwType"]="NORMAL",["flyDuration"]=4.37},{"Lower tunnel","CT Middle","grenade","weapon_smokegrenade",-538.607,1382.031,-112.02,-35.388,53.56,"stwmbf_582",["throwType"]="NORMAL",["flyDuration"]=5.17},{"Upper tunnel","B Entrance","grenade","weapon_smokegrenade",-1846.608,1232.606,32.424,-8.745,119.399,"stwmbf_567",["throwType"]="NORMAL",["flyDuration"]=3.56},{"Upper Tunnel","B Entrance","grenade","weapon_smokegrenade",-1747.697,1064.031,33.987,-10.775,118.857,"stwmbf_617",["throwType"]="NORMAL",["flyDuration"]=3.95},{"Middle","CT Spawn","grenade","weapon_smokegrenade",-513.365,1101.969,-68.195,-16.187,77.9,"stwmbf_577",["throwType"]="NORMAL",["flyDuration"]=3.56,["accurateMove"]=false},{"Short","CT Jump","grenade","weapon_smokegrenade",489.959,1446.002,0.553,-5.743,88.281,"stwmbf_597",["throwType"]="NORMAL",["flyDuration"]=1.72},{"Suicide","Middle doors","grenade","weapon_smokegrenade",-491.969,-593.969,2.193,-10.18,87.384,"stwmbf_610",["throwType"]="RUN",["flyDuration"]=4.17},{"B Tunnel","Window","grenade","weapon_smokegrenade",-1942.031,1794.529,33.031,-16.021,56.013,"stwmbf_625",["throwType"]="NORMAL",["flyDuration"]=1.91},{"CT Middle","Bombsite B","grenade","weapon_flashbang",-871.969,2083.089,-79.643,-32.192,164.727,"stwmbf_578",["throwType"]="NORMAL",["throwStrength"]=0.5},{"CT Spawn","Middle doors","grenade","weapon_flashbang",-57.969,2010.031,-121.511,-5.016,8.773,"stwmbf_627",["throwType"]="RUN",["runDuration"]=10},{"Goose","Short","grenade","weapon_flashbang",1051.031,2928.748,128.596,-79.63,-113.183,"stwmbf_623",["throwType"]="NORMAL",["throwStrength"]=0.5},{"Window","Bombsite B","grenade","weapon_flashbang",-1273.999,2575.969,70.397,-41.581,1.054,"stwmbf_591",["throwType"]="NORMAL"},{"CT Middle","Middle doors","grenade","weapon_flashbang",-760.031,2066.031,-109.247,-16.203,173.76,"stwmbf_626",["throwType"]="NORMAL"},{"Bombsite A","Stairs","grenade","weapon_flashbang",545.657,2068.031,127.031,-82.27,-0.617,"stwmbf_622",["throwType"]="NORMAL"},{"CT Ramp","Long","grenade","weapon_flashbang",914.142,2042.013,-17.081,-24.371,-178.854,"stwmbf_629",["throwType"]="NORMAL"},{"Middle","Short","grenade","weapon_flashbang",-521.969,1101.969,-67.176,-29.552,28.752,"stwmbf_587",["throwType"]="NORMAL"},{"Lower Tunnel","Middle dors","grenade","weapon_flashbang",-522.329,1382.031,-110.969,-54.121,51.653,"stwmbf_618",["throwType"]="NORMAL",["throwStrength"]=0.5},{"Xbox","Middle doors","grenade","weapon_flashbang",-275.031,1345.364,-122.79,-38.347,62.329,"stwmbf_579",["throwType"]="NORMAL"},{"Long Doors","Long","grenade","weapon_flashbang",740.969,565.969,1.312,-62.652,53.352,"stwmbf_613",["throwType"]="NORMAL"},{"Outside long","Long","grenade","weapon_flashbang",572.031,-395.969,8.031,-33.133,61.397,"stwmbf_593",["throwType"]="NORMAL"},{"Long","Car","grenade","weapon_molotov",847.153,790.031,47.031,4.8,52.713,"stwmbf_594",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=2.06},{"CT Middle","Backsite","grenade","weapon_molotov",-760.031,2066.031,-109.247,-24.124,132.784,"stwmbf_589",["throwType"]="NORMAL",["flyDuration"]=2.06},{"CT Middle","Big Box","grenade","weapon_molotov",-760.031,2066.031,-109.247,-21.042,166.945,"stwmbf_590",["throwType"]="RUN",["flyDuration"]=2.3,["runDuration"]=14},{"CT Middle","Back plateau","grenade","weapon_molotov",-936.489,2521.747,-24.969,-19.867,160.242,"stwmbf_621",["throwType"]="NORMAL",["flyDuration"]=2.0,["accurateMove"]=false},{"CT Middle","Default","grenade","weapon_molotov",-1232.471,2575.986,69.731,-24.157,-101.009,"stwmbf_619",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=2.39},{"CT Middle","Car","grenade","weapon_molotov",-984.909,2553.219,1.053,-22.045,-129.863,"stwmbf_588",["throwType"]="NORMAL",["flyDuration"]=2.06},{"CT Spawn","Default","grenade","weapon_molotov",531.592,2275.969,-108.627,-25.163,17.762,"stwmbf_615",["throwType"]="NORMAL",["flyDuration"]=1.62},{"CT Middle","Default","grenade","weapon_molotov",-1037.969,2102.031,-5.881,-22.556,115.296,"stwmbf_620",["throwType"]="NORMAL",["flyDuration"]=2.05},{"Short","Default","grenade","weapon_molotov",343.662,1790.942,96.031,-15.082,57.592,"stwmbf_612",["throwType"]="RUN",["flyDuration"]=2.39},{"Xbox","Middle doors","grenade","weapon_molotov",-275.031,1345.37,-122.731,-32.885,134.84,"stwmbf_569",["throwType"]="NORMAL",["flyDuration"]=2.06},{"T Spawn","Xbox","grenade","weapon_smokegrenade",-300,-1163.97,77.71,-16.42,90.01,"custom_128",["throwType"]="JUMP"},{"Long","Short","grenade","weapon_molotov",579.615,788.429,2.527,-55.176,96.794,"custom_213",["throwType"]="RUNJUMP",["runDuration"]=28},{"T Spawn","CT Spawn","grenade","weapon_smokegrenade",707.969,-395.969,8.031,-12.398,123.753,"custom_453",["throwType"]="RUNJUMP",["runDuration"]=78,["landX"]=-193.291,["landY"]=2170.016,["landZ"]=-124.23},{"Cat","B Door","grenade","weapon_smokegrenade",-149.031,1099.918,0.081,-14.334,112.607,"custom_454",["throwType"]="RUNJUMP",["runDuration"]=34,["landX"]=-1241.288,["landY"]=2220.566,["landZ"]=5.197},{"Long","Cross","grenade","weapon_smokegrenade",860.031,790.031,4.314,3.378,43.955,"custom_472",["throwType"]="RUNJUMP",["landX"]=1203.869,["landY"]=2164.944,["landZ"]=3.233},{"Long","Car","grenade","weapon_smokegrenade",795.969,808.031,0.031,-30.501,46.673,"custom_473",["throwType"]="NORMAL",["landX"]=1632.735,["landY"]=1959.029,["landZ"]=2.031},{"Car","Car (Oneway)","grenade","weapon_smokegrenade",1752.05,2046.933,0.307,-2.718,-95.848,"custom_474",["throwType"]="NORMAL",["duck"]=true,["landX"]=1706.473,["landY"]=1983.666,["landZ"]=56.253},{"Car","Long Door","grenade","weapon_molotov",1722.99,1951.285,47.515,4.663,-131.781,"custom_475",["throwType"]="RUNJUMP",["runDuration"]=7,["landX"]=606.731,["landY"]=702.406,["landZ"]=0.234},{"Lower","CT","grenade","weapon_smokegrenade",-1199.969,1343.031,-106.131,-8.349,8.99,"custom_482",["throwType"]="NORMAL",["landX"]=-464.097,["landY"]=1702.25,["landZ"]=-123.176},{"Short","A Site","grenade","weapon_smokegrenade",189.972,1334.016,1.084,-72.358,60.707,"custom_483",["throwType"]="RUN",["runDuration"]=9,["landX"]=1107.03,["landY"]=2605.58,["landZ"]=98.341},{"Long Doors","Outside Long","wallbang_hvh","weapon_wallbang",572.321,351.585,8.467,3.356,-152.982,"custom_624"},{"Long Doors","Long","wallbang_hvh","weapon_wallbang",690.508,565.975,0.966,1.869,89.71,"custom_625"},{"Pit","Long Doors / Under A / Ramp","wallbang_hvh","weapon_wallbang",1292.031,599.486,-55.702,-1.147,153.338,"custom_626",["duck"]=true},{"Long","Long Doors","wallbang_hvh","weapon_wallbang",1270.101,1265.957,0.031,1.018,-138.979,"custom_627"},{"Long","Under A","wallbang_hvh","weapon_wallbang",1351.661,1823.862,-6.932,-0.525,124.451,"custom_628"},{"A Site","CT Spawn","wallbang_hvh","weapon_wallbang",1300.03,2387.874,83.697,10.651,-170.319,"custom_629"},{"Under A","A Site","wallbang_hvh","weapon_wallbang",1238.368,2274.983,12.784,-9.501,118.313,"custom_630"},{"Under A","A Site","wallbang_hvh","weapon_wallbang",1149.465,2280.096,9.846,-14.03,60.15,"custom_631"},{"A Ramp","Long","wallbang_hvh","weapon_wallbang",1302.799,2934.382,129.031,4.04,-91.419,"custom_632",["duck"]=true},{"A Site","Short","wallbang_hvh","weapon_wallbang",1103.65,2562.295,96.14,1.423,-139.22,"custom_633",["duck"]=true},{"Extended A","Long","wallbang_hvh","weapon_wallbang",613.662,2560.18,95.734,6.621,-40.557,"custom_634",["duck"]=true},{"A Ramp","Short","wallbang_hvh","weapon_wallbang",1349.192,2889.892,122.544,1.628,-134.801,"custom_635",["duck"]=true},{"A Site","A Ramp","wallbang_hvh","weapon_wallbang",987.997,2508.955,96.312,7.665,-9.09,"custom_636",["duck"]=true},{"A Site","A Ramp","wallbang_hvh","weapon_wallbang",987.997,2526.301,96.12,5.037,5.272,"custom_637",["duck"]=true},{"Extended A","Short","wallbang_hvh","weapon_wallbang",499.994,2122.564,96.117,8.874,-112.267,"custom_638",["duck"]=true},{"CT Spawn","Short","wallbang_hvh","weapon_wallbang",396.332,2234.961,-129.675,-30.104,-89.965,"custom_639"},{"Middle Doors","A Ramp / Long","wallbang_hvh","weapon_wallbang",-340.031,1985.104,-126.256,-3.869,9.216,"custom_640",["duck"]=true},{"Middle Doors","Long","wallbang_hvh","weapon_wallbang",-287.954,2249.442,-122.295,-2.772,-8.313,"custom_641",["duck"]=true},{"CT Spawn","B Site (Doors)","wallbang_hvh","weapon_wallbang",-34.298,2236.143,-128.91,-4.972,-175.863,"custom_642"},{"CT Spawn","B Site (Doors)","wallbang_hvh","weapon_wallbang",78.445,2233.026,-128.748,-4.491,-176.749,"custom_643"},{"CT Spawn","Long","wallbang_hvh","weapon_wallbang",470.244,2311.754,-118.969,-5.464,-20.844,"custom_644"},{"CT Spawn","Middle Doors","wallbang_hvh","weapon_wallbang",316.195,2421.05,-121.003,0.807,-144.936,"custom_645"},{"CT Spawn","Middle Doors","wallbang_hvh","weapon_wallbang",79.033,2370.319,-66.565,4.456,-135.977,"custom_646",["duck"]=true},{"CT Spawn","Middle Doors","wallbang_hvh","weapon_wallbang",148.943,2483.26,-119.972,1.546,-135.121,"custom_647"},{"Middle Doors","Middle / T Spawn","wallbang_hvh","weapon_wallbang",-319.457,2002.202,-126.872,-4.761,-93.08,"custom_648"},{"Middle","Top Mid","wallbang_hvh","weapon_wallbang",-275.008,958.219,-35.533,-2.473,-70.746,"custom_649",["duck"]=true},{"Middle","B Ramp","wallbang_hvh","weapon_wallbang",-277.701,1356.969,-68.969,2.238,113.378,"custom_650",["duck"]=true},{"Short Stairs","Lower Tunnels","wallbang_hvh","weapon_wallbang",273.031,1538.844,2.758,6.04,-172.485,"custom_651"},{"Catwalk","Short","wallbang_hvh","weapon_wallbang",-191.284,990.91,1.515,1.1,72.898,"custom_652"},{"Top Mid","Lower Tunnels / Middle","wallbang_hvh","weapon_wallbang",-190.535,436.153,-1.336,4.884,102.857,"custom_653",["duck"]=true},{"Outside Long","Top Mid","wallbang_hvh","weapon_wallbang",440.676,401.809,3.508,1.259,166.545,"custom_654"},{"CT Spawn","B Site (Doors)","wallbang_hvh","weapon_knife",13.904,2300.34,-27.969,-1.628,-172.825,"custom_655",["duck"]=true},{"CT Spawn","B Site (Doors)","wallbang_hvh","weapon_wallbang",45.678,2229.093,-27.969,-1.775,-175.851,"custom_656",["duck"]=true},{"CT Spawn","B Site (Doors)","wallbang_hvh","weapon_wallbang",-115.0,2230.813,-53.969,-2.532,-175.247,"custom_657"},{"Middle Doors","Top Mid","wallbang_hvh","weapon_wallbang",-728.487,2544.672,-79.981,-1.957,-73.504,"custom_658"},{"B Site (Doors)","CT Spawn / Under A","wallbang_hvh","weapon_wallbang",-1195.012,2070.031,13.117,5.857,6.271,"custom_659",["duck"]=true},{"B Site (Car)","B Site (Doors)","wallbang_hvh","weapon_wallbang",-1640.071,1665.027,2.466,0.689,59.109,"custom_660",["duck"]=true},{"B Site (Back Box)","Upper Tunnels","wallbang_hvh","weapon_wallbang",-2070.752,2905.031,33.556,0.976,-84.628,"custom_661"},{"B Site (Barrels)","Upper Tunnels","wallbang_hvh","weapon_wallbang",-1833.604,2696.692,32.869,0.759,-95.939,"custom_662",["duck"]=true},{"B Site (Window)","CT Spawn","wallbang_hvh","weapon_wallbang",-1366.005,2642.441,130.031,10.351,-20.975,"custom_663"},{"B Site (Tower)","Upper Tunnels","wallbang_hvh","weapon_wallbang",-1671.407,2602.377,6.307,-0.097,-107.66,"custom_664"},{"Middle Doors","Upper Tunnels","wallbang_hvh","weapon_wallbang",-745.972,2396.071,-94.839,-4.327,-155.278,"custom_665"},{"B Site (Doors)","Upper Tunnels","wallbang_hvh","weapon_wallbang",-1273.969,2322.703,11.324,-0.584,-141.826,"custom_666"},{"Tunnel Stairs","Upper Tunnels","wallbang_hvh","weapon_wallbang",-1107.863,1177.741,-55.969,-8.657,-160.991,"custom_667",["duck"]=true},{"Upper Tunnels","Lower Tunnels","wallbang_hvh","weapon_wallbang",-1356.165,1158.538,32.898,14.229,26.757,"custom_668"},{"T Ramp","T Spawn","wallbang_hvh","weapon_wallbang",-1812.031,-380.723,75.699,0.354,-20.866,"custom_669",["duck"]=true},{"T Spawn","Upper Tunnels","wallbang_hvh","weapon_wallbang",-1727.824,-561.502,129.729,4.074,88.582,"custom_670",["duck"]=true},{"T Spawn","Outside Long","wallbang_hvh","weapon_wallbang",-721.779,-663.716,130.287,8.333,13.043,"custom_671"},{"T Spawn","Middle / Mid Doors","wallbang_hvh","weapon_wallbang",-521.368,-794.214,111.108,4.707,85.855,"custom_672",["duck"]=true},{"Outside Long","T Spawn","wallbang_hvh","weapon_wallbang",132.698,257.006,3.375,1.34,-90.262,"custom_673"},{"Outside Long","T Spawn","wallbang_hvh","weapon_wallbang",121.54,-278.587,4.646,-0.467,-109.868,"custom_674"},{"Outside Long","Long Doors","wallbang_hvh","weapon_wallbang",322.966,-647.084,-0.897,0.225,71.869,"custom_675"},{"Short Stairs","Catwalk","wallbang_hvh","weapon_wallbang",427.392,1749.969,4.024,1.487,-128.178,"custom_676",["duck"]=true},{"Tunnel Stairs","Middle Doors","wallbang_hvh","weapon_wallbang",-1048.011,1308.72,-110.463,1.357,23.858,"custom_677"},{"B Site (Window)","CT Spawn","grenade","weapon_molotov",-1422.397,2625.903,121.854,14.552,-23.676,"custom_678",["throwType"]="JUMP",["landX"]=-159.431,["landY"]=2072.773,["landZ"]=-125.505},{"B Site (Window)","Middle Doors","grenade","weapon_molotov",-1419.455,2641.685,125.031,17.35,-33.021,"custom_679",["throwType"]="JUMP",["landX"]=-324.201,["landY"]=1924.206,["landZ"]=-122.955},{"B Site (Window)","Upper Tunnels","grenade","weapon_molotov",-1223.662,2684.403,114.031,10.381,-130.114,"custom_680",["throwType"]="JUMP",["landX"]=-2013.534,["landY"]=1670.275,["landZ"]=31.676},{"B Site (Window)","B Site (Back Box)","grenade","weapon_molotov",-1122.031,2606.768,62.437,-10.687,161.299,"custom_681",["throwType"]="NORMAL",["landX"]=-2034.288,["landY"]=2967.165,["landZ"]=34.444},{"B Site (Window)","B Site (Box)","grenade","weapon_molotov",-1122.031,2691.802,88.1,9.852,-164.847,"custom_682",["throwType"]="JUMP",["landX"]=-2044.517,["landY"]=2369.35,["landZ"]=4.486},{"B Site (Window)","B Site (Car)","grenade","weapon_molotov",-1220.891,2686.9,114.031,13.178,-109.978,"custom_683",["throwType"]="JUMP",["landX"]=-1649.201,["landY"]=1693.399,["landZ"]=4.403},{"Middle Doors","B Site (Window)","grenade","weapon_molotov",-340.031,1884.721,-120.296,-24.574,139.891,"custom_684",["throwType"]="RUN",["landX"]=-1330.273,["landY"]=2689.206,["landZ"]=129.855},{"Catwalk","CT Spawn","grenade","weapon_molotov",-149.099,1239.578,0.117,-13.01,133.375,"custom_685",["throwType"]="RUN",["landX"]=-186.875,["landY"]=2132.764,["landZ"]=-124.737},{"Catwalk","Short Stairs (Box)","grenade","weapon_molotov",68.149,1348.031,0.094,-19.347,44.925,"custom_686",["throwType"]="RUN",["landX"]=335.71,["landY"]=2051.131,["landZ"]=97.91},{"Short Stairs","A Site (Box)","grenade","weapon_molotov",273.031,1710.115,62.877,-14.595,55.38,"custom_687",["throwType"]="RUN",["runDuration"]=30,["landX"]=1184.516,["landY"]=2524.475,["landZ"]=95.299},{"Short Stairs","A Site (Seed Barrels)","grenade","weapon_molotov",298.219,1739.151,80.745,-17.287,57.195,"custom_688",["throwType"]="RUN",["runDuration"]=31,["landX"]=1257.24,["landY"]=2928.87,["landZ"]=127.874},{"Catwalk","Top Mid (Barrels)","grenade","weapon_molotov",99.127,1515.969,1.163,-21.141,-132.98,"custom_689",["throwType"]="RUN",["runDuration"]=25,["landX"]=-191.224,["landY"]=519.449,["landZ"]=-0.859},{"Catwalk","Top Mid (FD)","grenade","weapon_molotov",429.548,1618.581,2.825,-10.675,-151.711,"custom_690",["throwType"]="RUN",["runDuration"]=25,["landX"]=-295.731,["landY"]=924.615,["landZ"]=-31.969},{"Long Doors","Pit","grenade","weapon_molotov",658.809,813.527,0.444,-4.961,-8.84,"custom_691",["throwType"]="RUN",["runDuration"]=7,["landX"]=1310.917,["landY"]=618.817,["landZ"]=-55.384},{"Long Doors","Long","grenade","weapon_molotov",539.031,511.902,4.328,-6.803,65.496,"custom_692",["throwType"]="RUN",["runDuration"]=8,["landX"]=198.572,["landY"]=468.181,["landZ"]=3.063},{"Top Mid","Outside Long (Barrel)","grenade","weapon_molotov",-413.088,904.362,-31.83,-13.192,-52.565,"custom_693",["throwType"]="RUN",["runDuration"]=15,["landX"]=263.426,["landY"]=405.782,["landZ"]=1.77},{"Outside Long","T Spawn","grenade","weapon_molotov",182.432,-311.251,1.529,-26.866,-125.376,"custom_694",["throwType"]="RUN",["runDuration"]=15,["landX"]=-561.449,["landY"]=-729.346,["landZ"]=119.526},{"B Site (Car)","B Site (Tunnel Tower)","grenade","weapon_molotov",-1707.969,1660.86,2.579,-40.518,12.395,"custom_695",["throwType"]="RUN",["runDuration"]=5,["landX"]=-1799.586,["landY"]=1840.098,["landZ"]=133.683},{"Under A","Short","grenade","weapon_molotov",769.592,2379.969,-34.468,9.382,-132.813,"custom_794",["throwType"]="JUMP",["landX"]=374.136,["landY"]=1674.756,["landZ"]=28.101},{"Under A","Short","grenade","weapon_smokegrenade",769.614,2379.969,-34.649,-67.937,-115.652,"custom_795",["throwType"]="NORMAL",["landX"]=374.198,["landY"]=1674.82,["landZ"]=28.101},{"CT Spawn","CT Box","movement","weapon_knife",218.361,2104.647,-126.128,5.06,169.16,"custom_872",["data"]={12, {0.0, 0.0, "F"}, 8, {0.264, -0.132004}, {0.352, -0.264008}, {0.352, -0.571991}, 8, {0.396, -0.220001}, {0.176, -0.17601}, {0.044, 0.044006}, 2, {0.044}, {0.264, -0.395996}, {0.528, -0.968002}, {0.264, -0.572006}, {0.264, -0.572006}, {0.22, -0.484009}, {0.0, -0.264008}, 6, {0.044}, 4, {-0.308, -0.088013}, {-0.484, -0.264008}, {-0.792, -0.220001}, {-0.748, -0.264008}, {-1.012, -0.307999}, {-1.1, -0.263992}, {-1.056}, {-0.924, 0.044006}, {-0.836, -0.088013}, {-0.484, -0.088013}, {-0.616, 0.044006}, {-0.484, 0.308014}, {-0.22, 0.175995}, {-0.352, 0.264008}, {-0.132, 0.660004}, {-0.044, 0.835999}, {0.308, 1.584}, {0.66, 1.848007}, {0.924, 1.451996, "JR"}, {2.332, 2.024002, "", "J"}, {3.036, 1.496002}, {3.036, 0.70401}, {3.124, -0.132004, "", "F"}, {1.628, -0.484009}, {2.068, -1.187988}, {1.54, -1.40799}, {0.836, -1.056}, {1.276, -2.28801}, {0.484, -1.188004}, {0.836, -2.112}, {0.66, -1.847992}, {0.484, -2.112}, {0.22, -1.40799}, {0.22, -1.935989}, {0.088, -1.891998}, {0.088, -1.891998}, {0.0, -1.848007}, {0.0, -1.100006}, {-0.088, -1.451981}, {-0.264, -1.451981}, {-0.44, -1.40799}, {-0.44, -1.011993}, {-0.352, -0.572006}, {-0.484, -0.615997}, {-0.396, -0.17601}, {-0.308, 0.088013, "L", "", 0.0, 0.0}, {-0.176, 0.220001, "", "", 0.0, 0.0}, {-0.22, 0.968002, "", "", 0.0, 0.0}, {-0.176, 2.551987, "", "R"}, {-0.088, 4.091995}, {-0.088, 6.600006}, {0.0, 8.096008}, {-0.088, 5.983994}, {-0.044, -349.923996, "Z"}, {0.0, 9.063995}, {0.0, 5.632004, "J"}, {0.088, 6.643997, "", "J"}, {0.044, 5.059998}, {0.0, 4.180008}, {0.0, 2.815994}, {0.0, 5.14801}, {-0.176, 5.412003}, {-0.308, 7.171997}, {-0.308, 6.952003, "", "Z"}, {-0.352, 6.599998}, {-0.132, 3.695999}, {-0.088, 4.048004}, {-0.044, 3.168007}, {0.0, 2.639999}, {0.0, 2.507996}, {0.0, 1.452003}, {0.0, 2.112007}, {0.0, 1.848}, {0.0, 2.112007}, {0.0, 1.540001}, {0.0, 0.836006}, {0.0, 1.188011}, {0.0, 1.364006}, {0.0, 1.891998}, {0.0, 1.187996}, {0.0, 1.715996, "R", "", 0.0, 0.0}, {0.044, 1.012001, "", "", 0.0, 0.0}, {0.044, 0.132004, "", "L"}, {0.044, -0.087997, "D"}, {0.088, -0.748001}, {0.0, -1.671997}, {0.0, -0.835999}, {-0.484, -1.496002}, {-0.704, -1.803993, "L", "", 0.0, 225.0}, {-0.264, -1.012001, "", "", 0.0, 0.0}, {-0.308, -0.528, "", "R"}, {-0.308, 0.175995, "F"}, {-0.176, 0.352005}, {-0.088, 0.307999}, {-0.088, 0.264008}, {-0.088, 0.220001, "", "L"}, {-0.176, 0.175995}, {-0.264, 0.307999}, {-0.264, 0.308006}, 3, {-0.088, 0.087997}, 12, {0.0, 0.0, "", "D"}, 4, {0.0, 0.0, "S"}, 8}}} end
		if map == "de_nuke" then locations_data={{"T Spawn","CT Red","grenade","weapon_smokegrenade",-916.119,-1143.969,-415.918,-18.25,-14.67,"stwmbf_426",["tickrate"]=128,["throwType"]="JUMP",["flyDuration"]=7.64},{"CT Spawn","Outside T","grenade","weapon_smokegrenade",1664.031,-280.002,-351.906,-25.048,-135.212,"stwmbf_372",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=8.42},{"T Spawn","Garage","grenade","weapon_smokegrenade",-891.999,-1168.323,-413.906,-17.573,-17.452,"stwmbf_345",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=6.17},{"Ramp","Ramp (Oneway)","grenade","weapon_smokegrenade",504.031,322.031,-353.906,-45.821,-155.002,"stwmbf_387",["duck"]=true,["throwType"]="NORMAL",["throwStrength"]=0,["flyDuration"]=2.56},{"Secret","Secret (Oneway)","grenade","weapon_smokegrenade",1370.327,-2447.993,-452.118,37.306,-88.045,"stwmbf_422",["throwType"]="NORMAL",["throwStrength"]=0,["flyDuration"]=1.55},{"T Roof","Main","grenade","weapon_smokegrenade",191.24,-666.62,-49.969,-44.963,-63.246,"stwmbf_608",["throwType"]="NORMAL",["throwStrength"]=0.5,["flyDuration"]=4.97},{"Outside T","CT Blue","grenade","weapon_smokegrenade",29.047,-2006.689,-416.06,-22.82,22.908,"stwmbf_598",["throwType"]="NORMAL",["flyDuration"]=3.34},{"T Roof","Red box","grenade","weapon_smokegrenade",-533.003,-833.216,-193.635,-30.905,-43.817,"stwmbf_343",["throwType"]="NORMAL",["flyDuration"]=5.59},{"T Roof","Garage","grenade","weapon_smokegrenade",-363.668,-1443.451,-287.906,-31.12,-14.296,"stwmbf_347",["throwType"]="NORMAL",["flyDuration"]=5.21},{"T Roof","Main","grenade","weapon_smokegrenade",-263.969,-280.005,-171.969,-56.844,-53.141,"stwmbf_600",["throwType"]="NORMAL",["flyDuration"]=8.14},{"Silo","Heaven","grenade","weapon_smokegrenade",63.791,-1430.719,-89.968,-23.91,49.211,"stwmbf_602",["throwType"]="NORMAL",["duck"]=true,["flyDuration"]=4.16},{"Silo","Heaven","grenade","weapon_smokegrenade",-0.2,-1390.099,-165.913,-28.628,46.571,"stwmbf_605",["throwType"]="NORMAL",["flyDuration"]=4.38},{"T Roof","Main","grenade","weapon_smokegrenade",4.031,-280.031,-171.969,-26.104,-64.048,"stwmbf_606",["throwType"]="NORMAL",["flyDuration"]=6.15},{"Outside T","Yard","grenade","weapon_smokegrenade",-423.996,-1753.002,-415.915,-2.624,-50.804,"stwmbf_421",["throwType"]="RUN",["flyDuration"]=3.18},{"T Roof","Bombsite A Silos","grenade","weapon_smokegrenade",-66.113,-493.031,-171.969,-30.592,-11.559,"stwmbf_603",["throwType"]="NORMAL",["flyDuration"]=4.77},{"Trophy","Ramp","grenade","weapon_smokegrenade",251.969,-449.969,-415.906,0.263,122.864,"stwmbf_349",["throwType"]="RUN",["flyDuration"]=2.91},{"T Roof","Secret entrance","grenade","weapon_smokegrenade",-438.052,-1060.469,-156.656,-14.751,-37.17,"stwmbf_342",["throwType"]="NORMAL",["flyDuration"]=4.76},{"Silo","Secret entrance","grenade","weapon_smokegrenade",63.064,-1430.764,-89.906,2.54,-31.097,"stwmbf_350",["throwType"]="NORMAL",["flyDuration"]=4.19},{"Outside T","Garage","grenade","weapon_smokegrenade",-164.093,-1954.734,-415.916,-13.614,1.279,"stwmbf_371",["throwType"]="NORMAL",["flyDuration"]=3.38},{"T Roof","Bombsite A","grenade","weapon_flashbang",-31.097,-338.031,-81.987,-20.049,-31.326,"stwmbf_601",["throwType"]="NORMAL"},{"T Roof","Back vent","grenade","weapon_molotov",18.719,-941.691,-21.969,-13.185,-23.96,"stwmbf_607",["throwType"]="RUN",["flyDuration"]=1.98},{"T Roof","Hut roof","grenade","weapon_molotov",27.339,-952.648,-21.969,-7.03,-35.404,"stwmbf_599",["throwType"]="RUN",["runDuration"]=6,["flyDuration"]=2.02},{"T Roof","Default (Bombsite A)","grenade","weapon_molotov",-136.548,-592.183,-105.969,-24.272,0.585,"stwmbf_604",["throwType"]="RUN",["flyDuration"]=2.05},{"Lobby","Behind Vent","wallbang","weapon_wallbang",-20.031,-1165.564,-415.969,-0.344,-18.09,"custom_203"},{"Outside","A Vent","grenade","weapon_smokegrenade",-891.984,-927.007,-415.969,-17.061,-11.162,"custom_455",["throwType"]="JUMP",["duck"]=true,["landX"]=509.205,["landY"]=-1299.476,["landZ"]=-413.969,["destroyX"]=406.563,["destroyY"]=-1192.891,["destroyZ"]=123.979,["destroyStartX"]=316.305,["destroyStartY"]=-1190.577,["destroyStartZ"]=180.164,["destroyText"]="Break the right window"}} end
		if map == "de_cbble" then locations_data={{"Plateau","Terrace","grenade","weapon_smokegrenade",-1566.001,1091.941,91.935,-34.32,-32.841,"stwmbf_662",["tickrate"]=128,["throwType"]="JUMP",["flyDuration"]=9.47},{"Plateau","Bombsite B","grenade","weapon_smokegrenade",-1566.001,1091.941,91.935,-41.646,-44.77,"stwmbf_661",["tickrate"]=128,["throwType"]="JUMP",["flyDuration"]=9.27},{"Plateau","Short","grenade","weapon_smokegrenade",-1566.001,1091.941,91.935,-45.705,-44.688,"stwmbf_660",["tickrate"]=128,["throwType"]="JUMP",["flyDuration"]=7.0},{"Connector","B Long","grenade","weapon_smokegrenade",-1540.976,-1226.969,5.454,-50.673,41.494,"stwmbf_638",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=8.44},{"CT Ramp","Balcony","grenade","weapon_smokegrenade",-2533.996,-272.031,-184.473,-17.079,-65.535,"stwmbf_656",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=4.77},{"Electric","B Long","grenade","weapon_smokegrenade",-399.969,-760.031,-95.667,-15.231,33.306,"stwmbf_657",["throwType"]="NORMAL",["flyDuration"]=2.73},{"B Door","B Long","grenade","weapon_smokegrenade",-823.969,-1055.969,-124.139,-16.716,33.789,"stwmbf_637",["throwType"]="RUN",["runDuration"]=18,["flyDuration"]=2.98},{"Balcony","A Long","grenade","weapon_smokegrenade",-1864.969,-1611.992,96.031,-11.04,136.122,"stwmbf_636",["throwType"]="NORMAL",["flyDuration"]=3.73},{"A Long","Hay","grenade","weapon_smokegrenade",-3471.969,-655.969,32.031,-17.31,44.44,"stwmbf_659",["throwType"]="NORMAL",["flyDuration"]=3.75},{"B Long","B Long (Oneway)","grenade","weapon_smokegrenade",272.031,-291.031,-63.969,-31.929,17.581,"stwmbf_658",["duck"]=true,["flyDuration"]=1.52},{"A Long","Storage","grenade","weapon_smokegrenade",-3334.71,-74.968,-29.969,-37.688,-37.876,"stwmbf_642",["throwType"]="NORMAL",["flyDuration"]=5.39},{"B Long","Bombsite B","grenade","weapon_smokegrenade",-417.183,-99.288,-32.772,-76.083,-60.89,"stwmbf_651",["throwType"]="NORMAL",["flyDuration"]=9.64},{"Halls","B Doors","grenade","weapon_smokegrenade",-558.031,-42.536,0.031,-62.174,-100.721,"stwmbf_639",["throwType"]="NORMAL",["flyDuration"]=7.22},{"B Long","Boost","grenade","weapon_smokegrenade",-355.092,-239.969,-31.969,-79.102,-9.214,"stwmbf_647",["throwType"]="NORMAL",["flyDuration"]=6.41},{"Alley","Balcony","grenade","weapon_smokegrenade",-2991.969,-788.422,16.523,-26.55,-35.085,"stwmbf_635",["throwType"]="NORMAL",["flyDuration"]=5.36},{"Hay","A Door","grenade","weapon_smokegrenade",-3346.549,454.832,0.031,-40.394,-45.595,"stwmbf_640",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=5.13},{"Drop","Dropper","grenade","weapon_smokegrenade",-752.031,-80.014,128.031,5.362,-119.332,"stwmbf_646",["throwType"]="NORMAL",["flyDuration"]=3.36},{"Hay","Grassy","grenade","weapon_smokegrenade",-3165.164,585.622,0.031,-55.095,-62.064,"stwmbf_641",["throwType"]="NORMAL",["flyDuration"]=6.81},{"Hay","Storage","grenade","weapon_smokegrenade",-3314.228,467.292,0.031,-39.42,-50.768,"stwmbf_643",["throwType"]="RUN",["runDuration"]=1,["flyDuration"]=4.98},{"B Long","B Door","grenade","weapon_smokegrenade",-319.18,-80.031,-31.969,-60.557,-117.217,"stwmbf_644",["throwType"]="NORMAL",["flyDuration"]=6.41},{"B Main","Site","grenade","weapon_smokegrenade",-703.969,-80.71,-28.987,-60.061,-54.991,"stwmbf_650",["throwType"]="NORMAL",["flyDuration"]=6.2},{"Rock","B Long","grenade","weapon_flashbang",-437.203,-880.156,-107.741,-19.587,39.378,"stwmbf_655",["throwType"]="NORMAL"},{"Terrace stairs","B Long","grenade","weapon_flashbang",751.969,-512.531,-66.295,-23.646,150.492,"stwmbf_654",["throwType"]="NORMAL",["throwStrength"]=0.5},{"Bombsite B","B Long","grenade","weapon_flashbang",786.495,-922.969,-108.025,-22.887,122.791,"stwmbf_652",["throwType"]="NORMAL"},{"Halls","Dropper","grenade","weapon_flashbang",-589.691,438.241,-0.969,-17.904,-108.495,"stwmbf_648",["throwType"]="NORMAL"},{"Catwalk","Hay","grenade","weapon_flashbang",-2863.969,560.031,0.031,-17.408,-13.553,"stwmbf_630",["throwType"]="JUMP"},{"B Door","B Long","grenade","weapon_molotov",-823.969,-1055.969,-124.139,-16.748,33.862,"stwmbf_634",["throwType"]="RUN",["runDuration"]=18,["flyDuration"]=2.28},{"Alley","Storage","grenade","weapon_molotov",-2989.969,-945.01,32.019,-11.814,-13.047,"stwmbf_633",["throwType"]="NORMAL",["flyDuration"]=1.94},{"B Long","Boost","grenade","weapon_molotov",47.969,-16.031,-23.177,-31.748,-126.045,"stwmbf_645",["throwType"]="NORMAL",["flyDuration"]=2.06},{"Alley","A Door","grenade","weapon_molotov",-2976.751,-945.555,32.031,-11.831,-4.695,"stwmbf_632",["throwType"]="RUN",["flyDuration"]=2.0,["runDuration"]=3},{"Alley","Balcony","grenade","weapon_molotov",-2962.764,-961.88,32.02,-15.708,-32.613,"stwmbf_631",["throwType"]="RUN",["flyDuration"]=1.84,["runDuration"]=4},{"B Long","Terrace","grenade","weapon_molotov",-504.031,-264.547,-32.835,-13.25,11.276,"stwmbf_649",["throwType"]="NORMAL",["duck"]=true,["flyDuration"]=1.64},{"Sidewalk","Straw","grenade","weapon_molotov",-2688.031,719.969,0.031,-40.492,-119.068,"stwmbf_653",["throwType"]="NORMAL",["flyDuration"]=2.05},{"Alley","Balcony","grenade","weapon_molotov",-3375.635,-307.611,0.031,-25.466,-40.299,"custom_218",["throwType"]="RUN",["runDuration"]=48},{"Alley","Balcony","grenade","weapon_smokegrenade",-3375.635,-307.611,0.031,-25.066,-40.299,"custom_219",["throwType"]="RUN",["runDuration"]=40},{"CT Spawn","B Long","grenade","weapon_smokegrenade",-2479.694,-1913.14,20.857,-28.491,37.132,"stwmbf_436",["tickrate"]=64,["throwType"]="RUNJUMP",["viewAnglesDistanceMax"]=0.09,["runDuration"]=25},{"B Site","Fountain","grenade","weapon_molotov",-78.923,-360.095,-31.593,-19.493,-87.646,"custom_404",["throwType"]="RUN",["runDuration"]=11,["landX"]=144.366,["landY"]=-929.635,["landZ"]=-49.427},{"B Platform","Rock","grenade","weapon_molotov",520.316,-149.591,0.031,-8.482,-142.417,"custom_405",["throwType"]="NORMAL",["landX"]=-425.494,["landY"]=-877.578,["landZ"]=-109.509},{"B Bombsite","B Platform","grenade","weapon_molotov",106.467,-1293.212,-112.667,-22.65,79.164,"custom_406",["throwType"]="NORMAL",["landX"]=326.752,["landY"]=-125.21,["landZ"]=-7.768},{"Rock","B Platform","grenade","weapon_molotov",-463.419,-969.302,-121.383,-21.264,42.924,"custom_407",["throwType"]="NORMAL",["landX"]=365.733,["landY"]=-199.338,["landZ"]=-4.519},{"Long","Boost / Corner","grenade","weapon_molotov",-94.201,-239.969,-31.969,-18.841,91.217,"custom_545",["throwType"]="RUNJUMP",["runDuration"]=16,["landX"]=-111.142,["landY"]=-670.634,["landZ"]=62.031},{"T Main","Tree","movement","weapon_knife",26.618,-68.982,-31.969,0.836,-33.396,"custom_870",["data"]={7, {0.0, 0.0, "FR"}, 4, {0.0, 0.043999, "", "R"}, {0.176, 0.396}, {0.616, 0.571999}, 10, {0.132, 0.307999, "L"}, {0.0, 0.175999}, {0.044, 0.395998}, {0.132, 0.528002}, {0.044, 0.219999}, {0.088, 0.088001}, {0.132, 0.483999}, {0.132, 0.351999}, {0.176, 0.351999}, {0.132, 0.351999}, {0.176, 0.351997}, {0.176, 0.307999}, {0.264, 0.219999}, {0.44, 0.351999, "", "L"}, {0.88, 0.528}, {0.748, 0.396}, {0.528, 0.132002}, {0.572, 0.219999}, {0.66, 0.0, "L"}, {1.056, -0.219999}, {0.66, -0.176001}, {0.748, -0.439999}, {0.264, -0.175999}, {0.264, -0.351999, "", "L"}, {0.176, -0.263998}, {0.132, -0.263998}, {0.132, -0.307999}, {0.088, -0.176001}, {0.176, -0.440001}, {0.352, -1.011999}, {0.132, -0.440001}, {0.132, -0.351999}, {0.088, -0.351999}, {0.132, -0.396}, {0.044, -0.308002}, {0.0, -0.308002}, {0.0, -0.131996}, {0.044, -0.131996}, {0.088, -0.307999}, {0.22, -0.924004}, {0.264, -0.924}, {0.264, -0.923996}, {0.088, -1.011997}, {0.044, -0.483997}, {0.0, -0.615997}, {0.0, -0.352001}, {0.0, -0.087997}, 2, {0.088, 0.043999}, {0.352, 0.439999, "J"}, {1.188, 0.967999, "", "J"}, {1.584, 1.144001}, {2.332, 1.055996, "R"}, {2.376, 0.351997, "", "F"}, {2.112, -0.220001}, {2.024, -0.835999}, {2.024, -1.452}, {1.188, -1.496002}, {0.792, -1.628002}, {0.748, -1.804001}, {0.88, -2.243996}, {1.012, -2.595997}, {0.704, -2.023998}, {0.66, -2.023998}, {0.616, -2.243999}, {0.748, -3.343998}, {0.704, -3.343998}, {0.572, -3.167999}, {0.264, -4.091999}, {0.0, -2.507996}, {0.0, -2.332001}, {0.264, -3.431999}, {0.22, -3.695999}, {0.0, -3.036003}, {-0.176, -1.540001}, {-0.088, -2.463997}, {-0.264, -1.496002}, {-0.484, -1.672005, "F"}, {-0.396, -0.879997}, {-0.352, -0.132004, "", "R"}, {-0.176, 0.307999}, {-0.044, 0.484009}, {0.0, 1.099998}, {0.176, 2.332001}, {0.396, 1.584}, {0.396, 1.276009}, {0.528, 1.408005}, {0.528, 1.143997}, {0.704, 1.099998}, {0.44, 0.616005}, {0.528, 0.220001}, {0.704, -0.352005, "R"}, {0.968, -1.804008, "J"}, {1.188, -2.992004, "", "J"}, {1.056, -4.444, "", "F"}, {0.528, -5.500008}, {0.088, -6.644005}, {-0.044, -4.444}, {-0.22, -3.519997}, {-0.176, -4.223999}, {-0.176, -2.683998}, {-0.396, -2.816002}, {-0.264, -2.332001}, {-0.616, -2.771996}, {-1.056, -4.311996}, {-0.792, -2.859985}, {-0.924, -2.464005}, {-1.584, -3.212021}, {-1.54, -2.464005}, {-1.496, -2.772003, "L", "", 0.0, 0.0}, {-1.276, -2.419998, "", "R"}, {-1.804, -2.199997}, {-1.012, -0.968018}, {-0.88, -0.175995}, {-1.54, 2.419983}, {-0.352, 2.947998}, {0.528, 1.671997, "R", "L"}, {1.496, 1.23201}, {1.936, 0.572006}, {2.376, -1.055984}, {1.408, -1.936005}, {0.792, -1.980011}, {0.352, -2.024002}, {-0.044, -1.804001}, {-0.748, -2.200012, "L", "", 0.0, 225.0}, {-0.836, -1.363983, "", "", 0.0, 0.0}, {-0.572, -0.528, "", "R"}, {-1.716, -0.044006, "F", "", 225.0}, {-1.452, 0.132004}, {-1.408, 0.087997, "D"}, {-2.244, 0.880005}, {-2.728, 2.244003, "", "L"}, {-2.596, 2.199997}, {-1.628, 0.70401}, {-1.54, 0.307999}, {-1.452}, {-1.056, -0.044006}, {-0.616, 0.17601}, {-0.264, 0.307999, "Z"}, {0.0, 0.132004}, 1, {0.0, 0.044006}, 4, {0.0, 0.0, "", "Z"}, 4, {0.0, 0.044006}, {-0.088, 0.439987}, {-0.088, 1.100021}, {0.0, 0.307999}, 19, {0.0, 0.132004}, {-0.792, 0.615982}, {-0.572, 0.352005}, {-0.748, 0.395996}, {-0.66, 0.440002}, {-0.528, 0.220016}, {-0.528, 0.044006}, {-0.572, 0.132019}, {-0.396, 0.088013}, {-0.264, 0.044006}}},{"B Platform","Tree","movement","weapon_knife",662.0,21.956,0.031,7.612,-142.012,"custom_871",["data"]={5, {0.0, 0.0, "F"}, 3, {0.0, 0.0, "L"}, 1, {0.0, 0.0, "", "L"}, 1, {0.044, 0.044006}, {0.396, -0.087997}, {0.44, -2.156006, "L"}, {0.0, 0.0, "", "L"}, 4, {0.0, 0.0, "L"}, {0.0, 0.0, "", "L"}, {-0.044, -0.220001}, {-0.308, -0.088013}, {-0.352, 0.220032}, {-0.088, 0.17601}, {-0.176, 0.440002}, {-0.308, 0.836014, "L"}, {0.0, 0.087997, "", "L"}, 6, {0.0, 0.0, "L"}, 1, {0.0, 0.044006, "", "L"}, {0.0, -0.484009}, {0.0, -0.308014}, {0.0, -0.044006}, 7, {0.0, -0.044006}, {0.0, -0.088013, "R"}, {0.308, 0.264008}, {0.616, -0.132004}, 4, {0.308, -0.175995}, {-0.044, 0.044006, "", "R"}, {0.088, -0.440018}, {0.352, -0.440018, "R"}, {0.176, -0.396027}, {0.22, -0.440002}, {0.088, -0.528, "", "R"}, {0.0, -0.044006}, 2, {0.264, -0.572006}, {0.572, -0.836014}, {0.264, -0.440002}, {0.088, -0.088013}, {0.044, -0.044006}, {0.088, -0.176025}, {0.132, -0.17601}, 1, {0.088, -0.132004}, {0.22, -0.132019}, {0.176}, {0.264, -0.132019}, {0.22, -0.264008}, {0.352, -0.088013}, {0.264}, {0.176, -0.044006}, {0.264}, {0.176, -0.044006}, {0.176, -0.044006}, {0.044}, {0.22, -0.088013}, {0.044, -0.220016}, {0.088, -0.088013}, {0.176, -0.132019}, {0.264, -0.176025}, {0.176, -0.132019}, {0.132, -0.176025}, {0.132, -0.132019}, {0.088, -0.132019}, {0.044, -0.132019}, {0.088, -0.176025}, {0.0, -0.264038}, {0.0, -0.176025}, {0.0, -0.220032}, {-0.088, -0.17601}, {-0.176, -0.440002}, {-0.308, -0.308044}, {-0.264, -0.176025}, {-0.308, -0.264038}, {-0.264, -0.132019}, {-0.308, -0.132019}, {-0.704, -0.132019}, {-0.968, -0.132019}, {-1.012, -0.088013}, {-0.968, 0.220032, "J"}, {-0.572, 0.572006, "L", "J"}, {0.0, 0.615982, "", "F"}, {0.748, 0.70401}, {1.188, 0.880005}, {0.616, 0.484009}, {0.396, 0.35202}, {0.44, 0.440002}, {0.308, 0.440018}, {0.352, 0.528015}, {0.484, 0.747986}, {0.528, 0.968002}, {0.528, 1.012009}, {0.44, 1.055984}, {0.528, 1.40799}, {0.484, 1.320007}, {0.484, 1.760025}, {0.572, 1.892014}, {0.396, 1.40802}, {0.308, 1.231995}, {0.352, 1.363983}, {0.176, 1.496002}, {0.088, 1.40802}, {0.088, 2.420029}, {0.0, 2.860008}, {0.0, 2.596016}, {0.0, 3.300011}, {0.0, 3.652}, {-0.088, 3.695999}, {-0.088, 4.399994}, {-0.176, 3.73999}, {-0.22, 4.400002}, {-0.132, 3.73999}, {-0.088, 5.367996}, {-0.044, 3.696007}, {-0.044, 0.792, "R", "", 0.0, 0.0}, {0.0, 0.0, "", "L"}, {0.0, -0.968002, "J"}, {0.0, -3.080002, "", "J"}, {0.044, -4.840012}, {0.044, -4.224014}, {0.088, -4.003998}, {0.0, -5.103996}, {0.0, -4.047997}, {0.0, -3.652}, {0.0, -3.124001}, {0.0, -2.552017}, {0.0, -2.948021}, {0.132, -3.124008}, {0.0, -2.112015}, {0.0, -2.156021}, {0.0, -1.628021}, {0.0, -2.023987}, {-0.176, -2.903992}, {-0.308, -2.024017}, {-0.616, -1.672012, "L", "", 0.0, 0.0}, {-0.616, -0.528015, "", "R"}, {-0.528, 0.572021}, {-0.484, 2.156021}, {-0.132, 2.815994}, {0.0, 2.200012, "R", "", 0.0, 0.0}, {0.0, 0.0, "", "L"}, 1, {0.176, -1.584}, {0.176, -2.684021}, {0.0, -1.848007, "L", "", 0.0, 0.0}, {0.0, -1.451996, "", "", 0.0, 0.0}, {-0.176, -0.87999, "", "R"}, {-0.22, 0.396011, "D"}, {-0.308, 2.463989}, {0.132, 1.58403}, {0.088, 0.220001, "R", "L"}, {0.044}, {0.088, -2.112}, {-0.044, -2.024002}, {-0.484, -1.672012, "L", "", 0.0, 0.0}, {-0.792, -0.703995, "J", "", 0.0, 0.0}, {-1.276, 1.848007, "", "JR"}, {-0.66, 2.552002}, {0.0, 0.308014, "RZ", "L"}, {0.0, 0.044006}, 1, {0.0, 0.0, "L", "", 0.0, 225.0}, {0.264, -0.571991, "", "RZ"}, {0.484, -1.188004}, {0.484, 0.352005}, {1.804, 5.544006}, {0.748, 6.863998}, {0.0, 0.835999}, {0.0, 0.132004, "R", "L"}, {0.0, -0.836029, "", "D"}, {-0.088, -2.727997}, {-0.044, -3.73999}, {-0.132, -2.024002}, {-0.396, -2.463989}, {-0.968, -3.123978, "L", "", 0.0, 225.0}, {-1.276, -1.979996, "", "", 0.0, 0.0}, {-1.012, -0.264008, "", "R"}, {-0.836, 1.760025}, {-0.176, 2.991989}, {0.0, 3.783997, "R", "", 0.0, -225.0}, {0.0, 1.364014, "", "L"}, {-0.088, -0.088013}, {-0.132, -2.508011}, {-0.44, -3.388}, {-0.44, -1.231995, "L", "", 0.0, 0.0}, {-0.44, 0.70401, "", "R"}, {-0.132, 2.595993, "F"}, 1, {0.44, -1.319992}, {0.352, -3.871979}, {0.44, -3.608017, "S"}, {0.176, -0.307999}, 2, {0.0, 0.088013}, {0.0, -0.044006}, {0.264, -0.088013}, {0.176, -0.088013}, {0.088, -0.088013}, {0.176, -0.220032, "", "F"}, {0.396, -1.672028}, {0.088, -0.88002}, {0.0, -0.087997}, 1, {0.132, -0.088013}, {0.132}, 4}}} end
		if map == "de_inferno" then locations_data={{"Banana (Logs)","Spools","grenade","weapon_smokegrenade",-79.449,1330.031,106.771,-11.006,69.319,"stwmbf_474",["tickrate"]=128,["throwType"]="JUMP",["flyDuration"]=3.94},{"C1","B Entrance","grenade","weapon_smokegrenade",569.914,2520.409,291.094,28.874,-28.351,"stwmbf_478",["throwType"]="NORMAL",["flyDuration"]=1.73},{"CT Spawn","T","grenade","weapon_smokegrenade",2129.031,1917.969,128.094,-46.827,-121.514,"stwmbf_503",["throwType"]="NORMAL",["flyDuration"]=5.61},{"Balcony","Balcony (Oneway)","grenade","weapon_smokegrenade",2110.926,-319.989,292.094,-16.188,130.413,"stwmbf_549",["throwType"]="NORMAL",["flyDuration"]=3.35},{"CT Spawn","B Entrance","grenade","weapon_smokegrenade",1089.392,2781.969,128.029,1.138,-145.548,"stwmbf_477",["throwType"]="NORMAL",["flyDuration"]=2.12},{"Dark","B Entrance","grenade","weapon_smokegrenade",151.969,3063.995,160.094,-8.02,-40.489,"stwmbf_476",["throwType"]="NORMAL",["flyDuration"]=2.53},{"Pit","Pit (Oneway)","grenade","weapon_smokegrenade",2479.991,-16.031,98.196,0.099,-132.038,"stwmbf_484",["throwType"]="NORMAL",["throwStrength"]=0,["flyDuration"]=1.52},{"Arch","Balcony","grenade","weapon_smokegrenade",1913.227,1225.969,174.094,-46.497,-87.005,"stwmbf_546",["throwType"]="NORMAL",["flyDuration"]=5.79},{"Well","Fountain","grenade","weapon_smokegrenade",1971.688,2636.702,128.094,-39.996,175.975,"stwmbf_547",["throwType"]="NORMAL",["flyDuration"]=4.37},{"Ruins","Banana","grenade","weapon_smokegrenade",1439.999,2956.279,131.412,-29.981,-133.287,"stwmbf_481",["throwType"]="NORMAL",["flyDuration"]=4.19},{"Bombsite B","Banana (Deep)","grenade","weapon_smokegrenade",875.969,2481.443,145.094,-23.992,-125.139,"stwmbf_550",["throwType"]="NORMAL",["flyDuration"]=4.98},{"CT Spawn","B Entrance","grenade","weapon_smokegrenade",2032.024,2975.976,133.09,-38.132,-154.727,"stwmbf_473",["throwType"]="NORMAL",["flyDuration"]=5.78},{"Pit","Pit (Oneway)","grenade","weapon_smokegrenade",2631.969,-16.031,84.031,-7.8,-178.847,"stwmbf_535",["throwType"]="NORMAL",["duck"]=true,["flyDuration"]=1.53},{"Ruins","Banana","grenade","weapon_smokegrenade",1329.922,2977.219,144.344,-30.756,-129.919,"stwmbf_505",["throwType"]="NORMAL",["flyDuration"]=5.0},{"Pit","Pit (Oneway)","grenade","weapon_smokegrenade",2643.637,-337.031,90.823,-17.045,171.899,"stwmbf_516",["throwType"]="NORMAL",["flyDuration"]=4.15},{"Car","Car (Oneway)","grenade","weapon_smokegrenade",610.969,1873.031,134.252,11.154,165.15,"stwmbf_491",["throwType"]="NORMAL",["throwStrength"]=0.5,["flyDuration"]=1.51},{"C2","B Entrance","grenade","weapon_smokegrenade",386.386,2537.663,160.094,-26.5,-19.824,"stwmbf_479",["throwType"]="NORMAL",["flyDuration"]=3.16},{"Sandbags","CT Boost","grenade","weapon_smokegrenade",610.974,1873.0,134.242,-17.673,69.676,"stwmbf_521",["throwType"]="NORMAL",["flyDuration"]=2.54},{"2nd Middle","Library","grenade","weapon_smokegrenade",726.007,333.918,96.094,-45.969,26.172,"stwmbf_511",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=5.34},{"T","Moto","grenade","weapon_smokegrenade",960.9,434.006,88.094,-49.864,13.16,"stwmbf_497",["throwType"]="NORMAL",["flyDuration"]=6.2},{"2nd Middle","Long","grenade","weapon_smokegrenade",491.937,-267.969,88.094,-42.025,45.855,"stwmbf_470",["throwType"]="NORMAL",["flyDuration"]=4.37},{"Banana","Spools","grenade","weapon_smokegrenade",338.872,1650.803,122.094,-50.094,84.573,"stwmbf_472",["throwType"]="NORMAL",["flyDuration"]=5.58},{"2nd Middle","Long (Deep)","grenade","weapon_smokegrenade",274.681,-224.628,88.094,-41.052,31.799,"stwmbf_485",["throwType"]="RUN",["flyDuration"]=8.71},{"Logs","Spools","grenade","weapon_smokegrenade",110.815,1569.627,132.076,-45.095,76.556,"stwmbf_496",["throwType"]="NORMAL",["flyDuration"]=5.39},{"2nd Middle","Truck","grenade","weapon_smokegrenade",721.031,393.32,92.906,-51.959,-19.791,"stwmbf_502",["throwType"]="NORMAL",["flyDuration"]=3.98},{"2nd Middle","Arch","grenade","weapon_smokegrenade",726.011,186.012,97.527,-46.35,45.801,"stwmbf_495",["throwType"]="NORMAL",["flyDuration"]=6.0},{"2nd Middle","Short / Default","grenade","weapon_smokegrenade",697.512,-242.262,91.094,-53.098,16.443,"stwmbf_527",["throwType"]="NORMAL",["flyDuration"]=5.61},{"2nd Middle","Truck / Pit","grenade","weapon_smokegrenade",726.031,220.963,94.03,-55.242,-8.7,"stwmbf_542",["throwType"]="NORMAL",["flyDuration"]=5.59},{"2nd Middle","Pit","grenade","weapon_smokegrenade",693.867,11.969,88.316,-52.338,-2.135,"stwmbf_543",["throwType"]="NORMAL",["flyDuration"]=6.8},{"Banana (Logs)","CT Spawn","grenade","weapon_smokegrenade",120.0,1587.966,113.308,-34.798,56.15,"stwmbf_469",["throwType"]="NORMAL",["flyDuration"]=4.17},{"Banana","CT Spawn","grenade","weapon_smokegrenade",460.448,1828.489,136.177,-24.519,62.338,"stwmbf_486",["throwType"]="NORMAL",["flyDuration"]=5.37},{"Banana","CT Spawn","grenade","weapon_smokegrenade",361.208,1795.971,126.042,-32.028,58.743,"stwmbf_488",["throwType"]="NORMAL",["flyDuration"]=5.57},{"2nd Middle","Short","grenade","weapon_smokegrenade",790.031,-302.989,99.047,-58.427,41.08,"stwmbf_517",["throwType"]="NORMAL",["flyDuration"]=5.58},{"Sandbags","C1","grenade","weapon_smokegrenade",664.969,1873.031,168.094,-29.14,136.445,"stwmbf_489",["throwType"]="NORMAL",["flyDuration"]=5.37},{"2nd Middle","Balcony","grenade","weapon_smokegrenade",693.867,11.969,88.316,-51.134,-12.082,"stwmbf_498",["throwType"]="NORMAL",["flyDuration"]=6.99},{"2nd Middle","Headshot / Default","grenade","weapon_smokegrenade",726.031,294.227,96.094,-54.451,2.338,"stwmbf_525",["throwType"]="NORMAL",["flyDuration"]=7.43},{"T","Library","grenade","weapon_smokegrenade",960.156,434.031,88.094,-47.025,28.968,"stwmbf_544",["throwType"]="NORMAL",["flyDuration"]=6.6},{"2nd Middle","Arch","grenade","weapon_smokegrenade",726.031,294.227,96.094,-43.561,41.451,"stwmbf_480",["throwType"]="NORMAL",["flyDuration"]=5.8},{"2nd Middle","Long","grenade","weapon_smokegrenade",726.0,246.549,91.627,-30.079,40.927,"stwmbf_483",["throwType"]="NORMAL",["flyDuration"]=4.37},{"2nd Middle","Boost / Default","grenade","weapon_smokegrenade",726.049,246.79,91.62,-50.952,-1.721,"stwmbf_528",["throwType"]="NORMAL",["flyDuration"]=6.02},{"Banana","C1","grenade","weapon_smokegrenade",460.465,1828.471,136.183,-25.443,86.28,"stwmbf_515",["throwType"]="NORMAL",["flyDuration"]=4.77},{"Underpass","Short","grenade","weapon_smokegrenade",295.99,644.005,20.094,-22.456,-11.856,"stwmbf_471",["throwType"]="NORMAL",["flyDuration"]=3.55},{"Close","Middle","grenade","weapon_flashbang",1347.064,830.0,145.197,-54.996,98.371,"stwmbf_522",["throwType"]="NORMAL"},{"Close","Middle","grenade","weapon_flashbang",1487.969,760.018,138.936,-35.937,-164.239,"stwmbf_554",["throwType"]="NORMAL",["throwStrength"]=0.5},{"Sandbags","Banana","grenade","weapon_flashbang",610.969,1873.031,134.252,-44.187,-0.872,"stwmbf_553",["throwType"]="NORMAL"},{"Close","Middle","grenade","weapon_flashbang",1517.992,792.031,140.017,-16.913,-160.268,"stwmbf_507",["throwType"]="NORMAL"},{"Cubby","T","grenade","weapon_flashbang",1291.031,1186.031,160.094,-77.155,-1.665,"stwmbf_493",["throwType"]="NORMAL",["throwStrength"]=0},{"T","Middle","grenade","weapon_flashbang",1314.031,347.223,128.464,-26.451,-90.554,"stwmbf_508",["throwType"]="RUN"},{"Porch","Banana","grenade","weapon_flashbang",941.969,2221.969,142.464,-29.421,-142.1,"stwmbf_509",["throwType"]="NORMAL"},{"C1","Banana","grenade","weapon_flashbang",498.969,2444.031,160.094,1.749,142.808,"stwmbf_513",["throwType"]="NORMAL"},{"C1","Banana","grenade","weapon_flashbang",498.98,2444.031,160.094,-20.807,143.303,"stwmbf_514",["throwType"]="NORMAL"},{"Long","T","grenade","weapon_flashbang",1721.969,1012.001,171.094,-35.409,-179.345,"stwmbf_523",["throwType"]="NORMAL",["throwStrength"]=0},{"Arch","Long","grenade","weapon_flashbang",1762.031,1447.951,160.094,-40.705,-37.097,"stwmbf_534",["throwType"]="NORMAL"},{"C1","Banana","grenade","weapon_flashbang",498.969,2444.031,160.094,1.997,166.339,"stwmbf_551",["throwType"]="NORMAL"},{"Dark","Stairs","grenade","weapon_flashbang",1121.031,-367.969,256.094,-6.798,74.802,"stwmbf_555",["throwType"]="NORMAL"},{"Speedway","Bombsite B","grenade","weapon_flashbang",1744.031,2694.497,160.094,-2.162,-100.138,"stwmbf_556",["throwType"]="NORMAL"},{"Tree","Banana","grenade","weapon_flashbang",1023.966,2654.031,133.262,-9.588,-0.42,"stwmbf_519",["throwType"]="RUN"},{"Banana","Car","grenade","weapon_flashbang",273.983,1378.46,107.094,-71.197,151.15,"stwmbf_512",["throwType"]="NORMAL",["throwStrength"]=0.5},{"Underpass","T","grenade","weapon_flashbang",272.031,644.012,20.094,-30.674,0.774,"stwmbf_545",["throwType"]="RUN",["runDuration"]=10},{"CT Apps","T","grenade","weapon_flashbang",1275.969,-111.969,256.094,9.454,116.691,"stwmbf_557",["throwType"]="RUN",["runDuration"]=10},{"Long Hall","Bombsite A","grenade","weapon_flashbang",1329.031,-365.969,256.031,-29.734,-22.831,"stwmbf_499",["throwType"]="NORMAL",["duck"]=true},{"2nd Middle","T","grenade","weapon_flashbang",736.006,159.994,99.412,-28.43,50.242,"stwmbf_506",["throwType"]="NORMAL"},{"Ruins","Grill","grenade","weapon_molotov",929.177,3295.995,144.094,-45.887,-131.961,"stwmbf_518",["throwType"]="JUMP",["flyDuration"]=1.8},{"Fountain","B Entrance","grenade","weapon_molotov",248.001,2883.031,160.094,-19.768,-44.473,"stwmbf_530",["throwType"]="NORMAL",["flyDuration"]=2.05},{"CT","C1 / C2","grenade","weapon_molotov",1483.84,2893.969,129.53,-16.121,-162.14,"stwmbf_532",["throwType"]="NORMAL",["flyDuration"]=1.87},{"Tree","Dark","grenade","weapon_molotov",1128.016,2643.0,134.56,-24.899,154.803,"stwmbf_531",["throwType"]="NORMAL",["flyDuration"]=2.04},{"Tree","New box","grenade","weapon_molotov",1128.0,2643.031,134.558,-23.001,-178.221,"stwmbf_533",["throwType"]="NORMAL",["flyDuration"]=2.05},{"Banana","C2","grenade","weapon_molotov",409.346,2009.173,128.094,-23.414,119.236,"stwmbf_501",["throwType"]="JUMP",["flyDuration"]=2.08},{"Banana","CT Boost","grenade","weapon_molotov",672.143,2125.969,136.073,-18.861,69.477,"stwmbf_520",["throwType"]="NORMAL",["duck"]=true,["flyDuration"]=2.07},{"2nd Middle","Boiler","grenade","weapon_molotov",695.087,-267.969,99.094,-21.533,32.424,"stwmbf_490",["throwType"]="NORMAL",["flyDuration"]=2.04},{"Window","Patio Roof","grenade","weapon_molotov",894.86,-56.048,296.094,-47.142,0.827,"stwmbf_492",["throwType"]="NORMAL",["flyDuration"]=2.06},{"Sandbags","New box","grenade","weapon_molotov",999.982,1878.531,149.33,-26.648,141.133,"stwmbf_504",["throwType"]="NORMAL",["flyDuration"]=2.07},{"Car","Dark","grenade","weapon_molotov",474.219,2034.3,203.094,-20.593,109.524,"stwmbf_494",["throwType"]="NORMAL",["flyDuration"]=2.06},{"Banana","C1","grenade","weapon_molotov",339.973,2027.928,128.094,-46.366,69.403,"stwmbf_500",["throwType"]="JUMP",["flyDuration"]=2.08},{"T","Patio","grenade","weapon_molotov",1157.563,589.969,122.094,-13.349,-43.742,"stwmbf_526",["throwType"]="RUN",["flyDuration"]=2.16},{"B Entrance","New boxes","grenade","weapon_molotov",875.999,2386.238,145.306,-17.886,166.899,"stwmbf_475",["throwType"]="NORMAL",["flyDuration"]=2.04},{"Short","Under balcony","grenade","weapon_molotov",1764.969,-108.969,130.136,-27.621,60.547,"stwmbf_529",["throwType"]="NORMAL",["flyDuration"]=2.08},{"Sandbags","Spools","grenade","weapon_molotov",664.969,1873.031,168.094,-24.273,96.641,"stwmbf_487",["throwType"]="NORMAL",["flyDuration"]=2.06},{"Porch","Dark","grenade","weapon_molotov",941.96,2108.011,140.094,-22.161,129.513,"stwmbf_510",["throwType"]="RUN",["runDuration"]=3,["flyDuration"]=2.39},{"Banana","Sandbags","grenade","weapon_molotov",327.111,1627.34,122.094,-11.122,56.075,"stwmbf_524",["throwType"]="RUN",["flyDuration"]=1.91,["runDuration"]=4},{"Balcony","Default","grenade","weapon_molotov",1911.2,-160.031,256.094,-19.57,-70.337,"stwmbf_548",["throwType"]="NORMAL",["flyDuration"]=1.64},{"Banana","CT","grenade","weapon_smokegrenade",416.48,1768.7,128.65,-48.07,65.35,"custom_48",["tickrate"]=64,["throwType"]="NORMAL"},{"Banana","B Plant (1)","grenade","weapon_smokegrenade",-79.45,1330.01,106.77,-36.52,66.62,"custom_49",["tickrate"]=64,["throwType"]="NORMAL"},{"Second Mid","Minipit","grenade","weapon_smokegrenade",941.91,415.63,88.53,-51.03,13.23,"custom_50",["tickrate"]=64,["throwType"]="NORMAL"},{"Second Mid","Short","grenade","weapon_smokegrenade",721.26,49.05,94.28,-36.35,55.47,"custom_51",["tickrate"]=64,["throwType"]="NORMAL"},{"Second Mid","Deep Long","grenade","weapon_smokegrenade",941.98,415.87,88.53,-47.68,39.04,"custom_52",["tickrate"]=64,["throwType"]="NORMAL"},{"Fountain","Construction (Retake)","grenade","weapon_smokegrenade",1899.344,2616.976,251.511,-37.61,158.63,"custom_53",["tickrate"]=64,["throwType"]="NORMAL"},{"A Arch","A Bombsite","grenade","weapon_molotov",2076.96,1225.886,174.031,-36.093,-89.079,"custom_378",["throwType"]="JUMP",["flyDuration"]=1.969,["landX"]=2064.695,["landY"]=485.309,["landZ"]=162.031},{"Short","Graveyard","grenade","weapon_molotov",1440.376,126.498,127.291,-7.493,0.507,"custom_379",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=1.875,["landX"]=2499.908,["landY"]=222.991,["landZ"]=126.031},{"Banana","Logs","grenade","weapon_molotov",741.021,2146.535,136.029,-7.436,-130.022,"custom_380",["throwType"]="RUN",["runDuration"]=6,["flyDuration"]=1.938,["landX"]=-59.771,["landY"]=1355.009,["landZ"]=103.291},{"Banana","Logs","grenade","weapon_hegrenade",787.048,2238.16,136.151,-12.87,-128.879,"custom_381",["throwType"]="RUN",["runDuration"]=2,["flyDuration"]=1.641,["landX"]=4.731,["landY"]=1381.72,["landZ"]=208.286},{"Middle","Arch","grenade","weapon_molotov",1136.425,434.031,109.158,-35.436,51.536,"custom_382",["throwType"]="RUNJUMP",["runDuration"]=24,["flyDuration"]=2.047,["landX"]=1530.432,["landY"]=1121.687,["landZ"]=156.535},{"Middle","Middle Gap","grenade","weapon_molotov",1199.743,434.031,116.292,-10.704,54.028,"custom_383",["throwType"]="RUN",["runDuration"]=15,["landX"]=1379.415,["landY"]=1172.546,["landZ"]=163.471},{"Arch","Pit","grenade","weapon_molotov",2076.96,1225.886,174.031,-13.85,-63.589,"custom_384",["throwType"]="RUN",["runDuration"]=8,["landX"]=2553.735,["landY"]=-133.558,["landZ"]=84.031},{"A Bombsite","Library","grenade","weapon_molotov",1934.129,507.748,160.031,-37.323,49.951,"custom_385",["throwType"]="RUNJUMP",["runDuration"]=5,["flyDuration"]=2.047,["landX"]=2414.046,["landY"]=1076.567,["landZ"]=158.985},{"Ruins","B Bombsite","grenade","weapon_molotov",1190.992,2837.244,127.797,-22.28,-146.204,"custom_386",["throwType"]="RUN",["flyDuration"]=2.047,["landX"]=222.987,["landY"]=2661.765,["landZ"]=160.031},{"Ruins Entrance","Grill","grenade","weapon_molotov",1232.719,2890.762,127.961,-23.424,-138.196,"custom_387",["throwType"]="RUN",["flyDuration"]=1.625,["landX"]=609.714,["landY"]=2920.412,["landZ"]=205.17},{"CT Spawn","Tree","grenade","weapon_molotov",1818.419,2502.152,128.026,-12.184,130.027,"custom_388",["throwType"]="RUN",["runDuration"]=5,["flyDuration"]=2.047,["landX"]=1220.97,["landY"]=2657.296,["landZ"]=131.561},{"Middle","Underpass","grenade","weapon_molotov",1373.294,609.36,129.715,-23.481,-154.948,"custom_389",["throwType"]="RUN",["runDuration"]=15,["flyDuration"]=2,["landX"]=404.036,["landY"]=639.673,["landZ"]=88.829},{"Arch","Box","grenade","weapon_molotov",2112.472,1225.812,169.821,-30.954,-89.705,"custom_401",["throwType"]="RUNJUMP",["runDuration"]=12,["landX"]=2118.624,["landY"]=174.321,["landZ"]=160.031},{"Arch","Centered Box","grenade","weapon_molotov",2017.015,1162.544,159.885,-37.807,-91.63,"custom_402",["throwType"]="RUNJUMP",["runDuration"]=4,["landX"]=-2000.214,["landY"]=698.833,["landZ"]=-45.969,["flyDuration"]=10.672},{"Top of Mid","Arch","grenade","weapon_molotov",1417.613,955.019,147.977,-13.555,30.963,"custom_403",["throwType"]="RUN",["runDuration"]=9,["landX"]=2251.058,["landY"]=969.987,["landZ"]=162.031},{"Arch","Graveyard","grenade","weapon_molotov",1804.406,1350.957,160.031,-19.635,-57.904,"custom_417",["throwType"]="NORMAL",["landX"]=2438.688,["landY"]=333.691,["landZ"]=220.031},{"A Site","Middle","grenade","weapon_molotov",2354.002,489.369,144.248,-35.882,177.1,"custom_418",["throwType"]="RUNJUMP",["runDuration"]=11,["landX"]=1371.718,["landY"]=538.192,["landZ"]=129.896},{"Top of Mid","Graveyard","grenade","weapon_molotov",1328.751,259.45,132.618,-18.095,-32.673,"custom_419",["throwType"]="RUN",["runDuration"]=32,["landX"]=2357.761,["landY"]=150.607,["landZ"]=130.02},{"Middle","A Site (Right)","grenade","weapon_molotov",1145.033,497.8,108.008,-35.936,18.009,"custom_544",["throwType"]="RUNJUMP",["landX"]=2235.48,["landY"]=848.833,["landZ"]=153.259},{"Top Mid","Under 1way","grenade","weapon_molotov",1314.015,235.502,135.243,-13.656,-24.905,"custom_781",["throwType"]="NORMAL",["landX"]=2089.972,["landY"]=-124.773,["landZ"]=258.031},{"Arch","Onspot","grenade","weapon_molotov",2007.521,1225.969,174.031,-42.695,-90.878,"custom_782",["throwType"]="RUNJUMP",["runDuration"]=1,["landX"]=2002.291,["landY"]=450.844,["landZ"]=223.781},{"Arch","Fakeduck box","grenade","weapon_molotov",2076.985,1225.965,174.031,-35.161,-98.816,"custom_783",["throwType"]="RUNJUMP",["runDuration"]=4,["landX"]=1956.549,["landY"]=434.211,["landZ"]=183.259},{"Arch","Onspot 50","grenade","weapon_hegrenade",1981.043,1225.974,174.031,-10.791,-41.444,"custom_784",["throwType"]="RUN",["runDuration"]=58,["landX"]=1972.569,["landY"]=464.318,["landZ"]=223.781},{"Arch","Graveyard","grenade","weapon_molotov",1991.761,1225.969,174.031,-21.544,-61.64,"custom_785",["throwType"]="NORMAL",["landX"]=2095.278,["landY"]=629.251,["landZ"]=160.031},{"Middle","Onspot","grenade","weapon_molotov",1298.12,545.948,122.75,-36.612,0.806,"custom_786",["throwType"]="RUNJUMP",["runDuration"]=2,["landX"]=2061.943,["landY"]=556.197,["landZ"]=160.031},{"Middle","Pit (Oneway)","grenade","weapon_molotov",1312.204,456.36,196.374,-28.078,-34.804,"custom_787",["throwType"]="RUNJUMP",["runDuration"]=16,["landX"]=2233.164,["landY"]=-198.182,["landZ"]=109.378},{"banana","T Site","grenade","weapon_smokegrenade",479.348,2017.988,128.409,-8.976,-111.516,"custom_789",["throwType"]="NORMAL",["landX"]=-58.748,["landY"]=833.896,["landZ"]=47.27},{"Barrel","Banana","grenade","weapon_smokegrenade",-857.994,437.79,-30.801,-53.296,50.735,"custom_796",["throwType"]="RUN",["runDuration"]=15,["runSpeed"]=true,["landX"]=388.946,["landY"]=1942.247,["landZ"]=130.031},{"Lower Mid","Middle","grenade","weapon_smokegrenade",-857.994,437.79,-30.801,-7.316,2.441,"custom_797",["throwType"]="JUMP",["landX"]=1236.568,["landY"]=519.189,["landZ"]=118.272},{"Deck","Roof","movement","weapon_knife",-107.998,205.969,184.031,3.564,-36.492,"custom_878",["data"]={9, {0.0, 0.0, "F"}, 4, {0.0, 0.088001}, 1, {0.0, 0.088001}, {0.0, 0.043999}, {0.044, 0.439999}, {0.088, 0.440002}, {0.22, 0.66}, {0.264, 1.011997}, {0.22, 0.792}, {0.264, 0.483997}, {0.088}, 7, {-0.088, 0.043999}, {0.0, 0.087997}, {0.0, 0.220001}, {-0.088, -0.044003}, {0.0, 0.043999, "R"}, {0.088, 0.087997}, {0.088, 0.396}, {0.0, 0.571999}, {0.044, 0.219999}, {0.044, 0.395998, "", "R"}, {0.044, 0.308001}, {0.0, 0.792}, {0.044, 0.528002}, {0.0, 0.528002}, {0.0, 0.528002}, {0.044, 0.439999}, {0.0, 0.088001}, {0.0, 0.044001}, {0.044, 0.044001}, {0.044, 0.044001}, {0.0, 0.088001}, {0.044, 0.044001}, {0.044, 0.132002}, {0.044, 0.088001}, {0.0, 0.088001, "L"}, {0.132, 0.307999}, {0.132, 0.351999}, {0.176, 0.748001, "", "L"}, {0.132, 0.747999}, {0.088, 1.011999}, {0.044, 0.747999}, {0.132, 0.792}, {0.088, 0.527998}, {0.044, 0.175999}, {0.044, 0.044001}, 6, {-0.044, -0.308001}, {-0.176, -0.66}, {-0.22, -0.704}, {-0.308, -0.747999}, {-0.308, -0.792}, {-0.44, -0.879999}, {-0.484, -0.615999}, {-0.528, -0.66}, {-0.616, -0.528002}, {-0.748, -0.440001}, {-0.528, -0.088001}, {-0.352, 0.219999}, {-0.308, 0.572001}, {-0.088, 1.584}, {0.308, 1.803999, "JR"}, {1.1, 2.199999, "", "J"}, {2.112, 1.495998, "", "F"}, {2.068, 0.66}, {2.112, 0.219999}, {2.288, -0.087999}, {2.024, -0.528}, {2.244, -1.1}, {1.276, -0.924002}, {1.144, -1.143999}, {1.1, -1.408001}, {0.66, -1.32}, {0.572, -1.672001}, {0.924, -2.375999}, {0.66, -1.628}, {0.44, -1.231998}, {0.66, -2.068001}, {0.484, -1.627998}, {0.572, -2.464001}, {0.308, -2.112}, {0.396, -1.804001}, {0.264, -1.847996}, {0.176, -2.508003}, {0.088, -1.891998}, {0.132, -2.023998}, {0.044, -3.123997}, {0.0, -1.671997}, {0.0, -3.299999}, {0.0, -3.035999}, {-0.132, -2.947998}, {-0.176, -4.487999}, {-0.22, -2.992004}, {-0.264, -2.903999}, {-0.792, -3.652}, {-0.748, -2.727997}, {-0.704, -2.288002, "L", "", 0.0, 225.0}, {-0.616, -1.715996, "Z", "", 0.0, 0.0}, {-0.572, -1.276001, "J", "R"}, {-0.22, -0.175995, "", "J"}, {-0.396, -0.131996}, {-0.264, 0.131996}, {-0.308, 0.352005}, {-0.616, 1.232002}, {-0.484, 1.320007, "", "Z"}, {-0.44, 1.320007}, {-0.264, 1.627998}, {-0.176, 2.024002}, {-0.088, 1.715996}, {-0.132, 1.452003}, {-0.088, 1.408005}, {0.0, 1.32}, {-0.044, 0.835999}, {0.0, 0.923996}, {-0.044, 1.188004}, {0.0, 1.672012}, {0.0, 1.584}, {0.0, 1.584}, {-0.044, 2.243996}, {-0.044, 1.584}, {0.0, 1.496002}, {0.0, 1.363998}, {0.044, 1.408001}, {0.044, 1.276001, "R", "", 0.0, 0.0}, {0.176, 0.66, "", "L"}, {0.22, 0.307999}, {0.352, -0.132}, {0.616, -1.056}, {0.484, -1.407997}, {0.484, -2.199997}, {0.264, -2.288002}, {0.132, -3.299999, "L", "", 0.0, 0.0}, {0.0, -2.200005, "", "", 0.0, 0.0}, {0.0, -1.716003, "", "R"}, {-0.264, -1.320007}, {-0.352}, {-0.572, 1.144005, "R", "", 0.0, -225.0}, {-0.572, 2.156006, "D", "L"}, {-0.044, 1.143997}, {0.264, -0.968002}, {0.22, -4.223999}, {0.044, -5.148003}, {0.0, -4.575996}, {-0.572, -2.728012}, {-0.484, -0.440002, "F"}, {-0.792, 0.087997}, {-0.836, 0.395996}, {-0.352, 0.484009}, {-0.22, 0.704002}, {-0.132, 0.879997}, {0.0, 1.099998, "Z"}, {0.0, 0.44001}, {0.0, 0.263992}, {0.0, 0.704002}, {-0.132, 3.124001}, {-0.044, 5.456001}, {-0.132, 8.975994}, {-0.088, 10.076, "", "Z"}, {0.088, 14.476002}, {0.0, 8.755999, "", "D"}, {-0.22, 7.656002}, {-1.496, 8.536001}, {-1.276, 5.28}, {-0.836, 4.092}, {-0.308, 3.696, "S"}, {-0.22, 6.996}, {-0.352, 4.004}, {-0.528, 1.628, "", "F"}, 6, {-0.176, 0.264}, {-0.176, 0.176}, {-0.44, 0.396}, {-0.968, 0.747999}, {-0.66, 0.616}, {-0.528, 0.836001}, {-0.44, 0.528}, {-0.616, 0.220001}, {-0.396, 0.044001}, {-0.22}, {-0.176}, {-0.264}, {-0.484, -0.132002}, {-0.44, -0.044001, "F"}, {-0.528, -0.088001}, {-0.572}, {-0.88, -0.220001}, {-0.528, -0.132002}, {-0.396, -0.088001}, {-0.132, -0.132}, {-0.044, -0.044001, "", "R"}, 13, {0.0, 0.0, "R"}, 3, {-0.132, 0.132}, {-0.044, 0.219999}, {-0.044, 0.044001, "", "R"}, 3, {0.0, 0.044001}, {-0.044, 0.176001}, {0.0, 0.132002}, {0.0, 0.132002}, {0.0, 0.044001}, {0.0, 0.044001, "R"}, {0.0, 0.044001}, 2, {0.0, 0.0, "L", "", 450.0, 225.0}, {0.0, 0.0, "", "R"}, {0.0, 0.044001, "", "F"}, 2, {0.0, 0.0, "", "L"}, {0.0, 0.0, "R"}, {0.0, 0.0, "F", "", 225.0}, 3, {0.0, 0.0, "", "R"}, 1, {0.0, 0.0, "L"}, {0.0, 0.0, "", "L"}, {0.0, 0.0, "", "F"}, 10}},{"Roof","Deck","movement","weapon_knife",366.969,-302.969,257.641,31.284,111.7,"custom_879",["data"]={13, {-0.044, 0.043999}, {0.176, 0.616005}, {0.484, 1.275993}, {0.396, 1.056}, {0.264, 0.792, "F", "", 225.0}, {0.484, 1.496002}, {0.396, 1.364006}, {0.264, 1.452003}, {0.264, 1.627998}, {0.308, 1.628006}, {0.088, 0.660004}, {0.264, 0.792}, {0.264, 0.923996}, {0.352, 1.540001}, {0.088, 0.616005}, {0.088, 0.527992}, {0.088, 0.572006}, {0.132, 1.320007}, {0.088, 1.231995}, {0.044, 1.187988}, {0.044, 1.584}, {0.0, 0.791992}, {0.044, 2.068008}, {0.0, 1.716019}, {0.0, 1.540009, "R", "", 450.0, 225.0}, {0.044, 1.23201}, {0.044, 0.484009}, {0.0, 0.087997}, 3, {0.132, -0.043991}, {0.308, -0.792007}, {0.22, -1.099991}, {0.044, -1.627991}, {0.0, -1.979996}, {0.0, -2.419998}, {-0.088, -3.520004}, {-0.132, -2.771996, "J"}, {-0.132, -2.903999, "", "J"}, {-0.132, -4.928001, "", "F"}, {-0.088, -3.519997}, {-0.132, -2.992004}, {-0.132, -3.387993}, {-0.44, -4.619995}, {-0.308, -2.155998}, {-0.748, -3.696007}, {-0.528, -1.804001, "L", "", 0.0, 0.0}, {-0.572, -1.496002, "", "", 0.0, 0.0}, {-0.748, -1.276001, "", "R"}, {-0.264, -0.351997}, {-0.176, -0.043999}, {-0.264, 0.219994}, {-0.352, 1.012001}, {-0.44, 1.628006}, {-0.44, 2.816002}, {-0.352, 4.972}, {-0.088, 2.464005}, {0.044, 2.024002}, {0.264, 1.540001}, {0.308, 1.012001}, {0.176, 0.440002}, {0.396, 0.440002, "R", "", 0.0, 0.0}, {0.484, 0.131996, "", "L"}, {0.572, -0.176003}, {0.748, -0.968002}, {0.396, -0.879997}, {0.352, -1.055992}, {0.44, -1.231995}, {0.132, -1.23201}, {0.132, -1.320007}, {0.0, -0.923996, "L", "", 0.0, 0.0}, {0.0, -0.660004, "", "", 0.0, 0.0}, {-0.132, -0.836006, "", "R"}, {-0.308, -0.219994}, {-0.484, 0.264}, {-0.572, 0.748001}, {-0.572, 1.804008, "D"}, {-0.308, 0.967995}, {-0.176, 0.572006}, {-0.044, 0.087997}, {0.0, 0.0, "R", "L"}, 3, {-0.044, 0.043999}, {-0.396, 0.307999, "F"}, {-0.748, 0.660004}, {-1.452, 2.112}, {-1.408, 2.683998}, {-1.584, 3.344002, "", "R"}, {-2.2, 5.675995}, {-0.924, 3.739998, "L"}, {-1.76, 6.248009}, {-1.056, 2.991989}, {-0.528, 1.276001, "", "D"}, 1, {-0.088, 0.087997, "D"}, {-0.044, -0.044006, "", "L"}, {0.0, -0.220001}, {0.0, -0.395996}, {-0.044, -0.175995}, 1, {0.0, 0.0, "", "D"}, {0.0, 0.615997}, {0.0, 2.024002}, {0.0, 3.784012}, {0.044, 7.128006}, {-0.132, 4.708008, "S"}, {-0.44, 3.388016}, {-0.308, 1.276001}, 1, {-0.088, 0.220001}, {-0.088, 0.132019}, {-0.22, 0.17601}, {-0.616, 0.307999}, {-0.528, 0.352005}, {-0.352, 0.307999, "L", "", 450.0, -225.0}, {-0.264, 0.088013}, {-0.352, 0.220016}, {-0.264, 0.132019}, {-0.22, 0.17601, "", "L"}, {-0.22, 0.132019}, {-0.396, 0.088013}, {-0.308}, {-0.528, -0.220001}, {-0.616, -0.307999}, {-0.792, -0.440002}, {-0.352, -0.132004}, {-0.308, -0.044006}, {-0.44, -0.307999}, {-0.176, -0.220001}, {-0.132, -0.132019}, {-0.044}, 1, {-0.088, -0.088013, "L"}, {-0.088, -0.044006}, {-0.132, -0.132004, "", "S"}, {-0.044, -0.087997}, 1, {-0.044, 0.044006, "", "L"}, 2, {-0.044, -0.132019}, {-0.044, -0.044006}, {0.0, -0.044006}, 1, {0.0, 0.0, "R", "", 450.0, 225.0}, 1, {-0.044, -0.088013}, {0.0, -0.176025}, {0.0, -0.088013}, {0.0, -0.132019}, {-0.044, -0.17601}, {0.0, -0.395996, "", "R"}, {0.0, -0.440002}, {-0.044, -0.748016}, {-0.044, -1.099991}, {0.0, -2.463989}, {0.0, -2.376022, "R"}, {-0.044, -2.156006}, {0.0, -1.584}, {-0.088, -0.924011}, {-0.22, -0.968018}, {-0.176, -0.615997}, {-0.044, -0.35199}, {-0.176, -1.011993}, {-0.22, -1.187988}, {-0.264, -0.924011}, {-0.396, -0.968018}, {-0.396, -0.792007}, {-0.66, -0.835999}, {-0.44, -0.440002, "", "R"}, {-0.484, -0.395996}, {-0.616, -0.395996}, {-0.484, -0.132019, "L", "", 450.0, -225.0}, {-0.396, -0.17601}, {-0.308, -0.088013}, {-0.396, -0.044006, "", "F"}, {-0.308}, {-0.264}, {-0.308, 0.044006}, {-0.132, 0.132004}, {-0.22, 0.307999}, {-0.264, 0.220001}, {-0.132, 0.132019}, {-0.132, 0.044006}, {-0.176}, {-0.132, -0.044006}, {-0.352}, {-0.528, -0.17601, "F"}, {-0.484, -0.352005}, {-0.396, -0.440002, "", "L"}, {-0.264, -0.263992}, {-0.132, -0.220001}, {-0.044, -0.087997}, {-0.088, -0.175995}, {0.0, -0.044006}, 1, {0.0, -0.17601}, {0.176, -0.528}, {0.22, -0.792007}}},{"Under Boiler","Apartments","movement","weapon_knife",939.969,339.684,93.031,5.148,-96.904,"custom_880",["data"]={11, {0.0, 0.0, "F"}, 8, {-0.044, -0.175995}, {0.044, -0.131996}, {0.176, -0.263992}, 8, {-0.044, -0.043999}, {0.044}, {0.22, 0.175995}, {0.088, 0.087997}, 1, {0.132, -0.043999}, {0.044}, 1, {0.088, 0.043999, "L", "", 450.0, -225.0}, 1, {0.044, -0.043999}, {0.132, -0.087997}, {0.0, -0.087997}, {0.044}, {0.044, -0.043999, "", "L"}, {0.176}, {0.088, 0.043999}, {0.132, 0.175995}, {0.044, 0.043999}, 2, {0.044, 0.087997}, 1, {0.132, -0.176003}, {0.132, -0.704002}, {0.044, -0.967995}, {0.044, -1.584007}, {0.044, -1.584}, {0.0, -0.748001}, {0.0, -1.980003}, {0.0, -1.056}, {0.0, -0.660004}, 1, {0.132, 0.220001, "J"}, {0.352, 0.792, "R", "J"}, {1.232, 1.76001}, {1.54, 1.496002, "", "F"}, {1.716, 0.879997, "D"}, {2.068, 0.396004}, {1.716, -0.176003}, {1.672, -1.144005}, {0.924, -0.967995}, {0.924, -0.967995}, {1.012, -1.099998}, {0.88, -1.011993}, {1.056, -1.187996}, {0.528, -0.923996}, {0.484, -1.056}, {0.308, -0.792}, {0.176, -0.528008}, {0.088, -0.263992}, {0.132, -0.484001}, {0.176, -0.616005}, {0.176, -0.616005}, {0.132, -0.616013}, {0.044, -0.263992}, {0.0, -0.131996}, {0.0, -0.043999}, {0.0, -0.043999, "", "D"}, 1, {-0.088, -0.131996, "L", "", 0.0, 0.0}, {-0.044, 0.264, "", "R"}, {-0.176, 0.396004}, {-0.176, 0.616005}, {-0.308, 0.836006}, {-0.132, 0.879997}, {-0.088, 0.967995}, {-0.044, 0.835999, "J"}, {0.0, 0.835999, "", "J"}, {-0.088, 1.540009}, {-0.044, 1.496002}, {-0.044, 1.848007}, {0.0, 1.056}, {0.0, 0.879997}, {0.0, 0.660004}, {0.0, 0.748009}, {0.0, 0.660004}, {0.044, 0.660004}, {0.0, 0.660004}, {0.0, 0.879997}, {0.0, 1.275993}, {0.044, 1.055992}, {0.0, 0.879997}, {0.0, 0.792007}, {0.0, 0.307999}, {0.0, 0.219994}, {0.0, 0.219994}, {0.0, 0.307991}, {0.044, 0.352005, "D"}, {0.0, 0.528008}, {0.044, 0.572006}, {0.0, 0.924004}, {0.0, 1.099998}, {-0.176, 1.055992}, {-0.176, 1.011993}, {-0.132, 0.923996, "", "D"}, {-0.132, 0.528008, "F", "", 225.0}, {0.0, 0.0, "", "L"}, 9, {-0.044}, 2, {0.0, -0.087997}, {0.044, -0.263992}, {0.088, -0.131996}, {0.132, -0.175995}, {0.22, -0.175995}, {0.264, -0.087997}, {0.308, -0.087997}, {0.352, -0.131996}, {0.484, -0.087997}, {0.396, -0.043999}, {0.616}, {0.748}, {0.836}, {1.232}, {1.056, -0.043999}, {0.924}, {1.188, -0.131996}, {0.748, -0.043999}, {0.748, -0.087997}, {0.836, -0.043999}, {0.792, -0.131996}, {0.616, -0.175995}, {0.264, -0.087997}, {0.22, -0.131996}, {0.22, -0.131996}, {0.088, -0.131996}, {0.0, -0.219994}, {-0.088, -0.704002, "J"}, {-0.528, -1.320007, "", "J"}, {-1.276, -2.464005}, {-1.54, -1.935997}, {-2.244, -1.408005}, {-1.144, -0.220001, "L"}, {-1.98, 0.264008}, {-1.144, 0.572006}, {-1.232, 0.792007}, {-0.616, 0.923996, "", "F"}, {-0.308, 0.792}, {-0.176, 0.704002}, {-0.088, 0.748001}, {-0.044, 0.792}, {0.0, 1.363991}, {0.0, 1.144005}, {0.0, 1.188004}, {-0.044, 1.628014}, {0.0, 1.188011}, {0.0, 1.188004}, {0.0, 1.144005}, {0.0, 1.099998}, {0.0, 1.363991}, {0.0, 0.967995}, {0.044, 1.143997}, {0.088, 0.704002}, {0.132, 0.616005}, {0.22, 0.44001, "R", "L"}, {0.352, 0.263992}, {0.484, -0.043999}, {0.704, -0.748009}, {0.44, -0.879997}, {0.352, -0.792}, {0.396, -0.792}, {0.264, -1.056}, {0.0, -0.748001}, {0.0, -0.660004}, {0.0, -0.660011}, {-0.088, -0.307999, "L", "R"}, {-0.088, -0.087997}, {-0.088, -0.131996}, {-0.132, -0.131996}, {-0.22, -0.131996, "F", "", 225.0}, {-0.132, -0.087997, "", "L"}, {-0.22, -0.087997}, {-0.132, -0.087997}, {-0.044, -0.043999}, {-0.088, -0.087997}, {-0.044, -0.043999}, {-0.044, -0.043999}, 2, {-0.088, 0.175995}, {-0.088, 0.131996}, {-0.088, 0.175995}, {0.0, 0.131996}, {-0.044, 0.043999}, {-0.088, 0.175995}, {-0.044, 0.087997}, {-0.044, 0.175995}, {0.0, 0.219994}, {0.044, 0.484001}, {0.264, 0.792, "J"}, {0.88, 1.364006, "", "J"}, {2.024, 2.200005}, {3.036, 2.419998, "R"}, {2.2, 1.012001}, {2.112, 0.308006}, {1.892, -0.307999, "", "F"}, {2.332, -0.924004}, {1.408, -0.835999}, {1.232, -0.835999}, {1.012, -1.143997}, {0.704, -1.276001}, {0.528, -1.232002}, {0.44, -1.232002}, {0.528, -1.628014}, {0.264, -1.276009}, {0.264, -1.364006}, {0.44, -1.540001}, {0.22, -1.056}, {0.132, -1.011993}, {0.088, -1.496002}, {0.088, -1.671997}, {0.044, -2.199997}, {0.044, -1.584}, {0.0, -1.232002}, {0.0, -1.319992}, {-0.044, -1.099998}, {0.0, -1.320007}, {-0.044, -1.188004}, {-0.132, -1.056}, {-0.352, -1.32}, {-0.264, -0.792}, {-0.22, -0.44001, "L", "", 0.0, 0.0}, {-0.22, -0.264, "", "", 0.0, 0.0}, {-0.176, -0.175995, "", "R"}, {-0.176, 0.131996}, {-0.308, 0.484001}, {-0.66, 1.804001}, {-0.484, 2.155998}, {-0.308, 2.948006}, {-0.44, 3.343994}, {-0.132, 1.584}, {-0.22, 2.243996}, {-0.132, 1.627998}, {-0.22, 1.408005}, {-0.22, 2.508003}, {-0.352, 1.891998}, {-0.396, 2.112007}, {-0.528, 2.288002}, {-0.66, 3.343994}, {-1.144, 5.236}, {-0.924, 4.751999}, {-1.1, 6.16}, {-0.748, 3.739998}, {-0.66, 3.607998}, {-0.66, 3.563999}, {-0.66, 3.872002}, {-0.528, 3.343998}, {-0.88, 4.355999}, {-0.704, 2.683998}, {-1.1, 3.563999}, {-0.924, 2.728001}, {-0.748, 2.859999}, {-0.836, 2.903999, "DZ"}, {-0.66, 2.903999}, {-1.276, 3.872}, {-0.924, 2.507999}, {-0.924, 2.552}, {-1.32, 3.564, "J"}, {-0.88, 2.596, "", "J"}, {-0.792, 2.728}, {-0.66, 2.332}, {-0.528, 2.508, "", "Z"}, {-0.572, 2.772}, {-0.264, 1.54}, {-0.264, 1.496, "", "D"}, {-0.132, 1.32}, {-0.044, 1.408, "R", "", 0.0, 0.0}, {0.0, 1.056001, "", "L"}, {0.0, 0.924}, {0.0, 0.352}, 1, {0.0, -0.087999}, {0.132, -0.528001}, {0.352, -1.54}, {0.176, -1.54}, {0.132, -1.892}, {0.088, -1.892}, {0.0, -2.156}, {0.0, -1.452}, {0.0, -1.672}, {-0.22, -1.364, "L", "", 0.0, 0.0}, {-0.484, -0.836, "", "", 0.0, 0.0}, {-0.968, -0.396, "", "R"}, {-1.056, 0.264}, {-1.012, 0.836}, {-1.188, 1.584}, {-1.232, 2.904}, {-0.704, 2.816}, {-0.484, 3.08}, {-0.264, 3.784001}, {-0.132, 2.332, "J"}, {0.0, 2.244001, "", "J"}, {0.0, 2.42}, {0.044, 2.728001, "R", "", 0.0, 0.0}, {0.132, 1.32, "", "L"}, {0.308, 0.792}, {0.748, 0.176001}, {1.628, -0.792}, {1.54, -1.627998}, {1.1, -2.023998}, {0.88, -2.419998}, {0.396, -1.495998, "L", "", 0.0, 0.0}, {0.044, -0.527998, "", "", 0.0, 0.0}, {-0.044, -0.044001, "", "R"}, {-0.308, 0.088001}, {-0.748, 0.659998}, {-0.66, 1.056}, {-0.924, 2.024}, {-1.452, 3.651999}, {-2.156, 5.940001}, {-1.628, 4.883997}, {-2.024, 5.852001}, {-2.772, 8.755997}, {-2.112, 5.983997}, {-2.112, 5.059998}, {-2.332, 4.443996}, {-3.344, 4.751999, "F"}, {-2.772, 3.652}, {-2.376, 3.255997, "", "L"}, {-2.288, 3.080002}, {-1.584, 2.024002}, {-1.672, 1.627998}, {-0.968, 0.923996}, {-0.572, 0.704002}, {-0.264, 0.308006}, 1, {-0.088, 0.087997}, {0.044, 0.043999}, {0.44, -0.043999}, {0.66, -0.219994}, {0.836, -0.307999}, {0.66, -0.616005}, {0.132, -0.307999}, 8, {0.0, -0.220001}, {0.044, -0.087997}, {0.572, -0.484009}, {0.572, -0.484009}, {0.176, -0.220001}, {0.044, -0.043999}, {0.484, -0.131996}, {0.968, -0.219994}}},{"Balcony","Roof","movement","weapon_knife",2092.969,-364.969,256.031,8.228,100.4,"custom_881",["data"]={12, {0.0, 0.0, "F"}, 2, {0.176, 0.131996}, {0.528}, {0.572, -0.131996}, {0.308, -0.043999}, {0.748, -0.175995}, {0.528, -0.175995}, {0.616, -0.175995}, {0.44, -0.131996}, {0.704, -0.219994}, {0.616, -0.175995}, {0.66, -0.263992}, {0.528, -0.131996}, {0.704, -0.175995}, {0.528, -0.087997}, {0.528, -0.087997}, {0.528}, {0.66}, {0.396}, {0.44, 0.087997}, {0.704, 0.175995}, {0.44, 0.220001}, {0.924, 0.528008}, {0.748, 0.396011}, {0.968, 0.571999}, {0.572, 0.440002}, {1.364, 0.968002}, {1.1, 0.879997}, {1.32, 1.232002}, {0.792, 0.879997}, {0.836, 0.967995}, {0.792, 0.967995}, {1.188, 1.143997}, {0.88, 0.660004}, {0.572, 0.308006}, {0.704, 0.352005}, {1.012, 0.395996}, {0.616, 0.175995}, {0.484, 0.131996}, {0.352}, {0.308, -0.087997}, 1, {0.044, -0.175995}, {0.0, -0.572006}, {-0.22, -0.967995}, {-1.144, -2.155998}, {-1.672, -1.715996}, {-1.98, -1.584}, {-3.08, -1.540009, "J"}, {-1.408, -0.440002, "L", "J"}, {-1.936, -0.176003}, {-0.968, 0.704002}, {-0.968, 1.452003, "", "F"}, {-0.704, 2.639999}, {-0.176, 2.288002}, {-0.132, 2.463997}, {-0.044, 2.068008}, {0.0, 2.507996}, {0.0, 1.671997}, {0.0, 2.332001}, {0.0, 1.056}, {0.0, 2.419998}, {-0.044, 2.332008}, {-0.088, 2.728004}, {0.0, 3.73999}, {0.0, 2.552002}, {0.0, 2.771988}, {0.0, 2.595993}, {-0.088, 3.563995}, {-0.088, 2.28801}, {-0.044, 2.199997}, {-0.044, 2.199997}, {-0.044, 3.608002}, {0.0, 2.728012}, {0.0, 2.376007}, {0.0, 1.671997}, {0.088, 0.220001, "R", "", 0.0, 0.0}, {0.22, -0.263992, "", "", 0.0, 0.0}, {0.352, -0.88002, "", "L"}, {0.572, -1.320007}, {0.66, -1.935989}, {0.44, -1.363998}, {0.264, -1.495987}, {0.132, -1.628006}, {0.088, -1.979996}, {0.0, -1.40799, "J"}, {-0.132, -1.143997, "L", "J", 0.0, 0.0}, {-0.616, -1.056, "", "", 0.0, 0.0}, {-0.704, -0.264008, "", "", 0.0, 0.0}, {-0.704, 0.395996, "", "R"}, {-0.66, 0.792007}, {-0.924, 2.111984}, {-0.396, 2.024002}, {-0.308, 2.332001}, {-0.176, 2.067993}, {-0.132, 2.112}, {-0.264, 2.596008}, {-0.132, 2.156006}, {-0.176, 2.552002}, {-0.088, 1.672012}, {-0.088, 1.451996}, {-0.044, 1.495987}, {-0.044, 1.276001}, {-0.044, 1.231995}, {-0.044, 1.627991}, {-0.044, 1.363998}, {0.0, 1.451981}, {0.0, 2.244003}, {-0.044, 1.628006}, {0.0, -358.548019}, {0.0, 1.495987}, {0.0, 1.451981}, {0.0, 1.539993}, {0.0, 1.627991}, {0.0, 1.056015, "R", "", 0.0, 0.0}, {0.176, 0.439987, "", "L"}, {0.308, -0.132004}, {0.352, -0.660004}, {0.44, -1.540009}, {0.264, -1.012009, "D"}, {0.044, -1.23201}, {0.0, -1.187988}, {-0.264, -0.968018, "L", "R"}, {-0.66, -0.792007}, {-0.66, -0.17601}, {-0.836, 0.132004}, {-1.144, 0.660004}, {-0.396, 0.395996, "F", "", 225.0}, {-0.968, 0.703979}, {-0.748, 0.396011, "", "L"}, {-0.836, 0.484009}, {-0.396, 0.17601}, {-0.088, 0.044006}, 4, {0.0, 0.0, "R"}, 2, {0.0, 0.0, "", "R"}, 1, {0.0, 0.0, "", "D"}, 1, {-0.044, -0.088013}, {0.044, -0.263992}, {0.352, -0.440002}, {0.88, -0.440002}, {1.144, -0.352005}, {1.408, -0.263992, "J"}, {2.156, -0.220016, "", "J"}, {1.32, -0.044006, "D"}, {0.308, -0.044006}, {0.176}, {0.132}, {0.088}, 14, {0.0, 0.0, "", "D"}, 6, {0.088}, {0.44, -0.263992}, {0.396, -0.352005}, {0.308, -0.263992}, {0.176, -0.132019}, {0.176, -0.044006}, {0.132, -0.088013}, {0.22, -0.352005}, {0.22, 359.647995}, {0.264, -0.132019}, {0.22, -0.088013}, {0.132, -0.044006}, {0.264}, {0.308, -0.044006}, {0.352}, {0.396, 0.044006}, {0.352}, {0.308, 0.044006}, {0.088}, {0.264, -0.087997}, {0.308, -0.044006}, {0.044, 0.044006}, {0.044, -0.044006}, {0.044}, {0.044, 0.044006}, 6, {-0.132, 0.088013}, {-0.264, 0.220016, "J"}, {-0.176, -359.604004, "R", "J"}, {-0.044, 0.792007}, {0.088, 1.363998}, {0.352, 1.100006, "", "F"}, {0.88, 0.307999}, {0.704, -0.528}, {0.968, -1.276016}, {0.528, -0.835999}, {0.704, 358.416}, {0.396, -1.320007}, {0.176, -1.539993}, {0.0, -1.276001, "Z"}, {0.0, -1.364014}, {-0.044, -0.307999, "L", "R"}, {-0.308, -0.307999}, {-0.66, -0.132019}, {-0.396, 0.264008}, {-0.308, 0.571991}, {-0.352, 0.703979}, {-0.176, 0.440002, "", "Z"}, {-0.352, 1.188004}, {-0.352, 1.100006}, {-0.352, 1.363998}, {-0.308, -358.108017, "F"}, {-0.044, 0.703995, "", "L"}, {-0.044, 0.220001}, {0.0, 0.044006}, {0.0, 0.044006}, 1, {0.0, 0.0, "S"}, 1, {0.0, 0.044006}, {0.264, 0.132019}, {0.484, 0.044006}, {0.792}, {1.012, 0.088013}, {0.66}, {0.44, -0.088013}, {0.132, -0.088013}, 6, {0.044}, {0.044}, 2, {0.088}, {0.396, -1.23201}, {0.528, 357.447998}, {0.308, -3.783997}, {0.044, -4.003998, "L"}, {-0.088, -3.652008}, {-0.704, -5.192001}, {-1.408, -5.632004, "", "F"}, {-1.408, -5.67601}, {-1.584, -6.424011}, {-1.628, -7.876007}, {-1.364, -5.5}, {-1.144, -4.003998}, {-1.54, -3.608002}, {-0.88, -1.408005}, {-0.792, -1.276009}, {-0.748, -1.363998}, {-0.484, -0.792}, {-0.572, -1.407997}, {-0.528, -1.364006}, {-0.792, -1.540001}, {-0.484, -0.792}, {-0.396, -0.440002}, {-0.352, -0.308006}, {-0.264, -0.263992}, {-0.132, -0.175995}, {-0.132, -0.175995}, {-0.044, -0.175995}, {-0.044, -0.263992}, {0.0, -0.043999}, {0.0, -0.043999}, {-0.044, -0.131996}, {0.0, -0.219994}, {0.0, -0.484009}, {-0.044, -0.352005}, {0.0, -0.352005}, {0.0, -0.351997}, {0.0, -0.043999}, 3, {0.044, -0.307999}, {0.044, -0.263992}, {0.044, -0.131996}, {0.0, -0.263992}, {0.0, -0.043999}, {0.0, -0.043999}, {0.044, -0.131996, "R", "", 0.0, -225.0}, {0.088, -0.307991, "", "L"}, {0.044, -0.263992}, {0.088, -0.263992}, {0.0, -0.043999}, {0.044, -0.087997}, {0.132, -0.307991, "L", "R"}, {0.044, -0.087997}, 1, {0.0, -0.043999}, {0.044, -0.087997}, 1, {0.0, -0.087997}, {0.0, -0.043999, "R", "", 0.0, -225.0}, {0.0, 0.0, "", "L"}, 5, {0.0, 0.0, "", "R"}, 7}},{"Balcony","Graveyard","movement","weapon_knife",1841.031,-160.031,256.031,8.465,-18.837,"custom_882",["data"]={12, {0.0, 0.0, "F"}, 3, {0.0, 0.219999}, {0.308, 0.396}, {0.44, 0.307999}, {0.484, 0.176001}, {0.44, 0.132002}, {0.836, 0.307999}, {0.704, 0.264}, {0.704, 0.132002}, {0.704, 0.132002}, {0.836, 0.264}, {0.66, 0.132002}, {0.572, 0.044001}, {0.792, 0.132002}, {1.056, 0.176003}, {1.056, 0.22}, {0.924, 0.264001}, {0.88, 0.22}, {1.276, 0.264}, {1.144, 0.22}, {1.1, 0.131999}, {1.276, 0.175999}, {0.968, 0.044}, {0.968, -0.044}, {0.836, -0.044}, {1.144, -0.087999}, {0.88, -0.131999}, {0.968, -0.131999}, {0.748, -0.087999}, {1.1, -0.352}, {0.792, -0.352}, {0.66, -0.440001}, {0.484, -0.307999}, {0.572, -0.704002}, {0.264, -0.351999}, {0.088, -0.219999}, {0.132, -0.351999}, {0.0, -0.396}, {0.0, -0.484001}, {-0.308, -0.66}, {-0.924, -1.188}, {-1.628, -1.451998}, {-1.628, -0.792}, {-2.068, -0.703999}, {-2.42, -0.703999}, {-2.464, -0.528}, {-3.036, -0.132}, {-1.892, 0.219999, "JL"}, {-1.76, 0.704, "", "J"}, {-1.232, 1.188}, {-0.748, 1.364}, {-0.308, 1.364, "", "F"}, {0.572, 2.42}, {0.968, 2.816}, {1.144, 3.212}, {1.012, 2.948}, {1.364, 3.696}, {0.924, 2.508}, {0.836, 2.42}, {0.616, 1.76}, {0.528, 1.54}, {0.616, 1.98}, {0.396, 1.496}, {0.396, 1.452}, {0.44, 1.803999}, {0.264, 1.231999}, {0.088, 1.188}, {0.044, 1.495999}, {0.0, 2.112}, {0.0, 3.915998}, {0.0, 3.299999}, {0.0, 4.400002}, {-0.044, 3.388}, {-0.088, 3.344002}, {-0.132, 4.179996}, {-0.176, 5.455997}, {-0.088, 2.507999}, {-0.176, 3.035999, "R", "", 0.0, 0.0}, {0.0, 0.264, "", "", 0.0, 0.0}, {0.0, -0.175999, "", "L"}, {0.0, -3.387997}, {0.132, -4.091999}, {0.22, -5.631996}, {0.088, -2.375999}, {0.044, -4.355997, "J"}, {0.0, -2.948, "", "J"}, {0.044, -3.256001}, {0.088, -3.344002}, {0.088, -4.179998}, {0.044, -2.948}, {0.088, -2.860001}, {0.044, -2.816}, {0.0, -3.124}, {0.044, -2.024}, {0.088, -2.552}, {0.0, -2.464}, {0.0, -3.08}, {0.0, -2.112}, {-0.088, -1.892}, {-0.572, -2.596001, "L", "", 0.0, 0.0}, {-0.308, -1.804, "", "", 0.0, 0.0}, {-0.352, -1.759999, "", "R"}, {-0.22, -0.968}, {-0.132, -0.264}, {-0.22, 0.307999}, {-0.572, 1.363998}, {-0.572, 2.112}, {-0.308, 3.124001}, {-0.22, 4.224}, {-0.088, 3.212}, {0.0, 3.476}, {-0.044, 4.972}, {0.0, 3.52, "R", "", 0.0, 0.0}, {-0.044, 2.684001, "", "L"}, {0.0, 2.288}, {0.0, 1.54}, {0.0, 0.176}, {0.0, 0.044}, {0.0, -0.572}, {0.132, -2.772001}, {0.22, -2.904}, {0.22, -3.608}, {0.22, -4.532}, {0.088, -2.244}, {0.044, -3.872, "L", "", 0.0, 225.0}, {0.0, -2.42, "", "", 0.0, 0.0}, {0.0, -1.936, "", "R"}, {-0.044, -0.396}, {-0.132, 0.087999}, {-0.352, 1.144}, {-0.352, 2.596}, {-0.22, 4.928}, {-0.044, 4.356}, {0.0, 3.784, "R", "", 0.0, 0.0}, {-0.044, 2.816, "", "L"}, {-0.044, 0.835999}, {0.0, -0.044}, {0.088, -1.363999}, {0.132, -2.64}, {0.088, -4.312}, {0.044, -3.432}, {0.0, -2.2}, {-0.22, -1.496, "D"}, {-0.616, -0.924, "F", "", 225.0}, {-0.528, -0.264}, {-0.748, 0.044, "", "R"}, {-0.88, 0.264, "L"}, {-0.484, 0.132}, {-0.44, 0.088, "", "L"}, {-0.308, 0.088}, {-0.176, 0.088}, {-0.044, 0.044}, {-0.044, 0.044}, {-0.044, 0.176}, {0.968, 1.231999}, {1.672, 4.092}, {1.144, 6.776}, {0.308, 11.176001}, {0.044, 20.591999}, {0.0, 17.864002}, {0.0, 11.792}, {0.0, 4.884003}, 2, {0.0, 0.835999}, {0.0, 1.232002}, {-0.396, 1.980003}, {-0.396, 0.879997}, {-0.616, 0.792}, {-0.924, 1.100006}, {-1.892, 1.892006}, {-1.672, 1.759995}, {-1.54, 1.408005}, {-1.892, 0.968002}, {-0.924, 0.219994, "", "D"}, {-0.572, 0.352005}, {-0.22, 0.748001}, {-0.352, 0.923996}, {-0.044, -0.043999}, {0.0, 0.0, "S"}, 4, {0.0, -0.043999}, {0.0, -0.484001}, {-0.132, -0.264008}, {-0.176, -0.396004}, {-0.132, -0.087997}, 3, {-0.088, -0.043999}, {-0.088, -0.528008}, {0.0, -0.748001}, {-0.044, -1.011993}, {-0.044, -0.835999}, {0.0, -0.923996}, {0.0, -1.187996}, {0.088, -1.408005}, {0.044, -2.332001, "", "S"}, {0.044, -3.696007}, {0.0, -2.683998}, {0.0, -2.244003}, {-0.044, -1.847992}, {0.0, -1.936005}, {0.0, -1.364006}, {0.0, -1.408001}, {0.0, -1.100002}, {-0.044, -0.66}, {-0.044, -0.792}, {-0.044, -0.396}, {0.0, -0.043999}, 1, {0.0, 0.264, "R", "", 450.0, 225.0}, {0.132, 1.540001}, {0.968, 4.268005}, {1.232, 3.564003, "J", "F"}, {1.54, 2.903999, "", "J"}, {1.54, 1.099998}, {1.892, -0.615997}, {1.98, -2.375999}, {1.408, -2.244003}, {0.968, -2.112007}, {0.924, -2.244003}, {0.968, -2.815998}, {0.308, -2.639999}, {0.132, -3.212002}, {0.044, -3.916}, {0.0, -2.375999}, {0.044, -1.98}, {0.0, -1.848}, {0.0, -2.464001}, {-0.044, -1.804001}, {-0.088, -1.276001}, {-0.132, -1.715996}, {-0.176, -2.551998}, {-0.088, -1.056}, {-0.176, -1.891998}, {-0.132, -1.056, "L", "", 0.0, 0.0}, {-0.176, -0.396, "", "", 0.0, 0.0}, {-0.396, 0.087999, "", "R"}, {-0.396, 0.615999}, {-0.396, 0.924004}, {-0.66, 1.935997}, {-0.528, 2.947998}, {-0.396, 4.048}, {-0.22, 4.664001}, {-0.176, 6.863998}, {0.0, 4.268002}, {0.176, 3.168003}, {0.484, 2.155998, "R", "", 0.0, 0.0}, {0.704, 1.584, "", "L"}, {0.66, 0.440002, "J"}, {0.66, -0.131996, "", "J"}, {0.792, -0.704002}, {0.924, -1.056004}, {0.88, -1.760002}, {0.44, -1.188}, {0.572, -1.627998}, {0.748, -2.464001}, {0.352, -2.244003, "L", "", 0.0, 0.0}, {0.176, -2.112, "", "", 0.0, 0.0}, {0.044, -1.628002, "", "R"}, {-0.132, -1.495998}, {-0.44, -0.396}, {-0.396, 0.264}, {-0.528, 1.32}, {-0.484, 1.803997}, {-0.264, 2.815998}, {-0.132, 3.167999}, {-0.044, 3.388}, {-0.132, 3.784004}, {-0.044, 1.672005, "R", "L"}, {0.0, 0.264}, {0.0, -0.748001}, {0.0, -1.760002}, {0.0, -3.871998}, {-0.044, -2.728001}, {-0.264, -1.363998}, {-0.484, -0.220001}, {-1.452, 2.419998}, {-1.408, 4.311996}, {-1.672, 10.736008}, {-1.452, 10.295998}, {-2.112, 11.175995}, {-1.716, 9.459999}, {-1.98, 9.328003}, {-1.54, 4.267998}, {-1.496, 2.816002}, {-1.584, 2.244003}, {-1.98, 2.508003}, {-1.232, 1.408005}, {-1.188, 0.967995}, {-1.188, 0.484001, "F", "", 225.0}, {-0.308, -0.088013}, {-0.176, -0.132004}, {-0.176, -0.352005}, {-0.22, -0.571999}, {-0.396, -0.792}, {-0.44, -1.540009}, {-0.176, -1.056}, {-0.044, -0.616005}, {0.0, -0.352005, "S"}, {0.0, -0.131996}, {0.088, -0.131996}, {0.572, -0.175995}, {0.528, -0.219994}, {0.616, -0.175995}, {0.44, -0.175995, "", "F"}, {0.352, -0.131996}, {0.044, -0.043999}, {0.044, -0.087997}, {0.0, -0.175995}, {0.044, -0.307999}, {0.176, -0.528015}, {0.22, -0.528008}, {0.132, -0.44001}, {0.132, -0.484009}, {0.044, -0.087997}, 4, {0.0, 0.0, "F"}, 1, {0.0, 0.0, "", "R"}}},{"CT","CT Roof","movement","weapon_knife",2235.529,2230.034,206.031,21.66,177.398,"custom_883",["data"]={12, {0.264, 0.088013}, {1.1, 0.396011}, {1.496, 0.483994, "F", "", 225.0}, {2.552, 0.396011}, {1.496}, {1.672, 0.088013}, {1.76}, {1.804, -0.132004}, {1.804, -0.132019}, {1.276}, {1.144}, {1.144}, {0.924, 0.132019}, {1.012, 1.5e-05}, {0.748, -0.044006}, {1.188, 0.088013}, {0.572, 0.044006}, {1.232, 0.044006}, {1.012}, {0.836, -0.132004}, {0.704, -0.220016}, {0.88, -0.17601}, {0.704, -0.220001}, {0.396, -0.395996}, {1.188, -0.395996}, {0.924, -0.307999}, {0.792, -0.307999}, {0.66, -0.263992}, {0.572, -0.176025}, {0.22, -0.132004}, {0.044, -0.132019}, {0.0, -0.044006}, 2, {-0.176, -0.307999}, {-1.144, -1.276016}, {-1.672, -1.496002}, {-2.728, -1.979996}, {-3.916, -2.156006, "J"}, {-5.808, -2.860001, "L", "J"}, {-3.432, -0.923996}, {-6.732, -0.043991, "", "F"}, {-4.796, 1.584}, {-3.872, 2.640015}, {-1.144, 2.904007}, {-0.704, 1.936005}, {-0.22, 1.716003}, {0.0, 1.628006}, {0.44, 2.28801}, {0.572, -358.548004}, {0.924, 0.923996, "R", "", 0.0, 0.0}, {1.584, 0.703995, "", "L"}, {1.232, -0.087997}, {1.188, -0.660004}, {0.968, -0.792023}, {0.924, -0.968018}, {1.1, 358.23999}, {0.748, -1.628006}, {0.616, -2.199997}, {0.528, -1.935989}, {0.264, -2.023987}, {0.044, -1.628006}, {-0.044, -1.056015, "L", "", 0.0, 0.0}, {-0.396, -0.263992, "", "", 0.0, 0.0}, {-0.484, -0.044006, "", "R"}, {-1.144, 0.967987}, {-0.748, 1.276001, "D"}, {-0.968, 2.199997}, {-0.352, 1.188004}, {-0.088, 0.836014}, {0.0, 0.747986, "F"}, {0.0, 0.615997}, {-0.044, 0.571991}, {0.0, 0.307999}, {0.0, 0.352005, "", "L"}, {-0.088, 0.35202}, {-0.088, 0.132019}, {-0.044, 0.088013}, 1, {-0.044, 0.044006}, {-0.044}, {-0.088, -0.220001}, {-0.308, -0.615997}, {-0.264, -0.615997}, {-0.528, -0.439987}, {-0.484, -0.17601}, {-0.924, 0.131989}, {-0.792, 0.440002}, {-1.54, 0.220016}, {-1.672, 0.264008}, {-1.76, 0.263992}, {-2.024, 0.440002}, {-1.276, 0.396011}, {-1.496, 0.440002}, {-2.024, 1.012009}, {-1.144, 0.572006}, {-1.672, -359.12001, "R"}, {-0.616, 0.307999}, {-0.132, 0.044006}, 4, {-0.132, 0.220001}, {0.132, 0.17601, "", "D"}, {0.264, 0.307999}, {0.44, 0.395996}, {0.22, 0.307999}, {0.22, 0.307999}, {0.308, 0.395996, "S"}, {0.396, 0.396011}, {0.484, 0.396011}, {0.704, 0.352005}, {1.056, 0.440002}, {0.572, 0.263992}, {0.528, 0.132019}, {0.264, 0.088013}, {0.088, 0.044006}, {0.088, 0.044006}, {0.132, 0.044006}, {0.176, 0.132019}, {0.484, 0.35199}, {0.22, 0.220001}, {0.088, 0.044006}, {0.044, 0.087997}, 10, {0.176, 0.220001}, {0.22, 0.396011}, {0.264, 0.483994}, {0.396, 0.791992}, {0.264, 0.572006}, {0.132, 0.395996}, {0.264, 0.572006}, {0.176, 0.483994}, {0.176, 0.440002}, {0.132, 0.395996}}},{"Banana CT","Wall","movement","weapon_knife",729.832,2091.456,136.172,16.644,-163.717,"custom_884",["data"]={10, {0.0, 0.0, "F"}, 4, {-0.044, 0.044006}, {0.088, 0.571991}, {0.044, 0.571991}, {0.0, 0.396011}, {0.0, 0.263992}, {0.0, 0.132019}, {0.0, 0.395996}, {0.0, 0.440002}, {0.0, 0.483994}, {0.0, 0.483994}, {0.0, 0.307999}, {0.0, 0.264008}, {0.0, 0.17601}, {0.0, 0.088013}, 3, {0.0, 0.0, "L"}, 1, {0.0, 0.0, "", "L"}, 9, {0.0, 0.044006}, 1, {0.0, 0.044006}, {0.0, 0.044006}, 3, {-0.044, 0.132019}, {-0.396, 0.088013}, {-0.44, 0.132019}, {-0.528, 0.132019}, {-0.616, 0.088013}, {-0.528, 0.132019}, {-0.704, 0.220016}, {-0.704, 0.088013}, {-0.748, 0.088013}, {-0.968, 0.307999}, {-0.748, 0.396011}, {-0.572, 0.615997}, {-0.528, 1.012009}, {-0.484, 1.716019}, {-0.044, 1.451996}, {0.352, 1.584, "JR"}, {1.628, 1.979996, "", "J"}, {2.2, 1.143997}, {2.288, 0.572006, "", "F"}, {2.42, 0.17601}, {1.892, -0.440002}, {1.716, -0.792007}, {1.716, -1.363998}, {1.672, -2.023987}, {1.1, -1.804016}, {0.616, -1.23201}, {0.66, -1.628006}, {0.836, -2.684006}, {0.308, -2.156006}, {0.088, -2.639999}, {0.0, -1.936005}, {0.0, -1.76001}, {-0.22, -2.244003}, {-0.176, -1.144012}, {-0.308, -2.552002}, {-0.528, -1.363998}, {-1.1, -1.539993}, {-0.528, -0.528015}, {-1.056, -0.968002}, {-0.704, -0.307999, "L", "", 0.0, 0.0}, {-0.484, 0.792023, "", "", 0.0, 0.0}, {-1.188, 2.332001, "", "", 0.0, 0.0}, {-1.012, 3.212006, "", "R"}, {-0.572, 4.487991}, {-0.396, 5.059998}, {-0.396, 6.203979}, {-0.264, 4.839996, "J"}, {-0.22, 4.268005, "", "J"}, {-0.176, 3.740005}, {-0.176, 3.564011}, {-0.22, 4.532013}, {-0.176, 3.475998}, {-0.22, 4.179993}, {-0.088, 2.463997}, {-0.088, 2.332001}, {-0.088, 2.112007}, {-0.132, 2.772011}, {-0.132, 2.024002}, {-0.044, 1.804001}, {-0.044, 1.671997}, {-0.044, 1.452003}, {-0.088, 2.243996}, {-0.044, 1.804001}, {-0.044, 2.02401}, {0.0, 2.023994}, {-0.044, 2.948006}, {-0.088, 2.639999}, {0.0, 2.419998}, {0.0, 2.419998}, {0.0, 2.508003, "R", "", 0.0, 0.0}, {0.088, 0.924004, "", "L"}, {0.22, -0.131996}, {0.44, -1.100006}, {0.528, -1.672005, "D"}, {0.308, -2.860001}, {0.088, -2.860008}, {0.0, -2.552002}, {-0.088, -1.627998, "L", "", 0.0, 0.0}, {-0.308, -0.264, "", "R"}, {-0.484, 0.748001}, {-0.88, 3.300003, "F"}, {-0.308, 3.564003, "", "L"}, {-0.176, 3.388}, {-0.176, 2.419998}, {-0.176, 1.848007}, {0.0, 0.043999}, {0.0, -1.715996}, {0.0, -4.531998}, {-0.044, -5.543999}, {-0.308, -7.084007, "", "D"}, {-0.616, -4.136002}, {-0.748, -2.375999}, {-0.572, -0.792}, {-0.616, -0.264}, {-0.352}, {-0.176, 0.0, "S"}, 2, {-0.088}, {-0.22, 0.396004}, {-0.132, 0.528008}, {-0.132, 0.307999}, {-0.132, 0.44001}, {-0.308, 0.660011, "L"}, {-0.132, 0.352005}, {-0.22, 0.175995}, {-0.132, 0.131996, "", "F"}, 3, {-0.088, 0.043999}, {-0.264}, {-0.264, -0.131996}, {-0.264, -0.087997}, {-0.352, -0.175995}, {-0.088, -0.087997, "BR", "L", -450.0, 225.0}, {-0.088, -0.131996}, 5, {0.0, 0.0, "", "B"}, 13, {0.0, 0.0, "L", "", 0.0, 0.0}, {0.0, 0.0, "", "R"}, 2, {0.0, 0.0, "", "L"}, 4}},{"Banana T","Wall","movement","weapon_knife",198.818,1745.591,122.031,2.3,62.611,"custom_885",["data"]={10, {0.0, 0.0, "F"}, 4, {0.0, -0.088001}, {0.264, -0.220001}, {0.88, -0.132}, {1.012, -0.175999}, 9, {0.132}, {0.088, 0.175999}, {0.132, 0.087997}, {0.308, 0.264004}, {0.44, 0.352005}, {0.308, 0.220001}, {0.396, 0.264004}, {0.44, 0.396}, {0.66, 0.616009}, {0.572, 0.264}, {0.44, 0.175995}, {0.44, 0.087997}, {0.308, 0.087997}, {0.264}, {0.132}, {0.176}, {0.132, -0.043999}, {0.132}, 1, {0.088}, {0.044}, {0.088}, {0.088}, {0.132, 0.043999}, {0.088, 0.043999}, {0.088, 0.087997}, {0.044, 0.043999}, {0.264, 0.219994}, {0.088, 0.087997}, {0.044, 0.087997}, {0.044, 0.043999}, {0.044, 0.087997}, {0.088, 0.087997}, 1, {0.044}, {0.0, -0.087997}, {-0.352, -0.440002}, {-0.572, -0.484001}, {-0.66, -0.484009}, {-0.836, -0.616005}, {-1.364, -1.012001}, {-1.012, -0.748001}, {-0.836, -0.264}, {-0.484, 0.264}, {-0.22, 0.572002, "R", "", 450.0, 225.0}, {0.0, 0.879997, "J"}, {0.968, 1.716007, "", "J"}, {1.408, 1.23201}, {2.068, 1.144005, "", "F"}, {1.98, 0.528}, {2.464}, {1.54, -0.352005}, {1.364, -0.572006}, {1.672, -1.056}, {0.792, -0.615997}, {1.408, -1.540009}, {0.704, -1.099998}, {0.616, -1.231998}, {0.792, -2.068001}, {0.616, -1.671997}, {0.528, -1.759998}, {0.484, -2.067997}, {0.396, -2.375999}, {0.264, -3.476002}, {0.088, -2.683998}, {0.132, -2.596001}, {0.132, -3.124001}, {0.044, -4.531998}, {0.0, -3.387999}, {0.044, -3.167999}, {0.088, -5.632002}, {0.0, -5.412001}, {0.0, -5.940001}, {0.0, -7.172}, {0.0, -5.148}, {-0.044, -5.324}, {-0.044, -5.059999}, {-0.088, -4.664001, "J"}, {0.0, -6.072002, "", "J"}, {0.0, -4.752001}, {0.044, -4.047998}, {0.088, -4.268002}, {0.0, -3.959999}, {-0.044, -4.751999}, {0.0, -4.84}, {-0.044, -2.155998}, {-0.088, -4.136002}, {0.0, -2.464001}, {-0.132, -2.243999}, {-0.088, -3.563999}, {0.0, -2.771996}, {0.0, -2.375999}, {0.0, -2.596001}, {-0.044, -2.552002}, {0.0, -3.036003}, {0.0, -2.464005}, {0.0, -2.332001}, {0.0, -1.760002}, {0.0, -2.112}, {0.044, -1.979996}, {0.044, -1.891998}, {0.0, -1.715996, "D"}, {0.132, -2.155998}, {0.044, -1.671997}, {0.132, -2.288002}, {0.088, -1.320007}, {0.264, -2.904007}, {0.132, -1.891998}, {0.044, -1.891998}, {0.044, -1.627998}, {0.044, -1.804008}, {-0.044, -1.187996}, {-0.044, -0.660004}, {-0.088, -0.572006}, {-0.132, -0.44001}, {-0.176, -0.351997}, 3, {-0.132, 0.043999, "F"}, {-0.22, 0.131996}, {0.0, 0.087997}, {-0.044, 0.571999}, {-0.132, 0.879997}, {-0.044, 0.748009}, {-0.044, 0.528008}, {-0.132, 0.396004, "", "R"}, {-0.044, 0.219994}, {-0.132, 0.131996}, {-0.132, 0.175995}, {-0.352, -0.043999}, {-1.188, -0.528008}, {-1.628, -0.792}, {-2.068, -1.716003, "L"}, {-1.32, -1.451996}, {-1.584, -0.396004}, {-1.232, 0.484001, "", "L"}, {-0.308, 0.220001}, 5, {-0.22, 0.440002}, {-0.088, 0.264}, {-0.044, 0.175995}, {-0.396, 0.748009}, {-0.352, 0.175995, "L"}, {-0.528, 0.043999}, {-0.528, 0.043999, "", "F"}, {-0.484, 0.043999}, {-0.704, -0.131996}, {-0.88, -0.484009}, {-0.484, -0.263992}, {-0.308, -0.219994}, {-0.44, -0.484009}, {-0.176, -0.307999}, {-0.132, -0.131996}, {-0.044, -0.087997}, {-0.132, -0.219994}, {-0.088, -0.176003}, 5, {-0.044, -0.043999}, {-0.044}, 1, {0.0, 0.043999, "R", "L"}, {-0.176, 0.220001, "", "D"}, {-0.132, 0.175995}, 1, {-0.088, 0.131996}, {-0.132, 0.175995}, 2, {0.0, 0.0, "S"}, 1, {-0.044, 0.043999}, {0.0, 0.131996}, {0.0, 0.219994}, {0.0, 0.131996}, {0.0, 0.087997}, 2}},{"Fountain","Quad","movement","weapon_knife",388.572,2788.161,273.031,64.604,-153.78,"custom_886",["data"]={16, {-0.088}, {-0.352, 0.17601}, {-1.232, 0.615997, "F"}, {-1.32, 0.527985}, {-1.98, 0.747986}, {-1.32, 0.528}, {-1.056, 0.220001}, {-0.924, 0.132019}, {-1.012, 0.132019}, {-0.88}, {-1.232, -0.220016}, {-0.88, -0.263992}, {-0.836, -0.263992}, {-0.924, -0.307999}, {-0.792, -0.307999}, {-0.924, -0.352005}, {-0.88, -0.263992}, {-1.32, -0.307999}, {-1.012, -0.132019}, {-1.056, -0.132019}, {-0.924, -0.088013}, {-1.188, -0.088013}, {-0.836, -0.088013}, {-1.056, -0.044006}, {-1.056, -0.088013}, {-1.584, -0.088013}, {-1.188}, {-1.276, -0.044006}, {-2.068, -0.220016}, {-1.936, -0.17601}, {-2.156, -0.132019, "J", "", 30.795621871948242, 448.94500732421875}, {-2.156, 0.0, "", "J", 25.770551681518555, -449.261474609375}, {-2.816, -0.044006, "", "", 30.766691207885742, 448.9469909667969}, {-1.672, 0.0, "", "", 25.029672622680664, -449.3033752441406}, {-1.76, 0.263992, "", "", 28.29190444946289, 449.1097412109375}, {-1.232, 0.263992, "", "", 20.92888832092285, -449.5130310058594}, {-0.704, 0.088013, "", "", 33.01871871948242, 448.7869873046875}, {-0.22, 0.044006, "", "", 21.624752044677734, -449.4801025390625}, {-0.132, 0.044006, "", "", 31.942354202270508, 448.8648986816406}, {-0.132, 0.044006, "", "", 21.93202781677246, -449.4652099609375}, {-0.176, 0.044006, "", "", 30.878236770629883, 448.9393615722656}, {-0.044, 0.0, "", "", 21.910003662109375, -449.46630859375}, {0.0, 0.0, "", "", 30.518951416015625, 448.96392822265625}, {0.0, 0.0, "", "", 21.557477951049805, -449.4833679199219}, {0.0, 0.0, "", "", 30.328840255737305, 448.9767761230469}, {0.0, 0.0, "", "", 21.453813552856445, -449.4883117675781}, {0.0, 0.0, "", "", 30.224214553833008, 448.9838562011719}, {0.0, 0.0, "", "", 21.34763526916504, -449.49334716796875}, {0.0, 0.0, "", "", 30.116958618164062, 448.9910583496094}, {0.0, 0.0, "", "", 21.23822021484375, -449.49853515625}, {0.0, 0.0, "", "", 30.00634765625, 448.99847412109375}, {0.0, 0.0, "", "", 21.125812530517578, -449.50384521484375}, {0.0, 0.0, "", "", 29.89275360107422, 449.0060119628906}, {0.0, 0.0, "", "", 21.010412216186523, -449.5092468261719}, {0.0, 0.0, "", "", 29.776042938232422, 449.0137939453125}, {0.0, 0.0, "", "", 20.892017364501953, -449.5147705078125}, {0.0, 0.0, "", "", 29.521696090698242, 449.0306091308594}, {0.0, 0.0, "", "", 20.578365325927734, -449.52923583984375}, {0.0, 0.0, "", "", 29.2142391204834, 449.0506896972656}, {0.0, 0.0, "", "", 20.27607536315918, -449.54296875}, {0.0, 0.0, "", "", 28.917770385742188, 449.06988525390625}, {0.0, 0.0, "", "", 19.98455047607422, -449.5559997558594}, {0.0, 0.0, "", "", 28.631574630737305, 449.0882263183594}, {0.0, 0.0, "", "", 19.703075408935547, -449.5684509277344}, {0.0, 0.0, "", "", 28.35529136657715, 449.1057434082031}, {0.0, 0.0, "", "", 19.431171417236328, -449.5802917480469}, {0.0, 0.0, "", "", 28.088211059570312, 449.1225280761719}, {0.0, 0.0, "", "", 19.16823959350586, -449.5915832519531}, {0.0, 0.0, "", "", 27.829851150512695, 449.13861083984375}, {0.0, 0.0, "", "", 18.913921356201172, -449.6023254394531}, {0.0, 0.0, "", "", 27.579856872558594, 449.1540222167969}, {0.0, 0.0, "", "", 18.667503356933594, -449.6126403808594}, {0.0, 0.0, "D", "", 27.337629318237305, 449.1688232421875}, {0.0, 0.0, "", "", 18.513277053833008, -449.6190185546875}, {-0.044, 0.0, "", "", 27.211668014526367, 449.176513671875}, {0.0, 0.0, "", "", 18.387907028198242, -449.6241760253906}, {0.0, 0.0, "", "", 27.08785629272461, 449.1839904785156}, 4, {0.0, 0.0, "R"}, 8, {0.0, 0.0, "", "R"}, 4, {0.0, 0.044006}, {0.132, 0.263992}, {0.308, 0.484009, "", "D"}, {0.66, 0.70401}, {1.144, 1.276001}, {0.352, 0.395996}, 4, {0.088, 0.087997}, {0.396, 1.847992}, {0.088, 3.300003}, {-0.088, 5.456009}, {-0.308, 6.292007}, {-0.264, 6.028}, {-0.22, 5.236}, {-0.176, 3.344009}, 11, {0.0, 0.0, "R"}, 2, {0.0, 0.0, "", "R"}, 9, {0.0, 0.220001}, {0.132, -0.043999}, {0.22, -0.396004}, {0.396, -0.616005}, {0.792, -1.627998, "DR"}, {0.572, -1.32}, {1.804, -4.136002}, {0.968, -3.124008}, {0.968, -3.959991}, {0.66, -3.035995}, {0.484, -2.684006, "", "F"}, {0.176, -1.100006}, {0.0, -0.220001}, {0.0, -0.087997}, 2, {0.0, 0.484009}, {-0.044, 2.287994}, {-0.22, 3.695999}, {-0.308, 7.040001}, {-0.308, 10.031998}, {-0.396, 17.203995}, {-0.308, 14.080002}, {-0.264, 14.124001, "B"}, {-0.352, 12.803997}, {-1.628, 12.936001}, {-2.464, 10.295998}, {-1.1, 3.608002}, {-1.628, 4.619999}, {-1.936, 5.456001}, {-1.056, 3.388}, {-0.572, 3.167999}, {-0.748, 4.179999}, {-0.176, 2.332}, {-0.044, 2.376}, {-0.044, 1.98}, {0.0, 0.308}, {-0.132, 0.132, "", "R"}, {-0.264, 0.088}, {-0.484, 0.044}, {-0.396, 0.088}, {-0.396, -0.044}, {-0.484, 0.132}, {-0.616, 0.176}, {-1.012, 0.704}, {-0.836, 0.792}, {-0.792, 0.88}, {-0.704, 1.144, "R"}, {-0.132, 0.264}, {0.0, 0.088}, {0.0, 0.22}, {0.088, 0.264}, {0.0, 0.22}, {0.088, 0.308}, {0.044, 0.132}, {0.176, 0.176}, {0.264, 0.22}, {0.088, 0.044}, {0.132}, {0.352, 0.176}, {0.264, 0.044}, {0.176}, {0.132}, {0.22}, {0.132}, {0.22}, {0.22, 0.0, "", "R"}, {0.352, 0.088}, {0.088, 0.044, "L"}, {0.176, 0.044}, {0.044}, {0.044, 0.088}, {0.0, 0.0, "", "L"}, {0.0, 0.044, "", "B"}, {0.044, 0.044}, {0.0, 0.044}, 18}},{"Fountain","2nd","movement","weapon_knife",353.39,2803.584,273.031,59.5,-97.461,"custom_887",["data"]={16, {0.088}, {0.0, 0.131996}, {-0.264, 0.351997}, {-0.264, 0.528008}, {-0.308, 0.396011}, {-0.264, 0.395996}, {-0.396, 0.396004}, {-0.528, 0.528008}, {-0.748, 1.276001, "F"}, {-1.056, 0.923996}, {-0.968, 0.616005}, {-0.88, 0.484009}, {-1.276, 0.748009}, {-0.66, 0.352005}, {-1.1, 0.528008}, {-0.484, 0.263992}, {-0.44, 0.131996}, {-0.66, 0.263992}, {-0.748, 0.175995}, {-0.308, 0.043999}, {-0.748, 0.087997}, {-0.572, 0.043999}, {-0.528}, {-0.484, -0.043999}, {-0.484}, {-0.44, -0.087997}, {-0.352, -0.043999}, {-0.22, -0.087997}, {-0.176}, {-0.484, -0.131996}, {-0.44, -0.131996}, {-0.396, -0.087997}, {-0.616, -0.175995}, {-0.66, -0.219994}, {-0.792, -0.263992}, {-1.364, -0.484009}, {-0.748, -0.264008, "J", "", 34.77640914916992, 448.6542053222656}, {-1.496, -0.616013, "", "J", 24.803218841552734, -449.31591796875}, {-1.188, -0.352005, "", "", 34.131160736083984, 448.7037658691406}, {-1.408, -0.131996, "", "", 20.60398292541504, -449.528076171875}, {-2.2, 0.395996, "", "", 31.666746139526367, 448.8844299316406}, {-1.32, 0.528008, "", "", 19.600528717041016, -449.57293701171875}, {-1.012, 0.484009, "", "", 31.222143173217773, 448.9155578613281}, {-0.924, 0.440002, "", "", 26.50089454650879, -449.218994140625}, {-0.352, 0.220001, "", "", 33.49832534790039, 448.75146484375}, {-1.012, 0.70401, "", "", 25.527008056640625, -449.2753601074219}, {-0.352, 0.308006, "", "", 33.0344352722168, 448.7858581542969}, {-0.528, 0.440002, "", "", 23.188129425048828, -449.40216064453125}, {-0.132, 0.131996, "", "", 28.197473526000977, 449.1156921386719}, {-0.176, 0.131996, "", "", 24.90636444091797, -449.3102111816406}, {-0.044, 0.0, "", "", 26.97265625, 449.19091796875}, {-0.044, 0.043999, "", "", 25.147830963134766, -449.2967834472656}, {-0.044, 0.087997, "", "", 25.83324432373047, 449.25787353515625}, {-0.132, 0.263992, "", "", 19.958629608154297, -449.5571594238281}, {-0.132, 0.307999, "", "", 29.097938537597656, 449.0582580566406}, {-0.176, 0.396011, "", "", 25.426204681396484, -449.2811279296875}, {-0.22, 0.616013, "", "", 28.931100845336914, 449.06903076171875}, {-0.132, 0.396011, "", "", 25.445049285888672, -449.280029296875}, {-0.22, 0.572006, "", "", 29.10487174987793, 449.05780029296875}, {-0.176, 0.528008, "", "", 18.30498504638672, -449.6275634765625}, {-0.132, 0.484009, "", "", 28.947845458984375, 449.0679626464844}, {0.0, 0.175995, "", "", 23.416959762573242, -449.39031982421875}, {0.0, 0.131996, "", "", 26.309715270996094, 449.230224609375}, {0.0, 0.131996, "", "", 17.3222713470459, -449.6664733886719}, {0.088, 0.263992, "", "", 30.733871459960938, 448.9492492675781}, {0.088, 0.263992, "", "", 21.160409927368164, -449.502197265625}, {0.132, 0.352005, "", "", 25.602806091308594, 449.2710876464844}, {0.308, 0.528008, "", "", 19.921634674072266, -449.5588073730469}, {0.22, 0.263992, "", "", 26.94532012939453, 449.1925354003906}, {0.308, 0.44001, "", "", 17.315385818481445, -449.666748046875}, {0.352, 0.528015, "", "", 26.91762924194336, 449.1942138671875}, {0.132, 0.352005, "", "", 23.94598960876465, -449.3624267578125}, {0.088, 0.175995, "D", "", 30.344863891601562, 448.9757080078125}, {0.132, 0.395996, "", "", 20.391902923583984, -449.5377197265625}, {0.0, 0.087997, "", "", 26.40985107421875, 449.224365234375}, {0.044, 0.131996, "", "", 21.977453231811523, -449.4629821777344}, {0.0, 0.0, "", "", 25.235958099365234, 449.29180908203125}, {0.044, 0.087997, "", "", 22.529848098754883, -449.4356689453125}, {0.0, 0.043999, "", "", 24.064342498779297, 449.3561096191406}, {0.0, 0.087997, "", "", 15.583207130432129, -449.7301025390625}, {0.0, 0.043999, "", "", 30.757183074951172, 448.9476623535156}, {0.0, 0.087997, "", "", 16.486005783081055, -449.6979064941406}, {0.0, 0.175995, "", "", 28.55616569519043, 449.0930480957031}, {0.0, 0.087997}, {0.0, 0.175995}, {0.0, 0.087997}, {0.0, 0.043999}, {-0.044, 0.043999}, {-0.044, 0.043999}, {-0.044, 0.043999}, 3, {-0.044}, 2, {0.0, 0.087997}, {0.0, 0.043999}, 3, {0.0, 0.043999}, {0.0, 0.087997}, {0.044, 0.395996}, {0.0, 0.219994}, {0.0, 0.748001}, {0.0, 1.408005}, {0.0, 1.012001}, {0.0, 0.352005, "", "F"}, {0.0, 2.200005}, {0.044, 2.772003}, {0.0, 9.063995, "", "D"}, {0.0, 8.403999}, {-0.22, 9.944}, {-0.572, 8.667999}, {-0.924, 8.316}, {-1.408, 9.152}, {-1.232, 5.059999}, {-1.32, 4.136}, {-0.792, 1.32}, {-0.66, 0.572}, {-0.748, 0.792}, {-0.528, 0.66}, {-0.132, 0.308}, {0.044, 0.572}, {0.264, 0.44}, {0.0, -0.044}, 6, {0.0, -0.088}, {-0.22, -0.132}, {-0.264, 0.044}, {-0.396, -0.132}, {-0.924, -0.352}, {-0.572, -0.132}, {-0.352, -0.088}, {-0.088, -0.044}, 2, {-0.044}, 2}}} end
		if map == "de_overpass" then locations_data={{"Long","Bank","grenade","weapon_smokegrenade",-3611.196,-177.627,512.836,4.686,45.854,"stwmbf_320",["tickrate"]=128,["throwType"]="JUMP",["flyDuration"]=4.38},{"Long","Back A","grenade","weapon_smokegrenade",-3580.172,-78.238,512.936,6.714,32.608,"stwmbf_322",["tickrate"]=128,["throwType"]="JUMP",["flyDuration"]=4.18},{"CT Spawn","Canal pipe","grenade","weapon_smokegrenade",-1993.413,537.721,475.094,-1.881,-43.971,"stwmbf_190",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=6.39},{"CT Spawn","Monster","grenade","weapon_smokegrenade",-2088.665,918.096,480.031,-16.534,-48.059,"stwmbf_411",["tickrate"]=64,["throwType"]="JUMP",["duck"]=true,["flyDuration"]=6.78},{"Long","Bank","grenade","weapon_smokegrenade",-3612.726,-177.627,512.78,3.036,45.676,"stwmbf_319",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=4.36},{"Long","Back A","grenade","weapon_smokegrenade",-3580.172,-78.238,512.936,4.256,32.542,"stwmbf_321",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=4.56},{"Back A","Canal pipe","grenade","weapon_smokegrenade",-1926.861,1307.969,354.928,-46.201,-40.011,"stwmbf_191",["throwType"]="NORMAL",["flyDuration"]=7.41},{"Heaven","Heaven (Oneway)","grenade","weapon_smokegrenade",-1826.376,629.179,256.094,26.58,-17.457,"stwmbf_292",["throwType"]="NORMAL",["flyDuration"]=1.53},{"CT Spawn","Long","grenade","weapon_smokegrenade",-1993.399,537.698,493.094,-28.678,-169.597,"stwmbf_324",["throwType"]="NORMAL",["duck"]=true,["flyDuration"]=3.78},{"CT Spawn","Pipe","grenade","weapon_smokegrenade",-2244.988,801.227,472.094,-20.659,-59.483,"stwmbf_266",["throwType"]="NORMAL",["flyDuration"]=5.37},{"CT Spawn","Pipe","grenade","weapon_smokegrenade",-2445.471,1043.549,480.085,-5.792,-58.008,"stwmbf_383",["throwType"]="JUMP",["flyDuration"]=4.97},{"CT Spawn","Pipe","grenade","weapon_smokegrenade",-1929.297,800.613,480.094,-13.267,-67.331,"stwmbf_410",["throwType"]="NORMAL",["flyDuration"]=4.77},{"Construction","Construction (Oneway)","grenade","weapon_smokegrenade",-1559.991,-361.262,32.424,-19.075,-131.258,"stwmbf_293",["throwType"]="NORMAL",["throwStrength"]=0.5,["flyDuration"]=1.95},{"Back A","Back A (Oneway)","grenade","weapon_smokegrenade",-2191.969,1311.969,356.094,-8.862,-55.39,"stwmbf_294",["throwType"]="NORMAL",["flyDuration"]=1.54},{"CT Spawn","Pipe","grenade","weapon_smokegrenade",-2079.997,670.613,472.094,-17.145,-61.819,"stwmbf_171",["throwType"]="NORMAL",["flyDuration"]=4.79},{"CT Spawn","Monster","grenade","weapon_smokegrenade",-2059.971,633.613,472.094,-33.991,-43.225,"stwmbf_435",["throwType"]="NORMAL",["flyDuration"]=8.23},{"CT Spawn","Sandbags","grenade","weapon_smokegrenade",-2115.841,992.92,480.094,-22.936,-57.691,"stwmbf_172",["throwType"]="NORMAL",["flyDuration"]=6.41},{"Tunnels","Tunnels (Oneway)","grenade","weapon_smokegrenade",-2012.969,-1231.969,240.094,16.219,63.144,"stwmbf_239",["throwType"]="NORMAL",["flyDuration"]=2.56},{"T Spawn","Restroom","grenade","weapon_smokegrenade",-730.031,-2225.144,240.094,-51.613,149.046,"stwmbf_241",["throwType"]="RUN",["flyDuration"]=6.67},{"Short","Heaven","grenade","weapon_smokegrenade",-2174.002,-1151.969,398.197,-26.368,71.544,"stwmbf_291",["throwType"]="NORMAL",["flyDuration"]=4.35},{"Alley","Bridge","grenade","weapon_smokegrenade",-617.486,-1509.029,144.094,-48.989,113.071,"stwmbf_183",["throwType"]="NORMAL",["flyDuration"]=5.38},{"Long","GSG","grenade","weapon_smokegrenade",-3612.546,-177.627,512.792,-40.393,51.26,"stwmbf_184",["throwType"]="NORMAL",["flyDuration"]=4.98},{"Short","B Default","grenade","weapon_smokegrenade",-2536.196,-1056.031,433.399,-25.873,34.544,"stwmbf_173",["throwType"]="NORMAL",["flyDuration"]=5.6},{"Short","Toxic / Pillar","grenade","weapon_smokegrenade",-2537.056,-1056.031,433.399,-25.526,38.12,"stwmbf_177",["throwType"]="NORMAL",["flyDuration"]=6.21},{"Construction","Pit","grenade","weapon_smokegrenade",-1567.969,-1087.99,0.094,-24.899,71.313,"stwmbf_188",["throwType"]="NORMAL",["flyDuration"]=4.98},{"Construction","B Default","grenade","weapon_smokegrenade",-1567.969,-1087.985,0.094,-30.278,74.646,"stwmbf_187",["throwType"]="NORMAL",["flyDuration"]=3.76},{"Cafe","Boxes / Truck","grenade","weapon_smokegrenade",-3540.031,-381.969,528.08,-14.257,41.85,"stwmbf_386",["throwType"]="NORMAL",["flyDuration"]=4.16},{"Long","Back A","grenade","weapon_smokegrenade",-3383.37,35.248,516.906,-18.035,31.699,"stwmbf_242",["throwType"]="NORMAL",["flyDuration"]=4.17},{"Construction","Toxic","grenade","weapon_smokegrenade",-1645.969,-1087.969,96.094,-14.603,62.433,"stwmbf_185",["throwType"]="RUN",["flyDuration"]=3.27},{"Construction","Bridge","grenade","weapon_smokegrenade",-1559.999,-361.285,32.422,-43.693,21.193,"stwmbf_170",["throwType"]="NORMAL",["flyDuration"]=2.96},{"Short","Truck (In)","grenade","weapon_smokegrenade",-2351.589,-790.031,388.758,-37.653,79.287,"stwmbf_178",["throwType"]="NORMAL",["flyDuration"]=5.19},{"Short","Truck (Out)","grenade","weapon_smokegrenade",-2351.969,-790.031,388.807,-37.736,81.105,"stwmbf_179",["throwType"]="NORMAL",["flyDuration"]=6.8},{"Tracks","Toxic / Pillar","grenade","weapon_smokegrenade",-613.014,-1082.017,42.16,-29.337,99.341,"stwmbf_181",["throwType"]="NORMAL",["flyDuration"]=4.17},{"Tracks","B Default","grenade","weapon_smokegrenade",-525.982,-1551.984,144.094,-43.808,110.431,"stwmbf_182",["throwType"]="NORMAL",["flyDuration"]=5.59},{"Construction","Bridge","grenade","weapon_smokegrenade",-1567.969,-632.289,7.325,-39.254,57.024,"stwmbf_186",["throwType"]="NORMAL",["flyDuration"]=4.58},{"Short","Truck","grenade","weapon_smokegrenade",-2351.969,-815.969,391.09,-34.684,81.5,"stwmbf_323",["throwType"]="NORMAL",["flyDuration"]=4.36},{"Water","Walkway (Right)","grenade","weapon_smokegrenade",-1421.973,-1087.969,0.281,-28.76,107.193,"stwmbf_325",["throwType"]="NORMAL",["flyDuration"]=3.76},{"Water","Walkway (Left)","grenade","weapon_smokegrenade",-1259.999,-1079.979,0.094,-32.011,110.08,"stwmbf_326",["throwType"]="NORMAL",["flyDuration"]=4.16},{"Cafe","GSG","grenade","weapon_smokegrenade",-3320.361,-358.998,536.094,-18.135,62.146,"stwmbf_169",["throwType"]="NORMAL",["flyDuration"]=4.38},{"Short","Back A","grenade","weapon_smokegrenade",-2351.969,-414.031,388.562,-60.588,73.826,"stwmbf_175",["throwType"]="NORMAL",["flyDuration"]=6.82},{"Short","Bank","grenade","weapon_smokegrenade",-2162.0,-519.969,391.46,-29.75,100.836,"stwmbf_176",["throwType"]="NORMAL",["flyDuration"]=4.59},{"Construction","Heaven","grenade","weapon_smokegrenade",-1559.969,-728.786,52.574,-33.446,96.294,"stwmbf_189",["throwType"]="NORMAL",["flyDuration"]=3.96},{"Construction","Pillar","grenade","weapon_smokegrenade",-1645.987,-1087.982,96.094,-20.016,55.836,"stwmbf_317",["throwType"]="NORMAL",["flyDuration"]=3.16},{"Squeaky","Heaven","grenade","weapon_smokegrenade",-1751.969,-671.969,128.344,-21.813,87.23,"stwmbf_180",["throwType"]="NORMAL",["flyDuration"]=3.36},{"Bank","Long","grenade","weapon_flashbang",-2604.024,1102.215,480.094,-24.09,70.938,"stwmbf_161",["throwType"]="NORMAL"},{"Connector","Lower Tunnel","grenade","weapon_flashbang",-2012.911,-1231.996,240.094,-28.842,44.555,"stwmbf_459",["throwType"]="NORMAL",["throwStrength"]=0},{"Construction","Bridge","grenade","weapon_flashbang",-1559.997,-361.27,32.427,-43.643,21.174,"stwmbf_162",["throwType"]="NORMAL"},{"Safe","B Default","grenade","weapon_molotov",-1399.969,-139.999,0.094,-15.444,63.084,"stwmbf_163",["throwType"]="NORMAL",["flyDuration"]=1.5},{"Walkway","Pipe","grenade","weapon_molotov",-2022.996,-48.031,139.761,-12.59,-44.596,"stwmbf_167",["throwType"]="NORMAL",["flyDuration"]=2.07},{"Walkway","B Default","grenade","weapon_molotov",-1894.376,263.177,160.094,-22.407,-21.446,"stwmbf_166",["throwType"]="NORMAL",["flyDuration"]=2.07},{"Alley","Construction","grenade","weapon_molotov",-759.57,-1903.185,198.719,-13.915,112.224,"stwmbf_164",["throwType"]="NORMAL",["flyDuration"]=2.07},{"Cafe","Truck","grenade","weapon_molotov",-3495.777,-346.775,524.711,-15.127,34.216,"stwmbf_165",["throwType"]="RUN",["runDuration"]=6,["flyDuration"]=2.12},{"Construction","Toxic","grenade","weapon_molotov",-1580.023,-480.768,136.094,-20.148,53.764,"stwmbf_168",["throwType"]="NORMAL",["flyDuration"]=2.07},{"Cafe","Bombsite A","grenade","weapon_molotov",-3328.007,-358.999,536.094,-13.036,50.826,"stwmbf_370",["throwType"]="NORMAL",["flyDuration"]=1.95},{"Construction","Pit Ramp","grenade","weapon_molotov",-1731.969,-702.001,96.094,-18.035,57.402,"stwmbf_240",["throwType"]="NORMAL",["flyDuration"]=2.07},{"CT Spawn","Water","grenade","weapon_smokegrenade",-2041.28,902.592,480.094,-30.085,-65.09,"custom_44",["tickrate"]=64,["throwType"]="NORMAL"},{"Canal","Barrels","grenade","weapon_smokegrenade",-201.185,-919.1,30.607,-31.845,117.134,"custom_45",["tickrate"]=64,["throwType"]="NORMAL"},{"Upper Park","Car","grenade","weapon_smokegrenade",-3288.63,-358.969,536.094,-21.68,61.475,"custom_46",["tickrate"]=64,["throwType"]="NORMAL"},{"Upper Park","Container","grenade","weapon_smokegrenade",-3288.63,-358.969,536.094,-17.83,59.77,"custom_47",["tickrate"]=64,["throwType"]="NORMAL"},{"Boiler","Bank","grenade","weapon_molotov",-2503.969,1199.999,356.021,-63.162,-89.636,"custom_171",["throwType"]="NORMAL",["landX"]=-1923.2,["landY"]=-173.357,["landZ"]=-163.734,["flyDuration"]=11.297},{"Under A","Heaven","grenade","weapon_molotov",-2046.386,539.158,104.031,-17.424,-0.525,"custom_172",["throwType"]="NORMAL",["landX"]=-1454.981,["landY"]=183.339,["landZ"]=-165.969,["flyDuration"]=7.609},{"Construction","Heaven","grenade","weapon_molotov",-1559.969,-728.769,52.046,1.661,98.259,"custom_173",["throwType"]="JUMP",["landX"]=-676.87,["landY"]=-1590.253,["landZ"]=-165.969,["flyDuration"]=8.016},{"Alley","Construction","grenade","weapon_flashbang",-613.292,-1473.611,192.281,-26.741,137.213,"custom_202",["throwType"]="NORMAL"},{"Construction","Heaven","grenade","weapon_smokegrenade",-856.031,-639.969,96.031,-23.716,125.051,"custom_204",["tickrate"]=64,["throwType"]="RUN",["runDuration"]=4},{"CT","Default","grenade","weapon_hegrenade",-1744.031,1307.969,355.44,-18.029,-124.942,"custom_208",["throwType"]="RUN",["runDuration"]=10},{"CT","Default","grenade","weapon_molotov",-1744.031,1307.969,355.44,-18.029,-124.942,"custom_209",["throwType"]="RUN",["runDuration"]=10,["landX"]=-930.693,["landY"]=-2390.316,["landZ"]=-165.998,["flyDuration"]=2.531},{"Bank","Default","grenade","weapon_molotov",-2604.012,1102.234,480.031,-57.801,-84.768,"custom_210",["throwType"]="JUMP",["landX"]=-680.134,["landY"]=-1165.49,["landZ"]=-165.969,["flyDuration"]=3.828},{"T Spawn","Restroom","grenade","weapon_smokegrenade",-687.969,-2192.032,200.129,-40.441,149.628,"custom_214",["tickrate"]=64,["throwType"]="JUMP"},{"T Spawn","Lower Park","grenade","weapon_smokegrenade",-16.031,-2095.969,185.755,-29.487,148.727,"custom_215",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=15},{"Canal","Barrel","grenade","weapon_molotov",-448.709,-1488.187,144.031,-17.709,100.966,"custom_335",["throwType"]="RUN",["runDuration"]=15,["flyDuration"]=2.063,["landX"]=-817.42,["landY"]=384.971,["landZ"]=96.031},{"Long","Stairs","grenade","weapon_molotov",-3533.392,-63.37,514.894,-14.985,32.568,"custom_336",["throwType"]="RUN",["flyDuration"]=2.008,["landX"]=-1985.128,["landY"]=925.576,["landZ"]=482.031},{"Pipe","Water","grenade","weapon_molotov",-1200.031,-1019.987,0.031,-24.208,93.897,"custom_337",["throwType"]="NORMAL",["flyDuration"]=2.047,["landX"]=-1296.513,["landY"]=174.88,["landZ"]=21.046},{"Pipe","Heaven","grenade","weapon_molotov",-1200.031,-1019.987,0.031,-28.437,107.854,"custom_338",["throwType"]="RUN",["flyDuration"]=1.93,["landX"]=-1794.907,["landY"]=613.264,["landZ"]=258.031},{"Heaven","Construction","grenade","weapon_hegrenade",-1796.272,576.691,256.031,-1.731,-60.291,"custom_339",["throwType"]="RUN",["flyDuration"]=1.648,["landX"]=-1047.671,["landY"]=-576.04,["landZ"]=181.391},{"Water","Connector Door","grenade","weapon_molotov",-1429.622,412.28,20.395,-26.138,-102.691,"custom_340",["throwType"]="NORMAL",["flyDuration"]=2.039,["landX"]=-1684.501,["landY"]=-719.599,["landZ"]=96.031},{"Pillar","Water","grenade","weapon_molotov",-807.1,78.688,91.585,-12.601,124.973,"custom_341",["throwType"]="RUN",["flyDuration"]=2.047,["landX"]=-1371.057,["landY"]=55.047,["landZ"]=17.327},{"Canal","B Bombsite","grenade","weapon_hegrenade",-604.659,-1167.906,75.988,-20.69,110.1,"custom_342",["throwType"]="RUN",["runDuration"]=7,["flyDuration"]=1.648,["landX"]=-975.854,["landY"]=-161.942,["landZ"]=260.961},{"Back of A","Toilets","grenade","weapon_molotov",-1746.37,1224.147,353.089,-23.3,-125.453,"custom_343",["throwType"]="RUN",["runDuration"]=4,["flyDuration"]=2.055,["landX"]=-2696.75,["landY"]=-110.544,["landZ"]=432.031},{"Playground","A Long Tree","grenade","weapon_molotov",-2808.078,-2677.066,477.373,-24.605,130.138,"custom_344",["throwType"]="RUN",["flyDuration"]=2.055,["landX"]=-3924.67,["landY"]=-1355.796,["landZ"]=514.026},{"Playground","A Long Stone","grenade","weapon_molotov",-3099.28,-2346.147,474.031,-44.699,123.525,"custom_345",["throwType"]="RUNJUMP",["flyDuration"]=1.734,["landX"]=-3523.353,["landY"]=-1688.193,["landZ"]=513.092},{"Under A","Pipe","grenade","weapon_molotov",-1967.969,74.32,128.031,-15.098,-53.567,"custom_346",["throwType"]="NORMAL",["flyDuration"]=2.906,["landX"]=-1150.343,["landY"]=-636.341,["landZ"]=-165.969},{"Lower Park","Tunnels","grenade","weapon_molotov",-2805.173,-1044.967,440.373,-22.562,-49.934,"custom_347",["throwType"]="RUN",["runDuration"]=2,["flyDuration"]=2.047,["landX"]=-1796.432,["landY"]=-2253.301,["landZ"]=419.759},{"Tunnels","Walkway","grenade","weapon_molotov",-285.297,-952.938,15.924,-28.607,152.046,"custom_348",["throwType"]="RUN",["flyDuration"]=2.047,["landX"]=-1870.214,["landY"]=-156.499,["landZ"]=128.031},{"Bombsite","Tunnels","grenade","weapon_molotov",-1263.172,473.709,37.804,-1.306,-41.108,"custom_349",["throwType"]="RUN",["runDuration"]=15,["flyDuration"]=2.047,["landX"]=-565.386,["landY"]=-245.808,["landZ"]=2.897},{"Short","Car","grenade","weapon_molotov",-2315.485,-134.919,397.732,-63.004,65.741,"custom_350",["throwType"]="RUNJUMP",["runDuration"]=11,["flyDuration"]=2.055,["landX"]=-2014.111,["landY"]=598.872,["landZ"]=472.25},{"Lower Park","Tunnels","grenade","weapon_molotov",-2212.129,-167.772,385.744,1.638,-79.287,"custom_449",["throwType"]="RUNJUMP",["runDuration"]=33,["landX"]=-1817.239,["landY"]=-2239.532,["landZ"]=428.109},{"Lower Park","Playground","grenade","weapon_molotov",-2276.354,-405.83,384.281,-1.75,-86.99,"custom_450",["throwType"]="RUNJUMP",["runDuration"]=32,["landX"]=-2164.294,["landY"]=-2484.746,["landZ"]=471.156},{"Barrels","Barrels","grenade","weapon_molotov",-1581.802,-763.506,136.031,-9.57,59.84,"custom_480",["throwType"]="RUN",["runDuration"]=6,["landX"]=-819.252,["landY"]=471.144,["landZ"]=98.031},{"Water","Barrels","grenade","weapon_molotov",-1567.969,-1087.969,0.031,-26.797,65.401,"custom_481",["throwType"]="RUN",["runDuration"]=15,["landX"]=-847.225,["landY"]=486.358,["landZ"]=96.031},{"Connector","Water (Popflash)","grenade","weapon_flashbang",-1839.969,-1071.986,96.031,-46.585,179.674,"custom_487",["throwType"]="NORMAL",["duck"]=true,["landX"]=-1779.776,["landY"]=-987.69,["landZ"]=171.757},{"Walkway","Lower Park","grenade","weapon_smokegrenade",-1637.933,-309.122,128.031,-64.67,-157.893,"custom_791",["throwType"]="JUMP",["landX"]=-2250.198,["landY"]=-508.739,["landZ"]=386.281},{"CT Spawn","Tunnels","grenade","weapon_smokegrenade",-2445.898,260.753,492.031,-2.96,-74.786,"custom_792",["throwType"]="RUNJUMP",["runDuration"]=28,["runSpeed"]=false,["landX"]=-1656.304,["landY"]=-2362.854,["landZ"]=338.031},{"Connector","Pipes","movement","weapon_knife",-1690.031,-1157.375,136.246,23.111,-64.443,"custom_793",["data"]={{0, 0, "R"}, {0, 0, "F"}, 47, {0, 0, "J"}, 3, {0, 0, "D"}, 4, {0, 0, "", "J"}, 10, {0, 0, "", "R"}, 7, {0, 0, "L"}, 10, {0, 0, "", "D"}, 7, {0, 0, "", "L"}, 1, {0, 0, "L"}, 1, {0, 0, "J"}, 1, {0, 0, "D"}, 2, {0, 0, "", "J"}, {0, 0, "", "L"}, 1, {0.605}, {0.726, -0.453758}, {0.968, -0.635262}, {2.178, -2.178016}, {3.388, -4.628243, "L"}, {4.114, -6.806251}, {4.84, -8.258248}, {5.687, -11.252991, "", "F"}, {3.751, -9.528739}, {3.388, -10.345482}}},{"Bench","Boost","movement","weapon_knife",-3536.031,-645.094,534.72,39.028,89.476,"custom_888",["data"]={12, {0.0, 0.0, "F"}, 4, {0.132, 0.131996}, {0.044, 0.352005}, {0.264, 0.572006}, {0.484, 0.484001}, {0.528, 0.395996}, {0.616, 0.219994}, {0.616, 0.175995}, {0.484, -0.087997}, {0.264, -0.043999}, {0.44, -0.087997}, {0.264, -0.043999}, {0.22, -0.087997}, {0.264, -0.087997}, {0.176, -0.219994}, {0.0, -0.087997}, 1, {0.0, -0.043999}, {-0.044, -0.131996}, {-0.264, -0.087997}, {-1.672, -0.572006}, {-1.848, -0.263992}, {-1.628}, {-3.168, 0.351997, "J"}, {-4.136, 0.792007, "L", "J"}, {-2.068, 0.880005}, {-1.892, 1.188004}, {-2.156, 2.112007, "", "F"}, {-2.42, 3.475998}, {-1.408, 3.343994}, {-0.528, 1.980011}, {-0.132, 2.815994}, {0.088, 1.232002}, {0.176, 0.748001}, {0.176, 0.968002}, {0.44, 1.363991}, {0.528, 0.70401}, {0.528, 0.263992, "R", "", 0.0, 0.0}, {0.704, -0.176003, "", "L"}, {0.924, -0.836006}, {0.836, -1.408005}, {0.792, -1.804008}, {0.572, -2.331993}, {0.352, -2.551994, "D"}, {0.176, -1.715996}, {0.044, -1.584007}, {0.044, -1.319992}, {0.0, -1.056}, {0.088, -0.528}, {0.132, -0.440002}, {0.044, -0.70401}, {0.0, -1.012001}, {0.0, -0.879997}, {0.0, -1.407997}, {0.0, -0.351997}, {-0.132, -0.660004}, {-0.044, -1.320007}, {0.0, -2.155998}, {-0.132, -1.848, "F"}, {-0.22, -0.439995}, {-0.264}, {-0.484, -0.395996}, {-0.704, -0.484009}, {-1.32, -0.70401}, {-2.42, -2.639992}, {-1.496, -1.232002}, {-1.628, -0.924004}, {-1.188, -0.836006}, {-1.32, -0.836006}, {-1.54, -1.012001}, {-1.848, -1.099998}, {-2.068, -1.187996}, {-1.892, -1.187996}, {-0.924, -1.584007}, {-0.352, -1.363998}, 6, {0.044, -0.528008}, {0.0, -1.143997}, {0.0, -1.716011, "", "D"}, {-0.088, -1.363998}, {-0.176, -0.615997}, {0.0, -0.175995}, {0.0, 0.0, "", "F"}, {0.0, -0.175995}, {0.0, -0.131996, "S"}, {0.0, -0.263992}, {0.0, -0.703999}, {0.044, -0.836002}, {0.0, -0.528, "F"}, {0.0, -0.880001}, {0.0, -1.099998}, {-0.088, -0.483997}, {-0.088, -0.615997}, {-0.088, -0.352005}, {-0.132, -0.484001}, {-0.176, -0.352001}, {-0.176, -0.087997}, {-0.352, 0.0, "", "F"}, {-0.176, 0.0, "", "R"}, {-0.308, 0.175995}, {-0.044, 0.087997}, {0.0, 0.043999}, 21}}} end
		if map == "de_mirage" then locations_data={{"CT Spawn","T Ramp","grenade","weapon_smokegrenade",-2026.398,-2029.969,-299.06,-15.312,12.574,"stwmbf_238",["tickrate"]=64,["throwType"]="JUMP",["flyDuration"]=5.641,["landX"]=274.736,["landY"]=-1516.729,["landZ"]=-173.969},{"A Alley","CT","grenade","weapon_smokegrenade",936.04,-1032.01,-257.947,-12.78,-143.92,"custom_24",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-951.621,["landY"]=-2407.507,["landZ"]=-165.969,["flyDuration"]=5.375},{"T Roof","Middle of Boxes in A","grenade","weapon_smokegrenade",875.969,-1209.69,-108.906,-21.651,-149.336,"custom_25",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-433.518,["landY"]=-2053.842,["landZ"]=-177.969,["flyDuration"]=4.75},{"T Roof","Stairs","grenade","weapon_smokegrenade",1148.4,-1183.96,-205.57,-43.184,-165.255,"custom_26",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-456.206,["landY"]=-1606.266,["landZ"]=-37.969,["flyDuration"]=5.172},{"T Roof","Jungle","grenade","weapon_smokegrenade",815.969,-1457.4,-108.906,-26.919,-174.367,"custom_27",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-667.822,["landY"]=-1629.432,["landZ"]=-169.969,["flyDuration"]=5.781},{"Window","Window (Oneway)","grenade","weapon_smokegrenade",-1209.08,-873.271,-167.906,-48.214,66.405,"custom_28",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-1086.703,["landY"]=-593.106,["landZ"]=-136.969,["flyDuration"]=2.531},{"Alley","B Bombsite","grenade","weapon_smokegrenade",-292.957,651.055,-79.906,-38.383,-168.915,"custom_29",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-2076.502,["landY"]=301.621,["landZ"]=-157.969,["flyDuration"]=7.203},{"Back of Top Mid","Short","grenade","weapon_smokegrenade",399.969,-17.062,-199.764,-47.085,-174.254,"custom_30",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-815.545,["landY"]=-156.615,["landZ"]=-168.744,["flyDuration"]=6.766},{"T Spawn","Connector","grenade","weapon_smokegrenade",1135.97,647.976,-261.329,-28.566,-140.282,"custom_31",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-690.807,["landY"]=-941.322,["landZ"]=-221.969,["flyDuration"]=6.156},{"Alley","B Short","grenade","weapon_smokegrenade",-160.031,887.976,-135.266,-44.558,-134.517,"custom_32",["tickrate"]=64,["throwType"]="NORMAL",["visY"]=-15,["landX"]=-1166.617,["landY"]=206.283,["landZ"]=-169.852,["flyDuration"]=6.594},{"Alley","Kitchen Window","grenade","weapon_smokegrenade",-784.014,623.969,-75.969,-60.945,-151.417,"custom_33",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-1821.149,["landY"]=31.854,["landZ"]=-165.969,["flyDuration"]=5.578},{"Alley","Bench","grenade","weapon_smokegrenade",-539.649,520.031,-81.257,-41.707,-178.889,"custom_34",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-2327.198,["landY"]=485.363,["landZ"]=-165.969,["flyDuration"]=5.547},{"Short","Palace","grenade","weapon_smokegrenade",-903.969,-376.031,-158.426,-17.026,-60.066,"custom_35",["tickrate"]=64,["throwType"]="JUMP",["landX"]=66.3,["landY"]=-2212.795,["landZ"]=-37.969,["flyDuration"]=4.766},{"Back of Top Mid","Connector","grenade","weapon_smokegrenade",398.969,174.526,-248.867,-47.134,-136.79,"custom_36",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-712.629,["landY"]=-909.794,["landZ"]=-237.969,["flyDuration"]=5.172},{"Palace","Balcony","grenade","weapon_flashbang",367.969,-2207.2,-39.906,-9.949,-131.947,"custom_37",["throwType"]="NORMAL"},{"Sandwich","Jungle-Connector","grenade","weapon_smokegrenade",-261.389,-1546.36,-167.906,-41.182,-7.275,"custom_38",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-597.995,["landY"]=-1516.152,["landZ"]=-165.969,["flyDuration"]=4.375},{"B Aps","Kitchen Window","grenade","weapon_hegrenade",-1952.03,691.415,-47.906,14.496,-87.4,"custom_39",["throwType"]="JUMP"},{"B Balcony","Kitchen Window","grenade","weapon_molotov",-1952.03,651.29,-27.906,20.95,-87.132,"custom_40",["throwType"]="JUMP"},{"Under Balcony","Palace","grenade","weapon_molotov",150.969,-2071.969,-167.969,-32.786,101.522,"custom_41",["throwType"]="RUN",["runDuration"]=4},{"T Roof","Sandwich","grenade","weapon_molotov",831.956,-1255.19,-108.969,-19.857,-165.016,"custom_42",["throwType"]="NORMAL"},{"Window","Underpass","grenade","weapon_molotov",-1183.97,-456.031,-167.906,6.761,-69.763,"custom_43",["throwType"]="NORMAL"},{"Middle","Window","grenade","weapon_smokegrenade",360.08,-691.97,-162.5,-32.53,177.9,"custom_54",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-1179.264,["landY"]=-629.459,["landZ"]=-165.969,["flyDuration"]=5.391},{"CT Spawn","Middle","grenade","weapon_flashbang",-1712.0,-1128.031,-187.969,-35.025,34.838,"custom_55",["tickrate"]=64,["throwType"]="NORMAL"},{"Alley","B Default","grenade","weapon_smokegrenade",-148.03,353.03,-34.43,-47.48,178.95,"custom_56",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-2024.743,["landY"]=394.362,["landZ"]=-157.969,["flyDuration"]=8.438},{"Alley","Market Window","grenade","weapon_smokegrenade",-160.03,887.97,-135.33,-50.38,-146.49,"custom_57",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1918.775,["landY"]=-259.244,["landZ"]=-161.969,["flyDuration"]=7.172},{"Alley","Market Door","grenade","weapon_smokegrenade",-160.03,887.97,-135.33,-45.01,-152.88,"custom_58",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-2263.731,["landY"]=-191.177,["landZ"]=-166.045,["flyDuration"]=7.781},{"Connector","Underpass","grenade","weapon_smokegrenade",-807.97,-1235.97,-167.97,6.94,48.2,"custom_59",["tickrate"]=64,["throwType"]="RUN",["runDuration"]=4,["landX"]=-890.687,["landY"]=-591.716,["landZ"]=-261.969,["flyDuration"]=2.5},{"Palace","Under Balcony","grenade","weapon_molotov",16.03,-2359.99,-39.97,9.71,73.4,"custom_60",["throwType"]="NORMAL"},{"Under Balcony","A Ramp","grenade","weapon_flashbang",150.969,-1914.031,-167.969,-5.51,-165.246,"custom_61",["throwType"]="NORMAL"},{"Under Balcony","A Ramp","grenade","weapon_flashbang",-44.65,-1922.03,-167.97,-13.1,104.1,"custom_62",["throwType"]="NORMAL"},{"Short","Middle","grenade","weapon_flashbang",-752.03,-52.43,-161.88,-52.99,-84.4,"custom_63",["throwType"]="JUMP"},{"Car","B Apartments","grenade","weapon_flashbang",-2114.03,706.46,-134.96,-1.55,173,"custom_64",["throwType"]="NORMAL"},{"B Apartments","Car","grenade","weapon_flashbang",-1165.97,568.98,-79.97,-3.57,-80.9,"custom_65",["throwType"]="RUN"},{"A Stairs","A Ramp","grenade","weapon_smokegrenade",-552.37,-1309.03,-163.97,-77.32,-17.64,"custom_66",["tickrate"]=64,["throwType"]="JUMP"},{"Middle","Short","grenade","weapon_smokegrenade",360.06,-691.98,-162.49,-23.5,162.36,"custom_67",["tickrate"]=64,["throwType"]="NORMAL"},{"T Roof","Short","grenade","weapon_smokegrenade",1148.4,-1183.96,-205.57,-32.25,153.79,"custom_68",["tickrate"]=64,["throwType"]="JUMP"},{"Alley","Balcony","grenade","weapon_smokegrenade",-595.42,520.07,-83.03,-50.2,171.48,"custom_69",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=229.511,["landY"]=-1557.638,["landZ"]=-173.969,["flyDuration"]=8.406},{"B Bombsite","Kitchen (Oneway)","grenade","weapon_smokegrenade",-1872.54,-247.97,-163.907,15.7,-141.92,"custom_70",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-805.415,["landY"]=-243.318,["landZ"]=-165.638,["flyDuration"]=3.75},{"Triple Boxes","Stairs","grenade","weapon_smokegrenade",-253.97,-2134.08,-172.887,-77.17,113.32,"custom_71",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-847.583,["landY"]=-124.012,["landZ"]=-167.475,["flyDuration"]=8.016},{"Jungle","A Ramp","grenade","weapon_smokegrenade",-1119.97,-1527.04,-156.017,-12.79,-0.66,"custom_72",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-2007.097,["landY"]=731.548,["landZ"]=-45.969,["flyDuration"]=8.625},{"A Alley","A Bombsite (Popflash)","grenade","weapon_flashbang",743.97,-1719.28,-249.58,-5.38,176.14,"custom_76",["throwType"]="NORMAL"},{"CT","A Ramp","grenade","weapon_smokegrenade",-1710.97,-1489.33,-257.91,-56.86,-1.2,"custom_79",["tickrate"]=64,["throwType"]="JUMP"},{"CT Spawn","B Bombsite","grenade","weapon_smokegrenade",-2026.36,-2029.97,-299.067,-29.43,86.93,"custom_80",["tickrate"]=64,["throwType"]="JUMP"},{"CT","B Default","grenade","weapon_smokegrenade",-2031.97,-1957.02,-300.43,-37.83,88.81,"custom_82",["tickrate"]=64,["throwType"]="JUMP",["landX"]=178.873,["landY"]=-1528.923,["landZ"]=-173.969,["flyDuration"]=7.797},{"Middle","Tetris","grenade","weapon_smokegrenade",-1071.97,-380.03,-263.97,-28.04,-50.06,"custom_83",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1898.244,["landY"]=338.203,["landZ"]=-157.969,["flyDuration"]=8.844},{"Tetris","Stairs","grenade","weapon_smokegrenade",-91.09,-1418.03,-115.97,-31.76,-62.54,"custom_84",["tickrate"]=64,["throwType"]="JUMP"},{"Ticket booth","Default","wallbang","weapon_wallbang_light",-902.03,-2603.08,-167.97,1.6,35.79,"custom_85",["landX"]=-1981.922,["landY"]=451.957,["landZ"]=-157.995,["flyDuration"]=7},{"Under Balcony","Tetris","wallbang","weapon_wallbang_light",87.97,-2092.85,-167.97,-6.69,108.96,"custom_86",["landX"]=-236.302,["landY"]=-1544.135,["landZ"]=-52.48,["flyDuration"]=6.625},{"CT","Palace","wallbang","weapon_wallbang",-1711.98,-823.84,-165.97,-3.26,-38.27,"custom_87",["landX"]=-472.428,["landY"]=-1529.492,["landZ"]=-37.969,["flyDuration"]=5.563},{"Apartments","Car","wallbang","weapon_wallbang_light",-1038.01,390.03,-79.97,0.55,169,"custom_88"},{"Middle","Window","wallbang","weapon_wallbang",362.05,-642.2,-165.07,0.83,-178.09,"custom_89"},{"B Apartments","Banger","wallbang","weapon_wallbang_light",-1025.03,486.49,-79.97,6.7,-169.55,"custom_90"},{"A Stairs","A Bombsite","grenade","weapon_flashbang",-496.03,-1309.03,-159.97,-60.07,-77.06,"custom_91",["throwType"]="NORMAL"},{"T Spawn","Short","grenade","weapon_smokegrenade",1135.99,647.97,-261.39,-43.86,-156.65,"custom_92",["tickrate"]=64,["throwType"]="JUMP"},{"T Spawn","Window","grenade","weapon_smokegrenade",1422.99,34.83,-167.97,-26.16,-166.36,"custom_93",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=71,["duck"]=true,["visX"]=-44},{"T Spawn","B Arch","grenade","weapon_smokegrenade",496.03,679.97,-135.97,-45.7,-165.33,"custom_94",["tickrate"]=64,["throwType"]="JUMP"},{"CT Spawn","Alley","grenade","weapon_smokegrenade",-1710.97,-1208.03,-255.08,-48.81,67.43,"custom_95",["tickrate"]=64,["throwType"]="JUMP",["viewAnglesDistanceMax"]=0.1,["landX"]=-853.249,["landY"]=-164.965,["landZ"]=-167.006,["flyDuration"]=10.266},{"A Alley","Jungle","grenade","weapon_smokegrenade",1239.97,-1159.97,-246.27,-48.66,-173.19,"custom_96",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1141.718,["landY"]=-645.893,["landZ"]=-165.969,["flyDuration"]=6.578},{"A Alley","Window","grenade","weapon_smokegrenade",1127.98,-1208,-108.97,-26.37,166.51,"custom_97",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1455.216,["landY"]=169.163,["landZ"]=-165.969,["flyDuration"]=8.422},{"T Spawn","B Bombsite","grenade","weapon_smokegrenade",1398.97,-1255.97,-167.97,-32.29,159.6,"custom_98",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=15,["landX"]=-935.23,["landY"]=598.704,["landZ"]=-80.228,["flyDuration"]=10.219},{"T Spawn","B Default","grenade","weapon_smokegrenade",1398.97,-1255.97,-167.97,-41.43,155.2,"custom_99",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=24,["landX"]=-942.47,["landY"]=-1420.576,["landZ"]=-165.969,["flyDuration"]=7.594},{"CT Spawn","Palace","grenade","weapon_smokegrenade",-1711.97,-761.03,-167.97,-32.66,-38.86,"custom_100",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1174.149,["landY"]=-613.599,["landZ"]=-165.969,["flyDuration"]=6.766},{"T Spawn","Balcony","grenade","weapon_smokegrenade",1422.99,-248.01,-167.97,-46.5,162.48,"custom_101",["tickrate"]=64,["throwType"]="RUNJUMP",["viewAnglesDistanceMax"]=0.2,["runDuration"]=40,["landX"]=-2116.226,["landY"]=70.465,["landZ"]=-157.969,["flyDuration"]=8.391},{"T Spawn","B Arch","grenade","weapon_smokegrenade",494.66,583.6,-124,-53.8,-176.55,"custom_102",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-2112.748,["landY"]=373.097,["landZ"]=-157.969,["flyDuration"]=7.469},{"Window","Window (Oneway)","grenade","weapon_smokegrenade",-1120.03,-456,-167.97,54.42,-81.43,"custom_103",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=57.313,["landY"]=-2271.474,["landZ"]=-37.969,["flyDuration"]=6.797},{"Window","Window (Oneway)","grenade","weapon_smokegrenade",-1120.01,-796,-167.97,8.23,85.8,"custom_104",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-1997.681,["landY"]=787.134,["landZ"]=-45.969,["flyDuration"]=12.281},{"A Bombsite","A Ramp","grenade","weapon_smokegrenade",-554.969,-2103.693,-179.969,-10.479,48.569,"custom_105",["tickrate"]=64,["throwType"]="NORMAL"},{"Trash Bin","B Apartments","grenade","weapon_smokegrenade",-2416,-115.76,-157.97,-28.17,44.12,"custom_106",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-1090.279,["landY"]=-653.478,["landZ"]=-135.969,["flyDuration"]=1.688},{"Trash Bin","B Apartments","grenade","weapon_molotov",-2416,-115.76,-157.97,-28.17,44.12,"custom_107",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-1092.693,["landY"]=-660.063,["landZ"]=-135.969,["flyDuration"]=1.484},{"Triple Boxes","Tetris","grenade","weapon_molotov",-365,-2173.03,-176.19,-26,44.66,"custom_108",["throwType"]="NORMAL",["landX"]=191.444,["landY"]=-1545.437,["landZ"]=-173.969,["flyDuration"]=2.906},{"Tetris","Triple Boxes","grenade","weapon_molotov",-31.92,-1418.02,-167.97,-19.77,-138.12,"custom_109",["throwType"]="NORMAL",["landX"]=-1427.987,["landY"]=713.584,["landZ"]=-61.969,["flyDuration"]=4.125},{"Cart","Connector","grenade","weapon_flashbang",343.3,-621.62,-163.43,-14.39,-171.28,"custom_110",["throwType"]="NORMAL"},{"B Apartments","Short","grenade","weapon_smokegrenade",-1367.97,815.99,-79.97,-3.81,-160.38,"custom_111",["tickrate"]=64,["throwType"]="NORMAL"},{"Short","B Bombsite","grenade","weapon_flashbang",-944.56,-119.97,-167.97,-30.25,26.39,"custom_112",["throwType"]="NORMAL"},{"Window","Middle","grenade","weapon_flashbang",-1120,-854.38,-167.97,-42.45,135.65,"custom_113",["throwType"]="NORMAL"},{"A Stairs","Connector","grenade","weapon_flashbang",-496.03,-1309.03,-159.97,-65.18,-10.26,"custom_114",["throwType"]="NORMAL",["landX"]=-1568.205,["landY"]=534.531,["landZ"]=-166.018,["flyDuration"]=3.125},{"A Stairs","A Bombsite","grenade","weapon_flashbang",-496,-1392.27,-114.94,-47.82,93.07,"custom_115",["throwType"]="NORMAL"},{"T Spawn","CT","grenade","weapon_smokegrenade",1257.795,-871.969,-143.969,-21.82,-144.34,"custom_116",["tickrate"]=64,["throwType"]="JUMP"},{"T Roof","Under Balcony","grenade","weapon_smokegrenade",814.969,-1549.009,-108.969,-27.97,163.55,"custom_117",["tickrate"]=64,["throwType"]="NORMAL"},{"T Ramp","T Ramp (Oneway)","grenade","weapon_smokegrenade",457.97,-1712,-240.95,-10.48,133.14,"custom_118",["tickrate"]=64,["throwType"]="NORMAL"},{"Tetris","CT","grenade","weapon_smokegrenade",-91.09,-1418.01,-115.97,-28.22,-114.38,"custom_119",["tickrate"]=64,["throwType"]="NORMAL"},{"T Spawn","Cat","grenade","weapon_smokegrenade",1422.98,70.97,-112.9,-32.65,-163.53,"custom_120",["tickrate"]=64,["throwType"]="NORMAL",["visX"]=-47,["visZ"]=0,["landX"]=-857.508,["landY"]=-2389.727,["landZ"]=-169.969,["flyDuration"]=6.359},{"B Bombsite","Alley","grenade","weapon_smokegrenade",-1862.97,176.02,-159.97,-42.82,21.95,"custom_121",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-73.523,["landY"]=-1875.723,["landZ"]=-165.969,["flyDuration"]=5.344},{"B Bombsite","Palace","grenade","weapon_smokegrenade",-1863.97,335.97,-159.97,-31.19,-51.15,"custom_122",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=15},{"B Bombsite","Kitchen (Oneway)","grenade","weapon_smokegrenade",-1435.97,283.97,-167.97,-6.47,-131.31,"custom_123",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-950.843,["landY"]=-2379.278,["landZ"]=-165.979,["flyDuration"]=5.156},{"Palace","Balcony","grenade","weapon_smokegrenade",32.01,-2375.96,-39.97,4.91,59.56,"custom_127",["tickrate"]=64,["throwType"]="NORMAL",["accurateMove"]=false,["landX"]=-1997.32,["landY"]=-333.796,["landZ"]=-128.89,["flyDuration"]=1.703},{"Jungle","A Ramp","grenade","weapon_smokegrenade",-879.97,-1306.03,-167.97,-72.48,-11.12,"custom_129",["tickrate"]=64,["throwType"]="JUMP"},{"Middle","Window","grenade","weapon_flashbang",160.031,39.981,-206.579,-31.153,-31.537,"custom_130",["tickrate"]=64,["throwType"]="NORMAL"},{"Palace","Jungle","grenade","weapon_smokegrenade",223.969,-2375.969,-39.969,-2.256,137.987,"custom_131",["tickrate"]=64,["throwType"]="RUN",["runDuration"]=4,["landX"]=-32.86,["landY"]=-2011.826,["landZ"]=-41.969,["flyDuration"]=1.938},{"Palace","CT","grenade","weapon_smokegrenade",141.235,-2375.969,-39.969,9.36,120.653,"custom_132",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=38},{"Alley","Short","grenade","weapon_smokegrenade",-160.031,887.969,-135.328,-69.602,-120.605,"custom_133",["tickrate"]=64,["throwType"]="JUMP",["landX"]=214.881,["landY"]=-1521.241,["landZ"]=-173.969,["flyDuration"]=8.438},{"Alley","Middle Window","grenade","weapon_smokegrenade",-160.031,887.969,-135.328,-54.858,-120.487,"custom_134",["tickrate"]=64,["throwType"]="JUMP"},{"Alley","B Site","grenade","weapon_smokegrenade",-160.031,887.969,-135.328,-58.862,-159.509,"custom_135",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1025.017,["landY"]=-1457.192,["landZ"]=-165.969,["flyDuration"]=3.531},{"Alley","Back of B","grenade","weapon_smokegrenade",-784.014,623.969,-75.969,-56.805,-158.062,"custom_136",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-841.62,["landY"]=-2332.311,["landZ"]=-173.969,["flyDuration"]=4.344},{"Alley","Balcony","grenade","weapon_smokegrenade",-148.031,353.031,-34.428,-56.725,167.454,"custom_137",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-849.315,["landY"]=-170.212,["landZ"]=-167.273,["flyDuration"]=10.438},{"Alley","Ninja Box","grenade","weapon_smokegrenade",-148.031,353.031,-34.428,-60.373,-179.841,"custom_138",["tickrate"]=64,["throwType"]="JUMP",["viewAnglesDistanceMax"]=0.1,["landX"]=-1125.366,["landY"]=-660.213,["landZ"]=-165.969,["flyDuration"]=7.375},{"Alley","Bench","grenade","weapon_smokegrenade",-148.031,353.031,-34.428,-45.787,-177.841,"custom_139",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1861.386,["landY"]=259.24,["landZ"]=-161.969,["flyDuration"]=7.844},{"Alley","A CT","grenade","weapon_smokegrenade",-351.969,887.969,-124.975,-39.909,-98.973,"custom_140",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=20,["landX"]=-2125.364,["landY"]=83.708,["landZ"]=-157.969,["flyDuration"]=7.016},{"Alley","A Stairs","grenade","weapon_smokegrenade",-459.969,887.987,-71.969,-37.566,-91.076,"custom_141",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1984.696,["landY"]=761.75,["landZ"]=-45.969,["flyDuration"]=11.047},{"Alley","A Jungle","grenade","weapon_smokegrenade",-160.031,887.969,-135.328,-36.502,-101.475,"custom_142",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-1914.414,["landY"]=348.141,["landZ"]=-92.84,["flyDuration"]=7.172},{"Alley","A Spot","grenade","weapon_smokegrenade",-161.031,728.353,-71.969,-38.045,-96.337,"custom_143",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=3,["landX"]=-2448.228,["landY"]=261.881,["landZ"]=-143.806,["flyDuration"]=8.422},{"Alley","Car","grenade","weapon_smokegrenade",-161.031,728.353,-71.969,-39.568,-179.464,"custom_144",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-841.504,["landY"]=-2392.897,["landZ"]=-169.969,["flyDuration"]=7.188},{"Under Balcony","A Ramp (Oneway)","grenade","weapon_smokegrenade",87.969,-2165.969,-110.233,45.803,-158.052,"custom_145",["tickrate"]=64,["throwType"]="NORMAL",["throwStrength"]=0.5,["duck"]=true,["landX"]=-506.916,["landY"]=-1612.703,["landZ"]=-37.969,["flyDuration"]=8.266},{"B Apartments","Short","grenade","weapon_smokegrenade",-1793.285,839.999,-47.969,6.236,-50.61,"custom_146",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-666.901,["landY"]=-1608.985,["landZ"]=-165.969,["flyDuration"]=8.828},{"B Apartments","Kitchen Window","grenade","weapon_smokegrenade",-1520.031,680.031,-47.969,-6.106,105.384,"custom_147",["tickrate"]=64,["throwType"]="RUN",["runDuration"]=12,["landX"]=-485.813,["landY"]=-2196.129,["landZ"]=-177.969,["flyDuration"]=7.609},{"B Bombsite","A CT","grenade","weapon_smokegrenade",-1863.969,335.969,-159.969,-45.503,-68.284,"custom_148",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=21,["landX"]=-2340.406,["landY"]=690.1,["landZ"]=-39.197,["flyDuration"]=6.781},{"CT","CT","grenade","weapon_smokegrenade",-1438.03,-848.031,-167.969,-52.763,-71.044,"custom_149",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-49.359,["landY"]=-2142.628,["landZ"]=-165.969,["flyDuration"]=1.781},{"Car","Car (Oneway)","grenade","weapon_smokegrenade",-2364.138,808.312,-80.259,-10.099,-160.887,"custom_150",["tickrate"]=64,["throwType"]="NORMAL",["throwStrength"]=0.5,["landX"]=-1099.212,["landY"]=168.267,["landZ"]=-171.682,["flyDuration"]=3.109},{"Window","Boost","grenade","weapon_molotov",-1120.026,-796.017,-167.969,-11.551,84.048,"custom_151",["throwType"]="NORMAL",["throwStrength"]=0.5,["landX"]=-1771.005,["landY"]=104.899,["landZ"]=-164.284,["flyDuration"]=3.734},{"Ninja","Stairs","grenade","weapon_smokegrenade",-129.519,-2413.969,-163.969,-16.512,110.258,"custom_152",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-841.23,["landY"]=-2371.393,["landZ"]=-169.969,["flyDuration"]=7.188},{"Ninja","Stairs","grenade","weapon_smokegrenade",-284.481,-2413.995,-163.969,-16.633,100.911,"custom_153",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-959.568,["landY"]=-2404.551,["landZ"]=-165.969,["flyDuration"]=9.219},{"Palace","Stairs","grenade","weapon_flashbang",223.969,-2375.969,-39.969,-12.761,149.004,"custom_154",["throwType"]="NORMAL",["landX"]=-2258.665,["landY"]=694.892,["landZ"]=-38.58,["flyDuration"]=1.719},{"T Spawn","Kitchen Window","grenade","weapon_smokegrenade",1398.97,-1255.97,-167.97,-46.0,159.9,"custom_155",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=12},{"CT","Kitchen Window","grenade","weapon_smokegrenade",-1434.031,-1173.969,-167.969,-62.734,117.42,"custom_156",["throwType"]="NORMAL",["landX"]=-477.174,["landY"]=-1560.033,["landZ"]=-37.969,["flyDuration"]=2.297},{"CT","Kitchen Door","grenade","weapon_smokegrenade",-1434.031,-1173.969,-167.969,-58.463,125.679,"custom_157",["throwType"]="NORMAL",["landX"]=-448.369,["landY"]=-1547.827,["landZ"]=-37.969,["flyDuration"]=2.328},{"Alley","Stairs","grenade","weapon_smokegrenade",560.832,-1128.031,-127.969,-71.408,-155.882,"custom_158",["throwType"]="JUMP"},{"Alley","Jungle","grenade","weapon_smokegrenade",592.031,-1200.031,-223.969,-68.43,-159.976,"custom_159",["throwType"]="JUMP",["landX"]=-1843.205,["landY"]=50.84,["landZ"]=-165.969,["flyDuration"]=9.641},{"Alley","CT","grenade","weapon_smokegrenade",700.055,-1127.963,-251.039,-53.789,-141.1,"custom_160",["throwType"]="JUMP",["landX"]=-2016.469,["landY"]=-51.286,["landZ"]=-163.969,["flyDuration"]=8.469},{"Tetris","Boxes","grenade","weapon_smokegrenade",-91.094,-1418.031,-115.969,-1.033,-106.8,"custom_161",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-2277.112,["landY"]=-71.198,["landZ"]=-167.401,["flyDuration"]=8.234},{"Underpass","Connector","grenade","weapon_smokegrenade",-1071.969,-380.031,-263.969,-5.565,-46.355,"custom_162",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-494.233,["landY"]=-1600.402,["landZ"]=-37.969,["flyDuration"]=8.203},{"Underpass","Jungle","grenade","weapon_smokegrenade",-1071.969,-380.031,-263.969,-61.862,-71.789,"custom_163",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-660.606,["landY"]=-1656.531,["landZ"]=-173.969,["flyDuration"]=8.219},{"Underpass","Jungle","grenade","weapon_smokegrenade",-968.031,-379.988,-345.971,-59.773,-76.177,"custom_164",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-870.117,["landY"]=-2394.956,["landZ"]=-169.969,["flyDuration"]=7.609},{"Underpass","Short","grenade","weapon_smokegrenade",-968.031,-380.013,-345.959,-44.947,-76.866,"custom_165",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-294.207,["landY"]=-1952.543,["landZ"]=-169.969,["flyDuration"]=3.125},{"Underpass","Window","grenade","weapon_smokegrenade",-968.019,-313.975,-367.969,-50.291,-109.914,"custom_166",["tickrate"]=64,["throwType"]="NORMAL",["throwStrength"]=0.5,["landX"]=-678.411,["landY"]=-930.34,["landZ"]=-229.969,["flyDuration"]=2.703},{"Jungle","Window","grenade","weapon_smokegrenade",-1216.031,-1526.969,-155.278,-64.254,117.784,"custom_167",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-666.901,["landY"]=-1611.289,["landZ"]=-169.969,["flyDuration"]=8.234},{"Jungle","Arch","grenade","weapon_smokegrenade",-1216.031,-1526.969,-155.278,-55.04,97.023,"custom_168",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-663.797,["landY"]=-1616.491,["landZ"]=-169.969,["flyDuration"]=7.406},{"Bench","Jungle","grenade","weapon_smokegrenade",-2655.969,447.969,-167.866,-65.634,-42.087,"custom_169",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=19,["landX"]=-782.437,["landY"]=-309.989,["landZ"]=-165.168,["flyDuration"]=4.531},{"B Short","Short","grenade","weapon_flashbang",-909.969,78.031,-165.969,-28.152,-16.312,"custom_170",["throwType"]="NORMAL",["landX"]=-1131.319,["landY"]=-657.198,["landZ"]=-165.969,["flyDuration"]=2.75},{"T Spawn","Jungle","grenade","weapon_smokegrenade",1257.795,-871.969,-143.969,-42.512,-160.448,"custom_183",["tickrate"]=64,["throwType"]="JUMP"},{"T Roof","Jungle","grenade","weapon_smokegrenade",814.969,-1549.009,-108.969,-66.251,-178.427,"custom_184",["tickrate"]=64,["throwType"]="JUMP"},{"T Roof","Stairs","grenade","weapon_smokegrenade",814.969,-1549.009,-108.969,-68.451,-178.427,"custom_185",["tickrate"]=64,["throwType"]="JUMP"},{"T Spawn","CT","grenade","weapon_smokegrenade",1422.989,34.831,-167.969,-34.744,-128.131,"custom_186",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=13},{"T Spawn","Jungle","grenade","weapon_smokegrenade",1422.969,70.969,-112.903,-64.764,-141.521,"custom_187",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=10,["landX"]=-658.626,["landY"]=-1651.535,["landZ"]=-173.969,["flyDuration"]=7.203},{"T Spawn","Stairs","grenade","weapon_smokegrenade",1359.303,519.972,-258.404,-75.987,-130.962,"custom_188",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=40,["landX"]=-669.508,["landY"]=-1589.772,["landZ"]=-165.969,["flyDuration"]=9.422},{"Ticket Booth","Connector","grenade","weapon_smokegrenade",-911.737,-2534.903,-167.969,-16.301,68.123,"custom_189",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-510.513,["landY"]=-1585.395,["landZ"]=-37.969,["flyDuration"]=8.219},{"Ticket Booth","A Ramp","grenade","weapon_smokegrenade",-911.737,-2534.903,-167.969,-66.032,43.076,"custom_190",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-855.324,["landY"]=-2396.927,["landZ"]=-169.99,["flyDuration"]=6.984},{"Under Balcony","Balcony","grenade","weapon_molotov",150.969,-2071.969,-167.969,-74.52,-91.285,"custom_191",["throwType"]="NORMAL",["landX"]=-670.757,["landY"]=-1593.207,["landZ"]=-165.969,["flyDuration"]=10.641},{"Connector","Cat","grenade","weapon_smokegrenade",-807.969,-1235.969,-167.969,2.468,70.075,"custom_192",["tickrate"]=64,["throwType"]="RUN",["runDuration"]=4,["landX"]=-476.029,["landY"]=-1594.176,["landZ"]=-37.969,["flyDuration"]=10.656},{"Top Mid","Cat","grenade","weapon_smokegrenade",399.548,280.408,-254.611,-73.773,-133.289,"custom_193",["tickrate"]=64,["throwType"]="JUMP",["landX"]=-640.456,["landY"]=-1349.121,["landZ"]=-165.969,["flyDuration"]=3.75},{"Top Mid","Jungle","grenade","weapon_smokegrenade",399.548,280.408,-254.611,-48.544,-119.692,"custom_194",["tickrate"]=64,["throwType"]="JUMP",["landX"]=169.603,["landY"]=-1523.847,["landZ"]=-173.969,["flyDuration"]=8.188},{"T Spawn","CT","grenade","weapon_smokegrenade",447.969,679.969,-165.969,-50.928,-113.191,"custom_195",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=12},{"T Spawn","Stairs","grenade","weapon_smokegrenade",496.031,679.969,-135.969,-35.762,-115.821,"custom_196",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=3,["landX"]=-448.772,["landY"]=-418.633,["landZ"]=-166.102,["flyDuration"]=2.547},{"Ninja","CT","grenade","weapon_smokegrenade",-129.519,-2413.969,-163.969,-3.146,166.321,"custom_205",["tickrate"]=64,["throwType"]="NORMAL"},{"Ninja","Connector","grenade","weapon_smokegrenade",-129.519,-2413.969,-163.969,-14.94,117.22,"custom_206",["tickrate"]=64,["throwType"]="NORMAL"},{"Ninja","Connector","grenade","weapon_smokegrenade",-284.481,-2413.969,-163.969,-6.107,108.129,"custom_207",["tickrate"]=64,["throwType"]="NORMAL"},{"CT Spawn","Middle (Deep)","grenade","weapon_smokegrenade",-2026.397,-2029.969,-299.12,-46.233,35.096,"custom_217",["tickrate"]=64,["throwType"]="RUNJUMP",["viewAnglesDistanceMax"]=0.26,["runDuration"]=15},{"Tetris","Connector","grenade","weapon_smokegrenade",-91.094,-1418.031,-115.969,-30.185,-115.607,"custom_220",["tickrate"]=64,["throwType"]="RUN"},{"T Spawn","Window","grenade","weapon_smokegrenade",1422.969,-248.031,-167.969,-25.72,-170.5,"custom_238",["tickrate"]=64,["throwType"]="JUMP"},{"Middle","Middle (Oneway)","grenade","weapon_smokegrenade",370.085,-720.523,-162.487,35.376,124.136,"custom_239",["tickrate"]=64,["throwType"]="NORMAL",["throwStrength"]=0},{"Alley","Window","grenade","weapon_smokegrenade",-624.244,615.992,-78.969,-51.596,-109.421,"custom_240",["tickrate"]=64,["throwType"]="NORMAL"},{"Car","Kitchen Door","grenade","weapon_smokegrenade",-2325.228,811.777,-119.841,-14.884,-94.343,"custom_241",["tickrate"]=64,["throwType"]="NORMAL"},{"T Spawn","Window","grenade","weapon_smokegrenade",1391.969,-1011.236,-167.969,-49.603,172.189,"custom_242",["tickrate"]=64,["throwType"]="RUN",["runDuration"]=28,["landX"]=-1078.92,["landY"]=-669.062,["landZ"]=-189.969,["flyDuration"]=5.781},{"T Spawn","Firebox","grenade","weapon_smokegrenade",1391.969,-930.076,-167.969,-21.037,-151.205,"custom_243",["tickrate"]=64,["throwType"]="JUMP",["landX"]=315.818,["landY"]=-638.224,["landZ"]=-160.059,["flyDuration"]=1.547},{"CT","CT (Oneway)","grenade","weapon_smokegrenade",-964.057,-2489.52,-167.969,-41.927,-10.766,"custom_244",["tickrate"]=64,["throwType"]="NORMAL",["throwStrength"]=0,["landX"]=-1088.815,["landY"]=-675.354,["landZ"]=-136.969,["flyDuration"]=4.563},{"Bench","Kitchen (Oneway)","grenade","weapon_smokegrenade",-2600.019,535.973,-159.969,-16.582,-50.818,"custom_245",["tickrate"]=64,["throwType"]="NORMAL",["landX"]=-2322.141,["landY"]=-378.364,["landZ"]=-165.969,["flyDuration"]=3.969},{"CT Spawn","B Apartments","grenade","weapon_smokegrenade",-2026.401,-2029.969,-299.121,-39.594,81.178,"custom_246",["tickrate"]=64,["throwType"]="RUNJUMP",["viewAnglesDistanceMax"]=0.1,["runDuration"]=9,["landX"]=-1125.402,["landY"]=-628.433,["landZ"]=-165.969,["flyDuration"]=5.75},{"CT Spawn","B Alley","grenade","weapon_smokegrenade",-2026.401,-2029.969,-299.121,-40.594,67.978,"custom_247",["tickrate"]=64,["throwType"]="RUNJUMP",["viewAnglesDistanceMax"]=0.1,["runDuration"]=17,["landX"]=-787.484,["landY"]=-2084.198,["landZ"]=-177.969,["flyDuration"]=6.578},{"B Arch","B Apartments","grenade","weapon_molotov",-1292.744,220.956,-167.969,-14.576,131.397,"custom_248",["throwType"]="NORMAL",["landX"]=-844.903,["landY"]=-2510.081,["landZ"]=-119.969,["flyDuration"]=1.484},{"CT Spawn","Middle","grenade","weapon_flashbang",-1710.997,-1208.031,-255.077,-37.687,45.553,"custom_249",["throwType"]="NORMAL",["landX"]=-1846.637,["landY"]=-391.097,["landZ"]=-122.032,["flyDuration"]=2.375},{"Window","Middle","grenade","weapon_flashbang",-1120.001,-854.408,-167.969,-14.278,88.37,"custom_250",["throwType"]="NORMAL",["landX"]=-1557.298,["landY"]=763.426,["landZ"]=-45.969,["flyDuration"]=6.984},{"A Spot","T Ramp","wallbang_hvh","weapon_wallbang",-58.85,-1808.9,-167.97,1.82,38.37,"custom_251",["duck"]=true,["landX"]=-851.298,["landY"]=611.398,["landZ"]=-80.172,["flyDuration"]=6.766},{"Connector","Palace","wallbang_hvh","weapon_wallbang",-808,-1152.02,-120.18,-3.53,-50.18,"custom_253",["duck"]=true},{"Triple Stack","Palace","wallbang_hvh","weapon_wallbang",-285.47,-2005.39,-42.97,-0.32,-31.57,"custom_254",["duck"]=false},{"CT","T Ramp / Palace","wallbang_hvh","weapon_wallbang",-967.56,-2481.82,-167.97,9.87,37,"custom_255",["duck"]=true},{"Hotbox","Palace","wallbang_hvh","weapon_wallbang",-381.52,-2394.97,-163.97,-16.39,36.5,"custom_256",["duck"]=true},{"Jungle","Palace","wallbang_hvh","weapon_wallbang",-1312,-1150.41,-167.97,-3.69,-38.07,"custom_257",["duck"]=false},{"Window","Top Mid","wallbang_hvh","weapon_wallbang",-1094.47,-684,-134.97,0.96,20.81,"custom_258",["duck"]=true},{"Chair","Short","wallbang_hvh","weapon_wallbang",-314.63,-934.99,-165.79,0.3,118.76,"custom_259",["duck"]=false},{"Top Mid","Window","wallbang_hvh","weapon_wallbang",192.73,-233.55,-169.36,-0.02,-156.59,"custom_260",["duck"]=false},{"Short","Chair","wallbang_hvh","weapon_wallbang",-911.09,149.48,-172.55,1.62,-60.53,"custom_261",["duck"]=false},{"Short","A","wallbang_hvh","weapon_wallbang",-866.1,105.85,-171.76,0.7,-79.27,"custom_262",["duck"]=false},{"B","Stove","wallbang_hvh","weapon_wallbang",-1577.63,196.44,-168.19,-7.07,30.04,"custom_263",["duck"]=false},{"Kitchen","Stove","wallbang_hvh","weapon_wallbang",-2320,-691.12,-167.97,-2.67,45.1,"custom_264",["duck"]=false},{"Kitchen","B Appartments","wallbang_hvh","weapon_wallbang",-2104.71,-642,-167.97,-4.64,66.95,"custom_265",["duck"]=false},{"Car","B Appartments","wallbang_hvh","weapon_wallbang",-2325.23,811.8,-119.84,-6.39,-4.23,"custom_266",["duck"]=true},{"Car","Short and Kitchen","wallbang_hvh","weapon_wallbang",-2233.87,650.9,-39.97,7.02,-36.93,"custom_267",["duck"]=false},{"Alley","Stove","wallbang_hvh","weapon_wallbang",-812.11,586.96,-82.5,1.23,13.97,"custom_268",["duck"]=true},{"B House","Top Mid","wallbang_hvh","weapon_wallbang",312.09,766,-135.97,7.1,-89.2,"custom_269",["duck"]=false},{"T side","Palace and T Ramp","wallbang_hvh","weapon_wallbang",1358.99,306.4,-224.23,1.71,-91.43,"custom_270",["duck"]=true},{"T Spawn","T Side","wallbang_hvh","weapon_wallbang",1120.01,-690.32,-222.8,-1.17,89.52,"custom_271",["duck"]=true},{"T Spawn","T Ramp and T Side","wallbang_hvh","weapon_wallbang",1252.97,-877.15,-45.97,10.78,-138.12,"custom_272",["duck"]=false},{"Tetris","Palace","wallbang_hvh","weapon_wallbang",-6.81,1744.48,-167.97,6.82,-76.67,"custom_273",["duck"]=true},{"Underpass","Middle","wallbang_hvh","weapon_wallbang",-1055,471.98,-367.97,-4.04,-83.82,"custom_274",["duck"]=true},{"Vent","Jungle","wallbang_hvh","weapon_wallbang",-1460.46,-797.56,-167.97,0.4,-56.48,"custom_275",["duck"]=true},{"Vent","Jungle","wallbang_hvh","weapon_wallbang",-1488,-1066.94,-222.2,-2.55,-26.79,"custom_276",["duck"]=true},{"CT","Palace","wallbang_hvh","weapon_wallbang",-1547.7,-2407.97,-240.03,-7.36,8.85,"custom_277",["duck"]=false},{"Tower","T ramp and Palace","wallbang_hvh","weapon_wallbang",-907.12,-2506.7,-35.97,6.3,40.99,"custom_278",["duck"]=true},{"B Alley","Short","wallbang_hvh","weapon_wallbang",-637.893,520.07,-81.665,11.783,-117.827,"custom_279"},{"B Alley","Car Crate","grenade","weapon_smokegrenade",-148.064,353.031,-34.428,-51.414,174.261,"custom_280",["tickrate"]=64,["throwType"]="JUMP"},{"A Bombsite","A Ramp","grenade","weapon_smokegrenade",-879.973,-2264.021,-171.081,-9.076,33.308,"custom_281",["tickrate"]=64,["throwType"]="NORMAL"},{"Connector","Connector (Oneway)","grenade","weapon_smokegrenade",-807.969,-1152.031,-120.175,29.448,12.465,"custom_282",["tickrate"]=64,["throwType"]="NORMAL",["throwStrength"]=0.5},{"Tetris","Ticket","grenade","weapon_molotov",-31.916,-1418.021,-167.969,1.678,-127.554,"custom_283",["throwType"]="JUMP"},{"Tetris","Firebox","grenade","weapon_molotov",-91.095,-1418.002,-115.969,-11.456,-102.972,"custom_284",["throwType"]="NORMAL",["landX"]=-2271.185,["landY"]=536.139,["landZ"]=-163.719,["flyDuration"]=7.641},{"T Ramp","Danger Box","grenade","weapon_molotov",479.27,-1556.031,-251.6,-9.29,-174.578,"custom_285",["throwType"]="RUN",["viewAnglesDistanceMax"]=0.1,["runDuration"]=25,["landX"]=254.518,["landY"]=-1518.577,["landZ"]=-173.969,["flyDuration"]=3.313},{"Under Balcony","Tetris","grenade","weapon_molotov",150.997,-2071.969,-167.969,-8.278,117.291,"custom_286",["throwType"]="NORMAL",["landX"]=-648.357,["landY"]=-1092.734,["landZ"]=-197.969,["flyDuration"]=2.094},{"Top Mid","Window","grenade","weapon_molotov",399.969,-120.582,-165.969,-17.012,-153.078,"custom_287",["throwType"]="RUN",["viewAnglesDistanceMax"]=0.1,["runDuration"]=40},{"Window","Whatever","move","weapon_knife",-1099.249,-683.903,-134.969,4.477,89.448,"custom_288"},{"T Spawn","Window","grenade","weapon_smokegrenade",1422.99,34.83,-167.97,-22.804,162.609,"custom_290",["throwType"]="RUNJUMP",["runDuration"]=44,["runYaw"]=90},{"Middle","Top Middle","grenade","weapon_flashbang",224.031,121.691,-234.547,-45.584,-95.476,"custom_305",["throwType"]="NORMAL",["throwStrength"]=0.5,["landX"]=-2122.319,["landY"]=362.427,["landZ"]=11874.031,["flyDuration"]=6.766},{"Car","B Apartments","grenade","weapon_flashbang",-2391.907,597.267,-127.969,-42.613,16.188,"custom_306",["throwType"]="NORMAL",["throwStrength"]=0.5,["landX"]=-2291.986,["landY"]=589.243,["landZ"]=11769.587,["flyDuration"]=7.578},{"Balcony","Tetris","grenade","weapon_flashbang",150.999,-1914.031,-39.969,-80.629,-166.746,"custom_307",["throwType"]="NORMAL",["throwStrength"]=0.5,["landX"]=-2168.196,["landY"]=826.24,["landZ"]=11778.004,["flyDuration"]=2.672},{"Window","Middle","grenade","weapon_flashbang",-1120.001,-967.657,-167.969,-15.614,90.013,"custom_308",["throwType"]="NORMAL",["duck"]=true,["landX"]=-2101.997,["landY"]=386.35,["landZ"]=11874.009,["flyDuration"]=2.094},{"Alley","B Arch (Left)","grenade","weapon_smokegrenade",-148.031,379.969,-34.428,-59.368,-172.424,"custom_309",["throwType"]="NORMAL",["landX"]=-2392.983,["landY"]=-141.431,["landZ"]=11554.031,["flyDuration"]=3.313},{"Alley","B Arch (Right)","grenade","weapon_smokegrenade",-623.921,615.969,-78.972,-72.726,-167.909,"custom_310",["throwType"]="NORMAL"},{"Jungle-Window","B Arch (for Short)","grenade","weapon_smokegrenade",-1434.031,-1173.988,-167.969,-59.949,99.876,"custom_311",["throwType"]="NORMAL",["landX"]=-2046.579,["landY"]=585.357,["landZ"]=11778.031,["flyDuration"]=7.172},{"CT Spawn","A Ramp","grenade","weapon_smokegrenade",-1710.964,-1559.874,-259.673,-52.082,-3.067,"custom_312",["throwType"]="NORMAL",["landX"]=-2089.02,["landY"]=902.033,["landZ"]=11778.031,["flyDuration"]=6.547},{"Middle","Window","grenade","weapon_smokegrenade",446.303,-611.881,-159.969,-15.333,-179.23,"custom_334",["throwType"]="RUN",["runDuration"]=10,["flyDuration"]=2.953,["landX"]=-1132.307,["landY"]=-636.585,["landZ"]=-165.969},{"T Apts","Apartment Balcony","grenade","weapon_smokegrenade",459.991,680.0,-123.969,-43.58,179.517,"custom_390",["throwType"]="RUNJUMP",["runDuration"]=2,["landX"]=-1977.183,["landY"]=705.544,["landZ"]=-45.969},{"Appartments","Tunnel Stairs","grenade","weapon_molotov",-1068.405,478.511,-79.969,-8.841,36.512,"custom_420",["throwType"]="NORMAL",["landX"]=-543.823,["landY"]=391.09,["landZ"]=-205.969},{"Middle","Underpass","grenade","weapon_molotov",276.64,-161.471,-167.204,-8.482,-145.58,"custom_421",["throwType"]="RUN",["runDuration"]=22,["landX"]=-972.574,["landY"]=-567.338,["landZ"]=-287.969},{"Window","Underpass","grenade","weapon_molotov",-1120.016,-967.654,-167.969,-3.84,114.547,"custom_422",["throwType"]="RUN",["runDuration"]=11,["landX"]=-944.741,["landY"]=-238.373,["landZ"]=-361.969},{"T Roof","Stairs","grenade","weapon_molotov",965.487,-1224.603,-108.969,-17.92,-164.945,"custom_423",["throwType"]="RUN",["runDuration"]=2,["landX"]=-453.514,["landY"]=-1607.899,["landZ"]=-37.969},{"Stairs","T Roof","grenade","weapon_molotov",-249.082,-1541.724,-53.969,-2.168,0.062,"custom_424",["throwType"]="RUNJUMP",["throwStrength"]=0,["runDuration"]=22,["landX"]=794.362,["landY"]=-1540.578,["landZ"]=-109.969},{"Stairs","T Roof","grenade","weapon_molotov",-440.893,-1528.988,-39.969,-18.206,-0.446,"custom_425",["throwType"]="NORMAL",["landX"]=803.831,["landY"]=-1538.685,["landZ"]=-109.969},{"Balcony","T Roof","grenade","weapon_molotov",26.671,-1799.082,-63.175,-1.629,71.881,"custom_426",["throwType"]="RUNJUMP",["runDuration"]=18,["landX"]=788.668,["landY"]=-1519.166,["landZ"]=-109.969},{"T Roof","A Boxes","grenade","weapon_molotov",651.777,-1128.031,-127.969,1.54,-138.228,"custom_427",["throwType"]="RUNJUMP",["runDuration"]=1,["runYaw"]=180},{"Under Window","Connector","grenade","weapon_molotov",-789.012,-712.474,-267.523,-18.12,-50.747,"custom_428",["throwType"]="RUN",["runDuration"]=15,["landX"]=-743.667,["landY"]=-1348.416,["landZ"]=-165.969},{"CT Spawn","A Default","grenade","weapon_molotov",-1309.719,-2314.032,-208.176,-11.408,-4.482,"custom_429",["throwType"]="RUN",["runDuration"]=21,["landX"]=-257.909,["landY"]=-2178.504,["landZ"]=-173.969},{"Tetris","Stairs","grenade","weapon_molotov",-91.095,-1418.002,-115.969,-8.042,-63.379,"custom_430",["throwType"]="RUNJUMP",["runDuration"]=8,["landX"]=-409.491,["landY"]=-1524.784,["landZ"]=-39.969},{"Balcony","Palace","grenade","weapon_flashbang",150.969,-2071.97,-37.969,-1.705,103.693,"custom_435",["throwType"]="RUN",["runDuration"]=2},{"Under Balcony","A Ramp","grenade","weapon_flashbang",150.969,-1914.031,-167.969,-44.99,-104.781,"custom_436",["throwType"]="RUN",["runDuration"]=1},{"Sandwich","Stairs","grenade","weapon_flashbang",-260.139,-1528.031,-167.969,-58.355,168.863,"custom_437",["throwType"]="NORMAL"},{"Connector","Middle","grenade","weapon_flashbang",-727.807,-1306.896,-167.969,24.87,76.526,"custom_438",["throwType"]="NORMAL"},{"Window","Middle","grenade","weapon_flashbang",-1196.712,-856.031,-167.969,-62.755,62.114,"custom_439",["throwType"]="NORMAL"},{"Short","Middle","grenade","weapon_flashbang",-856.774,79.288,-165.969,-46.245,-63.195,"custom_440",["throwType"]="NORMAL"},{"Car","B Apartments","grenade","weapon_flashbang",-2114.014,830.584,-121.579,-63.69,32.031,"custom_441",["throwType"]="NORMAL"},{"B Site","B Site","grenade","weapon_flashbang",-2199.555,23.969,-167.969,-14.135,-76.633,"custom_442",["throwType"]="NORMAL"},{"Apartments","Car","grenade","weapon_flashbang",-1038.031,390.031,-79.969,-14.96,-111.078,"custom_443",["throwType"]="NORMAL"},{"Apartments","B Bombsite","grenade","weapon_flashbang",-1008.031,520.031,-79.969,-5.72,142.89,"custom_444",["throwType"]="RUN"},{"Top of Mid","Middle","grenade","weapon_flashbang",399.557,280.399,-254.61,-25.4,-125.454,"custom_445",["throwType"]="NORMAL",["accurateMove"]=false},{"T Spawn","A Ramp","grenade","weapon_flashbang",815.999,-1457.758,-108.969,-24.3,166.738,"custom_446",["throwType"]="NORMAL"},{"Palace","Under Balcony","grenade","weapon_flashbang",367.995,-2207.674,-39.969,-12.255,-132.399,"custom_447",["throwType"]="RUN",["runDuration"]=2},{"Palace","A Bombsite","grenade","weapon_flashbang",32.027,-2375.991,-39.969,-57.3,96.77,"custom_448",["throwType"]="NORMAL"},{"Window","Ladder Room","movement","weapon_knife",-1096.253,-683.969,-134.969,0,91.214,"custom_456",["data"]={{0, 0, "", "", 450}, {0, 0, "F"}, 13, {0, 0, "L"}, 4, {0.12100028991699, -0.090751647949219}, {0.12100028991699, -0.18151092529297, "", "FL", 450, -450}, {0.12100028991699, 0, "", "", 450, -450}, {0.24200057983398, -0.27225494384766, "", "", 450, -450}, {0.12100028991699, -0.18150329589844, "", "", 450, -450}, {0.12100028991699, -0.18150329589844, "", "", 450, -450}, {0.24199867248535, -0.18150329589844, "", "", 450, -450}, {0.12100028991699, -0.090751647949219, "", "", 450, -450}, {0.12100028991699, 0, "", "", 450, -450}, {0.12100028991699, 0, "", "", 450, -450}, {0, 0, "FL"}, {0, 0.090751647949219, "J"}, {0.12100028991699, 0.090751647949219, "", "J"}, {0.24200057983398, 0.54450225830078, "", "FL", 450, -450}, {0.36299991607666, 0.99825286865234, "", "", 450, -450}, {0, 0.72599792480469, "FL"}, {0.12100028991699, 3.0854949951172, "", "FL", 450, -450}, {0.12100028991699, 2.6317520141602, "FL"}, {0.12100028991699, 1.6334991455078}, {0.36299991607666, 2.9040069580078}, {0.12100028991699, 3.1762466430664}, {-0.12100028991699, 3.0855026245117}, {-0.12100028991699, 3.3577499389648, "", "FL", 450, -450}, {0.12100028991699, 3.3577499389648, "", "", 450, -450}, {0, 2.8132553100586, "FL"}, {-0.12100028991699, 2.9039993286133, "", "FL", 450, -450}, {-0.12100028991699, 2.6317520141602, "", "", 450, -450}, {0, 2.6317520141602, "FL"}, {0.12100028991699, 2.7225036621094, "", "FL", 450, -450}, {0.36299991607666, 2.7225036621094, "", "", 450, -450}, {0.24199962615967, 2.3594970703125, "FL"}, {0.36299991607666, 2.0872497558594, "", "FL", 450, -450}, {0.12099933624268, 1.4519958496094, "", "", 450, -450}, {0.36299991607666, 1.0889892578125, "FL"}, {0.36299991607666, 0.72599792480469, "", "FL", 450, -450}, {0.48400115966797, 0.45375061035156, "FL"}, {0.24200057983398, 0.090744018554688, "", "FL", 450, -450}, {0.36300086975098, 0, "", "", 450}, {0.84700202941895, -0.36299133300781, "", "", 450}, {0.24200057983398, -0.18150329589844, "", "", 450}, {0.72600173950195, -0.99824523925781, "", "", 450, 225}, {0.96800231933594, -1.9965057373047, "", "", 450, 450}, {0.60500144958496, -1.9964904785156, "", "", 450, 450}, {0.36300086975098, -1.3612518310547, "", "", 450, 450}, {0.48400115966797, -2.5410003662109, "", "", 0, 450}, {0.48400115966797, -3.1762542724609, "", "", 0, 450}, {0.36300086975098, -3.9022521972656, "", "", 0, 450}, {0, -3.9929962158203, "R"}, {-0.24200057983398, -4.9912490844727, "", "R", 0, 450}, {0.24200057983398, -5.354248046875, "", "", 0, 450}, {0.12100028991699, -5.4450073242188, "R"}, {0, -5.354248046875}, {0.12100028991699, -5.0820007324219, "", "R", 0, 450}, {-0.24200057983398, -4.1744995117188, "", "", 0, 450}, {-0.12100028991699, -3.9022445678711, "", "", 0, 450}, {1.9073486328125e-06, -3.2670059204102, "R"}, {-0.24200057983398, -2.1780014038086, "", "R", 450, 450}, {-0.36300086975098, -1.5427474975586, "", "", 450, 450}, {-0.48400115966797, -0.99824523925781, "", "", 450, 450}, {-0.24200057983398, -0.45375061035156, "FR"}, {-0.12100028991699, -0.090751647949219}, {0, 0, "J"}, 4, {0, 0, "A"}, 1, {0, 0, "D", "FR", 450}, {0, 0, "", "J", 450}, {0, 0, "", "", 450}, {0, 0, "FL"}, 1, {0, 0, "", "A"}, 7, {0, 0.27224731445313}, {0, 0.18150329589844}, {-0.12100028991699, 0.45375061035156, "", "FL", 450, -450}, {0, 0.54449462890625, "FL"}, {-0.12100028991699, 0.54450225830078, "", "FL", 450, -450}, {-0.24200057983398, 0.63524627685547, "", "", 450, -450}, {-0.48400115966797, 1.1797485351563, "", "", 450, -450}, {-0.36300086975098, 0.63524627685547, "FL"}, {-0.48400115966797, 1.2704925537109, "", "FL", 450, -450}, {-0.12100028991699, 0.90750122070313, "", "", 450, -450}, {-0.24200057983398, 0.36299896240234, "FL"}, {-0.24200057983398, 0.63524627685547}, {-0.24200057983398, 0.27225494384766, "", "FL", 450, -450}, {-0.24200057983398, 0.27225494384766, "", "", 450, -450}, {-0.24200057983398, 0.18150329589844, "FL", "D"}, {-0.12100028991699, 0.090751647949219, "", "FL", 450, -450}, {-0.12100028991699, 0.18150329589844, "", "", 450, -450}, {-0.12100028991699, 0.090751647949219, "", "", 450}, {-0.24200057983398, 0.18150329589844, "F"}, {-0.48400115966797, 0.27225494384766, "", "F", 450}, {-0.48400115966797, 0.36300659179688, "F"}, {-0.24200057983398, 0.45375061035156, "", "F", 450}, {-0.36299991607666, 0.27225494384766, "F"}, {-0.36299896240234, 0.27225494384766, "", "F", 450}, {-0.24200057983398, 0.18150329589844, "", "", 450}, {-0.12100028991699, 0, "", "", 450}, {-0.12100028991699, 0.090751647949219, "F"}}},{"Window","Short","movement","weapon_knife",-1177.301,-829.755,-167.969,2.001,87.707,"custom_457",["data"]={{0, 0, "F"}, 27, {0, 0, "J"}, {0, 0, "", "FJ", 450}, {0, 0, "", "", 450}, 1, {0, 0, "R", "", 0, 225}, 1, {0.12100005149841, -0.27225494384766}, {0.12100005149841, -0.36300659179688}, {0.12100005149841, -0.45375061035156}, {0.12100005149841, -0.63524627685547}, {0.12100005149841, -0.81674957275391}, {0.24200010299683, -0.99825286865234}, {0.36300015449524, -1.2705001831055}, {0.24200010299683, -1.2705001831055}, {0.12099981307983, -0.63524627685547}, {0.48400020599365, -2.1779937744141}, {0.24199962615967, -1.8149948120117}, {0.24199962615967, -1.9057540893555}, {0.24200010299683, -0.99825286865234}, {0.3629994392395, -2.7225036621094}, {0.12099981307983, -0.54450225830078}, {0.12099981307983, -1.9964981079102}, {0.84700012207031, -3.0855026245117}, {0.48400020599365, -2.1780014038086}, {0.48400020599365, -2.3595008850098, "F", "", 225}, {0.24199962615967, -2.3594970703125}, {0.24200010299683, -1.1797485351563}, {0.12099981307983, -1.9965019226074}, {0.24199962615967, -2.1779975891113, "", "FR", 450}, {0.12100028991699, -2.0872497558594, "", "", 450}, {0, -2.0872497558594, "", "", 450}, {-0.12100028991699, -1.9057502746582, "", "", 450}, {-0.12099981307983, -1.724250793457, "", "", 450}, {-0.12099933624268, -1.5427513122559, "", "", 450}, {-0.36299896240234, -2.0872535705566, "", "", 450}, {-0.12099981307983, 0.54450607299805, "", "", 450}, {0, 0, "", "", 450}, {-4.7683715820313e-07, -0.27225494384766, "", "", 450}, {-0.12099981307983, 0, "", "", 450}, {0.12099981307983, 0, "F"}, {-4.7683715820313e-07}, 1, {0.12099981307983, -0.54450988769531}, {-0.3629994392395, -1.2705230712891}, 8, {0, 3.814697265625e-06}, 4, {0, 0, "J"}, {-0.12099981307983, -0.090751647949219, "", "FJ", 450}, {0, -0.090751647949219, "", "", 450}, {0.12100028991699, -0.54450988769531, "FR"}, {0.48399925231934, -2.4502754211426, "", "F"}, {0.48399972915649, -2.2687873840332}, {0.48400115966797, -1.4520263671875}, {0.36300086975098, -1.9965229034424}, {-0.12099933624268, -1.088996887207}, {0, -0.63524627685547}, {0, -1.1797466278076}, {0.24200057983398, -1.179744720459}, {0.36300086975098, -1.4519958496094}, {0.72600173950195, -1.54274559021}, {0.48400115966797, -1.3612461090088}, {0.48400115966797, -1.1797466278076}, {0.60500144958496, -0.90749740600586}, {0.24200057983398, -0.54449844360352}, {0.36300086975098, -0.6352481842041}, {0, -0.36299896240234}, {0.36300086975098, -0.99824714660645}, {0.36300086975098, -1.54274559021}, {0.72600173950195, -1.1797466278076}, {0.72600173950195, -0.6352481842041}, {0.84700202941895, -1.1797466278076}, {1.0890026092529, -1.5427465438843}, {1.0890045166016, -0.25712410608926667}, {0.36300086975098, -0.04537487030029333}, {0.84700202941895, 0.04537487030029333}, {0.48400115966797, 0.15124956766764333, "L", "R"}, {0.72600173950195, 0.10558255513508334}, {0.72600173950195, 0.0444990793864}, {0.84700202941895, 0.05962371826171667, "", "L"}, {0.84700202941895, -0.059915860493983335, "R"}, {0.48400115966797, -0.27224922180175, "L", "", 0, 0}, {0, 0.13554032643636668, "", "R"}, {0, 0.40837383270263333}, {0, 0.015125274658203167, "R", "L"}, {-0.12099838256836, 0.0, "F"}, {0, 0.0, "", "FR"}, 8}},{"B Apartments","B Site","grenade","weapon_flashbang",-1520.031,680.105,-47.969,-3.565,102.886,"custom_476",["throwType"]="NORMAL"},{"B Apartments","B Site","grenade","weapon_flashbang",-1471.969,664.031,-47.969,-7.074,113.412,"custom_477",["throwType"]="NORMAL",["landX"]=-1687.255,["landY"]=594.709,["landZ"]=-2.364},{"B Apartments","B Site","grenade","weapon_flashbang",-1359.969,664.031,-79.969,-4.896,139.821,"custom_478",["throwType"]="NORMAL",["landX"]=-1714.865,["landY"]=592.21,["landZ"]=-48.722},{"B Apartments","B Site","grenade","weapon_smokegrenade",-284.481,-2413.995,-163.969,-7.195,165.129,"custom_479",["throwType"]="RUN",["runDuration"]=1,["runYaw"]=180,["landX"]=252.343,["landY"]=154.8,["landZ"]=-135.215},{"Underpass","Palace","grenade","weapon_smokegrenade",-1071.97,-380.03,-263.97,-38.115,-56.261,"custom_484",["throwType"]="JUMP",["landX"]=69.511,["landY"]=-2210.22,["landZ"]=-37.969},{"T Spawn","Stairs","grenade","weapon_smokegrenade",743.997,-1290.019,-255.402,-68.542,-165.905,"custom_485",["throwType"]="JUMP",["landX"]=-501.468,["landY"]=-1603.059,["landZ"]=-37.969},{"T Spawn","Jungle","grenade","weapon_smokegrenade",743.997,-1290.019,-255.402,-60.081,-168.618,"custom_486",["throwType"]="JUMP",["landX"]=-656.53,["landY"]=-1629.244,["landZ"]=-169.969},{"T Spawn","A Bombsite (Popflash)","grenade","weapon_flashbang",580.2,-1719.065,-258.497,-7.323,174.127,"custom_488",["throwType"]="NORMAL",["landX"]=282.541,["landY"]=-1465.462,["landZ"]=-98.968},{"Middle","Palace Alley","grenade","weapon_molotov",139.706,-441.121,-167.106,-26.526,-42.721,"custom_489",["throwType"]="NORMAL",["landX"]=992.302,["landY"]=-1223.965,["landZ"]=-109.969},{"Sandwich","Stairs","grenade","weapon_smokegrenade",-261.389,-1546.36,-167.906,-68.41,-7.953,"custom_490",["throwType"]="NORMAL"},{"CT Spawn","B Site","grenade","weapon_flashbang",-1360.841,-1174.0,-117.112,-12.465,136.139,"custom_491",["throwType"]="RUNJUMP",["runDuration"]=12,["landX"]=-2370.866,["landY"]=-203.318,["landZ"]=352.975},{"Palace","A Boxes","grenade","weapon_molotov",16.031,-2237.458,-39.969,-3.235,15.78,"custom_520",["throwType"]="RUN",["runDuration"]=6,["landX"]=-319.669,["landY"]=-2090.15,["landZ"]=-98.969},{"T Roof","Scaffolding Box","grenade","weapon_molotov",691.637,-1130.105,-127.969,-1.871,-136.267,"custom_543",["throwType"]="RUNJUMP",["throwStrength"]=0.5,["runDuration"]=2,["landX"]=-19.584,["landY"]=-1810.549,["landZ"]=-110.98},{"Scaffolding","Outer Palace","wallbang_hvh","weapon_wallbang",150.969,-2071.969,-37.969,-0.346,-111.68,"custom_546",["duck"]=true},{"Jungle","Connector","wallbang_hvh","weapon_wallbang",-992.036,-1304.803,-156.124,4.195,3.082,"custom_547",["duck"]=true},{"Tunnel Stairs","Short","wallbang_hvh","weapon_wallbang",-676.049,385.521,-231.995,-4.517,-140.125,"custom_548"},{"Short","Back Alley","wallbang_hvh","weapon_wallbang",-737.847,-180.376,-159.969,-6.717,89.385,"custom_549"},{"B Site","Apartments","wallbang_hvh","weapon_wallbang",-1340.444,246.197,-167.969,-10.625,120.93,"custom_550"},{"Short","Tunnel Stairs","wallbang_hvh","weapon_wallbang",-1149.268,294.969,-159.969,37.001,26.738,"custom_551"},{"Middle","Vent","wallbang_hvh","weapon_wallbang",-1004.621,-638.675,-263.969,-10.132,-125.374,"custom_552"},{"Vent","Middle #1","wallbang_hvh","weapon_wallbang",-1279.239,-936.031,-167.969,14.405,45.962,"custom_553"},{"Vent","Middle #1","wallbang_hvh","weapon_wallbang",-1279.239,-936.031,-167.969,14.405,45.962,"custom_554"},{"Vent","Catwalk","wallbang_hvh","weapon_wallbang",-1279.239,-936.031,-167.969,1.334,37.162,"custom_555"},{"Vent","Jungle","wallbang_hvh","weapon_wallbang",-1380.528,-978.658,-167.969,0.009,-51.06,"custom_556",["duck"]=true},{"Vent","Jungle","wallbang_hvh","weapon_wallbang",-1488.012,-1017.959,-209.958,-5.007,-38.015,"custom_557",["duck"]=true},{"Jungle","Palace","wallbang_hvh","weapon_wallbang",-1488.012,-1017.959,-209.958,-5.007,-38.015,"custom_558",["duck"]=true},{"Top Middle","Connector","wallbang_hvh","weapon_wallbang",176.016,-219.995,-151.969,7.694,-143.017,"custom_559"},{"Top Alley","Ramp","wallbang_hvh","weapon_wallbang",814.994,-1548.962,-108.969,13.772,-177.008,"custom_560",["duck"]=true},{"Palace Alley","T Palace","wallbang_hvh","weapon_wallbang",561.031,-1200.0,-175.969,-0.886,-5.245,"custom_561",["duck"]=true},{"Scaffolding","Palace","wallbang_hvh","weapon_wallbang",-10.014,-1744.125,-167.969,-10.126,-77.241,"custom_562",["duck"]=true},{"CT","T Ramp / Palace","wallbang_hvh","weapon_wallbang",-879.982,-2264.026,-171.08,1.123,31.631,"custom_563"},{"Middle","Short","wallbang_hvh","weapon_wallbang",-573.063,-788.969,-261.463,-5.846,108.245,"custom_564",["duck"]=true},{"Tunnel","Short (AWP)","wallbang_hvh","weapon_wallbang",-1003.838,196.756,-367.969,-46.884,179.923,"custom_565"},{"B Site","Tunnel Stairs","wallbang_hvh","weapon_wallbang",-1577.591,175.405,-167.97,0.22,16.816,"custom_566",["duck"]=true},{"Short","Jungle","wallbang_hvh","weapon_wallbang",-822.054,-185.322,-168.749,0.906,-119.948,"custom_567"},{"Upper Vents","Connector / Middle / Jungle","wallbang_hvh","weapon_wallbang",-1199.969,-407.969,-55.969,17.066,-37.226,"custom_568",["duck"]=true},{"Top Middle","Connector","wallbang_hvh","weapon_wallbang",50.641,-439.708,-183.969,7.322,-150.861,"custom_569",["duck"]=true},{"Top Middle","Short","wallbang_hvh","weapon_wallbang",-86.216,-537.093,-209.392,-2.47,159.794,"custom_570",["duck"]=true},{"T Stairs","Side Alley","wallbang_hvh","weapon_wallbang",822.306,637.956,-196.174,8.636,-145.532,"custom_571",["duck"]=true},{"Side Alley","T Stairs","wallbang_hvh","weapon_wallbang",421.839,357.53,-251.969,1.396,9.771,"custom_572"},{"Back Alley","Stove","wallbang_hvh","weapon_wallbang",-431.51,770.991,-83.969,0.628,-155.721,"custom_573"},{"Stove","Back Alley","wallbang_hvh","weapon_wallbang",-1024.116,600.142,-79.969,2.048,6.349,"custom_574"},{"Tunnel Stairs","Apartments","wallbang_hvh","weapon_wallbang",-471.162,479.969,-143.404,-1.766,166.243,"custom_575",["duck"]=true},{"A Stairs","Palace","wallbang_hvh","weapon_wallbang",-546.973,-1405.803,-104.118,-1.044,-53.385,"custom_576",["duck"]=true},{"A Site","T Ramp","wallbang_hvh","weapon_wallbang",-303.003,-2084.999,-100.969,6.77,44.318,"custom_577",["duck"]=true},{"T","T Palace","wallbang_hvh","weapon_wallbang",1239.998,-695.542,-224.853,-4.071,-86.352,"custom_578",["duck"]=true},{"CT","Palace","wallbang_hvh","weapon_wallbang",-1089.365,-2308.935,-167.969,-6.066,7.301,"custom_579"},{"Connector","Middle","wallbang_hvh","weapon_wallbang",-807.969,-1204.848,-167.969,12.223,62.371,"custom_580"},{"Connector","Middle","wallbang_hvh","weapon_wallbang",-761.945,-1306.031,-167.969,14.27,73.242,"custom_581"},{"Catwalk","Top Middle","wallbang_hvh","weapon_wallbang",-488.22,-369.636,-167.92,0.819,10.976,"custom_582"},{"CT","Market","wallbang_hvh","weapon_wallbang",-1710.985,-1226.169,-255.322,-6.808,82.15,"custom_583",["duck"]=true},{"Back Alley","Window","grenade","weapon_smokegrenade",-161.031,576.04,-69.897,-8.163,-154.476,"custom_798",["throwType"]="JUMP",["landX"]=-1877.131,["landY"]=-299.57,["landZ"]=-165.969},{"Back Alley","Window (Oneway)","grenade","weapon_smokegrenade",-871.572,613.902,-79.768,-66.386,-139.488,"custom_799",["throwType"]="JUMP",["landX"]=-1983.263,["landY"]=-335.97,["landZ"]=-128.89},{"B Site","Wood","movement","weapon_knife",-2032.052,50.435,-159.969,8.479,52.215,"custom_800",["data"]={{0, 0, "F"}, 16, {0, 0, "J"}, 5, {0, 0, "D"}, {0, 0, "", "J"}, 19, {0, 0, "", "D"}, 3, {0, 0, "", "F"}},["viewAnglesDistanceMax"]=10},{"Palace","Outside Palace","grenade","weapon_hegrenade",747.888,-2240.465,-39.969,-4.414,-169.274,"custom_835",["throwType"]="RUN",["runDuration"]=54,["runSpeed"]=false,["landX"]=79.314,["landY"]=-2006.939,["landZ"]=-13.928},{"Ramp","T Garbage","grenade","weapon_molotov",921.532,-1183.905,-263.969,-8.785,48.427,"custom_836",["throwType"]="RUNJUMP",["runDuration"]=32,["runSpeed"]=false,["landX"]=1146.722,["landY"]=-305.644,["landZ"]=-167.969},{"Mid","Jungle 2","grenade","weapon_molotov",310.408,-168.045,-166.209,-18.604,-152.993,"custom_837",["throwType"]="RUN",["runDuration"]=21,["runSpeed"]=false,["landX"]=-1088.634,["landY"]=-650.818,["landZ"]=-137.969},{"Ramp","Stairs One-Way [Strafe Left]","grenade","weapon_molotov",1004.907,-1183.957,-256.631,-2.402,65.125,"custom_838",["throwType"]="RUNJUMP",["runDuration"]=26,["runSpeed"]=false,["landX"]=1235.209,["landY"]=192.882,["landZ"]=-191.969},{"Underpass","Cat","grenade","weapon_molotov",-1047.842,-192.406,-367.969,-22.419,-73.724,"custom_839",["throwType"]="RUNJUMP",["runDuration"]=40,["runSpeed"]=false,["landX"]=-760.144,["landY"]=-403.591,["landZ"]=-166.934},{"Connector","Chair","grenade","weapon_molotov",-719.989,-1034.719,-214.606,-32.467,73.944,"custom_840",["throwType"]="RUN",["runDuration"]=58,["runSpeed"]=false,["landX"]=-604.457,["landY"]=-575.79,["landZ"]=-272.184},{"Jungle","Ramp","grenade","weapon_molotov",-1119.992,-1527.054,-156.073,-16.642,-0.672,"custom_841",["throwType"]="NORMAL"},{"Jungle","CT-Boost","grenade","weapon_molotov",-871.609,-1306.03,-167.969,3.365,-89.05,"custom_842",["throwType"]="JUMP",["landX"]=-850.811,["landY"]=-2574.068,["landZ"]=-33.969},{"Jungle","CT Spawn","grenade","weapon_molotov",-828.359,-1306.175,-167.969,-22.558,-92.837,"custom_843",["throwType"]="NORMAL",["landX"]=-887.793,["landY"]=-2505.352,["landZ"]=-105.969},{"Box","Roof","grenade","weapon_molotov",-299.419,-2046.859,-36.969,8.425,47.889,"custom_844",["throwType"]="RUNJUMP",["runDuration"]=26,["runSpeed"]=false,["landX"]=781.248,["landY"]=-1376.694,["landZ"]=-109.969},{"Mid","Cat","grenade","weapon_molotov",330.251,-84.734,-179.964,3.803,-136.802,"custom_845",["throwType"]="RUNJUMP",["runDuration"]=22,["runSpeed"]=false,["landX"]=-733.899,["landY"]=-487.191,["landZ"]=-166.007},{"Ramp","Top Stairs 1-Way","grenade","weapon_molotov",1004.907,-1183.957,-256.631,-27.223,64.481,"custom_846",["throwType"]="RUN",["runDuration"]=25,["runSpeed"]=false,["landX"]=1281.292,["landY"]=47.037,["landZ"]=-167.969},{"Underpass","Cat","grenade","weapon_molotov",-1010.811,-328.472,-367.969,-36.432,-72.623,"custom_847",["throwType"]="RUN",["runSpeed"]=false,["landX"]=-726.836,["landY"]=-370.689,["landZ"]=-165.969},{"Palace","Outside Palace","grenade","weapon_hegrenade",747.888,-2240.465,-39.969,-4.414,-169.274,"custom_848",["throwType"]="RUN",["runDuration"]=54,["runSpeed"]=false,["landX"]=79.314,["landY"]=-2006.939,["landZ"]=-13.928},{"Ramp","T Garbage","grenade","weapon_molotov",921.532,-1183.905,-263.969,-8.785,48.427,"custom_849",["throwType"]="RUNJUMP",["runDuration"]=32,["runSpeed"]=false,["landX"]=1146.722,["landY"]=-305.644,["landZ"]=-167.969},{"Mid","Cat","grenade","weapon_molotov",399.969,-120.582,-165.969,4.416,-152.1,"custom_850",["throwType"]="RUNJUMP",["runSpeed"]=false,["landX"]=-672.32,["landY"]=-511.375,["landZ"]=-143.969},{"Mid","Jungle","grenade","weapon_molotov",399.969,-120.582,-165.969,-17.103,-153.2,"custom_851",["throwType"]="RUN",["runDuration"]=46,["runSpeed"]=false,["landX"]=-1106.685,["landY"]=-650.318,["landZ"]=-167.969},{"Mid","Jungle","grenade","weapon_molotov",417.94,-104.426,-162.969,3.916,-151.345,"custom_852",["throwType"]="RUNJUMP",["runDuration"]=49,["runSpeed"]=false,["landX"]=-1089.942,["landY"]=-603.508,["landZ"]=-138.969},{"Mid","Jungle 2","grenade","weapon_molotov",310.408,-168.045,-166.209,-18.604,-152.993,"custom_853",["throwType"]="RUN",["runDuration"]=21,["runSpeed"]=false,["landX"]=-1088.634,["landY"]=-650.818,["landZ"]=-137.969},{"Ramp","Stairs One-Way","grenade","weapon_molotov",1005.118,-1183.952,-256.629,-0.866,66.124,"custom_854",["throwType"]="RUNJUMP",["runDuration"]=24,["runSpeed"]=false,["landX"]=1266.134,["landY"]=181.986,["landZ"]=-183.969},{"Underpass","Cat","grenade","weapon_molotov",-1047.972,-192.587,-367.969,-24.665,-74.444,"custom_855",["throwType"]="RUNJUMP",["runDuration"]=40,["runSpeed"]=false,["landX"]=-730.32,["landY"]=-198.412,["landZ"]=-161.969},{"Connector","Chair","grenade","weapon_molotov",-719.989,-1034.719,-214.606,-32.467,73.944,"custom_856",["throwType"]="RUN",["runDuration"]=58,["runSpeed"]=false,["landX"]=-604.457,["landY"]=-575.79,["landZ"]=-272.184},{"Jungle","Ramp","grenade","weapon_molotov",-1119.992,-1527.054,-156.073,-16.642,-0.672,"custom_857",["throwType"]="NORMAL"},{"Jungle","CT-Boost","grenade","weapon_molotov",-871.609,-1306.03,-167.969,3.365,-89.05,"custom_858",["throwType"]="JUMP",["landX"]=-850.811,["landY"]=-2574.068,["landZ"]=-33.969},{"Jungle","CT Spawn","grenade","weapon_molotov",-828.359,-1306.175,-167.969,-22.558,-92.837,"custom_859",["throwType"]="NORMAL",["landX"]=-887.793,["landY"]=-2505.352,["landZ"]=-105.969},{"Box","Roof","grenade","weapon_molotov",-299.419,-2046.859,-36.969,8.425,47.889,"custom_860",["throwType"]="RUNJUMP",["runDuration"]=26,["runSpeed"]=false,["landX"]=781.248,["landY"]=-1376.694,["landZ"]=-109.969},{"Middle","Chair (Weird land)","movement","weapon_knife",176.021,-159.667,-151.969,1.1,-99.899,"custom_861",["data"]={{0.0, 0.0, "FZ", "", 225.0}, 4, {0.0, 0.0, "", "Z"}, 3, {0.0, 0.0, "L"}, 3, {0.0, -0.484001}, {0.0, -0.748001, "", "L"}, {0.0, -0.792}, {0.22, -1.584}, {0.22, -1.011993}, {0.088, -1.055992}, {0.088, -1.452003, "L"}, {0.176, -2.552002}, {0.044, -2.068001}, {0.044, -1.848}, {0.044, -2.991997}, {0.044, -1.627998}, {0.044, -3.431999, "", "L"}, {0.088, -2.772003}, {0.132, -2.772003}, {0.132, -3.784004}, {0.132, -2.464005}, {0.176, -2.552002}, {0.308, -3.872009}, {0.132, -2.595993}, {0.22, -2.28801}, {0.088, -1.496002}, {0.0, -1.056015, "R"}, {0.0, -0.440002}, {-0.088, -0.835999}, {-0.044, -0.483994}, {-0.044, -0.483994}, {0.0, -0.483994, "", "R"}, {0.0, -0.264008}, {0.0, -0.132004}, {0.132, -0.088013}, 2, {0.0, 0.0, "R"}, 3, {0.0, 0.0, "", "R"}, 12, {0.044, 0.044006}, {0.044, -0.044006}, {0.044, -0.088013}, {0.044, -0.044006}, {0.176, -0.088013}, {0.132, -0.132019}, {0.088}, {0.088, -0.044006}, 1, {0.044, -0.044006}, {0.088, -0.088013}, {0.088, -0.088013}, {0.088, -0.088013}, {0.088, -0.176025}, {0.044, -0.132019}, {0.088, -0.132019}, {0.044, -0.440002}, {0.176, -0.263992}, {0.132, -0.132019}, {0.176, -0.176025}, {0.176, -0.044006}, {0.264, -0.132019}, {0.132, -0.044006}, {0.176, -0.088013}, {0.044}, 1, {0.22, 0.044006}, {0.308, 0.220001, "R", "", 450.0, 225.0}, {0.66, 0.528015}, {0.044, 0.044006}, 6, {0.0, 0.0, "", "R"}, 2, {0.044, 0.044006}, {0.132, 0.0, "R"}, {0.176}, {0.044, 0.044006}, 7, {0.088, 0.132004}, 1, {0.044, 0.044006}, {0.044, 0.087997}, {0.044, 0.175995}, {0.088, 0.264008}, {0.088, 0.307999}, {0.088, 0.352005, "", "R"}, {0.088, 0.527985}, {0.132, 0.968018}, {0.0, 0.395996}, {0.088, 0.220001}, {0.044, 0.088013}, {0.044, 0.308014}, {0.088, 0.352005}, {0.088, 0.395996}, {0.132, 0.527985}, {0.22, 0.791992}, {0.176, 0.483994}, {0.088, 0.263992}, {0.132, 0.17601}, {0.132, 0.35199}, {0.132, 0.220001}, {0.132, 0.220001}, {0.22, 0.308014}, {0.22, 0.264008}, {0.176, 0.307999}, {0.132, 0.220001}, {0.088, 0.175995}, {0.088, 0.220001}, {0.132, 0.264008}, {0.132, 0.307999}, {0.132, 0.263992}, {0.132, 0.307999}, {0.088, 0.220001}, {0.088, 0.220001}, {0.044, 0.088013}, {0.088, 0.264008}, {0.132, 0.17601}, {0.088, 0.132019}, {0.044, 0.044006}, {0.088, 0.17601}, {0.044, 0.17601}, {0.088, 0.132004}, {0.088, 0.17601}, {0.132, 0.264008}, {0.088, 0.17601}, {0.22, 0.352005, "J", "", 27.508686065673828, 449.1584167480469}, {0.0, 0.0, "", "J", 26.58900260925293, -449.21380615234375}, {0.044, 0.132004, "", "", 34.165279388427734, 448.701171875}, {0.176, 0.263992, "", "", 21.5322208404541, -449.48455810546875}, {0.264, 0.396011, "", "", 28.64771842956543, 449.0871887207031}, {0.264, 0.352005, "", "", 19.200328826904297, -449.5902099609375}, {0.484, 0.572006, "", "", 28.932479858398438, 449.0689392089844}, {0.484, 0.483994, "", "", 19.33837890625, -449.58428955078125}, {0.704, 0.659988, "", "", 27.493375778198242, 449.1593322753906}, {0.44, 0.440002, "", "", 19.81621742248535, -449.5634765625}, {0.484, 0.440002, "", "", 28.117992401123047, 449.12066650390625}, {0.44, 0.483994, "", "", 18.90853500366211, -449.6025695800781}, {0.396, 0.396011, "", "", 28.73801612854004, 449.0814208984375}, {0.484, 0.528015, "", "", 17.9969425201416, -449.63995361328125}, {0.308, 0.440002, "", "", 28.83070182800293, 449.07550048828125}, {0.308, 0.440002, "", "", 24.858680725097656, -449.3128662109375}, {0.22, 0.352005, "", "", 30.40321159362793, 448.9717712402344}, {0.308, 0.572006, "", "", 24.202800750732422, -449.34869384765625}, {0.264, 0.483994, "", "", 29.903217315673828, 449.0053405761719}, {0.22, 0.528, "", "", 24.23271942138672, -449.3470458984375}, {0.22, 0.572006, "", "", 29.05404281616211, 449.06109619140625}, {0.22, 0.70401, "", "", 18.484539031982422, -449.6202087402344}, {0.308, 1.143997, "", "", 30.19258689880371, 448.9859619140625}, {0.396, 1.187996, "", "", 21.07595443725586, -449.50616455078125}, {0.264, 1.011993, "", "", 28.610942840576172, 449.08953857421875}, {0.132, 1.495995, "", "", 17.197187423706055, -449.6712646484375}, {0.044, 1.055992, "", "", 31.97086524963379, 448.86285400390625}, {0.132, 1.099998, "", "", 18.141056060791016, -449.6341857910156}, {0.0, 1.099998, "", "", 30.117673873901367, 448.9909973144531}, {0.044, 1.804008, "", "", 17.106115341186523, -449.67474365234375}, {0.044, 1.320007, "", "", 28.880216598510742, 449.0722961425781}, {0.0, 1.408005, "", "", 22.557018280029297, -449.4342956542969}, {0.0, 2.243996, "", "", 31.339902877807617, 448.9073486328125}, {0.0, 1.715996, "", "", 22.00905418395996, -449.4614562988281}, {0.0, 1.671997, "", "", 28.069313049316406, 449.12371826171875}, {0.0, 1.584, "", "", 15.926226615905762, -449.71807861328125}, {-0.044, 2.508011, "", "", 27.118061065673828, 449.1821594238281}, {0.0, 2.068001, "", "", 20.219865798950195, -449.5455017089844}, {-0.088, 1.980011, "", "", 26.518720626831055, 449.21795654296875}, {-0.044, 2.068001, "", "", 20.376937866210938, -449.5384216308594}, {0.0, 2.068001, "J", "", 25.23613739013672, 449.29180908203125}, {0.0, 1.452003, "", "J", 17.00755500793457, -449.6784973144531}, {-0.044, 1.364006, "", "", 27.176319122314453, 449.1786193847656}, {0.0, 1.452003, "", "", 23.3477840423584, -449.3938903808594}, {0.0, 1.011993, "", "", 23.434791564941406, 449.3893737792969}, {0.0, 0.792, "", "", 21.672574996948242, -449.4778137207031}, {0.0, 0.704002, "", "", 27.243186950683594, 449.1745910644531}, {0.0, 0.660004, "", "", 16.534626007080078, -449.6961364746094}, {0.044, 0.836006, "", "", 23.200157165527344, 449.40155029296875}, {0.088, 0.528008, "", "", 19.219724655151367, -449.5893859863281}, {0.044, 0.616005, "", "", 29.73353385925293, 449.0166320800781}, {0.088, 0.484009, "", "", 19.83950424194336, -449.56243896484375}, {0.044, 0.220001, "", "", 24.10856056213379, 449.3537292480469}, {0.132, 0.307999, "", "", 16.077728271484375, -449.7126770019531}, {0.088, 0.263992, "", "", 27.416757583618164, 449.1640319824219}, {0.088, 0.175995, "", "", 19.51438331604004, -449.57666015625}, {0.176, 0.263992, "", "", 23.939468383789062, 449.3627624511719}, {0.22, 0.263992, "", "", 15.747830390930176, -449.724365234375}, {0.088, 0.087997, "", "", 28.968414306640625, 449.0666198730469}, {0.132, 0.087997, "", "", 17.10761260986328, -449.6747131347656}, {0.308, 0.131996, "", "", 27.21047019958496, 449.17657470703125}, {0.176, 0.087997, "", "", 18.76688575744629, -449.6084899902344}, {0.264, 0.043999, "", "", 26.107646942138672, 449.24200439453125}, {0.352, 0.175995, "", "", 20.423389434814453, -449.5362854003906}, {0.22, 0.087997, "", "", 23.86628532409668, 449.3666687011719}, {0.44, 0.219994, "", "", 14.769401550292969, -449.757568359375}, {0.264, 0.219994, "", "", 28.04084587097168, 449.12548828125}, {0.264, 0.219994, "", "", 18.009336471557617, -449.6394958496094}, {0.352, 0.219994, "", "", 24.377695083618164, 449.3392028808594}, {0.308, 0.175995, "", "", 20.905963897705078, -449.5141296386719}, {0.396, 0.307999, "", "", 28.216073989868164, 449.1145324707031}, {0.396, 0.307991, "", "", 17.691524505615234, -449.652099609375}, {0.352, 0.219994, "", "", 23.877952575683594, 449.36602783203125}, {0.308, 0.175995, "", "", 20.599672317504883, -449.52825927734375}, {0.44, 0.175995, "", "", 28.762535095214844, 449.0798645019531}, {0.616, 0.351997, "", "", 16.705345153808594, -449.6898193359375}, {0.528, 0.175995, "", "", 24.43525505065918, 449.3360595703125}, {0.704, 0.219994, "", "", 19.62423324584961, -449.5718994140625}, {0.616, 0.131996, "", "", 21.48828887939453, 449.4866638183594}, {0.66, 0.307999, "", "", 15.045546531677246, -449.7484130859375}, {0.968, 0.616013, "", "", 21.906230926513672, 449.46649169921875}, {0.968, 0.396004, "", "", 14.963859558105469, -449.75115966796875}, {1.1, 0.308006, "", "", 24.054231643676758, 449.3566589355469}, {0.924, 0.131996, "", "", 18.24571418762207, -449.6299743652344}, {0.792, 0.484009, "", "", 26.89292335510254, 449.1956787109375}, {0.924, 0.660004, "", "", 19.208648681640625, -449.58984375}, {0.88, 0.704002, "", "", 23.873647689819336, 449.36627197265625}, {0.748, 0.748001, "", "", 14.744668006896973, -449.7583923339844}, {1.056, 0.616013, "", "", 20.860172271728516, 449.5162353515625}, {0.572, 0.528008, "D", "", 15.715731620788574, -449.7254943847656}, {0.352, 0.44001, "", "", 21.02429962158203, 449.50860595703125}, {0.22, 0.307999, "", "", 13.686809539794922, -449.79180908203125}, {0.044, 0.528015, "", "", 440.5281066894531, -91.84222412109375}, {0.044, 0.572006, "J", "", -405.3492126464844, -195.42776489257812}, {0.176, 0.660004, "Z", "J", 438.4389343261719, 101.34745025634766}, {0.176, 0.792, "", "", -290.73748779296875, -343.4701232910156}, {0.0, 1.584007, "", "", 348.15966796875, 285.1050109863281}, {-0.616, 1.671997, "", "", -97.57566833496094, -439.29376220703125}, {-1.364, 3.124008, "", "", 171.17654418945312, 416.17132568359375}, {-1.672, 6.644001, "", "", 79.61041259765625, -442.9019775390625}, {-0.352, 3.740002, "", "", 438.6090087890625, -100.60887908935547}, {-1.364, 4.048, "", "Z", -381.7134094238281, -238.3167724609375}, {-2.86, 5.147999, "", "", 410.8211975097656, 183.64625549316406}, {-3.52, 6.512001, "", "", -151.89340209960938, -423.58990478515625}, {-3.652, 6.819996, "", "", 203.60845947265625, 401.3023681640625}, {-0.748, 1.363998, "", "", 2.827449321746826, -449.9911193847656}, {-0.22, 0.043999, "", "", 105.21217346191406, 437.527587890625}, {0.0, -0.352001, "", "", 94.77899169921875, -439.9056091308594}, {0.0, -0.088001, "", "", 109.38199615478516, 436.5038146972656}, {0.0, 0.0, "", "", 94.86187744140625, -439.88775634765625}, {0.0, 0.0, "R", "F", 110.13451385498047, 436.3145751953125}, {0.0, 0.0, "", "", 192.00888061523438, -406.9798278808594}, {0.0, 0.0, "", "", -91.60311889648438, 440.577880859375}, {0.0, 0.0, "", "", 352.47479248046875, -279.7525634765625}, {0.0, 0.0, "", "", -273.5760192871094, 357.2900390625}, {0.0, 0.0, "", "", 445.44500732421875, -63.86518859863281}, {0.0, 0.0, "", "", -408.3743896484375, 189.02476501464844}, {0.0, 0.0, "", "", 441.48614501953125, 87.1204605102539}, {0.0, 0.0, "", "", 162.4395751953125, 419.6586608886719}, {0.044, -0.352001, "", "", 261.19610595703125, -366.4377136230469}, {0.22, -1.804001, "F", "", 29.69013023376465, 449.0195007324219}, {0.264, -2.551998, "", "", 133.85043334960938, -429.6324768066406}, {0.22, -3.916, "", "", 134.10809326171875, 429.5521240234375}, {0.044, -7.084, "", "", 116.51542663574219, -434.654052734375}, {0.132, -13.023998, "", "", 117.72602844238281, 434.3277587890625}, {0.088, -7.348, "", "", 114.14472961425781, -435.28265380859375}, {0.132, -7.172005, "", "", 116.64370727539062, 434.6196594238281}, {0.528, -8.008003, "", "", 116.70858764648438, -434.60223388671875}, {0.132, -5.500008, "", "", 124.40550994873047, 432.46185302734375}, {-0.044, -3.740005, "", "", 118.81046295166016, -434.0323486328125}, {0.0, -1.320007}, {-0.264, 2.024002}, {-0.396, 5.192001}, {-0.572, 4.927994, "", "R"}, {-0.308, 0.879997}, {0.176, -7.788002}, {0.22, -11.484001}, {0.0, -16.324005}, {-0.044, -19.228004}, {0.044, -12.143997}, {0.748, -6.908005}, 3, {0.0, 0.0, "L"}, 1, {-0.044, -1.143997}, {-0.088, -1.539993}, {0.264, -5.85199, "", "F"}, {0.132, -13.639999}, {0.0, 350.891998}, {0.0, -16.719986}, {0.044, -12.891998}, {-0.352, -13.508003}, {-0.528, -8.183998}, {-0.792, -5.852005}, {-1.1, -4.708}, {-0.792, -3.036003, "B", "", -225.0}, {-1.54, -4.268005}, {-0.616, -0.704002}, 4, {-0.132, 0.087997}, {-0.0, 1.232002}, {0.572, 2.156006}, {0.352, -0.043999}, {0.132, -0.220001, "", "L"}, {-0.616, -1.848, "", "D"}, {-0.176, -1.672005}, {-0.176, -3.255997}, {-0.088, -1.627998}, {0.0, -2.288002}, {0.088, -2.640007}, {0.22, -2.463997, "S"}, {0.044, -1.188004}, 7, {0.0, 0.0, "R"}, {0.264, 0.264008}, {0.176, 0.572006}, {0.088, 0.396004}, 2, {0.0, 0.087997, "", "R"}, {0.0, 0.264}, {0.0, 0.660004}, {-0.132, 0.572014}, {-0.132, 0.44001}}},{"Upper Mid","Ticket","movement","weapon_knife",343.302,-621.619,-163.43,1.452,-144.577,"custom_862",["data"]={{0.0, 0.0, "J"}, {0.0, 0.0, "", "J"}, 1, {0.0, 0.0, "F"}, {0.132, 0.17601}, {0.88, 0.17601}, {1.54, 0.35199, "D"}, {3.036, 0.528015}, {2.816, 0.307999}, {2.376, 0.044006}, {2.948}, {2.068, -0.044006}, {2.024, -0.132019}, {1.716, -0.044006}, {1.496, 0.088013}, {1.98, 0.132019}, {1.584, 0.044006}, {1.364, -0.35199}, {1.848}, {1.232, 0.132019}, {0.924, 0.307999}, {0.792, 0.307999}, {0.924, 0.396011}, {1.144, 0.660004}, {0.66, 0.396011}, {0.44, 0.263992}, {0.264, 0.132019, "", "D"}, {0.572, 0.264008}, {0.352, 0.263992}, {0.484, 0.395996}, {0.66, 0.528015}, {0.396, 0.352005}, {0.396, 0.307999}, {0.264, 0.220001}, {0.264, 0.220016}, {0.264, 0.17601}, {0.396, 0.17601, "J"}, {0.352, 0.176025, "D", "J"}, {0.352, 0.175995}, {0.22, 0.044006}, {0.132}, 6, {0.044, -0.088013}, {-0.22, -0.17601, "L"}, {-0.66, -0.484009}, 1, {0.0, 0.0, "", "F"}, 3, {-0.396, -0.352005}, {-0.088, 0.088013}, {-0.66, 0.132004}, {-0.528, 0.308014}, {-0.22, 0.264008, "F"}, {-0.132, 0.132019}, {-0.088, 0.395996}, {-0.132, 0.263992}, {-0.088, 0.528}, {-0.22, 0.132004, "", "D"}, {-0.44, 0.088013}, {-0.66, 0.088013}, {-0.396}, {-0.484, 0.044006}, {-0.748, 0.088013, "", "L"}, {-0.484, -0.044006}, {-0.132}, 3, {-0.044}, {0.176, 0.044006}, {0.748, 0.263992}, {0.704, 0.307999}, {0.66, 0.307999}, {0.616, 0.132004}, {0.704, 0.176025}, {0.44, 0.088013}, {0.66}, {0.836}, {0.704, 0.132019}, {0.792}, {0.616, 0.088013}, {0.528, 0.17601}, {0.352, 0.17601}, {0.528, 0.308014}, {0.396, 0.307999}, {0.396, 0.352005}, {0.572, 0.35199}, {0.704, 0.35199}, {0.44, 0.220001}, {0.528, 0.220001}, {0.88, 0.044006}, {0.748, 0.044006}, {0.748, 0.044006}, {0.792}, {0.748, -0.132019}, {0.792, -0.088013}, {0.572, -0.087997}, {0.396, -0.088013}, {0.792}, {0.66}, {0.88, -0.088013}, {1.144, -0.088013}, {0.616, -0.088013}, {0.66, -0.264008}, {1.188, -0.132019}, {1.232, -0.264008}, {1.496, -0.440002}, {1.144, -0.352005}, {1.1, -0.35199}, {0.968, -0.352005}, {1.144, -0.307999}, {0.968, -0.307999}, {0.704, -0.307999}, {0.528, -0.263992}, {0.66, -0.528015}, {0.264, -0.395996}, {0.088, -0.220001}, {-0.396, -0.616013}, {-1.76, -1.188004}, {-2.244, -1.056}, {-3.52, -1.319992}, {-3.608, -1.143997, "J"}, {-5.896, -1.891998, "L", "J", 450.0, -225.0}, {-4.84, -0.572006}, {-5.28, 0.175995}, {-4.092, 1.012009, "", "F"}, {-3.476, 2.112015}, {-1.408, 1.848007}, {-1.012, 2.199997}, {-0.396, 2.28801}, {-0.66, 3.740005}, {-0.484, 2.68399}, {-0.22, 2.464005}, {-0.044, 1.892006}, {0.22, 1.760002}, {0.352, 1.099998}, {0.44, 1.276009}, {0.66, 1.980003}, {0.528, 1.012001}, {0.616, 0.748001}, {0.572, 0.352005, "R", "", 0.0, 0.0}, {0.924, 0.043999, "", "L"}, {0.924, -0.748001}, {0.836, -0.923996}, {0.616, -0.879997}, {0.792, -1.716003}, {0.572, -1.364006}, {0.44, -1.364006}, {0.132, -1.188004, "D"}, {0.044, -1.275993}, {-0.044, -0.748001}, {-0.176, -0.967995}, {-0.352, -0.968002, "F"}, {-0.44, -0.791992}, {-0.572, -0.528}, {-0.528, -0.440002}, {-0.484, -0.483994}, {-0.748, -0.659988}, {-0.66, -0.352005, "", "R"}, {-0.572, -0.263992}, {-0.396}, {-0.44}, {-0.176, -0.044006}, {-0.132, -0.044006}, {-0.22}, {-0.22, 0.132019}, {-0.176, 0.220001}, {-0.088, 0.220001}, {-0.044}, {-0.088, -0.044006}, {0.0, -0.088013}, {-0.132, -0.484009}, {-2.552, -5.763992}, {-2.948, -6.951996}, {-1.232, -7.78801}, {-0.308, -9.591995, "L", "", 450.0, -225.0}, {-0.044, -12.539993}, {-0.88, 353.091995}, {-1.276, -7.919998}, {-0.308, -1.979996}, {0.0, 0.0, "", "F"}, 4, {-0.132, -0.923996}, {-0.088, -0.484009}, {0.352, -1.584015}, {-0.748, -3.167999}, {-2.288, -5.324005}, {-2.376, -4.927994}, {-3.52, -5.324005}, {-1.98, -2.772003}, {-0.924, -1.935989}, {-0.132, -0.483994}, 5, {0.0, 0.0, "F"}, 3, {-0.088, -0.175995}, {-0.484, -0.307999}, {-0.66, -0.220001}, {-0.66, -0.307999}, {-0.308, -1.5e-05}, {-0.088, 0.70401}, {0.0, 0.880005}, {-0.132, 1.100006, "", "F"}, {-0.088, 1.144012}, {0.0, 0.175995}, 1, {-0.044, 0.044006}, {-0.176, -0.396011}, {-0.176, -1.276001}, {-0.132, -1.716019}, {-0.22, -1.936005}, {-0.22, -0.748001}, {-0.044, -0.087997}, 2, {-0.044, -0.087997}, {-0.176, 0.044006}, {-0.132, 0.220001}, {-0.044, 0.087997}, {0.0, 0.0, "F", "D"}, 1, {0.0, 0.088013}, {0.044, 0.132004}, 1, {0.0, 0.087997, "S"}, {0.176, 0.307999, "", "F"}, {0.132, 0.263992}, {0.176, 0.220001}, {0.132, 0.132019, "", "L"}, {0.132, 0.220001}, {0.044, 0.087997, "R", "", 0.0, 225.0}, {0.088, 0.087997}, 1, {0.044, 0.087997}, {0.132, 0.132004}, 2, {0.0, 0.0, "B"}, 1, {0.0, 0.0, "L", "R"}, 4, {0.0, 0.0, "", "B"}, 3, {0.0, 0.0, "", "L"}, {0.0, 0.0, "R"}}},{"CT","Short (Fast)","movement","weapon_knife",-1710.969,-1208.031,-255.077,-7.8,37.791,"custom_863",["data"]={10, {0.0, 0.0, "R", "", 0.0, 225.0}, 2, {0.0, 0.0, "F", "", 225.0}, 7, {0.044, 0.132}, {0.308, 0.484001}, {0.132, 0.175999}, {0.088, 0.220001}, {0.22, 0.220001}, {0.308, 0.352001}, {0.22, 0.264004}, {0.352, 0.352001}, {0.66, 0.836002, "", "R"}, {0.528, 0.748001}, {0.572, 0.396}, {1.056, 0.396}, {1.1, 0.836002}, 1, {0.0, 0.0, "L", "", 450.0, -225.0}, 5, {0.22, 0.043999}, 1, {0.088}, {0.132, -0.043999}, {0.088, 0.043999}, {0.088, 0.220001}, {0.132, 0.132}, {0.176, 0.087997}, {0.176, 0.087997}, 2, {0.044, 0.043999}, 1, {0.044, 0.043999}, {0.044, 0.043999}, {0.044, 0.043999}, 1, {0.0, 0.0, "Z"}, 6, {0.0, 0.0, "", "Z"}, 9, {0.044, 0.043999}, {0.088}, {0.176, -0.087997}, {0.088, -0.175999}, {0.044, -0.043999, "", "L"}, {0.044, -0.043999}, {0.0, -0.043999}, {0.044, -0.043999}, {0.044}, {0.132, -0.131996}, {0.132, -0.043999, "L"}, {0.088, -0.131996}, {0.308, -0.440002}, {0.22, -0.352001}, {0.528, -0.835999}, {0.484, -0.924, "", "L"}, {0.484, -0.967999}, {0.264, -0.66}, {0.264, -0.528}, {0.352, -0.835999}, {0.748, -1.803997}, {0.528, -1.363998}, {0.528, -1.32}, {0.572, -1.495996}, {0.616, -1.848}, {0.572, -1.716}, {0.484, -1.628}, {0.396, -1.539999}, {0.484, -1.671999}, {0.484, -1.584}, {0.264, -0.747999}, {0.22, -1.056}, {0.264, -1.627998}, {0.22, -0.924}, {0.132, -1.143999}, {0.044, -1.188}, {-0.132, -1.363999}, {-0.44, -1.188}, {-0.66, -1.54}, {-0.572, -1.407999}, {-0.528, -1.188}, {-0.308, -0.572001}, {-0.44, -0.396}, {-0.616}, {-0.132, 0.616}, {-0.044, 2.464, "JR"}, {0.44, 2.42, "", "J"}, {0.704, 1.804001}, {1.1, 0.835999}, {1.496, -0.219999, "", "F"}, {1.276, -1.099999}, {1.628, -1.759999}, {1.056, -2.156}, {0.792, -2.024}, {0.66, -1.98}, {0.396, -1.804}, {0.132, -1.892}, {0.176, -1.848}, {0.044, -1.1}, {0.0, -1.056}, {0.0, -1.54}, {0.0, -0.968}, {-0.044, -1.012001}, {0.0, -1.056}, {-0.044, -1.1}, {-0.044, -0.923999}, {-0.044, -0.748}, {-0.044, -0.484}, 1, {-0.088, -0.132}, {-0.044, -0.088, "DL", "", 0.0, 225.0}, {-0.132, -0.176001, "", "", 0.0, 0.0}, {-0.044, -0.088, "", "R"}, 2, {-0.044, -0.044}, {-0.132}, {-0.088, 0.176}, {-0.176, 0.44}, {-0.176, 0.527999}, {-0.176, 0.88}, {-0.088, 0.704}, {-0.088, 1.144}, {-0.132, 1.892, "R", "", 0.0, -225.0}, {-0.044, 1.144, "", "", 0.0, 0.0}, {-0.176, 1.496, "", "L"}, {-0.132, 2.068}, {-0.132, 1.584}, {0.0, 0.352, "J"}, {0.0, 0.0, "", "J"}, 1, {0.0, 0.0, "Z"}, {0.0, -0.088}, {0.0, -0.308}, {0.044, -0.528, "", "D"}, {0.0, -0.572, "L", "", 0.0, 0.0}, {0.0, -0.396, "", "", 0.0, 0.0}, {0.0, -0.396, "", "R"}, {0.0, -0.44}, {0.0, -0.088, "", "Z"}, 1, {0.0, 0.0, "J"}, {0.0, 0.0, "", "J"}, {0.088, 0.132}, {0.0, 0.66}, {-0.044, 1.232}, {-0.088, 0.88}, {-0.044, 0.704}, {-0.132, 2.068}, {-0.088, 1.276}, {0.0, 0.88}, {0.0, 1.099999}, {-0.044, 1.275999}, {-0.044, 1.231999}, {-0.132, 1.936}, {-0.088, 1.408}, {-0.132, 1.540001}, {-0.088, 1.495998}, {-0.088, 1.188}, {-0.088, 1.672001}, {-0.088, 1.716}, {-0.132, 1.98}, {-0.088, 1.716002}, {-0.088, 2.991999}, {-0.088, 1.98}, {-0.088, 1.584}, {-0.044, 1.496002}, {-0.088, 2.860001}, {0.0, 2.640003}, {-0.044, 2.639999}, {-0.044, 2.772003}, {-0.088, 1.671997}, {-0.044, 1.408001}, {0.0, 1.848003}, {0.0, 2.375999, "J"}, {-0.044, 1.804001, "", "J"}, {0.0, 1.452}, {-0.044, 1.584}, {-0.044, 2.199997}, {-0.044, 1.936001}, {-0.088, 1.98}, {-0.176, 3.080002}, {-0.132, 2.419998}, {-0.132, 2.288002}, {-0.044, 2.068008}, {-0.22, 2.860008}, {-0.088, 1.143997}, {-0.132, 2.024002}, {-0.044, 1.144005}, {-0.088, 0.923996}, {-0.22, 1.012001}, {-0.132, 0.879997}, {-0.088, 0.748001}, {-0.044, 0.440002}, {0.0, 0.263992}, {-0.088, 0.219994}, {-0.088, 0.396011}, {-0.044, 0.616005}, {-0.132, 0.880005}, {-0.088, 0.528008}, {0.0, 0.396004}, {-0.044, 0.396011}, {-0.088, 0.395996}, {-0.132, 0.263992}, {0.0, 0.219994}, {0.0, 0.0, "F"}, 1, {0.0, 0.0, "", "L"}, 2, {-0.044, 0.043999}, {-0.044}, 4, {-0.044, -0.043999}, 2, {-0.044, -0.043999}, 1, {-0.044}, {0.0, 0.131996, "J"}, {0.044, 0.263992, "", "J"}, {0.176, 0.44001}, {0.484, 0.307999, "R"}, {0.396, 0.043999, "", "F"}, {0.44, -0.264}, {0.88, -0.528008}, {0.396, -0.308006}, {0.66, -0.572014}, {0.308, -0.396011}, {0.264, -0.44001}, {0.396, -0.835999}, {0.528, -1.584}, {0.484, -1.671997}, {0.396, -1.935997}, {0.22, -2.683998}, {0.22, -2.332001}, {0.22, -2.332001}, {0.22, -2.288002}, {0.22, -2.508003}, {0.088, -1.540001}, {0.044, -1.012001}, {0.0, -0.70401}, {0.044, -0.396011}, {0.0, -0.263992}, {0.0, -0.131996}, {0.0, -0.175995, "", "R"}, {0.0, -0.087997, "F"}, {0.0, -0.219994}, {0.0, -0.131996}, {0.0, -0.307991}, {0.044, -0.131996}, {0.0, 0.0, "R"}, 3, {0.0, 0.087997}, {0.0, 0.087997}, 1, {0.0, 0.043999}, 2, {0.088, -0.087997}, {0.132, -0.483997}, {0.308, -1.056}, {0.264, -1.935997}, {0.264, -2.287998}, {0.396, -3.343998}, {0.264, -4.091999}, {0.22, -5.896, "J"}, {0.176, -5.939999, "", "J"}, {0.22, -9.152, "", "F"}, {0.0, -5.368}, {-0.308, -3.828001}, {-0.22, -2.464001}, {-0.264, -3.212}, {-0.132, -2.288, "L", "", 0.0, 0.0}, {-0.176, -2.332001, "", "", 0.0, 0.0}, {-0.132, -1.056, "", "R"}, {-0.22, -0.616}, 1, {-0.044, -0.088}, {-0.132, 0.967999}, {-0.044, 1.76}, {-0.088, 2.904}, {-0.088, 1.452}, {-0.044, 2.199999, "R", "", 0.0, -225.0}, {-0.044, 3.74, "", "", 0.0, 0.0}, {0.044, 1.98, "", "L"}, {0.088, 0.615999}, {0.308}, {0.44, -0.835999}, {0.484, -1.407999}, {0.308, -1.98}, {0.176, -2.771999}, {0.044, -1.672}, {0.0, -1.188, "L", "", 0.0, 0.0}, {0.0, -1.012, "D", "", 0.0, 0.0}, {-0.22, -0.924001, "", "R"}, {-0.308, -0.352}, {-0.44, -0.087999}, {-0.308}, {-0.352, 0.175999, "F"}, {-0.308, 0.131999, "", "L"}, {-0.264, 0.087999}, {-0.088}, {-0.132, -0.132, "", "D"}, {-0.088, -0.088}, {-0.176, -0.176}, {-0.22, -0.352001}, {-0.132, -0.396, "J"}, {0.0, -0.616, "", "J"}, {0.044, -0.44, "D"}, {0.132, -0.484}, {0.044, -0.483999}, {0.088, -0.483999}, {0.176, -0.484}, {0.088, -0.44}, {0.088, -0.484}, {0.0, -0.263999}, {0.0, 0.0, "R"}, {0.088, -0.132}, {0.22, -0.264, "", "F"}, {0.308, -0.396}, {0.22, -0.44}, {0.484, -0.572}, {0.264, -0.66}, {0.044, -0.924}, {0.044, -1.232, "F", "", 225.0}, {-0.044, -0.704}, {-0.088, -0.396}, {-0.044, -0.132}, {-0.044, -0.088, "", "D"}, {-0.088, -0.132}, {-0.044, -0.132}, {-0.132, -0.22}, {-0.044, -0.088}, 2, {0.0, 0.0, "", "R"}, 12, {0.0, 0.044}, {0.132, 0.264}, {0.044, 0.22}, {0.176, 0.264}, {0.176, 0.264, "L", "", 450.0, -225.0}, {0.22, 0.352}, {0.088, 0.22}, {0.176, 0.22}, {0.088, 0.088}, {0.132, 0.308}, {0.088, 0.176}, {0.176, 0.44}, {0.176, 1.232}, {0.088, 1.276}, {0.088, 1.276}, {0.132, 0.792}, {0.132, 0.659999}, {0.044, 0.264001}, {0.0, 0.176}, {0.044, 0.176}, {0.0, 0.087999}, {0.044, 0.132}, {0.044, 0.176}, {0.0, 0.440001}, {-0.176, 1.54}, {-0.264, 2.596}, {-0.22, 3.3, "J"}, {-0.22, 4.576, "", "J"}, {-0.132, 4.268002}, {-0.176, 4.487999}, {-0.176, 4.883999}, {-0.132, 5.104, "", "F"}, {-0.044, 2.640003}, {-0.044, 1.803997}, {0.0, 1.232002}, {0.044, 1.099998, "R", "L"}, {0.132, 0.571999}, {0.044, 0.176003}, {0.176, 0.264004}, {0.484, 0.131996}, {0.176}, {0.44, -0.396}, {0.264, -0.439999}, {0.264, -0.880001}, {0.088, -0.571999}, {0.088, -1.452003}, {0.0, -1.144001}, {-0.088, -1.364002}, {-0.308, -1.715996}, {-0.396, -1.32, "L", "", 0.0, 0.0}, {-0.264, -0.792, "", "", 0.0, 0.0}, {-0.176, -0.307999, "", "R"}, {-0.132, 0.220001}, {-0.044, 0.704002}, {-0.088, 0.835999}, {-0.088, 1.671997}, {-0.088, 1.584}, {-0.176, 1.716}, {-0.176, 1.672001}, {-0.308, 2.771999}, {-0.264, 2.464001}, {-0.264, 2.551998}, {-0.22, 2.464001}, {-0.308, 2.771999}, {-0.176, 1.759998}, {-0.132, 1.804001}, {-0.176, 1.715996, "Z"}, {-0.22, 2.639999}, {-0.264, 2.112}, {-0.22, 2.156006}, {-0.22, 2.419998}, {-0.132, 1.099998}, {-0.176, 1.584007}, {-0.088, 0.967995}, {-0.088, 0.923996}, {-0.176, 1.012001}, {-0.352, 1.363991}, {-0.308, 1.144005}, {-0.44, 1.672005}, {-0.22, 1.540001, "", "Z"}, {-0.308, 1.408005}, {-0.264, 1.188004}, {-0.22, 0.923996}, {-0.176, 0.836006}, {-0.132, 0.44001}, {-0.044, 0.352005}, {-0.088, 0.175995, "R", "", 0.0, 0.0}, {-0.044, 0.043999, "", "L"}, 1, {-0.044, -0.043999}, {0.0, -0.264}, {-0.088, -0.924004, "J"}, {-0.044, -0.968002, "", "J"}, {-0.044, -1.276009}, {-0.044, -1.276009}, {-0.088, -1.319992}, {-0.044, -1.276009}, {-0.044, -1.144005, "L", "", 0.0, 225.0}, {-0.044, -0.924004, "", "", 0.0, 0.0}, {-0.044, -0.572006, "", "R"}, 1, {0.0, -0.043999}, {0.0, 0.264}, {-0.088, 1.144005}, {-0.132, 1.452003}, {-0.176, 2.419998}, {-0.132, 1.231995, "R", "", 0.0, -225.0}, {-0.176, 2.243996, "", "L"}, {-0.044, 1.276009}, {-0.044, 1.099998}, {0.0, 0.220001}, {0.0, 0.043999}, {0.0, -0.043999}, {0.0, -0.220001}, {0.0, -0.616005}, {0.0, -1.231995}, {0.0, -1.011993, "L", "", 0.0, 0.0}, {-0.176, -0.835999, "", "", 0.0, 0.0}, {-0.264, -0.396004, "", "R"}, {-0.66, -0.131996}, {-0.704, 0.352005}, {-0.616, 0.660004}, {-1.1, 1.496002}, {-1.056, 2.376007}, {-1.452, 3.388}, {-0.396, 0.879997, "R", "", 0.0, 0.0}, {0.0, 0.0, "", "L"}, 3, {0.0, 0.0, "F"}, 1, {0.0, 0.0, "", "R"}, 1, {-0.176, 0.484001}, {-0.088, 0.792}, {0.0, 0.396004}, {0.088, 0.835999}, {0.088, 1.672005}, {0.0, 0.616005}, {0.0, 0.352005}, {0.0, 0.087997}, 2, {0.0, 0.175995}, {0.0, 0.484009}, {0.0, 0.616005}, {0.0, 0.835999, "R"}, {0.0, 0.968002}, {-0.044, 1.584}, {-0.088, 1.936005}, {0.0, 1.452003}, {0.0, 1.144005, "", "R"}, {0.0, 0.528008}, {0.0, 0.219994}, {0.0, 0.087997}, {0.0, 0.131996}, {-0.044, 0.175995}, {0.0, 0.307999}, {0.0, 0.704002}, {-0.044, 0.879997}, {0.0, 0.924004, "R"}, {0.0, 0.528008}, {0.0, 0.879997}, {-0.044, 1.584}, {-0.044, 2.596001}, {-0.088, 2.200005}, {0.0, 1.804001}, {-0.088, 1.584}, {0.0, 1.672005}, {-0.088, 3.167999}, {0.0, 3.255997}, {0.0, 4.400009}, {0.044, 7.568008}, {0.0, 5.544006}, {0.0, 6.248001}, {-0.088, 5.192001}, {-0.088, 4.884003}, {0.0, 2.772003}, {-0.088, 2.112}, {-0.044, 1.76001}, {-0.088, 1.759995}, {0.0, 1.363998}, {-0.044, -358.23999}, {-0.044, 1.804001}, {-0.088, 3.124008}, {0.0, 2.155991}, {-0.044, 1.759995, "", "F"}, {0.0, 1.143997}, {0.0, 0.220001}, 2, {0.0, -0.572006}, {-0.088, -1.847992}, {-0.132, -3.255997}, {-0.044, -1.804001}, {-0.088, 356.787994, "F"}, {0.0, -1.363998}, {-0.044, -2.376007}, {0.0, -1.143997}, {0.0, -0.528}, 3, {0.0, 0.0, "", "F"}}},{"Balcony","Tetris","movement","weapon_knife",150.969,-2071.969,-37.969,13.012,125.772,"custom_864",["data"]={{0.044, 0.087997}, {0.0, 0.043999, "F"}, {0.0, 0.131996}, {0.0, 0.043999}, {0.044, 0.131996}, {0.0, 0.175995}, {0.044, 0.264008}, {0.088, 0.307999}, {0.0, 0.087997}, {0.088, 0.175995}, {0.0, 0.131996}, {0.088, 0.220001}, {0.044, 0.264008}, {0.044, 0.307999}, {0.0, 0.220001}, {0.044, 0.175995}, {0.0, 0.088013}, {0.044, 0.044006}, {0.0, 0.088013}, {0.0, 0.088013}, {0.0, 0.044006}, 1, {0.0, 0.044006}, 15, {0.0, 0.087997, "J", "", 27.266155242919922, -449.1731872558594}, {0.088, 0.132004, "", "J", 25.644683837890625, 449.2687072753906}, {0.352, 0.220001, "", "", 29.71440315246582, -449.01788330078125}, {0.308, 0.132004, "", "", 22.539602279663086, 449.4351501464844}, {0.748, 0.35199, "", "", 33.15275573730469, -448.777099609375}, {0.792, 0.35199, "", "", 24.513456344604492, 449.33184814453125}, {1.32, 0.440002, "", "", 31.172468185424805, -448.91900634765625}, {0.44, 0.087997, "", "", 20.027172088623047, 449.55413818359375}, {0.616, 0.0, "", "", 31.52054214477539, -448.89471435546875}, {0.484, 0.088013, "", "", 19.00132942199707, 449.5986633300781}, {0.792, 0.0, "", "", 31.881805419921875, -448.8691711425781}, {0.572, -0.088013, "", "", 19.369508743286133, 449.58294677734375}, {0.308, -0.044006, "", "", 30.531448364257812, -448.9630432128906}, {0.528, -0.132004, "", "", 20.439849853515625, 449.5355529785156}, {0.528, -0.088013, "", "", 28.639585494995117, -449.08770751953125}, {0.528, -0.132004, "", "", 22.0744686126709, 449.458251953125}, {0.528, -0.220001, "", "", 25.787660598754883, -449.260498046875}, {0.572, -0.264008, "", "", 17.93204116821289, 449.642578125}, {0.484, -0.307999, "", "", 29.063430786132812, -449.06048583984375}, {0.352, -0.35199, "", "", 23.064077377319336, 449.4085388183594}, {0.352, -0.395996, "", "", 30.975679397583008, -448.9326477050781}, {0.352, -0.528015, "", "", 22.40267562866211, 449.4420166015625}, {0.352, -0.879997, "", "", 27.711374282836914, -449.1459655761719}, {0.176, -0.440002, "", "", 16.9976749420166, 449.6788635253906}, {0.484, -1.23201, "", "", 30.228519439697266, -448.9835510253906}, {0.352, -0.880005, "", "", 17.86073112487793, 449.6454162597656}, {0.264, -0.792, "", "", 24.80662727355957, -449.31573486328125}, {0.22, -0.659996, "", "", 21.125036239624023, 449.5038757324219}, {0.088, -0.307999, "", "", 24.780183792114258, -449.31719970703125}, {0.264, -0.836006, "", "", 21.9819393157959, 449.4627685546875}, {0.264, -1.012001, "", "", 25.703969955444336, -449.2652893066406}, {0.396, -1.715996, "", "", 19.587955474853516, 449.573486328125}, {0.176, -1.143997, "", "", 26.5567626953125, -449.2156982421875}, {0.044, -0.571999, "", "", 17.118030548095703, 449.6742858886719}, {0.088, -1.056, "", "", 29.225181579589844, -449.04998779296875}, {0.044, -1.276001, "", "", 19.479421615600586, 449.57818603515625}, {0.0, -1.187996, "", "", 25.34783363342285, -449.2855529785156}, {-0.088, -1.056, "", "", 21.157535552978516, 449.5023498535156}, {-0.264, -1.187996, "", "", 23.201772689819336, -449.4014587402344}, {-0.352, -1.012001, "", "", 22.49740982055664, 449.4372863769531}, {-0.352, -0.924004, "", "", 23.478174209594727, -449.3871154785156}, {-0.44, -0.924004, "", "", 21.08283805847168, 449.505859375}, {-0.528, -0.968002, "", "", 24.10628890991211, -449.3538513183594}, {-0.572, -0.924004, "", "", 20.019807815551758, 449.554443359375}, {-0.66, -0.792007, "", "", 26.120805740356445, -449.24127197265625}, {-0.792, -0.703995, "", "", 15.855082511901855, 449.7205810546875}, {-0.396, -0.264, "", "", 26.165433883666992, -449.2386474609375}, {-0.616, -0.352005, "", "", 20.48217010498047, 449.53363037109375}, {-0.66, -0.219994, "J", "", 29.31343650817871, -449.0442199707031}, {-0.176, -0.043999, "", "J", 16.32869529724121, 449.7036437988281}, {-0.22, 0.0, "", "", 30.638877868652344, -448.95574951171875}, {-0.132, -0.043999, "", "", 16.51109504699707, 449.6969909667969}, {0.0, 0.0, "Z", "", 30.11899185180664, -448.9909362792969}, {0.0, 0.0, "", "", 16.331989288330078, 449.7035217285156}, {0.0, 0.0, "", "", 29.934425354003906, -449.0032653808594}, {0.0, 0.0, "", "", 16.147253036499023, 449.710205078125}, {0.0, 0.0, "", "", 29.743940353393555, -449.01593017578125}, {0.0, 0.0, "", "", 15.957125663757324, 449.7170104980469}, {0.0, 0.087997, "", "", 30.237483978271484, -448.98297119140625}, {0.0, 0.175995, "", "", 21.63624382019043, 449.4795837402344}, {0.044, 0.264008, "", "", 25.793224334716797, -449.26019287109375}, {0.0, 0.264008, "", "", 17.445796966552734, 449.66168212890625}, {0.088, 0.220001, "", "", 29.535446166992188, -449.0296936035156}, {0.044, 0.175995, "", "", 22.132402420043945, 449.4554138183594}, {0.044, 0.175995, "", "Z", 24.434297561645508, -449.33612060546875}, {0.0, 0.264008, "", "", 18.65876007080078, 449.6130065917969}, {0.0, 0.132004, "", "", 27.482847213745117, -449.15997314453125}, {0.0, 0.396004, "", "", 22.304704666137695, 449.4468688964844}, {0.0, 0.220001, "", "", 24.4453067779541, -449.3355407714844}, {0.0, 0.131996, "", "", 19.51576042175293, 449.57659912109375}, {0.0, 0.131996, "", "", 26.454118728637695, -449.2217712402344}, {0.088, 0.176003, "", "", 16.934982299804688, 449.68121337890625}, {0.088, 0.264008, "", "", 29.68337059020996, -449.0199279785156}, {0.176, 0.264008, "", "", 20.421894073486328, 449.536376953125}, {0.132, 0.220001, "", "", 25.42835807800293, -449.2809753417969}, {0.22, 0.352005, "", "", 15.72573471069336, 449.7251281738281}, {0.088, 0.132004, "", "", 29.015235900878906, -449.0635986328125}, {0.396, 0.484009, "", "", 18.53453254699707, 449.6181335449219}, {0.088, 0.132004, "D", "", 25.806564331054688, -449.2594299316406}, {0.22, 0.352005, "", "", 14.617464065551758, 449.76251220703125}, {0.22, 0.264008, "", "", 22.703699111938477, -449.4268798828125}, {0.22, 0.396004, "", "", 17.21036148071289, 449.6707763671875}, {0.264, 0.440002, "", "", 29.20365333557129, -449.0513916015625}, {0.264, 0.615997, "", "", 16.696962356567383, 449.69012451171875}, {0.176, 0.571999, "", "", 22.76120948791504, -449.4239807128906}, {0.132, 0.308006, "", "", 17.579679489135742, 449.656494140625}, {0.132, 0.308006, "", "", 27.53069496154785, -449.1570739746094}, {0.22, 0.484001, "", "", 19.131301879882812, 449.5931396484375}, {0.176, 0.484001, "", "", 27.198389053344727, -449.17730712890625}, {0.132, 0.616005, "", "", 18.265291213989258, 449.629150390625}, {0.132, 0.880005, "", "", 23.165807723999023, -449.4033203125}, {0.044, 0.440002, "", "", 15.6919584274292, 449.726318359375}, {0.044, 1.584, "", "", 23.29279136657715, -449.3967590332031}, {0.0, 0.748001, "", "", 20.891178131103516, 449.5148010253906}, {0.0, 1.364006}, {0.0, 1.364006}, {-0.044, 1.408005}, {-0.132, 1.407997}, {-0.484, 1.496002}, {-0.132, 0.351997}, {-0.22, 0.484001}, {-0.088, 0.176003}, {-0.044, 0.131996}, {0.0, 0.175995}, {-0.088, 0.175995}, {-0.088, 0.220001}, {-0.132, 0.176003}, 4, {-0.044, 0.087997}, {-0.044, 0.220001}, {-0.308, 0.704002}, {-0.352, 0.923988}, {-0.528, 1.276001}, {-0.132, 0.352005}, {-0.088, 0.484009}, {0.0, 0.703995}, {-0.044, 1.452011}, {-0.132, 3.432007}, {-0.264, 4.707993}, {-0.88, 5.807999}, {-1.54, 6.73201}, {-1.936, 6.996002}, {-2.156, 6.951996}, {-2.332, 6.688004, "R", "", 450.0, 225.0}, {-2.2, -353.927994}, {-1.848, 4.884003}, {-0.968, 2.199997}, {-1.628, 3.388}, {-0.264, -0.572006}, {-0.132, -2.552002}, {-0.044, -1.716003}, {0.0, -6.160004}, {0.0, 357.843994}, {0.0, -4.444}, {0.0, -2.376007}, {0.0, 0.175995}, {-0.044, 0.835999}, {0.0, 3.167999}, {0.0, 3.740005}, {0.0, -356.127991}, {0.0, 2.947998}, {0.088, 0.615997}, {0.176, -1.584}, {0.044, -4.532013}, {0.0, 355.028}, {0.0, -3.740005}, {0.0, -1.319992}, {0.0, 0.352005}, {0.044, 2.112}, {0.0, 3.299988}, {0.0, 3.783997}, {0.0, -357.975998}, {0.044, 3.388}, {0.088, 0.307999}, {0.088, -0.307999}, {0.22, -1.759995, "", "D"}, {0.044, -0.440002}, {0.044, -0.220001}, {0.044, -0.044006}, 1, {0.132, 0.307999, "", "R"}, {0.264, 0.748001}, {0.396, 0.835999}, {0.396, 0.748001}, {0.44, 0.660004}, {0.396, 0.748001}, {0.264, 0.528}, {0.176, 0.307999}, {0.264, 0.35199}, {0.352, 0.440002}, {0.396, 0.352005}, {0.132, 0.132004}, 1, {0.088, 0.087997}, {0.044, 0.044006}, {0.088, 0.088013, "", "F"}}},{"Window","Ladder","movement","weapon_knife",-1120.031,-967.656,-167.969,15.222,93.548,"custom_865",["data"]={{0.0, 0.0, "F", "", 225.0}, 4, {0.044, 0.043999}, {-0.132, 0.307991}, {-0.396, 0.572006}, {-0.308, 0.528}, {-0.22, 0.307991}, {-0.176, 0.175995}, {-0.176, 0.087997}, {-0.484, 0.307991}, {-0.616, 0.219994}, {-0.572, 0.175995}, {-0.924, 0.263992}, {-0.792, 0.307991}, {-0.572, 0.131996}, {-0.836, 0.307991}, {-0.528, 0.263992}, {-0.836, 0.660004}, {-0.572, 0.395996}, {-0.484, 0.307991}, {-0.484, 0.307991}, {-0.396, 0.263992}, {-0.396, 0.263992}, {-0.66, 0.35199}, {-0.792, 0.483986}, {-0.616, 0.35199}, {-0.792, 0.439987}, {-0.792, 0.704018}, {-0.924, 0.836014}, {-0.968, 1.144005}, {-0.66, 0.880013}, {-0.352, 0.440002}, {-0.572, 0.88002}, {-0.176, 0.395996}, {-0.22, 0.307991}, {-0.22, 0.395988}, {-0.352, 0.704018}, {-0.484, 0.616005}, {-0.264, 0.528}, {-0.132, 0.395996}, {-0.352, 1.100014}, {-0.176, 0.70401, "J", "", 23.816083908081055, 449.36932373046875}, {-0.044, 1.188004, "", "J", 31.75341796875, -448.8782958984375}, {0.0, 1.407997, "", "", 27.011056900024414, 449.1885986328125}, {0.132, 1.583992, "", "", 31.684499740600586, -448.8831481933594}, {0.088, 1.188004, "", "", 20.799657821655273, 449.51904296875}, {0.176, 1.100006, "", "", 33.648311614990234, -448.740234375}, {0.176, 1.100006, "", "", 18.926673889160156, 449.601806640625}, {0.308, 1.188004, "", "", 27.766578674316406, -449.14251708984375}, {0.264, 1.100006, "", "", 24.25533676147461, 449.3458251953125}, {0.22, 0.792007, "", "", 26.68088150024414, -449.2083435058594}, {0.22, 0.616005, "", "", 20.748001098632812, 449.5214538574219}, {0.176, 0.395988, "", "", 26.44687843322754, -449.2221984863281}, {0.22, 0.439995, "", "", 21.696514129638672, 449.4766540527344}, {0.22, 0.395988, "", "", 32.66672134399414, -448.812744140625}, {0.176, 0.175995, "", "", 24.872201919555664, 449.3121337890625}, {0.044, 0.087997, "", "", 26.838851928710938, -449.1989440917969}, {0.044, 0.043999, "", "", 23.776052474975586, 449.3714599609375}, {0.176, 0.0, "", "", 27.082233428955078, -449.184326171875}, {0.44, -0.087997, "", "", 24.36333656311035, 449.3399963378906}, {0.44, -0.483994, "", "", 30.332185745239258, -448.9765625}, {0.396, -0.572006, "", "", 24.679609298706055, 449.32275390625}, {0.44, -0.748016, "", "", 27.714305877685547, -449.1457824707031}, {0.264, -0.572014, "", "", 19.217510223388672, 449.5894470214844}, {0.308, -0.836014, "", "", 32.25852584838867, -448.84228515625}, {0.528, -1.671997, "", "", 23.071138381958008, 449.408203125}, {0.308, -0.836006, "", "", 28.18120574951172, -449.1167297363281}, {0.396, -0.96801, "", "", 21.50385093688965, 449.48590087890625}, {0.264, -1.188004, "", "", 26.785917282104492, -449.20208740234375}, {0.176, -1.407997, "", "", 18.039812088012695, 449.63824462890625}, {0.176, -1.715988, "", "", 25.53598403930664, -449.2748718261719}, {0.0, -1.144005, "", "", 16.667800903320312, 449.6911926269531}, {0.088, -1.672005, "", "", 26.710309982299805, -449.2065734863281}, {0.0, -2.859993, "", "", 20.578601837158203, 449.5292053222656}, {0.0, -2.507996, "", "", 31.42251205444336, -448.9015808105469}, {0.088, -2.155998, "", "", 17.733736038208008, 449.6504211425781}, {0.0, -1.848, "", "", 31.168703079223633, -448.9192810058594}, {0.0, -1.539993, "J", "", 20.54083251953125, 449.5309753417969}, {0.0, -1.715988, "", "J", 28.918787002563477, -449.06982421875}, {0.088, -1.144005, "", "", 19.20200538635254, 449.5901184082031}, {0.0, -0.748016, "", "", 29.600200653076172, -449.0254211425781}, {0.0, -0.351997, "", "", 19.84267807006836, 449.56231689453125}, {0.0, -0.219994, "", "", 24.929935455322266, -449.30889892578125}, {0.044, -0.528015, "", "", 17.651350021362305, 449.6536865234375}, {0.044, -0.396004, "", "", 25.342267990112305, -449.28582763671875}, {0.0, -0.307991, "", "", 15.153164863586426, 449.7447814941406}, {0.088, -0.439995, "", "", 27.137022018432617, -449.1809997558594}, {0.044, -0.263992, "", "", 20.496715545654297, 449.532958984375}, {0.132, -0.395988, "", "", 29.57598876953125, -449.02703857421875}, {0.0, -0.043999, "", "", 15.87700080871582, 449.7198181152344}, {0.044, -0.043999, "", "", 28.76875114440918, -449.0794677734375}, {0.0, -0.043999, "", "", 16.508520126342773, 449.6971130371094}, {0.0, 0.0, "", "", 28.3641414642334, -449.1051940917969}, {0.0, 0.0, "", "", 16.44732093811035, 449.6993103027344}, {0.0, 0.0, "", "", 28.3023681640625, -449.1091003417969}, {0.0, 0.0, "", "", 16.38396453857422, 449.7016296386719}, {0.0, 0.0, "", "", 28.238319396972656, -449.1131286621094}, {0.044, -0.087997, "", "", 17.00899314880371, 449.6784362792969}, {0.088, -0.043999, "", "", 27.13726234436035, -449.1809997558594}, {0.088, -0.043999, "", "", 17.631771087646484, 449.6544494628906}, {0.088, -0.131996, "", "", 25.68877410888672, -449.26617431640625}, {0.176, -0.131996, "", "", 19.633333206176758, 449.5715026855469}, {0.22, -0.219994, "", "", 22.763782501220703, -449.4238586425781}, {0.352, -0.263992, "", "", 15.37294864654541, 449.7373352050781}, {0.308, -0.263992, "", "", 26.26114273071289, -449.2330627441406}, {0.352, -0.263992, "", "", 19.315031051635742, 449.58526611328125}, {0.308, -0.35199, "", "", 29.069711685180664, -449.06005859375}, {0.22, -0.175995, "", "", 15.414749145507812, 449.73590087890625}, {0.264, -0.175995, "D", "", 26.117456436157227, -449.241455078125}, {0.176, -0.131996, "", "", 17.7071533203125, 449.6514587402344}, {0.088, -0.131996, "", "", 23.94527244567871, -449.3624572753906}, {0.22, -0.175995, "", "", 20.022083282470703, 449.5543518066406}, {0.22, -0.219994, "", "", 28.58014488220215, -449.0915222167969}, {0.132, -0.131996, "", "", 14.81737232208252, 449.7559814453125}, {0.132, -0.043999, "", "", 27.101015090942383, -449.1831970214844}, {0.044, -0.087997, "", "", 15.754477500915527, 449.72412109375}, {0.132, -0.219994}, {0.044, -0.175995}, {0.088, -0.131996}, {0.132, -0.395988}, {0.044, -0.439987, "R", "", 450.0, 225.0}, {0.0, -0.660004}, {0.044, -1.451996}, {0.22, -3.388}, {0.088, -3.827995}, {-0.528, -6.82}, {-0.66, -7.832008}, {-0.22, -3.080002}, {-0.308, -3.343994, "", "DR"}, {-0.22, -1.760002}, {0.0, -0.175999}, 1, {0.0, -0.220001}, {0.0, -0.264004}, {0.0, -0.175995}, {0.044, -0.131996}, {0.264, -0.043999}, {0.484, 0.131996}, {0.44, 0.307999}, {0.264, 0.307999}, {0.264, 0.440002}, {0.308, 0.924}, {0.264, 0.66}, {0.176, 0.528}, {0.22, 0.747997}, {0.176, 0.703999}, {0.264, 1.099998}, {0.176, 0.836002}, {0.088, 0.396004}, {0.088, 0.440002, "J", "", 33.39976119995117, 448.7588195800781}, {0.264, 0.572002, "", "J", 40.192718505859375, -448.2014465332031}, {0.088, 0.308002, "", "", 33.787742614746094, 448.7297668457031}, {0.044, 0.263996, "D", "", 43.79892349243164, -447.8634338378906}, {0.22, 0.70401, "", "", 33.46940612792969, 448.75360107421875}, {0.264, 0.660011, "", "", 38.563568115234375, -448.3445739746094}, {0.22, 1.056007, "", "", 35.465370178222656, 448.60028076171875}, {0.22, 0.792007, "", "", 37.22750473022461, -448.4574890136719}, {0.132, 0.616013, "", "", 32.119930267333984, 448.8522033691406}, {0.396, 1.452003, "", "", 37.515445709228516, -448.4334716796875}, {0.044, 0.528008, "", "", 32.06739044189453, 448.85595703125}, {0.044, 0.528, "L", "", 37.81716537475586, -448.40814208984375}, {0.044, 0.836014, "", "", 29.03508949279785, 449.06231689453125}, {0.0, 1.144005, "", "", 42.725101470947266, -447.9671630859375}, {0.044, 0.880013, "", "", 42.20456314086914, 448.0164794921875}, {0.0, 0.484001, "", "F", 45.99510192871094, -447.6432189941406}, {0.0, 0.571999, "", "", 73.16266632080078, 444.01263427734375}, {0.0, 0.792015, "", "", -21.497028350830078, -449.4862365722656}, {0.0, 0.528, "", "", 139.900634765625, 427.70062255859375}, {0.0, 0.35199, "F", "", -6.142623424530029, -449.95806884765625}, {-0.132, 1.584007, "", "", 79.740478515625, 442.87860107421875}, {-0.484, 2.112015, "", "L"}, {-0.484, 1.671997, "", "D"}, {-0.484, 1.232002}, {-0.352, 0.748001}, {-0.088, 0.219994}, {-0.132, 0.175995}, {0.0, 0.043999}, 4, {-0.044, 0.087997}, {0.0, 0.131996}, {0.484, 0.439995}, {0.308, 0.439995}, {0.088, 0.131996}, {0.044, 0.087997}, 1, {0.044, 0.087997}, 1, {0.0, -0.263992}, {0.0, -0.263992}, {0.0, -0.528015}, {0.0, -0.528}, {0.0, -0.528}, {0.0, -0.131996}, {0.0, -0.043999}, {0.0, -0.087997}, {0.044}, 3, {0.176, -0.307991}, {0.264, -0.219994}, {0.572, -0.395988}, {0.44, -0.439987, "L"}, {0.792, -0.836014}, {0.704, -1.012009}, {0.66, -0.660011, "", "L"}, {0.396, -1.276001}, {0.264, -0.748009}, {0.352, -0.615997}, {0.396, -0.483994}, {0.528, -0.440002}, {0.528, -0.307991}, {0.132, -0.131996}, {0.044}, 1, {0.044, -0.043999}, 2, {0.088, -0.087997}, {0.176, -0.131996, "L"}, {0.22, -0.307991}, {0.528, -1.187996}, {0.484, -2.596001}, {0.352, -2.112007}}},{"Middle","Chair","movement","weapon_knife",160.031,39.981,-206.579,3.036,-80.979,"custom_866",["data"]={{0.0, 0.0, "F"}, 3, {0.0, 0.0, "L"}, 2, {-0.044, -0.043999}, {0.0, -0.263992}, {0.0, -0.263992, "", "L"}, {0.0, -0.352005}, {0.0, -0.616005}, {0.0, -0.924004}, {0.0, -0.835999}, {0.044, -1.276001}, {0.088, -1.364006}, {0.0, -0.879997, "L"}, {0.0, -1.276001}, {0.0, -1.627998}, {0.264, -0.924004, "", "L"}, {0.088, -0.132004}, 8, {-0.132}, {-0.132, -0.043999}, {-0.044, -0.968002}, {0.0, -1.584}, {-0.088, -0.264}, {-0.132, -0.131996}, {-0.088, -0.131996}, {-0.044, -0.087997}, 5, {0.0, 0.0, "L"}, 2, {0.0, 0.0, "", "L"}, 4, {0.0, -0.087997}, {0.0, -0.131996}, {0.044, -0.307999}, {0.176, -0.660004}, {0.22, -0.792}, {0.176, -0.792007}, {0.0, -0.484009}, {0.0, -0.44001}, {0.0, -0.792007}, {0.0, -0.704002}, {0.0, -0.835999}, {0.044, -0.879997}, {0.0, -0.880005, "L", "", 450.0, -225.0}, {0.044, -0.484009}, {0.0, -0.484009}, {0.0, -0.528015}, {0.0, -0.263992}, {0.0, -0.263992}, {0.0, -0.35199, "", "L"}, {0.0, -0.220001}, {0.0, -0.70401}, {0.044, -0.967995}, {0.22, -1.452003}, {0.484, -1.935997, "L"}, {0.968, -4.224007}, {0.484, -3.475998, "", "L"}, {0.308, -3.124008}, {0.176, -2.728004}, {0.132, -3.872009}, {0.044, -3.167999}, {0.0, -2.860001}, {0.044, -3.652008}, {0.044, -2.332016}, {0.0, -2.155991}, {0.044, -2.552002}, {0.0, -3.388016}, {0.0, -2.376007}, {0.0, -1.76001}, {-0.044, -1.100006}, {-0.044, -0.792007, "R"}, {-0.044, -0.615997}, {-0.088, -0.396011}, {-0.088, -0.307999, "", "R"}, {-0.044, -0.17601}, {-0.044, -0.088013}, {-0.044, -0.132004}, {-0.044, -0.087997}, {0.0, -0.044006}, {-0.044, -0.087997}, {-0.088, -0.17601}, {-0.132, -0.307999}, 3, {-0.044, -0.087997}, {-0.264, -0.395996}, {-0.22, -0.307999}, {-0.176, -0.175995}, {-0.176, -0.175995}, {-0.088, -0.044006}, {-0.308, -0.088013}, {-0.22, -0.264008}, {-0.088, -0.088013}, 8, {-0.044, -0.044006}, {0.044, 0.307999}, {0.0, 0.044006}, {-0.132, -0.044006, "L", "", 450.0, -225.0}, 1, {0.0, 0.0, "", "L"}, 11, {0.0, 0.0, "R"}, 4, {0.0, 0.0, "", "R"}, 5, {0.0, 0.0, "R"}, 6, {0.0, 0.044006}, {0.044, 0.132019}, {0.044, 0.17601}, {0.044, 0.175995}, {0.044, 0.132004}, {0.044, 0.395996}, {0.044, 0.352005}, {0.044, 0.396011}, {0.0, 0.572006}, {0.088, 0.483994, "", "R"}, {0.088, 0.396011}, {0.044, 0.352005}, {0.044, 0.484009}, {0.044, 0.352005}, {0.044, 0.307999}, {0.044, 0.352005, "R", "", 450.0, 225.0}, {0.044, 0.791992}, {0.044, 0.440002}, {0.0, 0.440002, "", "R"}, {0.088, 0.528}, {0.044, 0.220001}, {0.0, 0.35199}, {0.0, 0.307999}, {0.044, 0.352005}, {0.0, 0.17601}, {0.044, 0.264008}, {0.0, 0.263992}, {0.044, 0.220016}, {0.0, 0.088013}, {0.0, 0.088013}, {0.0, 0.132019}, {0.0, 0.220001}, {0.0, 0.307999}, {0.0, 0.220001}, {0.0, 0.352005}, {0.0, 0.396011}, {0.0, 0.615997}, {-0.088, 0.571991}, {-0.044, 0.440002}, {-0.088, 0.395996}, {-0.132, 0.440002}, {-0.132, 0.440002}, {-0.044, 0.352005}, {-0.044, 0.088013}, {-0.044, 0.176025}, {0.0, 0.132019}, {-0.088, 0.17601}, {-0.044, 0.132019}, {0.0, 0.132019}, {-0.044}, {-0.044, 0.132019}, {-0.088, 0.088013}, {-0.132, 0.176025}, {-0.088, 0.132019}, {-0.132, 0.132019}, {-0.088, 0.307999}, {-0.088, 0.220001, "J", "", 25.364822387695312, -449.2845764160156}, {-0.044, 0.263992, "", "J", 34.30580139160156, 448.6904296875}, {0.0, 0.352005, "", "", 21.974641799926758, -449.463134765625}, {0.088, 0.659988, "", "", 33.8642578125, 448.7239990234375}, {0.22, 0.660004, "", "", 24.147754669189453, -449.35162353515625}, {0.22, 0.660004, "", "", 31.01178741455078, 448.9301452636719}, {0.352, 0.836014, "", "", 19.851776123046875, -449.5619201660156}, {0.396, 0.836014, "", "", 33.28248977661133, 448.7674865722656}, {0.484, 0.968018, "", "", 18.028675079345703, -449.6387023925781}, {0.352, 0.615997, "", "", 28.412107467651367, 449.1021423339844}, {0.44, 0.70401, "", "", 20.238719940185547, -449.5446472167969}, {0.528, 0.747986, "", "", 32.3962287902832, 448.8323669433594}, {0.396, 0.571991, "", "", 22.448875427246094, -449.4397277832031}, {0.396, 0.615997, "", "", 30.61663818359375, 448.957275390625}, {0.352, 0.572006, "", "", 23.74003028869629, -449.37335205078125}, {0.352, 0.572006, "", "", 29.39481544494629, 449.0389099121094}, {0.264, 0.396011, "", "", 23.38003921508789, -449.3922424316406}, {0.308, 0.615997, "", "", 29.204851150512695, 449.0513000488281}, {0.44, 0.835999, "", "", 18.968162536621094, -449.6000671386719}, {0.308, 0.70401, "", "", 24.888595581054688, 449.31121826171875}, {0.264, 0.527985, "", "", 20.687904357910156, -449.5242004394531}, {0.264, 0.660004, "", "", 31.168825149536133, 448.91925048828125}, {0.308, 0.880005, "", "", 17.051984786987305, -449.6767883300781}, {0.22, 0.748001, "", "", 26.2241153717041, 449.2352294921875}, {0.088, 0.484001, "", "", 18.817955017089844, -449.6063537597656}, {0.0, 0.307999, "", "", 27.799291610717773, 449.1405029296875}, {0.088, 0.660004, "", "", 18.50836944580078, -449.61920166015625}, {0.088, 1.143997, "", "", 29.140567779541016, 449.05548095703125}, {0.0, 1.099998, "", "", 20.14605712890625, -449.548828125}, {0.0, 1.452003, "", "", 24.54092025756836, 449.330322265625}, {0.0, 1.627998, "", "", 20.506174087524414, -449.53253173828125}, {0.0, 1.804001, "", "", 28.741905212402344, 449.0811767578125}, {-0.044, 2.860008, "", "", 17.63224983215332, -449.6544189453125}, {-0.132, 2.552002, "", "", 25.296142578125, 449.2884216308594}, {-0.176, 2.463997, "", "", 17.54530906677246, -449.6578369140625}, {-0.22, 3.300003, "", "", 26.937427520751953, 449.1930236816406}, {-0.088, 2.02401, "Z", "", 19.899486541748047, -449.5597839355469}, {-0.044, 1.671997, "", "", 29.1175479888916, 449.0569763183594}, {0.0, 1.496002, "", "", 20.999998092651367, -449.5097351074219}, {0.0, 1.672012, "", "", 27.576210021972656, 449.1542663574219}, {0.0, 1.144005, "J", "", 19.33526611328125, -449.58441162109375}, {-0.044, 1.672012, "", "J", 29.58710479736328, 449.0262756347656}, {-0.044, 1.320007, "", "", 19.832019805908203, -449.5627746582031}, {0.0, 0.968002, "", "Z", 27.17105484008789, 449.178955078125}, {0.0, 0.748001, "", "", 17.472620010375977, -449.66064453125}, {0.0, 0.704002, "", "", 23.49038314819336, 449.386474609375}, {0.0, 0.660011, "", "", 20.17125701904297, -449.54766845703125}, {0.0, 0.396011, "", "", 30.727231979370117, 448.94970703125}, {0.0, 0.528008, "", "", 19.4261417388916, -449.58050537109375}, {0.044, 0.484009, "", "", 30.44135284423828, 448.96917724609375}, {0.0, 0.440002, "", "", 18.6219425201416, -449.6145324707031}, {0.088, 0.263992, "", "", 24.707788467407227, 449.3211975097656}, {0.088, 0.307999, "", "", 15.147415161132812, -449.7449951171875}, {0.044, 0.219994, "", "", 28.361154556274414, 449.1053771972656}, {0.088, 0.263992, "", "", 18.887998580932617, -449.6034240722656}, {0.0, 0.043999, "", "", 25.887264251708984, 449.2547607421875}, {0.088, 0.263992, "", "", 21.244386672973633, -449.49822998046875}, {0.088, 0.175995, "", "", 30.215423583984375, 448.98443603515625}, {0.088, 0.175995, "", "", 16.085933685302734, -449.7123718261719}, {0.132, 0.307999, "", "", 26.358047485351562, 449.2273864746094}, {0.132, 0.263992, "", "", 20.509763717651367, -449.5323486328125}, {0.22, 0.307991, "", "", 29.647254943847656, 449.0223083496094}, {0.22, 0.264, "", "", 17.072223663330078, -449.6760559082031}, {0.176, 0.264, "", "", 25.440263748168945, 449.2803039550781}, {0.132, 0.175995, "", "", 20.42560386657715, -449.53619384765625}, {0.264, 0.264, "", "", 29.645225524902344, 449.0224304199219}, {0.264, 0.263992, "", "", 16.511812210083008, -449.69696044921875}, {0.176, 0.131996, "", "", 26.3346004486084, 449.2287902832031}, {0.264, 0.219994, "", "", 19.066884994506836, -449.59588623046875}, {0.176, 0.131996, "", "", 23.370105743408203, 449.39276123046875}, {0.044, -0.043999, "", "", 19.55586814880371, -449.5748596191406}, {0.22, 0.131996, "", "", 22.48119354248047, 449.4380798339844}, {0.264, 0.087997, "", "", 21.08595085144043, -449.5057373046875}, {0.264, 0.131996, "", "", 28.404268264770508, 449.1026611328125}, {0.484, 0.131996, "", "", 15.122560501098633, -449.7458190917969}, {0.352, 0.043999, "", "", 26.83980941772461, 449.1988830566406}, {0.308, 0.0, "D", "", 15.282041549682617, -449.7404479980469}, {0.44, 0.043999, "", "", 26.3765926361084, 449.226318359375}, {0.484, 0.043999, "", "", 15.875802040100098, -449.7198791503906}, {0.66, 0.043999, "", "", 25.59012222290039, 449.2718200683594}, {0.44, -0.087997, "", "", 15.43481159210205, -449.7351989746094}, {0.396, -0.043999, "", "", 26.529905319213867, 449.21728515625}, {0.396, -0.087997, "", "", 14.30441665649414, -449.7726135253906}, {0.572, -0.043999, "", "", 27.47088623046875, 449.16070556640625}, {0.396, -0.131996, "", "", 12.8297119140625, -449.81707763671875}, {0.572, -0.131996, "", "", 21.6063175201416, 449.4809875488281}, {0.44, -0.264, "", "", 17.49639320373535, -449.65972900390625}, {0.484, -0.175995, "", "", 24.965953826904297, 449.3069152832031}, {0.308, -0.131996, "", "", 14.988173484802246, -449.75030517578125}, {0.264, -0.175995, "", "", 27.290616989135742, 449.17169189453125}, {0.264, -0.263992, "", "", 19.293659210205078, -449.5862121582031}, {0.132, -0.307999}, {0.0, -0.44001}, {-0.044, -0.572014}, {-0.308, -0.528008}, {-0.308, -0.528008}, {-0.176, -0.264}, {-0.088, -0.043999}, {-0.132, 0.704002, "Z"}, {0.088, 0.967995}, {0.132, 0.484001}, 2, {0.0, 0.0, "", "Z"}, {0.0, -0.396004}, {0.0, -5.984001, "L"}, {-0.616, -7.260002}, {-1.716, -11.087997}, {-1.584, -15.179993}, {-1.1, -21.824005}, {-0.308, -10.604004}, 1, {0.0, 0.0, "", "F"}, 2, {0.0, -0.968002}, 2, {-0.528, -3.695999}, {-1.452, -10.604004, "B"}, {-1.056, 348.428009}, {-1.936, -13.727997}, {-1.584, -7.039993}, {-1.188, -5.983994}, {-0.704, -3.608002}, {-0.484, -1.584, "", "D"}, {-0.132, -0.175995}, {-0.088, -0.088013}, {-0.22, -0.220016}, {-0.484, -1.363998}, {-0.572, -1.363998, "S", "L"}, {-0.748, -0.615997}, {-0.528, -0.352005}, {-0.396, -0.703995}, {-0.836, -2.112}, {-0.352, -2.243988}, {-0.088, -1.892014}, {-0.264, -1.584}, {-0.352, -1.056007}, {-0.264, -0.704002}, {-0.264, -0.484009}, {-0.22, -0.307991}, {-0.22, -0.219994}, {-0.176, -0.175995}, {-0.088, -0.131996, "L"}}},{"Ninja","Ninja","movement","weapon_knife",-381.516,-2394.969,-163.969,6.171,25.123,"custom_867",["data"]={{0.0, 0.0, "D"}, {0.0, 0.0, "J"}, {0.0, 0.0, "", "J"}, 11, {0.0, 0.0, "F", "", 225.0}, 39, {0.0, 0.0, "", "F"}, 16, {0.0, 0.0, "", "D"}}},{"Bench","Firebox","movement","weapon_knife",-783.969,-1614.54,-167.969,3.883,-92.556,"custom_868",["data"]={{0.0, 0.0, "F"}, 2, {0.0, 0.0, "L"}, 2, {0.528, -0.571999}, {0.132}, 1, {0.0, 0.0, "", "L"}, 3, {0.0, 0.0, "L"}, 3, {-0.044, 0.043999, "", "L"}, {0.044, 0.087997}, {-0.132, -0.043999}, {-0.088, -0.043999}, 12, {0.0, 0.043999}, {0.088, 0.35199}, {0.044, 0.484009}, {0.044, 0.396011}, {0.088, 0.528008}, {0.0, 0.484009}, {0.0, 0.263992}, {0.0, 0.175995}, {0.0, 0.043999}, 1, {0.0, 0.087997}, {-0.132, 0.043999}, {-0.44, -0.131996}, {-0.924, -0.307991}, {-0.924, -0.264}, {-0.88, -0.175995}, {-1.144, -0.440002}, {-1.012, -0.528008}, {-0.616, -0.219994}, {-0.66, 0.615997}, {-0.308, 2.332008}, {0.396, 2.420006, "JR", "", 450.0, 225.0}, {2.156, 4.136002, "", "J"}, {5.72, 3.520004}, {4.4, 1.144005}, {6.116, 0.132004, "", "F"}, {4.444, -1.715996}, {2.552, -2.375992}, {1.496, -3.124008}, {0.792, -2.947998}, {0.484, -1.584}, {0.396, -2.947998}, {0.22, -2.81601}, {0.044, -1.936005}, {0.0, -1.848007}, {-0.132, -1.495995}, {-0.176, -1.540001}, {-0.308, -1.540009}, {-0.44, -1.099998}, {-0.924, -1.231995}, {-1.452, -1.275993}, {-1.804, -1.143997}, {-1.76, -0.528008, "L", "", 0.0, 0.0}, {-1.804, 0.484001, "", "", 0.0, 0.0}, {-1.76, 1.628006, "", "R"}, {-1.32, 2.243996}, {-0.88, 1.980003}, {-0.836, 3.124001}, {-0.308, 3.212006}, {-0.396, 4.487999}, {-0.22, 5.499992}, {-0.176, 4.487999}, {-0.308, 7.391998}, {-0.132, 4.400002}, {-0.264, 5.764, "J"}, {-0.22, 5.939999, "", "J"}, {-0.088, 2.991997}, {0.0, 3.476002}, {-0.044, 2.815998}, {0.0, 2.375999}, {0.0, 2.243996}, {0.0, 2.200001}, {0.0, 2.331997}, {0.0, 2.199997}, {-0.132, 2.112}, {-0.132, 1.715996}, {-0.132, 2.507996}, {-0.132, 2.771999}, {-0.088, 2.903999}, {-0.088, 3.431999}, {0.0, 3.784}, {-0.088, 3.476}, {0.0, 2.772, "R", "", 0.0, 0.0}, {0.0, 0.835999, "", "L"}, {0.044, -0.22}, {0.352, -2.332}, {0.132, -3.695999}, {0.044, -2.991999}, {0.0, -4.179998}, {0.0, -4.223999}, {0.044, -3.344, "L", "", 0.0, 0.0}, {-0.044, -2.860001, "", "", 0.0, 0.0}, {-0.308, -1.539997, "", "R"}, {-0.352, 0.616001}, {-0.264, 2.903999}, {-0.176, 4.664001}, {-0.088, 3.388}, {0.0, 3.08, "R", "", 0.0, 0.0}, {0.0, 0.66, "D", "", 0.0, 0.0}, {0.0, 0.087999, "", "L"}, {0.0, -1.408001}, {-0.264, -2.728001}, {-0.792, -2.903999, "L", "", 0.0, 0.0}, {-1.1, -1.275999, "", "R"}, {-0.748, 0.044001}, {-0.264, 0.792, "Z"}, {0.088, 1.979998}, {0.132, 1.1, "R", "L"}, {0.0, 0.087999}, {-0.044, -0.043999}, {-0.396, -0.351997, "", "Z"}, {-0.484, -0.264}, {-0.132, -0.968, "F"}, {0.22, -0.66}, 2, {0.044, -0.175999, "", "R"}, 2, {0.088, -0.176001}, {0.264, -1.539999}, {0.264, -2.639999}, {0.44, -6.468002}, {0.44, -8.755997}, {0.176, -6.643997}, {0.132, -3.563999}, {0.088, -1.011997}, {0.0, -0.528}, {0.044, -0.66}, {0.0, -0.043999}, {-0.352, 0.483997}, {-0.044, 0.132}, 2, {0.0, 0.0, "R"}, 3, {0.044, 0.043999, "", "D"}, {0.22, -1.363995}, {0.088, -1.803997}, {0.088, -2.068001, "", "R"}, {0.264, -1.320007, "", "F"}, 3, {0.044, -0.043999}}},{"Short","Window","movement","weapon_knife",-649.969,-512.26,-139.969,4.719,-89.644,"custom_869",["data"]={{-0.044}, {0.792, -2.199989, "R"}, {1.76, -6.467995}, {2.728, -10.604004}, {2.64, -12.716003}, {2.156, -11.792007}, {1.892, -11.043991}, {1.1, -8.095993}, {0.704, -5.236008}, {0.308, -3.080002}, {0.176, -3.080002}, {0.132, -2.507996}, {0.132, -1.979996}, {0.0, -0.528, "F"}, {0.0, -0.220001}, {0.0, -0.835983, "", "R"}, {-0.132, -0.791992}, {-0.352, -0.791992}, {-0.176, -0.352005}, {-0.396, -0.440002}, {-0.748, -0.747986}, {-0.792, -0.615997}, {-0.88, -0.484009}, {-0.968, -0.220016}, {-0.836}, {-0.836, -0.088013, "L"}, {-0.572}, {-0.792, 0.132019}, {-0.528, 0.176025, "", "L"}, {-0.264, 0.088013}, {-0.132}, {-0.044}, 4, {-0.044}, {-0.132, -0.396011}, {-0.132, -0.968002}, {-0.176, -0.791992}, {-0.088, -0.395996}, {-0.132, -0.307999}, {-0.22, -0.440002}, {-0.352, -0.264008}, {-0.66, -0.264008}, {-0.88, -0.044006}, {-1.056, 0.044006}, {-1.1, -0.395996}, {-1.232, -0.17601}, {-1.188, -1.5e-05}, {-0.528, 0.440002, "J"}, {-0.396, 1.188019, "R", "J"}, {0.748, 1.320007, "", "F"}, {2.728, 1.627991}, {4.004, 0.836014}, {4.268, -0.352005}, {2.86, -1.408005}, {1.364, -2.067993}, {0.792, -2.067993}, {0.528, 358.019989}, {0.264, -1.847992}, {0.044, -1.056, "L", "", 0.0, 0.0}, {0.0, -1.188004, "", "", 0.0, 0.0}, {0.0, -0.571991, "", "R"}, {-0.044}, {0.044, 0.395996}, {0.352, 0.968002, "Z"}, {0.396, 1.672012}, {0.484, 2.419998}, {0.572, -357.139999}, {0.396, 1.891998}, {0.572, 2.199997, "R", "Z", 0.0, 0.0}, {0.616, 1.804001, "", "", 0.0, 0.0}, {0.616, 1.144012, "", "L"}, {1.1, 0.484009}, {1.232, -0.572006}, {1.364, -1.23201}, {1.232, -2.199997}, {0.836, -2.376007}, {0.396, -2.727997, "J"}, {0.0, 357.799988, "", "J"}, {-0.352, -1.584}, {-0.44, -0.440002, "L", "", 0.0, 225.0}, {-0.528, 0.0, "", "", 0.0, 0.0}, {-0.616, 0.703995, "", "", 0.0, 0.0}, {-0.088, 0.880005, "", "R"}, {0.396, -357.932007}, {0.88, 3.036011}, {1.1, 2.507996}, {1.144, 1.584}, {1.188, 1.671997}, {1.232, 1.715988}, {0.748, 1.100006}, {0.968, 1.188004, "J"}, {1.012, 1.363998, "", "J"}, {0.88, 1.363998}, {0.616, 1.099991}, {0.484, 1.276001}, {0.66, 2.155991}, {0.616, 2.771988}, {0.572, 2.332001, "R", "", 0.0, 0.0}, {0.308, 0.835999, "", "L"}, {0.176, 0.132004}, {0.044, -0.440002}, {0.0, -1.056015}, {0.132, -3.168015}, {0.044, -3.167999}, {-0.044, -2.112}, {-0.66, -1.847992}, {-1.232, -1.451996, "L", "", 0.0, 0.0}, {-1.144, -0.748001, "", "R"}, {-0.748, 0.175995}, {-0.528, 1.759995}, {-0.176, 1.979996}, {-0.088, 3.036011}, {0.044, 1.892014}, {0.308, 2.68399}, {0.528, 1.76001, "R", "", 0.0, 0.0}, {0.484, -0.043991, "", "L"}, {0.484, -1.23201}, {0.088, -1.496002}, {0.0, -0.703995, "L", "", 0.0, 0.0}, {-0.22, 0.395996, "", "", 0.0, 0.0}, {-1.056, 4.751999, "", "R"}, {-0.22, 4.136002}, {-0.044, 4.796005}, {0.0, 4.884003}, {-0.132, 4.224014}, {-0.088, 3.124008}, {-0.132, 2.992004}, {-0.088, 3.388}, {-0.132, 3.300003}, {-0.132, 2.332001}, {-0.308, 4.708008}, {-0.264, 2.772003}, {-0.352, 3.255997}, {-0.396, 2.112}, {-0.088, 0.264}, {-0.088, 0.176003, "R", "", 0.0, 0.0}, {-0.176, -0.263992, "", "L"}, {-0.22, -0.792007}, {-0.088, -2.243996, "D"}, {0.0, -3.740005}, {-0.088, -4.18}, {-0.176, -4.400002}, {-0.176, -2.948006}, {-0.308, -3.431999}, {-0.484, -2.991997}, {-0.66, -2.727997}, {-0.748, -2.244003}, {-1.012, -2.595993}, {-0.748, -2.420013}, {-0.924, -2.244003, "J"}, {-0.748, -1.759995, "", "J"}, {-0.836, -1.452011}, {-0.484, -0.528}, {-0.088, -0.087997, "", "D"}, 1, {0.0, 0.0, "LZ", "", 0.0, 0.0}, {0.44, 0.308014, "", "", 0.0, 0.0}, {0.572, 0.923996, "", "R"}, {0.748, 2.067993}, {0.836, 2.992004}, {0.484, 3.124008, "", "Z"}, {0.132, 2.639999}, {0.0, 1.891998}, {0.0, 2.992004}, {0.0, 2.596008}, {0.0, 2.288002}, {-0.132, 3.300003}, {-0.264, 3.740013}, {-0.308, 3.828003}, {-0.44, 4.048004}, {-0.44, 3.607994}, {-0.44, 2.947998}, {-0.44, 1.892006}, {-0.528, 1.319992}, {-0.528, 1.276001}, {-1.32, 2.903999}, {-1.144, 2.068008}, {-1.672, 2.81601}, {-1.672, 2.419998}, {-2.244, 2.728004}, {-1.892, 1.891998}, {-1.496, 0.615997}, {-1.056, 0.0, "R", "L"}, {-1.584, -0.616005}, {-2.244, -0.748009}, {-1.98, -0.835999}, {-1.672, -0.660004}, {-1.1, -0.70401}, {-0.352, -0.307999}, {-0.352, -1.100006, "F"}, {-0.264, -1.540001}, {-0.088, -1.143997}, {0.0, -0.528008}, {0.0, 0.0, "", "R"}, {-0.044, -0.087997}, 2, {0.0, 0.0, "R", "", 450.0, 225.0}, 2, {-0.044, -0.087997}, {-0.132, -0.087997, "", "R"}, {-0.088, -0.087997}}}} end
		if map == "aim_ag_texture2" then locations_data={{"T Spawn","Edge","grenade","weapon_hegrenade",-772.95,1647.33,1.03,-16.03,-85.29,"custom_125",["throwType"]="NORMAL",["landX"]=-925.58,["landY"]=580.551,["landZ"]=-81.488,["flyDuration"]=5.781},{"CT Spawn","Boxes","grenade","weapon_molotov",-928.53,80.03,1.03,-14.58,64.53,"custom_126",["throwType"]="RUN",["runDuration"]=13,["landX"]=7.841,["landY"]=-2255.935,["landZ"]=-37.969,["flyDuration"]=5.797}} end
		if map == "de_austria" then locations_data={{"Street","House","grenade","weapon_flashbang",208.002,-100.031,-199.709,-21.175,0.046,"custom_221",["throwType"]="NORMAL",["landX"]=291.855,["landY"]=-68.152,["landZ"]=-187.607,["flyDuration"]=7.203},{"B","House","grenade","weapon_flashbang",1568.031,115.031,-111.836,-22.562,127.101,"custom_222",["throwType"]="NORMAL"},{"Storage","A Long","grenade","weapon_flashbang",-731.968,588.822,-159.969,-10.825,-13.925,"custom_223",["throwType"]="NORMAL"},{"A","Long","grenade","weapon_flashbang",-955.969,912.031,-157.379,-4.291,7.941,"custom_224",["throwType"]="NORMAL",["landX"]=-655.549,["landY"]=-1610.72,["landZ"]=-169.969,["flyDuration"]=5.172},{"A","Long","grenade","weapon_flashbang",-1359.999,1232.031,-157.779,-62.855,-0.771,"custom_225",["throwType"]="NORMAL",["throwStrength"]=0},{"A","A","grenade","weapon_flashbang",-994.993,1467.031,-163.079,-2.355,96.513,"custom_226",["throwType"]="NORMAL"},{"CT","A","grenade","weapon_smokegrenade",239.969,2155.969,-133.195,-2.476,-141.337,"custom_227",["tickrate"]=64,["throwType"]="JUMP"},{"Yellow House","B","grenade","weapon_smokegrenade",-99.943,1463.618,-189.558,-13.608,-24.815,"custom_228",["tickrate"]=64,["throwType"]="RUNJUMP",["runDuration"]=25},{"CT Spawn","Bridge","grenade","weapon_smokegrenade",643.969,1703.732,-144.905,-12.156,-71.47,"custom_229",["tickrate"]=64,["throwType"]="NORMAL"},{"T Spawn","A","grenade","weapon_smokegrenade",-1644.724,-1211.66,-128.937,-7.074,70.377,"custom_230",["tickrate"]=64,["throwType"]="JUMP"},{"Wall","Bridge","grenade","weapon_smokegrenade",-105.538,-966.418,-235.081,-24.321,60.494,"custom_231",["tickrate"]=64,["throwType"]="JUMP"},{"Back of B","Shed","grenade","weapon_smokegrenade",1527.612,1533.335,-161.543,-13.097,-83.028,"custom_232",["tickrate"]=64,["throwType"]="JUMP"},{"Street","Window","grenade","weapon_smokegrenade",279.624,-329.969,-232.65,-46.278,34.659,"custom_233",["tickrate"]=64,["throwType"]="JUMP"},{"Balcony","Yellow","grenade","weapon_smokegrenade",1052.031,-247.969,-35.727,-6.227,124.502,"custom_234",["tickrate"]=64,["throwType"]="JUMP"},{"Fountain","Storage","grenade","weapon_smokegrenade",207.969,-587.969,-233.03,-26.676,155.362,"custom_235",["tickrate"]=64,["throwType"]="JUMP"},{"Fountain","Street","grenade","weapon_smokegrenade",-477.399,-1106.031,-205.123,-22.32,39.666,"custom_236",["tickrate"]=64,["throwType"]="JUMP"},{"CT Spawn","A Long","grenade","weapon_smokegrenade",239.969,2155.976,-133.193,-41.833,-129.572,"custom_237",["tickrate"]=64,["throwType"]="RUN",["runDuration"]=15}} end
		if map == "de_vertigo" then locations_data={{"T Spawn","Sandbags (Ramp)","grenade","weapon_smokegrenade",-2278.461,-1205.458,11488.031,-39.522,-4.656,"custom_291",["throwType"]="JUMP",["destroyX"]=-1967.062,["destroyY"]=-1232.336,["destroyZ"]=12063.275},{"T Spawn","A Ramp","grenade","weapon_smokegrenade",-2507.969,-1258.044,11488.031,-26.066,2.843,"custom_292",["throwType"]="JUMP",["destroyX"]=-1924.25,["destroyY"]=-1242.812,["destroyZ"]=12068.3},{"Side","A Ramp","grenade","weapon_smokegrenade",-776.154,-528.0,11799.031,-83.007,-91.576,"custom_293",["throwType"]="NORMAL"},{"Sandbags","A Ramp","grenade","weapon_molotov",-88.031,-1439.969,11776.031,-4.785,141.464,"custom_294",["throwType"]="NORMAL",["landX"]=-1088.001,["landY"]=-561.049,["landZ"]=-134.969,["flyDuration"]=3.781},{"Scaffolding","Lobby","grenade","weapon_smokegrenade",-1007.978,-1247.326,11750.031,-38.534,48.983,"custom_295",["throwType"]="NORMAL",["landX"]=-101.972,["landY"]=-83.994,["landZ"]=11778.031},{"T Spawn","B Window","grenade","weapon_smokegrenade",-2400.5,-1426.565,11488.031,-28.733,81.093,"custom_296",["throwType"]="JUMP",["destroyX"]=-2324.381,["destroyY"]=-860.648,["destroyZ"]=12069.179},{"T Spawn","B Bombsite","grenade","weapon_smokegrenade",-2276.946,-1077.312,11488.031,-57.193,90.518,"custom_297",["throwType"]="JUMP",["destroyX"]=-2282.591,["destroyY"]=-856.552,["destroyZ"]=12067.216,["landX"]=-340.071,["landY"]=-1376.585,["landZ"]=11778.031,["flyDuration"]=6.563},{"Pit","Back of B","grenade","weapon_smokegrenade",-2467.043,-334.969,11552.031,-26.434,75.568,"custom_298",["throwType"]="NORMAL",["landX"]=-452.171,["landY"]=-1143.015,["landZ"]=11713.31,["flyDuration"]=6.125},{"Pit","B Window","grenade","weapon_smokegrenade",-2500.969,-334.969,11552.031,-30.306,62.319,"custom_299",["throwType"]="NORMAL",["landX"]=-132.413,["landY"]=-93.222,["landZ"]=11778.031,["flyDuration"]=4.938},{"Pit","Doorway","grenade","weapon_smokegrenade",-2500.969,-334.998,11552.031,-58.257,60.846,"custom_300",["throwType"]="JUMP",["duck"]=true,["landX"]=-783.043,["landY"]=-650.986,["landZ"]=11557.279,["flyDuration"]=8.766},{"Pit","Firebox","grenade","weapon_molotov",-2564.252,-254.887,11552.031,-1.992,90.244,"custom_301",["throwType"]="JUMP"},{"T Spawn","Generator / Corner","grenade","weapon_smokegrenade",-2304.057,-1424.752,11776.031,-40.954,83.528,"custom_302",["throwType"]="JUMP",["destroyX"]=-2283.788,["destroyY"]=-1245.468,["destroyZ"]=12069.572,["destroyText"]="Break the Windows",["landX"]=-946.829,["landY"]=-487.947,["landZ"]=11778.031,["flyDuration"]=6.359},{"T Spawn","Pillar","grenade","weapon_smokegrenade",-2304.129,-1424.747,11776.031,-26.434,85.071,"custom_303",["throwType"]="JUMP",["destroyX"]=-2283.788,["destroyY"]=-1245.468,["destroyZ"]=12069.572,["destroyText"]="Break the Windows",["landX"]=-211.784,["landY"]=-512.12,["landZ"]=11765.223,["flyDuration"]=7.594},{"T Spawn","Close Box","grenade","weapon_smokegrenade",-1838.51,-1519.668,11776.031,-11.672,110.026,"custom_304",["throwType"]="JUMP",["destroyX"]=-1942.927,["destroyY"]=-1232.977,["destroyZ"]=12063.582,["landX"]=-436.212,["landY"]=-673.753,["landZ"]=11778.031,["flyDuration"]=7.391},{"T Corridor","51st Floor","grenade","weapon_flashbang",-1985.573,-583.329,11776.031,-24.014,50.294,"custom_314",["throwType"]="NORMAL",["flyDuration"]=3.125,["landX"]=-291.154,["landY"]=-319.501,["landZ"]=11778.031},{"A Ramp","Boxes","grenade","weapon_molotov",-879.968,-1232.072,11648.031,-33.88,48.585,"custom_509",["throwType"]="NORMAL",["landX"]=-175.591,["landY"]=-438.844,["landZ"]=11881.524},{"Elevator","B Siteoxes","grenade","weapon_molotov",-475.087,-272.674,11776.031,-24.442,-27.248,"custom_510",["throwType"]="NORMAL",["landX"]=-313.366,["landY"]=-639.545,["landZ"]=11826.024},{"Middle","T Corridor Up","grenade","weapon_hegrenade",-1940.778,472.654,11776.031,-18.344,-81.166,"custom_511",["throwType"]="NORMAL",["landX"]=-1786.125,["landY"]=-522.484,["landZ"]=11907.209},{"T Spawn","Middle","grenade","weapon_molotov",-1917.719,-652.624,11776.031,-19.36,90.896,"custom_512",["throwType"]="NORMAL",["landX"]=-1936.343,["landY"]=452.111,["landZ"]=11776.031},{"T Spawn","Middle","grenade","weapon_hegrenade",-1908.123,-649.528,11776.031,-19.021,92.733,"custom_513",["throwType"]="NORMAL",["landX"]=-1955.894,["landY"]=351.127,["landZ"]=11917.818},{"Back of A","B Siteoxes","grenade","weapon_molotov",-441.486,205.083,11776.031,-16.989,-53.047,"custom_514",["throwType"]="RUN",["runDuration"]=13,["landX"]=-296.6,["landY"]=-645.733,["landZ"]=11828.031},{"Back of A","Bombsite Left Boxes","grenade","weapon_molotov",-441.444,205.026,11776.031,-15.004,-53.047,"custom_515",["throwType"]="NORMAL",["landX"]=-145.215,["landY"]=-444.47,["landZ"]=11883.531},{"A Ramp","Bombsite Fence","grenade","weapon_molotov",-780.34,-847.146,11607.816,-80.158,144.48,"custom_516",["throwType"]="NORMAL",["throwStrength"]=0.5,["landX"]=-892.179,["landY"]=-767.55,["landZ"]=11776.031},{"A Ramp","A Site","grenade","weapon_molotov",-547.437,-1236.888,11684.217,-26.58,57.989,"custom_517",["throwType"]="NORMAL",["landX"]=-100.647,["landY"]=-358.733,["landZ"]=11776.031},{"A Site","A Ramp","grenade","weapon_molotov",-97.669,-257.869,11776.031,-17.868,-119.539,"custom_518",["throwType"]="NORMAL",["landX"]=-330.91,["landY"]=-1087.902,["landZ"]=11776.031},{"Side","Sandbags","grenade","weapon_molotov",-1135.969,-1106.695,11776.031,-20.142,-14.435,"custom_519",["throwType"]="NORMAL",["landX"]=-130.365,["landY"]=-1394.549,["landZ"]=11776.031},{"CT Spawn","Selfboost","movement","weapon_knife",-815.031,967.992,11776.031,33.22,-31.4,"custom_889",["data"]={11, {0.0, 0.0, "J"}, {0.0, 0.0, "", "J"}, 1, {0.0, 0.0, "L"}, {0.044, 0.044001}, {0.352, 0.044001}, {1.232, -0.220001}, {0.528, -0.088001}, {0.484, -0.220001}, {0.616, -0.176003}, {1.056, 0.0, "Z"}, {0.968, 0.088001}, {0.616, 0.044001}, {0.484, 0.0, "", "Z"}, {0.704, -0.044001}, {0.616, -0.132}, {1.144, -0.308002}, {1.496, -0.351997}, {0.88, -0.131996}, {1.628, -0.396}, {1.804, -0.836002}, {1.408, -0.615997}, {1.232, -0.484001}, {0.836, -0.396}, {0.66, -0.219997}, {0.836, -0.308002}, {0.792, -0.352005}, {0.396, -0.219997}, {0.44, -0.264004}, {0.66, -0.571999}, {0.66, -0.968002}, {0.704, -0.924}, {0.484, -0.703999}, {0.484, -0.747997}, {0.44, -0.659996}, {0.396, -0.924004}, {0.396, -0.880005}, {0.44, -0.967999}, {0.484, -0.924}, {0.528, -1.099998}, {0.44, -0.968002}, {0.572, -1.452}, {0.616, -1.363998}, {0.66, -1.408001}, {0.748, -1.540001}, {0.528, -1.408001}, {0.704, -1.056004}, {0.968, -1.144001}, {0.968, -2.024002}, {0.88, -2.067997}, {1.408, -2.684002}, {1.364, -2.904007, "", "L"}, {1.276, -3.255997}, {0.924, -2.728004}, {0.66, -2.376007}, {0.572, -2.463997}, {0.66, -2.112}, {0.528, -1.672005, "F"}, {0.308, -0.967995}, {0.22, -1.936005}, {0.044, -1.32}, {0.0, -1.187996}, {0.0, -0.484001}, {-0.132, -0.440002}, {-0.132, -0.396004}, {-0.176, -0.352005}, {-0.396, -0.484009}, {-0.836, -0.528008}, {-1.584, -0.572014, "J"}, {-2.816, 0.484001, "L", "J"}, {-3.52, 2.728004}, {-1.848, 1.848}, {-1.804, 2.375999, "", "F"}, {-1.848, 3.827995}, {-1.232, 5.896004}, {-0.44, 5.676003}, {-0.264, 4.531998}, {-0.176, 3.035999}, {-0.22, 5.543995}, {-0.132, 5.104}, {-0.088, 4.576}, {-0.088, 4.355999}, {-0.044, 3.431999}, {-0.044, 4.355997}, {0.0, 4.4}, {-0.132, 4.004002}, {-0.088, 3.871998}, {0.0, 3.344}, {0.044, 2.464001, "Z"}, {0.088, 2.64, "D"}, {0.044, 3.3}, {0.0, 3.432}, {-0.132, 3.124}, {-0.264, 4.268, "", "Z"}, {-0.924, 3.212}, {-0.88, 1.804, "F", "L"}, {-0.836, 0.308}, {-2.288, -2.068}, {-3.036, -4.62}, {-4.136, -8.14}, {-4.532, -8.755999}, {-5.148, -8.316}, {-3.124, -4.355999}, {-3.476, -5.324001}, {-2.244, -6.864002, "", "D"}, {-1.716, -7.612}, {-1.056, -4.619999}, {-0.132, -0.967999}, {0.088, 0.043999, "L"}, 2, {0.044, 0.220001}, {-0.088, 2.815998}, {-1.496, -0.307999, "S"}, {-1.056, -3.607998}, {-0.748, -7.084}, {-0.616, -5.939995, "", "L"}, {-0.484, -3.432007}, {-0.396, -3.740005}, {-0.484, -3.959999}, {-0.352, -5.016006}, {-0.088, -6.379997}, {-0.22, -4.576004}, {-2.464, -10.252007}, {-0.792, -4.268005}, {-0.968, -4.884003}, {-0.352, -1.584007}, {-0.44, -1.539993}, {-0.264, -0.967995, "L"}, {-0.352, -1.584}, {-0.396, -2.068008}, {-0.44, -2.024002}, {-0.352, -1.408005}, {-0.484, -1.980003}, {-0.44, -1.320007}, {-0.572, -1.540009}, {-0.308, -0.968002}, {-0.264, -0.527985}, {-0.264, -0.660004}, {-0.22, -0.791992}, {-0.176, -0.440002}, {-0.264, -0.703979, "", "F"}, {-0.264, -0.748016}, {-0.264, -0.792007}, {-0.088, -0.132004}, 7, {0.0, 0.0, "R", "L"}, 3, {0.0, 0.0, "", "R"}, 12}},{"Mid","Planks","movement","weapon_knife",-2025.519,-295.969,11828.031,57.112,79.912,"custom_890",["data"]={7, {0.0, 0.0, "F", "", 225.0}, 3, {0.0, -0.087997}, {0.484, 0.219994}, {0.308, 0.175995}, {0.616, 0.440002}, {0.484, 0.219994}, {0.396, 0.263992}, {0.88, 0.307999}, {0.924, 0.219994}, {0.748, 0.087997}, {0.704}, {0.44}, {0.748, -0.131996}, {0.528, -0.175995}, {0.528, -0.35199}, {0.484, -0.572006}, {0.44, -0.44001}, {0.352, -0.440002}, {0.176, -0.35199}, {0.044, -0.087997}, {0.0, -0.175995}, {-0.22, -0.572006}, {-0.44, -0.44001}, {-1.452, -0.924011}, {-1.32, -0.616005}, {-3.124, -0.880005}, {-4.268, -1.143997, "J"}, {-4.004, -0.528, "", "J"}, {-4.092, 0.571999, "L"}, {-3.872, 0.880005, "", "F"}, {-2.728, 1.012001}, {-2.068, 1.451996}, {-1.672, 2.904007}, {-0.968, 3.256004}, {-0.308, 2.332001}, {-0.176, 2.243996}, {-0.176, 2.287994}, {-0.044, 2.683998}, {0.0, 2.419998}, {0.088, 2.199997}, {0.396, 2.155998}, {0.44, 1.672005, "R", "", 0.0, 0.0}, {0.308, 0.528008, "", "L"}, {0.396, 0.175995}, {0.44, -0.616005}, {0.528, -1.408005}, {0.484, -3.124008}, {0.044, -1.32}, {-0.308, -1.628014}, {-0.396, -1.804008}, {-0.44, -1.584007, "L", "", 0.0, 0.0}, {-0.528, -1.32, "", "R"}, {-0.572, -0.220001}, {-0.396, 1.364006}, {-0.088, 2.331993}, {0.0, 1.935997, "RZ", "", 0.0, 0.0}, {0.484, 2.155998, "", "L"}, {0.528, 0.660004}, {0.968, 0.176003}, {1.056, -0.748001, "D"}, {0.484, -2.288002, "", "Z"}, {-0.132, -2.508003}, {-0.924, -2.375999}, {-1.232, -1.452003, "L", "R"}, {-1.32, -0.264}, {-1.32, 1.49601}, {-0.88, 2.200005}, {-1.1, 3.212006}, {-0.22, 0.0, "F", "", 225.0}, {-0.528, -0.307999, "", "L"}, {-1.628, -1.232002}, {-2.728, -1.848007}, {-2.992, -3.079994}, {-2.904, -3.740005}, {-2.2, -2.068001}, {-0.968, -0.660004}, 2, {0.0, 0.0, "L"}, 2, {-0.308, -0.087997}, {-0.044, -0.043999}, {0.0, -0.35199}, {0.22, -0.263992, "", "L"}, {0.22}, {0.132, 0.748009, "", "D"}, {0.0, 0.572006}, {0.0, 0.087997}, {0.0, -0.043999}, {-0.176, -1.188004}, {-1.232, -3.564003}, {-1.54, -4.928009}, {-1.364, -4.840004, "L", "", 450.0, -225.0}, {-0.616, -3.695999}, {-1.012, -4.707996}, {-0.748, -3.827995}, {-0.792, -3.739998}, {-1.1, -3.871998}, {-0.66, -2.288002}, {-0.704, -4.003998}, {-0.044, -2.419998, "", "F"}, {-0.044, -1.495998}, {-0.044, -2.639999}, {0.0, -1.759998}, {0.0, -1.363998}, {0.088, -1.452}, {0.176, -2.508001, "F"}, {0.044, -1.671999}, {0.0, -2.288}, {-0.088, -2.860001}, {-0.132, -0.440001, "", "F"}, {-0.044, -0.264}, {-0.044, -0.175999}, {-0.308, -0.792}, {-0.176, -0.923998}, {-0.176, -0.616001}, {-0.044, -0.351999}, {-0.044, -0.219999}, {0.0, -0.044001}, 5, {-0.044, -0.087999}, {-0.308, -0.088001}, {-0.352, -0.088001, "R", "L"}, {-0.396, -0.044001}, {-0.264}, 1, {-0.044, 0.0, "", "R"}, {0.0, 0.088001}}}} end
		if map == "de_abbey" then locations_data={{"Field","Middle connector","grenade","weapon_smokegrenade",-4207.181,2413.969,-87.056,-16.214,-75.217,"custom_315",["throwType"]="JUMP"},{"Field","Wine cellar","grenade","weapon_smokegrenade",-4347.969,2126.031,-27.114,-23.298,-78.245,"custom_316",["throwType"]="NORMAL",["landX"]=-2561.349,["landY"]=313.92,["landZ"]=11778.442,["flyDuration"]=4.531},{"Right Alley","Back of A","grenade","weapon_smokegrenade",-3584.031,2415.969,-85.082,-7.326,-108.803,"custom_317",["throwType"]="JUMP"},{"Field","Restroom","grenade","weapon_molotov",-4347.969,2215.985,-30.821,-14.762,-92.128,"custom_318",["throwType"]="NORMAL"},{"Barn","A Site","grenade","weapon_flashbang",-3854.114,1461.428,-24.616,-46.366,107.088,"custom_319",["throwType"]="NORMAL",["landX"]=-1521.473,["landY"]=197.291,["landZ"]=-165.969,["flyDuration"]=6.453},{"A Ramp","Long A","grenade","weapon_flashbang",-4524.305,2382.82,-32.62,-25.686,-114.62,"custom_320",["throwType"]="NORMAL",["landX"]=-1439.161,["landY"]=441.403,["landZ"]=-165.969,["flyDuration"]=6.391},{"River","Balcony","grenade","weapon_smokegrenade",-3030.485,2903.095,-91.969,-23.97,-86.592,"custom_321",["throwType"]="JUMP",["landX"]=-1716.15,["landY"]=51.344,["landZ"]=-166.726,["flyDuration"]=8.234},{"Middle Arch","Middle Connector","grenade","weapon_smokegrenade",-2192.031,2455.969,1.031,-6.282,-121.528,"custom_322",["throwType"]="JUMP",["landX"]=-92.762,["landY"]=-1646.597,["landZ"]=-165.969,["flyDuration"]=6.969},{"Back Alley","Gate","grenade","weapon_smokegrenade",-1344.031,1978.031,1.198,-30.526,-100.388,"custom_323",["throwType"]="NORMAL",["duck"]=true},{"Back Alley","Gate House","grenade","weapon_smokegrenade",-1465.906,1720.031,2.041,-45.816,-84.864,"custom_324",["throwType"]="NORMAL"},{"Back Alley","T Ramp","grenade","weapon_flashbang",-966.014,1911.969,5.69,-26.654,-130.104,"custom_325",["throwType"]="NORMAL"},{"House","Street","grenade","weapon_flashbang",-1134.969,1008.031,0.031,-37.609,17.119,"custom_326",["throwType"]="NORMAL",["throwStrength"]=0.5,["landX"]=-491.712,["landY"]=-697.314,["landZ"]=11778.031,["flyDuration"]=3.328},{"CT","Middle","grenade","weapon_smokegrenade",-2787.03,-163.969,66.031,-3.664,80.697,"custom_327",["throwType"]="JUMP",["landX"]=-232.794,["landY"]=-534.215,["landZ"]=11765.223,["flyDuration"]=3.109},{"Stairs","B Site","grenade","weapon_smokegrenade",-2167.956,833.014,-158.969,-41.174,-43.369,"custom_328",["throwType"]="NORMAL"},{"Underpass","T Ramp","grenade","weapon_smokegrenade",-2189.969,693.556,-158.969,-46.893,-9.855,"custom_329",["throwType"]="NORMAL"},{"Banana","Back of B","grenade","weapon_smokegrenade",-2214.4,-676.54,2.459,-57.607,40.811,"custom_330",["throwType"]="NORMAL",["duck"]=true},{"Banana","T Ramp","grenade","weapon_smokegrenade",-2214.4,-676.54,2.459,-61.766,58.938,"custom_331",["throwType"]="NORMAL"},{"Bridge","Barn","grenade","weapon_smokegrenade",-3152.406,656.081,-50.293,-59.94,142.648,"custom_332",["throwType"]="NORMAL",["duck"]=true},{"Bridge","A Site","grenade","weapon_smokegrenade",-2639.969,844.467,-62.495,-8.812,179.257,"custom_333",["throwType"]="JUMP"}} end
		if map == "de_shortdust" then locations_data={{"Ramp","Car","grenade","weapon_molotov",-1265.967,1011.667,-171.785,-4.884,-22.028,"custom_431",["throwType"]="JUMP",["landX"]=-10.726,["landY"]=503.817,["landZ"]=7.031},{"Stairs","Car","grenade","weapon_molotov",-1374.51,1379.159,0.031,-19.439,-41.003,"custom_432",["throwType"]="RUN",["runDuration"]=15,["landX"]=-115.568,["landY"]=487.39,["landZ"]=0.031},{"Catwalk","Car","grenade","weapon_molotov",-861.969,957.954,0.031,-18.778,-45.553,"custom_433",["throwType"]="RUN",["runDuration"]=2,["landX"]=-77.851,["landY"]=619.364,["landZ"]=72.957},{"Tunnel","Bombsite","grenade","weapon_molotov",665.653,1101.734,32.031,-6.832,147.989,"custom_434",["throwType"]="RUN",["runDuration"]=5,["landX"]=-160.87,["landY"]=1399.604,["landZ"]=34.031},{"Ramp","Car","grenade","weapon_molotov",-1220.354,1014.813,-180.355,-4.147,-24.883,"custom_467",["throwType"]="JUMP",["landX"]=3.394,["landY"]=449.882,["landZ"]=1.07},{"Ramp","Up Down","grenade","weapon_molotov",-564.949,638.801,-110.819,4.862,135.277,"custom_468",["throwType"]="JUMP",["landX"]=-1414.927,["landY"]=1331.346,["landZ"]=2.031},{"Tunnel","Bombsite","grenade","weapon_molotov",657.565,1107.991,32.031,-5.918,148.059,"custom_469",["throwType"]="RUN",["runDuration"]=8,["landX"]=-162.392,["landY"]=1391.446,["landZ"]=34.031},{"Tunnel","Terrace","grenade","weapon_molotov",-234.031,1852.081,32.031,-6.149,-45.364,"custom_470",["throwType"]="RUN",["runDuration"]=13,["landX"]=607.033,["landY"]=1227.092,["landZ"]=34.031},{"Tunnel","Bombsite","grenade","weapon_molotov",695.974,1296.29,32.031,-6.38,-160.144,"custom_471",["throwType"]="RUN",["runDuration"]=9,["landX"]=-10.304,["landY"]=1266.373,["landZ"]=34.031}} end
		if map == "gd_rialto" then locations_data={{"Connector","Roof","grenade","weapon_molotov",453.58,607.342,141.694,-39.6,-136.824,"custom_458",["throwType"]="NORMAL",["landX"]=-195.529,["landY"]=0.241,["landZ"]=557.031},{"Right Alley","Roof","grenade","weapon_molotov",458.876,312.259,215.464,-27.192,-153.817,"custom_459",["throwType"]="JUMP",["throwStrength"]=0.5,["landX"]=-214.709,["landY"]=-28.009,["landZ"]=544.386},{"Connector 2","Roof","grenade","weapon_molotov",319.249,743.969,96.031,-44.616,-124.856,"custom_460",["throwType"]="NORMAL",["landX"]=-190.912,["landY"]=15.857,["landZ"]=550.582},{"Connector 3","Roof","grenade","weapon_molotov",273.888,743.996,96.031,-44.792,-123.2,"custom_461",["throwType"]="NORMAL",["landX"]=-216.195,["landY"]=-14.018,["landZ"]=551.52},{"Right Alley - Center","Roof","grenade","weapon_molotov",453.873,257.445,229.165,-16.456,-149.529,"custom_462",["throwType"]="JUMP",["throwStrength"]=0.5,["landX"]=-258.883,["landY"]=-165.534,["landZ"]=458.128},{"Roof","A Site","grenade","weapon_molotov",-250.898,-55.573,533.855,12.408,6.975,"custom_463",["throwType"]="NORMAL",["duck"]=true,["landX"]=-212.276,["landY"]=28.569,["landZ"]=226.031},{"Second roof","A Site","grenade","weapon_molotov",256.474,-94.077,514.217,8.096,165.639,"custom_464",["throwType"]="NORMAL",["duck"]=true,["landX"]=225.971,["landY"]=84.868,["landZ"]=226.031},{"CT Side Lower","Roof","grenade","weapon_molotov",278.433,-745.978,96.031,-44.176,125.969,"custom_465",["throwType"]="NORMAL",["landX"]=-252.655,["landY"]=-25.594,["landZ"]=545.617},{"CT Side Lower","Roof","grenade","weapon_molotov",-203.273,-751.003,96.031,-51.424,93.329,"custom_466",["throwType"]="NORMAL",["landX"]=-248.633,["landY"]=38.221,["landZ"]=539.178}} end
		if map == "de_cache" then locations_data={{"Vent Room","B Main","grenade","weapon_flashbang",5.56,-412.969,1614.031,-18.305,50.405,"custom_492",["throwType"]="NORMAL",["landX"]=369.783,["landY"]=-515.723,["landZ"]=1619.726},{"Garage","Middle","grenade","weapon_flashbang",929.831,130.674,1613.031,-22.005,107.772,"custom_493",["throwType"]="NORMAL",["landX"]=857.006,["landY"]=297.583,["landZ"]=1682.773},{"Whitebox","Middle (Popflash)","grenade","weapon_flashbang",-69.031,549.195,1628.514,-44.288,85.468,"custom_494",["throwType"]="RUN",["runDuration"]=3,["landX"]=-39.283,["landY"]=354.489,["landZ"]=1652.472},{"Squeaky","Site (Popflash)","grenade","weapon_flashbang",153.031,2085.054,1688.031,-17.445,82.637,"custom_495",["throwType"]="NORMAL",["landX"]=228.387,["landY"]=1981.741,["landZ"]=1690.327},{"Middle","Vent Room","grenade","weapon_flashbang",496.496,48.814,1765.178,-39.563,-119.185,"custom_496",["throwType"]="NORMAL",["landX"]=307.116,["landY"]=-283.757,["landZ"]=1966.271},{"B Hall","Vent Room","grenade","weapon_flashbang",1109.969,-884.83,1614.031,-8.734,177.749,"custom_497",["throwType"]="RUN",["runDuration"]=64,["landX"]=326.399,["landY"]=-419.073,["landZ"]=1631.533},{"B Hall","B Main","grenade","weapon_smokegrenade",1159.149,-746.743,1614.031,-16.228,-135.441,"custom_498",["throwType"]="RUN",["landX"]=212.371,["landY"]=-684.134,["landZ"]=1616.031},{"B Hall","Vent Room","grenade","weapon_molotov",1108.948,-884.74,1614.031,-8.874,177.597,"custom_499",["throwType"]="RUN",["runDuration"]=64,["landX"]=326.243,["landY"]=-444.748,["landZ"]=1616.031},{"Z","Boost","grenade","weapon_molotov",-260.031,-72.969,1662.031,2.194,28.817,"custom_500",["throwType"]="JUMP",["landX"]=883.434,["landY"]=586.876,["landZ"]=1806.16},{"Car","Quad","grenade","weapon_molotov",-999.807,906.335,1668.084,2.528,63.789,"custom_501",["throwType"]="JUMP",["landX"]=-385.964,["landY"]=2150.338,["landZ"]=1687.0},{"Toxic","Headshot","grenade","weapon_molotov",972.99,-1252.956,1613.015,-24.965,179.101,"custom_502",["throwType"]="RUN",["runDuration"]=2,["landX"]=-322.711,["landY"]=-1230.864,["landZ"]=1672,["destroyX"]=232.031,["destroyY"]=-1246.318,["destroyZ"]=1889.485,["destroyText"]="Break the right window"},{"Quad","Car","grenade","weapon_molotov",-328.969,2274.969,1687.031,-13.397,-122.173,"custom_503",["throwType"]="RUN",["runDuration"]=5,["landX"]=-960.392,["landY"]=1233.896,["landZ"]=1687},{"Vent","Window","grenade","weapon_molotov",605.206,-148.969,1690.179,-16.578,159.064,"custom_504",["throwType"]="NORMAL",["landX"]=-341.158,["landY"]=213.092,["landZ"]=1796.372},{"B Hall","B Hall (Box)","wallbang","weapon_wallbang",1111.658,-619.171,1614.031,0.497,176.88,"custom_505"},{"Under Heaven","B Hall","wallbang","weapon_wallbang",-535.198,-176.31,1614.031,0.446,-32.018,"custom_506"},{"Z","Middle","wallbang","weapon_wallbang",-550.969,278.994,1665.031,2.348,-3.117,"custom_507"},{"A Main","A Box","wallbang","weapon_wallbang",761.98,1250.241,1702.031,-1.743,169.302,"custom_508",["duck"]=true},{"Vent","Boost Boxes","grenade","weapon_molotov",588.698,-148.896,1748.063,1.563,95.59,"custom_521",["throwType"]="RUNJUMP",["runDuration"]=27,["landX"]=408.39,["landY"]=1896.215,["landZ"]=1798.509},{"Middle","Vent Room","grenade","weapon_molotov",-242.131,-73.98,1703.031,-69.242,-102.969,"custom_522",["throwType"]="JUMP",["landX"]=-307.669,["landY"]=-358.551,["landZ"]=1728.399},{"Dumpster","Vent Room","grenade","weapon_smokegrenade",1316.969,-188.005,1612.903,-24.414,-176.578,"custom_523",["throwType"]="JUMP",["duck"]=true,["landX"]=140.797,["landY"]=-326.131,["landZ"]=1616.031},{"Vent Room","Middle","grenade","weapon_smokegrenade",-411.969,-412.994,1614.875,-49.243,31.239,"custom_524",["throwType"]="NORMAL",["landX"]=871.462,["landY"]=280.477,["landZ"]=1616.031},{"Vent","Vent Room","grenade","weapon_flashbang",579.762,-71.707,1744.401,-45.76,-149.655,"custom_525",["throwType"]="NORMAL",["landX"]=201.611,["landY"]=-372.095,["landZ"]=1871.508},{"B Halls","B Main","wallbang","weapon_wallbang",1136.44,-600.012,1614.032,0.879,179.758,"custom_526"},{"Car","Quad","wallbang","weapon_wallbang",-1086.999,906.267,1689.91,0.365,57.549,"custom_527"},{"Car","Default","wallbang","weapon_wallbang",-575.044,1499.969,1709.013,1.991,36.052,"custom_528"},{"Car","Quad","wallbang","weapon_wallbang",-575.044,1499.969,1709.013,2.165,68.594,"custom_529"},{"Main A","Balcony","wallbang","weapon_wallbang",761.984,1296.368,1702.031,-24.661,-179.017,"custom_530"},{"Main A","Forklift","wallbang","weapon_wallbang",761.984,1296.304,1702.045,2.357,-177.766,"custom_531"},{"Main A","Forklift","wallbang","weapon_wallbang",761.984,1296.241,1702.045,1.36,174.171,"custom_532"},{"Long A","Car","wallbang","weapon_wallbang",1302.969,2007.969,1703.042,0.414,-156.512,"custom_533"},{"Long A","Car","wallbang","weapon_wallbang",962.179,2039.574,1703.844,0.734,-138.912,"custom_534"},{"Catwalk","Garage","grenade","weapon_flashbang",-52.024,480.95,1671.569,-23.452,-8.1,"custom_535",["throwType"]="NORMAL",["landX"]=886.755,["landY"]=347.196,["landZ"]=1890.299},{"Long A","Window","grenade","weapon_molotov",1809.933,741.173,1613.031,-1.384,-166.164,"custom_536",["throwType"]="RUNJUMP",["runDuration"]=64,["landX"]=-345.922,["landY"]=211.561,["landZ"]=1792.951},{"Car","Quad","grenade","weapon_molotov",-897.083,1349.239,1687.031,-19.187,58.918,"custom_537",["throwType"]="NORMAL",["landX"]=-298.536,["landY"]=2235.771,["landZ"]=1687.0},{"Catwalk","Forklift","grenade","weapon_molotov",-325.969,914.376,1690.371,-37.958,46.637,"custom_538",["throwType"]="NORMAL",["landX"]=183.378,["landY"]=1437.323,["landZ"]=1814.669},{"Toxic","Barrels","grenade","weapon_smokegrenade",942.805,-1464.962,1711.031,-20.573,163.811,"custom_539",["throwType"]="NORMAL",["landX"]=-329.584,["landY"]=-1040.019,["landZ"]=1661.031,["destroyX"]=232.031,["destroyY"]=-1246.318,["destroyZ"]=1889.485,["destroyText"]="Break the right window"},{"Toxic","B Site","grenade","weapon_smokegrenade",904.527,-1464.969,1711.04,-14.514,162.148,"custom_540",["throwType"]="NORMAL",["duck"]=true,["landX"]=-15.377,["landY"]=-1093.464,["landZ"]=1661.031,["destroyX"]=232.031,["destroyY"]=-1246.318,["destroyZ"]=1889.485,["destroyText"]="Break the right window"},{"Toxic","CT","grenade","weapon_smokegrenade",957.031,-1464.991,1648.031,-26.355,162.982,"custom_541",["throwType"]="NORMAL",["landX"]=-546.628,["landY"]=-908.705,["landZ"]=1616.031,["destroyX"]=232.031,["destroyY"]=-1246.318,["destroyZ"]=1889.485,["destroyText"]="Break the right window"},{"B Entrance","Vent","wallbang","weapon_wallbang_light",-1066.969,-376.993,1614.031,-4.222,4.51,"custom_542"},{"Back","Long Hall","wallbang_hvh","weapon_wallbang",1621.243,-867.233,1613.031,0.044,179.926,"custom_719",["duck"]=true},{"Forklift","A Main","wallbang_hvh","weapon_wallbang",336.125,1352.463,1689.867,-0.719,-29.292,"custom_720"},{"Car Box","A Main","wallbang_hvh","weapon_wallbang",-610.355,1499.969,1703.256,0.613,-9.35,"custom_721",["duck"]=true},{"A Site (Tank)","A Main","wallbang_hvh","weapon_wallbang",-153.876,1598.157,1816.518,7.993,-24.234,"custom_722",["duck"]=true},{"A Site (Boost)","A Main","wallbang_hvh","weapon_wallbang",445.641,2018.714,1875.031,15.244,-73.673,"custom_723"},{"A Site (Catwalk)","A Main","wallbang_hvh","weapon_wallbang",102.287,1386.281,1888.031,19.521,-13.843,"custom_724"},{"A Site (Back Boxes)","Squeaky","wallbang_hvh","weapon_wallbang",-172.775,2030.927,1811.031,10.797,10.13,"custom_725"},{"A Site (Forklift)","Squeaky / A Main","wallbang_hvh","weapon_wallbang",216.758,1375.995,1693.018,1.1,86.786,"custom_726",["duck"]=true},{"A Site (Catwalk)","Car","wallbang_hvh","weapon_wallbang",460.983,1407.007,1847.031,5.746,-166.951,"custom_727"},{"Electrical Box","A Main","wallbang_hvh","weapon_wallbang",-380.603,1111.031,1792.288,4.098,25.193,"custom_728",["duck"]=true},{"A Site (Back Boxes)","Car","wallbang_hvh","weapon_wallbang",-361.774,2052.906,1816.031,5.805,-117.722,"custom_729",["duck"]=true},{"T Spawn / Back","Long Hall","wallbang_hvh","weapon_wallbang",2486.69,-578.634,1740.031,4.08,-170.312,"custom_730"},{"T Spawn","A Main","wallbang_hvh","weapon_wallbang",2789.445,367.996,1623.832,-1.417,168.122,"custom_731"},{"CT Spawn (Entrance)","CT Spawn","wallbang_hvh","weapon_wallbang",-1010.892,-16.602,1622.031,0.976,122.916,"custom_732",["duck"]=true},{"CT Spawn (Entrance)","Car","wallbang_hvh","weapon_wallbang",-1066.969,-72.489,1618.228,-1.887,81.591,"custom_733",["duck"]=true},{"CT Spawn (Entrance)","B Site (Entrance)","wallbang_hvh","weapon_wallbang",-1066.973,75.432,1622.031,1.328,-65.552,"custom_734",["duck"]=true},{"CT Spawn (Entrance)","Long Hall","wallbang_hvh","weapon_wallbang",-466.031,-218.281,1614.044,1.733,-34.75,"custom_735"},{"Storage Room","Long Hall","wallbang_hvh","weapon_wallbang",-376.929,-306.159,1614.031,1.504,-29.89,"custom_736"},{"Car","A Main","wallbang_hvh","weapon_wallbang",-913.031,1041.309,1684.195,0.067,24.567,"custom_737",["duck"]=true},{"Middle","A Main (Entrance)","wallbang_hvh","weapon_wallbang",-18.895,-148.963,1668.651,-0.009,52.01,"custom_738"},{"Car","A Site","grenade","weapon_molotov",-982.07,790.646,1654.266,-18.224,67.46,"custom_739",["throwType"]="RUN",["runDuration"]=29,["landX"]=-354.045,["landY"]=1802.025,["landZ"]=1687.001},{"Car","Middle","grenade","weapon_molotov",-969.038,914.403,1669.048,-17.843,50.943,"custom_740",["throwType"]="RUN",["landX"]=-161.169,["landY"]=1188.029,["landZ"]=1689.032},{"Car","Catwalk / Forklift","grenade","weapon_molotov",-1073.969,957.009,1675.013,-3.479,18.569,"custom_741",["throwType"]="JUMP",["landX"]=212.014,["landY"]=1389.19,["landZ"]=1847},{"Car","Squeaky","grenade","weapon_molotov",-1008.383,963.819,1674.949,-14.989,38.772,"custom_742",["throwType"]="RUN",["runDuration"]=28,["landX"]=210.041,["landY"]=2043.231,["landZ"]=1687.56},{"Middle","Garage","grenade","weapon_molotov",-292.561,677.193,1648.094,-9.099,-39.296,"custom_743",["throwType"]="RUN",["runDuration"]=28,["landX"]=757.224,["landY"]=279.986,["landZ"]=1616.031},{"Middle","Inner Vents","grenade","weapon_molotov",-277.022,696.377,1651.038,-15.963,-45.402,"custom_744",["throwType"]="RUN",["runDuration"]=28,["landX"]=441.517,["landY"]=-304.82,["landZ"]=1751.031},{"Car","A Main","grenade","weapon_smokegrenade",-910.343,1078.265,1687.031,-18.513,23.438,"custom_745",["throwType"]="NORMAL",["landX"]=544.784,["landY"]=1709.092,["landZ"]=1704.031},{"Garage","Whitebox","wallbang","weapon_wallbang",1711.0,-132.978,1676.958,0.554,160.315,"custom_746"},{"Garage","Window","wallbang","weapon_wallbang_light",1711,-132.978,1676.958,-2.155,169.669,"custom_747"},{"T Spawn","Boost (Oneway)","grenade","weapon_smokegrenade",2301.969,253.957,1613.031,-26.971,146.177,"custom_748",["throwType"]="RUNJUMP",["runDuration"]=1,["landX"]=829.677,["landY"]=591.586,["landZ"]=1812.274},{"Quad","Car (Popflash)","grenade","weapon_flashbang",-328.969,2274.969,1687.031,-31.032,-122.545,"custom_749",["throwType"]="NORMAL"},{"Quad","Car","grenade","weapon_hegrenade",-328.969,2274.969,1687.031,11.281,-121.183,"custom_750",["throwType"]="RUNJUMP",["runDuration"]=14,["landX"]=-904.412,["landY"]=1130.64,["landZ"]=1699.02},{"Garage","Window","grenade","weapon_molotov",1819.974,847.974,1624.614,-0.274,-163.677,"custom_751",["throwType"]="RUNJUMP",["runDuration"]=75,["landX"]=-343.972,["landY"]=222.258,["landZ"]=1796.372},{"Garage","Z","grenade","weapon_smokegrenade",1819.974,847.974,1624.614,-0.88,-163.088,"custom_752",["throwType"]="RUNJUMP",["runDuration"]=72,["landX"]=-264.855,["landY"]=29.329,["landZ"]=1664.031},{"Car","Quad","grenade","weapon_molotov",-854.547,951.99,1719.345,4.905,68.18,"custom_753",["throwType"]="JUMP",["duck"]=true,["landX"]=-340.59,["landY"]=2235.643,["landZ"]=1687.0},{"Heaven","B Hall","grenade","weapon_smokegrenade",-461.031,-764.969,1796.963,-15.302,38.51,"custom_754",["throwType"]="NORMAL"},{"Heaven","B Main","grenade","weapon_smokegrenade",-616.969,-765.0,1796.031,16.037,6.385,"custom_755",["throwType"]="NORMAL",["landX"]=254.147,["landY"]=-667.532,["landZ"]=1616.031},{"Long A","Vent","grenade","weapon_molotov",1292.413,1324.292,1709.317,-20.384,-116.672,"custom_756",["throwType"]="RUN",["runDuration"]=15,["landX"]=525.503,["landY"]=-271.865,["landZ"]=1749.031},{"Z","Boost","grenade","weapon_flashbang",-682.791,140.031,1633.172,3.267,16.557,"custom_757",["throwType"]="RUNJUMP",["runDuration"]=32,["landX"]=956.382,["landY"]=627.341,["landZ"]=1853.187},{"Garage","Sandbags","grenade","weapon_molotov",1525.52,974.969,1622.08,2.299,-145.052,"custom_758",["throwType"]="RUNJUMP",["runDuration"]=13,["landX"]=-2.446,["landY"]=-94.245,["landZ"]=1619.237},{"Vent Room","Middle","grenade","weapon_flashbang",-339.031,-412.969,1614.031,-65.582,72.118,"custom_759",["throwType"]="NORMAL",["landX"]=-212.655,["landY"]=-21.273,["landZ"]=2289.5},{"B Hall","Heaven","wallbang","weapon_wallbang",1109.992,-1001.574,1614.031,-5.591,168.498,"custom_760"},{"Vent Room","Headshot","wallbang","weapon_wallbang",1109.992,-1001.574,1614.031,-5.591,168.498,"custom_761"},{"Toxic","B Site","grenade","weapon_molotov",548.803,-1227.031,1615.067,-8.054,-113.248,"custom_762",["throwType"]="JUMP",["landX"]=-26.322,["landY"]=-1381.471,["landZ"]=1661.031,["destroyStartX"]=392.701,["destroyStartY"]=-1442.725,["destroyStartZ"]=1936.638,["destroyX"]=232.031,["destroyY"]=-1425.989,["destroyZ"]=1899.578,["destroyText"]="Break the left window"},{"Toxic","B Default","grenade","weapon_molotov",957.031,-1464.946,1648.031,-20.868,166.979,"custom_763",["throwType"]="NORMAL",["landX"]=-211.28,["landY"]=-1202.74,["landZ"]=1659,["destroyX"]=232.031,["destroyY"]=-1313.641,["destroyZ"]=1889.485,["destroyText"]="Break the center windows"},{"NBK","Main (Popflash)","grenade","weapon_flashbang",87.985,2223.131,1687.031,-25.643,106.482,"custom_764",["throwType"]="RUN",["runDuration"]=1,["runYaw"]=180,["landX"]=57.034,["landY"]=1834.126,["landZ"]=1926.349},{"CT Spawn","Middle","grenade","weapon_smokegrenade",-1102.886,156.396,1614.09,-20.142,2.543,"custom_765",["throwType"]="RUN",["runDuration"]=41,["landX"]=940.666,["landY"]=261.137,["landZ"]=1616.031},{"T Spawn","Window","wallbang","weapon_wallbang",2736.004,383.969,1676.031,-1.414,-177.399,"custom_766"},{"Garage","Z","wallbang","weapon_wallbang",1710.967,58.549,1613.051,-1.448,-179.792,"custom_767"},{"Squeaky","Barrels","wallbang","weapon_wallbang",332.377,2312.99,1688.031,-0.247,-109.854,"custom_768",["duck"]=true},{"Quad","A Site","grenade","weapon_smokegrenade",-328.969,2274.969,1687.031,-5.472,-109.403,"custom_769",["landX"]=-321.828,["landY"]=1573.265,["landZ"]=1689.033},{"Quad","Main","grenade","weapon_smokegrenade",-328.969,2274.969,1687.031,-2.931,-34.438,"custom_770",["throwType"]="NORMAL",["landX"]=521.892,["landY"]=1691.546,["landZ"]=1704.031},{"Quad","Highway","grenade","weapon_smokegrenade",-328.969,2274.969,1687.031,-1.721,-81.26,"custom_771",["throwType"]="JUMP",["throwStrength"]=0.5,["landX"]=-131.34,["landY"]=989.504,["landZ"]=1689.031},{"Long A","Quad","wallbang","weapon_wallbang_light",1318.969,1212.031,1747.708,2.143,148.415,"custom_772"},{"Vent Room","Vent","grenade","weapon_molotov",425.969,-413.986,1614.753,-23.453,83.525,"custom_773",["throwType"]="NORMAL",["landX"]=438.492,["landY"]=-277.617,["landZ"]=1728.031},{"Long A","A Site","grenade","weapon_smokegrenade",1318.99,1565.969,1765.031,-49.125,176.345,"custom_774",["throwType"]="NORMAL",["landX"]=-327.07,["landY"]=1671.11,["landZ"]=1689.033},{"Long A","Highway","grenade","weapon_smokegrenade",1318.969,1356.031,1771.031,-44.769,-169.044,"custom_775",["throwType"]="NORMAL"},{"Heaven","Vent Room","grenade","weapon_smokegrenade",-616.973,-578.445,1758.79,-12.946,-45.073,"custom_776",["throwType"]="NORMAL",["duck"]=true},{"Middle","Window","grenade","weapon_smokegrenade",605.206,-148.969,1690.179,-16.874,157.238,"custom_777",["throwType"]="NORMAL",["landX"]=-325.245,["landY"]=240.718,["landZ"]=1795.022},{"Middle","Window","grenade","weapon_smokegrenade",1204.948,672.273,1613.024,-9.278,-162.456,"custom_778",["throwType"]="RUNJUMP",["runDuration"]=1,["runYaw"]=180,["landX"]=-321.605,["landY"]=191.581,["landZ"]=1795.008},{"Middle","Window","grenade","weapon_smokegrenade",779.969,577.969,1613.031,-28.814,-160.58,"custom_779",["throwType"]="NORMAL",["landX"]=-327.909,["landY"]=190.731,["landZ"]=1795.031},{"Middle","Window","grenade","weapon_smokegrenade",1281.969,-415.969,1612.031,-60.314,157.733,"custom_780",["throwType"]="RUN",["runDuration"]=2,["landX"]=-80.374,["landY"]=1171.943,["landZ"]=1849.031},{"Whitebox","Boost","movement","weapon_knife",281.306,474.969,1761.031,3.299,-4.278,"custom_788",["data"]={{0, 0, "F"}, {0.098999977111816}, {0.13199996948242}, {0.19799995422363, 0.098999977111816}, {0.13199996948242}, {0.23099994659424, 0.032999992370605}, {0.13199996948242}, {0.16499996185303}, {0.13199996948242, 0.065999984741211}, {0.13199996948242}, {0.065999984741211}, {0.098999977111816}, {0.19799995422363}, {0.16499996185303}, {0.098999977111816}, {0.19799995422363}, {0.098999977111816}, {0.32999992370605}, {0.6269998550415, -0.098999977111816}, {0.46199989318848, -0.098999977111816}, {1.1549997329712, -0.13199996948242}, {0.32999992370605, -0.098999977111816}, {0.82499980926514, -0.032999992370605}, {0.39599990844727, -0.13199996948242}, {0.46199989318848, -0.23099994659424}, {0.19799995422363, -0.16499996185303}, {0.36299991607666, -0.29699993133545}, {0.16499996185303, -0.16499996185303}, {0.32999992370605, -0.29699993133545}, {0.23099994659424, -0.16499996185303}, {0.32999992370605, -0.26399993896484}, {0.23099994659424, -0.16499996185303}, {0.29699993133545, -0.16499996185303}, {0.29699993133545, -0.13199996948242}, {0.29699993133545, -0.16499996185303}, {0.65999984741211, -0.26399993896484}, {0.39599990844727, -0.16499996185303}, {0.36299991607666, -0.19799995422363}, {0.52799987792969, -0.13199996948242}, {0.29699993133545, -0.065999984741211}, {0.26399993896484}, {0.42899990081787, -0.032999992370605}, {0.49499988555908}, {0.23100090026855}, {0.23100090026855}, {0.16500091552734}, {0.19800186157227, 0.19799995422363, "J"}, {0.29700088500977, 0.36299991607666, "", "J"}, {0.26399993896484, 0.52799987792969}, {0.36300086975098, 0.89099979400635}, {0.33000183105469, 0.98999977111816, "L"}, {0.26399993896484, 1.4189999103546}, {0.29700088500977, 3.2339999675751}, 1, {0.16500091552734, 3.3329999446869, "", "F"}, {0.13200187683105, 2.9700000286102}, {0.066001892089844, 3.1020002365112}, {0, 2.8379993438721}, {0, 2.342999458313}, {0, 2.5409994125366}, {0, 3.2670001983643}, {0.066001892089844, 3.2339992523193}, {0.13199996948242, 2.4420013427734}, {0, 1.6499996185303}, {0, 3.5639991760254}, {-0.065999984741211, 3.234001159668}, {-0.13199996948242, 1.814998626709}, {-0.23100090026855, 3.1679992675781}, {-0.19799995422363, 3.6300010681152}, {-0.23100090026855, 2.9700012207031}, {-0.13200187683105, 2.5080032348633}, {-0.23100090026855, 4.0260009765625}, {-0.19799995422363, 2.9370002746582}, {-0.19800186157227, 3.2999992370605}, {-0.3960018157959, 4.2239990234375}, {-0.23100090026855, 2.4419975280762}, {-0.4950008392334, 3.8940048217773}, {-0.46199989318848, 3.5640029907227}, {-0.42900085449219, 2.3759994506836}, {-0.52799987792969, 3.3000030517578}, {-0.52799987792969, 2.6070022583008}, {-0.6269998550415, 2.9700088500977}, {-0.5939998626709, 2.640007019043}, {-0.6269998550415, 2.6070022583008}, {-1.2869997024536, 4.2900009155273}, {-0.32999992370605, 1.0559997558594}, {-0.95699977874756, 2.7720031738281}, {-0.89099979400635, 2.4749984741211}, {-1.1219997406006, 2.7060012817383}, {-0.69299983978271, 1.3199996948242}, {-0.85799980163574, 1.4189987182617}, {-0.6269998550415, 0.85800170898438}, {-0.52799987792969, 0.69300842285156}, {-0.46199989318848, 0.46199798583984, "D"}, {-0.32999992370605, 0.13199615478516}, {-0.36299991607666, 0.065994262695313}, {-0.29699993133545, 0.065994262695313}, {-0.29699993133545, 0.065994262695313}, {-0.19799995422363, 0.066001892089844}, {-0.23099994659424, 0.065994262695313}, {-0.19799995422363}, {-0.16499996185303}, {-0.23099994659424}, {-0.032999992370605}, {-0.032999992370605}, {-0.065999984741211}}},{"WhiteBox","Boost","movement","weapon_knife",56.253,473.287,1761.031,2.278,-2.944,"custom_790",["data"]={{0, 0, "F"}, {0.066, 0.099}, {0.066, 0.033}, {0.033, 0.033}, {0.033, 0.033}, {0.033, 0.033}, {0.033, 0.033}, {0.033, 0.066}, {0, 0.066}, {0.033}, {0.033, 0.033}, {0.066, 0.033}, {0.066, 0.132}, {0.132, 0.264}, {0, 0.033}, {0.099, 0.132}, {0.033, 0.132}, {0.099, 0.099}, {0.033, 0.066}, {0.033, 0.066}, {0.033, 0.099}, {0.033, 0.099}, {0.033, 0.099}, {0.066, 0.099}, {0, 0.066}, {0.066}, {0.033, 0.033}, {0, 0.099}, {0, 0.033}, {0.033, 0.033}, {0.066, 0.033}, {0.066, 0.098999}, {0.066, 0.132}, {0.066, 0.033}, {0.132, 0.132}, {0.099, 0.099}, {0.066, 0.066}, {0.099, 0.066}, {0.066, 0.066}, {0.099, 0.066}, {0.132, 0.066}, {0.132, 0.099}, {0.066, 0.033}, {0.165, 0.033}, {0.099, 0.066}, {0.165, 0.066}, 1, {0.099}, {0.132, 0.066}, {0.066, 0.033}, {0.132}, {0.066, 0.033}, {0.165}, {0.066}, {0.132}, {0.066}, {0.165, 0.033}, {0.132, 0.066}, {0.066, 0.033}, {0.099}, {0.132, 0.033}, {0.132}, {0.033, 0.066}, {0.132}, {0.033}, {0.099, -0.033}, {0.099, -0.066}, {0.066, -0.099}, {0.066, -0.132}, {0.132, -0.231}, {0.132, -0.297}, {0.165, -0.363}, {0.198, -0.429}, {0.165, -0.329999}, {0.066, -0.363}, {0.132, -0.297}, {0.066, -0.231}, {0.198, -0.561001}, {0.033, -0.197999}, {0.132, -0.429}, {0.099, -0.33}, {0.066, -0.363}, {0.132, -0.363}, {0.132, -0.528}, {0.099, -0.297}, {0.066, -0.33}, {0.066, -0.231}, {0.099, -0.297}, {0.033, -0.231}, {0.033, -0.198}, {0.033, -0.264}, {0.099, -0.329999}, {0.099, -0.264}, {0.033, -0.264}, {0.066, -0.198}, {0.099, -0.264001}, {0, -0.165}, {0, -0.132}, {0.033, -0.198}, {0.066, -0.099}, {0.033, -0.099}, 1, {0.066, -0.033}, {0.066, 0, "J"}, {0.198, 0.198, "", "J"}, {0.099, 0.198}, {0.132, 0.792, "L"}, {0.066, 1.122}, {0.099, 1.551}, {0.066, 4.125, "", "F"}, {0, 1.253999}, {0, 1.782001}, {-0.099, 2.904}, {-0.165, 2.738999}, {-0.264, 3.003}, {-0.363, 3.629999}, {-0.363, 3.795}, {-0.297, 2.673}, {-0.396, 3.960001}, {-0.528, 3.630001}, {-0.33, 2.376002}, {-0.495, 3.794998}, {-0.462, 3.696003}, {-0.528, 3.795002}, {-0.33, 3.201}, {-0.429, 3.167999}, {-0.561, 3.828003}, {-0.396, 2.738999}, {-0.429, 2.771999}, {-0.561, 3.333}, {-0.462, 2.607002}, {-0.594, 2.937005}, {-0.495, 2.243995}, {-0.528, 2.244004}, {-0.561, 2.112007}, {-0.561, 1.847999}, {-0.561, 1.485001}, {-0.363, 0.956993}, {-0.528, 1.023003}, {-0.495, 1.154998}, {-0.66, 1.485001}, {-1.155, 2.772003}, {-0.165, 0.495003}, {-0.825, 1.914001}, {-0.561, 1.65001}, {-0.66, 2.079002}, {-0.66, 1.914009}, {-0.495, 1.749001}, {-0.594, 2.111991}, {-0.528, 1.517998}, {-0.429, 1.286995}, {-0.396, 1.122002, "D"}, {-0.363, 1.02301}, {-0.264, 0.462006}, {-0.264, 0.594009}, {-0.165, 0.329994}, {-0.033, 0.296997}, {-0.132, 0.197991}, {0, 0.098999}, {-0.033, 0.032997}, {-0.033, 0.131996}, {0, 0.032997}, {0, 0.164993}}},{"T Spawn","Z","grenade","weapon_smokegrenade",2630.343,11.51,1613.031,-11.831,-179.005,"custom_801",["throwType"]="RUNJUMP",["runDuration"]=27,["landX"]=-352.065,["landY"]=-48.998,["landZ"]=1667.031},{"B Main","CT","grenade","weapon_smokegrenade",421.266,-899.761,1614.031,-10.637,133.718,"custom_802",["throwType"]="RUN",["runDuration"]=16,["landX"]=-434.002,["landY"]=-906.718,["landZ"]=1616.031},{"B Main","Heaven","grenade","weapon_smokegrenade",324.882,-787.719,1614.031,-24.411,137.714,"custom_803",["throwType"]="RUN",["runDuration"]=11,["landX"]=-334.702,["landY"]=-723.911,["landZ"]=1798.031},{"NBK","Main","grenade","weapon_smokegrenade",-13.531,2274.969,1687.031,2.272,-70.487,"custom_804",["throwType"]="JUMP",["landX"]=495.352,["landY"]=1711.398,["landZ"]=1704.031},{"Z","Garage","grenade","weapon_smokegrenade",-740.976,215.386,1614.031,-17.973,1.29,"custom_805",["throwType"]="NORMAL"},{"Sandbags","Boost","grenade","weapon_molotov",16.969,-26.889,1626.031,-29.624,35.572,"custom_806",["throwType"]="NORMAL",["landX"]=932.358,["landY"]=620.932,["landZ"]=1820.55},{"Heaven","B Main (Deep)","grenade","weapon_smokegrenade",-435.02,-752.977,1797.031,2.763,39.003,"custom_807",["throwType"]="RUN",["runDuration"]=11,["landX"]=520.353,["landY"]=-935.901,["landZ"]=1616.031},{"Heaven","B Main (Deep)","grenade","weapon_flashbang",-435.02,-752.977,1797.031,2.763,39.003,"custom_808",["throwType"]="RUN",["runDuration"]=11,["landX"]=520.353,["landY"]=-935.901,["landZ"]=1616.031},{"Entrance","Vent Room","grenade","weapon_smokegrenade",-735.915,-232.413,1614.031,-28.055,-57.183,"custom_809",["throwType"]="NORMAL",["landX"]=-162.519,["landY"]=-492.562,["landZ"]=1616.031},{"Z","Boost","grenade","weapon_molotov",-611.403,140.031,1656.675,6.609,17.235,"custom_810",["throwType"]="RUNJUMP",["runDuration"]=23,["landX"]=848.372,["landY"]=586.75,["landZ"]=1812.865},{"Toxic","Whitebox","grenade","weapon_molotov",635.298,-1227.017,1613.048,-32.851,-150.444,"custom_811",["throwType"]="NORMAL",["landX"]=121.605,["landY"]=-1395.631,["landZ"]=1659},{"Truck","Default","grenade","weapon_molotov",-904.031,1000.082,1679.273,-14.197,47.42,"custom_812",["throwType"]="NORMAL",["landX"]=-122.551,["landY"]=1853.598,["landZ"]=1689.032},{"Toxic","Headglitch","grenade","weapon_molotov",955.933,-1462.376,1711.031,-18.552,168.336,"custom_813",["throwType"]="NORMAL",["landX"]=-267.295,["landY"]=-1209.938,["landZ"]=1659},{"Quad","Ladder","grenade","weapon_molotov",-329.469,2274.969,1687.031,-23.703,-82.836,"custom_814",["throwType"]="NORMAL",["landX"]=-180.168,["landY"]=1087.167,["landZ"]=1687.0},{"Highway","Quad","grenade","weapon_molotov",-302.715,408.286,1613.23,-0.07,89.23,"custom_815",["throwType"]="RUNJUMP",["runDuration"]=13,["landX"]=-277.905,["landY"]=2255.21,["landZ"]=1687.001},{"Main","Under Vent","grenade","weapon_molotov",896.126,-883.927,1614.031,-17.418,176.692,"custom_816",["throwType"]="RUN",["runDuration"]=15,["landX"]=313.567,["landY"]=-383.715,["landZ"]=1616.031},{"Truck","Quad","grenade","weapon_molotov",-886.721,903.33,1726.052,-19.613,68.167,"custom_817",["throwType"]="RUN",["runDuration"]=3,["landX"]=-306.594,["landY"]=2226.634,["landZ"]=1687.0},{"Dumpster Room","Middle","grenade","weapon_flashbang",1316.984,-402.969,1612.031,-33.739,148.83,"custom_818",["throwType"]="NORMAL",["landX"]=580.971,["landY"]=39.906,["landZ"]=1969.415},{"A Site","Main","grenade","weapon_flashbang",-429.954,1696.464,1689.82,-11.367,-1.521,"custom_819",["throwType"]="NORMAL",["landX"]=625.59,["landY"]=1669.079,["landZ"]=1706.769},{"NBK","Main (Popflash)","grenade","weapon_flashbang",87.969,2274.969,1722.531,-58.079,-84.453,"custom_820",["throwType"]="NORMAL",["landX"]=97.699,["landY"]=2057.578,["landZ"]=1715.815},{"Sandbags","Middle (Popflash)","grenade","weapon_flashbang",115.969,-110.008,1624.019,-37.255,-80.874,"custom_821",["throwType"]="RUN",["runDuration"]=3,["landX"]=112.366,["landY"]=87.275,["landZ"]=1638.193},{"B Site","Main (Popflash)","grenade","weapon_flashbang",-307.19,-1454.969,1672.031,-8.383,58.351,"custom_822",["throwType"]="NORMAL",["landX"]=247.833,["landY"]=-584.889,["landZ"]=1649.274},{"Heaven","B Main","grenade","weapon_flashbang",-471.734,-758.891,1796.241,0.637,32.463,"custom_823",["throwType"]="NORMAL",["landX"]=209.821,["landY"]=-588.216,["landZ"]=1680.933},{"CT","B Main","grenade","weapon_flashbang",-521.008,-982.969,1613.525,-13.843,28.782,"custom_824",["throwType"]="NORMAL",["landX"]=142.581,["landY"]=-534.167,["landZ"]=1705.445},{"B Site","CT (Popflash)","grenade","weapon_flashbang",76.928,-1454.969,1659.031,-12.45,118.404,"custom_825",["throwType"]="NORMAL",["landX"]=-352.651,["landY"]=-879.279,["landZ"]=1730.451},{"B Site","Vent room (Popflash)","grenade","weapon_flashbang",-263.031,-1454.969,1659.031,-9.156,83.363,"custom_826",["throwType"]="NORMAL",["landX"]=-135.983,["landY"]=-395.207,["landZ"]=1642.839},{"Heaven","B Site (Popflash)","grenade","weapon_flashbang",-819.995,-64.304,1614.031,-17.911,-59.689,"custom_827",["throwType"]="NORMAL",["landX"]=-362.196,["landY"]=-838.377,["landZ"]=1793.302},{"White Box","Boost","movement","weapon_knife",-69.031,549.187,1628.712,8.184,-59.955,"custom_873",["data"]={{0.0, 0.0, "F"}, 12, {0.0, 0.0, "J"}, {0.0, 0.0, "", "J"}, 3, {0.0, 0.0, "Z"}, 1, {0.044, 0.087997}, {0.66, 0.043999}, {1.496, -0.528}, {1.276, -0.528}, {1.848, -1.056004}, {2.552, -1.891998}, {1.716, -1.936008, "", "Z"}, {2.024, -3.124001}, {0.792, -1.496002}, {1.056, -2.508003}, {1.012, -2.552002}, {0.352, -1.891998}, {0.044, -2.112}, {0.0, -1.496002}, {0.0, -1.364006}, {-0.132, -1.188004}, {-0.132, -0.748001}, {-0.088, -0.396004}, {0.0, -0.44001}, {-0.132, -0.528008}, 7, {-0.044, -0.132004}, {-0.176, -0.395996}, {-0.044, -0.219994}, {-0.132, -0.307999}, {-0.044, -0.219994}, {0.0, -0.219994}, {0.0, -0.087997}, {0.0, -0.131996}, {0.0, -0.131996}, {0.0, -0.131996}, {0.0, 0.0, "J"}, {0.0, -0.043999, "", "J"}, {0.0, -0.043999}, {0.264, -0.087997, "L", "", 450.0, -225.0}, {1.496, 0.264}, {1.056, 0.528008}, {0.748, 0.572006}, {1.188, 1.319992, "", "F"}, {0.792, 1.188004}, {0.88, 1.408005}, {0.836, 1.320007}, {0.792, 1.364006}, {0.792, 2.155998}, {0.528, 1.760002}, {0.352, 2.02401}, {0.264, 2.156006}, {0.132, 3.299995}, {0.044, 2.551994}, {0.0, 3.036003}, {-0.088, 4.092003}, {-0.176, 3.431999}, {-0.176, 3.211998}, {-0.396, 4.972}, {-0.396, 3.475998}, {-0.484, 3.783997}, {-0.704, 4.092003}, {-0.616, 2.727997}, {-0.66, 2.068001}, {-0.616, 1.76}, {-0.748, 2.156}, {-0.528, 1.628}, {-0.616, 1.584}, {-0.616, 1.672001}, {-0.66, 2.024}, {-0.528, 1.98}, {-0.616, 2.948}, {-0.44, 1.936}, {-0.396, 1.804}, {-0.22, 1.584, "J"}, {-0.088, 2.2, "", "J"}, {0.0, 1.804}, {0.0, 1.452}, {0.0, 1.672}, {0.0, 1.056}, {0.176, 1.276}, {0.308, 1.1}, {0.484, 1.276}, {0.88, 2.244, "Z"}, {0.792, 2.112, "D"}, {0.484, 2.288}, {0.264, 2.376}, {0.132, 2.552}, {0.044, 1.495999}, {0.0, 0.88}, {0.0, 0.264, "", "Z"}, 1, {0.0, 0.0, "F", "D", 225.0}, 1, {0.0, 0.0, "", "L"}, {-0.308, -0.484}, {-0.748, -0.924}, {-1.1, -1.363999}, {-1.232, -2.024}, {-0.704, -1.804}, {-0.748, -1.760001}, {-1.012, -1.804}, {-1.54, -2.376}, {-1.144, -1.584}, {-1.276, -1.144}, {-1.276, -0.792}, {-0.924, -0.704}, {-0.396, -0.308}, 15, {-0.264, -0.22}, {0.22, -0.44}, {0.088, -0.088}, {0.044, -0.088}, 1, {0.176, -0.22}, {0.176, -0.044}, {0.132, -0.088}, {0.44, -0.088}, {0.44, -0.044}, {0.704}, {0.528, 0.088}, {0.44, 0.0, "L"}, {0.528, 0.044}, {0.308, 0.088}, {0.308, 0.088, "", "L"}, {0.176, 0.044}, {0.264}, {0.352, -0.044}, {0.396, -0.044}, {0.396, -0.044}, {0.396}, {0.484}, {0.44}, {0.484}, {0.748, 0.132}, {0.66}, {0.66, 0.088}, {0.792, 0.088}, {1.188, 0.132}, {0.528, 0.044}, {1.628, -0.088}, {1.1, -0.132}, {1.144, -0.088}, {1.496, -0.088}, {1.54, -0.044}, {0.836, -0.088}, {1.584, -0.088}, {0.88, -0.088}, {1.804, -0.176}, {1.232, -0.044}, {1.232, -0.176}, {1.496, -0.132}, {1.364}, {1.452}, {1.892, -0.088}, {2.772, -0.308}, {1.98, -0.176}, {1.584, -0.044}, {1.716, 0.088}, {1.32, -0.132}, {1.144, -0.044}, {1.232}, {1.364, -0.088}, {1.584, -0.176}, {1.012, -0.088}, {0.836, -0.132}, {0.616, -0.176}, {0.22, -0.176}, {0.132, -0.176}, {0.088, -0.176}, {0.044, -0.968}, {-0.22, -0.924}, {-0.792, -1.056001}, {-2.068, -1.232, "J"}, {-2.508, -1.1, "", "J"}, {-2.464, -0.836}, {-1.936, -0.22, "L"}, {-1.848, 0.615999}, {-1.452, 0.748}, {-1.892, 1.188}, {-1.1, 1.188}, {-0.968, 1.892, "", "F"}, {-1.232, 3.036}, {-0.924, 2.376}, {-0.748, 2.904}, {-0.528, 3.211999}, {-0.44, 4.092001}, {-0.308, 2.992001}, {-0.308, 3.080001}, {-0.264, 3.079998}, {-0.308, 4.796}, {-0.44, 3.388002}, {-0.484, 3.476}, {-0.44, 3.476002}, {-0.44, 3.212002}, {-0.44, 3.652}, {-0.484, 2.992001}, {-0.308, 2.948002}, {-0.572, 4.443996}, {-0.484, 3.167999}, {-0.704, 3.167999}, {-1.1, 3.652}, {-0.748, 2.420002}, {-0.792, 2.375999}, {-1.144, 3.740005}, {-0.44, 1.848}, {-1.056, 4.224007}, {-0.748, 2.639999}, {-0.748, 2.816002}, {-0.88, 3.036003}, {-0.704, 2.595993}, {-0.528, 2.551994}, {-0.704, 2.552002}, {-0.968, 3.167999}, {-0.44, 1.671997}, {-0.352, 1.364006}, {-0.396, 1.276009}, {-0.44, 1.540009}, {-0.308, 0.879997}, {-0.264, 0.660004}, {-0.264, 0.660004}, {-0.704, 1.804001}, {-0.44, 1.231995, "D"}, {-0.616, 1.408005}, {-0.704, 0.968002}, {-0.924, 0.572006}, {-0.572, 0.131996}, {-0.66, -0.087997}, {-0.748, -0.307991, "F"}, {-0.748, -0.484009}, {-0.66, -0.572006}, {-0.484, -0.660004}, {-0.264, -0.879997, "", "L"}, {-0.264, -0.923996}, {-0.176, -0.924004}, {0.0, -0.748001}, {0.264, -0.968002}, {0.132, -0.352005}, {0.528, -1.012001}, {1.32, -2.288002}, {2.112, -3.916, "", "D"}, {2.86, -4.752007}, {1.672, -1.848007}, {1.056, -0.792}, {0.572, -0.396004}, {0.396, -0.307991}, {0.176, -0.219994}, 1, {0.044, -0.131996}, {0.0, -0.043999}, 3, {0.0, 0.175995}, {0.176, 0.263992}, {0.484, 0.396004, "J"}, {0.968, 0.395996, "R", "J"}, {0.66, 0.087997}, {0.748, -0.484001, "", "F"}, {1.452, -1.451996}, {1.54, -1.847992}, {1.364, -2.112}, {0.836, -1.671997}, {0.748, -1.848}, {0.484, -1.936005}, {0.22, -3.520012}, {0.0, -3.167999}, {-0.132, -2.684006}, {-0.396, -2.244003, "L", "", 0.0, 0.0}, {-0.572, -1.848003, "", "R"}, {-0.396, -0.748001}, {-0.44, 0.087997}, {-0.396, 0.66}, {-1.276, 3.564003}, {-0.748, 4.444}, {-0.968, 6.072006}, {-0.352, 3.299995}, {-0.22, 2.771996}, {0.0, 1.496002}, {0.0, 0.880005, "RZ", "", 0.0, 0.0}, {0.0, 0.132004, "", "L"}, 1, {-0.088, -1.232002}, {-0.088, -2.816002}, {-0.132, -6.071999, "", "Z"}, {-0.044, -5.235992}, {-0.264, -5.015999, "F", "", 225.0}, {-0.528, -6.731998}, {-0.396, -4.576, "", "R"}, {-0.264, -5.059998}, {-0.22, -4.619995}, {-0.22, -6.116001}, {-0.132, -4.135998}, {-0.22, -3.387999, "R"}, {-0.22, -2.243999}, {-0.528, -2.024}, {-0.308, -0.615999}, {-0.132, -0.263998}, {-0.044, -0.176001}, {-0.044, -1.188}, {0.0, -1.759998}, {0.176, -3.08}, {0.352, -4.707999, "J"}, {1.012, -7.919999, "", "J"}, {0.924, -5.632}, {0.792, -5.06, "", "F"}, {1.012, -5.192}, {1.32, -5.323999}, {1.012, -3.651999}, {1.188, -3.695999}, {1.144, -3.960001}, {1.628, -7.304001}, {0.968, -6.247997}, {0.484, -5.587997}, {0.264, -5.279999}, {0.176, -4.663998}, {0.22, -5.411999}, {0.088, -3.519997}, {0.0, -3.431999}, {0.0, -4.003998}, {0.0, -2.507996}, {-0.088, -2.639999}, {-0.088, -1.056, "L", "", 0.0, 0.0}, {-0.264, -1.628006, "", "R"}, {-0.264, -0.792}, {-0.308, -0.131996}, {-0.616, 1.056}, {-0.704, 1.584}, {-1.188, 3.036003}, {-1.276, 5.015999}, {-1.232, 10.208004}, {-0.66, 7.787998}, {-1.1, 6.028}, {-1.276, 5.104}, {-1.672, 5.852001}, {-1.716, 4.664001}, {-1.584, 4.224001, "S"}, {-2.288, 5.148001}, {-1.364, 2.816, "F"}, {-0.88, 2.068001}, {-0.572, 1.32}, {-0.308, 0.616}, {-0.088, 0.264, "", "L"}, {-0.308, 0.923999}, {-0.352, 0.879999}, {-0.396, 0.879999}, {-0.484, 0.835999}, {-0.704, 1.012}, {-0.308, 0.528}, {-0.22, 0.264}, {-0.088, 0.132}, {-0.132, 0.22}, {-0.352, 0.352}, {-0.352, 0.308}, {-0.44, 0.351999}, {-0.308, 0.176}, {-0.396, 0.176}, {-0.44, 0.22}, {-0.396, 0.264}}},{"Ticket","Boost","movement","weapon_knife",-325.969,975.969,1694.031,10.34,-62.86,"custom_874",["data"]={10, {0.0, 0.0, "F"}, 23, {-0.044}, {0.088}, {0.22, 0.087997}, {0.176, 0.043999}, {0.132, 0.043999}, {0.088, 0.043999}, {0.22, 0.043999}, {0.132, 0.043999}, {0.132, 0.043999}, {0.176}, {0.264, 0.043999}, {0.132}, {0.308}, {0.176}, 1, {0.132, -0.087997}, {0.044, -0.043999}, {0.088}, {0.044}, {0.132, -0.043999}, {0.088}, {0.132}, {0.176, -0.043999}, {0.132}, {0.088}, {0.044}, {0.044}, {0.044}, {0.088}, {0.264}, {0.22, -0.043999}, {0.264, -0.132}, {0.264, -0.352001}, {0.308, -0.220001}, {0.396, -0.352005}, {0.308, -0.264}, {0.264, -0.263992}, {0.264, -0.219994}, {0.308, -0.219994}, {0.484, -0.395996}, {0.352, -0.219994}, {0.396, -0.175995}, {0.22, -0.131996}, {0.176, -0.219994}, {0.132, -0.087997}, {0.132, -0.131996}, {0.088, -0.175995}, {0.044, -0.175995}, {0.044, -0.175995}, {0.044, -0.131996}, {0.0, -0.175995}, {0.0, -0.307999}, {0.044, -0.484009}, {0.0, -0.263992}, {0.0, -0.307991}, {0.0, -0.175995}, {0.0, -0.219994}, {0.0, -0.131996}, {0.0, -0.219994}, {-0.044, -0.396011}, {-0.132, -0.44001}, {-0.132, -0.484009}, {-0.088, -0.175995}, {-0.176, -0.352005}, {-0.264, -0.44001}, {-0.528, -0.660011}, {-0.528, -0.44001}, {-0.616, -0.484009}, {-0.616, -0.484009}, {-0.924, -0.440002}, {-0.792, -0.307999}, {-0.704, -0.131996}, {-0.792, -0.131996}, {-0.88, -0.043999}, {-1.144}, {-0.748, 0.219994, "JL"}, {-0.704, 0.572006, "", "J"}, {-0.792, 1.143997}, {-0.396, 1.188004}, {-0.132, 1.76001, "", "F"}, {0.0, 1.100006}, {0.044, 1.055992}, {0.22, 1.099998}, {0.44, 1.408005}, {0.528, 1.496002}, {0.748, 2.243999}, {0.616, 1.584}, {0.572, 1.452003}, {0.484, 1.276001}, {0.484, 1.584}, {0.396, 1.188}, {0.44, 1.275997}, {0.528, 1.628002}, {0.484, 1.408001}, {0.616, 1.540001, "Z"}, {0.66, 1.276001}, {1.012, 1.32}, {0.66, 0.616001}, {0.572, 0.307999, "R", "", 0.0, 0.0}, {0.792, 0.043999, "", "", 0.0, 0.0}, {0.88, -0.308002, "", "L"}, {1.232, -0.835999, "", "Z"}, {1.056, -1.188}, {0.924, -1.540001}, {0.704, -1.759998}, {0.836, -2.112}, {0.66, -1.759998}, {0.616, -1.584}, {0.748, -2.420002}, {0.572, -1.759998}, {0.484, -1.804001}, {0.484, -1.759998}, {0.484, -2.068005}, {0.308, -1.496002}, {0.308, -1.144005, "J"}, {0.132, -0.835999, "", "J"}, {0.132, -0.836006}, {0.132, -0.307999}, {0.0, -0.087997, "L", "", 0.0, 225.0}, {0.0, 0.0, "", "", 0.0, 0.0}, {0.088, -0.043999, "", "", 0.0, 0.0}, {0.264, 0.175995, "", "R"}, {0.352, 0.307999}, {0.396, 0.44001}, {0.396, 0.616005}, {0.528, 1.099998}, {0.352, 0.967995}, {0.308, 1.011993}, {0.264, 1.363991}, {0.132, 1.187996}, {0.088, 1.319996}, {0.044, 1.407997}, {0.044, 1.803997}, {0.0, 1.672001}, {0.0, 2.111996}, {-0.088, 3.079998}, {-0.088, 2.111996}, {-0.088, 2.243999}, {-0.22, 2.332001}, {-0.748, 3.519997}, {-0.44, 1.759998}, {-0.924, 4.004002}, {-0.748, 3.255997}, {-0.748, 3.036001}, {-0.748, 3.784}, {-0.528, 3.168001}, {-0.484, 2.991999}, {-0.66, 3.256001, "J"}, {-0.66, 3.432, "", "J"}, {-0.616, 4.356001}, {-0.308, 3.08}, {-0.264, 3.212}, {-0.264, 4.224}, {-0.22, 3.344}, {-0.176, 3.3}, {-0.132, 3.3}, {-0.176, 3.652}, {-0.044, 2.156}, {0.0, 1.496}, {0.0, 1.276001}, {0.0, 0.572001, "D"}, {0.0, 0.307999}, {0.0, 0.044001}, 2, {0.0, 0.0, "F", "", 225.0}, {0.132, -0.132}, {0.176, -0.528, "", "D"}, {0.088, -0.528002, "", "L"}, {0.044, -0.659998}, {0.132, -1.935999}, {0.088, -1.76}, {0.0, -1.584}, {0.044, -1.76}, {0.0, -3.036}, {0.0, -2.332}, {0.0, -2.464}, {-0.044, -2.068}, {-0.352, -1.364}, {-0.748, -2.508}, {-0.132, -0.396}, 14, {0.0, -0.396}, {0.044, -0.044}, {0.044, 0.044}, {0.0, 0.132}, {0.088, 0.132}, {0.132}, {0.176, -0.044}, {0.616}, {0.528, 0.132}, {0.484, 0.088}, {0.66}, {0.66, 0.132}, {0.66, -0.176}, {0.836, -0.132}, {0.572, -0.088}, {0.308, 0.0, "L", "", 450.0, -225.0}, {0.264}, {0.264, 0.088}, {0.572, 0.0, "", "L"}, {0.528}, {0.66, -0.044}, {0.748, 0.044}, {0.792, 0.088}, {1.056}, {0.704, -0.088}, {0.66, -0.044}, {0.704, -0.132}, {1.012, -0.264}, {0.704, -0.176}, {0.792, -0.176}, {1.188, -0.22}, {0.528, -0.088}, {1.276, -0.22}, {0.792, -0.352}, {1.144, -0.132}, {1.628, -0.308}, {0.88, -0.308}, {1.012, -0.176}, {0.924, -0.44}, {1.32, -0.176001}, {0.968, -0.132}, {1.056, -0.22}, {0.88, -0.132}, {1.144, -0.264}, {1.1, -0.264}, {0.924, -0.263999}, {1.584, -0.528}, {1.1, -0.352}, {0.968, -0.088}, {1.012, -0.352}, {0.792, -0.263999}, {1.012, -0.484}, {0.748, -0.22}, {0.572, -0.44}, {0.572, -0.308001}, {0.616, -0.264}, 1, {0.088, -0.044}, {-0.088, -0.616}, {-0.836, -1.144}, {-1.408, -1.407999, "J"}, {-2.332, -1.804, "", "J"}, {-2.992, -0.923999, "L"}, {-4.62, 0.396}, {-2.992, 1.452}, {-1.672, 2.024, "", "F"}, {-1.232, 2.684001}, {-0.528, 1.892}, {-0.176, 2.2}, {-0.044, 3.256}, {0.0, 1.672}, {-0.044, 3.828}, {0.0, 3.124}, {0.0, 2.948}, {0.0, 2.64}, {0.0, 4.004002}, {0.0, 3.74}, {0.0, 3.256001}, {0.0, 4.179998}, {0.0, 2.948}, {-0.044, 2.992002}, {-0.088, 3.739998}, {-0.088, 5.279999}, {-0.132, 4.399998}, {-0.22, 4.091999}, {-0.22, 3.52}, {-0.44, 4.444}, {-0.396, 2.859997}, {-0.308, 3.079998}, {-0.484, 3.696014}, {-0.352, 2.596001}, {-0.308, 2.332001}, {-0.264, 2.068008}, {-0.44, 2.816002}, {-0.352, 2.419998}, {-0.264, 3.124008}, {-0.44, 2.683998}, {-0.396, 2.551994}, {-0.308, 2.463997}, {-0.176, 1.935997}, {-0.22, 1.364006}, {-0.132, 1.276009}, {-0.22, 1.23201}, {-0.176, 1.584}, {-0.132, 0.967995}, {-0.132, 0.924004}, {-0.088, 0.748001}, {-0.176, 0.835999}, {-0.176, 1.056}, {-0.132, 0.660004, "D"}, {-0.132, 0.44001}, {-0.044, 0.219994}, {-0.088, 0.087997}, 1, {-0.132, 0.043999, "F"}, {-0.176, -0.175995}, {-0.308, -0.704002}, {-0.88, -2.156006, "", "L"}, {-0.88, -2.156006}, {-0.792, -3.167999}, {-0.66, -3.299995}, {-0.704, -3.431999}, {-0.968, -3.652, "", "D"}, {-0.792, -2.155998}, {-0.66, -1.715996}, {-0.836, -1.364006}, {-1.232, -1.231995}, {-0.924, -0.572006}, {-1.188, -0.748009}, {-0.924, -0.307999}, {-0.836, -0.131996}, {-0.836}, {-0.66, 0.131996}, {-0.66, 0.219994}, {-0.308, 0.043999}, {-0.176}, {-0.088}, 2, {-0.088, 0.131996}, {-0.088, 0.528008}, {0.0, 1.099998}, {0.088, 1.011993, "J"}, {0.88, 1.144005, "R", "J"}, {1.76, 1.584}, {0.88, 0.704002}, {0.704, 0.307999}, {0.924, 0.043999, "", "F"}, {1.408, -0.615997}, {1.32, -1.23201}, {1.1, -1.408005}, {0.836, -1.496002}, {0.792, -1.980003}, {0.792, -2.728012}, {0.352, -2.244003}, {0.044, -1.848, "L", "", 0.0, 0.0}, {-0.132, -1.188004, "", "R"}, {-0.572, -1.012001}, {-0.616, 0.307999}, {-1.012, 1.540009}, {-0.352, 0.968002}, {-0.484, 2.068001}, {-0.088, 0.968002, "R", "", 0.0, 0.0}, {0.0, 0.0, "", "L"}, {0.0, -0.835999}, {0.044, -2.551994}, {0.132, -3.739998}, {0.176, -4.883999}, {0.352, -9.151997}, {0.176, -7.392002}, {0.132, -7.347996}, {0.352, -7.568001}, {0.616, -11.748001}, {0.088, -7.524}, {0.132, -8.536}, {0.308, -11.704}, {0.0, -5.368}, {0.0, -10.648001}, {0.0, -10.604002, "J"}, {0.0, -4.444, "", "J"}, {0.484, -9.063999}, {0.704, -5.807999}, {0.704, -5.411995}, {0.308, -5.632}, {0.22, -3.431999}, {0.22, -2.948006}, {0.308, -2.639999}, {0.264, -3.431999}, {0.132, -2.507996}, {0.088, -2.068008}, {0.0, -1.584}, {0.0, -0.835999}, {0.0, -0.220001, "L", "", 0.0, 0.0}, {0.0, 0.0, "", "", 0.0, 0.0}, {0.0, 0.0, "", "R"}, {-0.044, 0.264}, {-0.176, 1.936005}, {-0.176, 2.860008}, {-0.132, 4.048004}, {-0.044, 3.211998}, {-0.088, 4.091995}, {0.0, 3.475998}, {0.132, 4.223999}, {0.0, 2.024002}, {0.0, 3.871998}, {0.0, 3.079998}, {0.0, 3.52, "D"}, {-0.044, 3.739998}, {-0.088, 4.487999}, {-0.132, 3.784}, {-0.396, 5.235998}, {-0.264, 2.552}, {-0.44, 4.708002}, {-0.572, 3.476}, {-1.32, 5.147999}, {-1.32, 3.696001}, {-1.584, 3.608, "", "D"}, {-1.672, 2.992, "F"}, {-2.024, 2.816}, {-2.904, 3.256}, {-2.2, 2.244, "", "L"}, {-1.672, 1.716}, {-1.584, 1.804}, {-0.792, 1.144}, {-0.44, 0.748}, {-0.22, 0.396}, 6, {0.0, 0.0, "S"}, 6, {0.0, -0.22}, {0.0, -0.264001}, {-0.088, -0.396}, {-0.044, -0.572}, {0.0, -0.835999}, {-0.044, -0.968}, {0.0, -1.276}, {0.0, -0.396}, {0.0, -0.44, "", "S"}, {0.0, -0.22}, {0.0, -0.264}, {0.0, -0.352}, {0.088, -0.22}, {0.0, -0.132}, 8, {0.088, -0.088}}},{"A Site","Shroud (Open door)","movement","weapon_knife",-15.969,1702.969,1687.031,8.14,124.448,"custom_875",["data"]={11, {0.0, 0.0, "J"}, {0.0, 0.0, "", "J"}, {0.0, 0.0, "F"}, 2, {0.0, 0.0, "D"}, 1, {0.352, -0.043999}, {0.616, -0.308006}, {0.572, -0.703995}, {1.012, -1.187996}, {1.188, -1.452003}, {1.276, -1.979996}, {1.144, -2.332001}, {1.188, -2.639999}, {1.056, -2.683998}, {0.352, -1.803993}, {0.088, -1.671997}, {0.044, -2.024002}, {0.0, -1.364006}, {-0.176, -1.232002}, {-0.352, -1.364006, "", "D"}, {-0.572, -1.804008}, {-0.352, -1.011993}, {-0.22, -0.704002}, {-0.088, -0.220001}, {-0.088, 0.176003}, {-0.22, 0.571999}, 4, {-0.22, 0.396004}, {-0.044, 0.175995}, 3, {0.044, 0.043999}, 6, {0.044, -0.043999}, {0.044, -0.087997}, {0.0, -0.087997}, {0.044}, {0.0, -0.043999}, 1, {0.044}, 8, {0.044}, {0.088, -0.043999}, {0.088, -0.131996}, {0.264, -0.351997}, {0.484, -0.616005}, {1.276, -1.407997}, {1.1, -1.232002}, {0.836, -0.923996, "JD"}, {1.364, -1.099998, "", "J"}, {1.848, -1.363991}, {0.968, -0.835999}, {0.396, -0.484009}, {0.792, -0.35199}, {0.616, -0.176003}, {1.012, -0.307999}, {0.484, 0.308006}, 5, {0.044, 0.264008}, {0.0, 0.043999}, {0.0, 0.043999}, {0.088, 0.131996}, {0.088, 0.175995}, {0.0, 0.087997}, {0.044, 0.131996}, {0.088, 0.087997}, {0.044, 0.175995}, {0.088, 0.087997}, {0.044, 0.043999, "", "D"}, {0.044, 0.043999}, {0.088, 0.087997}, {0.088, 0.087997}, {0.044, 0.087997}, {0.044, 0.043999}, {0.044}, {0.044}, {0.044, 0.043999}, {0.088, 0.043999}, {0.132, 0.043999}, {0.044, 0.087997}, {0.044, 0.043999}, {0.088, 0.087997}, 1, {0.044, 0.043999}, {0.088, 0.175995}, {0.132, 0.175995}, {0.088, 0.087997}, {0.132, 0.219994}, {0.176, 0.264}, {0.352, 0.748009}, {0.264, 0.704002}, {0.264, 0.660004}, {0.264, 0.704002}, {0.264, 0.660004}, {0.308, 0.968002}, {0.264, 0.704002}, {0.264, 0.616005, "R"}, {0.352, 0.616013}, {0.176, 0.264}, {0.176, 0.087997}, {0.088}, {0.132, -0.043999}, {0.264, -0.219994}, {0.22, -0.263992}, {0.176, -0.351997}, {0.264, -0.704002}, {0.22, -0.879997}, {0.176, -1.144005}, {0.044, -1.408005}, {0.0, -2.332001}, {0.044, -1.803993}, {0.0, -1.848}, {0.0, -1.759995}, {0.0, -1.979996}, {0.0, -2.772011}, {0.0, -2.200005}, {-0.044, -1.980003}, {-0.352, -3.388}, {-0.352, -2.948006, "J"}, {-0.264, -3.652, "", "J"}, {-0.484, -3.608009}, {-0.704, -3.695999, "", "F"}, {-0.924, -4.488003}, {-0.66, -2.947998}, {-0.396, -2.155998}, {-0.088, -2.771999}, {0.0, -1.936001}, {0.0, -2.023998}, {0.0, -1.848003}, {0.0, -2.903999}, {0.044, -2.155998}, {0.0, -1.628002}, {0.044, -1.32}, {0.0, -1.056}, {0.0, -1.408001}, {0.0, -1.188}, {-0.044, -1.584}, {-0.044, -0.880001}, {-0.088, -0.836}, {-0.132, -0.880001}, {-0.088, -0.747999, "L", "", 0.0, 0.0}, {-0.132, -0.791998, "", "", 0.0, 0.0}, {-0.088, -0.307999, "", "R"}, {0.0, -0.044001}, 2, {-0.044, 0.703999}, {0.0, 1.452}, {0.0, 2.463999}, {0.0, 2.156}, {0.044, 1.716}, {0.264, 1.627998, "R", "L"}, {0.352, 1.144001}, {0.352, 0.747997}, {0.308, 0.220001}, {0.572, -0.307999}, {0.308, -0.352001}, {0.66, -1.188004}, {0.528, -1.276001}, {0.264, -1.847996}, {0.176, -1.892}, {0.132, -1.188}, {0.044, -1.055998}, {0.0, -1.011999, "L", "", 0.0, 225.0}, {0.0, -1.144001, "", "", 0.0, 0.0}, {0.0, -0.528, "D", "", 0.0, 0.0}, {0.0, -0.087999, "", "R"}, {-0.132, -0.088001}, {-0.132, 0.219999, "F"}, {-0.132, 0.351999}, {-0.132, 0.704, "", "L"}, {-0.308, 1.1}, {-0.748, 2.42}, {-0.396, 2.024, "L"}, {-0.44, 2.112}, {-0.308, 2.375999}, {0.132, 0.836002}, {0.44, 0.396}, {0.484, 0.264004}, {0.22, 0.131996}, {0.22, 0.175995, "", "L"}, {0.22, 0.175999}, {0.132, 0.087997}, {0.132, 0.043999, "L"}, {0.264, -0.087997, "", "D"}, {0.396, -0.396}, {0.792, -1.363998}, {0.792, -1.540001}, 2, {0.0, 0.0, "S"}, 3, {0.22, -0.440002, "", "F"}, {1.1, -1.979996}, {1.364, -2.771999}, {1.76, -3.035997}, {1.848, -2.816}, {1.54, -3.212}, {1.232, -2.596001}, {1.452, -3.168001}, {1.452, -3.256001}, {1.012, -2.596}, {0.88, -1.848}, {1.056, -1.848001}, {1.584, -3.344}, {1.408, -3.652}, {1.628, -5.632}, {1.54, -6.732}, {1.232, -8.359999}, {0.748, -7.92, "F"}, {1.144, -9.855995}, {0.616, -2.507999}, 5, {0.528, -1.32}, {1.716, -3.035999}, {2.2, -4.619999}, {2.772, -4.883999, "", "F"}, {3.256, -4.223999}, {2.112, -2.639999}, {1.716, -3.035999}, {2.068, -4.136009}, {1.232, -2.639999}, {0.836, -2.068001}, {0.66, -1.715996}, {0.748, -2.508003}, {0.352, -1.584, "U"}, {0.176, -1.012001}, {0.176, -0.923996}, {0.176, -1.011993}, {0.396, -1.363998, "J"}, {0.132, -0.616005, "", "J"}, {0.0, -0.396011, "", "U"}, {0.0, -0.263992, "", "S"}, {0.0, -0.219994}, 1, {0.0, 0.0, "D"}, 14, {0.0, 0.087997}, {0.0, 0.220001}, {-0.176, 0.924004}, {-1.848, 4.444008}, {-2.464, 5.895996}, {-4.444, 11.044006}, {-2.2, 5.676003}, {-4.62, 10.515999}, {-3.828, 6.467999}, {-4.752, 7.743999, "F"}, {-2.508, 3.651999}, {-2.376, 3.167999, "", "D"}, {-1.672, 2.024}, {-1.144, 1.056, "", "L"}, {-0.528, 0.528}, {-0.264, 0.132}, 7, {-0.088, -0.088001}, {0.0, -0.132002}, {0.0, -0.176003}, {0.0, -0.088001}, {0.0, -0.088001}, {-0.088, -0.176001}, {-0.176, -0.219999}, {-0.22, -0.088001}, {-0.176, 0.044001, "JL"}, {-0.396, 0.396, "", "J"}, {-0.572, 1.1, "", "F"}, {-0.088, 0.396}, {-0.044, 0.132}, {-0.044, 0.132}, {-0.044, 0.176001}, {-0.044, 0.396}, {-0.088, 0.924}, {-0.132, 1.32}, {-0.088, 1.716}, {-0.352, 2.507998}, {-0.176, 2.2, "S"}, {-0.176, 2.332}, {-0.352, 2.992001}, {-0.22, 2.42}, {-0.22, 2.684}, {-0.088, 2.376, "R", "L"}, {-0.22, 2.816}, {-0.264, 1.1, "", "S"}, {-0.044, 0.308}, 1, {-0.044}, {-0.132, -0.792}, {-0.22, -1.804}, {-0.132, -2.332}, {-0.044, -4.356}, {-0.088, -3.124001}, {-0.528, -2.904, "L", "", 0.0, 0.0}, {-1.232, -3.432, "", "R"}, {-1.936, -3.651999}, {-1.936, -2.112}, {-1.76, -1.1}, {-2.068, -0.440001}, {-2.992, 1.188}, {-2.42, 2.375999, "S"}, {-2.42, 3.256001}, {-2.86, 4.312}, {-1.804, 2.464001, "F"}, {-1.144, 1.188}, {-0.572, 0.088}, {-0.396, -1.584001, "", "L"}, {-0.044, -2.552}, {0.0, -2.772}, {0.088, -2.419999}, {0.132, -1.98}, {0.044, -1.627998}, 1, {0.044, -0.132}, {0.132, 0.087999}, {0.44, 1.056}, {0.66, 1.672001}, {0.968, 2.375999}, {0.968, 2.244}, {0.484, 0.615999}, {0.484, 0.088}, {0.484, -0.572}, {0.572, -1.495999}, {0.616, -1.892}, {0.66, -3.035999}, {0.484, -3.652, "L"}, {0.528, -5.632}, {0.44, -5.279999}, {0.352, -5.368}, {0.352, -4.795998}, {0.22, -4.84}, {0.132, -3.212002}, {0.132, -2.947998}, {0.088, -3.035999}, {0.088, -2.067997, "", "F"}, {0.132, -2.419998}, {0.22, -2.684002}, {0.22, -3.080002}, {0.264, -3.916008}, {0.748, -14.036003}, 2, {0.0, -0.571999}, {0.044, -0.264}, 10, {0.0, -0.219994}, {0.0, -0.219994}, {0.0, -0.043999}, {0.0, -0.087997}, {0.0, -0.043999}, 10, {0.0, 0.0, "R", "", 0.0, 0.0}, {0.0, 0.0, "", "L"}, 3, {0.0, 0.0, "", "R"}, 2}},{"B Main","B Bombsite (Selfboost)","movement","weapon_knife",204.969,-473.018,1613.031,1.716,-125.051,"custom_876",["data"]={11, {0.0, 0.0, "F"}, 104, {0.088, 0.131996}, {0.0, 0.44001}, {0.0, 0.528008}, {0.0, 0.572006}, {0.0, 0.219994}, {0.0, 0.219994}, {0.0, 0.175995}, {0.0, 0.440002}, {0.0, 0.396011}, {0.0, 0.616013}, {0.0, 0.264008}, {0.0, 0.440002}, {0.0, 0.219994}, {0.0, 0.263992}, {-0.044, 0.396004}, {-0.044, 0.484009}, {0.0, 0.484009}, {-0.044, 0.704002}, {-0.044, 0.792007}, {0.0, 0.484009}, {-0.044, 0.44001}, {-0.044, 0.352005}, {0.0, 0.352005}, {0.0, 0.528015}, {-0.044, 0.484009}, {0.0, 0.70401}, {0.0, 0.616005}, {-0.044, 0.660004}, {-0.044, 0.792}, {-0.044, 0.835999}, {-0.132, 1.012001}, {-0.044, 0.704002}, {-0.044, 0.748001}, {-0.044, 1.012001}, {-0.044, 0.704002}, {0.0, 0.748001}, {-0.044, 0.792, "Z"}, {-0.176, 1.760002}, {-0.132, 1.452003}, {-0.132, 1.540001}, {-0.088, 1.144005}, {-0.088, 1.100006}, {-0.044, 1.275993}, {-0.044, 0.967995}, {0.0, 0.923996}, {0.0, 0.660004}, {0.0, 0.484009, "", "Z"}, {0.0, 0.352005}, {0.0, 0.44001}, {0.0, 0.616005}, {0.088, 1.012001}, {0.088, 1.011993}, {0.176, 1.496002}, {0.088, 0.615997}, {0.132, 0.924004}, {0.088, 0.220001}, {0.044, 0.087997, "L"}, 1, {0.0, 0.0, "", "L"}, 1, {0.132, 0.087997}, {0.132}, {0.44, -0.087997}, {0.352, -0.175995}, {0.264, -0.131996}, {0.264, -0.131996}, {0.528, -0.131996}, {0.572, -0.087997}, {0.572, 0.043999, "J"}, {1.364, 0.263992, "", "J"}, {1.452, 0.352005, "R"}, {1.628, 0.396011}, {1.716, 0.175995, "", "F"}, {3.036, -0.307999}, {1.936, -0.484009}, {1.452, -0.704002}, {1.1, -0.968002}, {0.968, -0.792}, {0.924, -0.967995}, {0.66, -0.967995}, {0.484, -1.099998}, {0.176, -0.704002}, {0.044, -0.572006}, {0.088, -0.087997, "F"}, {0.088, 0.484001, "", "R"}, {0.22, 1.584}, {0.352, 2.507996}, {0.616, 2.992004}, {0.968, 3.739998}, {0.44, 2.112007}, 4, {0.044, 0.132004}, {0.088, -0.087997}, {0.088, 0.880005}, {0.528, 3.080002}, {1.628, 4.488007}, {1.584, 4.795998}, {1.584, 4.752003}, {1.012, 2.155998}, {0.968, 1.936001}, {1.276, 3.212002}, {1.452, 3.476002}, {0.352, 0.264}, 5, {0.088, -0.043999}, {-0.044, -0.043999}, {0.0, -0.264004}, {-0.572, -0.307999}, {-0.616, -0.880001}, {-0.616, -0.924}, {-0.704, -0.528}, {-0.968, -0.704002}, {-1.628, -1.187996}, {-3.124, -1.848, "J"}, {-2.816, -0.836002, "", "J"}, {-3.036, -0.264, "L"}, {-3.212, 1.539997}, {-1.98, 2.111996, "", "F"}, {-1.144, 2.023998}, {-0.572, 2.551998}, {-0.176, 3.871998}, {0.0, 1.891998}, {0.22, 3.827999}, {0.352, 2.420002}, {0.924, 2.464001}, {1.276, 1.891998}, {1.232, 1.143997}, {1.364, 0.747997}, {1.892, 0.439999, "R", "L", 0.0, 225.0}, {0.968}, {0.836, -0.219997}, {0.704, -0.571999}, {0.616, -0.659996}, {0.66, -1.276001}, {0.484, -1.056}, {0.308, -0.879997, "D"}, {0.22, -0.880001}, {0.0, -0.616001}, {0.0, -0.439999}, {0.0, -0.396004}, 1, {0.088, 0.087997}, {0.044, 0.220001}, {0.22, 0.571999}, {0.396, 1.012001}, {0.748, 2.419998}, {0.616, 3.079998, "F"}, {0.528, 5.191999}, {0.44, 7.656}, {0.44, 7.612, "", "D"}, {0.484, 7.656}, {0.572, 8.536, "", "R"}, {0.352, 10.076}, {-0.528, 3.74}, {-0.176, 0.219999}, 5, {-0.132, 0.087999}, {0.22, 0.615999}, {1.1, 2.023998}, {1.672, 2.771999}, {0.88, 1.143999}, {1.804, 1.363998}, {1.144, 0.087999}, {1.188, -0.572001}, {0.748}, {1.012, 0.132002}, {1.144, 0.044001}, {1.1}, {1.056, -0.088001}, {0.572, -0.043999}, {0.616, 0.132002}, {0.88, 0.264}, {0.704, 0.307999}, {0.66, 0.351999}, {0.704, 0.264}, {0.264, 0.088001}, {0.616, 0.176003}, {0.616, 0.044001}, {0.396, 0.088001}, {0.132}, {0.088, -0.088001}, {-0.044, -0.176001}, {-0.924, -0.66}, {-3.168, -1.452, "J"}, {-2.728, -0.704, "", "J"}, {-3.08, 0.088001, "L", "", 450.0, -225.0}, {-4.004, 1.628}, {-4.4, 3.608, "", "F"}, {-2.728, 3.168001}, {-1.98, 3.211998}, {-1.452, 3.035999}, {-1.276, 4.003998}, {-0.484, 3.563999}, {-0.132, 2.860001}, {-0.088, 2.199997}, {-0.088, 2.903996}, {0.0, 1.936001}, {-0.044, 2.200001}, {-0.176, 2.771996}, {-0.088, 2.199997}, {-0.088, 1.716}, {-0.088, 1.715996}, {-0.088, 2.375992}, {0.0, 1.804001}, {-0.044, 1.848}, {-0.044, 1.671997}, {-0.044, 1.804001}, {0.0, 2.287994}, {-0.044, 1.980003}, {0.0, 1.715996}, {0.0, 2.243996}, {0.0, 1.012001}, {0.044, 1.848007}, {0.22, 1.23201}, {0.264, 1.011993, "R", "L"}, {0.308, 0.924004}, {0.22, 0.307999}, {0.352, -0.043999}, {0.836, -0.792, "D"}, {0.572, -1.144005}, {0.396, -1.452003}, {0.132, -1.759995}, {0.0, -2.243996}, {-0.176, -0.880005}, {-0.44, -1.012009}, {-0.528, 0.264}, {-0.484, 1.012001}, {-0.176, 1.188004}, {0.528, -0.660004}, {0.748, -4.751999}, {0.176, -3.739998}, {0.132, -7.612}, {-0.176, -5.015999}, {-0.396, -2.551998}, {-0.264, -0.396, "F"}, {-1.144, 1.803997}, {-1.056, 3.212002}, {-0.616, 5.456001}, {-0.044, 3.211998}, {0.0, 2.375999, "", "D"}, {0.0, 2.068001}, {0.0, 2.375999}, {0.044, 2.991997}, {-0.088, 0.484001}, {0.0, 0.0, "S"}, 5, {-0.088}, 1, {0.088, 0.219994}, {0.088, 0.616005}, {0.0, 1.056}, 1, {0.0, 0.307999}, {-0.176, 0.175995}, {-0.22, 0.35199}, {-0.176, 0.263992}, {-0.264, 0.263992}, {-0.088, 0.087997}, 2, {0.0, 0.0, "", "F"}, 14}},{"A Site","A Site Route","movement","weapon_knife",-511.031,1111.001,1691.031,4.4,-2.539,"custom_877",["data"]={{0.0, 0.0, "F"}, 8, {0.0, 0.0, "J"}, {0.0, 0.0, "", "J"}, 11, {0.0, 0.0, "R"}, 5, {0.0, 0.0, "", "R"}, 9, {0.0, 0.044}, {0.176, 0.044}, {0.484, 0.132}, {0.44, 0.044}, {0.484}, {0.44, 0.088}, {0.352, 0.044}, {0.264, 0.0, "J"}, {0.352, 0.044, "", "J"}, {0.396}, {0.22}, 1, {0.264, 0.0, "Z"}, {0.132}, 6, {0.0, 0.0, "", "Z"}, 7, {0.132, 0.132}, {0.044, 0.088}, {0.22, 0.22}, {0.176, 0.22}, {0.22, 0.176}, {0.132, 0.132}, {0.22, 0.22}, {0.132, 0.132}, {0.22, 0.22}, {0.088, 0.044}, {0.088, 0.132}, {0.22, 0.176}, {0.176, 0.176}, {0.264, 0.22}, {0.264, 0.308, "L"}, {0.22, 0.132}, {0.044, 0.044}, {0.088, 0.044, "", "L"}, {0.044}, {0.132}, {0.132, 0.044}, {0.132}, {0.22, 0.044}, {0.22}, {0.176, 0.132}, {0.396, 0.088}, {0.264, 0.088}, {0.176, 0.088}, {0.264, 0.088}, {0.176, 0.132}, {0.088, 0.088}, {0.044, 0.044}, 4, {0.0, -0.044}, {-0.528, -0.484}, {-0.88, -0.836}, {-1.144, -1.1}, {-1.716, -1.496}, {-0.66, -0.44, "R"}, {-0.704, -0.264, "J"}, {-0.22, 0.704, "", "J"}, {0.044, 1.496}, {0.88, 2.244, "", "F"}, {1.012, 1.144}, {1.188, 0.704}, {1.232, 0.088}, {1.628, -0.44}, {1.232, -0.528}, {1.232, -0.748}, {1.056, -0.792}, {0.88, -0.88}, {0.968, -1.276, "D"}, {0.572, -0.968}, {0.44, -1.056}, {0.22, -0.44}, {0.088, -0.264}, {0.132, -0.44}, {0.22, -0.528}, {0.22, -0.748}, {0.22, -0.572}, {0.22, -0.528}, {0.132, -0.44}, {0.176, -0.44}, {0.132, -0.484}, {0.176, -0.484}, {0.132, -0.396}, {0.132, -0.484}, {0.264, -0.747999}, {0.088, -0.396, "", "D"}, {0.176, -0.880001, "J"}, {0.044, -0.616, "L", "J", 0.0, 225.0}, {0.0, -0.396, "", "", 0.0, 0.0}, {0.0, -0.22, "", "R"}, {-0.088, -0.131999}, 1, {-0.044, 0.088}, {0.0, 0.396}, {0.0, 0.835999}, {0.132, 1.496}, {0.088, 1.012}, {0.132, 0.924}, {0.132, 0.66}, {0.176, 0.528}, {0.132, 0.44}, {0.088, 0.352}, {0.044, 0.352}, {0.22, 0.924}, {0.22, 1.012}, {0.132, 1.364}, {0.176, 1.892}, {0.132, 0.748}, {0.132, 0.352}, {0.088, 0.308}, {0.088, 0.396}, {0.088, 0.44}, {0.044, 0.484}, {0.044, 0.572}, {0.0, 0.792}, {0.0, 1.232}, {0.0, 1.012}, {0.044, 1.056001}, {0.0, 1.364}, {0.0, 0.923999}, {0.0, 1.627999}, {0.0, 0.924}, {-0.132, 2.376}, {-0.088, 1.98}, {-0.132, 2.243999}, {-0.132, 2.816}, {-0.176, 4.4}, {-0.176, 4.620001, "Z"}, {-0.22, 4.356001}, {-0.308, 6.688}, {-0.44, 4.927998}, {-0.44, 4.223999}, {-0.44, 3.695999, "J"}, {-0.352, 2.771999, "", "J"}, {-0.308, 3.123997}, {-0.22, 2.155998}, {-0.176, 3.080006, "", "Z"}, {-0.088, 2.288002}, {-0.088, 1.980003}, {0.0, 2.068008}, {0.0, 2.507996}, {0.0, 1.803993}, {0.0, 1.848}, {-0.044, 1.584}, {-0.044, 1.23201}, {-0.088, 1.407997}, {0.0, 1.011993}, {0.0, 1.496002}, {-0.176, 2.772003}, {-0.264, 0.879997}, {-0.264, -0.264}, 1, {0.0, 0.0, "", "L"}, 2, {0.0, 0.0, "F"}, 3, {-0.088}, {-0.044, -0.219994}, {-0.088, -0.087997}, {-0.44, 0.043999}, {-0.44, -0.263992}, {-0.66, -0.395996}, {-0.572, -0.263992}, {-0.528, -0.484009}, {-0.44, -0.704002}, {-0.396, -0.44001}, {-0.528, -0.660011}, {-0.308, -0.879997}, {-0.264, -0.835999}, {-0.132, -0.572006}, {0.0, -0.131996}, {0.0, -0.087997}, {0.0, -0.043999}, {0.0, -0.043999}, {0.0, -0.131996}, {0.0, -0.043999}, {-0.044, -0.087997}, {-0.044, -0.043999}, {-0.132, -0.175995}, {-0.132, -0.131996}, {-0.22, -0.087997}, {-0.572, -0.35199}, {-0.572, -0.396011}, {-0.528, -0.484009}, {-0.528, -0.396004}, {-0.22, -0.043999}, {-0.132, 0.748001}, {0.264, 1.848, "JR"}, {0.924, 2.771996, "", "J"}, {2.816, 4.839996}, {2.64, 2.288002, "", "F"}, {3.256, 0.968002}, {3.872, -0.704002}, {2.64, -1.584}, {1.98, -1.759995}, {1.496, -1.715996}, {1.056, -1.847992}, {1.144, -2.551994}, {0.836, -1.936005}, {0.704, -1.671997}, {0.66, -1.671997}, {0.616, -1.540001}, {0.22, -0.967995}, {0.264, -0.879997}, {0.22, -1.540001}, {0.088, -0.792007}, {0.352, -1.540001}, {0.264, -1.23201}, {0.176, -2.024002}, {0.0, -1.584}, {0.0, -1.672001}, {-0.176, -1.759998}, {-0.704, -2.463997}, {-0.44, -1.144001}, {-1.1, -1.716, "L", "", 0.0, 225.0}, {-1.1, -1.056, "", "", 0.0, 0.0}, {-1.54, -0.132, "", "R"}, {-1.188, 0.747997}, {-1.144, 1.276001}, {-1.144, 1.98}, {-1.1, 2.640003}, {-0.616, 2.023998}, {-0.352, 2.595997, "J"}, {-0.264, 3.387993, "", "J"}, {-0.088, 3.431999}, {-0.044, 4.531998}, {0.0, 2.860008}, {0.0, 2.860001}, {-0.044, 2.992004}, {0.0, 1.187996, "Z"}, {0.0, 2.068001}, {0.0, 1.276009}, {0.044, 0.967995}, {0.0, 1.363991}, {0.0, 1.276009}, {0.0, 1.364006}, {0.0, 1.936005}, {0.0, 1.540001}, {0.0, 1.627998, "", "Z"}, {0.0, 1.320007}, {0.0, 1.628014}, {0.0, 1.276009}, {0.0, 1.276009}, {0.0, 1.276009}, {0.0, 1.143997}, {0.0, 0.396004}, {0.044, 0.131996}, {0.088, 0.043999}, {0.176, -0.087997, "R", "L", 0.0, 225.0}, {0.264, -0.484009}, {0.352, -0.704002}, {0.528, -1.187996}, {0.396, -1.100006}, {0.484, -1.276009}, {0.396, -1.363998}, {0.484, -1.496002}, {0.66, -2.508003}, {0.308, -1.891998}, {0.176, -1.936005}, {0.088, -1.496002}, {0.0, -1.76001, "L", "", 0.0, 0.0}, {0.0, -0.923996, "", "", 0.0, 0.0}, {-0.088, -0.308006, "", "R"}, {-0.176, 0.176003}, {-0.484, 1.627998}, {-0.352, 1.672005}, {-0.264, 2.332001, "R", "L"}, {-0.176, 2.640007}, {0.0, 0.616005}, {0.0, 0.087997}, {0.044, -0.132004}, {0.088, -1.232002}, {0.132, -2.683998}, {0.0, -2.332001}, {-0.044, -2.992004, "F", "R"}, {-0.352, -2.02401}, {-0.484, -1.363998}, {-0.968, -2.068001}, {-1.452, -1.980003}, {-0.704, -0.967995}, 9, {-0.088, -0.264}, {-0.088, -0.087997}, {-0.352}, {-0.264}, {-0.176, 0.0, "R"}, {-0.088}, 2, {0.0, 0.0, "", "R"}, 7, {0.0, 0.043999}, {0.0, 0.043999}, 1, {0.044, 0.264}, {0.132, 0.307999}, {0.132, 0.616005}, {0.176, 0.704002}, {0.264, 0.836006}, {0.22, 0.660004}, {0.132, 0.484009}, {0.22, 0.616005}, {0.308, 0.70401, "R"}, {0.308, 0.484009}, {0.396, 0.484009}, {0.484, 0.572006}, {0.66, 0.660011}, {0.528, 0.44001, "", "R"}, {0.88, 0.792007}, {0.616, 0.572006}, {0.66, 0.528008}, {0.66, 0.528008}, {0.704, 0.616005}, {0.968, 0.968002}, {0.88, 0.792}, {0.924, 0.835999}, {1.188, 0.968002}, {1.012, 0.792}, {0.968, 0.704002}, {1.408, 1.012001}, {1.144, 0.792}, {0.968, 0.704002}, {1.012, 0.704002}, {1.276, 0.924004}, {0.792, 0.571999}, {1.452, 0.924004}, {1.1, 0.704002}, {0.88, 0.44001}, {0.968, 0.484009}, {0.572, 0.219994}, {0.44, 0.087997}, {0.22, -0.087997}, {0.132, -0.395996}, {-0.264, -0.528008}, {-0.836, -0.704002}, {-1.584, -1.099998}, {-3.652, -1.76001, "J"}, {-3.608, -1.144005, "", "J"}, {-3.08, -0.748001, "L"}, {-3.872, 0.087997, "", "F"}, {-1.716, 0.835999}, {-2.816, 3.519997}, {-1.584, 3.431999}, {-1.54, 3.915993}, {-1.144, 5.104004}, {-0.352, 3.784004}, {-0.132, 3.080002}, {-0.088, 3.916}, {0.0, 2.508003}, {0.0, 2.420013}, {0.0, 2.199997}, {0.0, 2.903992}, {0.088, 1.847992}, {0.088, 1.848007}, {0.132, 1.936005}, {0.088, 1.187988}, {0.22, 1.012009}, {0.264, 0.70401, "", "L"}, {0.352, 0.395996, "R"}, {0.528, 0.132004}, {0.924, -0.396011}, {0.836, -0.703995}, {1.056, -1.276001}, {0.484, -0.660004}, {0.572, -1.188004}, {0.352, -1.452011}, {0.264, -1.848007}, {0.22, -2.596008}, {0.0, -1.584, "L", "", 0.0, 225.0}, {0.0, -1.143997, "", "", 0.0, 0.0}, {-0.088, -0.968018, "", "R"}, {-0.132, -0.572006}, {-0.396, -0.264008}, {-0.484, 0.440002}, {-0.66, 1.319992}, {-0.66, 2.068008, "R", "L"}, {-0.792, 3.73999}, {-0.352, 2.684006}, {-0.352, 2.771988}, {-0.264, 3.036011, "F"}, {-0.176, 1.979996}, {-0.132, 2.155991}, {-0.176, 2.552002}, {-0.22, 4.664001, "", "R"}, {-0.22, 3.784012}, {-0.352, 4.532013}, {-0.748, 4.048004}, {-1.892, 5.32402}, {-1.32, 3.167999}, {-1.496, -356.612, "R"}, {-1.232, 3.212006}, {-1.188, 4.972}, {-0.66, 2.552017}, {-0.396, 0.615997}, 2, {0.0, 0.0, "", "R"}, 5, {-0.132, 0.484009}, {0.044, 0.660004, "R"}, {-0.22, 1.891998}, {-0.176, 1.539993}, {-0.088, 1.143997}, {0.0, 2.024002}, {0.0, 2.815994}, {0.0, 3.079987, "", "R"}, {0.132, 2.156006}, {0.616, 1.891998}, {1.188, 1.803986}, {0.704, 0.175995}, 6, {0.088}, {0.484, 0.483994}, {0.176, 0.483994}, {0.176, 0.572006}, {0.396, 1.276001}, {0.308, 1.40799}, {0.396, 1.408005}, {0.264, 0.835999}, {0.264, 0.571991}, {0.264, 0.527985}, {0.308, 0.528}, {0.352, 0.440002}, {0.088, 0.087997}, 2, {0.0, 0.0, "L"}, {0.044, 0.132004, "J"}, {0.132, 0.527985, "", "J"}, {0.264, 1.364014, "", "F"}, {0.572, 2.860001}, {0.44, 2.464005}, {0.176, 1.056}, {0.352, 1.320007}, {0.44, 1.143997}, {0.528, 1.056}, {0.352, 0.880005}, {0.22, 0.484009}, {0.264, 0.528008}, {0.264, 0.572006}, {0.264, 0.616005}, {0.088, 0.44001}, {0.132, 0.70401}, {0.132, 0.484009, "D"}, {0.132, 1.012001}, {0.132, 1.276001}, {0.0, 1.496002}, {0.044, 1.584}, {0.044, 2.068001}, {0.0, 1.627998}, {0.044, 1.804001}, {0.044, 1.891998}, {0.0, 2.684006}, {0.0, 1.804001}, {0.0, 2.112}, {0.0, 1.099998}, {0.0, 2.816002}, {0.0, 2.81601}, {0.0, 3.300003, "", "D"}, {0.0, 4.840012, "J"}, {-0.088, 4.268005, "", "J"}, {-0.044, 4.179993}, {0.0, 5.148003}, {0.0, 2.024002}, {0.0, 3.916}, {0.308, 2.112007}, {0.616, 2.287994}, {0.22, 1.275997}, {0.484, 1.672001}, {0.66, 2.507996}, {0.528, 1.540001}, {0.616, 1.276001}, {0.264, 0.264}, {0.352, 0.088001}, {0.66, -0.924, "R", "", 0.0, 0.0}, {0.484, -0.880001, "", "L"}, {1.364, -3.123997}, {1.1, -2.815998}, {0.968, -2.595997}, {0.792, -2.684006}, {0.748, -3.519997}, {0.66, -3.475998}, {0.44, -2.904007}, {0.484, -3.432007}, {0.352, -2.420006}, {0.264, -2.419998}, {0.308, -2.815994}, {0.396, -5.015999}, {0.264, -4.575996}, {0.22, -4.091995}, {0.22, -3.872002}, {0.264, -4.531998}, {0.176, -4.839996}, {0.044, -4.223999}, {0.0, -3.255997}, {-0.088, -1.980003}, {0.0, -2.156006}, {0.0, -3.388008}, {-0.088, -2.28801}, {-0.044, -1.671997}, {-0.132, -1.540009}, {-0.088, -1.319992}, {0.0, -1.539993}, {-0.044, -0.87999, "L", "", 0.0, 0.0}, {0.0, 0.0, "", "", 0.0, 0.0}, {0.0, 0.0, "", "", 0.0, 0.0}, {0.0, 0.0, "J", "R"}, {0.0, 0.044006, "", "J"}, {0.0, 0.703995}, {0.0, 0.792023}, {0.088, 0.968002}, {0.088, 1.627991}, {0.088, 1.276001}, {0.176, 1.804001}, {0.132, 2.155991}, {0.176, 3.212006}, {0.132, 1.848}, {0.176, 1.672005, "Z"}, {0.088, 0.792}, {0.132, 1.408005}, {0.044, 2.155998}, {0.0, 1.671997}, {0.0, 1.936005}, {0.0, 2.112007}, {0.0, 3.872002, "", "Z"}, {-0.132, 3.124001}, {-0.132, 3.476006}, {-0.308, 4.620003}, {-0.264, 3.871994}, {-0.396, 3.696007}, {-0.528, 4.664009}, {-0.396, 2.552002}, {-0.44, 2.332001}, {-0.352, 2.288002}, {-0.484, 2.463997}, {-0.792, 3.872009}, {-0.616, 2.772003}, {-0.748, 2.816002}, {-0.924, 3.124001}, {-0.484, 1.759998}, {-1.056, 3.475998}, {-0.836, 2.815998}, {-0.968, 3.563999}, {-0.66, 2.243999}, {-0.44, 1.671997}, {-0.264, 2.023998}, {-0.132, 1.496002}, {-0.044, 1.408001}, {-0.044, 0.924, "J"}, {-0.044, 1.231998, "", "J"}, {0.0, 1.760002}, {0.0, 1.98}, {0.0, 1.759998}, {0.0, 1.495998}, {0.0, 1.935999}, {0.0, 1.716}, {0.044, 1.716}, {0.0, 1.98}, {0.0, 0.836}, {0.0, 1.804001}, {0.0, 0.924}, {0.0, 0.615999}, {-0.044, 0.483999}, {-0.088, 0.792}, {0.0, 0.483999}, {-0.044, 0.351999}, {0.0, 0.132}, 1, {0.0, -0.044001, "R", "", 0.0, 0.0}, {0.0, -0.088001, "", "", 0.0, 0.0}, {0.176, -0.615999, "", "L"}, {0.264, -0.792}, {0.352, -1.188}, {0.176, -0.572001}, {0.176, -1.011999}, {0.308, -1.275999}, {0.088, -0.528}, {0.22, -1.275997}, {0.132, -0.615999}, {0.088, -0.439999}, 1, {0.0, 0.0, "L", "", 0.0, 225.0}, {0.0, 0.0, "", "", 0.0, 0.0}, {0.0, 0.219999, "", "R"}, {-0.088, 0.528}, {-0.132, 0.967999}, {-0.088, 0.528002}, {-0.088, 0.440001}, {0.0, 0.351999, "R", "", 0.0, -225.0}, {0.0, 0.175999, "", "L"}, 3, {-0.044, 0.044001, "L", "", 0.0, 225.0}, {0.0, 0.0, "", "R"}, 1, {-0.044, 0.087999}, {-0.088, 0.219999}, {-0.176, 0.571999}, {-0.396, 0.924002}, {-0.528, 1.232}, {-0.528, 1.188}, {-0.792, 1.716, "F", "L"}, {-0.792, 1.804001}, {-0.924, 2.464}, {-0.572, 1.804}, {-0.572, 2.816}, {-0.88, 2.508}, 4, {0.0, 0.0, "L"}, 1, {0.0, 0.0, "", "L"}, 3, {-0.132, 0.308}, {-0.176, 0.352}, {-0.176, 0.132}, {-0.132, 0.308}, {-0.132, 0.572}, {0.0, 0.088}, {0.0, 0.264}, {0.0, 0.792}, {0.0, 0.704}, {0.044, 0.528}, {0.088, 0.968}, {0.0, 0.66}, {0.0, 1.188}, {0.0, 1.232}, {0.0, 1.364}, {-0.044, 1.98}, {-0.132, 1.716}, {-0.176, 1.76}, {-0.264, 2.156}, {-0.396, 3.388}, {-0.132, 2.684}, {-0.044, 2.42}, {-0.044, 1.716, "R"}, {0.0, 0.924}, {0.0, 0.132}, {-0.044, -0.396, "J"}, {0.132, -0.66, "", "J"}, {0.792, -2.552, "", "F"}, {0.836, -3.036}, {0.44, -2.596}, {0.264, -2.816}, {0.044, -3.52}, {0.0, -3.168}, {0.0, -3.388}, {-0.088, -3.784}, {-0.44, -5.148}, {-0.704, -2.86}, {-0.88, -1.936001, "L", "", 0.0, 0.0}, {-0.924, -0.527998, "", "R"}, {-0.704, 0.835999}, {-0.616, 1.628}, {-0.352, 2.464001}, {-0.044, 3.167999}, {0.0, 2.112}, {0.0, 1.276, "R", "L"}, {0.308, 0.792}, {0.704, 0.132}, {0.66, -0.396}, {0.528, -0.748}, {0.572, -1.276}, {0.528, -2.156}, {0.132, -2.244}, {0.0, -2.508001, "L", "", 0.0, 0.0}, {-0.088, -3.124001, "", "R"}, {-0.396, -1.628}, {-0.66, -0.836, "D"}, {-0.748, 0.351999}, {-0.836, 1.143999}, {-1.144, 2.684}, {-0.66, 1.672}, {-0.308, 0.484}, {-0.088, -0.615999, "R", "", 0.0, 0.0}, {-0.132, -2.552, "", "", 0.0, 0.0}, {-0.924, -3.431999, "", "L"}, {-1.232, -1.671999}, {-2.156, 0.264}, {-1.804, 1.892, "F", "", 225.0}, {-1.32, 1.76}, {-0.66, 0.043999}, {-1.144, -2.948, "", "DR"}, {-0.924, -3.167999}, {-0.66, -2.639999}, {-0.484, -1.452}, {-0.264, -0.439999}, {-0.22, 0.483999}, {-0.132, 0.747999}, {0.0, 0.132}, 3, {0.0, 0.044001}, {0.308, -0.836}, {0.396, -1.056}, {0.088, -0.351999}, {0.0, -0.219999}, {0.0, -0.176001}, {0.0, -0.132002}, {0.0, -0.396}, {0.0, -0.66}, {0.0, -0.748001}, {-0.044, -0.572001}, {-0.176, -0.615999}, {-0.264, -0.704}, {-0.308, -0.396}, {-0.22}, {-0.044, 1.056002}, {0.0, 3.343998, "R"}, {-0.044, 2.727999}, {0.044, 4.048002, "", "F"}, {0.572, 0.66, "J"}, {1.408, -1.056, "", "J"}, {3.036, -3.431997}, {2.332, -3.079998}, {2.112, -2.904001}, {2.64, -4.399996}, {1.54, -3.167999}, {1.276, -3.211998}, {1.012, -2.464001}, {1.188, -2.992001}, {0.748, -2.112, "D"}, {0.704, -2.332001}, {0.924, -2.507996}, {0.792, -2.420002}, {0.704, -2.595997}, {0.132, -1.32}, {0.0, -0.967999}, {0.0, -0.748001}, {-0.132, -0.924, "L", "", 0.0, 0.0}, {-0.22, -0.836002, "", "", 0.0, 0.0}, {-0.132, -0.220001, "", "R"}, {-0.44, 0.043999}, {-0.484, 0.307999}, {-0.264, 0.307999}, {-0.176, 0.396}, {-0.088, 0.528}, {-0.132, 0.308002}, {-0.132, 0.439999}, {-0.132, 0.527996}, {-0.264, 0.748001}, {-0.352, 1.627998}, {-0.396, 2.156002}, {-0.528, 2.332001}, {-0.44, 2.639999}, {-0.22, 1.231998}, {-0.132, 1.012001}, {-0.132, 1.144001, "F", "", 225.0}, {-0.176, 1.671997, "", "D"}, {-0.44, 3.035999, "", "L"}, {-0.352, 2.859997}, {-0.528, 3.431999}, {-0.352, 3.299995}, {-0.308, 4.619999, "S"}, {-0.22, 3.299999}, {-0.176, 2.860001}, {-0.088, 2.684}, {-0.088, 1.1}, {0.0, 0.615999}, {0.0, 0.087999}, 3, {0.0, 0.132002}, {0.0, 0.351999}, {0.0, 0.792}, {0.0, 1.76}, {0.0, 2.464, "R"}, {0.0, 4.752}, {0.088, 4.444}, {0.0, 4.796}, {0.0, 4.884}, {0.0, 4.092}, {0.0, 4.796}, {0.0, 4.620002}, {0.0, 2.507999, "", "F"}, {0.0, 4.223999}, {0.0, 3.432001}, {0.0, 2.903999}, {0.0, 2.771997}, {0.0, 3.343998}, {0.0, 2.507996}, {0.0, 2.683998}, {0.0, 2.507999}, {0.0, 2.903999}, {0.0, 1.804001}, {0.0, 1.759998}, {0.0, 0.571999}, {-0.044, 0.967999}, {0.0, 0.308002}, {0.0, 0.088001}, 3, {-0.264, 0.043999}, {-0.308}, {-0.836, 0.043999}, {-0.748, 0.043999}, {-1.056, 0.352001}, {-0.352, 0.264}, {-0.616, 0.615997}, {-0.308, 0.527996}, {-0.132, 0.615997}, {-0.044, 0.396}, {-0.044, 0.264004}, {0.0, 0.220001}, {-0.044, 0.308002}, {-0.044, 0.396004}, {-0.044, 0.308002}, {-0.044, 0.264004}, {-0.044, 0.132}, 5, {0.0, 0.087997}, {0.0, 0.220001}, {0.132, 0.396}, {0.132, 0.528}, {0.088, 0.396}, {0.132, 0.308002}, {0.044, 0.308002}, {0.044, 0.220001}, {0.044, 0.220001}, {0.044, 0.175999}, {0.088, 0.396}, {0.088, 0.527996}, {0.0, 0.616001}, {0.044, 0.616001}, {0.088, 0.704002}, {0.088, 0.484009}, {0.044, 0.219994}, {0.0, 0.087997}, {0.088, 0.263992}, {0.088, 0.219994}, {0.044, 0.131996}, {0.044, 0.175995}, {0.088, 0.219994}, {0.088, 0.219994}, {0.088, 0.307999}, {0.132, 0.351997}, {0.0, 0.131996}, {0.176, 0.484009}, {0.132, 0.396011}, {0.088, 0.396011}, {0.088, 0.528015}, {0.044, 0.484009}, {0.044, 0.616005}, {0.044, 0.484001}, {0.044, 0.352005}, {0.0, 0.616005}, {0.044, 0.924004}, {0.0, 0.396004}, {0.044, 0.307999}, 2, {0.0, 0.043999}, 1, {0.0, 0.175995}, {0.044, 0.175995}, {0.044, 0.131996}, {0.0, 0.131996}, 2, {0.044, 0.219994}, {0.044, 0.263992}, {0.0, 0.263992}, {0.132, 0.616005}, {0.044, 0.396004}, {0.088, 0.484009}, {0.088, 0.263992}, {0.044, 0.263992}, {0.044, 0.219994}, {0.088, 0.484009}, {0.088, 0.396004}, {0.0, 0.263992}, {0.044, 0.175995}, {0.044, 0.35199}, {0.0, 0.263992}, {0.088, 0.396004}, {0.044, 0.352005}, {0.0, 0.528008}, {0.044, 0.352005}, {0.0, 0.352005}, {0.0, 0.351997}, {0.044, 0.264}, {0.0, 0.572006}, {0.044, 0.660004}, {0.0, 0.44001}, {0.0, 0.836006}, {0.0, 0.484009}, {0.0, 0.263992}, {0.0, 0.572006}, {0.0, 0.836006}, {0.0, 0.220001}, {0.0, 0.087997}, {0.0, 0.043999}, {0.0, 0.087997}, {0.0, 0.087997}, {0.0, 0.131996}, {0.0, 0.219994}, {0.0, 0.219994}, {0.0, 0.352005}, {0.0, 0.307999}, {0.0, 0.35199}, {0.0, 0.219994, "", "R"}, 9}}} end
		if map == "cs_office" then locations_data={{"Snipers Nest","Main Hall","wallbang_hvh","weapon_wallbang",-1520.009,-697.413,-239.969,-1.901,5.709,"custom_584"},{"Front Courtyard","Main Hall","wallbang_hvh","weapon_wallbang",-808.913,-476.874,-233.716,-2.511,-0.059,"custom_585",["duck"]=true},{"Front Courtyard","Main Hall","wallbang_hvh","weapon_wallbang",-304.002,-412.672,-175.969,-0.003,0.398,"custom_586"},{"Front Courtyard","Side Hall","wallbang_hvh","weapon_wallbang",-817.283,-453.446,-277.122,-7.19,3.641,"custom_587",["duck"]=true},{"Back Courtyard","T Spawn","wallbang_hvh","weapon_wallbang",813.983,-1072.031,-205.414,0.299,77.347,"custom_588",["duck"]=true},{"Back Courtyard","Main Hall / T Spawn","wallbang_hvh","weapon_wallbang",1022.87,-1072.02,-209.184,-0.804,108.142,"custom_589",["duck"]=true},{"Main Hall","Snipers Nest","wallbang_hvh","weapon_wallbang",625.011,-394.491,-159.969,2.458,-172.254,"custom_590"},{"Main Hall","Front Courtyard (Pixel Walk)","wallbang_hvh","weapon_wallbang",624.001,-399.846,-107.969,6.33,-179.031,"custom_591"},{"Main Hall","Back Way","wallbang_hvh","weapon_wallbang",807.417,-573.984,-159.969,2.376,-51.159,"custom_592"},{"Side Hall","Stairwell","wallbang_hvh","weapon_wallbang",194.546,18.004,-159.969,4.083,-98.62,"custom_593"},{"Storage Room","Back Way","wallbang_hvh","weapon_wallbang",1068.809,-154.467,-159.969,1.138,-107.421,"custom_594"},{"Storage Room","Back Way","wallbang_hvh","weapon_wallbang",1068.809,-154.467,-159.969,1.138,-107.421,"custom_595"},{"T Spawn","Side Hall","wallbang_hvh","weapon_wallbang",1686.464,623.142,-159.969,0.029,146.231,"custom_596",["duck"]=true},{"Back Way","Main Hall","wallbang_hvh","weapon_wallbang",701.874,-1503.969,-234.094,-2.599,74.046,"custom_597"},{"Garage","Back Way","wallbang_hvh","weapon_wallbang",365.841,-1736.031,-327.969,-4.817,81.782,"custom_598"},{"Back Courtyard","CT Spawn","wallbang_hvh","weapon_wallbang",632.003,-1753.788,-318.748,0.528,-179.849,"custom_599"},{"Bathroom","Back Way","wallbang_hvh","weapon_wallbang",673.698,-299.248,-159.969,1.496,-58.497,"custom_600"},{"Side Alley","CT Spawn","wallbang_hvh","weapon_wallbang",-993.972,-75.584,-352.304,0.188,-94.815,"custom_601",["duck"]=true},{"Side Alley","Side Alley (Entrance)","wallbang_hvh","weapon_wallbang",-855.969,259.64,-367.969,0.27,-63.661,"custom_602",["duck"]=true},{"Side Yard","Side Hall","wallbang_hvh","weapon_wallbang",-960.031,620.697,-175.969,-0.235,-32.491,"custom_603"},{"Office","Front Courtyard / CT Spawn","wallbang_hvh","weapon_wallbang",-764.64,-307.782,-141.514,15.951,-119.857,"custom_604"},{"Front Courtyard","Side Hall / Office (AWP)","wallbang_hvh","weapon_wallbang",-960.031,91.756,-175.969,0.399,-0.715,"custom_605"},{"Front Courtyard","Office (AWP)","wallbang_hvh","weapon_wallbang",-968.774,-295.453,-175.969,0.123,21.009,"custom_606"},{"Snipers Nest","CT Spawn / Office","wallbang_hvh","weapon_wallbang",-1567.032,-420.061,-239.969,4.734,-65.99,"custom_607"},{"Control Room","Control Room Entrance / Stairwell / Office","wallbang_hvh","weapon_wallbang",-827.777,-1162.238,-239.969,-0.487,-14.398,"custom_608"},{"Main Hall","Stairwell Entrance","wallbang_hvh","weapon_wallbang",293.041,-534.992,-159.969,12.097,-149.061,"custom_609",["duck"]=true},{"Main Hall","CT Spawn / Front Courtyard","wallbang_hvh","weapon_wallbang",18.031,-374.131,-159.969,6.735,-148.956,"custom_610"},{"T Spawn","Side Hall","wallbang_hvh","weapon_wallbang",1573.505,199.98,-159.969,1.179,109.39,"custom_611"},{"Front Courtyard","Control Room Entrance (AWP)","wallbang_hvh","weapon_wallbang",-536.992,-975.969,-283.995,-3.121,-90.527,"custom_612"},{"Stairwell","Side Hall / Main Hall","wallbang_hvh","weapon_wallbang",29.467,-1040.004,-185.969,-0.898,81.321,"custom_613"},{"Stairwell","Side Hall","wallbang_hvh","weapon_wallbang",21.969,-754.031,-184.981,-1.402,77.267,"custom_614"},{"Main Hall","Back Way","wallbang_hvh","weapon_wallbang",370.688,-418.031,-159.969,-0.428,-18.978,"custom_615",["duck"]=true},{"T Spawn","T Spawn Entrance","wallbang_hvh","weapon_wallbang",1639.784,464.031,-159.969,0.311,-142.378,"custom_616",["duck"]=true},{"Office","Side Hall","wallbang_hvh","weapon_wallbang",-512.031,-250.718,-159.969,1.56,45.039,"custom_617"},{"CT Spawn","Front Courtyard","wallbang_hvh","weapon_wallbang",-796.713,-2096.114,-293.99,3.185,116.225,"custom_618",["duck"]=true},{"Snowman (Side Yard)","Side Alley Window","wallbang_hvh","weapon_wallbang",-781.414,1162.055,-243.302,-5.474,-91.479,"custom_619",["duck"]=true},{"Snowman (Side Yard)","Side Alley Window","wallbang_hvh","weapon_wallbang",-781.414,1162.055,-243.302,-5.474,-91.479,"custom_620",["duck"]=true},{"Bathroom","Side Alley Window / Office","wallbang_hvh","weapon_wallbang",625.031,-1.995,-159.969,1.241,172.102,"custom_621"},{"Garage","Back Courtyard Stairs","wallbang_hvh","weapon_wallbang",-422.267,-1818.795,-335.969,-0.851,15.022,"custom_622"},{"Kitchen","Storage Room","wallbang_hvh","weapon_wallbang",1329.647,-518.321,-116.687,9.601,84.872,"custom_623"}} end
		if map == "cs_italy" then locations_data={{"Left Alley","Apartment Bridge","grenade","weapon_molotov",-1465.693,177.131,-159.134,-19.874,63.353,"custom_696",["throwType"]="RUN",["runDuration"]=10,["landX"]=-922.552,["landY"]=915.02,["landZ"]=9.89},{"Left Alley","Apartment Hut (Entrance)","grenade","weapon_molotov",-1396.676,186.043,-159.482,-33.971,69.92,"custom_697",["throwType"]="RUN",["runDuration"]=10,["landX"]=-907.918,["landY"]=1185.471,["landZ"]=146.466},{"Left Alley","Left Alley (Corner)","grenade","weapon_molotov",-931.518,-90.099,-160.223,-21.141,135.118,"custom_698",["throwType"]="RUN",["landX"]=-1202.563,["landY"]=840.563,["landZ"]=-163.067},{"Left Alley (Corner)","Left Alley (CT Corner)","grenade","weapon_molotov",-958.438,1034.603,-160.412,-22.144,-135.86,"custom_699",["throwType"]="RUN",["landX"]=-1191.367,["landY"]=142.071,["landZ"]=-162.588},{"Left Alley (Car)","Apartments","wallbang_hvh","weapon_wallbang",-1284.879,1026.567,-102.379,-8.264,-38.766,"custom_700"},{"Apartments","Left Alley (Stairs)","wallbang_hvh","weapon_wallbang",-918.27,1002.576,44.031,14.687,-131.514,"custom_701"},{"Apartments","Left Alley","wallbang_hvh","weapon_wallbang",-848.985,1374.043,0.031,9.776,-118.871,"custom_702"},{"Apartments","Apartments (Entrance)","wallbang_hvh","weapon_wallbang",-393.401,760.794,8.031,1.974,-176.053,"custom_703"},{"Wine Cellar","Middle","wallbang_hvh","weapon_wallbang",-495.972,1515.075,-151.969,2.672,1.954,"custom_704"},{"Wine Cellar","Middle","wallbang_hvh","weapon_wallbang",-344.267,1336.825,-151.969,3.112,-0.789,"custom_705"},{"Dumpster","Middle","wallbang_hvh","weapon_wallbang",168.321,386.375,-151.969,6.948,27.292,"custom_706",["duck"]=true},{"Middle","Middle","wallbang_hvh","weapon_wallbang",-0.022,1142.883,-151.969,0.519,-59.05,"custom_707"},{"Apartments","Middle","wallbang_hvh","weapon_wallbang",-689.827,1504.468,8.031,11.366,-13.968,"custom_708"},{"Middle","Middle","wallbang_hvh","weapon_wallbang",304.023,613.319,-150.277,0.443,120.688,"custom_709"},{"T Spawn","Apartments","wallbang_hvh","weapon_wallbang",-156.952,2420.883,-63.969,-6.902,-106.032,"custom_710",["duck"]=true},{"Long Hall","Long Hall","wallbang_hvh","weapon_wallbang",633.383,1436.761,48.031,24.877,-65.253,"custom_711"},{"Long Hall","Long Hall","wallbang_hvh","weapon_wallbang",625.726,1458.733,48.031,21.938,-65.569,"custom_712"},{"T Spawn","Middle","wallbang_hvh","weapon_wallbang",10.031,2369.904,7.685,6.597,-89.951,"custom_713",["duck"]=true},{"CT Spawn","Left Alley","wallbang_hvh","weapon_wallbang",-689.376,-1300.024,-239.982,-3.042,106.561,"custom_714"},{"Right Alley","Apartment","wallbang_hvh","weapon_wallbang",-189.902,-400.021,-151.969,-9.05,140.894,"custom_715"},{"Middle","Apartments (Hut)","wallbang_hvh","weapon_wallbang",172.438,659.206,-151.186,-5.477,155.405,"custom_716"},{"Tunnel","Side Hall","grenade","weapon_molotov",232.642,158.805,-151.274,-14.341,34.713,"custom_717",["throwType"]="RUN",["landX"]=955.287,["landY"]=184.453,["landZ"]=-149.969},{"Apartment","Apartment","wallbang_hvh","weapon_wallbang",-612.385,174.953,-31.969,-1.581,96.51,"custom_718"}} end
		if map == "de_dust" then locations_data={{"Box","A-Site 1-Way","grenade","weapon_molotov",464.536,852.624,128.031,-12.311,-16.006,"custom_828",["throwType"]="RUN",["runSpeed"]=false,["landX"]=2189.424,["landY"]=414.227,["landZ"]=78.031},{"Box","Box FD 1-way","grenade","weapon_molotov",442.58,870.217,128.031,-16.115,-97.573,"custom_829",["throwType"]="NORMAL",["landX"]=405.08,["landY"]=-29.3,["landZ"]=118.017},{"Tuns","A Site 1-Way","grenade","weapon_molotov",1327.331,1209.618,32.031,-18.216,-45.159,"custom_830",["throwType"]="NORMAL",["landX"]=2165.712,["landY"]=405.484,["landZ"]=78.031},{"Tuns","A Site 1-Way","grenade","weapon_molotov",599.564,870.262,96.063,3.903,-15.079,"custom_831",["throwType"]="RUNJUMP",["runDuration"]=5,["runSpeed"]=false,["landX"]=2140.063,["landY"]=455.263,["landZ"]=76.031},{"Arch","Triple Box 1-Way","grenade","weapon_molotov",-765.96,203.056,32.031,-20.518,-14.992,"custom_832",["throwType"]="NORMAL",["landX"]=-326.587,["landY"]=-1397.392,["landZ"]=7.68},{"Arch Boost","Barrels [sigma]","grenade","weapon_molotov",-437.864,300.18,72.063,2.903,-65.875,"custom_833",["throwType"]="RUNJUMP",["runDuration"]=8,["runSpeed"]=false,["landX"]=324.039,["landY"]=-1291.939,["landZ"]=65.333},{"Boost","Barrels [sigma]","grenade","weapon_molotov",-525.28,500.412,139.062,4.883,-65.447,"custom_834",["throwType"]="RUNJUMP",["runDuration"]=18,["runSpeed"]=false,["landX"]=262.454,["landY"]=-1323.026,["landZ"]=94.547}} end

		for i=1, #locations_data do
			for j=1, #array_to_key do
				if locations_data[i][j] ~= nil then
					locations_data[i][array_to_key[j]] = locations_data[i][j]
					locations_data[i][j] = nil
				end
			end
		end

		if #locations_data > 0 then
			data_all[map] = locations_data

			return locations_data
		end
	end
})

local position_data = setmetatable({}, {
	__index = function(tbl, index)
		tbl[index] = {}
		return tbl[index]
	end
})

local console_names = {
	["CSmokeGrenade"] = "weapon_smokegrenade",
	["CSensorGrenade"] = "weapon_smokegrenade",
	["CFlashbang"] = "weapon_flashbang",
	["CDecoyGrenade"] = "weapon_flashbang",
	["CIncendiaryGrenade"] = "weapon_molotov",
	["CMolotovGrenade"] = "weapon_molotov",
	["CHEGrenade"] = "weapon_hegrenade",
	["CWeaponAWP"] = "weapon_wallbang",
	["CWeaponSCAR20"] = "weapon_wallbang",
	["CWeaponG3SG1"] = "weapon_wallbang",
	["CWeaponSSG08"] = "weapon_wallbang",
	["CDEagle"] = "weapon_wallbang",
	["CAK47"] = "weapon_wallbang_light",
	["CWeaponSG556"] = "weapon_wallbang_light",
	["CWeaponGalilAR"] = "weapon_wallbang_light",
	["CWeaponM4A1"] = "weapon_wallbang_light",
	["CWeaponM4A4"] = "weapon_wallbang_light",
	["CWeaponAug"] = "weapon_wallbang_light",
	["CWeaponFamas"] = "weapon_wallbang_light",
	["CWeaponTec9"] = "weapon_wallbang_light",
	["CKnife"] = "weapon_knife",
}
local movement_buttons_chars = {
	["in_attack"] = "A",
	["in_jump"] = "J",
	["in_duck"] = "D",
	["in_forward"] = "F",
	["in_back"] = "B",
	["in_use"] = "U",
	["in_moveleft"] = "L",
	["in_moveright"] = "R",
	["in_attack2"] = "Z",
	["in_speed"] = "S"
}
local movement_setup_command_values = {"pitch", "yaw", "forwardmove", "sidemove", "in_forward", "in_back", "in_moveleft", "in_moveright", "in_jump", "in_duck", "in_speed", "in_attack", "in_attack2", "in_use"}
local rotation_keys = {
	"in_forward",
	"in_moveright",
	"in_back",
	"in_moveleft"
}
local names_to_type = {
	["Grenade: Smoke"] = "grenade",
	["Grenade: Flashbang"] = "grenade",
	["Grenade: High Explosive"] = "grenade",
	["Grenade: Molotov"] = "grenade",
	["Grenade"] = "grenade",
	["Wallbang"] = "wallbang",
	["HvH: Location"] = "wallbang_hvh",
	["Movement"] = "movement"
}
local types_to_name = {
	["grenade"] = "Grenade",
	["wallbang"] = "Wallbang: Legit",
	["wallbang_hvh"] = "HvH: Location",
	["movement"] = "Movement",
}
local console_names_to_name = {
	["weapon_smokegrenade"] = "Grenade: Smoke",
	["weapon_flashbang"] = "Grenade: Flashbang",
	["weapon_hegrenade"] = "Grenade: High Explosive",
	["weapon_molotov"] = "Grenade: Molotov",
}
local throwtype_description = {
	["RUN"] = "Runthrow",
	["JUMP"] = "Jumpthrow",
	["RUNJUMP"] = "Run + Jumpthrow"
}
local run_direction_yaw = {
	["Forward"] = 0,
	["Back"] = 180,
	["Left"] = 90,
	["Right"] = -90,
}
local map_aliases = {
	["workshop/141243798/aim_ag_texture2"] = "aim_ag_texture2",
	["workshop/1855851320/de_cache_new"] = "de_cache",
	["workshop/1193879022/de_dust"] = "de_dust"
}
local map_patterns = {
	["_scrimmagemap$"] = ""
}
local get_clipboard_text, set_clipboard_text

do
	if pcall(client.create_interface) then
		local ffi = require "ffi"
		local function vmt_entry(instance, index, type)
			return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
		end
		local function vmt_bind(module, interface, index, typestring)
			local instance = client.create_interface(module, interface) or error("invalid interface")
			local fnptr = vmt_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
			return function(...)
				return fnptr(instance, ...)
			end
		end

		local native_GetClipboardTextCount = vmt_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
		local native_SetClipboardText = vmt_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
		local native_GetClipboardText = vmt_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")

		function get_clipboard_text()
			local size = native_GetClipboardTextCount()
			if size > 0 then
				local char = ffi.new("char[?]", size)
				local bytesize = size * ffi.sizeof("char[?]", size)
		    native_GetClipboardText(0, char, bytesize)
		    return ffi.string(char, size-1)
			end
		end

		function set_clipboard_text(text)
			native_SetClipboardText(text, text:len())
		end
	end
end

local on_saving_enabled_changed
local function on_enabled_changed()
	reload_data = "on_enabled_changed"
	local enabled = ui_get(enabled_reference)
	ui_set_visible(types_reference, enabled)
	ui_set_visible(color_reference, enabled)
	ui_set_visible(ignore_visibility_reference, enabled)
	ui_set_visible(saving_enabled_reference, enabled)
	ui_set_visible(aimbot_reference, enabled)
	if not enabled and ui_get(saving_enabled_reference) then
		ui_set(saving_enabled_reference, false)
		if on_saving_enabled_changed ~= nil then
			on_saving_enabled_changed()
		end
	end
end
ui_set_callback(enabled_reference, on_enabled_changed)
ui_set_callback(types_reference, on_enabled_changed)
on_enabled_changed()

local function get_mapname()
	local mapname = globals_mapname()
	if mapname == nil then
		return
	end

	if map_aliases[mapname] ~= nil then
		mapname = map_aliases[mapname]
	end

	if data_all ~= nil and data_all[mapname] == nil then
		for pattern, replacement in pairs(map_patterns) do
			local mapname_temp = mapname:gsub(pattern, replacement)
			if data_all[mapname_temp] ~= nil then
				mapname = mapname_temp
				break
			end
		end
	end

	return mapname
end

local function get_callout_name(name_raw)
	return (name_raw .. " "):gsub("%u[%l ]", function(c) return " " .. c end):sub(2, -2):gsub("of ", " of "):gsub("  ", " ")
end

local movement_saving_hotkey_prev, movement_play_location, movement_play_prev, movement_play_index, movement_play_frame_progress
local local_locations_copy, saving_location, editing_location, grenade_thrown_at, grenade_entindex = {}

local function on_saving_teleport()
	if saving_location ~= nil then
		client_exec("setpos_exact ", saving_location.x, " ", saving_location.y, " ", saving_location.z, "; setang ", saving_location.pitch, " ", saving_location.yaw, " 0; noclip off")
	end
end
local saving_teleport_reference = ui.new_button("LUA", "B", "  Teleport to location  ", on_saving_teleport)
local saving_teleport_hotkey_reference = ui.new_hotkey("LUA", "B", "Teleport to current location hotkey", true)

local function saving_serialize(location, use_ordered_table)
	if location ~= nil then
		local props_saved = {"map", "from", "to", "type", "weapon", "tickrate", "x", "y", "z", "pitch", "yaw", "throwType", "throwStrength", "viewAnglesDistanceMax", "runDuration", "runYaw", "runSpeed", "duck", "flyDuration", "landX", "landY", "landZ", "data"}
		local location_serialized = use_ordered_table and ordered_table({}) or {}

		for i=1, #props_saved do
			if location[props_saved[i]] ~= nil then
				location_serialized[props_saved[i]] = location[props_saved[i]]
			end
		end
		if location_serialized.tickrate == "" then
			location_serialized.tickrate = nil
		end
		if not location_serialized.duck then
			location_serialized.duck = nil
		end
		if location_serialized.throwStrength == 1 then
			location_serialized.throwStrength = nil
		end
		if location_serialized.viewAnglesDistanceMax == 0.22 then
			location_serialized.viewAnglesDistanceMax = nil
		end
		if location_serialized.runDuration == 20 then
			location_serialized.runDuration = nil
		end
		if location_serialized.runYaw == 0 then
			location_serialized.runYaw = nil
		end
		if location_serialized.runSpeed == false then
			location_serialized.runYaw = nil
		end

		return location_serialized
	end
end

local function saving_load(location)
	if location ~= nil then
		ui_set(saving_from_reference, location.from)
		ui_set(saving_to_reference, location.to)
		ui_set(saving_run_duration_reference, location.runDuration or 20)

		if location.runYaw ~= nil then
			for key, value in pairs(run_direction_yaw) do
				if value == location.runYaw then
					ui_set(saving_run_direction_reference, key)
				end
			end
		else
			ui_set(saving_run_direction_reference, "Forward")
		end

		if location.type ~= nil and types_to_name[location.type] ~= nil then
			ui_set(saving_type_reference, types_to_name[location.type])
		else
			ui_set(saving_type_reference, "Grenade")
		end

		local properties = {}
		if location.throwType == "RUN" or location.throwType == "RUNJUMP" then
			table_insert(properties, "Run")

			if location.runSpeed then
				table_insert(properties, "Walk")
			end
		end
		if location.throwType == "JUMP" or location.throwType == "RUNJUMP" then
			table_insert(properties, "Jump")
		end
		if location.tickrate ~= nil then
			table_insert(properties, "Tickrate")
		end
		ui_set(saving_properties_reference, properties)
	else
		ui_set(saving_from_reference, "")
		ui_set(saving_to_reference, "")
		ui_set(saving_run_duration_reference, 20)
		ui_set(saving_run_direction_reference, "Forward")
		ui_set(saving_type_reference, "Grenade")
		ui_set(saving_properties_reference, {})
	end
end

local saving_list_label_reference = ui.new_label("LUA", "A", "All locations on")
local saving_list_reference = ui.new_listbox("LUA", "A", "Local locations", {})
local saving_create_reference, create_items, saving_export_reference, saving_import_reference

ui.set_visible(saving_list_reference, false)
ui.set_visible(saving_list_label_reference, false)

local function multicolor_log(...)
	local args = {...}
	local len = #args
	for i=1, len do
		local arg = args[i]
		local r, g, b = unpack(arg)

		local msg = {}

		if #arg == 3 then
			table_insert(msg, " ")
		else
			for i=4, #arg do
				table_insert(msg, arg[i])
			end
		end
		msg = table_concat(msg)

		if len > i then
			msg = msg .. "\0"
		end

		client_color_log(r, g, b, msg)
	end
end

local function get_export_text()
	local mapname = get_mapname()
	if mapname == nil then
		client.error_log("Mapname not found")
	else
		if db["local_locations"][mapname] == nil or #db["local_locations"][mapname] == 0 then
			client.error_log("No locations stored for ", mapname)
		else
			local fancy = false
			local indent = "  "

			local text = "[" .. (fancy and "\n" or "")
			for i=1, #db["local_locations"][mapname] do
				local location = saving_serialize(db["local_locations"][mapname][i], true)
				local data_prev = location.data
				if data_prev ~= nil then
					location.data = json_encode_pretty(location.data, "", "", "")
				end
				local json_str = json_encode_pretty(location, fancy and "\n" or "", fancy and indent or "", fancy and " " or "")
				if location.data ~= nil then
					local data_escaped = json_encode_pretty({location.data}, "", "", ""):sub(2, -2)
					local quotepattern = '(['..("%^$().[]*+-?"):gsub("(.)", "%%%1")..'])'

					json_str = json_str:gsub((data_escaped:gsub(quotepattern, "%%%1")), location.data)
				end

				location.data = data_prev

				text = text .. (fancy and indent or "") .. json_str:gsub("\n", "\n" .. indent)
				text = text .. (i == #db["local_locations"][mapname] and "" or ",") .. (fancy and "\n" or "")
			end
			text = text .. "]\n"

			return text
		end
	end
end

local function import_from_text(text)
	local success, data = pcall(json.parse, text)

	if success and type(data) == "table" and #data > 0 then
		local imported = 0
		for i=1, #data do
			local location = data[i]

			if
				type(location) == "table" and
				#location == 0 and
				type(location["map"]) == "string" and
				type(location["from"]) == "string" and
				type(location["to"]) == "string" and
				type(location["type"]) == "string" and
				(location["weapon"] == nil or type(location["weapon"]) == "string") and
				(location["tickrate"] == nil or type(location["tickrate"]) == "number") and
				type(location["x"]) == "number" and
				type(location["y"]) == "number" and
				type(location["z"]) == "number" and
				type(location["pitch"]) == "number" and
				type(location["yaw"]) == "number" and
				(location["throwType"] == nil or type(location["throwType"]) == "string") and
				(location["throwStrength"] == nil or type(location["throwStrength"]) == "number") and
				(location["viewAnglesDistanceMax"] == nil or type(location["viewAnglesDistanceMax"]) == "number") and
				(location["runDuration"] == nil or (type(location["runDuration"]) == "number" and location["runDuration"] % 1 == 0)) and
				(location["runYaw"] == nil or type(location["runYaw"]) == "number") and
				(location["runSpeed"] == nil or type(location["runSpeed"]) == "boolean") and
				(location["duck"] == nil or type(location["duck"]) == "boolean") and
				(location["flyDuration"] == nil or type(location["flyDuration"]) == "number") and
				(location["landX"] == nil or type(location["landX"]) == "number") and
				(location["landY"] == nil or type(location["landY"]) == "number") and
				(location["landZ"] == nil or type(location["landZ"]) == "number") and
				(location["data"] == nil or (type(location["data"]) == "table" and true))
			then
				local location_save = saving_serialize(location)
				if location_save ~= nil then
					if db["local_locations"][location_save.map] == nil then
						db["local_locations"][location_save.map] = {}
					end
					local map_locations = db["local_locations"][location_save.map]

					map_locations[#map_locations+1] = location_save
					imported = imported + 1
				end
			else
				multicolor_log(console_prefix, {217, 32, 32, "Location #", i, " is invalid!"})
			end
		end

		if imported > 0 then
			multicolor_log(console_prefix, {183, 232, 16, "Successfully imported ", imported, " locations."})
			create_items(true)
			reload_data = "on_saving_save"
		end
	else
		local err = success and "Unknown error" or data:match("%.\\.+%..+:.+: (.+)")
		multicolor_log(console_prefix, {217, 32, 32, "Invalid input: "}, {217, 32, 32, err or data})
	end
end

local function on_saving_save()
	if saving_location ~= nil then
		local location_save = saving_serialize(saving_location)
		if db["local_locations"][location_save.map] == nil then
			db["local_locations"][location_save.map] = {}
		end
		local map_locations = db["local_locations"][location_save.map]

		map_locations[math_min(ui_get(saving_list_reference)+1, #map_locations+1)] = location_save
		create_items()
		database.write("helper", db)
		reload_data = "on_saving_save"
	end
end

local function on_saving_list_changed()
	local mapname = get_mapname()
	if mapname == nil then
		return
	end

	if db["local_locations"] ~= nil and db["local_locations"][mapname] ~= nil and db["local_locations"][mapname][ui_get(saving_list_reference)+1] ~= nil then
		local location = db["local_locations"][mapname][ui_get(saving_list_reference)+1]
		saving_location = saving_serialize(location)
		saving_location.temporary = true
		editing_location = location
	else
		saving_location = nil
		editing_location = nil
	end
	saving_load(saving_location)
	reload_data = "on_saving_list_changed"
end

local function on_saving_export()
	if set_clipboard_text == nil then
		return
	end

	local text = get_export_text()
	set_clipboard_text(text)
end

local function on_saving_import()
	if get_clipboard_text == nil then
		return
	end

	local text = get_clipboard_text():gsub("\n$", ""):gsub("\n$", "")

	import_from_text(text)
end

local function on_saving_delete()
	local mapname = get_mapname()
	if mapname == nil then
		return
	end

	if db["local_locations"] ~= nil and db["local_locations"][mapname] ~= nil then
		local i = ui_get(saving_list_reference)+1
		if db["local_locations"][mapname][i] ~= nil then
			table.remove(db["local_locations"][mapname], i)
			create_items()
			on_saving_list_changed()
		end
	end
end

local saving_save_reference = ui.new_button("LUA", "B", "Save", on_saving_save)
local saving_delete_reference = ui_new_button("LUA", "A", "Delete", on_saving_delete)

if set_clipboard_text ~= nil then
	saving_export_reference = ui_new_button("LUA", "A", "Export to clipboard", on_saving_export)
end
if get_clipboard_text ~= nil then
	saving_import_reference = ui_new_button("LUA", "A", "Import from clipboard", on_saving_import)
end

function create_items(select_new)
	local mapname = get_mapname()
	if mapname == nil then
		ui_set_visible(saving_list_label_reference, false)
		return
	end

	local saving_enabled = ui_get(saving_enabled_reference)

	ui_set_visible(saving_list_label_reference, saving_enabled)
	ui_set(saving_list_label_reference, "Locally stored locations for " .. mapname .. ":")
	local list_i

	if not select_new then
		list_i = ui_get(saving_list_reference)
	end

	local list_items = {}

	if db["local_locations"] ~= nil and db["local_locations"][mapname] ~= nil then
		local local_locations = db["local_locations"][mapname]

		local i = 1
		while #local_locations >= i do
			local location = local_locations[i]
			if location.type == "grenade" and console_names_to_name[location.weapon] == nil then
				-- invalid grenade weapon
				table_remove(local_locations, i)
				client_error_log("deleted invalid location ", location.from, " to ", location.to)
			else
				table_insert(list_items, (location.type == "grenade" and console_names_to_name[location.weapon]:gsub("Grenade: ", "") or types_to_name[location.type]) .. ": " .. location.from .. " to " .. location.to)
				i = i + 1
			end
		end
	end

	table_insert(list_items, "» Create new location")
	ui.update(saving_list_reference, list_items)

	ui_set(saving_list_reference, math_min((list_i or #list_items-1), #list_items-1))
	ui_set_callback(saving_list_reference, on_saving_list_changed)
	on_saving_list_changed()

	if not saving_enabled then
		if saving_list_reference ~= nil then
			ui_set_visible(saving_list_reference, false)
		end
		if saving_delete_reference ~= nil then
			ui_set_visible(saving_delete_reference, false)
		end
		if saving_export_reference ~= nil then
			ui_set_visible(saving_export_reference, false)
		end
		if saving_import_reference ~= nil then
			ui_set_visible(saving_import_reference, false)
		end
	end
end
client_delay_call(0, create_items)

local function on_saving_properties_changed(reference)
	local saving_properties = ui_get(saving_properties_reference)
	if reference ~= nil then
		local saving_enabled = ui_get(saving_enabled_reference)
		ui_set_visible(saving_run_duration_reference, saving_enabled and table_contains(saving_properties, "Run"))
		ui_set_visible(saving_run_direction_reference, saving_enabled and table_contains(saving_properties, "Run"))
	end
end
ui.set_callback(saving_properties_reference, on_saving_properties_changed)
ui.set_callback(saving_run_duration_reference, on_saving_properties_changed)

-- restore after reload
-- if type(saving_location) == "table" and saving_location.map ~= nil then
-- 	saving_location.temporary = true

-- 	if data_all[saving_location.map] == nil then
-- 		data_all[saving_location.map] = {}
-- 	end

-- 	saving_load(saving_location)
-- 	reload_data = true
-- end

local console_input_registered = false
local function on_saving_console_input(text)
	if not ui_get(saving_enabled_reference) then
		return
	end

	if text == "helper" or text:sub(1, 7) == "helper " then
		local words = {}
		for w in text:gmatch("%S+") do
			table.insert(words, w)
		end

		local print_help = false
		if words[2] == "debug" then
			if not helper_debug then
				multicolor_log(console_prefix, {183, 232, 16, "Debug mode enabled!"})
				helper_debug = true
			else
				multicolor_log(console_prefix, {217, 32, 32, "Debug mode disabled!"})
				helper_debug = false
			end

		elseif words[2] == "statistics" and helper_debug then
			local table_gen = require "lib/table_gen"
			local maps = {}
			for map, map_spots in pairs(data_all) do
				table_insert(maps, map)
			end
			table_sort(maps)
			local rows = {}
			local headings = {"MAP", "Smokes", "Flashes", "Molotovs", "Grenades", "Wallbangs", "One-ways", "Movement", "Other"}
			local total_row = {"TOTAL", 0, 0, 0, 0, 0, 0, 0, 0}

			for i=1, #maps do
				local row = {maps[i], 0, 0, 0, 0, 0, 0, 0, 0}
				local map_locations = data_all[maps[i]]
				for i=1, #map_locations do
					local index = 9
					if map_locations[i].type == "grenade" then
						if map_locations[i].weapon == "weapon_smokegrenade" then
							index = 2
						elseif map_locations[i].weapon == "weapon_flashbang" then
							index = 3
						elseif map_locations[i].weapon == "weapon_molotov" then
							index = 4
						elseif map_locations[i].weapon == "weapon_hegrenade" then
							index = 5
						end
					elseif map_locations[i].type == "wallbang" then
						index = 6
					elseif map_locations[i].type == "wallbang_hvh" then
						index = 7
					elseif map_locations[i].type == "movement" then
						index = 8
					end

					if not map_locations[i].temporary then
						row[index] = row[index] + 1
						total_row[index] = total_row[index] + 1
					end
				end

				table_insert(rows, row)
			end

			table_insert(rows, {"", "", "", "", "", "", "", ""})
			table_insert(rows, total_row)

			local tbl_result = table_gen(rows, headings, {style="Unicode (Single Line)"})
			client_log("Locations loaded:")
			for s in tbl_result:gmatch("[^\r\n]+") do
				client_color_log(210, 210, 210, s)
			end

		elseif words[2] == "clear_dynamic" and helper_debug then
			if data_map ~= nil then
				for i=1, #data_map do
					data_map[i].landX = nil
					data_map[i].landY = nil
					data_map[i].landZ = nil
					data_map[i].flyDuration = nil
				end
			end

		elseif words[2] == "create_dynamic" and helper_debug then

		elseif words[2] == "search" then
			local search_str = text:sub(15, -1):lower()
			local eyepos = vector3(client.eye_position())
			eyepos.z = eyepos.z-64

			local matching, distance = {}, {}
			for i=1, #data_weapon do
				local location = data_weapon[i]
				if location.name:lower():match(search_str) or location.from:lower():match(search_str) or location.to:lower():match(search_str) then
					table_insert(matching, location)
					distance[location] = location.pos:dist_to(eyepos)
				end
			end

			table.sort(matching, function(a, b) return distance[a] < distance[b] end)

			if #matching > 0 then
				multicolor_log(console_prefix, {183, 232, 16, "Locations matching \"", search_str, "\":"})
				for i=1, #matching do
					local location = matching[i]
					multicolor_log({210, 210, 210, "- ", location.from, " to ", location.to, " (id: ", location.id, ", ", string_format("dist: %.1du", distance[location]), ")"})
				end
			else
				multicolor_log(console_prefix, {217, 32, 32, #data_weapon == 0 and "No locations stored for current weapon." or "No locations matched \" .. search_str .. \"."})
			end

		elseif words[2] == "teleport" then
			local id_str = text:sub(17, -1):lower():gsub(" ", "")

			local found = false
			for i=1, #data_map do
				local location = data_map[i]
				if location.id:lower() == id_str then
					found = true
					client_log("Teleported to ", location.name, " (", location.id, ")")
					client_exec("setpos ", location.x, " ", location.y, " ", location.z, "; setang ", location.pitch, " ", location.yaw)
					break
				end
			end

			if not found then
				multicolor_log(console_prefix, {217, 32, 32, "Location \"", id_str, "\" not found."})
			end

		elseif words[2] == "export" then
			local text = get_export_text()
			multicolor_log(console_prefix, {210, 210, 210, "Copy the text below to your clipboard:"})
			local json_str_chunks = chunk_string(text, 1000)

			for i=1, #json_str_chunks do
				if i < #json_str_chunks then
					client_color_log(190, 190, 190, json_str_chunks[i] .. "\0")
				else
					client_color_log(190, 190, 190, json_str_chunks[i])
				end
			end

		elseif words[2] == "import" then
			import_from_text(text:sub(14, -1))
		else
			if words[2] ~= nil and words[2] ~= "help" then
				multicolor_log(console_prefix, {217, 32, 32, "Unknown helper command '", text, "'. "}, {210, 210, 210, "List of commands:"})
			else
				multicolor_log(console_prefix, {210, 210, 210, "List of helper commands:"})
			end
			print_help = true
		end

		if print_help then
			local commands = {
				{"help", "Print this help"},
				{"search [text]", "Searches for a location (for the currently held weapon and on the current map)"},
				{"teleport [id]", "Teleports you to a location"},
				{"export", "Export the locally saved locations for the current map to console"},
				{"import [data]", "Import locations"}
			}

			for i=1, #commands do
				multicolor_log({180, 180, 180, "> "}, {183, 232, 16, commands[i][1]}, {210, 210, 210, ": ", commands[i][2]})
			end
		end

		return true
	end
end

function on_saving_enabled_changed()
	reload_data = "on_saving_enabled_changed"
	local saving_enabled = ui_get(enabled_reference) and ui_get(saving_enabled_reference)
	ui_set_visible(saving_hotkey_reference, saving_enabled)
	ui_set_visible(saving_from_reference, saving_enabled)
	ui_set_visible(saving_to_reference, saving_enabled)
	ui_set_visible(saving_type_reference, saving_enabled)
	ui_set_visible(saving_properties_reference, saving_enabled)
	ui_set_visible(saving_teleport_reference, saving_enabled)
	ui_set_visible(saving_teleport_hotkey_reference, saving_enabled)
	ui_set_visible(saving_save_reference, saving_enabled)
	on_saving_properties_changed(saving_properties_reference)

	if saving_list_reference and saving_list_label_reference and saving_delete_reference then
		ui_set_visible(saving_list_reference, saving_enabled)
		ui_set_visible(saving_list_label_reference, saving_enabled)
		ui_set_visible(saving_delete_reference, saving_enabled)
		if saving_export_reference then
			ui_set_visible(saving_export_reference, saving_enabled)
		end
		if saving_import_reference then
			ui_set_visible(saving_import_reference, saving_enabled)
		end
	end

	if not saving_enabled and saving_list_reference ~= nil then
		local mapname = get_mapname()
		if db["local_locations"] ~= nil and db["local_locations"][mapname] ~= nil then
			ui.set(saving_list_reference, #db["local_locations"][mapname])
		end
	end
	ui_set(saving_properties_reference, {})
	ui_set(saving_run_duration_reference, 20)
	ui_set(saving_run_direction_reference, "Forward")

	if saving_enabled and not console_input_registered then
		client_set_event_callback("console_input", on_saving_console_input)
		console_input_registered = true
	elseif not saving_enabled and console_input_registered then
		client_unset_event_callback("console_input", on_saving_console_input)
		console_input_registered = false
	end
end
ui_set_callback(saving_enabled_reference, on_saving_enabled_changed)
on_saving_enabled_changed()

local water_level_prev
local function on_run_command(e)
	local local_player = entity_get_local_player()
	local weapon = console_names[entity_get_classname(entity_get_player_weapon(local_player))]

	-- if water_level_prev ~= nil then
	-- 	entity_set_prop(local_player, "m_nWaterLevel", water_level_prev)
	-- 	water_level_prev = nil
	-- end

	-- if ui_get(saving_enabled_reference) then
	-- 	if e.command_number % 32 == 0 then
	-- 		package_loaded["helper_data"] = nil
	-- 		local new_data_all, new_data_loaded_at = get((require("helper_data")))
	-- 		if new_data_loaded_at ~= data_loaded_at then
	-- 			data_all, data_loaded_at = new_data_all, new_data_loaded_at
	-- 			reload_data = "helper_spots_reloaded"
	-- 			client_log("Helper spots were reloaded")
	-- 		end
	-- 		package_loaded["helper_data"] = nil
	-- 	end
	-- end

	if weapon ~= weapon_prev or reload_data ~= nil then
		if weapon ~= weapon_prev then
			last_weapon_switch = globals_realtime()
		end
		-- print("reloading data! " .. tostring(reload_data))

		if reload_data ~= nil and reload_data ~= "pos_inaccurate" then
			local_locations_copy = {}
		end

		weapon_prev = weapon
		reload_data = nil
		data_weapon = {}

		local offset_z = 20
		local player_radius = 16
		local accurate_move_offset_table_start = {
			vector3(player_radius*0.7, 0, offset_z),
			vector3(-player_radius*0.7, 0, offset_z),
			vector3(0, player_radius*0.7, offset_z),
			vector3(0, -player_radius*0.7, offset_z),
		}
		local accurate_move_offset_table_end = {
			vector3(player_radius*2, 0, 0),
			vector3(0, player_radius*2, 0),
			vector3(-player_radius*2, 0, 0),
			vector3(0, -player_radius*2, 0),
		}
		local inaccurate_check_offset_table = {
			vector3(0, 0, 0),
			vector3(8, 0, 0),
			vector3(-8, 0, 0),
			vector3(0, 8, 0),
			vector3(0, -8, 0),
		}
		local inaccurate_check_top, inaccurate_check_bottom = vector3(0, 0, 6), -vector3(0, 0, 6)

		if weapon ~= nil and ui_get(enabled_reference) then
			local types = ui_get(types_reference)

			if #types > 0 then
				local mapname = get_mapname()
				data_map = {unpack(data_all[mapname] or {})}

				local data_map_local = db["local_locations"][mapname]
				if data_map_local ~= nil then
					for i=1, #data_map_local do
						if data_map_local[i] ~= saving_location and data_map_local[i] ~= editing_location then
							if local_locations_copy[data_map_local[i]] == nil then
								local_locations_copy[data_map_local[i]] = saving_serialize(data_map_local[i])
							end
							table_insert(data_map, local_locations_copy[data_map_local[i]])
						end
					end
				end

				if saving_location ~= nil then
					table_insert(data_map, saving_location)
				end

				if data_map ~= nil then
					local saving_enabled = ui_get(saving_enabled_reference)
					local types_enabled = {}
					local position_cache = {}
					for i=1, #types do
						local type_enabled = names_to_type[types[i]]
						if type_enabled ~= "grenade" or table_contains(types, console_names_to_name[weapon]) then
							table_insert(types_enabled, type_enabled)
						end
					end

					local tickrate = 1/globals_tickinterval()
					for i=1, #data_map do
						local location = data_map[i]
						if (weapon == location.weapon or (weapon == "weapon_wallbang" and location.weapon == "weapon_wallbang_light")) and table_contains(types_enabled, location.type) and (location.tickrate == nil or location.tickrate == tickrate or true) and (not location.temporary or saving_enabled) then
							if location.name == nil then
								local shorten_name, show_source = true, false
								location.name = shorten_name and location.to or (location.from .. " to " .. location.to)
							end

							if location.runDuration == nil then
								location.runDuration = 20
							end
							if location.duck == nil then
								location.duck = false
							end
							if location.throwStrength == nil then
								location.throwStrength = 1
							end
							if location.viewAnglesDistanceMax == nil then
								location.viewAnglesDistanceMax = 0.22
							end
							if location.runYaw == nil then
								location.runYaw = 0
							end
							if location.flyDuration ~= nil and location.runDuration ~= nil and (location.type == "RUN" or location.type == "RUNJUMP") then
								-- location.flyDuration = location.flyDuration + location.runDuration
							end

							if location.pos_inaccurate == 1 then
								location.pos = nil
							end

							if location.pos == nil then
								local id = table_concat({round(location.x, 6), round(location.y, 6), round(location.z, 6)}, " ")
								location.pos_id = id
								if position_cache[id] == nil then
									local pos = vector3(location.x, location.y, location.z)
									for id2, pos2 in pairs(position_cache) do
										if pos2:dist_to(pos) < 1 then
											id = id2
										end
									end

									if position_cache[id] == nil then
										-- bad position
										if location.pos_inaccurate == nil then
											local min = 1
											for i=1, #inaccurate_check_offset_table do
												local frac = (pos+inaccurate_check_offset_table[i]+inaccurate_check_top):trace_line(pos+inaccurate_check_offset_table[i]+inaccurate_check_bottom, local_player)
												min = math_min(min, frac)
											end

											if min == 1 then
												-- client.log("position of ", location.id, " inaccurate, waiting for pos with same x y")

												-- pos:draw_debug_text(0, 25, 255, 255, 255, 255, min)
												location.pos_inaccurate = 1
												local pos_new = pos - vector3(0, 0, 16)
												local frac = (pos_new-vector3(0, 0, -1)):trace_line(pos_new+vector3(0, 0, -1), local_player)
												if frac > 0.4 and frac < 0.6 then
													pos = pos_new
												end
												location.pos = pos
												reload_data = "pos_inaccurate"
											else
												-- good position, cache it
												position_cache[id] = pos
											end
										elseif location.pos_inaccurate == 1 then
											-- client.log("checking for accurate position of ", location.id)
											location.pos = vector3(location.x, location.y, location.z)
											location.pos_inaccurate = 2

											for i=1, #data_weapon do
												local pos2 = data_weapon[i].pos
												if pos2 ~= location.pos and pos2:dist_to_2d(location.pos) < 1 and pos2:dist_to(location.pos) < 50 then
													-- client.log(pos2:dist_to(location.pos))
													location.pos = pos2
													location.pos_inaccurate = nil
													-- client.log("found accurate position for", location.id, ".")
													break
												end
											end

											if location.pos_inaccurate == 2 then
												local frac, entindex_hit, pos_hit = (pos+vector3(0, 0, 32)):trace_line(pos-vector3(0, 0, 32), local_player)
												if frac ~= 1 then
													-- client.log("found no accurate position for ", location.id, ", guessing")
													location.pos = pos_hit
													position_data[location.pos].inaccurate = true
													position_data[location.pos].accurate_move = false

												end
												location.pos_inaccurate = nil
											end
										end
									end
								end
								location.pos = position_cache[id] or location.pos
							end
							if location.fwd == nil or location.target == nil then
								if location.pitch == nil or location.yaw == nil and helper_debug then
									client.error_log("Invalid location, pitch or yaw missing: ", location.id)
								end
								location.fwd = vector3.angle_forward(vector3(location.pitch or 0, location.yaw or 0, 0))
								location.view_offset = location.duck and 46 or 64

								-- determine target in world
								local eye_pos = location.pos + vector3(0, 0, location.view_offset)
								location.eye_pos = eye_pos
								local target = eye_pos+(location.fwd*2048)
								local fraction, entindex_hit, target_hit = eye_pos:trace_line(target, local_player)
								location.target = target_hit
							end
							if location.viewangles == nil then
								location.viewangles = vector2(location.pitch, location.yaw)
							end
							if location.data_parsed == nil and location.data ~= nil then
								local recording_compressed = location.data
								local frames = {}

								-- set up stuff
								local real = {
									pitch = location.pitch,
									yaw = location.yaw
								}
								for key, char in pairs(movement_buttons_chars) do
									real[key] = 0
								end

								local recording_compressed_new = {}
								for i=1, #recording_compressed do
									if type(recording_compressed[i]) == "number" then
										for i=1, recording_compressed[i] do
											table.insert(recording_compressed_new, {})
										end
									else
										table.insert(recording_compressed_new, recording_compressed[i])
									end
								end

								for i=1, #recording_compressed_new do
									local frame_compressed = recording_compressed_new[i]
									real.pitch = real.pitch + (frame_compressed[1] or 0)
									real.yaw = real.yaw + (frame_compressed[2] or 0)

									if frame_compressed[3] ~= nil then
										local keys_down = {}
										for char in frame_compressed[3]:gmatch(".") do
											keys_down[char] = true
										end

										for key, char in pairs(movement_buttons_chars) do
											if keys_down[char] then
												real[key] = 1
											end
										end

										if frame_compressed[4] ~= nil then
											local keys_up = {}
											for char in frame_compressed[4]:gmatch(".") do
												keys_up[char] = true
											end

											for key, char in pairs(movement_buttons_chars) do
												if keys_up[char] then
													real[key] = 0
												end
											end
										end
									end

									real.forwardmove = real["in_forward"] == 1 and 450 or (real["in_back"] == 1 and -450 or 0)
									if frame_compressed[5] ~= nil then
										real.forwardmove = frame_compressed[5]
									end

									real.sidemove = real["in_moveright"] == 1 and 450 or (real["in_moveleft"] == 1 and -450 or 0)
									if frame_compressed[6] ~= nil then
										real.sidemove = frame_compressed[6]
									end

									local frame = {}
									for key, value in pairs(real) do
										frame[key] = value
									end

									table.insert(frames, frame)
								end
								-- client.log("parsed data")
								location.data_parsed = frames
							end

							if location.destroyX ~= nil and location.destroyY ~= nil and location.destroyZ ~= nil then
								if location.destroyText == nil then
									location.destroyText = "Break the Glass"
								end
								local destroy = vector3(location.destroyX, location.destroyY, location.destroyZ)

								if location.destroyStartX ~= nil and location.destroyStartY ~= nil and location.destroyStartZ ~= nil then
									location.destroy_start = vector3(location.destroyStartX, location.destroyStartY, location.destroyStartZ)
								else
									location.destroy_start = location.eye_pos
								end

								local delta = destroy - location.destroy_start
								local destroy_new = location.destroy_start + delta*1.2

								location.destroy = destroy_new
							end
							if location.land == nil and location.landX ~= nil then
								location.land = vector3(location.landX, location.landY, location.landZ)
							end

							if position_data[location.pos].accurate_move == nil and location.accurateMove ~= nil then
								position_data[location.pos].accurate_move = location.accurateMove
							end
							if position_data[location.pos].visibility_location == nil then
								position_data[location.pos].visibility_location = location.pos+vector3(location.visX or 0, location.visY or 0, location.visZ or 40)
								-- position_data[location.pos].visibility_location:draw_debug_text(0, 5, 255, 255, 255, 100, "HI")
							end
							if position_data[location.pos].accurate_move == nil then
								local count_accurate_move = 0

								-- go through all directions
								for i=1, #accurate_move_offset_table_end do
									if count_accurate_move > 1 then
										break
									end

									-- set offset added to start for this direction
									local end_offset = accurate_move_offset_table_end[i]

									-- loop through all start points
									for i=1, #accurate_move_offset_table_start do
										local start = location.pos + accurate_move_offset_table_start[i]
										-- client.draw_debug_text(start.x, start.y, start.z, 0, 5, 255, 255, 255, 255, "S", i)

										local fraction, entindex_hit = start:trace_line(start + end_offset, entity_get_local_player())
										local end_pos = start + end_offset
										-- client.draw_debug_text(end_pos.x, end_pos.y, end_pos.z, 0, 5, 255, 255, 255, 255, "E", i)

										if entindex_hit == 0 and fraction > 0.45 and fraction < 0.6 then
											count_accurate_move = count_accurate_move + 1
											-- client.draw_debug_text(end_pos.x, end_pos.y, end_pos.z, 1, 5, 0, 255, 0, 100, "HIT ", fraction)
											break
										end
									end
								end

								-- client.draw_debug_text(location.pos.x, location.pos.y, location.pos.z, 0, 5, 255, 255, 255, 255, "hit ", count_accurate_move, " times")
								position_data[location.pos].accurate_move = count_accurate_move > 1
							end
							table_insert(data_weapon, location)
						end
					end
				end
			end
		end
	end

	if not e.from_paint and movement_saving_hotkey_prev and saving_location ~= nil and saving_location.data_parsed ~= nil then
		local buttons_indices = {
			["in_attack"] = 1,
			["in_jump"] = 2,
			["in_duck"] = 4,
			["in_forward"] = 8,
			["in_back"] = 16,
			["in_use"] = 32,
			["in_moveleft"] = 512,
			["in_moveright"] = 1024,
			["in_attack2"] = 2048,
			["in_speed"] = 131072
		}

		for i=1, #saving_location.data_parsed-1 do
			local frame = saving_location.data_parsed[i]
			if not frame.did_run then
				frame.did_run = true

				local local_player = entity.get_local_player()
				local buttons = entity.get_prop(local_player, "m_nButtons")

				for key, value in pairs(frame) do
					if buttons_indices[key] ~= nil then
						local value_btns = bit.band(buttons, buttons_indices[key]) == buttons_indices[key]
						local value_sc = value ~= 0
						if value_btns ~= value_sc then
							-- client.log(key, " differs: ", value_sc, " -> ", value_btns)
							frame[key] = value_btns and 1 or 0
						end
					end
				end

				break
			end
		end
	end
end
client.set_event_callback("run_command", on_run_command)

local function is_grenade_being_thrown(weapon, cmd)
	local pin_pulled = entity_get_prop(weapon, "m_bPinPulled")
	if pin_pulled ~= nil then
		if pin_pulled == 0 or cmd.in_attack == 1 or cmd.in_attack2 == 1 then
			local throw_time = entity_get_prop(weapon, "m_fThrowTime")
			if throw_time ~= nil and throw_time > 0 and throw_time < globals_curtime() then
				return true
			end
		end
	end
	return false
end

local function grenade_apply_movement(cmd, active_move_location)
	if active_move_location.type == "grenade" then
		cmd["in_forward"] = 0
		cmd["in_back"] = 0
		cmd["in_moveleft"] = 0
		cmd["in_moveright"] = 0

		cmd["forwardmove"] = 0
		cmd["sidemove"] = 0

		cmd["in_jump"] = 0
		cmd["in_speed"] = active_move_location.runSpeed and 1 or 0

		if (active_move_location.throwType == "RUN" or active_move_location.throwType == "RUNJUMP") then
			cmd["in_forward"] = 1
			cmd["forwardmove"] = 450
		end

		cmd["move_yaw"] = active_move_location.yaw + (active_move_location.runYaw or 0)
	end
	cmd.in_duck = active_move_location.duck and 1 or 0
end

local locations_on, location_targeted, position_closest
local active_move, active_move_start, active_move_location, airstrafe_disabled, quick_peek_assist_disabled, infinite_duck_disabled, active_move_weapon
local saving_hotkey_prev, saving_teleport_hotkey_prev = false, false
local has_to_release_hotkey = false

local function on_setup_command(cmd)
	if not ui_get(enabled_reference) then
		return
	end

	local types = ui_get(types_reference)
	if #types == 0 then
		return
	end

	local local_player = entity_get_local_player()
	local weapon = entity_get_player_weapon(local_player)
	if weapon == nil then
		return
	end

	local tickrate_mp = (1/globals_tickinterval())/64

	local set_forwardmove = false
	if ui_get(hotkey_reference) then
		local aimbot = ui_get(aimbot_reference)

		if (location_targeted ~= nil and location_targeted.type == "grenade") or (active_move ~= nil and active_move_location ~= nil) then
			-- water_level_prev = entity_get_prop(local_player, "m_nWaterLevel")
			-- entity_set_prop(local_player, "m_nWaterLevel", 2)
			if aimbot == "Legit (Silent)" or aimbot == "Rage" or (active_move ~= nil and active_move_location ~= nil) or vector2(client_camera_angles()):dist_to(vector2(location_targeted.pitch, location_targeted.yaw)) <= location_targeted.viewAnglesDistanceMax then
				-- aiming at the location and pin pulled
				if active_move == nil then
					local speed = vector3(entity_get_prop(local_player, "m_vecVelocity")):length()
					if (cmd.in_attack == 1 or cmd.in_attack2 == 1) and entity_get_prop(weapon, "m_bPinPulled") == 1 and speed <= 1.1 then
						if entity_get_prop(local_player, "m_flDuckAmount") == (location_targeted.duck and 1 or 0) then
							if location_targeted.targeted then
								local throw_strength = entity_get_prop(weapon, "m_flThrowStrength")
								if throw_strength == location_targeted.throwStrength then
									active_move = MOVE_PREPARE
									active_move_weapon = weapon
									active_move_start = cmd.command_number
									active_move_location = location_targeted
								else
									if location_targeted.throwStrength == 1 then
										cmd.in_attack = 1
										cmd.in_attack2 = 0
									elseif location_targeted.throwStrength == 0.5 then
										cmd.in_attack = 1
										cmd.in_attack2 = 1
									elseif location_targeted.throwStrength == 0 then
										cmd.in_attack = 0
										cmd.in_attack2 = 1
									end
								end
							end
						end
					end
				end
				if active_move ~= nil and active_move_weapon ~= weapon then
					active_move = nil
				end
				if active_move == MOVE_PREPARE or active_move == MOVE_THROW then
					if aimbot == "Off" then
						cvar_sensitivity:set_raw_float(0)
					end
					if active_move_location.throwType == "RUN" or active_move_location.throwType == "RUNJUMP" then
						local step = math.floor((cmd.command_number-active_move_start) / tickrate_mp)

						if active_move_location.runDuration > step or active_move == MOVE_THROW then
							grenade_apply_movement(cmd, active_move_location)
						elseif active_move == MOVE_PREPARE then
							active_move = MOVE_THROW
						end
					else
						active_move = MOVE_THROW
					end
				end

				if active_move == MOVE_PREPARE then
					if active_move_location.throwStrength == 1 then
						cmd.in_attack = 1
						cmd.in_attack2 = 0
					elseif active_move_location.throwStrength == 0.5 then
						cmd.in_attack = 1
						cmd.in_attack2 = 1
					elseif active_move_location.throwStrength == 0 then
						cmd.in_attack = 0
						cmd.in_attack2 = 1
					end
				end

				if active_move == MOVE_THROW then
					local throw_type = active_move_location.throwType
					cmd.in_attack = 0
					cmd.in_attack2 = 0

					grenade_apply_movement(cmd, active_move_location)
					if throw_type == "JUMP" or throw_type == "RUNJUMP" then
						cmd.in_jump = 1
					end
					active_move = MOVE_DONE

					if aimbot == "Off" then
						client_delay_call(0.2, function()
							reset_cvar(cvar_sensitivity)
						end)
					end
					if ui_get(airstrafe_reference) then
						airstrafe_disabled = true
						ui_set(airstrafe_reference, false)
					end

					client_delay_call(0.8, function()
						active_move = nil
						active_move_location = nil
						has_to_release_hotkey = false

						if airstrafe_disabled then
							airstrafe_disabled = nil
							ui_set(airstrafe_reference, true)
						end
					end)
					has_to_release_hotkey = true
				elseif active_move == MOVE_DONE then
					cmd.in_attack = 0
					cmd.in_attack2 = 0
					if ui_get(airstrafe_reference) then
						airstrafe_disabled = true
						ui_set(airstrafe_reference, false)
					end

					grenade_apply_movement(cmd, active_move_location)

					if is_grenade_being_thrown(weapon, cmd) then
						if aimbot ~= "Off" then
							cmd.pitch = active_move_location.pitch
							cmd.yaw = active_move_location.yaw
							cmd.allow_send_packet = false
						end
						active_move = nil
					end
				end
			end
			if (cmd.in_attack == 1 or cmd.in_attack2 == 1) and location_targeted ~= nil and location_targeted.type == "grenade" then
				cmd.in_duck = location_targeted.duck and 1 or 0
			end
		elseif movement_play_location ~= nil and (cmd.in_forward == 1 or cmd.in_back == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or true) then
			-- water_level_prev = entity_get_prop(local_player, "m_nWaterLevel")
			-- entity_set_prop(local_player, "m_nWaterLevel", 2)

			if ui_get(airstrafe_reference) then
				airstrafe_disabled = true
				ui_set(airstrafe_reference, false)
			end
			if ui_get(infinite_duck_reference) then
				infinite_duck_disabled = true
				ui_set(infinite_duck_reference, false)
			end

			movement_play_frame_progress = 0
			if movement_play_location.data_parsed[math.floor(movement_play_index)] ~= nil then
				local frame = movement_play_location.data_parsed[math.floor(movement_play_index)]

				local rage_silent = ui_get(aimbot_reference) == "Rage"
				if not rage_silent and frame.pitch ~= nil and frame.yaw ~= nil then
					client_camera_angles(frame.pitch, frame.yaw)
				end

				if frame["in_moveright"] == 1 and frame["in_moveleft"] == 1 then
					frame["in_moveright"], frame["in_moveleft"], frame["sidemove"] = 0, 0, 0
				end
				if frame["in_forward"] == 1 and frame["in_back"] == 1 then
					frame["in_forward"], frame["in_back"], frame["forwardmove"] = 0, 0, 0
				end

				for i=1, #movement_setup_command_values do
					local name = movement_setup_command_values[i]
					local value = frame[name]
					if (value == 1 or (name ~= "in_attack" and name ~= "in_attack2" and name ~= "in_use")) and not (rage_silent and (name == "yaw" or name == "pitch")) then
						cmd[name] = value
					end
				end
				cmd.move_yaw = frame.yaw or cmd.move_yaw
				-- client.log(cmd.move_yaw)

				movement_play_index = movement_play_index + 1/tickrate_mp
			elseif movement_play_index ~= nil then
				-- client.log("playback finished after ", #movement_play_location.data_parsed, " frames")
				movement_play_index = nil
				movement_play_location = nil
			end
			movement_play_prev = true
		elseif location_targeted ~= nil then
			if location_targeted.type == "movement" and location_targeted.data_parsed ~= nil and vector2(client_camera_angles()):dist_to(vector2(location_targeted.pitch, location_targeted.yaw)) <= (aimbot == "Rage" and 15 or location_targeted.viewAnglesDistanceMax) and 0.1 > vector3(entity_get_prop(local_player, "m_vecVelocity")):length() then
				movement_play_location = location_targeted
				movement_play_prev = false
				movement_play_index = 1

				client_delay_call((#location_targeted.data_parsed)*(1/64)+0.2, function()
					if airstrafe_disabled then
						airstrafe_disabled = false
						ui_set(airstrafe_reference, true)
					end
					if infinite_duck_disabled then
						infinite_duck_disabled = false
						ui_set(infinite_duck_reference, true)
					end
				end)
			end
		elseif not has_to_release_hotkey then
			-- move to closest location
			if cmd.forwardmove == 0 and cmd.sidemove == 0 and cmd.in_forward == 0 and cmd.in_back == 0 and cmd.in_moveleft == 0 and cmd.in_moveright == 0 then
				if position_closest ~= nil then
					local origin = vector3(entity_get_prop(local_player, "m_vecOrigin"))
					local distance, distance_2d = origin:dist_to(position_closest), origin:dist_to_2d(position_closest)
					if (distance_2d < 0.08 and distance > 0.08 and distance < 4) or (position_data[position_closest].inaccurate and distance < 40) then
						distance = distance_2d
					end
					if distance < 32 and distance > 0.005 then
						local yaw = origin:vector_angles(position_closest).y
						cmd.move_yaw = yaw

						if position_data[position_closest].accurate_move then
							cmd.forwardmove = 450
							if distance < 3 then
								cmd.in_speed = 1
							end
						else
							if distance > 14 then
								cmd.forwardmove = 450
							else
								local wishspeed = math_min(450, math_max(1.1, distance * 9))
								local vel = vector3(entity_get_prop(local_player, "m_vecAbsVelocity")):length_2d()
								if vel >= math_min(250, wishspeed)+15 then
									cmd.forwardmove = 0
									cmd.in_forward = 0
								else
									cmd.forwardmove = vel >= math_min(250, wishspeed) and wishspeed*0.9 or wishspeed
									cmd.in_forward = 1
								end
							end
							set_forwardmove = true
						end
						-- cmd.in_speed = 1
					end
				end
			end
		end
	else
		active_move = nil
		active_move_location = nil
		has_to_release_hotkey = false
		movement_play_location = nil

		if airstrafe_disabled then
			airstrafe_disabled = false
			ui_set(airstrafe_reference, true)
		end
		if infinite_duck_disabled then
			infinite_duck_disabled = false
			ui_set(infinite_duck_reference, true)
		end
	end
	if set_forwardmove then
		if ui_get(quick_peek_assist_reference) then
			quick_peek_assist_disabled = true
			ui_set(quick_peek_assist_reference, false)
		end
	elseif quick_peek_assist_disabled then
		ui_set(quick_peek_assist_reference, true)
		quick_peek_assist_disabled = false
	end
	location_targeted = nil

	if ui_get(saving_enabled_reference) and ui_get(saving_hotkey_reference) and names_to_type[ui_get(saving_type_reference)] == "movement" and saving_location ~= nil then
		-- initialize data if first frame
		if not movement_saving_hotkey_prev then
			saving_location.data_parsed = {}
		end

		local frame = {}
		for i=1, #movement_setup_command_values do
			frame[movement_setup_command_values[i]] = cmd[movement_setup_command_values[i]]
		end
		table_insert(saving_location.data_parsed, frame)

		-- only start recording if something changes
		movement_saving_hotkey_prev = movement_saving_hotkey_prev or (cmd.forwardmove ~= 0 or cmd.sidemove ~= 0 or cmd.in_duck ~= 0 or cmd.in_jump ~= 0 or cmd.in_attack ~= 0 or cmd.in_attack2 ~= 0)
	elseif movement_saving_hotkey_prev then
		movement_saving_hotkey_prev = false
		-- recording finished

		local recording = saving_location.data_parsed
		local recording_compressed = {}

		local real = {}
		for key, char in pairs(movement_buttons_chars) do
			real[key] = 0
		end
		real.pitch = recording[1].pitch
		real.yaw = recording[1].yaw

		for i=1, #recording do
			local frame = recording[i]

			-- determine key flags
			local keys_down, keys_up = "", ""
			for key, char in pairs(movement_buttons_chars) do
				if frame[key] == 1 and real[key] == 0 then
					keys_down = keys_down .. char
				elseif frame[key] == 0 and real[key] == 1 then
					keys_up = keys_up .. char
				end
				real[key] = frame[key]
			end

			local pitch_delta, yaw_delta = round(frame.pitch-real.pitch, 4), round(frame.yaw-real.yaw, 6)
			local frame_compressed = {pitch_delta, yaw_delta, keys_down, keys_up, frame.forwardmove, frame.sidemove}

			-- check if sidemove is what we expect it to be
			if (frame.sidemove == 0 and frame.in_moveright == 0 and frame.in_moveleft == 0)
			or (frame.sidemove == 450 and frame.in_moveright == 1 and frame.in_moveleft == 0)
			or (frame.sidemove == -450 and frame.in_moveright == 0 and frame.in_moveleft == 1) then
				frame_compressed[6] = nil

				-- check if forwardmove is what we expect it to be
				if (frame.forwardmove == 0 and frame.in_forward == 0 and frame.in_back == 0)
				or (frame.forwardmove == 450 and frame.in_forward == 1 and frame.in_back == 0)
				or (frame.forwardmove == -450 and frame.in_forward == 0 and frame.in_back == 1) then
					frame_compressed[5] = nil

					-- check if no key is lifted
					if keys_up == "" then
						frame_compressed[4] = nil

						-- check if no key is pressed
						if keys_down == "" then
							frame_compressed[3] = nil

							-- check if yaw is unchanged
							if frame_compressed[2] == 0 then
								frame_compressed[2] = nil

								-- check if pitch is unchanged
								if frame_compressed[1] == 0 then
									frame_compressed[1] = nil
								end
							end
						end
					end
				end
			end

			table_insert(recording_compressed, frame_compressed)

			-- update real pitch and yaw
			real.pitch = real.pitch+pitch_delta
			real.yaw = real.yaw+yaw_delta
		end

		local recording_compressed_new = {}

		local amt = 0
		for i=1, #recording_compressed do
			if #recording_compressed[i] == 0 then
				amt = amt + 1
			else
				if amt > 0 then
					table_insert(recording_compressed_new, amt)
					amt = 0
				end
				table_insert(recording_compressed_new, recording_compressed[i])
			end
		end
		if amt > 0 then
			table_insert(recording_compressed_new, amt)
			amt = 0
		end

		saving_location.pitch = recording[1].pitch
		saving_location.yaw = recording[1].yaw
		saving_location.viewangles = nil
		saving_location.fwd = nil
		reload_data = "new_save"

		-- json_encode_pretty(dt, [lf = "\n", [id = "\t", [ac = " ", [ec = function]]]])
		saving_location.data = recording_compressed_new
		-- json_encode_pretty(recording_compressed_new, "", "", "")
	end
end
client.set_event_callback("setup_command", on_setup_command)

local function on_paint_saving(local_player, weapon, screen_width, screen_height, locations_on, on_correct)
	local location_type = names_to_type[ui_get(saving_type_reference)]
	local create_location = false

	local saving_hotkey = ui_get(saving_hotkey_reference)

	if saving_hotkey and not saving_hotkey_prev then
		if location_type == "grenade" then
			if entity_get_prop(weapon, "m_bPinPulled") == 1 or true then
				create_location = true
			end
		elseif location_type ~= "movement" or not movement_saving_hotkey_prev then
			create_location = true
		end
	end

	local saving_teleport_hotkey = ui_get(saving_teleport_hotkey_reference)
	if not saving_teleport_hotkey and saving_teleport_hotkey_prev then
		on_saving_teleport()
	end

	if create_location then
		local weapon_name = console_names[entity_get_classname(entity_get_player_weapon(entity_get_local_player()))]
		if weapon_name ~= nil then
			local mapname = get_mapname()
			saving_location = ordered_table({
				"temporary", true,
				"map", mapname,
				"from", "",
				"to", "",
				"type", location_type,
				"weapon", weapon_name,
				"x", "",
				"y", "",
				"z", "",
				"pitch", "",
				"yaw", ""
			})

			-- client.log("created saving_location")

			saving_location.x, saving_location.y, saving_location.z = entity_get_prop(local_player, "m_vecAbsOrigin")
			saving_location.pitch, saving_location.yaw = client_camera_angles()
			saving_location.duck = entity_get_prop(local_player, "m_flDuckAmount") > 0 and true or nil

			if location_type == "grenade" then
				local throw_strength = entity_get_prop(weapon, "m_flThrowStrength")
				if throw_strength ~= nil and throw_strength ~= 1 then
					saving_location.throwStrength = throw_strength
				end
			end

			reload_data = "created saving_location"
		end
	end

	if saving_location ~= nil then
		if saving_location.type == "grenade" then
			local saving_properties = ui_get(saving_properties_reference)
			if table_contains(saving_properties, "Jump") and table_contains(saving_properties, "Run") then
				saving_location.throwType = "RUNJUMP"
			elseif table_contains(saving_properties, "Jump") then
				saving_location.throwType = "JUMP"
			elseif table_contains(saving_properties, "Run") then
				saving_location.throwType = "RUN"
			else
				saving_location.throwType = "NORMAL"
			end

			if table_contains(saving_properties, "Run") then
				local run_duration = ui_get(saving_run_duration_reference)
				saving_location.runDuration = run_duration
				local run_direction = ui_get(saving_run_direction_reference)
				saving_location.runYaw = run_direction_yaw[run_direction]
				saving_location.runSpeed = table_contains(saving_properties, "Walk")
			else
				saving_location.runDuration = nil
				saving_location.runYaw = nil
				saving_location.runSpeed = nil
			end

			saving_location.tickrate = table_contains(saving_properties, "Tickrate") and 1/globals_tickinterval() or nil
		end

		local from = ui_get(saving_from_reference)

		saving_location.to = ui_get(saving_to_reference)

		if saving_location.to == "" then
			saving_location.to = "Unnamed"
		end
		if create_location and on_correct and not locations_on[1].temporary then
			saving_location.from = locations_on[1].from
			saving_location.pos = locations_on[1].pos
			saving_location.x, saving_location.y, saving_location.z = saving_location.pos:unpack()
		else
			if saving_location.from == nil or from ~= "" then
				saving_location.from = from
			end
			if saving_location.from == "" then
				saving_location.from = get_callout_name(entity.get_prop(entity.get_local_player(), "m_szLastPlaceName")) or ""
			end
		end
		if saving_location.from == "" then
			saving_location.from = "Unnamed"
		end
		saving_location.name = saving_location.to
		saving_location.type = location_type

		if saving_location.type == "grenade" and console_names_to_name[saving_location.weapon] == nil then
			saving_location = nil
		end
	end

	saving_hotkey_prev = saving_hotkey
	saving_teleport_hotkey_prev = saving_teleport_hotkey

	local lines = {}
	local from, to = ui_get(saving_from_reference), ui_get(saving_to_reference)

	if from == "" or to == "" then
		table_insert(lines, {255, 255, 255, 255, "bc", "Saving new location"})
		if from == "" then
			table_insert(lines, {255, 16, 16, 255, "", "Warning: from not set", ((saving_location ~= nil and saving_location.from ~= nil and saving_location.from ~= "Unknown") and ", assuming '" .. saving_location.from .. "'" or "")})
		end
		if to == "" then
			table_insert(lines, {255, 16, 16, 255, "", "Warning: to not set"})
		end
	else
		table_insert(lines, {255, 255, 255, 255, "b", (saving_location == nil and "Saving" or "Editing"), " '", from, "' to '", to, "'"})
	end

	if grenade_thrown_at ~= nil and saving_location ~= nil and saving_location.type == "grenade" then
		table_insert(lines, {27, 162, 248, 255, "", "Grenade flying for ", string_format("%.2fs", globals_curtime()-grenade_thrown_at)})
	elseif saving_location ~= nil and saving_location.flyDuration ~= nil then
		table_insert(lines, {27, 162, 248, 255, "", "Grenade took ", string_format("%.2fs", saving_location.flyDuration)})
	elseif location_type == "movement" then
		local saving_cvars = {
			{"sv_airaccelerate", "float", 12},
			{"sv_enablebunnyhopping", "int", 0},
			{"sv_autobunnyhopping", "int", 0},
		}

		if ui_get(airstrafe_reference) then
			table_insert(lines, {255, 16, 16, 255, "", "Warning: Air strafe is enabled"})
		end

		for i=1, #saving_cvars do
			local cvar_name, cvar_type, value_correct = unpack(saving_cvars[i])
			local cvar_obj = cvar[cvar_name]

			local value
			if cvar_type == "float" then
				value = cvar_obj:get_float()
			elseif cvar_type == "int" then
				value = cvar_obj:get_int()
			elseif cvar_type == "string" then
				value = cvar_obj:get_string()
			end

			if value ~= nil and value ~= value_correct then
				table_insert(lines, {255, 16, 16, 255, "", "Warning: cvar " .. cvar_name .. " is wrong (correct=" .. value_correct .. ")"})
			end
		end

		if saving_location ~= nil and saving_location.data_parsed ~= nil then
			local tickinterval = globals_tickinterval()
			if saving_hotkey then
				table_insert(lines, {})
				if (#saving_location.data_parsed-1) == 0 then
					table_insert(lines, {230, 84, 84, 255, "", "Start moving to record"})
				else
					table_insert(lines, {230, 84, 84, 255, "", "Recording for ", string_format("%.2fs", tickinterval*(#saving_location.data_parsed-1))})
				end
			elseif saving_location.data ~= nil then
				table_insert(lines, {})
				table_insert(lines, {84, 230, 94, 255, "", "Recorded for ", string_format("%.2fs", tickinterval*(#saving_location.data_parsed))})
			end
		end
	end

	if location_type == "grenade" then
		local saving_properties = ui_get(saving_properties_reference)
		if #saving_properties > 0 then
			table_insert(lines, {230, 230, 230, 255, "", "Properties: ", table_concat(saving_properties, ", ")})
		end

		if table_contains(saving_properties, "Run") then
			local run_direction = ui_get(saving_run_direction_reference)
			table_insert(lines, {230, 230, 230, 255, "", "Run duration: ", run_direction == "Forward" and "" or " ", ui_get(saving_run_duration_reference), " ticks"})
			if run_direction ~= "Forward" then
				table_insert(lines, {230, 230, 230, 255, "", "Run direction: ", run_direction})
			end
		end
	end

	if saving_location ~= nil then
		table_insert(lines, {})
		table_insert(lines, {230, 230, 230, 180, "", "Make sure to click 'Save'"})
	end

	if #lines[#lines] == 0 then
		lines[#lines] = nil
	end

	local line_width, line_height = {}, {}
	for i=1, #lines do
		line_width[i], line_height[i] = renderer_measure_text(select(5, unpack(lines[i])))
	end
	local width = math_max(0, unpack(line_width))

	local x = screen_width/2-width/2
	local y = 60

	--draw background
	renderer_rectangle(x-5, y-4, width+10, #lines*10+10, 16, 16, 16, 150)

	for i=1, #lines do
		table_insert(lines[i], 6, 0)
		local flag_offset = i == -1 and (width/2 - line_width[i]/2) or 0

		if lines[i][5] ~= nil then
			if lines[i][5]:find("b") then
				flag_offset = flag_offset + 1
			end
			if lines[i][5]:find("c") then
				lines[i][5] = lines[i][5]:gsub("c", "")
				flag_offset = flag_offset + (width-line_width[i])/2
			end
			renderer_text(x + flag_offset, y+i*10-10, unpack(lines[i]))
		end
	end
end

local function on_paint()
	location_targeted = nil
	position_closest = nil
	if not ui_get(enabled_reference) then
		return
	end
	local types = ui_get(types_reference)
	if #types == 0 then
		return
	end

	local local_player = entity_get_local_player()
	local weapon = entity_get_player_weapon(local_player)
	if weapon == nil then
		return
	end

	local is_running_commands = not (entity_get_prop(local_player, "m_MoveType") == MOVETYPE_NOCLIP)

	if not is_running_commands then
		on_run_command({command_number=globals.tickcount(), from_paint=true})
	end

	if is_running_commands and ui_get(hotkey_reference) and ui_get(aimbot_reference) ~= "Rage" and movement_play_index ~= nil and movement_play_location ~= nil and movement_play_index % 1 == 0 then
		local recording = movement_play_location.data_parsed
		if recording ~= nil and recording[movement_play_index] ~= nil and recording[movement_play_index-1] ~= nil then
			local progress = movement_play_frame_progress / globals_tickinterval()
			movement_play_frame_progress = movement_play_frame_progress + globals.frametime()

			if progress >= 0 and progress <= 1 then
				-- return a + (b - a) * percentage

				local prev = vector2(recording[movement_play_index-1].pitch, recording[movement_play_index-1].yaw)
				local cur = vector2(recording[movement_play_index].pitch, recording[movement_play_index].yaw)
				local delta = cur - prev

				prev:normalize_angles()
				cur:normalize_angles()
				delta:normalize_angles()

				local interp = prev + delta * progress
				interp:normalize_angles()

				client_camera_angles(interp:unpack())
			end
		end
	end

	local dist_max_targets = 20
	local full_world_alpha_distance = 200
	local flags_world = "c"
	local flags_target = ""
	local flags_target_sub = "-"
	local background_r, background_g, background_b, background_a = 19, 19, 19, 130
	local locations_world_visible_only = not (ui_get(ignore_visibility_reference) or helper_debug)
	local r, g, b, a = ui_get(color_reference)
	local a_mp = a/255
	local realtime = globals_realtime()

	if last_weapon_switch ~= nil then
		local delta = realtime - last_weapon_switch
		if 0.45 > delta then
			a_mp = a_mp * delta / 0.45
		end
	end

	local origin = vector3(entity_get_prop(local_player, "m_vecAbsOrigin"))
	local eye_pos = vector3(client_eye_position())
	local camera_pos = vector3(client.camera_position())
	local screen_width, screen_height = client_screen_size()

	-- find locations close that we need to draw (close and on)
	local locations_close, locations_close_unchecked = {}, {}
	locations_on = {}

	local dist_closest = 1/0

	for i=1, #data_weapon do
		local location = data_weapon[i]
		local location_pos = location.pos
		if position_data[location_pos].distance_sqr == nil then
			position_data[location_pos].distance_sqr = (origin-location_pos):length_sqr()
		end

		if dist_max_sqr > position_data[location_pos].distance_sqr then
			if position_data[location_pos].distance == nil then
				position_data[location_pos].distance = math_sqrt(position_data[location_pos].distance_sqr)
				position_data[location_pos].wx, position_data[location_pos].wy = (location_pos+wx_offset_vec):to_screen()
				if position_data[location_pos].wx ~= nil and (position_data[location_pos].wx > screen_width or position_data[location_pos].wx < 0 or position_data[location_pos].wy > screen_height or position_data[location_pos].wy < 0) then
					position_data[location_pos].wx = nil
				end
				if position_data[location_pos].wx ~= nil then
					position_data[location_pos].wx_bottom, position_data[location_pos].wy_bottom = location_pos:to_screen()
				end

				position_data[location_pos].distance_2d = origin:dist_to_2d(location_pos)
				if (position_data[location_pos].distance_2d < 0.08 and position_data[location_pos].distance > 0.08 and position_data[location_pos].distance < 4) or (position_data[location_pos].inaccurate and position_data[location_pos].distance < 32) then
					position_data[location_pos].distance = position_data[location_pos].distance_2d
				end
			end

			table_insert(locations_close_unchecked, location)

			if position_data[location_pos].wx ~= nil then
				if (position_data[location_pos].distance_2d < 80 and position_data[location_pos].distance < 100) or location.temporary then
					position_data[location_pos].visible = true
				end
				if position_data[location_pos].visible == nil then
					local fraction = camera_pos:trace_line(position_data[location_pos].visibility_location, local_player)
					position_data[location_pos].visible = fraction > 0.97
				end
				if not locations_world_visible_only or position_data[location_pos].visible or (position_data[location_pos].last_visible ~= nil and realtime - position_data[location_pos].last_visible < 0.15) then
					table_insert(locations_close, location)
				end
			end

			if position_data[location_pos].visible == nil then
				position_data[location_pos].visible = false
			end

			if position_data[location_pos].visible ~= (position_data[location_pos].visible_prev or false) then
				if position_data[location_pos].visible then
					position_data[location_pos].last_invisible = realtime
				else
					position_data[location_pos].last_visible = realtime
				end
			end

			if dist_closest > position_data[location_pos].distance then
				position_closest = location_pos
				dist_closest = position_data[location_pos].distance
			end
		end
	end

	for i=1, #locations_close_unchecked do
		if locations_close_unchecked[i].pos == position_closest and position_data[locations_close_unchecked[i].pos].distance < dist_max_targets then
			table_insert(locations_on, locations_close_unchecked[i])
		end
	end

	local on_correct = locations_on[1] ~= nil and position_data[locations_on[1].pos].distance < (locations_on[1].type == "movement" and 0.03 or 0.08)
	local a_mp_target = on_correct and 1 or (locations_on[1] == nil and 0 or (1-position_data[locations_on[1].pos].distance/dist_max_targets))

	if ui_get(saving_enabled_reference) then
		on_paint_saving(local_player, weapon, screen_width, screen_height, locations_on, on_correct)
	end

	-- determine position offset for all locations based on locations with the same position
	local pos_offsets = {}
	for i=1, #locations_close do
		local pos = locations_close[i].pos
		if pos_offsets[pos] == nil then
			pos_offsets[pos] = -1

			local distance_alpha = math_min(1, 1 - (position_data[pos].distance-full_world_alpha_distance) / (dist_max-full_world_alpha_distance))

			local visible_alpha_mp = 1
			if position_data[pos].visible and position_data[pos].last_invisible ~= nil and realtime - position_data[pos].last_invisible < 0.35 then
				visible_alpha_mp = (realtime - position_data[pos].last_invisible) / 0.35
			elseif not position_data[pos].visible and position_data[pos].last_visible ~= nil and realtime - position_data[pos].last_visible < 0.15 then
				visible_alpha_mp = (1 - (realtime - position_data[pos].last_visible) / 0.15)
			elseif not position_data[pos].visible then
				visible_alpha_mp = 0
			end

			position_data[pos].visible_alpha_mp = visible_alpha_mp

			position_data[pos].world_alpha_multiplier = distance_alpha * visible_alpha_mp
			if locations_world_visible_only then
				position_data[pos].world_alpha_multiplier_text = position_data[pos].world_alpha_multiplier
			else
				position_data[pos].world_alpha_multiplier_text = distance_alpha
			end

			-- currently focusing another location
			if #locations_on > 0 then
				position_data[pos].world_alpha_multiplier = table_contains(locations_on, locations_close[i]) and 1 or position_data[pos].world_alpha_multiplier*0.15
				position_data[pos].world_alpha_multiplier_text = position_data[pos].world_alpha_multiplier
			elseif active_move_location ~= nil then
				position_data[pos].world_alpha_multiplier = active_move_location == pos and 1 or 0
				position_data[pos].world_alpha_multiplier_text = position_data[pos].world_alpha_multiplier
			end
		end
		pos_offsets[pos] = pos_offsets[pos] + 1
		locations_close[i].offset = pos_offsets[pos]
	end

	-- determine text for all positions that are on screen
	for i=1, #locations_close do
		local location = locations_close[i]
		location.text_world = location.name -- .. " (" .. tostring(position_data[location.pos].accurate_move) .. ")"
		if helper_debug then
			location.text_world = location.name .. " (" .. string_format("%.1f", position_data[location.pos].distance) .. ", " .. (location.pos_id or "no id") .. ", " .. string_format("%.2f", position_data[location.pos].visible_alpha_mp) .. ")"
		end
	end

	-- determine text width for a position by first finding the longest string, then doing measure_text
	local pos_width = {}
	for i=1, #locations_close do
		local location = locations_close[i]
		if location.text_world ~= nil then
			if pos_width[locations_close[i].pos] == nil or pos_width[locations_close[i].pos]:len() < location.text_world:len() then
				pos_width[locations_close[i].pos] = location.text_world
			end
		end
	end
	for pos, text in pairs(pos_width) do
		pos_width[pos] = renderer_measure_text(flags_world, text)

		local width = math_ceil(pos_width[pos]/2)*2+6
		local height = (pos_offsets[pos]+1)*10+4
		renderer_rectangle(position_data[pos].wx-width/2, position_data[pos].wy-height+7, width, height, background_r, background_g, background_b, background_a*position_data[pos].world_alpha_multiplier_text*a_mp)

		if position_data[pos].wx_bottom ~= nil then
			renderer_line(position_data[pos].wx-1, position_data[pos].wy+7, position_data[pos].wx_bottom-1, position_data[pos].wy_bottom, background_r, background_g, background_b, background_a*0.3*position_data[pos].world_alpha_multiplier*a_mp)
			renderer_line(position_data[pos].wx, position_data[pos].wy+7, position_data[pos].wx_bottom, position_data[pos].wy_bottom, background_r, background_g, background_b, background_a*position_data[pos].world_alpha_multiplier*a_mp)
			renderer_line(position_data[pos].wx+1, position_data[pos].wy+7, position_data[pos].wx_bottom+1, position_data[pos].wy_bottom, background_r, background_g, background_b, background_a*0.3*position_data[pos].world_alpha_multiplier*a_mp)
		end
	end

	-- draw world text
	for i=1, #locations_close do
		local location = locations_close[i]
		if location.text_world ~= nil then
			local r, g, b, a = r, g, b, a
			if location.temporary then
				r, g, b = 255, 0, 0
			end
			renderer_text(position_data[location.pos].wx, position_data[location.pos].wy-10*location.offset, r, g, b, a*position_data[location.pos].world_alpha_multiplier_text*a_mp, flags_world, 0, location.text_world)
		end
	end

	local screen_center = vector2(screen_width, screen_height)/2

	local dist_closest, location_closest = 1/0
	for i=1, #locations_on do
		local location = locations_on[i]
		-- renderer_text(15, 5+i*10, 255, 255, 255, 255, nil, 0, "", location.name, " ", location.offset, " ", location.id, " ", location.description)
		local target = location.target
		position_data[target].wx, position_data[target].wy = location.target:to_screen()
		if position_data[target].wx ~= nil then
			local dist = screen_center:dist_to_2d(vector2(position_data[target].wx, position_data[target].wy))
			if dist < dist_closest then
				location_closest, dist_closest = location, dist
			end
		end
	end
	location_targeted = location_closest

	if location_closest ~= nil and position_data[location_closest.target].wx ~= nil then
		-- location_targeted.crosshair_dist = vector2(client_camera_angles()):dist_to_2d(vector2(location_closest.pitch, location_closest.yaw))
		local camera_angles = vector2(client_camera_angles())
		local delta = camera_angles - location_targeted.viewangles
		delta:normalize_angles()
		location_targeted.crosshair_dist = delta:length_2d()
		location_targeted.viewangles_correct = (location_targeted.crosshair_dist <= location_closest.viewAnglesDistanceMax)
		location_targeted.center_dist = dist_closest
		local aimbot = ui_get(aimbot_reference)
		local closest_targeted = (((aimbot == "Legit (Silent)" and location_closest.type == "grenade") or (aimbot == "Rage")) and (location_targeted.crosshair_dist < 15) or location_targeted.viewangles_correct) and entity_get_prop(local_player, "m_flDuckAmount") == (location_closest.duck and 1 or 0)
		local line_drawn = location_targeted.center_dist < 230

		local can_target = true
		if location_targeted.destroy ~= nil then
			local fraction, entindex_hit = location_targeted.destroy_start:trace_line(location_targeted.destroy, local_player)
			can_target = fraction > 0.84
			-- location_targeted.destroy_start:draw_line(location_targeted.destroy, 255, can_target and 0 or 255, can_target and 0 or 255, 255)
		end

		if (aimbot == "Legit (Smooth)" or (aimbot == "Legit (Silent)" and (location_closest.type == "movement" or location_closest.type == "wallbang"))) and location_targeted.crosshair_dist < 10 and location_targeted.crosshair_dist > 0.001 and ui_get(hotkey_reference) and entity_get_prop(local_player, "m_flDuckAmount") == (location_closest.duck and 1 or 0) then
			local delta = camera_angles - location_targeted.viewangles
			delta:normalize_angles()
			local dist = delta:length_2d()
			delta:normalize()

			local mp = math.min(1, dist/3)*0.5
			delta = delta*mp + delta*dist*(1-mp)

			client.camera_angles((camera_angles - delta*globals.frametime()*10*client.random_float(0.7, 1.2)):unpack())
		end

		location_closest.targeted = closest_targeted and can_target

		-- determine all texts + subtexts
		for i=1, #locations_on do
			local location = locations_on[i]
			location.target_text = location.name
			location.target_text_2 = nil
			location.target_subtext = nil
			if location == location_closest then
				local info = {}
				if location.duck then
					table_insert(info, "DUCK")
				end
				if location.throwStrength ~= 1 then
					local strength_text = tostring(location.throwStrength) .. " STRENGTH"
					if location.throwStrength == 0 then
						strength_text = "RIGHTCLICK"
					elseif location.throwStrength == 0.5 then
						strength_text = "RIGHT+LEFTCLICK"
					end
					table_insert(info, strength_text)
				end

				-- if location.flyDuration ~= nil then
				-- 	table_insert(info, round(location.flyDuration, 1) .. " S")
				-- end
				if can_target then
					local subtext = table_concat(info, ", ")
					if subtext ~= "" then
						location.target_subtext = subtext
					end
				else
					location.target_subtext = location.destroyText:upper()
				end

				local target_text_2_elements = {}

				if throwtype_description[location.throwType] ~= nil then
					table_insert(target_text_2_elements, throwtype_description[location.throwType])
				end
				if location.temporary then
					table_insert(target_text_2_elements, "editing")
				end

				if #target_text_2_elements > 0 then
					location.target_text_2 = " - " .. table_concat(target_text_2_elements, ", ")
				end
			end
		end

		-- draw all backgrounds
		for i=1, #locations_on do
			local location = locations_on[i]
			if position_data[location.target].wx ~= nil then
				local text_width_2 = 0
				if location.target_text_2 ~= nil then
					text_width_2 = renderer_measure_text(flags_target, location.target_text_2)
				end
				local text_width = renderer_measure_text(flags_target, location.target_text)
				local subtext_width = location.target_subtext ~= nil and renderer_measure_text(flags_target_sub, location.target_subtext) or 0
				local width = math_max(text_width+text_width_2, subtext_width)
				local height = 10
				if location.target_subtext ~= nil then
					height = height + 6
				end
				position_data[location].target_text_width = text_width

				renderer_rectangle(position_data[location.target].wx-7, position_data[location.target].wy-6, width+16, height+3, background_r, background_g, background_b, background_a*a_mp*a_mp_target)

				if location ~= location_closest then
					renderer_circle(position_data[location.target].wx, position_data[location.target].wy, 8, 8, 8, 120*a_mp*a_mp_target, 4, 0, 1)
				end
			end
		end

		if location_closest.type ~= "wallbang_hvh" then
			if closest_targeted and on_correct then
				if can_target then
					local r, g, b = 0, 255, 0
					if location_closest.type == "wallbang" then
						local max_distance = 8192

						local pitch, yaw = client_camera_angles()

						local fwd = vector3.angle_forward(vector2(pitch, yaw, 0))
						local end_pos = eye_pos + (fwd * max_distance)
						local damage, entindex_hit = eye_pos:trace_bullet(end_pos, local_player)

						if entindex_hit > 0 then
							r, g, b = 10, 96, 255
						end
					end
					renderer_circle(position_data[location_closest.target].wx, position_data[location_closest.target].wy, r, g, b, 150*a_mp*a_mp_target, 3, 0, 1)
				else
					renderer_circle(position_data[location_closest.target].wx, position_data[location_closest.target].wy, 255, 150, 0, 150*a_mp*a_mp_target, 3, 0, 1)
				end
			else
				local a_mp_circles = a_mp_target
				if not on_correct then
					a_mp_circles = a_mp_target / 4
				end
				if line_drawn then
					renderer_circle(position_data[location_closest.target].wx, position_data[location_closest.target].wy, 255, 32, 32, 80*a_mp*a_mp_circles, 3, 0, 1)
				else
					renderer_circle(position_data[location_closest.target].wx, position_data[location_closest.target].wy, 255, 32, 32, 20*a_mp*a_mp_circles, 3, 0, 1)
				end
			end
		end

		if location_targeted.center_dist > 4 then
			local mp = ui_get(brightness_adjustment_reference) == "Night mode" and 0.4 or 0.8
			renderer_line(position_data[location_closest.target].wx, position_data[location_closest.target].wy, screen_width/2, screen_height/2, r, g, b, a*mp*a_mp*a_mp_target)
		end
		if location_targeted.land ~= nil then
			local wx, wy = location_targeted.land:to_screen()

			if wx ~= nil then
				if not true then
					local wx_top, wy_top = (location_targeted.land+land_offsets_vec[1]):to_screen()
					if wx_top ~= nil then
						renderer_line(wx, wy, wx_top, wy_top, 255, 0, 0, a*a_mp*a_mp_target)
					end

					local wx_fwd, wy_fwd = (location_targeted.land+land_offsets_vec[2]):to_screen()
					if wx_fwd ~= nil then
						renderer_line(wx, wy, wx_fwd, wy_fwd, 255, 0, 0, a*a_mp*a_mp_target)
					end

					local wx_back, wy_back = (location_targeted.land-land_offsets_vec[2]):to_screen()
					if wx_back ~= nil then
						renderer_line(wx, wy, wx_back, wy_back, 255, 0, 0, a*a_mp*a_mp_target)
					end

					local wx_left, wy_left = (location_targeted.land+land_offsets_vec[3]):to_screen()
					if wx_left ~= nil then
						renderer_line(wx, wy, wx_left, wy_left, 255, 0, 0, a*a_mp*a_mp_target)
					end

					local wx_right, wy_right = (location_targeted.land-land_offsets_vec[3]):to_screen()
					if wx_right ~= nil then
						renderer_line(wx, wy, wx_right, wy_right, 255, 0, 0, a*a_mp*a_mp_target)
					end
				else
					if wx ~= nil then
						local wx_top, wy_top = (location_targeted.land+land_offsets_vec[1]):to_screen()
						if wx_top ~= nil then
							local size = math_max(5, math_min(22, math.abs(wy_top-wy)*0.8))

							renderer_triangle(wx-size-2, wy-size-1, wx+size+2, wy-size-1, wx, wy+2, background_r, background_g, background_b, background_a*a_mp*a_mp_target*0.6)
							renderer_triangle(wx-size, wy-size, wx+size, wy-size, wx, wy, r, g, b, a*a_mp*a_mp_target*0.6)
						end
					end
				end
			end
		end

		for i=1, #locations_on do
			local location = locations_on[i]
			if position_data[location.target].wx ~= nil then
				local a_multiplier = 0.35
				if location == location_closest then
					a_multiplier = line_drawn and 1 or 0.65
				end

				renderer_circle_outline(position_data[location.target].wx, position_data[location.target].wy, 255, 255, 255, 255*a_multiplier*a_mp*a_mp_target, 4, 0, 1, 1)

				local r, g, b, a = r, g, b, a
				if location.temporary then
					r, g, b = 255, 0, 0
				end
				renderer_text(position_data[location.target].wx+6, position_data[location.target].wy-6, r, g, b, a*a_multiplier*a_mp*a_mp_target, flags_target, 0, location.target_text)

				if location.target_text_2 ~= nil then
					renderer_text(position_data[location.target].wx+6+position_data[location].target_text_width, position_data[location.target].wy-6, 200, 200, 200, 255*a_multiplier*0.8*a_mp*a_mp_target, flags_target, 0, location.target_text_2)
				end

				if location.target_subtext ~= nil then
					if can_target then
						renderer_text(position_data[location.target].wx+6, position_data[location.target].wy-6+10, 255, 255, 255, 160*a_multiplier*a_mp*a_mp_target, flags_target_sub, 0, location.target_subtext)
					else
						renderer_text(position_data[location.target].wx+6, position_data[location.target].wy-6+10, 255, 150, 32, 160*a_multiplier*a_mp*a_mp_target, flags_target_sub, 0, location.target_subtext)
					end
				end
			end
		end
	end

	-- reset
	for i=1, #data_weapon do
		position_data[data_weapon[i].pos].distance = nil
		position_data[data_weapon[i].pos].distance_sqr = nil
		position_data[data_weapon[i].pos].wx = nil
		position_data[data_weapon[i].pos].wx_bottom = nil

		if position_data[data_weapon[i].pos].visible ~= nil then
			position_data[data_weapon[i].pos].visible_prev = position_data[data_weapon[i].pos].visible
			position_data[data_weapon[i].pos].visible = nil
		end
	end
	if not on_correct then
		location_targeted = nil
		locations_on = {}
	end
end
client.set_event_callback("paint", on_paint)

local function on_grenade_detonate(e, grenade_type)
	if grenade_type ~= "molotov" and client_userid_to_entindex(e.userid) ~= entity_get_local_player() then
		return
	end

	if ui_get(saving_enabled_reference) then
		if saving_location ~= nil and grenade_thrown_at ~= nil then
			-- saving_location.flyDuration = globals_curtime()-grenade_thrown_at
			saving_location.landX = e.x
			saving_location.landY = e.y
			saving_location.landZ = e.z
			reload_data = "saving_detonated"
		end
	end
	grenade_thrown_at = nil
end
client.set_event_callback("smokegrenade_detonate", function(e) on_grenade_detonate(e, "smokegrenade") end)
client.set_event_callback("hegrenade_detonate", function(e) on_grenade_detonate(e, "hegrenade") end)
client.set_event_callback("inferno_startburn", function(e) on_grenade_detonate(e, "molotov") end)
client.set_event_callback("flashbang_detonate", function(e) on_grenade_detonate(e, "flashbang") end)
client.set_event_callback("decoy_started", function(e) on_grenade_detonate(e, "decoy") end)

local function on_grenade_thrown(e)
	if client_userid_to_entindex(e.userid) ~= entity_get_local_player() then
		return
	end

	if saving_location ~= nil then
		saving_location.flyDuration = nil
		saving_location.landX = nil
		saving_location.landY = nil
		saving_location.landZ = nil
	end

	grenade_thrown_at = globals_curtime()
	grenade_entindex = entity_get_player_weapon(entity_get_local_player())
end
client.set_event_callback("grenade_thrown", on_grenade_thrown)

local function on_shutdown()
	if airstrafe_disabled then
		ui_set(airstrafe_reference, true)
	end
	if quick_peek_assist_disabled then
		ui_set(quick_peek_assist_reference, true)
	end
	if infinite_duck_disabled then
		ui_set(infinite_duck_reference, true)
	end
	reset_cvar(cvar_sensitivity)

	db["saving_location"] = saving_serialize(saving_location)

	database.write("helper", db)
end
client.set_event_callback("shutdown", on_shutdown)

local function on_level_init()
	ui_set(saving_enabled_reference, false)
	create_items()
end
client.set_event_callback("level_init", on_level_init)
