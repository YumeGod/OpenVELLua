local notify = require "notify"

-- NOTIFICATION LISTENER
client.set_event_callback("paint", function()
    notify:listener()
end)

local vote_option = { }
local current_tickcount = globals.tickcount()

client.set_event_callback("vote_options", function(c)
    vote_option[0] = c.option1
    vote_option[1] = c.option2
    vote_option[2] = c.option3
    vote_option[3] = c.option4
    vote_option[4] = c.option5

    current_tickcount = globals.tickcount()
end)


client.set_event_callback("vote_cast", function(event)
    if event.entityid ~= nil then
        local nick = entity.get_player_name(event.entityid)
        local team_name = "[SP] "

        if event.team == 3 then
            team_name = "[CT] "
        elseif event.team == 2 then
            team_name = "[T] "
        end

        if vote_option[event.vote_option] == nil then
            return
        end

        local current_vote = vote_option[event.vote_option]
        local text = team_name .. string.sub(nick, 0, 12) .. ": voted " .. vote_option[event.vote_option]

        client.log(text)

        if current_vote == "No" then notify.setup_color({ 255, 0, 0 }) end
        notify.add(15, true, { 255, 255, 255, team_name }, { 150, 185, 1, string.sub(nick, 0, 12) }, { 255, 255, 255, ": voted " }, { 25, 118, 210, vote_option[event.vote_option] } )
    end
end)