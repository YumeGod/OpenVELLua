local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,pairs,r,s=client.draw_indicator,client.random_int,client.set_event_callback,globals.realtime,math.floor,math.sin,renderer.measure_text,renderer.rectangle,renderer.text,string.format,ui.get,ui.new_checkbox,ui.new_combobox,ui.new_hotkey,ui.new_multiselect,ui.reference,ui.set,pairs,ui.set_callback,ui.set_visible;local t=client.screen_size()local function u()local v,w,x=func_rgb_rainbowize(1,1)local y=[[
        ______            _____          _
        | ___ \          |  ___|        (_)
        | |_/ /_   _     | |__ _ __ ___  _ _   _  __ _
        | ___ \ | | |    |  __| '_ ` _ \| | | | |/ _` |
        | |_/ / |_| |    | |__| | | | | | | |_| | (_| |
        \____/ \__, |    \____/_| |_| |_|_|\__, |\__,_|
                __/ |                       __/ |
             |___/                       |___/
       ]]client.color_log(37,160,247,"--------EMIYA MANUAL AA(using eagle aa mode) IS LOADED-------------")client.color_log(37,160,247,y)client.color_log(37,160,247,"--------EMIYA MANUAL AA(using eagle aa mode) IS LOADED-------------")end;local z=ui.new_label("LUA","B","======= EMIYA AA =======")local A=ui.new_checkbox("LUA","B","| Activate Antiaim")local B=ui.new_combobox("LUA","B","| Anti-hit types","Static","Auto","Manual","Experimental","Experimental 2","Test")local C=ui.new_hotkey("LUA","B","| Invert key")local D=ui.new_hotkey("LUA","B","| Slowwalk Keybind")local E=ui.new_hotkey("LUA","B","| Manual LEFT")local F=ui.new_hotkey("LUA","B","| Manual RIGHT")local G=ui.new_combobox("LUA","B","| LBY exploits by user64","Off","Fake twist","Fake jitter","Fake max","Cradle","Shake")local H=ui.new_combobox("LUA","B","Fakewalk mode",{"Opposite","Extend","Jitter"})local I=ui.new_multiselect("LUA","B","| Indicators","Arrows","Watermark")local J,K=ui.new_slider("LUA","B","| Watermark X POS",0,1920,0,true,"px"),ui.new_slider("LUA","B","| Watermark Y POS",0,1080,0,true,"px")local L=ui.new_label("LUA","B","| Real ind color")local M=ui.new_color_picker("LUA","B","| Indicator color",235,146,52,255)local N=ui.new_label("LUA","B","| Fake ind color")local O=ui.new_color_picker("LUA","B","| Fake Indicator color",235,146,52,255)local P=ui.new_label("LUA","B","======= EMIYA AA =======")local Q=ui.reference("AA","Anti-aimbot angles","Yaw Base")local R,S=ui.reference("AA","Anti-aimbot angles","Yaw")local T,U=ui.reference("AA","Anti-aimbot angles","Yaw jitter")local V,W=ui.reference("AA","Anti-aimbot angles","Body Yaw")local X=ui.reference("AA","Anti-aimbot angles","Lower body yaw target")local Y=ui.reference("AA","Anti-aimbot angles","Fake Yaw Limit")local Z=ui.reference("RAGE","Other","Duck Peek Assist")local _=ui.reference("AA","Anti-aimbot angles","Freestanding body yaw")local a0=ui.reference("AA","Fake lag","Limit")local a1=ui.reference("AA","Fake lag","variance")local a2,a3=ui.reference("AA","Other","Slow motion")local a4=ui.reference("AA","Anti-aimbot angles","Fake yaw limit")local a5=ui.reference("AA","Other","On shot anti-aim")local a6=0;local a7,a8=client.screen_size()local a9,aa=a7/2,a8/2-3;local ab=a9-46;local ac=a9+46;local ad=a9;local ae=aa+40;local af={client.screen_size()}local ag={af[1]/2,af[2]/2}local ah="⯇"local ai="⯈"local function aj(ak,al,am,an)local v,w,x;local ao=e(ak*6)local ap=ak*6-ao;local aq=am*(1-al)local ar=am*(1-ap*al)local as=am*(1-(1-ap)*al)ao=ao%6;if ao==0 then v,w,x=am,as,aq elseif ao==1 then v,w,x=ar,am,aq elseif ao==2 then v,w,x=aq,am,as elseif ao==3 then v,w,x=aq,ar,am elseif ao==4 then v,w,x=as,aq,am elseif ao==5 then v,w,x=am,aq,ar end;return v*255,w*255,x*255,an*255 end;local function func_rgb_rainbowize(at,au)local v,w,x,an=aj(d()*at,1,1,1)v=v*au;w=w*au;x=x*au;return v,w,x end;local function av(aw,ax)for ay,az in pairs(aw)do if ax==az then return true end end;return false end;local aA,aB=false,false;local function aC(aD)if aD and not aA then aA=true;return true end;if not aD and aA then aA=false end;return false end;local function aE(aF)if aF and not aB then aB=true;return true end;if not aF and aB then aB=false end;return false end;local function aG()if av(ui.get(I),"Watermark")then ui.set_visible(J,true)ui.set_visible(K,true)else ui.set_visible(J,false)ui.set_visible(K,false)end end;aG()ui.set_callback(I,aG)local function aH()local aI=entity.get_local_player()local aJ=entity.get_prop(aI,"m_flPoseParameter",11)local aK=math.max(-60,math.min(60,aJ*120-60+0.5))local aL=aK/60*100;if aK<0 then aL=-aL end;local aM=string.format('Emiya - Instable: %s%s - dir: %s',string.format("%.f",aL),"%",k(C)and">"or"<")local ak,aN=17,renderer.measure_text(nil,aM)+8;local v,w,x=func_rgb_rainbowize(0.2,1)if not k(C)then renderer.rectangle(ui.get(J),ui.get(K),2,ak,v,w,x,217)renderer.rectangle(aN+ui.get(J),ui.get(K),0,ak,255,135,121,197)else renderer.rectangle(aN+ui.get(J),ui.get(K),0,ak,255,135,121,197)renderer.rectangle(ui.get(J),ui.get(K),2,ak,255,135,121,190)end;renderer.rectangle(ui.get(J)+2,ui.get(K),aN,ak,60,60,60,60)renderer.text(ui.get(J)+5,2+ui.get(K),255,255,255,237,'',0,aM)end;c("paint",function(aO)if not k(A)then return end;if av(k(I),"Watermark")then aH()end;local v,w,x,an=k(M)local aP=1+math.sin(math.abs(-math.pi+globals.curtime()*1/0.5%(math.pi*2)))*237;local aQ,aR,aS,aT=k(O)if av(k(I),"Arrows")then if a6==0 then i(ad,ae,v,w,x,an,"c+",0,"⯆")i(ab,aa,160,160,160,136,"c+",0,ah)i(ac,aa,160,160,160,136,"c+",0,ai)elseif a6<0 then i(ab,aa,v,w,x,an,"c+",0,ah)i(ad,ae,160,160,160,136,"c+",0,"⯆")i(ac,aa,160,160,160,136,"c+",0,ai)elseif a6>0 then i(ad,ae,160,160,160,136,"c+",0,"⯆")i(ab,aa,160,160,160,136,"c+",0,ah)i(ac,aa,v,w,x,an,"c+",0,ai)end;if k(C)then i(ab,aa,aQ,aR,aS,aP,"c+",0,ai)else i(ac,aa,aQ,aR,aS,aP,"c+",0,ah)end end end)r(A,function(aO)c("paint",function(aO)ui.set(F,"On hotkey")ui.set(E,"On hotkey")if aC(k(E))then if a6~=-1 then a6=-1 else a6=0 end end;if aE(k(F))then if a6~=1 then a6=1 else a6=0 end end;if k(A)then if k(B)=="Static"then if k(C)then q(R,"180")q(S,12)q(V,"Static")q(T,"off")q(X,"Eye yaw")q(W,40)else q(S,-15)q(V,"Static")q(T,"off")q(W,-60)q(X,"Eye yaw")end end;if k(B)=="Auto"then q(S,-6)q(R,"180")q(T,"Random")q(V,"Jitter")q(U,14)q(W,12)q(_,true)q(Y,40)q(X,"eye yaw")s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)s(X,false)end;if k(B)=="Manual"then if k(C)then q(S,70)q(R,"180")q(V,"Static")q(T,"off")q(W,-90)else q(S,-85)q(R,"180")q(V,"Static")q(T,"off")q(W,-90)end end;if k(B)=="Experimental"then if k(C)==true then q(S,17)q(R,"180")q(U,32)q(V,"Static")q(T,"Random")q(W,90)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)s(X,false)else q(S,-24)q(R,"180")q(U,-43)q(V,"Static")q(T,"Random")q(W,-90)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)s(X,false)end end;if k(B)=="Experimental 2"then if k(C)then local aU=b(8,18)q(S,10)q(R,"180")q(T,"Offset")q(U,aU)q(V,"Opposite")q(W,60)q(X,"Opposite")q(W,60)q(_,true)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)else local aV=b(-6,-17)q(S,-10)q(R,"180")q(T,"Offset")q(U,aV)q(V,"Jitter")q(W,0)q(X,"Opposite")q(_,true)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)end end;if k(B)=="Test"then if k(C)then local aW=b(6,12)local aW=b(4,14)q(R,"180")q(S,aW)q(T,"Center")q(U,aW)q(V,"Jiiter")q(W,0)q(Y,60)q(_,false)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)else q(R,"180")q(S,-16)q(T,"RANDOM")q(V,"Static")q(W,-105)q(U,-6)q(Y,60)q(_,true)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)end end;if k(D)then if k(C)then q(S,6)q(R,"180")q(T,"Offset")q(U,6)q(V,"Jitter")q(W,95)q(Y,36)q(_,false)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)s(X,false)else q(R,"180")q(S,-16)q(T,"off")q(V,"Static")q(W,-40)q(Y,60)q(_,false)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)s(X,false)end end;if k(Z)then if k(C)then q(S,5)q(R,"180")q(T,"Center")q(U,5)q(V,"Static")q(W,90)q(Y,60)q(_,false)else q(R,"180")q(S,-10)q(T,"off")q(V,"Static")q(W,-105)q(Y,60)q(_,false)end end;if a6<0 then q(S,-80)q(R,"180")q(T,"Center")q(U,5)q(V,"Static")q(W,105)q(Y,60)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)s(X,false)end;if a6>0 then q(S,80)q(R,"180")q(T,"Center")q(U,3)q(V,"Static")q(W,95)q(Y,60)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)s(X,false)end;if not k(A)then return end end end)if not k(A)then q(W,0)q(S,"180")q(V,"Off")q(T,"Off")q(U,0)s(W,false)s(V,false)s(T,false)s(S,false)s(Y,false)s(X,false)end end)c("shutdown",function()q(S,0)q(U,0)q(W,0)end)local aX=0;local aY=0;client.set_event_callback("setup_command",function(aZ)if aZ.chokedcommands==0 then aX=aX+1;aY=aY+1 end;if aY>=ui.get(a0)then aY=0 end;if ui.get(G)=="Fake twist"then if aZ.chokedcommands%(aX%2==0 and ui.get(a0)/2 or 0)==0 then aZ.forwardmove=1.01 end elseif ui.get(G)=="Fake jitter"then if aZ.chokedcommands%2~=0 and aZ.chokedcommands%aY==0 then aZ.forwardmove=1.01 end elseif ui.get(G)=="Fake max"then if aZ.chokedcommands%aY then aZ.forwardmove=1.01 end elseif ui.get(G)=="Cradle"then if aZ.chokedcommands%aY==0 then aZ.forwardmove=1.01 end elseif ui.get(G)=="Shake"then if aZ.chokedcommands%3==0 or aZ.chokedcommands%aY/2==0 then aZ.forwardmove=1.01 end end end)local c,a_,b0,b1,b2,b3,b4,b5,e,b6,f,b7,k,m,p,q,s=client.set_event_callback,entity.get_local_player,entity.get_player_weapon,entity.get_prop,math.abs,math.atan2,math.ceil,math.cos,math.floor,math.max,math.sin,math.sqrt,ui.get,ui.new_combobox,ui.reference,ui.set,ui.set_visible;local Y=p("AA","Fake lag","Limit")local a1=p("AA","Fake lag","Variance")local a2,a3=p("AA","Other","Slow motion")local a4=p("AA","Anti-aimbot angles","Fake yaw limit")local a5=p("AA","Other","On shot anti-aim")local b8=p("Misc","Movement","Fast walk")local H=m("LUA","B","Fakewalk mode",{"Opposite","Extend","Jitter"})local function b9(a7,a8,ba)return{x=a7 or 0,y=a8 or 0,z=ba or 0}end;local function bb(bc)return bc*math.pi/180.end;local function bd(be,bf)if be.x==0 and be.y==0 then if be.z>0 then bf.x=-90 else bf.x=90 end;bf.y=0 else bf.x=b3(-be.z,b7(be.x*be.x+be.y*be.y))*180/math.pi;bf.y=b3(be.y,be.x)*180/math.pi end;bf.z=0 end;local function bg(bf,be)local bh=f(bb(bf.x))local bi=b5(bb(bf.x))local bj=f(bb(bf.y))local bk=b5(bb(bf.y))be.x=bi*bk;be.y=bi*bj;be.z=-bh end;function round(a9)return a9>=0 and e(a9+0.5)or b4(a9-0.5)end;local function bl(R)if R>180 or R<-180 then local bm=round(b2(R/360))if R<0 then R=R+360*bm else R=R-360*bm end end;return R end;local function bn(aZ)local bo=b9(b1(a_(),"m_vecVelocity"))local bp=b7(bo.x*bo.x+bo.y*bo.y)local bq=b9(0,0,0)bd(bo,bq)bq.y=aZ.yaw-bq.y;local br=b9(0,0,0)bg(bq,br)local bs=b6(b2(aZ.forwardmove),b2(aZ.sidemove))local bt=450/bs;br=b9(br.x*-bt,br.y*-bt,br.z*-bt)end;local bu=0;local bv=""local function bw()local bx=b0(a_())local by=b1(a_(),"m_bIsScoped")if bv=="deagle"or bv=="aug"and by==1 then return 10 end;if bv=="negev"or bv=="sg556"and by==1 then return 9 end;return 8 end;local bz=false;local bA=k(a5)local bB=k(Y)local bC=k(a1)local bD=k(b8)local bE=0;c("setup_command",function(aZ)if k(a2)then return end;if not k(a3)then if bz and bB>0 then q(a5,bA)q(Y,bB)q(a1,bC)q(b8,bD)end;bA=k(a5)bB=k(Y)bC=k(a1)bD=k(b8)bz=false;return end;local bF=b9(b1(a_(),"m_angEyeAngles"))local bG=b9(b1(a_(),"m_angAbsRotation"))local bH=bl(bG.y-bF.y)>0 and-1 or 1;local bo=b9(b1(a_(),"m_vecVelocity"))local bp=b7(bo.x*bo.x+bo.y*bo.y)bz=true;q(b8,true)local bI=bw()if aZ.chokedcommands>=k(Y)-bI then if aZ.forwardmove~=0 or aZ.sidemove~=0 then bn(aZ)end end;if aZ.chokedcommands==k(Y)-7 then if bp<=0 then aZ.forwardmove=-1.01 end;bE=bE+1;if k(H)=="Opposite"then aZ.yaw=bl(bF.y+40*bH)elseif k(H)=="Extend"then aZ.yaw=bl(bF.y+90*bH)elseif k(H)=="Jitter"then aZ.yaw=bl(bF.y+22*(bE%2==0 and-1 or 1))end end end)c("item_equip",function(bJ)bv=bJ.item;bu=bJ.weptype end)c("pre_render",function()s(H,not k(a2)and true or false)end)local function aj(ak,al,am,an)local v,w,x;local ao=math.floor(ak*6)local ap=ak*6-ao;local aq=am*(1-al)local ar=am*(1-ap*al)local as=am*(1-(1-ap)*al)ao=ao%6;if ao==0 then v,w,x=am,as,aq elseif ao==1 then v,w,x=ar,am,aq elseif ao==2 then v,w,x=aq,am,as elseif ao==3 then v,w,x=aq,ar,am elseif ao==4 then v,w,x=as,aq,am elseif ao==5 then v,w,x=am,aq,ar end;return v*255,w*255,x*255,an*255 end;local function func_rgb_rainbowize(at,au)local v,w,x,an=aj(globals.realtime()*at,1,1,1)v=v*au;w=w*au;x=x*au;return v,w,x end;local function u()local v,w,x=func_rgb_rainbowize(1,1)local y=[[
        ______            _____          _
        | ___ \          |  ___|        (_)
        | |_/ /_   _     | |__ _ __ ___  _ _   _  __ _
        | ___ \ | | |    |  __| '_ ` _ \| | | | |/ _` |
        | |_/ / |_| |    | |__| | | | | | | |_| | (_| |
        \____/ \__, |    \____/_| |_| |_|_|\__, |\__,_|
                __/ |                       __/ |
               |___/                       |___/
       ]]client.color_log(37,160,247,"------------------------------------------------------------")client.color_log(37,160,247,y)client.color_log(37,160,247,"------------------------------------------------------------")end;u()local bK=0;client.set_event_callback("paint",function(bL)local v,w,x=func_rgb_rainbowize(0.35,1)renderer.text(0,0,v,w,x,255,nil,0,"| EMIYA ANTIAIM EAGLE PRO")end)