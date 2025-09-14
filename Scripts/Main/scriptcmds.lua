loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()

scriptcmds = {
  ["reanimate"] = function()
    sendNotification("Moon Convert", "Reanimating!", 7)
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Reanimation/MyWorld.lua", true))()
  end,
  ["reload"] = function()
    sendNotification("Moon Convert", "Rerunning!", 7)
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Main/Moon%20Convert.lua", true))()
  end,
  ["sonic"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if not game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      sendNotification("Moon Convert", "This script will be clientsided unless u run the reanimate command.", 7)
    end
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Converts/sonic.lua", true))()
  end,
  ["chips"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if not game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      sendNotification("Moon Convert", "This script will be clientsided unless u run the reanimate command.", 7)
    end
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Converts/chips.lua", true))()
  end,
}
