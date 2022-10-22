local r_aspectratio = cvar.r_aspectratio
local process_ticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")

local db = {
    { 
        'cr_ucmd', 0, function(value, shutdown)
            if value ~= 0 then
                ui.set(process_ticks, value)
            end
        end
    },

    { 
        'cr_aspratio', 0, function(value, shutdown)
            r_aspectratio:set_float(shutdown and 0 or value)
        end
    },
}

for i=1, #db do
    db[i][2] = (database.read(db[i][1]) or db[i][2])
end

local self_call = function(live)
    for i=1, #db do db[i][3](db[i][2], not live) end
end

(function(fn) 
    local func = nil; 
    func = function() fn(); 
        client.delay_call(globals.tickinterval()*1, func)
    end client.delay_call(globals.tickinterval()*1, func) end
)(function() self_call(true) end)

client.set_event_callback("shutdown", self_call)
client.set_event_callback("console_input", function(e)
    local split = function(pString, pPattern)
        local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
        local fpat = "(.-)" .. pPattern
        local last_end = 1
        local s, e, cap = pString:find(fpat, 1)
    
        while s do
            if s ~= 1 or cap ~= "" then
                table.insert(Table,cap)
            end
            last_end = e+1
            s, e, cap = pString:find(fpat, last_end)
        end
    
        if last_end <= #pString then
            cap = pString:sub(last_end)
            table.insert(Table, cap)
        end
    
        return Table
    end
    
    local console_data = split(e, " ")
    local value = console_data[2]

    for i=1, #db do
        local cdb = db[i]

        if console_data[1] == cdb[1] then
            if value then
                db[i][2] = value
                database.write(cdb[1], db[i][2])
            else
                client.color_log(83, 126, 242, "[" .. cdb[1] .. "]\0")
                client.color_log(163, 163, 163, " ", "current value: " .. db[i][2])
            end
    
            return true
        end 
    end
end)