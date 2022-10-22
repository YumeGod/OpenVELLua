--------------------------------------------------------------------------------
-- Cache common functions
--------------------------------------------------------------------------------
local uix = require 'gamesense/uix'
local assert, bit_band, client_delay_call, client_error_log, client_userid_to_entindex, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_is_alive, ipairs, string_format, ui_get, ui_name, ui_new_checkbox, ui_new_combobox, ui_new_label, ui_reference, ui_set, ui_set_callback, ui_set_visible, unpack = assert, bit.band, client.delay_call, client.error_log, client.userid_to_entindex, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive, ipairs, string.format, ui.get, ui.name, ui.new_checkbox, ui.new_combobox, ui.new_label, ui.reference, ui.set, ui.set_callback, ui.set_visible, unpack

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local enable_ref
local config_ref
local label_ref

-- Array of aimbot references
-- references[IDX_BUILTIN] is an array of references to the built-in menu items
-- references[IDX_GLOBAL] is an array of references to the global config
local references = {}
local IDX_BUILTIN = 1
local IDX_GLOBAL = 2

local config_idx_to_name = {}
local config_name_to_idx = {}
local weapon_id_to_config_idx = {}

-- Active weapon config is managed by the script when the local player is alive
-- Active weapon config is managed by the user (via the menu) while the local player is dead
local active_config_idx

local SPECATOR_TEAM_ID = 1

--------------------------------------------------------------------------------
-- Utility functions
--------------------------------------------------------------------------------
local function copy_settings(config_idx_src, config_idx_dst)
	local src_refs = references[config_idx_src]
	local dst_refs = references[config_idx_dst]
	for i=1, #dst_refs do
		local set_successful = pcall(ui_set, dst_refs[i], ui_get(src_refs[i]))
		if set_successful == false then
			client_error_log("An error occured while trying to load a setting")
		end
	end
end

local function load_config(config_idx)
	if active_config_idx ~= config_idx then
		active_config_idx = config_idx
		copy_settings(config_idx, IDX_BUILTIN)
		ui_set(label_ref, "Hitler fix Active weapon config: " .. config_idx_to_name[config_idx])
	end
end

local function update_config_visibility(state)
	local display_config = state
	local script_state = enable_ref:get()
	if display_config == nil then
		display_config = entity_is_alive(entity_get_local_player()) == false
	end
	local display_label = not display_config and script_state
	display_config = display_config and script_state
	ui_set_visible(config_ref, display_config)
	ui_set_visible(label_ref, display_label)
	return display_config
end

local function save_reference(config_idx, setting_idx, ref)
	references[config_idx][setting_idx] = ref
	return ref
end

local function bind(func, ...)
	local args = { ... }
	return function(ref)
		func(ref, unpack(args))
	end
end

local function delayed_bind(func, delay, ...)
	local args = { ... }
	return function(ref)
		client_delay_call(delay, func, ref, unpack(args))
	end
end

-- Temporary function for enabling config in the menu
local function menu_task()
	update_config_visibility()
	client_delay_call(5, menu_task)
end

--------------------------------------------------------------------------------
-- Callback functions
--------------------------------------------------------------------------------
local function on_setup_command()
	local local_player = entity_get_local_player()
	-- Get the local players weapon so we can find its item definition index
	local weapon = entity_get_player_weapon(local_player)
	if weapon then
		-- Get the weapons item definition and toggle off the 16th bit to get the real item def index
		local weapon_id = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
		-- Use the weapon_id_to_config_idx lookup table to get the new config index and attempt to load the config
		load_config(weapon_id_to_config_idx[weapon_id] or IDX_GLOBAL)
	end
end

local function on_player_death(e)
	if client_userid_to_entindex(e.userid) == entity_get_local_player() then
		update_config_visibility(true)
	end
end

local function on_player_spawn(e)
	if client_userid_to_entindex(e.userid) == entity_get_local_player() then
		update_config_visibility(false)
	end
end

local function on_player_team_change(e)
	if client_userid_to_entindex(e.userid) == entity_get_local_player() then
		-- Check if the team the local player switched to is spectator(1)
		if e.team == SPECATOR_TEAM_ID then
			update_config_visibility(true)
		end
	end
