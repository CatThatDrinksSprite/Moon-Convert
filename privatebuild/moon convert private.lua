local whitelistdata = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/privatebuild/whitelist.json", true))
local possible = {}

for index, asset in pairs(game:GetService("Players"):GetPlayers()) do
  if asset.UserId ~= game.Players.LocalPlayer.UserId then
    if whitelistdata[tostring(asset.UserId)] then
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("meow")
    end
  end
end

game:GetService("Players").PlayerAdded:Connect(function(asset)
  if asset.UserId ~= game.Players.LocalPlayer.UserId then
      if whitelistdata[tostring(asset.UserId)] then
          task.wait(10)
          game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("meow")
      end
    end
end)

game:GetService("TextChatService").OnIncomingMessage = function(msg)
  if not msg or msg.TextSoruce then return end

  local Player = game:GetService("Players"):GetPlayerByUserId(msg.TextSource.UserId)
  local Text = msg.Text
  local prefix = msg.PrefixText
  local props = Instance.new("TextChatMessageProperties")

  if Text == "meow" then
    if whitelistdata[tostring(Player.UserId)] then return end
    if table.find(possible, Player) then return end
    table.insert(possible, Player)
  end

  if table.find(possible, Player) then
    props.PrefixText = "<font color='rgb(0, 0, 255)'>[POSSIBLE MOON CONVERT USER]</font> " .. prefix
  end

  if Player.UserId ~= game.Players.LocalPlayer.UserId then
    if whitelistdata[tostring(asset.UserId)] then
      if Text:lower():sub(1, 13) == "-kill default" then
        game.Players.LocalPlayer.Humanoid:ChangeState(15)
      end
    end
  end
  return props
end
