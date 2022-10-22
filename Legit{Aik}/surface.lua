local ffi = require("ffi")
local bit = require("bit")
local cast = ffi.cast
local unpack = table.unpack
local bor = bit.bor

-- localize

ffi.cdef[[
    typedef unsigned char wchar_t;
]]

local function uuid(len)
    local res, len = "", len or 32
    for i=1, len do
        res = res .. string.char(client.random_int(97, 122))
    end
    return res
end

local interface_mt = {}

function interface_mt.get_function(self, index, ret, args)
    local ct = uuid() .. "_t"

    args = args or {}
    if type(args) == "table" then
        table.insert(args, 1, "void*")
    else
        return error("args has to be of type table", 2)
    end
    local success, res = pcall(ffi.cdef, "typedef " .. ret .. " (__thiscall* " .. ct .. ")(" .. table.concat(args, ", ") .. ");")
    if not success then
        error("invalid typedef: " .. res, 2)
    end

    local interface = self[1]
    local success, func = pcall(ffi.cast, ct, interface[0][index])
    if not success then
        return error("failed to cast: " .. func, 2)
    end

    return function(...)
        local success, res = pcall(func, interface, ...)

        if not success then
            return error("call: " .. res, 2)
        end

        if ret == "const char*" then
            return res ~= nil and ffi.string(res) or nil
        end
        return res
    end
end

local function create_interface(dll, interface_name)
    local interface = (type(dll) == "string" and type(interface_name) == "string") and client.create_interface(dll, interface_name) or dll
    return setmetatable({ffi.cast(ffi.typeof("void***"), interface)}, {__index = interface_mt})
end

ffi.cdef[[
    typedef int(__thiscall* ConvertAnsiToUnicode_t)(void*, const char*, wchar_t*, int);
    typedef int(__thiscall* ConvertUnicodeToAnsi_t)(void*, const wchar_t*, char*, int);
    typedef wchar_t*(__thiscall* FindSafe_t)(void*, const char*);
]]

local localize = create_interface("localize.dll", "Localize_001")
local convert_ansi_to_unicode = localize:get_function(15, "int", {"const char*", "wchar_t*", "int"})
local convert_unicode_to_ansi = localize:get_function(16, "int", {"const wchar_t*", "char*", "int"})
local find_safe = localize:get_function(12, "wchar_t*", {"const char*"})

-- set up surface metatable
local surface_mt   = {}
surface_mt.__index = surface_mt

surface_mt.isurface = create_interface("vguimatsurface.dll", "VGUI_Surface031")

surface_mt.fn_draw_set_color            = surface_mt.isurface:get_function(15, "void", {"int", "int", "int", "int"})
surface_mt.fn_draw_filled_rect          = surface_mt.isurface:get_function(16, "void", {"int", "int", "int", "int"})
surface_mt.fn_draw_outlined_rect        = surface_mt.isurface:get_function(18, "void", {"int", "int", "int", "int"})
surface_mt.fn_draw_line                 = surface_mt.isurface:get_function(19, "void", {"int", "int", "int", "int"})
surface_mt.fn_draw_poly_line            = surface_mt.isurface:get_function(20, "void", {"int*", "int*", "int",})
surface_mt.fn_draw_set_text_font        = surface_mt.isurface:get_function(23, "void", {"unsigned long"})
surface_mt.fn_draw_set_text_color       = surface_mt.isurface:get_function(25, "void", {"int", "int", "int", "int"})
surface_mt.fn_draw_set_text_pos         = surface_mt.isurface:get_function(26, "void", {"int", "int"})
surface_mt.fn_draw_print_text           = surface_mt.isurface:get_function(28, "void", {"const wchar_t*", "int", "int" })

