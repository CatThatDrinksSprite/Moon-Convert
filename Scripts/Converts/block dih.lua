loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()
loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Other/AlignCharacter.lua", true))()
if game.Players.LocalPlayer.Character:FindFirstChild("MeshPartAccessory") then
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e1"
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e2"
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e3"
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e4"
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e5"
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e6"
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e7"
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e8"
game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory").Name = "e9"
game.Players.LocalPlayer.Character.e1.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.e2.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.e3.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.e4.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.e5.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.e6.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.e7.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.e8.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.e9.Handle.AccessoryWeld:Destroy()
for _, v in ipairs(game.Players.LocalPlayer.Character.MyWorldDetection:GetChildren()) do
    if v.Name == "MeshPartAccessory" and v:IsA("Accessory") then
      v.Handle.SpecialMesh:Destroy()
    end
end
AlignCharacter(game.Players.LocalPlayer.Character.e1.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(5,6,0), Vector3.new(0, 0,0))
AlignCharacter(game.Players.LocalPlayer.Character.e2.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(-5, 6, 0), Vector3.new(0, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.e3.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -1), Vector3.new(0,0,0))
AlignCharacter(game.Players.LocalPlayer.Character.e4.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -5), Vector3.new(0, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.e5.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -10), Vector3.new(0, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.e6.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -15), Vector3.new(0, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.e7.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -20), Vector3.new(0, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.e8.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -25), Vector3.new(0, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.e9.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -30), Vector3.new(0, 0, 0))
else
  sendNotification("Moon Convert", "It is REQUIRED to wear the hats used for this script... You can get the hats by using \"get hats;block dih\"", 7)
end
