local whitelistdata = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/privatebuild/whitelist.json", true))

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
end
