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
  if not msg or not msg.TextSource then return end

  local Player = game:GetService("Players"):GetPlayerByUserId(msg.TextSource.UserId)
  local Text = msg.Text
  local prefix = msg.PrefixText
  local props = Instance.new("TextChatMessageProperties")

  if Text:lower() == "meow" then
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
    end
  end
  return props
end
