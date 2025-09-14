function sendNotification(Title: string, Text: string, Duration: number)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = Title;
		Text = Text;
		Duration = Duration
	})
	task.delay(0,function()
		local notif = Instance.new("Sound")
		notif.SoundId = "rbxassetid://7518627362"
		notif.Volume = 0.7
		game:GetService("SoundService"):PlayLocalSound(notif)
		task.delay(5, function()
			notif:Destroy()
		end)
	end)
end
