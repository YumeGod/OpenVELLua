local limtzuida = 0

local a, b, c, d, e, f, g, h, i, j =
    client.latency,
    client.log,
    client.draw_rectangle,
    client.draw_circle_outline,
    client.userid_to_entindex,
    client.draw_indicator,
    client.draw_gradient,
    client.set_event_callback,
    client.screen_size,
    client.eye_position
local k, l, m, n, o, p, q, r =
    client.draw_circle,
    client.color_log,
    client.delay_call,
    client.draw_text,
    client.visible,
    client.exec,
    client.trace_line,
    client.set_cvar
local s, t, u, v, w, x, y, z =
    client.world_to_screen,
    client.draw_hitboxes,
    client.get_cvar,
    client.draw_line,
    client.camera_angles,
    client.draw_debug_text,
    client.random_int,
    client.random_float
local A, B, C, D, E, F, G, H =
    entity.get_local_player,
    entity.is_enemy,
    entity.get_player_name,
    entity.get_steam64,
    entity.get_bounding_box,
    entity.get_all,
    entity.set_prop,
    entity.get_player_weapon
local I, J, K, L = entity.hitbox_position, entity.get_prop, entity.get_players, entity.get_classname
local M, N, O, P, Q, R, S, T, U =
    globals.realtime,
    globals.absoluteframetime,
    globals.tickcount,
    globals.curtime,
    globals.mapname,
    globals.tickinterval,
    globals.framecount,
    globals.frametime,
    globals.maxplayers
local V, W, X, Y, Z, _, a0, a1, a2, a3, a4, a5, a6 =
    ui.new_slider,
    ui.new_combobox,
    ui.reference,
    ui.set_visible,
    ui.is_menu_open,
    ui.new_color_picker,
    ui.set_callback,
    ui.set,
    ui.new_checkbox,
    ui.new_hotkey,
    ui.new_button,
    ui.new_multiselect,
    ui.get
local a7, a8, a9, aa, ab, ac, ad, ae, af, ag, ah, ai, aj, ak, al, am, an =
    math.ceil,
    math.tan,
    math.log10,
    math.randomseed,
    math.cos,
    math.sinh,
    math.random,
    math.huge,
    math.pi,
    math.max,
    math.atan2,
    math.ldexp,
    math.floor,
    math.sqrt,
    math.deg,
    math.atan,
    math.fmod
local ao, ap, aq, ar, as, at, au, av, aw, ax, ay, az, aA =
    math.acos,
    math.pow,
    math.abs,
    math.min,
    math.sin,
    math.frexp,
    math.log,
    math.tanh,
    math.exp,
    math.modf,
    math.cosh,
    math.asin,
    math.rad
local aB, aC, aD, aE, aF, aG, aH, aI, aJ =
    table.maxn,
    table.foreach,
    table.sort,
    table.remove,
    table.foreachi,
    table.move,
    table.getn,
    table.concat,
    table.insert
local aK, aL, aM, aN, aO, aP, aQ, aR, aS, aT, aU, aV, aW, aX =
    string.find,
    string.format,
    string.rep,
    string.gsub,
    string.len,
    string.gmatch,
    string.dump,
    string.match,
    string.reverse,
    string.byte,
    string.char,
    string.upper,
    string.lower,
    string.sub
local aY = 0
local aZ = 0
local a_ = 0
local function b0(b1)
    aY = 0
    aZ = 0
    a_ = 0
end
ui.new_button("rage", "Other", "Reset misses", b0)
local function b2(b3)
    aY = aY + 1
end
local function b4(b3)
    aZ = aZ + 1
end
local function b5(b3)
    if b3.reason == "spread" then
        a_ = a_ + 1
        aZ = aZ - 1
    end
    if b3.reason == "death" then
        aZ = aZ - 1
    end
    if b3.reason == "prediction error" then
        aZ = aZ - 1
    end
