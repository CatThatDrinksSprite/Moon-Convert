loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Main/scriptcmds.lua", true))()
loadstring(game:HttpGet("https://github.com/sharkymeowwww/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()
print(game.PlaceId)
if game.PlaceId == 88308889239232 or game.PlaceId == 17574618959 then
	print("good")
else
	sendNotification("Moon Convert", "This script only works in Just a baseplate or Green baseplate.", 7)
	error("bad")
end
local userinputService = game:GetService("UserInputService")

local Converted = {
	["_Moon Convert"] = Instance.new("ScreenGui");
	["_MainBar"] = Instance.new("Frame");
	["_MainText"] = Instance.new("TextBox");
	["_UICorner"] = Instance.new("UICorner");
	["_UIStroke"] = Instance.new("UIStroke");
}

Converted["_Moon Convert"].DisplayOrder = 999999999
Converted["_Moon Convert"].IgnoreGuiInset = true
Converted["_Moon Convert"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Converted["_Moon Convert"].ResetOnSpawn = false
Converted["_Moon Convert"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_Moon Convert"].Name = "Moon Convert"
Converted["_Moon Convert"].Parent = game:GetService("CoreGui")

Converted["_MainBar"].BackgroundColor3 = Color3.fromRGB(60.00000022351742, 60.00000022351742, 60.00000022351742)
Converted["_MainBar"].BackgroundTransparency = 0.10000000149011612
Converted["_MainBar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_MainBar"].BorderSizePixel = 0
Converted["_MainBar"].Position = UDim2.new(0.5, -510, 0, -100)
Converted["_MainBar"].Size = UDim2.new(0, 1020, 0, 49)
Converted["_MainBar"].Name = "MainBar"
Converted["_MainBar"].Parent = Converted["_Moon Convert"]
Converted["_MainBar"].Visible = false

Converted["_MainText"].CursorPosition = -1
Converted["_MainText"].Font = Enum.Font.Gotham
Converted["_MainText"].PlaceholderColor3 = Color3.fromRGB(229.00000154972076, 229.00000154972076, 229.00000154972076)
Converted["_MainText"].PlaceholderText = "command"
Converted["_MainText"].Text = ""
Converted["_MainText"].TextColor3 = Color3.fromRGB(229.00000154972076, 229.00000154972076, 229.00000154972076)
Converted["_MainText"].TextSize = 26
Converted["_MainText"].TextWrapped = true
Converted["_MainText"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_MainText"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_MainText"].BackgroundTransparency = 1
Converted["_MainText"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_MainText"].BorderSizePixel = 0
Converted["_MainText"].Position = UDim2.new(0.0145097915, 0, 0, 0)
Converted["_MainText"].Size = UDim2.new(0.985490143, 0, 1, 0)
Converted["_MainText"].Name = "MainText"
Converted["_MainText"].Parent = Converted["_MainBar"]

Converted["_UICorner"].Parent = Converted["_MainBar"]

Converted["_UIStroke"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke"].Color = Color3.fromRGB(93.00000205636024, 91.00000217556953, 93.00000205636024)
Converted["_UIStroke"].Thickness = 4
Converted["_UIStroke"].Parent = Converted["_MainBar"]

Converted["_MainText"].FocusLost:Connect(function()
	Converted["_MainBar"]:TweenPosition(UDim2.new(0.5, -510, 0, -100), "Out", "Quint", 0.3)
	Converted["_MainText"]:ReleaseFocus()
	task.wait(0.3)
	Converted["_MainText"].Text = ""
	Converted["_MainBar"].Visible = false
end)

Converted["_MainText"].FocusLost:Connect(function(enterPressed)
	if enterPressed then
		if scriptcmds[Converted["_MainText"].Text] then
			scriptcmds[Converted["_MainText"].Text]()
			elseif Converted["_MainText"].Text == "help" then
				for index, asset in pairs(scriptcmds) do
					print(index)
					game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
				end
		end
	end
end)

userinputService.InputBegan:Connect(function(input, gameprocessedEvent)
	if gameprocessedEvent then return end
	if input.KeyCode == Enum.KeyCode.RightAlt then
		if Converted["_MainBar"].Visible == false then
			Converted["_MainBar"].Visible = true
			Converted["_MainText"]:CaptureFocus()
			Converted["_MainBar"]:TweenPosition(UDim2.new(0.5, -510, 0, 50), "Out", "Quint", 0.3)
		else
			Converted["_MainBar"]:TweenPosition(UDim2.new(0.5, -510, 0, -100), "Out", "Quint", 0.3)
			Converted["_MainText"]:ReleaseFocus()
			task.wait(0.3)
			Converted["_MainText"].Text = ""
			Converted["_MainBar"].Visible = false
		end
	end
end)
sendNotification("Moon Convert", "Loaded! Click Right Alt to Open the Command Bar.", 7)
