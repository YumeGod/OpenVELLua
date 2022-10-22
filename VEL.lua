client.exec("clear")

local vel = {
    version = "1.6",
    start_time = tostring(client.unix_time())
}

local veluser = {}

local userinfo = {
    username = '',
    password = '',
    role = '',
    owned_role = '',
}

local information = {
    changelog = '',
    news = '',

    last_config_update = '',
}

local lualist = {}
local loaded_lualist = {}

local config_text, config_needs_load = nil, true

local references = {
    import_from_clipboard = ui.reference('CONFIG', 'Presets', 'Import from clipboard')
}

local ffi = require("ffi")
local bit = require("bit")

--
-- file library start
--

local sid = panorama.open().MyPersonaAPI.GetXuid()

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
    for c = 6, 17 do table.insert(charset, math.random(sid)) end
end

local function randomString(length)
    if not length or length <= 0 then return '' end
    return randomString(length - 1) .. charset[math.random(1, math.random(#charset))]
end

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

-- https://developer.valvesoftware.com/wiki/IFileSystem

local base_filesystem = {}

base_filesystem.fs = create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
base_filesystem.read_file                    = base_filesystem.fs:get_function(0,  "int",          {"void*", "int", "void*"})
base_filesystem.write_file                   = base_filesystem.fs:get_function(1,  "int",          {"void const*", "int", "void*"})
base_filesystem.open_file                    = base_filesystem.fs:get_function(2,  "void*",        {"const char*", "const char*", "const char*"})
base_filesystem.close_file                   = base_filesystem.fs:get_function(3,  "void",         {"void*"})
base_filesystem.get_file_size_from_path      = base_filesystem.fs:get_function(6,  "unsigned int", {"const char*", "const char*"})
base_filesystem.get_file_size                = base_filesystem.fs:get_function(7,  "unsigned int", {"void*"})
base_filesystem.does_file_exists             = base_filesystem.fs:get_function(10, "bool",         {"const char*", "const char*"})

local fs = {}
local fs_mt = {
        __index = fs
}

local access_paths = {
        "GAME", "MOD", "BASE"
}
local access_modes = {
        ["r"] = {writable=false, readable=true, binary = false},
        ["w"] = {writable=true, readable=false, binary = false},
        ["a"] = {writable=true, readable=false, binary = false},
        ["r+"] = {writable=true, readable=true, binary = false},
        ["w+"] = {writable=true, readable=true, binary = false},
        ["a+"] = {writable=true, readable=true, binary = false},

        ["rb"] = {writable=false, readable=true, binary = true},
        ["wb"] = {writable=true, readable=false, binary = true},
        ["ab"] = {writable=true, readable=false, binary = true},
        ["r+b"] = {writable=true, readable=true, binary = true},
        ["w+b"] = {writable=true, readable=true, binary = true},
        ["a+b"] = {writable=true, readable=true, binary = true},
}
local fs_data = {}

local function check_file(self)
        return getmetatable(self) == fs_mt and fs_data[self] ~= nil and fs_data[self].file ~= nil
end

function fs:close()
        if not check_file(self) then
                error("Invalid file", 2)
        end
        if fs_data[self].file == nil then
                return
        end

        base_filesystem.close_file(fs_data[self].file)
        fs_data[self].file = nil
        fs_data[self].writable = false
        fs_data[self].readable = false
end

function fs:size()
        if not check_file(self) then
                error("Invalid file", 2)
        end

        local filesize = base_filesystem.get_file_size(fs_data[self].file) or error("Failed to get file size", 2)
        return filesize
end

function fs:read()
        if not check_file(self) then
                error("Invalid file", 2)
        end
        if not fs_data[self].readable then
                error("File not opened for reading", 2)
        end

        local filesize = self:size()
        local buffer = ffi.new('char[?]', filesize + 1)
        local _ = base_filesystem.read_file(buffer, filesize, fs_data[self].file) or error("Failed to read from file", 2)
        if buffer == nil then
                error("Failed to read file", 2)
        end
        if fs_data[self].binary == true then
                return ffi.string(buffer, filesize)
        end
        return ffi.string(buffer)
end

function fs:write(content)
        if not check_file(self) then
                error("Invalid file", 2)
        end
        if not fs_data[self].writable then
                error("File not opened for writing", 2)
        end

        local size = content:len()
        local _ = base_filesystem.write_file(ffi.string(content), size, fs_data[self].file) or error("Failed to write to file", 2)
        return size
end

function fs:clear()
        return self:write("")
end

local function open_file(filename, path, mode)
        path = path or "MOD"
        mode = mode or "a+"

        local access_mode = access_modes[mode]
        if access_mode == nil then
                error("Invalid file access mode", 2)
        end

        local file = setmetatable({}, fs_mt)

        -- don't directly expose file handles to the user
        fs_data[file] = {
                file = base_filesystem.open_file(filename, mode, path) or error("Failed to open file", 2),
                readable = access_mode.readable,
                writable = access_mode.writable
        }

        -- ffi.gc(fs_data[file].file, function()
        --      file:close()
        -- end)

        return file
end

local function read_file(filename, path)
        path = path or "MOD"
        local file = open_file(filename, path or "MOD", "r")
        local contents = file:read()
        file:close()
        return contents
end

local function write_file(filename, path, content, mode)
        path = path or "MOD"
        mode = mode or "w"

        local file = open_file(filename, path, mode)
        local size = file:write(content)
        file:close()
        return size
end

local function append_file(filename, path, content)
        return write_file(filename, path, content, "a+")
end


local cast, typeof = ffi.cast, ffi.typeof
local voidp = ffi.typeof("void***")

ffi.cdef[[
        typedef bool(__thiscall* file_exist)(void*, const char *, const char *);
]]

local fs_raw = cast(voidp, client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011") or error("Falied to load", 2))
local exec_existfl = cast("file_exist", fs_raw[0][10])

-- file library end

-- base64 library start

local base64 = {}

local extract = _G.bit32 and _G.bit32.extract
if not extract then
	if _G.bit then
		local shl, shr, band = _G.bit.lshift, _G.bit.rshift, _G.bit.band
		extract = function( v, from, width )
			return band( shr( v, from ), shl( 1, width ) - 1 )
		end
	elseif _G._VERSION >= "Lua 5.3" then
		extract = load[[return function( v, from, width )
			return ( v >> from ) & ((1 << width) - 1)
		end]]()
	else
		extract = function( v, from, width )
			local w = 0
			local flag = 2^from
			for i = 0, width-1 do
				local flag2 = flag + flag
				if v % flag2 >= flag then
					w = w + 2^i
				end
				flag = flag2
			end
			return w
		end
	end
end


function base64.makeencoder( s62, s63, spad )
	local encoder = {}
	for b64code, char in pairs{[0]='A','B','C','D','E','F','G','H','I','J',
		'K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y',
		'Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n',
		'o','p','q','r','s','t','u','v','w','x','y','z','0','1','2',
		'3','4','5','6','7','8','9',s62 or '+',s63 or'/',spad or'='} do
		encoder[b64code] = char:byte()
	end
	return encoder
end

function base64.makedecoder( s62, s63, spad )
	local decoder = {}
	for b64code, charcode in pairs( base64.makeencoder( s62, s63, spad )) do
		decoder[charcode] = b64code
	end
	return decoder
end

local DEFAULT_ENCODER = base64.makeencoder()
local DEFAULT_DECODER = base64.makedecoder()

local char, concat = string.char, table.concat

function base64.encode( str, encoder, usecaching )
	encoder = encoder or DEFAULT_ENCODER
	local t, k, n = {}, 1, #str
	local lastn = n % 3
	local cache = {}
	for i = 1, n-lastn, 3 do
		local a, b, c = str:byte( i, i+2 )
		local v = a*0x10000 + b*0x100 + c
		local s
		if usecaching then
			s = cache[v]
			if not s then
				s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
				cache[v] = s
			end
		else
			s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
		end
		t[k] = s
		k = k + 1
	end
	if lastn == 2 then
		local a, b = str:byte( n-1, n )
		local v = a*0x10000 + b*0x100
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
	elseif lastn == 1 then
		local v = str:byte( n )*0x10000
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
	end
	return concat( t )
end

function base64.decode( b64, decoder, usecaching )
	decoder = decoder or DEFAULT_DECODER
	local pattern = '[^%w%+%/%=]'
	if decoder then
		local s62, s63
		for charcode, b64code in pairs( decoder ) do
			if b64code == 62 then s62 = charcode
			elseif b64code == 63 then s63 = charcode
			end
		end
		pattern = ('[^%%w%%%s%%%s%%=]'):format( char(s62), char(s63) )
	end
	b64 = b64:gsub( pattern, '' )
	local cache = usecaching and {}
	local t, k = {}, 1
	local n = #b64
	local padding = b64:sub(-2) == '==' and 2 or b64:sub(-1) == '=' and 1 or 0
	for i = 1, padding > 0 and n-4 or n, 4 do
		local a, b, c, d = b64:byte( i, i+3 )
		local s
		if usecaching then
			local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
			s = cache[v0]
			if not s then
				local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
				s = char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
				cache[v0] = s
			end
		else
			local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
			s = char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
		end
		t[k] = s
		k = k + 1
	end
	if padding == 1 then
		local a, b, c = b64:byte( n-3, n-1 )
		local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
		t[k] = char( extract(v,16,8), extract(v,8,8))
	elseif padding == 2 then
		local a, b = b64:byte( n-3, n-2 )
		local v = decoder[a]*0x40000 + decoder[b]*0x1000
		t[k] = char( extract(v,16,8))
	end
	return concat( t )
end


local function base64_encode(string)
    return base64.encode(string, DEFAULT_ENCODER, true)
end

local function base64_decode(string)
    local status, data = pcall(function()
        return base64.decode(string, DEFAULT_DECODER, true)
    end)

    if(status) then
        return data
    else
        client.color_log(255, 0, 0, "An error occured during decrypting the data from VEL server. Please contact the administrator.")
        return ''
    end
end

-- base64 library end

-- md5 library start

local md5 = {}

local char, byte, format, rep, sub =
  string.char, string.byte, string.format, string.rep, string.sub
local bit_or, bit_and, bit_not, bit_xor, bit_rshift, bit_lshift = bit.bor, bit.band, bit.bnot, bit.bxor, bit.rshift, bit.lshift

-- convert little-endian 32-bit int to a 4-char string
local function lei2str(i)
  local f=function (s) return char( bit_and( bit_rshift(i, s), 255)) end
  return f(0)..f(8)..f(16)..f(24)
end

-- convert raw string to big-endian int
local function str2bei(s)
  local v=0
  for i=1, #s do
    v = v * 256 + byte(s, i)
  end
  return v
end

-- convert raw string to little-endian int
local function str2lei(s)
  local v=0
  for i = #s,1,-1 do
    v = v*256 + byte(s, i)
  end
  return v
end

-- cut up a string in little-endian ints of given size
local function cut_le_str(s,...)
  local o, r = 1, {}
  local args = {...}
  for i=1, #args do
    table.insert(r, str2lei(sub(s, o, o + args[i] - 1)))
    o = o + args[i]
  end
  return r
end

local swap = function (w) return str2bei(lei2str(w)) end

-- An MD5 mplementation in Lua, requires bitlib (hacked to use LuaBit from above, ugh)
-- 10/02/2001 jcw@equi4.com

local CONSTS = {
  0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
  0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
  0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
  0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
  0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
  0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
  0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
  0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
  0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
  0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
  0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
  0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
  0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
  0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
  0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
  0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
  0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
}

local f=function (x,y,z) return bit_or(bit_and(x,y),bit_and(-x-1,z)) end
local g=function (x,y,z) return bit_or(bit_and(x,z),bit_and(y,-z-1)) end
local h=function (x,y,z) return bit_xor(x,bit_xor(y,z)) end
local i=function (x,y,z) return bit_xor(y,bit_or(x,-z-1)) end
local z=function (ff,a,b,c,d,x,s,ac)
  a=bit_and(a+ff(b,c,d)+x+ac,0xFFFFFFFF)
  -- be *very* careful that left shift does not cause rounding!
  return bit_or(bit_lshift(bit_and(a,bit_rshift(0xFFFFFFFF,s)),s),bit_rshift(a,32-s))+b
end

local function transform(A,B,C,D,X)
  local a,b,c,d=A,B,C,D
  local t=CONSTS

  a=z(f,a,b,c,d,X[ 0], 7,t[ 1])
  d=z(f,d,a,b,c,X[ 1],12,t[ 2])
  c=z(f,c,d,a,b,X[ 2],17,t[ 3])
  b=z(f,b,c,d,a,X[ 3],22,t[ 4])
  a=z(f,a,b,c,d,X[ 4], 7,t[ 5])
  d=z(f,d,a,b,c,X[ 5],12,t[ 6])
  c=z(f,c,d,a,b,X[ 6],17,t[ 7])
  b=z(f,b,c,d,a,X[ 7],22,t[ 8])
  a=z(f,a,b,c,d,X[ 8], 7,t[ 9])
  d=z(f,d,a,b,c,X[ 9],12,t[10])
  c=z(f,c,d,a,b,X[10],17,t[11])
  b=z(f,b,c,d,a,X[11],22,t[12])
  a=z(f,a,b,c,d,X[12], 7,t[13])
  d=z(f,d,a,b,c,X[13],12,t[14])
  c=z(f,c,d,a,b,X[14],17,t[15])
  b=z(f,b,c,d,a,X[15],22,t[16])

  a=z(g,a,b,c,d,X[ 1], 5,t[17])
  d=z(g,d,a,b,c,X[ 6], 9,t[18])
  c=z(g,c,d,a,b,X[11],14,t[19])
  b=z(g,b,c,d,a,X[ 0],20,t[20])
  a=z(g,a,b,c,d,X[ 5], 5,t[21])
  d=z(g,d,a,b,c,X[10], 9,t[22])
  c=z(g,c,d,a,b,X[15],14,t[23])
  b=z(g,b,c,d,a,X[ 4],20,t[24])
  a=z(g,a,b,c,d,X[ 9], 5,t[25])
  d=z(g,d,a,b,c,X[14], 9,t[26])
  c=z(g,c,d,a,b,X[ 3],14,t[27])
  b=z(g,b,c,d,a,X[ 8],20,t[28])
  a=z(g,a,b,c,d,X[13], 5,t[29])
  d=z(g,d,a,b,c,X[ 2], 9,t[30])
  c=z(g,c,d,a,b,X[ 7],14,t[31])
  b=z(g,b,c,d,a,X[12],20,t[32])

  a=z(h,a,b,c,d,X[ 5], 4,t[33])
  d=z(h,d,a,b,c,X[ 8],11,t[34])
  c=z(h,c,d,a,b,X[11],16,t[35])
  b=z(h,b,c,d,a,X[14],23,t[36])
  a=z(h,a,b,c,d,X[ 1], 4,t[37])
  d=z(h,d,a,b,c,X[ 4],11,t[38])
  c=z(h,c,d,a,b,X[ 7],16,t[39])
  b=z(h,b,c,d,a,X[10],23,t[40])
  a=z(h,a,b,c,d,X[13], 4,t[41])
  d=z(h,d,a,b,c,X[ 0],11,t[42])
  c=z(h,c,d,a,b,X[ 3],16,t[43])
  b=z(h,b,c,d,a,X[ 6],23,t[44])
  a=z(h,a,b,c,d,X[ 9], 4,t[45])
  d=z(h,d,a,b,c,X[12],11,t[46])
  c=z(h,c,d,a,b,X[15],16,t[47])
  b=z(h,b,c,d,a,X[ 2],23,t[48])

  a=z(i,a,b,c,d,X[ 0], 6,t[49])
  d=z(i,d,a,b,c,X[ 7],10,t[50])
  c=z(i,c,d,a,b,X[14],15,t[51])
  b=z(i,b,c,d,a,X[ 5],21,t[52])
  a=z(i,a,b,c,d,X[12], 6,t[53])
  d=z(i,d,a,b,c,X[ 3],10,t[54])
  c=z(i,c,d,a,b,X[10],15,t[55])
  b=z(i,b,c,d,a,X[ 1],21,t[56])
  a=z(i,a,b,c,d,X[ 8], 6,t[57])
  d=z(i,d,a,b,c,X[15],10,t[58])
  c=z(i,c,d,a,b,X[ 6],15,t[59])
  b=z(i,b,c,d,a,X[13],21,t[60])
  a=z(i,a,b,c,d,X[ 4], 6,t[61])
  d=z(i,d,a,b,c,X[11],10,t[62])
  c=z(i,c,d,a,b,X[ 2],15,t[63])
  b=z(i,b,c,d,a,X[ 9],21,t[64])

  return bit_and(A+a,0xFFFFFFFF),bit_and(B+b,0xFFFFFFFF),
         bit_and(C+c,0xFFFFFFFF),bit_and(D+d,0xFFFFFFFF)
end

----------------------------------------------------------------

local function md5_update(self, s)
  self.pos = self.pos + #s
  s = self.buf .. s
  for ii = 1, #s - 63, 64 do
    local X = cut_le_str(sub(s,ii,ii+63),4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)
    assert(#X == 16)
    X[0] = table.remove(X,1) -- zero based!
    self.a,self.b,self.c,self.d = transform(self.a,self.b,self.c,self.d,X)
  end
  self.buf = sub(s, math.floor(#s/64)*64 + 1, #s)
  return self
end

local function md5_finish(self)
  local msgLen = self.pos
  local padLen = 56 - msgLen % 64

  if msgLen % 64 > 56 then padLen = padLen + 64 end

  if padLen == 0 then padLen = 64 end

  local s = char(128) .. rep(char(0),padLen-1) .. lei2str(bit_and(8*msgLen, 0xFFFFFFFF)) .. lei2str(math.floor(msgLen/0x20000000))
  md5_update(self, s)

  assert(self.pos % 64 == 0)
  return lei2str(self.a) .. lei2str(self.b) .. lei2str(self.c) .. lei2str(self.d)
end

----------------------------------------------------------------

function md5.new()
  return { a = CONSTS[65], b = CONSTS[66], c = CONSTS[67], d = CONSTS[68],
           pos = 0,
           buf = '',
           update = md5_update,
           finish = md5_finish }
end

function md5.tohex(s)
  return format("%08x%08x%08x%08x", str2bei(sub(s, 1, 4)), str2bei(sub(s, 5, 8)), str2bei(sub(s, 9, 12)), str2bei(sub(s, 13, 16)))
end

function md5.sum(s)
  return md5.new():update(s):finish()
end

function md5.sumhexa(s)
  return md5.tohex(md5.sum(s))
end

-- md5 library end


--
-- http library start
--

local http_ = loadstring("local a=require\"ffi\"local b,c,d,e,f=a.typeof,a.sizeof,a.cast,a.string,a.gc;local g=ui.new_checkbox;local h;do if not pcall(a.sizeof,\"SteamAPICall_t\")then a.cdef[[    typedef uint64_t SteamAPICall_t;    struct SteamAPI_callback_base_vtbl {            void(__thiscall *run1)(struct SteamAPI_callback_base *, void *, bool, uint64_t);            void(__thiscall *run2)(struct SteamAPI_callback_base *, void *);            int(__thiscall *get_size)(struct SteamAPI_callback_base *);    };    struct SteamAPI_callback_base {            struct SteamAPI_callback_base_vtbl *vtbl;            uint8_t flags;            int id;            uint64_t api_call_handle;            struct SteamAPI_callback_base_vtbl vtbl_storage[1];    };    ]]end;local i;local j;local k=b(\"struct SteamAPI_callback_base\")local l=c(k)local m=b(\"struct SteamAPI_callback_base[1]\")local n=b(\"struct SteamAPI_callback_base*\")local o=b(\"uintptr_t\")local p={}local q={}local function r(s)return tostring(tonumber(d(o,s)))end;local function t(self,u,v)self.api_call_handle=0;local w=r(self)local x=p[w]if x~=nil then xpcall(x,client.error_log,u,v)end;p[w]=nil;q[w]=nil end;local function y(self,u,v,z)if z==self.api_call_handle then t(self,u,v)end end;local function A(self,u)t(self,u,false)end;local function B(self)return l end;local function C(self)if self.api_call_handle~=0 then j(self,self.api_call_handle)self.api_call_handle=0;local w=r(self)p[w]=nil;q[w]=nil end end;pcall(a.metatype,k,{__gc=C,__index={cancel=C}})local D=d(\"void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)\",y)local E=d(\"void(__thiscall *)(struct SteamAPI_callback_base *, void *)\",A)local F=d(\"int(__thiscall *)(struct SteamAPI_callback_base *)\",B)function h(z,x)assert(z~=0)local G=m()local H=d(n,G)H.vtbl_storage[0].run1=D;H.vtbl_storage[0].run2=E;H.vtbl_storage[0].get_size=F;H.vtbl=H.vtbl_storage;H.api_call_handle=z;H.id=2101;local w=r(H)p[w]=x;q[w]=G;i(H,z)end;local function I(J,K,L)local M=client.find_signature(J,K)or error(\"signature not found\",2)return d(L,M)end;i=I(\"steam_api.dll\",\"\\x55\\x8B\\xEC\\x83\\x3D\\xCC\\xCC\\xCC\\xCC\\xCC\\x7E\\x0D\\x68\\xCC\\xCC\\xCC\\xCC\\xFF\\x15\\xCC\\xCC\\xCC\\xCC\\x5D\\xC3\\xFF\\x75\\x10\",\"void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)\")j=I(\"steam_api.dll\",\"\\x55\\x8B\\xEC\\xFF\\x75\\x10\\xFF\\x75\\x0C\",\"void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)\")client.set_event_callback(\"shutdown\",function()for w,N in pairs(q)do local H=d(n,N)C(H)end end)end;if not pcall(c,\"http_HTTPRequestHandle\")then a.cdef[[typedef uint32_t http_HTTPRequestHandle;typedef uint32_t http_HTTPCookieContainerHandle;enum http_EHTTPMethod {    k_EHTTPMethodInvalid,    k_EHTTPMethodGET,    k_EHTTPMethodHEAD,    k_EHTTPMethodPOST,    k_EHTTPMethodPUT,    k_EHTTPMethodDELETE,    k_EHTTPMethodOPTIONS,    k_EHTTPMethodPATCH,};struct http_ISteamHTTPVtbl {    http_HTTPRequestHandle(__thiscall *CreateHTTPRequest)(uintptr_t, enum http_EHTTPMethod, const char *);    bool(__thiscall *SetHTTPRequestContextValue)(uintptr_t, http_HTTPRequestHandle, uint64_t);    bool(__thiscall *SetHTTPRequestNetworkActivityTimeout)(uintptr_t, http_HTTPRequestHandle, uint32_t);    bool(__thiscall *SetHTTPRequestHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);    bool(__thiscall *SetHTTPRequestGetOrPostParameter)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);    bool(__thiscall *SendHTTPRequest)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);    bool(__thiscall *SendHTTPRequestAndStreamResponse)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);    bool(__thiscall *DeferHTTPRequest)(uintptr_t, http_HTTPRequestHandle);    bool(__thiscall *PrioritizeHTTPRequest)(uintptr_t, http_HTTPRequestHandle);    bool(__thiscall *GetHTTPResponseHeaderSize)(uintptr_t, http_HTTPRequestHandle, const char *, uint32_t *);    bool(__thiscall *GetHTTPResponseHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);    bool(__thiscall *GetHTTPResponseBodySize)(uintptr_t, http_HTTPRequestHandle, uint32_t *);    bool(__thiscall *GetHTTPResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint8_t *, uint32_t);    bool(__thiscall *GetHTTPStreamingResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint32_t, uint8_t *, uint32_t);    bool(__thiscall *ReleaseHTTPRequest)(uintptr_t, http_HTTPRequestHandle);    bool(__thiscall *GetHTTPDownloadProgressPct)(uintptr_t, http_HTTPRequestHandle, float *);    bool(__thiscall *SetHTTPRequestRawPostBody)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);    http_HTTPCookieContainerHandle(__thiscall *CreateCookieContainer)(uintptr_t, bool);    bool(__thiscall *ReleaseCookieContainer)(uintptr_t, http_HTTPCookieContainerHandle);    bool(__thiscall *SetCookie)(uintptr_t, http_HTTPCookieContainerHandle, const char *, const char *, const char *);    bool(__thiscall *SetHTTPRequestCookieContainer)(uintptr_t, http_HTTPRequestHandle, http_HTTPCookieContainerHandle);    bool(__thiscall *SetHTTPRequestUserAgentInfo)(uintptr_t, http_HTTPRequestHandle, const char *);    bool(__thiscall *SetHTTPRequestRequiresVerifiedCertificate)(uintptr_t, http_HTTPRequestHandle, bool);    bool(__thiscall *SetHTTPRequestAbsoluteTimeoutMS)(uintptr_t, http_HTTPRequestHandle, uint32_t);    bool(__thiscall *GetHTTPRequestWasTimedOut)(uintptr_t, http_HTTPRequestHandle, bool *pbWasTimedOut);};]]end;local O={get=a.C.k_EHTTPMethodGET,head=a.C.k_EHTTPMethodHEAD,post=a.C.k_EHTTPMethodPOST,put=a.C.k_EHTTPMethodPUT,delete=a.C.k_EHTTPMethodDELETE,options=a.C.k_EHTTPMethodOPTIONS,patch=a.C.k_EHTTPMethodPATCH}local P={[100]=\"Continue\",[101]=\"Switching Protocols\",[102]=\"Processing\",[200]=\"OK\",[201]=\"Created\",[202]=\"Accepted\",[203]=\"Non-Authoritative Information\",[204]=\"No Content\",[205]=\"Reset Content\",[206]=\"Partial Content\",[207]=\"Multi-Status\",[208]=\"Already Reported\",[250]=\"Low on Storage Space\",[226]=\"IM Used\",[300]=\"Multiple Choices\",[301]=\"Moved Permanently\",[302]=\"Found\",[303]=\"See Other\",[304]=\"Not Modified\",[305]=\"Use Proxy\",[306]=\"Switch Proxy\",[307]=\"Temporary Redirect\",[308]=\"Permanent Redirect\",[400]=\"Bad Request\",[401]=\"Unauthorized\",[402]=\"Payment Required\",[403]=\"Forbidden\",[404]=\"Not Found\",[405]=\"Method Not Allowed\",[406]=\"Not Acceptable\",[407]=\"Proxy Authentication Required\",[408]=\"Request Timeout\",[409]=\"Conflict\",[410]=\"Gone\",[411]=\"Length Required\",[412]=\"Precondition Failed\",[413]=\"Request Entity Too Large\",[414]=\"Request-URI Too Long\",[415]=\"Unsupported Media Type\",[416]=\"Requested Range Not Satisfiable\",[417]=\"Expectation Failed\",[418]=\"I\'m a teapot\",[420]=\"Enhance Your Calm\",[422]=\"Unprocessable Entity\",[423]=\"Locked\",[424]=\"Failed Dependency\",[424]=\"Method Failure\",[425]=\"Unordered Collection\",[426]=\"Upgrade Required\",[428]=\"Precondition Required\",[429]=\"Too Many Requests\",[431]=\"Request Header Fields Too Large\",[444]=\"No Response\",[449]=\"Retry With\",[450]=\"Blocked by Windows Parental Controls\",[451]=\"Parameter Not Understood\",[451]=\"Unavailable For Legal Reasons\",[451]=\"Redirect\",[452]=\"Conference Not Found\",[453]=\"Not Enough Bandwidth\",[454]=\"Session Not Found\",[455]=\"Method Not Valid in This State\",[456]=\"Header Field Not Valid for Resource\",[457]=\"Invalid Range\",[458]=\"Parameter Is Read-Only\",[459]=\"Aggregate Operation Not Allowed\",[460]=\"Only Aggregate Operation Allowed\",[461]=\"Unsupported Transport\",[462]=\"Destination Unreachable\",[494]=\"Request Header Too Large\",[495]=\"Cert Error\",[496]=\"No Cert\",[497]=\"HTTP to HTTPS\",[499]=\"Client Closed Request\",[500]=\"Internal Server Error\",[501]=\"Not Implemented\",[502]=\"Bad Gateway\",[503]=\"Service Unavailable\",[504]=\"Gateway Timeout\",[505]=\"HTTP Version Not Supported\",[506]=\"Variant Also Negotiates\",[507]=\"Insufficient Storage\",[508]=\"Loop Detected\",[509]=\"Bandwidth Limit Exceeded\",[510]=\"Not Extended\",[511]=\"Network Authentication Required\",[551]=\"Option not supported\",[598]=\"Network read timeout error\",[599]=\"Network connect timeout error\"}local function I(J,K,Q,R)local S=client.find_signature(J,K)or error(\"signature not found\",2)local M=d(\"uintptr_t\",S)if Q~=0 then M=M+Q end;for T=1,R do M=d(\"uintptr_t*\",M)[0]if M==nil then return error(\"signature not found\")end end;return M end;local function U()local V=I(\"client_panorama.dll\",\"\\xB9\\xCC\\xCC\\xCC\\xCC\\xE8\\xCC\\xCC\\xCC\\xCC\\x83\\x3D\\xCC\\xCC\\xCC\\xCC\\xCC\\x0F\\x84\",1,1)local W=d(\"uintptr_t*\",V)[11]if W==0 then return error(\"find_isteamhttp failed\")end;local X=d(\"struct http_ISteamHTTPVtbl**\",W)[0]if X==nil then return error(\"find_isteamhttp failed\")end;return W,X end;local function Y(Z,_)return function(...)return Z(_,...)end end;local a0=b([[struct {http_HTTPRequestHandle m_hRequest;uint64_t m_ulContextValue;bool m_bRequestSuccessful;int m_eStatusCode;uint32_t m_unBodySize;} *]])local a1=b([[struct {http_HTTPCookieContainerHandle m_hCookieContainer;}]])local a2=b(\"SteamAPICall_t[1]\")local a3=b(\"const char[?]\")local a4=b(\"uint8_t[?]\")local a5=b(\"unsigned int[?]\")local a6=b(\"bool[1]\")local a7,a8=U()local a9=Y(a8.CreateHTTPRequest,a7)local aa=Y(a8.SetHTTPRequestContextValue,a7)local ab=Y(a8.SetHTTPRequestNetworkActivityTimeout,a7)local ac=Y(a8.SetHTTPRequestHeaderValue,a7)local ad=Y(a8.SetHTTPRequestGetOrPostParameter,a7)local ae=Y(a8.SendHTTPRequest,a7)local af=Y(a8.DeferHTTPRequest,a7)local ag=Y(a8.PrioritizeHTTPRequest,a7)local ah=Y(a8.GetHTTPResponseHeaderSize,a7)local ai=Y(a8.GetHTTPResponseHeaderValue,a7)local aj=Y(a8.GetHTTPResponseBodySize,a7)local ak=Y(a8.GetHTTPResponseBodyData,a7)local al=Y(a8.ReleaseHTTPRequest,a7)local am=Y(a8.SetHTTPRequestRawPostBody,a7)local an=Y(a8.CreateCookieContainer,a7)local ao=Y(a8.ReleaseCookieContainer,a7)local ap=Y(a8.SetCookie,a7)local aq=Y(a8.SetHTTPRequestCookieContainer,a7)local ar=Y(a8.SetHTTPRequestUserAgentInfo,a7)local as=Y(a8.SetHTTPRequestRequiresVerifiedCertificate,a7)local at=Y(a8.SetHTTPRequestAbsoluteTimeoutMS,a7)local au=Y(a8.GetHTTPRequestWasTimedOut,a7)local av,aw,ax,tostring,tonumber,error,xpcall,setmetatable,type,pairs=client.log,client.delay_call,ui.get,tostring,tonumber,error,xpcall,setmetatable,type,pairs;local ay,az={},false;local aA=setmetatable({},{__mode=\"k\"})local aB=setmetatable({},{__mode=\"k\"})local aC={__index=function(aD,aE)local aF=aB[aD]if aF==nil then return end;aE=tostring(aE)if aF.m_hRequest~=0 then local aG=a5(1)if ah(aF.m_hRequest,aE,aG)then if aG~=nil then aG=aG[0]if aG==0 then return end;local aH=a4(aG)if ai(aF.m_hRequest,aE,aH,aG)then aD[aE]=e(aH,aG-1)return aD[aE]end end end end end,__metatable=false}local aI={__index={set_cookie=function(aJ,aK,aL,aE,N)local aM=aA[aJ]if aM==nil or aM.m_hCookieContainer==0 then return end;ap(aM.m_hCookieContainer,aK,aL,tostring(aE)..\"=\"..tostring(N))end},__metatable=false}local function aN(aM)if aM.m_hCookieContainer~=0 then ao(aM.m_hCookieContainer)aM.m_hCookieContainer=0 end end;local function aO(aF)if aF.m_hRequest~=0 then al(aF.m_hRequest)aF.m_hRequest=0 end end;local function aP(aQ,...)al(aQ)return error(...)end;local function aR(u,v)if u==nil then return end;local aF=a.cast(a0,u)local aS=tostring(aF.m_hRequest)local aT=v==false and aF.m_bRequestSuccessful;local aU=aF.m_eStatusCode;local aV={status=aU,status_message=P[aU]}if aF.m_hRequest~=0 then local aW=aF.m_unBodySize;if aT and aW>0 then local aH=a4(aW)if ak(aF.m_hRequest,aH,aW)then aV.body=e(aH,aW)end elseif not aT then local aX=a6()au(aF.m_hRequest,aX)aV.timed_out=aX~=nil and aX[0]==true end;aV.headers=setmetatable({},aC)aB[aV.headers]=aF end;local aY=ay[aS]if aY~=nil then ay[aS]=nil;az=true;xpcall(aY,client.error_log,aT,aV)az=false;aO(aF)end end;local function aZ(a_,aL,b0,aY)if type(b0)==\"function\"and aY==nil then aY=b0;b0={}end;b0=b0 or{}b0.network_timeout=b0.network_timeout or 10;b0.absolute_timeout=b0.absolute_timeout or 30;local b1=O[tostring(a_):lower()]if b1==nil then return error(\"invalid HTTP method\")end;if type(aY)~=\"function\"then return error(\"callback has to be a function\")end;local aQ=a9(b1,aL)if aQ==0 then return error(\"Failed to create HTTP request\")end;if type(b0.network_timeout)==\"number\"and b0.network_timeout>0 then if not ab(aQ,b0.network_timeout)then return aP(aQ,\"failed to set network_timeout\")end elseif b0.network_timeout~=nil then return aP(aQ,\"options.network_timeout has to be of type number and greater than 0\")end;if type(b0.absolute_timeout)==\"number\"and b0.absolute_timeout>0 then if not at(aQ,b0.absolute_timeout*1000)then return aP(aQ,\"failed to set absolute_timeout\")end elseif b0.absolute_timeout~=nil then return aP(aQ,\"options.absolute_timeout has to be of type number and greater than 0\")end;local b2=\"application/text\"if type(b0.headers)==\"table\"then for aE,N in pairs(b0.headers)do aE=tostring(aE)N=tostring(N)if aE:lower()==\"content-type\"then b2=N end;if not ac(aQ,aE,N)then return aP(aQ,\"failed to set header \"..aE)end end elseif b0.headers~=nil then return aP(aQ,\"options.headers has to be of type table\")end;if b0.body~=nil and b0.params~=nil then return aP(aQ,\"can only set options.body or options.params\")end;if type(b0.body)==\"string\"then local b3=b0.body:len()if not am(aQ,b2,a.cast(\"unsigned char*\",b0.body),b3)then return aP(aQ,\"failed to set post body\")end elseif b0.body~=nil then return aP(aQ,\"options.body has to be of type string\")end;if type(b0.params)==\"table\"then for aE,N in pairs(b0.params)do aE=tostring(aE)if not ad(aQ,aE,tostring(N))then return aP(aQ,\"failed to set parameter \"..aE)end end elseif b0.params~=nil then return aP(aQ,\"options.params has to be of type table\")end;if type(b0.require_ssl)==\"boolean\"then if not as(aQ,b0.require_ssl)then return aP(aQ,\"failed to set require_ssl\")end elseif b0.require_ssl~=nil then return aP(aQ,\"options.require_ssl has to be of type boolean\")end;if type(b0.user_agent_info)==\"string\"then if not ar(aQ,b0.user_agent_info)then return aP(aQ,\"failed to set user_agent_info\")end elseif b0.user_agent_info~=nil then return aP(aQ,\"options.user_agent_info has to be of type string\")end;if type(b0.cookie_container)==\"table\"then local aM=aA[b0.cookie_container]if aM~=nil and aM.m_hCookieContainer~=0 then if not aq(aQ,aM.m_hCookieContainer)then return aP(aQ,\"failed to set user_agent_info\")end else return aP(aQ,\"options.cookie_container has to a valid cookie container\")end elseif b0.cookie_container~=nil then return aP(aQ,\"options.cookie_container has to a valid cookie container\")end;local b4=a2()if not ae(aQ,b4)then al(aQ)return aY(false,{})end;if b0.priority==\"defer\"or b0.priority==\"prioritize\"then local Z=b0.priority==\"prioritize\"and ag or af;if not Z(aQ)then return aP(aQ,\"failed to set priority\")end elseif b0.priority~=nil then return aP(aQ,\"options.priority has to be \'defer\' of \'prioritize\'\")end;ay[tostring(aQ)]=aY;h(b4[0],aR)end;local function b5(b6)if b6~=nil and type(b6)~=\"boolean\"then return error(\"allow_modification has to be of type boolean\")end;local b7=an(b6==true)if b7~=nil then local aM=a1(b7)f(aM,aN)local w=setmetatable({},aI)aA[w]=aM;return w end end;local b8={request=aZ,create_cookie_container=b5}for a_ in pairs(O)do b8[a_]=function(...)return aZ(a_,...)end end;return b8")
local http = http_()

--
-- http library end
--

--
-- custom encryption start
--

local static_key = 812934
local random_key = client.random_int(100000, 999999)

local inv256

local function encrypt(str, key1, key2)
  if not inv256 then
    inv256 = {}
    for M = 0, 127 do
      local inv = -1
      repeat inv = inv + 2
      until inv * (2*M + 1) % 256 == 1
      inv256[M] = inv
    end
  end
  local K, F = key1, 57864 + key2
  return (str:gsub('.',
    function(m)
      local L = K % 274877906944
      local H = (K - L) / 274877906944
      local M = H % 128
      m = m:byte()
      local c = (m * inv256[M] - (H - M) / 128) % 256
      K = L * F + H + c + m
      return ('%02x'):format(c)
    end
  ))
end

local function decrypt(str, key1, key2)
  local K, F = key1, 57864 + key2
  return (str:gsub('%x%x',
    function(c)
      local L = K % 274877906944
      local H = (K - L) / 274877906944
      local M = H % 128
      c = tonumber(c, 16)
      local m = (c + (H - M) / 128) * (2*M + 1) % 256
      K = L * F + H + c + m
      return string.char(m)
    end
  ))
end

--
-- custom encryption end
--

local ffi_cast = ffi.cast

ffi.cdef [[
typedef int(__thiscall* get_clipboard_text_count)(void*);
typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

--[ VGUI_System ]--
local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi_cast( ffi.typeof( "void***" ), VGUI_System010 )

local get_clipboard_text_count = ffi_cast( "get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi_cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi_cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")
--[ VGUI_System ]--

-- library functions start

local atelier_api = 'http://175.27.187.40:4755/atelier'
local atelier_version = 'http://175.27.187.70:4755/version'

--local atelier_api = 'http://localhost:4755/atelier'
--local atelier_version = 'http://localhost:4755/version'

local request_type = {
    get_list = '100',
    get_lua = '200',
    get_config = '300',

    upload_config = '400'
}

local response_status = {
    BAD_PARAMETERS = '400',
    BAD_REQUEST = '401',
    INVALID_SIGNATURE = '402',
    INTERNAL_ERROR = '403',

    USER_UNKNOWN = '500',
    USER_WRONG_PASSWORD = '501',
    USER_WRONG_HWID = '502',
    USER_BANNED = '503',
    REQUEST_NOT_ALLOWED = '504',

    SCRIPT_UNKNOWN = '600',
    CONFIG_UNKNOWN = '601',

    REQUEST_RECEIVED = '700'
}

local function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local extra_log = function(...)
    client.color_log(0, 255, 255, "[ VEL Loader ] \0")
    local data = { ... }

    for i=1, #data do
        client.color_log(data[i][1], data[i][2], data[i][3],  string.format('%s\0', data[i][4]))

        if i == #data then
            client.color_log(255, 255, 255, ' ')
        end
    end
end

local function print_information()
    local changelog = split(information.changelog, "\n")
    local news = split(information.news, "\n")

    client.color_log(0, 255, 255, "[ VEL Loader ] \0")
    client.color_log(0, 255, 0, "Latest changelog: ")

    for i, v in pairs(changelog) do
        if(v ~= '') then
            client.color_log(0, 255, 255, "               - \0")
            client.color_log(255, 255, 255, v)
        end
    end

    client.color_log(0, 255, 255, "[ VEL Loader ] \0")
    client.color_log(0, 255, 0, "Latest news: ")

    for i, v in pairs(news) do
        if(v ~= '') then
            client.color_log(0, 255, 255, "               - \0")
            client.color_log(255, 255, 255, v)
        end
    end
end

local create_safe_callback = function(name, func)
    local get_func_index = function(fn)
        return ffi.cast("int*", ffi.cast(ffi.typeof("void*(__thiscall*)(void*)"), fn))[0]
    end

    local DEC_HEX = function(IN)
        local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
        while IN>0 do
            I=I+1
            IN,D=math.floor(IN/B),math.fmod(IN,B)+1
            OUT=string.sub(K,D,D)..OUT
        end
        return OUT
    end

    extra_log({ 255, 255, 255, 'Creating safe ' }, { 0, 255, 255, name .. ' ' }, { 255, 255, 255, 'callback ' }, { 0, 255, 255, string.format('(0x%s)', DEC_HEX(get_func_index(func))) })

    client.delay_call(0.1, function()
        client.set_event_callback(name, func)
    end)
end

local function set_clipboard(content)
    set_clipboard_text(VGUI_System, content, content:len())
end

local function md5_encode(string)
    local m = md5.new()
    m:update(string)
    return md5.tohex(m:finish())
end

local function generateHWID()
    if not exec_existfl(fs_raw, "pak02_005.vpk", "DEFAULT_WRITE_PATH") then
        write_file("pak02_005.vpk", "DEFAULT_WRITE_PATH", md5_encode(randomString(32)))
        client.delay_call(1.2, generateHWID)
    else
        return read_file("pak02_005.vpk", "DEFAULT_WRITE_PATH")
    end
end
generateHWID()

local hwid = generateHWID()

local function trim(str)
    return (string.gsub(str, "^[%s\n\r\t]*(.-)[%s\n\r\t]*$", "%1"))
end

local function is_file_exist(name)
    return (function(filename) return package.searchpath("", filename) == filename end)("./" .. name)
end


local creds_name = "VEL.creds"
local function read_creds()
    if not(is_file_exist(creds_name)) then
        extra_log({255, 255, 255, "VEL.creds"}, {255, 0, 0, " file doesn't exisit, exiting ..."})
        return nil
    end

    local data = split(readfile(creds_name), "\n")

    local info = {
        username = trim(data[1]),
        password = data[2]
    }

    return info
end

local function generate_signature(request_type, userinfo)
    return md5_encode(userinfo.username .. ":" .. request_type .. ":" .. userinfo.password .. ":" .. "SIGNATURE" .. ":" .. hwid .. ":" .. vel.start_time)
end

local function check_response(body)
    if(body == response_status.BAD_PARAMETERS) then
        extra_log({255, 0, 0, 'Bad request during sending request, are you trying to crack VEL loader? lol.'})
        return false
    elseif(body == response_status.BAD_REQUEST) then
        extra_log({255, 0, 0, 'Bad request during sending request, are you trying to crack VEL loader? lol.'})
        return false
    elseif(body == response_status.INVALID_SIGNATURE) then
        extra_log({255, 0, 0, 'Bad request during sending request, are you trying to crack VEL loader? lol.'})
        return false
    elseif(body == response_status.USER_UNKNOWN) then
        extra_log({255, 0, 0, 'User doesn\'t exist. Invalid VEL.creds ?'})
        return false
    elseif(body == response_status.USER_WRONG_PASSWORD) then
        extra_log({255, 0, 0, 'Invalid VEL.creds.'})
        return false
    elseif(body == response_status.USER_WRONG_HWID) then
        extra_log({255, 0, 0, 'Invalid Hardware ID. Send a request to administrator to reset your hwid.'})
        return false
    elseif(body == response_status.USER_BANNED) then
        extra_log({255, 0, 0, 'User is banned.'})
        return false
    elseif(body == response_status.SCRIPT_UNKNOWN) then
        extra_log({255, 0, 0, 'Script requested is unknown, please try reloading the VEL loader.'})
        return false
    elseif(body == response_status.INTERNAL_ERROR)then
        extra_log({255, 0, 0, 'Occurred an error in the server side. (Internal Server Error)'})
        return false
    elseif(body == response_status.CONFIG_UNKNOWN) then
        extra_log({255, 0, 0, 'No available config for your role.'})
        return false
    elseif(body == response_status.REQUEST_NOT_ALLOWED) then
        return false
    elseif(body == response_status.REQUEST_RECEIVED) then
        return true
    else
        return true
    end
end

local function generate_getversion_parameters()
    local options = {
        network_timeout = 8,
        absolute_timeout = 20,
        priority = 'prioritize',
    }

    return options
end

local function security_check()
    return false
end

local function generate_getlist_parameters(userinfo)
    local options = {
        network_timeout = 8,
        absolute_timeout = 20,
        priority = 'prioritize',
        user_agent_info = "",
    
        params = {
            ["request"] = request_type.get_list,
            ["username"] = userinfo.username,
            ["password"] = userinfo.password,
            ["hwid"] = generateHWID(),
            ["time"] = vel.start_time,
            ["signature"] = generate_signature(request_type.get_list, userinfo),
            ["key"] = random_key,
        }
    }

    if (security_check()) then
        options.user_agent_info = "yes"
    else
        options.user_agent_info = "no"
    end


    return options
end

local function isloaded(scriptname)
    for i,v in pairs(loaded_lualist) do
        if(v == scriptname) then return true end
    end

    return false
end

local function generate_getscript_parameters(userinfo, scriptname)
    local options = {
        network_timeout = 8,
        absolute_timeout = 20,
        priority = 'defer',
    
        params = {
            ["request"] = request_type.get_lua,
            ["username"] = userinfo.username,
            ["password"] = userinfo.password,
            ["hwid"] = generateHWID(),
            ["time"] = vel.start_time,
            ["script"] = scriptname,
            ["signature"] = generate_signature(request_type.get_lua, userinfo),
            ["key"] = random_key,
        }
    }

    if (security_check()) then
        options.user_agent_info = "yes"
    else
        options.user_agent_info = "no"
    end

    return options
end

local function generate_getconfig_parameters(userinfo)
    local options = {
        network_timeout = 8,
        absolute_timeout = 20,
        priority = 'defer',

        params = {
            ["request"] = request_type.get_config,
            ["username"] = userinfo.username,
            ["password"] = userinfo.password,
            ["hwid"] = generateHWID(),
            ["time"] = vel.start_time,
            ["signature"] = generate_signature(request_type.get_config, userinfo),
            ["key"] = random_key,
        }
    }

    if (security_check()) then
        options.user_agent_info = "yes"
    else
        options.user_agent_info = "no"
    end

    return options
end

local function generate_uploadconfig_parameters(userinfo)
    local parameters = {
        ["request"] = request_type.upload_config,
        ["username"] = userinfo.username,
        ["password"] = userinfo.password,
        ["hwid"] = generateHWID(),
        ["time"] = vel.start_time,
        ["signature"] = generate_signature(request_type.upload_config, userinfo),
        ["config"] = config.export()
    }

    local options = {
        network_timeout = 8,
        absolute_timeout = 20,
        priority = 'defer',

        body = json.stringify(parameters)
    }

    if (security_check()) then
        options.user_agent_info = "yes"
    else
        options.user_agent_info = "no"
    end

    return options
end

local function loadscript(scriptname)
    if(scriptname == '') then return end

    loaded_lualist[table.getn(loaded_lualist) + 1] = scriptname

    extra_log({255, 255, 255, "Attempt to load "},
              {0, 255, 255, scriptname},
              {255, 255, 255, " from VEL server."})
    
    http.request('GET', atelier_api, generate_getscript_parameters(userinfo, scriptname), function(success, response)
        if not(success) then
            extra_log({255, 0, 0, "Failed to load script "},
                      {255, 255, 255, scriptname},
                      {255, 0, 0, " due to unknown reason."})
            return
        end

        if(check_response(response.body) == false) then
            extra_log({255, 0, 0, "An error occured during loading script "},
                    {255, 255, 255, scriptname},
                    {255, 0, 0, " from VEL server."})
            return
        end

        local status, error = pcall(function()
            -- Check x2
            if not(security_check()) then
                loadstring(base64_decode(decrypt(response.body, static_key, random_key)))()
            end
            return true
        end)

        if(status) then
            extra_log({0, 255, 255, scriptname},
                     {255, 255, 255, " is successfully loaded from VEL server."})

            config_needs_load = true
        else
            extra_log({255, 0, 0, "An error occured during loading script "},
                    {255, 255, 255, scriptname},
                    {255, 0, 0, " from VEL server."})
            return
            print(error)
        end
    end)
end

local function loadconfig()
    if not exec_existfl(fs_raw, "vel.cfg", "DEFAULT_WRITE_PATH") then
        return ''
    else
        local data = split(read_file("vel.cfg", "DEFAULT_WRITE_PATH"), "\n")


        for i,v in pairs(data) do
            if not(v == '' or v == ' ') then
                data[i] = trim(v)
            end
        end

        return data
    end
end

local function saveconfig(enabled)
    local data = ""
    
    for i,v in pairs(enabled) do
        data = data .. v .. "\n"
    end
    
    write_file("vel.cfg", "DEFAULT_WRITE_PATH", data)
end

if not exec_existfl(fs_raw, "vel.cfg", "DEFAULT_WRITE_PATH") then
    write_file("vel.cfg", "DEFAULT_WRITE_PATH", "")
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local function is_include(table, value)
    for i,v in pairs(table) do
        if(v == value) then return true end
    end

    return false
end

local function check_success(success, timed_out)
    if not(success) then
        if(timed_out ~= nil) then
            extra_log({255, 0, 0, 'Failed to connect to the server due to timed out, please try again.'})
            return false
        else
            extra_log({255, 0, 0, 'Failed to connect to the server, please try again.'})
            return false
        end
    else
        return true
    end
end

local function upload_config()
    http.request('POST', atelier_api, generate_uploadconfig_parameters(userinfo), function(success, response)
        if not(check_success(success, response.timed_out)) then
            return
        end

        if(check_response(response.body) == false) then
            return
        end

        extra_log({0, 255, 0, "Successfully uploaded the config to the server for your role."})
    end)
end

-- library functions end

-- read creds

local creds = read_creds()

if(creds == nil) then return end

userinfo.username = creds.username
userinfo.password = creds.password

if(userinfo == nil) then
    return
end

-- menu items start

header = ui.new_label('CONFIG', 'Presets', "〓〓〓〓〓〓〓〓 VEL Loader 〓〓〓〓〓〓〓〓")

local menu_items =  {
    username = ui.new_label('CONFIG', 'Presets', ' '),
    role = ui.new_label('CONFIG', 'Presets', ' '),
    scripts_loaded = ui.new_label('CONFIG', 'Presets', ' '),
    last_config_update = ui.new_label('CONFIG', 'Presets', ' '),
    upload_config = ui.new_button('CONFIG', 'Presets', 'Upload config', upload_config),
    footer = ui.new_label('CONFIG', 'Presets', "〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓"),
}

local function set_visible(boolean)
    for i, v in pairs(menu_items) do
        if not(v == nil) then
            if not(ui.name(v) == 'Upload config') then
                ui.set_visible(v, boolean)
            end
        end
    end
end

set_visible(false)
ui.set_visible(menu_items.upload_config, false)

-- menu items end

-- online config loading=
local function get_config()
    http.request('GET', atelier_api, generate_getconfig_parameters(userinfo), function(success, response)
        if not(check_success(success, response.timed_out)) then
            return
        end

        if(check_response(response.body) == false) then
            return
        end

        local status, data = pcall(function()
            return decrypt(response.body, random_key, static_key)
        end)

        if(status) then
            config_text = data
        else
            extra_log({255, 0, 0, 'An error occurred during decrypting role config text from server.'})
            return
        end
    end)
end

local function get_lualist()

    -- lua scripts list getting

    http.request('GET', atelier_api, generate_getlist_parameters(userinfo), function(success, response)
        if not(check_success(success, response.timed_out)) then
            return
        end

        if(check_response(response.body) == false) then
            return
        end

        local data = split(decrypt(response.body, static_key, random_key), "\n")
        local json_data = json.parse(data[1])

        userinfo.role = json_data["role"]
        userinfo.owned_role = json_data["ownedRole"]

        information.changelog = json_data["changelog"]
        information.news = json_data["news"]
        information.last_config_update = json_data["configLastUpdate"]

        print_information()

        if(userinfo.owned_role == userinfo.role) then
            userinfo.role = userinfo.role .. " (Owner)"
        end

        for i, v in pairs(data) do
            if(i ~= 1) then
                lualist[i - 1] = v
            end
        end

        ui.set(menu_items.username, "| Username: " .. userinfo.username)
        ui.set(menu_items.role, "| Role: " .. firstToUpper(userinfo.role))
        ui.set(menu_items.scripts_loaded, "| " ..  table.getn(lualist) .. " script(s) loaded.")
        ui.set(menu_items.last_config_update, "| Last config update: " .. information.last_config_update)

        set_visible(true)

        if(json_data["role"] == json_data["ownedRole"]) then
            ui.set_visible(menu_items.upload_config, true)
        end

        menu_items.scripts = ui.new_multiselect('CONFIG', 'Presets', '| VEL Scripts', lualist)

        local enabled = loadconfig()
        ui.set(menu_items.scripts, enabled)

        package.vel_username = userinfo.username
        package.vel_version = vel.version

        local function load_scripts()
            local enabled_scripts = ui.get(menu_items.scripts)
            for _,v  in pairs(enabled_scripts) do
                if not(isloaded(v)) then
                    if(is_include(lualist, v)) then
                        loadscript(v)
                    end
                end
            end

            saveconfig(enabled_scripts)
        end

        -- handle the callback
        ui.set_callback(menu_items.scripts, load_scripts)
        get_config()
        load_scripts()
    end)
end

-- vel loader version checking start

extra_log({255, 255, 255, "Attempt to check loader version ..."})

http.request('GET', atelier_version, generate_getversion_parameters(), function(success, response)
    if not(check_success(success, response.timed_out)) then
        return
    end

    if(response.body == vel.version) then
        extra_log({255, 255, 255, "VEL Loader is the "},
                  {0, 255, 0, "latest"},
                  {255, 255, 255, " version"})

        client.exec("clear")

        get_lualist()
    else
        extra_log({255, 0, 0, "VEL Loader is outdated, please download the latest loader!"})
    end
end)

-- vel loader version checking end

-- config load period

local function check_and_loadconfig()
    if(config_needs_load and config_text ~= nil) then
        -- Load online config
        set_clipboard(config_text)

        ui.set(references.import_from_clipboard, true)

        set_clipboard('')
        extra_log({255, 255, 255, "Config is "},
                {0, 255, 0, "loaded"},
                {255, 255, 255, " from VEL server."})
        --

        config_needs_load = false
    end

    client.delay_call(3, check_and_loadconfig)
end

check_and_loadconfig()

--

-- getting end

-- watermark thing
local wm                  = ui.new_label('LUA', 'B', 'Watermark Color')
local wm_color               = ui.new_color_picker('LUA', 'B', 'wm_color', 255, 255, 255, 255)
local wm_bg                  = ui.new_label('LUA', 'B', 'Watermark Background Color')
local wm_bg_color            = ui.new_color_picker('LUA', 'B', 'bg_Color',   0, 112, 255, 255)

local screenx,screeny = client.screen_size()

local slider_x               = ui.new_slider('LUA', 'B', 'Watermark: X Position', 0, screenx, 1697, true, "px")
local slider_y               = ui.new_slider('LUA', 'B', 'Watermark: Y Position', 0, screeny, 12, true, "px")

local interface_ptr = ffi.typeof('void***')
local latency_ptr = ffi.typeof('float(__thiscall*)(void*, int)')
local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
local ivengineclient = ffi.cast(interface_ptr, rawivengineclient) or error('rawivengineclient is nil', 2)
local get_net_channel_info = ffi.cast('void*(__thiscall*)(void*)', ivengineclient[0][78]) or error('ivengineclient is nil')
local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')
local notes = (function(b)local c=function(d,e)local f={}for g in pairs(d)do table.insert(f,g)end;table.sort(f,e)local h=0;local i=function()h=h+1;if f[h]==nil then return nil else return f[h],d[f[h]]end end;return i end;local j={get=function(k)local l,m=0,{}for n,o in c(package.cnotes)do if o==true then l=l+1;m[#m+1]={n,l}end end;for p=1,#m do if m[p][1]==b then return k(m[p][2]-1)end end end,set_state=function(q)package.cnotes[b]=q;table.sort(package.cnotes)end,unset=function()client.unset_event_callback('shutdown',callback)end}client.set_event_callback('shutdown',function()if package.cnotes[b]~=nil then package.cnotes[b]=nil end end)if package.cnotes==nil then package.cnotes={}end;return j end)('a_watermark')

local g_paint_watermark = function()
    if(userinfo.role == '') then return end

	notes.set_state(true)
    notes.get(function(id)
        local sys_time = { client.system_time() }
        local actual_time = string.format('%02d:%02d:%02d', sys_time[1], sys_time[2], sys_time[3])

        local text = string.format('VEL | %s | %s | %s', userinfo.username, firstToUpper(userinfo.role), actual_time)

        if is_in_game(is_in_game) == true then
            local INetChannelInfo = ffi.cast(interface_ptr, get_net_channel_info(ivengineclient)) or error('netchaninfo is nil')
            local get_avg_latency = ffi.cast(latency_ptr, INetChannelInfo[0][10])
            local latency = get_avg_latency(INetChannelInfo, 0) * 1000
            local tick = 1/globals.tickinterval()

            text = string.format('VEL | %s | %s | delay: %dms | %dtick | %s', userinfo.username, firstToUpper(userinfo.role), latency, tick, actual_time)
        end

        local r1, g1, b1, a1 = ui.get(wm_color)
		local r2, g2, b2, a2 = ui.get(wm_bg_color)
        local h, w = 18, renderer.measure_text(nil, text) + 8
        local x, y = client.screen_size(), 10 + (25*id)

        x = x - w - 10

		renderer.gradient(ui.get(slider_x) + 1, ui.get(slider_y) -1, w + 2, 2, r2, g2, b2, 255, r2, g2, b2, 255, false)
		renderer.gradient(ui.get(slider_x) + 1, ui.get(slider_y) -1, 2, h, r2, g2, b2, 255, r2, g2, b2, 0, false)
		renderer.gradient(ui.get(slider_x) + 1 + w, ui.get(slider_y) -1, 2, h, r2, g2, b2, 255, r2, g2, b2, 0, false)
		renderer.rectangle(ui.get(slider_x) + 2, ui.get(slider_y), w, h, 20, 20, 20, 155) 
    	renderer.text(ui.get(slider_x) + 5, 2 + ui.get(slider_y), r1, g1, b1, a1, '', 0, text)
    end)
end

client.delay_call(10, function()
    create_safe_callback("paint_ui", g_paint_watermark)
end)