end

local function on_game_disconnect()
	update_config_visibility(true)
end

-- Called when a user selects a different weapon config with the combobox
local function on_weapon_config_selected(ref)
	-- If the local player is alive then do nothing and hide this combobox
	if update_config_visibility() == false then
		-- This should never happen
		-- client.error_log("Weapon config selected while local player is alive!")
		return
	end

	-- Load settings from the selected weapon config
	local config_name = ui_get(ref)
	local config_idx = config_name_to_idx[config_name]
	load_config(config_idx)
end

-- Called when a user changes the value of a built-in menu item (e.g. checking "Automatic penetration")
-- Also called when a config is loaded
local function on_builtin_setting_change(ref, setting_idx)
	-- Propagate built-in setting changes to the adaptive settings
	if active_config_idx and enable_ref:get() == true then
		local set_successful = pcall(ui_set, references[active_config_idx][setting_idx], ui_get(ref))
		if set_successful == false then
			client_error_log("An error occured while trying to save a setting.")
		end
	end
end

-- Called when a user changes the value of a weapon configs menu item (e.g. checking "Global automatic penetration")
-- Also called when a config is loaded
local function on_adaptive_setting_changed(ref, config_idx, setting_idx)
	-- Propagate adaptive setting changes to the built-in settings
	if config_idx == active_config_idx and enable_ref:get() == true then
		pcall(ui_set, references[IDX_BUILTIN][setting_idx], ui_get(ref))
	end
end

--------------------------------------------------------------------------------
-- Initialization code
--------------------------------------------------------------------------------
local function duplicate(tab, container, name, ui_func, ...)
	-- This menu item will have the same index across all weapon configs
	local setting_index = #references[IDX_BUILTIN]+1
	-- Check if the reference exists before creating the other duplicate menu items
	local ref_successful, ref_builtin = pcall(ui_reference, tab, container, name)
	if ref_successful then
		-- Create hidden menu items to store values
		for i = IDX_GLOBAL, #references do
			local config_name = config_idx_to_name[i]
			-- Create a duplicate menu item to store settings that can be copied later
			local ref = save_reference(i, setting_index, ui_func(tab, container, config_name .. " " .. name:lower(), ...))
			-- Set a default value for the target hitbox as this multiselect cannot be empty
			if name == "Target hitbox" then
				ui_set(ref, { "Head" })
			end
			ui_set_visible(ref, false)
			ui_set_callback(ref, bind(on_adaptive_setting_changed, i, setting_index))
		end
		-- Set a callback on the built-in menu items so that settings are not overwritten whenever we are loading a new config
		save_reference(IDX_BUILTIN, setting_index, ref_builtin) 
		ui_set_callback(ref_builtin, delayed_bind(on_builtin_setting_change, 0.01, setting_index))
	else
		client_error_log(string_format("Reference: '%s' '%s' '%s' not found", tab, container, name))
	end
end

local function init_config(name, ...)
	local config_idx = #references + 1
	references[config_idx] = {}
	config_idx_to_name[config_idx] = name
	config_name_to_idx[name] = config_idx
	-- Populate the weapon_id_to_config_idx lookup table so we can easily get a configs index from a weapon id
	for _, weapon_id in ipairs({ ... }) do
		weapon_id_to_config_idx[weapon_id] = config_idx
	end
	return config_idx
end

