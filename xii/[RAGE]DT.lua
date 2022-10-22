client.color_log(37, 160, 247, "--------XII DT Script IS LOADED-------")

client.color_log(37, 160, 247, "--------XII DT Script IS LOADED-------")
local name="XII SCRIPT v1.2"
local clr_label = ui.new_label("CONFIG", "Presets", "Double tap indicator")
local color = ui.new_color_picker("CONFIG", "Presets", "Double tap clr", 4, 255, 255, 255)
local a_stored = 240
local a2_stored = 240
local a1 = 120
local ref_doubletap = { ui.reference("RAGE", "Other", "Double Tap") }
local double_tap_mode = ui.reference("RAGE", "Other", "Double tap mode")
local double_tap_hitchance = ui.reference("RAGE", "Other", "Double tap hit chance")
local double_tap_fake_lag_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit")
local fake_lag = ui.reference("AA", "Fake lag", "Limit")
local sv_maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")

local increase_speed = ui.new_checkbox("LUA", "B", "Doubletap Script")
local increase_speed_mode = ui.new_combobox("LUA", "B", "Dt Modes", {"Faster DT", "Experimental DT"})
local last_charge = 0
local tickMode = 0

local function visbilityshit(state)
  ui.set_visible(sv_maxusrcmdprocessticks, state)
end

visbilityshit(true)

local function image_stuff()
  local M = {}
  local renderer_load_svg, renderer_texture, math_floor = renderer.load_svg, renderer.texture, math.floor
  local image_class = {}
  local image_mt = {
    __index = image_class
  }
  local cache = {}
  function image_class:measure(width, height)
    if width == nil and height == nil then
      return self.width, self.height
     elseif width == nil then
      height = height or self.height
      local width = math_floor(self.width * (height/self.height))
      return width, height
     elseif height == nil then
      width = width or self.width
      local height = math_floor(self.height * (width/self.width))
      return width, height
     else
      return width, height
    end
  end

  function image_class:draw(x, y, width, height, r, g, b, a, force_same_res_render)
    local width, height = self:measure(width, height)
    local id = width .. "_" .. height
    local texture = self.textures[id]
    if texture == nil then
      if ({next(self.textures)})[2] == nil or force_same_res_render then
        texture = renderer_load_svg(self.svg, width, height)
        if texture == nil then
          self.textures[id] = -1
         else
          self.textures[id] = texture
        end
       else
        texture = ({next(self.textures)})[2]
      end
    end
    if texture == nil or texture == -1 then
      return
    end
    if a > 0 then
      renderer_texture(texture, x, y, width, height, r, g, b, a)
    end
    return width, height
  end

  function M.load(data)
    local result = {}
    if cache[data] == nil then
      local header = data[-1]
      for image_name, image_data in pairs(data) do
        if image_name ~= -1 then
          local image = setmetatable({}, image_mt)
          image.name = image_name
          image.width = image_data[1]
          image.height = image_data[2]
          image.svg = image_data[3]
          if header ~= nil and image.svg:sub(0, 5) ~= "<?xml" then
            image.svg = header .. image.svg
          end
          image.textures = {}
          result[image_name] = image
        end
      end
      cache[data] = result
     else
      result = cache[data]
    end
    return result
  end
  return M
end