surface_mt.fn_draw_get_texture_id       = surface_mt.isurface:get_function(34, "int",  {"const char*"}) -- new
surface_mt.fn_draw_get_texture_file     = surface_mt.isurface:get_function(35, "bool", {"int", "char*", "int"}) -- new
surface_mt.fn_draw_set_texture_file     = surface_mt.isurface:get_function(36, "void", {"int", "const char*", "int", "bool"}) -- new
surface_mt.fn_draw_set_texture_rgba     = surface_mt.isurface:get_function(37, "void", {"int", "const unsigned char*", "int", "int"}) -- new
surface_mt.fn_draw_set_texture          = surface_mt.isurface:get_function(38, "void", {"int"}) -- new
surface_mt.fn_delete_texture_by_id      = surface_mt.isurface:get_function(39, "void", {"int"}) -- new
surface_mt.fn_draw_get_texture_size     = surface_mt.isurface:get_function(40, "void", {"int", "int&", "int&"}) -- new
surface_mt.fn_draw_textured_rect        = surface_mt.isurface:get_function(41, "void", {"int", "int", "int", "int"})
surface_mt.fn_is_texture_id_valid       = surface_mt.isurface:get_function(42, "bool", {"int"}) -- new
surface_mt.fn_create_new_texture_id     = surface_mt.isurface:get_function(43, "int",  {"bool"}) -- new

surface_mt.fn_unlock_cursor             = surface_mt.isurface:get_function(66, "void")
surface_mt.fn_lock_cursor               = surface_mt.isurface:get_function(67, "void")
surface_mt.fn_create_font               = surface_mt.isurface:get_function(71, "unsigned int")
surface_mt.fn_set_font_glyph            = surface_mt.isurface:get_function(72, "void", {"unsigned long", "const char*", "int", "int", "int", "int", "unsigned long", "int", "int"})
surface_mt.fn_get_text_size             = surface_mt.isurface:get_function(79, "void", {"unsigned long", "const wchar_t*", "int&", "int&"})
surface_mt.fn_get_cursor_pos            = surface_mt.isurface:get_function(100, "unsigned int", {"int*", "int*"})
surface_mt.fn_set_cursor_pos            = surface_mt.isurface:get_function(101, "unsigned int", {"int", "int"})
surface_mt.fn_draw_outlined_circle      = surface_mt.isurface:get_function(103, "void", {"int", "int", "int", "int"})
surface_mt.fn_draw_filled_rect_fade     = surface_mt.isurface:get_function(123, "void", {"int", "int", "int", "int", "unsigned int", "unsigned int", "bool"})

--[[
    @function draw_set_color
	@params int, int, int, int
    @returns nothing
    @infos 
        vtable index: 15
        typedef:    
            void* = thisptr;
            int[4] = color values(r, g, b, a);
]]
ffi.cdef[[
    typedef void(__thiscall* draw_set_color_t)(void*, int, int, int, int);  
]]
function surface_mt:draw_set_color(r, g, b, a) 
    self.fn_draw_set_color(r, g, b, a)
end

--[[
    @function draw_filled_rect
	@params int, int, int, int
    @returns nothing
    @infos 
        vtable index: 16
        typedef:    
            void* = thisptr;
            int[4] = screen coordinates(x0, y0, x1, y1);
]]
ffi.cdef[[
    typedef void(__thiscall* draw_filled_rect_t)(void*, int, int, int, int);  
]]
function surface_mt:draw_filled_rect(x0, y0, x1, y1) 
    self.fn_draw_filled_rect(x0, y0, x1, y1)
end

--[[
    @function draw_outlined_rect
	@params int, int, int, int
    @returns nothing
    @infos 
        vtable index: 18
        typedef:    
            void* = thisptr;
            int[4] = screen coordinates(x0, y0, x1, y1);
]]
ffi.cdef[[
    typedef void(__thiscall* draw_outlined_rect_t)(void*, int, int, int, int);  
]]
function surface_mt:draw_outlined_rect(x0, y0, x1, y1) 
    self.fn_draw_outlined_rect(x0, y0, x1, y1)
end

