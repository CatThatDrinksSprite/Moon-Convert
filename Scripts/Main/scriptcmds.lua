loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()

scriptcmds = {
  ["reanimate"] = function()
    sendNotification("Moon Convert", "Reanimating!", 7)
    loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Reanimation/MyWorld.lua", true))()
  end,
  ["sonic"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/sonic.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["chips"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/chips.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["shopping cart"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/shopping%20cart.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["memeus"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/memeus.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["server admin"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/server%20admin.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["holiday feelings"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/holiday%20feelings.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["nebula star glitcher"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/nebula%20star%20glitcher.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;chips"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"4964938812"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["get hats;shopping cart"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"4794163533"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["sex;50"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/sex%3B50.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["sex;67"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/sex%3B67.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["sex;21"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/sex%3B21.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["sex;56"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/sex%3B56.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;ban hammer"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"4739580137"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["get hats;neptunian v"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"4506945409"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
["ban hammer"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/ban%20hammer.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["neptunian v"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/neptunian%20v.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;sex"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      -- // wow just a baseplate owner you ACTUALLY patched it... good job man
      --[[ local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"48474294", "48474313", "451220849", "62724852", "63690008", "62234425"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " ")) ]]--
      sendNotification("Moon Convert", "This command is locked.", 7)
    end
  end,
  ["get hats;voodoo child"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"7218253553", "4684948729"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["voodoo child"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/voodoo%20child.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;hoverboard"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"4315489767"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["hoverboard"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/hoverboard.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["discord"] = function()
    setclipboard([[gg/DPBtncwaEm]])
    sendNotification("Moon Convert", "Set clipboard to discord link", 7)
  end,
  ["caducus"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/caducus.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["animation man"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/animation%20man.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["dual ultima"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/dual%20ultima.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;dual ultima"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"5316549755", "5316539421"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["get hats;asterazuke glitcher"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"5268555719", "5268602207", "5316479641", "5316549755", "5316539421", "5268710380", "6904794619"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["asterazuke glitcher"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/asterazuke%20glitcher.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["elio basio"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/elio%20basio.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;elio basio"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"100171532179089"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["get hats;blind reaper"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"18275328462", "15008443536"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["blind reaper"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/blind%20reaper.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;banzai bazooka"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"79492025253331"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end,
  ["banzai bazooka"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/banzai%20bazooka.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["soul reaper"] = function()
    sendNotification("Moon Convert", "Ran!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Converts/soul%20reaper.lua", true))()
    else
      sendNotification("Moon Convert", "Please use command \"reanimate\" first.", 7)
    end
  end,
  ["get hats;soul reaper"] = function()
    sendNotification("Moon Convert", "Getting Hats!", 7)
    if game.Players.LocalPlayer.Character:FindFirstChild("MyWorldDetection") then
      sendNotification("Moon Convert", "Please get hats before reanimating", 7)
    else
      local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
      local ids = {"128219376096305"}
      local shuffledids = shuffleTable(ids)

      game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh " .. table.concat(shuffledids, " "))
      print("-gh " .. table.concat(shuffledids, " "))
    end
  end
}
