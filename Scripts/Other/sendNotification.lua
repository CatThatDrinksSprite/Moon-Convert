function sendNotification(Title: string, Text: string, Duration: number)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = Title;
		Text = Text;
		Duration = Duration
	})
	task.delay(0,function()
		local notif = Instance.new("Sound")
		notif.SoundId = getcustomasset("ScriptBase/notification.mp3")
		notif.Volume = 0.7
		game:GetService("SoundService"):PlayLocalSound(notif)
		task.delay(5, function()
			notif:Destroy()
		end)
	end)
end

if not isfile("ScriptBase/notification.mp3") then
	sendNotification("Moon Convert", "Downloading \"ScriptBase/notification.mp3\"", 7)
	writefile("ScriptBase/notification.mp3", game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/ScriptBase/notification.mp3", true))
end
