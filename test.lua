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
local rdmstr = randomString(8)
print(rdmstr)