end
local a6 = ui.get
local b6 = ui.new_combobox
local b7 = ui.new_checkbox
local b8 = ui.new_slider
local b9 = ui.set_visible
local ba = entity.get_local_player
local J = entity.get_prop
local bb = client.draw_circle_outline
local bc = client.draw_indicator
local n = client.draw_text
local bd = client.set_event_callback
local be = ui.set_callback
local limit_ref = ui.reference("AA","Fake lag","Limit")
local bf = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local bg = ui.reference("RAGE", "Other", "Duck peek assist")
local bh, bi = ui.reference("RAGE", "Other", "Double tap")
local bj = b7("aa", "Fake lag", "Fake lag indicator")
local bk = ui.new_color_picker("aa", "Fake lag", "Desync color", "0", "115", "255", "255")
local bl = b7("aa", "Fake lag", "Detailed log")
ui.set_visible(bl,false)
ui.set(bl,true)
local bm = b7("aa", "Fake lag", "Show LC threshold")
local bn = ui.new_color_picker("aa", "Fake lag", "LC color", "187", "128", "255", "255")
local bo = (function()
    local bp = {}
    local bq, br, bs, b3, bt, bu, bv, bw, bx, by, bz, bA, bB, bC
    local bD = {__index = {drag = function(self, ...)
                local bE, bF = self:get()
                local bG, bH = bp.drag(bE, bF, ...)
                if bE ~= bG or bF ~= bH then
                    self:set(bG, bH)
                end
                return bG, bH
            end, set = function(self, bE, bF)
                local bx, by = client.screen_size()
                ui.set(self.x_reference, bE / bx * self.res)
                ui.set(self.y_reference, bF / by * self.res)
            end, get = function(self)
                local bx, by = client.screen_size()
                return ui.get(self.x_reference) / self.res * bx, ui.get(self.y_reference) / self.res * by
            end}}
    function bp.new(bI, bJ, bK, bL)
        bL = bL or 10000
        local bx, by = client.screen_size()
        local bM = ui.new_slider("AA", "Fake lag", bI .. " pos", 0, bL, bJ / bx * bL)
        local bN = ui.new_slider("AA", "Fake lag", "\n" .. bI .. " pos 2", 0, bL, bK / by * bL)
        ui.set_visible(bM, false)
        ui.set_visible(bN, false)
        return setmetatable({name = bI, x_reference = bM, y_reference = bN, res = bL}, bD)
    end
    function bp.drag(bE, bF, bO, bP, bQ, bR, bS)
        if globals.framecount() ~= bq then
            br = ui.is_menu_open()
            bt, bu = bs, b3
            bs, b3 = ui.mouse_position()
            bw = bv
            bv = client.key_state(0x01) == true
            bA = bz
            bz = {}
            bC = bB
            bB = false
            bx, by = client.screen_size()
        end
        if br and bw ~= nil then
            if (not bw or bC) and bv and bt > bE and bu > bF and bt < bE + bO and bu < bF + bP then
                bB = true
                bE, bF = bE + bs - bt, bF + b3 - bu
                if not bR then
                    bE = math.max(0, math.min(bx - bO, bE))
                    bF = math.max(0, math.min(by - bP, bF))
                end
            end
        end
        table.insert(bz, {bE, bF, bO, bP})
        return bE, bF, bO, bP
    end
    return bp
end)()
local bT = bo.new("Ind", 100, 200)
local bU = b6("aa", "Fake lag", "Visual text indicator", {"Pulsating", "Static"})
local bV = b8("aa", "Fake lag", "Static alpha threshold", 1, 255, 255, true)
local bW = 0
local bX, bY, bZ, b_ = 0, 0, 0, 0
local c0 = 0
local c1, c2 = 0, 0
local c3 = 14
local c4, c5, c6 = 0, 0, 0
local c7 = ""
local c8, c9, ca = 0, 0, 0
local cb, cc = {}, true
local function cd(ce)
    if not a6(bj) then
        return
    end
    local cf = entity.get_local_player()
    if cf ~= nil and ce.chokedcommands == 0 then
        local bL, bM, bN = entity.get_prop(cf, "m_vecOrigin")
        cb[cc and 0 or 1] = {bL, bM}
        cc = not cc
    end
    c4 = ce.chokedcommands
    c1 = math.max(unpack({bX, bY, bZ, b_}))
    c2 = math.min(unpack({bX, bY, bZ, b_}))
    if ui.get(limit_ref) <= 15 and (a6(bf) - 2) > 17 then
        limtzuida = 15
    else
        limtzuida = (a6(bf) - 2)
    end
    c3 = limtzuida
    c0 = c1 - c2
    c5 = bX + bY + bZ + b_
    c6 = 3 * 0.25 + c1 / c5
    if not a6(bg) then
        --if not a6(bi) then
            if c1 <= 14 then
                if c1 >= 0 and c1 <= 2 then
                    if not a6(bi) then
                        c7 = "INACTIVE"
                    else
                        c7 = "DOUBLE TAP"
                    end
                elseif c1 >= 3 and c1 <= 3 then
                    c7 = "LOW"
                elseif c1 <= 9 and c0 <= 2 then
                    c7 = "NOMINAL"
                elseif c1 >= 10 and c0 <= 2 then
                    if c1 >= 13 and c1 <= 14 and bW >= 13 then
                        c7 = "MAXIMIZED"
                    elseif c1 >= 10 and c1 <= 12 then
                        c7 = "MAX-MINIMAL"
                    end
                elseif c0 >= 2 and c1 >= 5 then
                    if c0 >= 9 and c0 <= 10 then
                        c7 = "FLUCTUATED"
                    elseif c0 >= 11 and c0 <= 13 and c6 < 1.29 then
                        c7 = "FLUCTUATED-MAX"
                        c8, c9, ca = 123, 180, 15
                    elseif c0 >= 13 and c6 > 1.29 then
                        c7 = "BREAK"
                    elseif c0 >= 3 and c0 <= 8 then
                        c7 = "FLUCTUATED-MIN"
                    end
                end
            elseif c1 >= 15 then
                if c6 > 1.12 then
                    c7 = "BREAK-EXPLOIT"
                elseif c6 < 1.12 then
                    c7 = "OVERFLOW"
                end
            end
        --else
            --c7 = "DOUBLE TAP"
        --end
    else
        --if a6(bi) then
            --c7 = "FAKEDUCK  (DT)"
        --else
            c7 = "FAKEDUCK"
        --end
    end
