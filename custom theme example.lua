loadstring(game:HttpGet("https://github.com/luanecoarc/Moon-Convert/raw/main/Scripts/Main/scriptcmds.lua", true))()
print(game.PlaceId)
if game.PlaceId == 88308889239232 or game.PlaceId == 17574618959 or game.PlaceId == 92637633202893 then
    print("good")
else
    sendNotification("Moon Convert", "This script only works in Just a baseplate, Snowy Fencing or Green baseplate.", 7)
    error("bad")
end
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({ Title = "Moon Convert Example Theme", Author = "By luanecoarc (windui used)" })

local CommandsTab = Window:Tab({ Title = "Commands" })

for index, asset in pairs(scriptcmds) do
CommandsTab:Button({ Title = index, Callback = function()
asset()
end })
end
