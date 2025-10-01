loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()

scriptcmds = {
  ["reanimate"] = function()
    sendNotification("Moon Convert", "Reanimating!", 7)
    loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Reanimation/MyWorld.lua", true))()
  end,
  ["sonic"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/sonic.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["chips"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/chips.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["shopping cart"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/shopping%20cart.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["memeus"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/memeus.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["server admin"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/server%20admin.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["holiday feelings"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/holiday%20feelings.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["orange justice"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/orange%20justice.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["clean groove"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/clean%20groove.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["nebula star glitcher"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/nebula%20star%20glitcher.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;chips"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh 4964938812")
    end
  end,
  ["get hats;shopping cart"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh 4794163533")
    end
  end,
  ["doll;50"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/doll%3B50.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["doll;67"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Converts/doll%3B67.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;doll"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("Model") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh 451220849 62724852 63690008 62234425 48474294 48474313")
    end
  end
}