--[[
    @function draw_line
	@params int, int, int, int
    @returns nothing
    @infos 
        vtable index: 19
        typedef:    
            void* = thisptr;
            int[4] = screen coordinates(x0, y0, x1, y1);
]]
ffi.cdef[[
    typedef void(__thiscall* draw_line_t)(void*, int, int, int, int);  
]]
function surface_mt:draw_line(x0, y0, x1, y1) 
    self.fn_draw_line(x0, y0, x1, y1)
end

--[[
    @function draw_poly_line
	@params int*, int*, int
    @returns nothing
    @infos 
        vtable index: 20
        typedef:    
            void* = thisptr;
            int[2] = screen coordinates(x, y);
            int = amount of lines;
]]
ffi.cdef[[
    typedef void(__thiscall* draw_poly_line_t)(void*, int*, int*, int);  
]]
function surface_mt:draw_poly_line(x, y, count) 
    local int_ptr = ffi.typeof("int[1]") 
    local x1 = ffi.new(int_ptr, x)
    local y1 = ffi.new(int_ptr, y)
    self.fn_draw_poly_line(x1, y1, count)
end

--[[
    @function draw_outlined_circle
	@params int, int, int, int
    @returns nothing
    @infos 
        vtable index: 103
        typedef:    
            void* = thisptr;
            int[2] = screen coordinates(x, y)
            int = radius
            int = segments
]]
ffi.cdef[[
    typedef void(__thiscall* draw_outlined_circle_t)(void*, int, int, int, int);  
]]
function surface_mt:draw_outlined_circle(x, y, radius, segments) 
    self.fn_draw_outlined_circle(x, y, radius, segments)
end

--[[
    @function draw_filled_rect_fade
	@params int, int, int, int, unsigned int, unsigned int, bool
    @returns nothing
    @infos 
        vtable index: 123
        typedef:    
            void* = thisptr;
            int[4] = screen coordinates(x0, y0, x1, y1)
            unsigned int = alpha0
            unsigned int = alpha1
            bool = horizontal
]]
ffi.cdef[[
    typedef void(__thiscall* draw_filled_rect_fade_t)(void*, int, int, int, int, unsigned int, unsigned int, bool);  
]]
function surface_mt:draw_filled_rect_fade(x0, y0, x1, y1, alpha0, alpha1, horizontal) 
    self.fn_draw_filled_rect_fade(x0, y0, x1, y1, alpha0, alpha1, horizontal)
end

--[[
    @function draw_set_text_font
	@params unsigned long
    @returns nothing
    @infos 
        vtable index: 23
        typedef:    
            void* = thisptr;
            unsigned long = font(return type of create_font);
]]
ffi.cdef[[
    typedef void(__thiscall* draw_set_text_font_t)(void*, unsigned long);  
]]
function surface_mt:draw_set_text_font(font) 
    self.fn_draw_set_text_font(font)
end

--[[
    @function draw_set_text_color
	@params int, int, int, int
    @returns nothing
    @infos 
        vtable index: 25
        typedef:    
            void* = thisptr;
            int[4] = color values(r, g, b, a);
]]
ffi.cdef[[
    typedef void(__thiscall* draw_set_text_color_t)(void*, int, int, int, int);  
]]
function surface_mt:draw_set_text_color(r, g, b, a) 
    self.fn_draw_set_text_color(r, g, b, a)
end

--[[
    @function draw_set_text_pos
	@params int, int,
    @returns nothing
    @infos 
        vtable index: 26
        typedef:    
            void* = thisptr;
            int[2] = screen coordinates(x, y);
]]
ffi.cdef[[
    typedef void(__thiscall* draw_set_text_pos_t)(void*, int, int);  
]]
function surface_mt:draw_set_text_pos(x, y) 
    self.fn_draw_set_text_pos(x, y)
end

