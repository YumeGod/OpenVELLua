local duration = 100
local CookingHack_enabled = ui.new_checkbox("MISC", "Miscellaneous", "Nai Clantag")
local clantags = {"✿❀", "❀N✿", "✿Na❀", "❀Nai✿", "✿Nai❤❀", "❀Nai♡C✿", "✿Nai❤CF❀", "❀Nai♡CFG✿", "✿Nai❤CF❀", "❀Nai♡C✿", "✿Nai❤❀", "❀Nai✿", "✿Na❀", "❀N✿", "✿❀", "❀♡✿", "✿❤❀", }
local clantag_prev
client.set_event_callback("run_command", function()
  local cur = math.floor(globals.tickcount() / duration) % #clantags
  local clantag = clantags[cur+1]

  if clantag ~= clantag_prev then
    clantag_prev = clantag
    client.set_clan_tag(clantag)
  end
end)