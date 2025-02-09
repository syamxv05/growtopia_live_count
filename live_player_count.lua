local http = require("socket.http")
local ltn12 = require("ltn12")

local oldCounter = 0
local checkInterval = 10 -- Interval dalam detik
local server_url = "https://growtopiagame.com/detail"
local link = "https://discord.com/api/webhooks/1324656544570408980/b0LyD6EyZzpj395zUG9hE3GlaGCFdCbZBMk6Q9Vo-_d02Oq6lfj9dWOq1LjSf2yN5p1S" -- Gantilah dengan link webhook Anda
local discordUserId = "your_discord_user_id" -- Gantilah dengan ID pengguna Discord Anda untuk tag selama BW

function wh(msg)
  local body = string.format('{"content": "[Player Count] %s"}', msg)
  local response_body = {}
  http.request{
    url = link,
    method = "POST",
    headers = {
      ["Content-Type"] = "application/json",
      ["Content-Length"] = #body
    },
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response_body)
  }
end

wh("Player Count script started!\nCheck Interval: " .. checkInterval .. " second(s)")

while true do
  local response_body = {}
  local _, code = http.request{
    url = server_url,
    sink = ltn12.sink.table(response_body)
  }

  if code == 200 then
    local respond = table.concat(response_body)
    local player_count = respond:match('"online_user":"(%d+)"')
    player_count = tonumber(player_count)
    local player_difference = player_count - oldCounter
    oldCounter = player_count

    local player_difference_sym = player_difference >= 0 and "+" or "-"
    local abs_player_difference = math.abs(player_difference)

    if player_difference_sym == "-" then
      wh("<t:"..os.time()..":T> "..player_count.." | (**"..player_difference_sym..abs_player_difference.."**) | <@"..discordUserId..">")
    else
      wh("<t:"..os.time()..":T> "..player_count.." | (**"..player_difference_sym..abs_player_difference.."**)")
    end
  else
    print("HTTP request failed with code: " .. code)
  end

  sleep(checkInterval * 1000) -- Mengkonversi detik ke milidetik
end
