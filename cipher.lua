local VEL_public = {}
local VEL_INV_256

function VEL_public.encrypt(str, key1, key2)
  if not VEL_INV_256 then
    VEL_INV_256 = {}
    for M = 0, 127 do
      local inv = -1
      repeat inv = inv + 2
      until inv * (2*M + 1) % 256 == 1
      VEL_INV_256[M] = inv
    end
  end
  local K, F = key1, 57864 + key2
  return (str:gsub('.',
    function(m)
      local L = K % 274877906944
      local H = (K - L) / 274877906944
      local M = H % 128
      m = m:byte()
      local c = (m * VEL_INV_256[M] - (H - M) / 128) % 256
      K = L * F + H + c + m
      return ('%02x'):format(c)
    end
  ))
end

function VEL_public.decrypt(str, key1, key2)
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
return VEL_public