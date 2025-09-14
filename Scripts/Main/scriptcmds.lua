loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()

scriptcmds = {
  ["reanimate"] = function()
    sendNotification("Moon Convert", "Reanimating!", 7)
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Reanimation/MyWorld.lua", true))()
  end,
  ["sonic"] = function()
    sendNotification("Moon Convert", "Running!", 7)
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Converts/sonic.lua", true))()
  end,
  ["chips"] = function()
    sendNotification("Moon Convert", "Running!", 7)
    loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Converts/chips.lua", true))()
  end,
}