end
function Length2DSqr(cg)
    return cg[1] * cg[1] + cg[2] * cg[2]
end
function vecMvec(cg, ch)
    return {cg[1] - ch[1], cg[2] - ch[2]}
end
function ro(ci, bB)
    return math.floor(ci * 10 ^ (bB or 0) + 0.5) / 10 ^ (bB or 0)
end
function get_player_velocity(cj)
    local ck = entity.get_prop(cj, "m_vecVelocity[0]")
    local cl = entity.get_prop(cj, "m_vecVelocity[1]")
    return math.floor(math.min(10000, math.sqrt(ck * ck + cl * cl) + 0.5))
end
local cm = 0
local cn = false
local co = 0
local function cp()
    if not a6(bm) or not a6(bj) then
        co = 0
        return
    end
    local cf = entity.get_local_player()
    if cf == nil or not entity.is_alive(cf) then
        return
    end
    if cb[0] and cb[1] then
        local cq = get_player_velocity(cf) > 280
        local cr = Length2DSqr(vecMvec(cb[0], cb[1]))
        cr = cr - 64 * 64
        cr = cr < 0 and 0 or cr / 30
        cr = cr > 62 and 62 or cr
        cm = cr
        co = 3
    end
end
local function cs(br)
    if c4 <= bW then
        bX = bY
        bY = bZ
        bZ = b_
        b_ = bW
    end
    bW = c4