local http = require "gamesense/http"
http.get("http://download.b3hy.pro/svg_icon", function(success, response)
  if not success or response.status ~= 200 then
    return
  end
  local images_lib = image_stuff()
  local images_icons = images_lib.load(loadstring(response.body)())

  local function is_inside(a, b, x, y, w, h)
    return a >= x and a <= w and b >= y and b <= h
  end
  _,height = client.screen_size()
  local pos = {20 ,height/2}
  local tX, tY = pos[1], pos[2]
  local oX, oY, _d
  local drag_menu = function(x, y, w, h)
    if not ui.is_menu_open() then
      return tX, tY
    end
    local mouse_down = client.key_state(0x01)
    if mouse_down then
      local X, Y = ui.mouse_position()
      if not _d then
        local w, h = x + w, y + h
        if is_inside(X, Y, x, y, w, h) then
          oX, oY, _d = X - x, Y - y, true
        end
       else
        tX, tY = X - oX, Y - oY
      end
     else
      _d = false
    end
    return tX, tY
  end

  local weapon_names = {
    [1] = "weapon_deagle",
    [2] = "weapon_elite",
    [3] = "weapon_fiveseven",
    [4] = "weapon_glock",
    [7] = "weapon_ak47",
    [8] = "weapon_aug",
    [9] = "weapon_awp",
    [10] = "weapon_famas",
    [11] = "weapon_g3sg1",
    [13] = "weapon_galilar",
    [14] = "weapon_m249",
    [16] = "weapon_m4a1",
    [17] = "weapon_mac10",
    [19] = "weapon_p90",
    [23] = "weapon_mp5sd",
    [24] = "weapon_ump45",
    [25] = "weapon_xm1014",
    [26] = "weapon_bizon",
    [27] = "weapon_mag7",
    [28] = "weapon_negev",
    [29] = "weapon_sawedoff",
    [30] = "weapon_tec9",
    [31] = "weapon_taser",
    [32] = "weapon_hkp2000",
    [33] = "weapon_mp7",
    [34] = "weapon_mp9",
    [35] = "weapon_nova",
    [36] = "weapon_p250",
    [38] = "weapon_scar20",
    [39] = "weapon_sg556",
    [40] = "weapon_ssg08",
    [41] = "weapon_knifegg",
    [42] = "weapon_knife",
    [43] = "weapon_flashbang",
    [44] = "weapon_hegrenade",
    [45] = "weapon_smokegrenade",
    [46] = "weapon_molotov",
    [47] = "weapon_decoy",
    [48] = "weapon_incgrenade",
    [49] = "weapon_c4",
    [50] = "item_kevlar",
    [51] = "item_assaultsuit",
    [52] = "item_heavyassaultsuit",
    [55] = "item_defuser",
    [56] = "item_cutters",
    [57] = "weapon_healthshot",
    [59] = "weapon_knife_t",
    [60] = "weapon_m4a1_silencer",
    [61] = "weapon_usp_silencer",
    [63] = "weapon_cz75a",
    [64] = "weapon_revolver",
    [68] = "weapon_tagrenade",
    [69] = "weapon_fists",
    [70] = "weapon_breachcharge",
    [72] = "weapon_tablet",
    [74] = "weapon_melee",
    [75] = "weapon_axe",
    [76] = "weapon_hammer",
    [78] = "weapon_spanner",
    [80] = "weapon_knife_ghost",
    [81] = "weapon_firebomb",
    [82] = "weapon_diversion",
    [83] = "weapon_frag_grenade",
    [84] = "weapon_snowball",
    [512] = "weapon_knife_falchion",
    [514] = "weapon_knife_survival_bowie",
    [515] = "weapon_knife_butterfly",
    [516] = "weapon_knife_push",
    [503] = "weapon_knifegg",
    [522] = "weapon_knife_stiletto",
    [519] = "weapon_knife_ursus",
    [520] = "weapon_knife_gypsy_jackknife",
    [505] = "weapon_knife_flip",
    [506] = "weapon_knife_gut",
    [507] = "weapon_knife_karambit",
    [508] = "weapon_knife_m9_bayonet",
    [509] = "weapon_knife_tactical",
    [500] = "weapon_bayonet",
    [523] = "weapon_knife_widowmaker"
  }

  local function is_dt()
    local dt = false
    local local_player = entity.get_local_player()
    local scoped = entity.get_prop(local_player, "m_bIsScoped")
    if local_player == nil then
      return
    end
    if not entity.is_alive(local_player) then
      return
    end
    local active_weapon = entity.get_prop(local_player, "m_hActiveWeapon")
    if active_weapon == nil then
      return
    end
    nextAttack = entity.get_prop(local_player,"m_flNextAttack")
    nextShot = entity.get_prop(active_weapon,"m_flNextPrimaryAttack")
    nextShotSecondary = entity.get_prop(active_weapon,"m_flNextSecondaryAttack")
    if nextAttack == nil or nextShot == nil or nextShotSecondary == nil then
      return
    end
    nextAttack = nextAttack + 0.3
    nextShot = nextShot + 0.5
    nextShotSecondary = nextShotSecondary + 0.5
    if ui.get(ref_doubletap[1]) and ui.get(ref_doubletap[2]) then
      if math.max(nextShot,nextShotSecondary) < nextAttack then
        if nextAttack - globals.curtime() > 0.00 then
          dt = false
         else
          dt = true
        end
       else
        if (nextShot) - globals.curtime() > 0.00 then
          dt = false
         else
          if (nextShot) - globals.curtime() < 0.00 then
            dt = true
           else
            dt = true
          end
        end
      end
    end
    return dt
  end

  local function fast_dt()
    ui.set(fake_lag, math.min(14, ui.get(fake_lag)))

    if ui.get(increase_speed) then
      ui.set(ref_doubletap[1], true)
      ui.set(double_tap_fake_lag_limit, 1)
      ui.set(double_tap_mode, "Offensive")

      if ui.get(increase_speed_mode) == "Experimental DT" then
        ui.set(sv_maxusrcmdprocessticks, 20)
        ui.set(double_tap_hitchance, 10)
        cvar.cl_clock_correction:set_int(1)
        tickMode = 20
        return
      end
    end

    ui.set(sv_maxusrcmdprocessticks, 16)
    tickMode = 15
    cvar.cl_clock_correction:set_int(0)
  end

  local g_paint_handler = function()
    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)

    local weapons = {
      shots_4 = {
        mp9 = 34,
        mp7 = 33,
        mac10 = 17,
        mp5 = 23,
      },
      shots_1 = {
        ssg08 = 40,
        awp = 9,
      },
      shots_2 = {
        scar = 38,
        g3sg1 = 11,
        deagle = 1,
        glock = 4,
        p250 = 36,
        usp = 61,
      },
      shots_3 = {
        dual = 2,
        fiveseven = 3,
        ak47 = 7,
        aug = 8,
        famas = 10,
        m4a4 = 16,
        cz75 = 63,
      },
      knife_d = {
        knife1 = 41,
        knife2 = 42,
        flash = 43,
        f2 = 44,
        f3 = 45,
        f4 = 46,
        f5 = 47,
        f6 = 48,
        f7 = 81,
        f8 = 82,
        f9 = 83,
        k506 = 506,
        k507 = 507,
        k508 = 508,
        k509 = 509,
        k510 = 510,
        k511 = 511,
        k512 = 512,
        k513 = 513,
        k514 = 514,
        k515 = 515,
        k516 = 516,
        k517 = 517,
        k525 = 525,
      }
    }

    local function contains(list, data)
      for i, v in pairs(list) do
        if(v == data) then return true end
      end

      return false
    end

    local wpn_id = entity.get_prop(wpn, 'm_iItemDefinitionIndex')
    local m_item = wpn_id and bit.band(wpn_id, 0xFFFF) or 0
    local wpn_name = weapon_names[m_item] or ''
    if wpn_name == '' then
      return
    end

    local text1 = "0"
    local r, g, b, a = ui.get(color)
    if not (ui.get(ref_doubletap[1]) and ui.get(ref_doubletap[2])) or entity.get_prop(entity.get_local_player(), "m_bIsValveDS") == 1 then
      return
    end

    if not is_dt() then
      r, g, b = 150, 150, 150
      a_stored = a_stored - 2.6
      a2_stored = a2_stored - 2.6
      last_charge = 0
      if a_stored < 46 then
        a_stored = 46
      end
     else
      if a_stored < a then
        if a_stored < 30 or a2_stored < 0 then
          a_stored = 46
          a2_stored = 0
        end
        a_stored = a_stored + 2.6
        a2_stored = a2_stored + 2.6
        last_charge = tickMode
      end
      if last_charge == 0 then
        text1 = '0'
       else
        text1 = last_charge
      end
      local _, _, _, a = ui.get(color)
    end

    local text = string.format('DT [%s] | tickbase(⚡︎): %s', name, text1)
    local h, w = 17, renderer.measure_text(nil, text) + 8
    local x, y = drag_menu(tX, tY, w, h)

    local a2 = a2_stored
    local a1 = a2_stored

    renderer.rectangle(x - 1, y - 2, w + 1, 2, r, g, b, a)
    renderer.rectangle(x-1, y, w+1, h, 0, 0, 0, 0)
    renderer.text(x+4, y + 2, 255, 255, 255, 255, '', 0, text)

    local stripped = wpn_name:gsub("weapon_", ""):gsub("item_", "")

    images_icons[stripped]:draw(x, y + h + 6, nil, 16, 255, 255, 255, 255)
    local width = images_icons[stripped]:measure()
    local widthb = images_icons["icon_headshot"]:measure()

    if contains(weapons.shots_2, wpn_id) then
      images_icons["bullet"]:draw(x + width / 2 + 7, y + h + 7, nil, 16, 255, 255, 255, a2)
      images_icons["bullet"]:draw(x + width / 2 + widthb / 2 + 10, y + h + 7, nil, 16, 255, 255, 255, a2)
     elseif contains(weapons.shots_1, wpn_id) then
      images_icons["icon_headshot"]:draw(x + width / 2 + 7, y + h + 7, nil, 16, 255, 255, 255, a2)
     elseif contains(weapons.shots_3, wpn_id) then
      images_icons["bullet"]:draw(x + width / 2 + 7, y + h + 7, nil, 16, 255, 255, 255, a2)
      images_icons["bullet"]:draw(x + width / 2 + widthb / 2 + 10, y + h + 7, nil, 16, 255, 255, 255, a2)
      images_icons["bullet"]:draw(x + width / 2 + widthb / 2 + 10 + widthb / 2, y + h + 7, nil, 16, 255, 255, 255, a2)
     elseif contains(weapons.shots_4, wpn_id) then
      images_icons["bullet"]:draw(x + width / 2 + 7, y + h + 7, nil, 16, 255, 255, 255, a2)
      images_icons["bullet"]:draw(x + width / 2 + widthb / 2 + 10, y + h + 7, nil, 16, 255, 255, 255, a2)
      images_icons["bullet"]:draw(x + width / 2 + widthb / 2 + 10 + widthb / 2 , y + h + 7, nil, 16, 255, 255, 255, a2)
      images_icons["bullet"]:draw(x + width / 2 + widthb / 2 + 10 + widthb / 2 + widthb / 2, y + h + 7, nil, 16, 255, 255, 255, a2)
     else
      images_icons["bullet"]:draw(x + width / 2 + 6, y + h + 6, nil, 16, 255, 255, 255, 0)
      images_icons["bullet"]:draw(x + width / 2 + widthb / 2 + 6, y + h + 6, nil, 16, 255, 255, 255, 0)
    end
  end

  client.set_event_callback('paint_ui', g_paint_handler)
  ui.set_callback(increase_speed, fast_dt)
  ui.set_callback(increase_speed_mode, fast_dt)
  ui.set_callback(fake_lag, fast_dt)
  client.set_event_callback("shutdown", function()
    fast_dt()
    visbilityshit(false)
  end)
end)