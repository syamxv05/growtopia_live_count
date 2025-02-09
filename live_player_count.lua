local server = HttpClient.new()
local oldCounter = 0
local checkInterval = 10 -- Interval dalam detik
server.url = "https://growtopiagame.com/detail"
local link = "your_webhook_link" -- Gantilah dengan link webhook Anda
local discordUserId = "your_discord_user_id" -- Gantilah dengan ID pengguna Discord Anda untuk tag selama BW

function wh(msg)
  local wbh = Webhook.new(link)
  wbh.content = "[Player Count] " .. msg
  wbh:send()
end

wh("Player Count script started!\nCheck Interval: " .. checkInterval .. " second(s)")

while true do
  local respond = server:request().body
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

  sleep(checkInterval * 1000) -- Mengkonversi detik ke milidetik
end