local function init()
	IDX_BUILTIN = init_config("Built-in menu items")
	init_config("Global")
	init_config("Auto", 11, 38)
	init_config("Awp", 9)
	init_config("Scout", 40)
	init_config("Desert Eagle", 1)
	init_config("Revolver", 64)
	init_config("Pistol", 2, 3, 4, 30, 32, 36, 61, 63)
	init_config("Rifle", 7, 8, 10, 13, 16, 39, 60)
	init_config("Submachine gun", 17, 19, 23, 24, 26, 33, 34)
	init_config("Shotgun", 25, 27, 29, 35)
	init_config("Machine gun", 14, 28)

	assert(config_idx_to_name[IDX_GLOBAL] == "Global")

	enable_ref = uix.new_checkbox("RAGE", "Other", "Adaptive config")
	config_ref = ui_new_combobox("RAGE", "Other", "\nAdaptive config", config_idx_to_name)
	label_ref = ui_new_label("RAGE", "Other", "Active weapon config: " .. ui_get(config_ref))

	duplicate("RAGE", "Aimbot", "Target selection", ui_new_combobox, "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance")
	duplicate("RAGE", "Aimbot", "Target hitbox", ui.new_multiselect, "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")
	duplicate("RAGE", "Aimbot", "Multi-point", ui.new_multiselect, "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")
	duplicate("RAGE", "Aimbot", "Multi-point scale", ui.new_slider, 24, 100, 24, true, "%", 1)
	duplicate("RAGE", "Aimbot", "Prefer safe point", ui_new_checkbox)
	duplicate("RAGE", "Aimbot", "Force safe point on limbs", ui_new_checkbox)
	duplicate("RAGE", "Aimbot", "Automatic fire", ui_new_checkbox)
	duplicate("RAGE", "Aimbot", "Automatic penetration", ui_new_checkbox)
	duplicate("RAGE", "Aimbot", "Silent aim", ui_new_checkbox)
	duplicate("RAGE", "Aimbot", "Minimum hit chance", ui.new_slider, 0, 100, 50, true, "%", 1)
	duplicate("RAGE", "Aimbot", "Minimum damage", ui.new_slider, 0, 126, 0, true, "%", 1)
	duplicate("RAGE", "Aimbot", "Automatic scope", ui_new_checkbox)
	duplicate("RAGE", "Aimbot", "Maximum FOV", ui.new_slider, 1, 180, 180, true, "°")
	duplicate("RAGE", "Aimbot", "Custom minimum damage", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Default minimum damage", ui.new_slider, 0, 126, 0, true, "%", 1, mindamage_override)
	duplicate("RAGE", "Aimbot", "Visible minimum damage", ui.new_slider, 0, 126, 0, true, "%", 1, mindamage_override)
    duplicate("RAGE", "Aimbot", "Override damage", ui.new_slider, 0, 126, 0, true, "%", 1, mindamage_override)
	duplicate("RAGE", "Aimbot", "Default minimum hitchance", ui.new_slider, 0, 100, 50, true, "%", 1, hitchance_override)
	duplicate("RAGE", "Aimbot", "Custom noscope hitchance", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Noscope minimum hitchance", ui.new_slider, 0, 100, 44, true, "%", 1, hitchance_override)
	duplicate("RAGE", "Aimbot", "Custom Air Mode", ui.new_checkbox)
    duplicate("RAGE", "Aimbot", "Air damage", ui.new_slider, 0, 126, 0, true, "%", 1, mindamage_override)
	duplicate("RAGE", "Aimbot", "Air hitchance", ui.new_slider, 0, 100, 50, true, "%", 1, hitchance_override)
	duplicate("RAGE", "Aimbot", "Force safe point in air", ui.new_checkbox)
	--duplicate("Rage", "Aimbot", "Force safe point key", ui.new_combobox, "Always on","On hotkey","Toggle","Off hotkey")
	duplicate("RAGE", "Other", "Accuracy boost", ui.new_combobox, "Off", "Low", "Medium", "High", "Maximum")
	duplicate("RAGE", "Other", "Delay shot", ui.new_checkbox)
	--duplicate("RAGE", "Other", "Quick peek assist", ui.new_checkbox)
    duplicate("RAGE", "Other", "Quick stop", ui.new_checkbox)
    duplicate("RAGE", "Other", "Quick stop options", ui.new_multiselect, "Early", "Slow motion", "Duck", "Fake duck", "Move between shots", "Ignore molotov")
    duplicate("RAGE", "Other", "Prefer body aim", ui.new_checkbox)
    duplicate("RAGE", "Other", "Prefer body aim disablers", ui.new_multiselect, "Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage")
    duplicate("RAGE", "Other", "Force body aim on peek", ui.new_checkbox)
	duplicate("RAGE", "Other", "Double tap", ui.new_checkbox)
	duplicate("RAGE", "Other", "Double tap mode", ui.new_combobox, "Offensive", "Defensive")
	duplicate("RAGE", "Other", "Double tap hit chance", ui.new_slider, 0, 100, 50, true, "%", 1)
    duplicate("RAGE", "Other", "Double tap quick stop", ui.new_multiselect, "Slow motion", "Duck", "Move between shots")
	duplicate("MISC","Miscellaneous","Ping spike", ui.new_checkbox)
	-- duplicate("RAGE", "Other", "Prefer boda aim", ui.new_multiselect,"Backwards/Forwards","Moving targets","Slow targets","Shooting","x2 HP","<x HP","Big desync","Walking jitter desync","Always on")
	-- duplicate("RAGE", "Other", "Prefer head aim", ui.new_multiselect,"Sideways targets","Crouching targets","Fast targets","Shooting","Small desync","Small fakelag")
	-- duplicate("RAGE", "Other", "Force boda aim", ui.new_multiselect,"Backwards/Forwards","Sideways targets","Slow targets","Shooting","x1 HP","x2 HP","<x HP","Walking jitter desync","1 miss","2 miss")
	-- --duplicate("RAGE", "Other", "Indicator", ui.new_checkbox)
	-- duplicate("RAGE", "Other", "Automatically reset misses", ui.new_checkbox)
	-- duplicate("RAGE", "Other", "Predictive body aim", ui.new_checkbox)
	-- duplicate("RAGE", "Other", "Range", ui.new_slider, 1, 70, 30, true, "°")	
	-- duplicate("RAGE", "Other", "Desync limit", ui.new_slider, 290, 580, 290, true, "°", 0.1)
	-- duplicate("RAGE", "Other", "HP", ui.new_slider, 1, 100)
	-- duplicate("RAGE", "Other", "Jitter Sensitivity", ui.new_slider, 1, 10, 6, true)
	duplicate("RAGE", "Other", "Predictive body aim", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer high pitch enemy head", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer side way enemy head", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer inaccuracy enemy head", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer fast enemy head", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer crouch enemy head", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer crouch T enemy head", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer crouch enemy body", ui.new_checkbox)
	duplicate("RAGE", "Other", "Force crouch enemy safe point", ui.new_checkbox)
	duplicate("RAGE", "Other", "Force crouch enemy body", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer slow enemy body", ui.new_checkbox)
	duplicate("RAGE", "Other", "Force slow enemy safe point", ui.new_checkbox)
	duplicate("RAGE", "Other", "Force slow enemy body", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer <X HP enemy body", ui.new_slider, 0, 100, 0, true)
	duplicate("RAGE", "Other", "Force <X HP enemy body", ui.new_slider, 0, 100, 0, true)
	duplicate("RAGE", "Other", "Force <X HP enemy safe point", ui.new_slider, 0, 100, 0, true)
	duplicate("RAGE", "Other", "Prefer <X shots enemy body", ui.new_slider,  0, 5, 0, true)
	duplicate("RAGE", "Other", "Force <X shots enemy body", ui.new_slider,  0, 5, 0, true)
	duplicate("RAGE", "Other", "Force <X shots enemy safe point", ui.new_slider,  0, 5, 0, true)
	duplicate("RAGE", "Other", "Force X misses enemy body", ui.new_slider, 0, 10, 0, true)
	duplicate("RAGE", "Other", "Force X misses enemy safe point", ui.new_slider, 0, 10, 0, true)
	duplicate("RAGE","OTHER","Dynamic FPS Default Setting",ui.new_combobox,"Off", "Low", "Medium", "High", "Maximum")
	duplicate("AA","Other","On peek", ui.new_combobox,"Off","Double tap","Teleport","On shot anti-aim","Fake lag")
	duplicate("AA","Other","Charge ticks", ui.new_slider, 0, 12,6,true)
	duplicate("AA","Other","Charge while standing", ui.new_checkbox)
	duplicate("AA","Other","Log teleport data", ui.new_checkbox)


	enable_ref:on("change", update_config_visibility)
	enable_ref:on("setup_command", on_setup_command)
	enable_ref:on("player_death", on_player_death)
	enable_ref:on("player_spawn", on_player_spawn)
	enable_ref:on("player_team", on_player_team_change)
	enable_ref:on("cs_game_disconnected", on_game_disconnect)

	menu_task()
	ui_set_callback(config_ref, on_weapon_config_selected)
end

init()