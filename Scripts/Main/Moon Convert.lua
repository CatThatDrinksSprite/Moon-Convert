makefolder("Moon Convert")
writefile("Moon Convert/moonlogo.jpg", game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Moon-Convert/moonlogo.jpg", true))
writefile("Moon Convert/moonconvert.png", game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Moon-Convert/moonconvert.png", true))
writefile("Moon Convert/pfp.jpg", game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Moon-Convert/pfp.jpg", true))
writefile("Moon Convert/neptunian v.mp3", game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Moon-Convert/neptunian%20v.mp3", true))
loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Main/scriptcmds.lua", true))()
loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()
print(game.PlaceId)
if game.PlaceId == 88308889239232 or game.PlaceId == 17574618959 or game.PlaceId == 92637633202893 then
	print("good")
else
	sendNotification("Moon Convert", "This script only works in Just a baseplate, Snowy Fencing or Green baseplate.", 7)
	error("bad")
end
loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/privatebuild/moon%20convert%20private.lua", true))()
local userinputService = game:GetService("UserInputService")
local textchatService = game:GetService("TextChatService")

local Converted = {
	["_Moon Convert"] = Instance.new("ScreenGui");
	["_Cmdbar"] = Instance.new("TextBox");
	["_UICorner"] = Instance.new("UICorner");
	["_UIPadding"] = Instance.new("UIPadding");
	["_UIStroke"] = Instance.new("UIStroke");
	["_Clipper"] = Instance.new("CanvasGroup");
	["_UICorner1"] = Instance.new("UICorner");
	["_Frame"] = Instance.new("Frame");
	["_UICorner2"] = Instance.new("UICorner");
	["_Dropdown"] = Instance.new("ScrollingFrame");
	["_UIPadding1"] = Instance.new("UIPadding");
	["_UICorner3"] = Instance.new("UICorner");
	["_UIStroke1"] = Instance.new("UIStroke");
	["_UIPadding2"] = Instance.new("UIPadding");
	["_UIListLayout"] = Instance.new("UIListLayout");
	["_UICorner4"] = Instance.new("UICorner");
}

Converted["_Moon Convert"].DisplayOrder = 999999999
Converted["_Moon Convert"].IgnoreGuiInset = true
Converted["_Moon Convert"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Converted["_Moon Convert"].Enabled = false
Converted["_Moon Convert"].ResetOnSpawn = false
Converted["_Moon Convert"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_Moon Convert"].Name = "Moon Convert"
Converted["_Moon Convert"].Parent = game:GetService("CoreGui")

Converted["_Cmdbar"].Font = Enum.Font.SourceSans
Converted["_Cmdbar"].PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Cmdbar"].PlaceholderText = "Search or type a command here..."
Converted["_Cmdbar"].ShowNativeInput = false
Converted["_Cmdbar"].Text = ""
Converted["_Cmdbar"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Cmdbar"].TextSize = 16
Converted["_Cmdbar"].TextWrapped = true
Converted["_Cmdbar"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Cmdbar"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Cmdbar"].BackgroundColor3 = Color3.fromRGB(39.00000147521496, 39.00000147521496, 39.00000147521496)
Converted["_Cmdbar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Cmdbar"].BorderSizePixel = 0
Converted["_Cmdbar"].Position = UDim2.new(0.5, 0, 1.20000005, 0)
Converted["_Cmdbar"].Size = UDim2.new(0.800000012, 0, 0.0299999993, 0)
Converted["_Cmdbar"].Name = "Cmdbar"
Converted["_Cmdbar"].Parent = Converted["_Moon Convert"]
--// one stupid thing i forgot on the original ui
Converted["_Cmdbar"].ClearTextOnFocus = false

Converted["_UICorner"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner"].Parent = Converted["_Cmdbar"]

Converted["_UIPadding"].PaddingLeft = UDim.new(0, 12)
Converted["_UIPadding"].Parent = Converted["_Cmdbar"]

Converted["_UIStroke"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke"].Color = Color3.fromRGB(102.00000151991844, 102.00000151991844, 102.00000151991844)
Converted["_UIStroke"].Parent = Converted["_Cmdbar"]

Converted["_Clipper"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Clipper"].BackgroundTransparency = 1
Converted["_Clipper"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Clipper"].BorderSizePixel = 0
Converted["_Clipper"].Position = UDim2.new(0, -12, 0, 0)
Converted["_Clipper"].Size = UDim2.new(1, 12, 1, 0)
Converted["_Clipper"].Name = "Clipper"
Converted["_Clipper"].Parent = Converted["_Cmdbar"]

Converted["_UICorner1"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner1"].Parent = Converted["_Clipper"]

Converted["_Frame"].AnchorPoint = Vector2.new(0, 1)
Converted["_Frame"].BackgroundColor3 = Color3.fromRGB(69.00000348687172, 154.00000602006912, 238.00000101327896)
Converted["_Frame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame"].BorderSizePixel = 0
Converted["_Frame"].Position = UDim2.new(0, 0, 1, 0)
Converted["_Frame"].Size = UDim2.new(1, 0, 0, 2)
Converted["_Frame"].Parent = Converted["_Clipper"]

Converted["_UICorner2"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner2"].Parent = Converted["_Frame"]

Converted["_Dropdown"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Dropdown"].ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Dropdown"].Active = true
Converted["_Dropdown"].BackgroundColor3 = Color3.fromRGB(39.00000147521496, 39.00000147521496, 39.00000147521496)
Converted["_Dropdown"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Dropdown"].BorderSizePixel = 0
Converted["_Dropdown"].Position = UDim2.new(0, -12, -5.19999981, 0)
Converted["_Dropdown"].Size = UDim2.new(1, 12, 5, 0)
Converted["_Dropdown"].Parent = Converted["_Cmdbar"]



Converted["_UIPadding1"].PaddingLeft = UDim.new(0, 28)
Converted["_UIPadding1"].Parent = Converted["_Template"]

Converted["_UICorner3"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner3"].Parent = Converted["_Template"]

Converted["_UIStroke1"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke1"].Color = Color3.fromRGB(102.00000151991844, 102.00000151991844, 102.00000151991844)
Converted["_UIStroke1"].Parent = Converted["_Dropdown"]

Converted["_UIPadding2"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding2"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding2"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding2"].PaddingTop = UDim.new(0, 4)
Converted["_UIPadding2"].Parent = Converted["_Dropdown"]

Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout"].Parent = Converted["_Dropdown"]

Converted["_UICorner4"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner4"].Parent = Converted["_Dropdown"]

Converted["_Cmdbar"].FocusLost:Connect(function()
	game:GetService("TweenService"):Create(Converted["_Cmdbar"], TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 1.2, 0) }):Play()
	Converted["_Cmdbar"]:ReleaseFocus()
	task.wait(0.3)
	Converted["_Cmdbar"].Text = ""
	Converted["_Moon Convert"].Enabled = false
end)

Converted["_Cmdbar"].FocusLost:Connect(function(enterPressed)
	if enterPressed then
		if scriptcmds[Converted["_Cmdbar"].Text:lower()] then
			scriptcmds[Converted["_Cmdbar"].Text:lower()]()
		end
	end
end)

userinputService.InputBegan:Connect(function(input, gameprocessedEvent)
	if gameprocessedEvent then return end
	if input.KeyCode == Enum.KeyCode.RightAlt then
		if Converted["_Moon Convert"].Enabled == false then
			Converted["_Moon Convert"].Enabled = true
			Converted["_Cmdbar"]:CaptureFocus()
			game:GetService("TweenService"):Create(Converted["_Cmdbar"], TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.95, 0) }):Play()
		else
			game:GetService("TweenService"):Create(Converted["_Cmdbar"], TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 1.2, 0) }):Play()
			Converted["_Cmdbar"]:ReleaseFocus()
			task.wait(0.3)
			Converted["_Cmdbar"].Text = ""
			Converted["_Moon Convert"].Enabled = false
		end
	end
end)
function addcmd(cmdname)
	local Convertedd = {
		["_Template"] = Instance.new("TextLabel");
	}
	Convertedd["_Template"].Font = Enum.Font.SourceSans
	Convertedd["_Template"].Text = cmdname
	Convertedd["_Template"].TextColor3 = Color3.fromRGB(255, 255, 255)
	Convertedd["_Template"].TextSize = 16
	Convertedd["_Template"].TextXAlignment = Enum.TextXAlignment.Left
	Convertedd["_Template"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Convertedd["_Template"].BackgroundTransparency = 1
	Convertedd["_Template"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	Convertedd["_Template"].BorderSizePixel = 0
	Convertedd["_Template"].Size = UDim2.new(1, 0, 0, 32)
	Convertedd["_Template"].Name = cmdname
	Convertedd["_Template"].Parent = Converted["_Dropdown"]
end
for index, asset in pairs(scriptcmds) do
	addcmd(index)
end
game:GetService("RunService").Heartbeat:Connect(function()
	for index, asset in pairs(Converted["_Dropdown"]:GetChildren()) do
		if asset:IsA("TextLabel") then
			if asset.Text:lower():sub(1, #Converted["_Cmdbar"].Text) == Converted["_Cmdbar"].Text:lower() then
				asset.Visible = true
			else
				asset.Visible = false
			end
		end
	end
end)
sendNotification("Moon Convert", "Loaded! Click Right Alt to Open the Command Bar.", 7)