--[[
    @function draw_print_text
	@params const wchar_t*
    @returns nothing
    @infos 
        vtable index: 28
        typedef:    
            void* = thisptr;
            const wchar_t* = text to draw
]]
ffi.cdef[[
    typedef void(__thiscall* draw_print_text_t)(void*, const wchar_t*, int, int);  
]]
function surface_mt:draw_print_text(text, localized) 
    if localized then 
        local char_buffer = ffi.new('char[1024]')  
        convert_unicode_to_ansi(text, char_buffer, 1024)
        local test = ffi.string(char_buffer)
        self.fn_draw_print_text(text, test:len(), 0)
    else
        local wide_buffer = ffi.new('wchar_t[1024]')    
        convert_ansi_to_unicode(text, wide_buffer, 1024)
        self.fn_draw_print_text(wide_buffer, text:len(), 0)
    end
end

--[[
    @function draw_get_texture_id 
    @params const char*
    @returns the texture id of the file you provided
]]
function surface_mt:draw_get_texture_id(filename)
    return(self.fn_draw_get_texture_id(filename))
end

--[[
    @function draw_get_texture_file 
    @params int, char*, int
    @returns true if the file was found
]]
function surface_mt:draw_get_texture_file(id, filename, maxlen)
    return(self.fn_draw_get_texture_file(id, filename, maxlen))
end

--[[
    @function draw_set_texture_file 
    @params int, const char*, int, bool
    @returns nothing
]]
function surface_mt:draw_set_texture_file(id, filename, hardwarefilter, forcereload)
    self.fn_draw_set_texture_file(id, filename, hardwarefilter, forcereload)
end

--[[
    @function draw_set_texture_rgba
    @params int, const unsigned char*, int, int
    @returns nothing
]]
function surface_mt:draw_set_texture_rgba(id, rgba, wide, tall)
    self.fn_draw_set_texture_rgba(id, rgba, wide, tall)
end

--[[
    @function draw_set_texture 
    @params int
    @returns nothing
]]
function surface_mt:draw_set_texture(id)
    self.fn_draw_set_texture(id)
end

--[[
    @function delete_texture_by_id 
    @params int
    @returns nothing
]]
function surface_mt:delete_texture_by_id(id)
    self.fn_delete_texture_by_id(id)
end

--[[
    @function draw_get_texture_size 
    @params int, int&, int&
    @returns width, height
]]
function surface_mt:draw_get_texture_size(id)
    local int_ptr = ffi.typeof("int[1]") 
    local wide_ptr = int_ptr() local tall_ptr = int_ptr()
    self.fn_draw_get_texture_size(id, wide_ptr, tall_ptr)
    local wide = tonumber(ffi.cast("int", wide_ptr[0]))
    local tall = tonumber(ffi.cast("int", tall_ptr[0]))
    return wide, tall
end

--[[
    @function draw_textured_rect 
    @params int, int, int, int
    @returns nothing
]]
function surface_mt:draw_textured_rect(x0, y0, x1, y1)
    self.fn_draw_textured_rect(x0, y0, x1, y1)
end

--[[
    @function is_texture_id_valid 
    @params int
    @returns true if texture id is valid
]]
function surface_mt:is_texture_id_valid(id)
    return(self.fn_is_texture_id_valid(id))
end

--[[
    @function create_new_texture_id 
    @params bool
    @returns integer of the texture id
]]
function surface_mt:create_new_texture_id(id)
    return(self.fn_create_new_texture_id(id))
end

--[[
    @function create_font
	@params none
    @returns an int of the font index
    @infos 
        vtable index: 71
        typedef:    
            void* = thisptr;
]]
ffi.cdef[[
    typedef unsigned int(__thiscall* create_font_t)(void*);  
]]
function surface_mt:create_font() 
    return(self.fn_create_font())
end

