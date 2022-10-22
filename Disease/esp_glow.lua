--[[
    credits: 
        v1ad / owen
]]

local ffi = require("ffi")

ffi.cdef[[
    struct glow_object_definition_t {
        void *m_ent;
        float r;
        float g;
        float b;
        float a;
        char pad0x4[4];
        float unk1;
        float m_bloom_amount;
        float m_localplayeriszeropoint3;
        bool m_render_when_occluded;
        bool m_render_when_unoccluded;
        bool m_full_bloom_render;
        char pad0x1[1];
        int m_full_bloom_stencil_test_value;
        int m_style;
        int m_split_screen_slot;
        int m_next_free_slot;
    
        static const int END_OF_FREE_LIST = -1;
        static const int ENTRY_IN_USE = -2;
    };
    struct c_glow_object_mngr {
        struct glow_object_definition_t *m_glow_object_definitions;
        int m_max_size;
        int m_pad;
        int m_size;
        struct glow_object_definition_t *m_glow_object_definitions2;
        int m_current_objects;
    }; 
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

local cast = ffi.cast
local get_players = entity.get_players
local get = ui.get
local get_local_player = entity.get_local_player
local is_alive = entity.is_alive

local glow_object_manager_sig = "\x0F\x11\x05\xCC\xCC\xCC\xCC\x83\xC8\x01"
local match = client.find_signature("client_panorama.dll", glow_object_manager_sig) or error("sig not found")
local glow_object_manager = cast("struct c_glow_object_mngr**", cast("char*", match) + 3)[0] or error("glow_object_manager is nil")

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = cast(ffi.typeof("void***"), rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

--------------------------------------------------------------------------------------------------------------------

local local_player_glow = ui.new_checkbox("visuals", "player esp", "Local player glow")
local local_player_glow_clr = ui.new_color_picker("visuals", "player esp", "Local player glow color", 180, 60, 120, 170)
local local_player_glow_style = ui.new_combobox("visuals", "player esp", "\nLocal player glow style", {
    "Normal",
    "Overlay pulse",
    "Inline",
    "Inline pulse"
})

local styles = {
    ["Normal"] = 0,
    ["Overlay pulse"] = 1,
    ["Inline"] = 2,
    ["Inline pulse"] = 3
}

client.set_event_callback("paint", function(ctx)
    local r,g,b,a = get(local_player_glow_clr)
    local me = get_local_player()
    local lpent = get_client_entity(ientitylist, me)
    if get(local_player_glow) then 
        for i=0, glow_object_manager.m_size do 
            if glow_object_manager.m_glow_object_definitions[i].m_next_free_slot == -2 and glow_object_manager.m_glow_object_definitions[i].m_ent then 
                local glowobject = cast("struct glow_object_definition_t&", glow_object_manager.m_glow_object_definitions[i])
                local glowent = glowobject.m_ent
                if is_alive(me) and glowent == lpent then 
                    glowobject.r = r / 255
                    glowobject.g = g / 255 
                    glowobject.b = b / 255
                    glowobject.a = a / 255
                    glowobject.m_style = styles[get(local_player_glow_style)]
                    glowobject.m_render_when_occluded = true
                    glowobject.m_render_when_unoccluded = false
                end 
            end
        end
    end
end)