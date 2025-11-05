loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()
loadstring(game:HttpGet("https://github.com/CatThatDrinksSprite/Moon-Convert/raw/main/Scripts/Other/AlignCharacter.lua", true))()
if game.Players.LocalPlayer:FindFirstChild("MeshPartAccessory") then
  local e1 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e1.Name = "e1"
local e2 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e2.Name = "e2"
local e3 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e3.Name = "e3"
local e4 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e4.Name = "e4"
local e5 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e5.Name = "e5"
local e6 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e6.Name = "e6"
local e7 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e7.Name = "e7"
local e8 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e8.Name = "e8"
local e9 = game.Players.LocalPlayer.Character:WaitForChild("MeshPartAccessory")
e9.Name = "e9"
e1.Handle.SpecialMesh:Destroy()
e1.Handle.AccessoryWeld:Destroy()
e2.Handle.SpecialMesh:Destroy()
e2.Handle.AccessoryWeld:Destroy()
e3.Handle.SpecialMesh:Destroy()
e3.Handle.AccessoryWeld:Destroy()
e4.Handle.SpecialMesh:Destroy()
e4.Handle.AccessoryWeld:Destroy()
e5.Handle.SpecialMesh:Destroy()
e5.Handle.AccessoryWeld:Destroy()
e6.Handle.SpecialMesh:Destroy()
e6.Handle.AccessoryWeld:Destroy()
e7.Handle.SpecialMesh:Destroy()
e7.Handle.AccessoryWeld:Destroy()
e8.Handle.SpecialMesh:Destroy()
e8.Handle.AccessoryWeld:Destroy()
e9.Handle.SpecialMesh:Destroy()
e9.Handle.AccessoryWeld:Destroy()
AlignCharacter(e1.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(5,6,0), Vector3.new(0, 0,0))
AlignCharacter(e2.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(-5, 6, 0), Vector3.new(0, 0, 0))
AlignCharacter(e3.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -1), Vector3.new(0,0,0))
AlignCharacter(e4.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -5), Vector3.new(0, 0, 0))
AlignCharacter(e5.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -10), Vector3.new(0, 0, 0))
AlignCharacter(e6.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -15), Vector3.new(0, 0, 0))
AlignCharacter(e7.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -20), Vector3.new(0, 0, 0))
AlignCharacter(e8.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -25), Vector3.new(0, 0, 0))
AlignCharacter(e9.Handle, game.Players.LocalPlayer.Character.Humanoid.RootPart, Vector3.new(0, 8, -30), Vector3.new(0, 0, 0))
else
  sendNotification("Moon Convert", "It is REQUIRED to wear the hats used for this script... You can get the hats by using \"get hats;block dih\"", 7)
end