--[[
    @function set_font_glyph
	@params unsigned long, const char, int, int, int[]
    @returns nothing
    @infos 
        vtable index: 72
        typedef:    
            void* = thisptr;
            unsigned long = font variable(return type of create_font)
            const char* = windows font name(only .ttf)
            int = tall
            int = weight
            int = blur
            int = scanlines 
            int[] = hexadecimal values of the fontflags
]]
ffi.cdef[[
    typedef void(__thiscall* set_font_glyph_t)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int);
]]
function surface_mt:set_font_glyph(font, font_name, tall, weight, flags) 
    local x = 0
    if type(flags) == "number" then
        x = flags
    elseif type(flags) == "table" then
        for i=1, #flags do
            x = x + flags[i]
        end
    end
    self.fn_set_font_glyph(font, font_name, tall, weight, 0, 0, bit.bor(x), 0, 0)
end

--[[
    @function get_text_size
	@params unsigned long, const wchar_t*, int&, int&
    @returns nothing
    @infos 
        vtable index: 79
        typedef:    
            void* = thisptr;
            unsigned long = font variable(return type of create_font)
            const wchar_t* = text
            int& = wide
            int& = tall
]]
ffi.cdef[[
    typedef void(__thiscall* get_text_size_t)(void*, unsigned long, const wchar_t*, int&, int&);  
]]

function surface_mt:get_text_size(font, text) 
    local wide_buffer = ffi.new('wchar_t[1024]') 
    local int_ptr = ffi.typeof("int[1]") 
    local wide_ptr = int_ptr() local tall_ptr = int_ptr()

    convert_ansi_to_unicode(text, wide_buffer, 1024)
    self.fn_get_text_size(font, wide_buffer, wide_ptr, tall_ptr)
    local wide = tonumber(ffi.cast("int", wide_ptr[0]))
    local tall = tonumber(ffi.cast("int", tall_ptr[0]))
    return wide, tall
end

--[[
    @function get_cursor_pos
	@params 
    @returns x, y position of the cursor
    @infos 
        vtable index: 100
        typedef:    
            void* = thisptr;
]]
ffi.cdef[[
    typedef unsigned int(__thiscall* get_cursor_pos_t)(void*, int*, int*);  
]]
function surface_mt:get_cursor_pos() 
   local int_ptr = ffi.typeof("int[1]") 
   local x_ptr = int_ptr() local y_ptr = int_ptr()
   self.fn_get_cursor_pos(x_ptr, y_ptr)
   local x = tonumber(ffi.cast("int", x_ptr[0]))
   local y = tonumber(ffi.cast("int", y_ptr[0]))
   return x, y
end

--[[
    @function set_cursor_pos
	@params int int
    @returns nothing
    @infos 
        vtable index: 101
        typedef:    
            void* = thisptr;
            int[2] = screen coordinates(x, y)
]]
ffi.cdef[[
    typedef unsigned int(__thiscall* set_cursor_pos_t)(void*, int, int);  
]]
function surface_mt:set_cursor_pos(x, y) 
    self.fn_set_cursor_pos(x, y)
end

--[[
    @function unlock_cursor
	@params
    @returns nothing
    @infos 
        vtable index: 66
        typedef:    
            void* = thisptr;
]]
ffi.cdef[[
    typedef unsigned int(__thiscall* unlock_cursor_t)(void*);  
]]
function surface_mt:unlock_cursor() 
    self.fn_unlock_cursor()
end

--[[
    @function lock_cursor
	@params
    @returns nothing
    @infos 
        vtable index: 67
        typedef:    
            void* = thisptr;
]]
ffi.cdef[[
    typedef unsigned int(__thiscall* lock_cursor_t)(void*);  
]]
function surface_mt:lock_cursor() 
    self.fn_lock_cursor()
end

--------------------------
-- renderer functions --
--------------------------

function renderer.create_font(windows_font_name, tall, weight, flags)
    local font = surface_mt:create_font()
    if type(flags) == "nil" then 
        flags = 0 
    end
    surface_mt:set_font_glyph(font, windows_font_name, tall, weight, flags)
    return font
end