end
local ct = client.userid_to_entindex
local function cu(cv)
    if not a6(bj) then
        return
    end
    local cw = cv.entityid
    if cw == nil then
        return
    end
end
local function cx(cv)
    if not a6(bj) then
        return
    end
    if ct(cv.userid) == ba() then
        c7 = "INACTIVE"
        bW = 0
        bX = 0
        bY = 0
        bZ = 0
        b_ = 0
    end
end
local cy = 0
local cz = ""
local cA, cB, cC, cD = "", "", "", ""
local cE = ""
local cF = ""
local cG = ""
local bL, bM = client.screen_size()
local cH, cI = bL * 0, 5, bM * 0, 5
local cJ = 0
local cK = 17
local function cL(cM)
    if a6(bU) ~= "Static" or not a6(bj) then
        ui.set_visible(bV, false)
    elseif a6(bU) == "Static" then
        ui.set_visible(bV, true)
    end
    if not a6(bj) then
        return
    end
    if J(ba(), "m_lifeState") ~= 0 then
        return
    end
    if c7 == "LOW" then
        c8, c9, ca = 255, 0, 0
    elseif c7 == "UPDATING..." then
        c8, c9, ca = 230, 161, 0
    elseif c7 == "INACTIVE" then
        c8, c9, ca = 255, 0, 0
    elseif c7 == "DOUBLE TAP" then
        c8, c9, ca = 187, 128, 255
    elseif c7 == "FAKEDUCK" or c7 == "FAKEDUCK  (DT)" then
        c8, c9, ca = 187, 128, 255
    elseif c7 == "FLUCTUATED" then
        c8, c9, ca = 123, 194, 21
    elseif c7 == "FLUCTUATED-MAX" then
        c8, c9, ca = 123, 180, 15
    elseif c7 == "FLUCTUATED-MIN" then
        c8, c9, ca = 123, 180, 15
    elseif c7 == "F-LOW" then
        c8, c9, ca = 123, 180, 15
    elseif c7 == "BREAK" then
        c8, c9, ca = 212, 86, 251
    elseif c7 == "MAXIMIZED" then
        c8, c9, ca = 20, 142, 255
    elseif c7 == "MAX-MINIMAL" then
        c8, c9, ca = 20, 142, 255
    elseif c7 == "NOMINAL" then
        c8, c9, ca = 123, 180, 15
    elseif c7 == "OVERFLOW" then
        c8, c9, ca = 255, 50, 0
    elseif c7 == "BREAK-EXPLOIT" then
        c8, c9, ca = 168, 0, 230
    end
    local bF, bu, bq, bp = a6(bk)
    local cN, cO, cP, cQ = a6(bn)
    local cR = 1
    local cS = 8 + math.sin(math.abs(-math.pi + globals.realtime() * 0.6 / 1 % (math.pi * 2))) * 12
    local cT = 1 + math.sin(math.abs(-math.pi + globals.realtime() % (math.pi * 2))) * 219
    local cU, cV, cW, cX =
        math.min(255, bF + cR),
        math.min(255, bu + cR),
        math.min(255, bq + cR),
        math.min(255, bp + cR)
    local cY, cZ = bT:get()
    local bv, bK = 45, 200
    client.draw_gradient(cM, cY, cZ - 2, 40 + cS * 5, 2, cU, cV, cW, 255, 25, 25, 25, 5, true)
    client.draw_gradient(cM, cY, cZ, cS, bv + cK, cU, cV, cW, 255, 25, 25, 25, 5, true)
    client.draw_gradient(cM, cY + 5, cZ, bK, 16, 0, 0, 0, 255, 10, 10, 10, 30, true)
    client.draw_gradient(cM, cY + 5, cZ + cK + co +7, bK, 38, 0, 0, 0, 255, 10, 10, 10, 30, true)
    client.draw_gradient(cM, cY + 5, cZ + 14, bK / c3 * c4, 3, 20, 20, 20, 255, cU, cV, cW, 180, true)
    if co > 1 then
        client.draw_gradient(cM, cY + 5, cZ + 17, bK / 64 * math.floor(cm), 3, 20, 20, 20, 255, cN, cO, cP, cQ, true)
    end
    client.draw_gradient(cM, cY, cZ, bK, bv + cK + co, 30, 30, 30, 200, 10, 10, 10, 10, true)
    client.draw_gradient(cM, cY, cZ + co + bv + cK, 120 + cS * 3, 2, cU, cV, cW, 255, 25, 25, 25, 20, true)
    client.draw_gradient(cM, cY, cZ - 1, cS, 1 + bv + cK + co, cU, cV, cW, 255, 25, 25, 25, 5, true)
    renderer.text(cY + 8, cZ + 2, 187, 128, 255, 255, "", 0, "FAKE LAG")
    renderer.text(cY + 60, cZ + 2, c8, c9, ca, a6(bU) == "Pulsating" and cT or a6(bV), "", 0, c7)
    renderer.text(cY + 158, cZ + 2, 128, 183, 255, 255, "", 0, "Hitler")
    if a6(bl) then
        cA, cB, cC, cD = " M: ", c1, "  F: ", c0
        bT:drag(bK, bv * 2)
        cK = 9
        renderer.text(cY + 8, cZ + co + 20, 187, 128, 255, 255, "", 0, "HISTORY:")
        renderer.text(cY + 60, cZ + co + 20, 255, 255, 255, 255, "", 0, string.format("%i-%i-%i-%i", b_, bZ, bY, bX))
        renderer.text(cY + 135, cZ + co + 20, 128, 183, 255, 255, "", 0, cA)
        renderer.text(cY + 150, cZ + co + 20, 128, 183, 255, 255, "", 0, cB)
        renderer.text(cY + 165, cZ + co + 20, 128, 183, 255, 255, "", 0, cC)
        renderer.text(cY + 180, cZ + co + 20, 128, 183, 255, 255, "", 0, cD)
        local c_ = aZ - aY
        local d0 = aY / aZ * 100
        if aY == 0 or aZ == 0 then
            d0 = 0
        end
        renderer.text(cY + 8, cZ + co + 20 + 18, 128, 183, 255, 255, "", 0, "HITS:")
        renderer.text(cY + 8 + 28, cZ + co + 20 + 18, 0, 255, 183, 255, "", 0, aY)
        renderer.text(cY + 8 + 48, cZ + co + 20 + 18, 128, 183, 255, 255, "", 0, "MISSES:")
        renderer.text(cY + 8 + 45 + 46, cZ + co + 20 + 18, 255, 0, 0, 255, "", 0, c_)
        renderer.text(cY + 8 + 45 + 65, cZ + co + 20 + 18, 128, 183, 255, 255, "", 0, "PERCENT:")
        renderer.text(cY + 8 + 45 + 65 + 50, cZ + co + 20 + 18, 255, 255, 0, 255, "", 0, math.floor(d0) .. "%")
    else
        cA, cB, cC, cD = "", "", "", ""
        cK = 0
        bT:drag(bK, bv * 1.1)
    end
end
bd("run_command", cd)
bd("run_command", cp)
bd("setup_command", cs)
bd("run_command", cu)
bd("player_spawn", cx)
bd("paint", cL)
h("aim_fire", b4)
h("aim_hit", b2)
h("aim_miss", b5)
local function d1()
    local d2 = a6(bj)
    ui.set_visible(bk, d2)
    ui.set_visible(bU, d2)
    ui.set_visible(bV, d2)
    --ui.set_visible(bl, d2)
    ui.set_visible(bm, d2)
    ui.set_visible(bn, d2)
end
d1()
be(bj, d1)