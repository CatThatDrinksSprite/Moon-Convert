loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()

scriptcmds = {
  ["reanimate"] = function()
    sendNotification("Moon Convert", "Reanimating!", 7)
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Reanimation/MyWorld.lua", true))()
  end,
  ["reload"] = function()
    sendNotification("Moon Convert", "Reloading!", 7)
    game:GetService("CoreGui")["Moon Convert"]:Destroy()
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Main/Moon%20Convert.lua", true))()
  end,
  ["sonic"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Converts/sonic.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["chips"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Converts/chips.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["shopping cart"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Converts/shopping%20cart.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["memeus"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Converts/memeus.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
}