function renderer.localize_string(text)
    local localized_string = find_safe(text)
    local char_buffer = ffi.new('char[1024]')  
    convert_unicode_to_ansi(localized_string, char_buffer, 1024)
    return ffi.string(char_buffer)
end

function renderer.draw_text(x, y, r, g, b, a, font, text)
    surface_mt:draw_set_text_pos(x, y)
    surface_mt:draw_set_text_font(font)
    surface_mt:draw_set_text_color(r, g, b, a)
    surface_mt:draw_print_text(tostring(text), false)
end

function renderer.draw_localized_text(x, y, r, g, b, a, font, text)
    surface_mt:draw_set_text_pos(x, y)
    surface_mt:draw_set_text_font(font)
    surface_mt:draw_set_text_color(r, g, b, a)

    local localized_string = find_safe(text)

    surface_mt:draw_print_text(localized_string, true)
end

function renderer.draw_line(x0, y0, x1, y1, r, g, b, a)
    surface_mt:draw_set_color(r, g, b, a)
    surface_mt:draw_line(x0, y0, x1, y1)
end

function renderer.draw_filled_rect(x, y, w, h, r, g, b, a)
    surface_mt:draw_set_color(r, g, b, a)
    surface_mt:draw_filled_rect(x, y, x + w, y + h)
end

function renderer.draw_outlined_rect(x, y, w, h, r, g, b, a)
    surface_mt:draw_set_color(r, g, b, a)
    surface_mt:draw_outlined_rect(x, y, x + w, y + h)
end

function renderer.draw_filled_outlined_rect(x, y, w, h, r0, g0, b0, a0, r1, g1, b1, a1)
    surface_mt:draw_set_color(r0, g0, b0, a0)
    surface_mt:draw_filled_rect(x, y, x + w, y + h)
    surface_mt:draw_set_color(r1, g1, b1, a1)
    surface_mt:draw_outlined_rect(x, y, x + w, y + h)
end

function renderer.draw_filled_gradient_rect(x, y, w, h, r0, g0, b0, a0, r1, g1, b1, a1, horizontal)
    surface_mt:draw_set_color(r0, g0, b0, a0)
    surface_mt:draw_filled_rect_fade(x, y, x + w, y + h, 255, 255, horizontal)

    surface_mt:draw_set_color(r1, g1, b1, a1)
    surface_mt:draw_filled_rect_fade(x, y, x + w, y + h, 0, 255, horizontal)
end

function renderer.draw_outlined_circle(x, y, r, g, b, a, radius, segments)
    surface_mt:draw_set_color(r, g, b, a)
    surface_mt:draw_outlined_circle(x, y, radius, segments)
end

function renderer.draw_poly_line(x, y, r, g, b, a, count)
    surface_mt:draw_set_color(r, g, b, a)
    surface_mt:draw_poly_line(x, y, count)
end

function renderer.test_font(x, y, r, g, b, a, font)
    local _, height_offset = surface_mt:get_text_size(font, "a b c d e f g h i j k l m n o p q r s t u v w x y z")
   
    renderer.draw_text(x, y, r, g, b, a, font, "a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 ß + # ä ö ü , . -")
    renderer.draw_text(x, y + height_offset, r, g, b, a,  font, "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z = ! \" § $ % & / ( ) = ? { [ ] } \\ * ' _ : ; ~ ")
end

function renderer.get_text_size(font, text)
    return surface_mt:get_text_size(font, text) 
end

function renderer.set_mouse_pos(x, y)
    surface_mt:set_cursor_pos(x, y)
end

function renderer.get_mouse_pos()
    return surface_mt:get_cursor_pos()
end

function renderer.unlock_cursor()
    surface_mt:unlock_cursor()
end

function renderer.lock_cursor()
    surface_mt:lock_cursor()
end

function renderer.load_texture(filename)
    local texture = surface_mt:create_new_texture_id(false)
    surface_mt:draw_set_texture_file(texture, filename, true, true)
    local _w, _h = surface_mt:draw_get_texture_size(texture)
    return texture
end
