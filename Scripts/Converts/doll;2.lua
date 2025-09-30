loadstring(game:HttpGet("https://github.com/luanecoarc/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()
loadstring(game:HttpGet("https://github.com/luanecoarc/Moon-Convert/raw/main/Scripts/Other/AlignCharacter.lua", true))()

-- // male

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local RunService = game:GetService("RunService")

local CurrentAnimation = nil
local Running = false

Character.Animate.Enabled = false
Humanoid.RootPart.Anchored = true
local riggy = game.Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6)
riggy.Parent = Character
riggy.Humanoid.RootPart.Anchored = true
riggy.Humanoid.RootPart.CFrame = Character.Humanoid.RootPart.CFrame

local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)

for _, v in pairs(Animator:GetPlayingAnimationTracks()) do
	v:Stop()
end

local Motor6DMap = {
    ["Head"] = "Neck",
    ["Torso"] = "RootJoint",
    ["Left Arm"] = "Left Shoulder",
    ["Right Arm"] = "Right Shoulder",
    ["Left Leg"] = "Left Hip",
    ["Right Leg"] = "Right Hip"
}

local Motors = {}
for PartName, MotorName in pairs(Motor6DMap) do
	local Motor = Character:FindFirstChild(MotorName, true)
	if Motor then
		Motors[PartName] = {
			Motor = Motor,
			OriginalC0 = Motor.C0
		}
	end
end

-- Stores all running animations
local ActiveAnimations = {}

local function BuildPartAnimations(AnimationTable)
	local PartAnimations = {}
	local SortedTimestamps = {}
	for Timestamp in pairs(AnimationTable) do
		table.insert(SortedTimestamps, Timestamp)
	end
	table.sort(SortedTimestamps)

	for _, Timestamp in ipairs(SortedTimestamps) do
		local Poses = AnimationTable[Timestamp]
		for PartName, PoseData in pairs(Poses) do
			if not PartAnimations[PartName] then
				PartAnimations[PartName] = {}
			end
			table.insert(PartAnimations[PartName], {
				Timestamp,
				PoseData.CFrame,
				PoseData.Style or Enum.EasingStyle.Linear,
				PoseData.Direction or Enum.EasingDirection.In
			})
		end
	end
	return PartAnimations
end

function PlayAnimation(Name, AnimationTable, Loop, Speed)
	Speed = Speed or 1
	Loop = Loop ~= false
	StopAnimation(Name)

	local PartAnimations = BuildPartAnimations(AnimationTable)
	ActiveAnimations[Name] = {}

	for PartName, Keyframes in pairs(PartAnimations) do
		if Motors[PartName] then
			local Thread = task.spawn(function()
				while Loop do
					for i = 1, #Keyframes do
						local Frame = Keyframes[i]
						local PrevFrame = Keyframes[i - 1]
						local Duration = (Frame[1] - (PrevFrame and PrevFrame[1] or 0)) / Speed
						local TweenInfoObj = TweenInfo.new(Duration, Frame[3], Frame[4])
						local Tween = TweenService:Create(
							Motors[PartName].Motor,
							TweenInfoObj,
							{C0 = Motors[PartName].OriginalC0 * Frame[2]}
						)
						Tween:Play()
						task.wait(Duration)
					end
					task.wait()
				end
			end)
			ActiveAnimations[Name][PartName] = Thread
		end
	end
end

local function TransitionAnimation(NewAnimTable, Duration)
	local FirstTimestamp = math.huge
	for Timestamp in pairs(NewAnimTable) do
		if Timestamp < FirstTimestamp then
			FirstTimestamp = Timestamp
		end
	end

	for PartName, MotorData in pairs(Motors) do
		local PoseData = NewAnimTable[FirstTimestamp] and NewAnimTable[FirstTimestamp][PartName]
		if PoseData then
			local TargetC0 = MotorData.OriginalC0 * PoseData.CFrame
			local TweenInfoObj = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
			local Tween = TweenService:Create(MotorData.Motor, TweenInfoObj, {C0 = TargetC0})
			Tween:Play()
		end
	end

	task.wait(Duration)
end

function StopAnimation(Name)
	local Anim = ActiveAnimations[Name]
	if Anim then
		for _, Thread in pairs(Anim) do
			task.cancel(Thread)
		end
		ActiveAnimations[Name] = nil
	end
end

function StopAllAnimations()
	for Name in pairs(ActiveAnimations) do
		StopAnimation(Name)
	end
end

local Sex2 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -0.38, -2.788, -0.999, 0.002, 0.039, -0.039, -0.04, -0.998, -0, -0.999, 0.04)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.996, -0.094, 0, 0.094, 0.996)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.975, 0, 0.224, -0.055, 0.969, 0.242, -0.217, -0.248, 0.944)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.941, -0.107, -0.321, 0.18, 0.961, 0.208, 0.286, -0.254, 0.924)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.982, 0, -0.186, 0.058, 0.95, 0.306, 0.177, -0.312, 0.933)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.996, 0, 0.094, -0.036, 0.922, 0.385, -0.087, -0.387, 0.918)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(-0, 0, -0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, -0, 1, 0, 0, 0, 0.982, 0.191, 0, -0.191, 0.982)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.981, -0.192, 0, 0.192, 0.981)},
	},
	[0.05] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.989, -0.145, 0, 0.145, 0.989)},
	},
	[0.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -0.38, -2.788, -0.999, 0.002, 0.039, -0.039, -0.047, -0.998, -0, -0.999, 0.047)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.996, -0.094, 0, 0.094, 0.996)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.975, 0.011, 0.224, -0.066, 0.968, 0.242, -0.214, -0.25, 0.944)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.982, -0.004, -0.186, 0.062, 0.95, 0.306, 0.176, -0.313, 0.933)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.996, -0.006, 0.094, -0.031, 0.922, 0.385, -0.089, -0.386, 0.918)},
	},
	[0.133] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -0.38, -2.788, -0.999, 0.002, 0.039, -0.039, -0.053, -0.998, -0, -0.999, 0.053)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, 0, 0, 0.993, -0.12, 0, 0.12, 0.993)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.974, 0.027, 0.224, -0.083, 0.967, 0.242, -0.21, -0.254, 0.944)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.982, 0.001, -0.186, 0.057, 0.95, 0.306, 0.178, -0.312, 0.933)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.995, -0.033, 0.094, -0.006, 0.923, 0.385, -0.1, -0.384, 0.918)},
	},
	[0.183] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, -0, 1, 0, 0, 0, 0.997, 0.071, 0, -0.071, 0.997)},
	},
	[0.2] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -0.38, -2.797, -0.999, 0.003, 0.039, -0.039, -0.075, -0.996, -0, -0.997, 0.075)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, 0, 0, 0.992, -0.129, 0, 0.129, 0.992)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, 0.051, 0.224, -0.106, 0.965, 0.242, -0.203, -0.259, 0.944)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.981, -0.052, -0.186, 0.108, 0.946, 0.306, 0.16, -0.321, 0.933)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.993, -0.07, 0.094, 0.029, 0.922, 0.385, -0.114, -0.38, 0.918)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, -0, 1, 0, 0, 0, 0.999, 0.053, 0, -0.053, 0.999)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0, 0, -0, 1, 0, 0, 0, 0.994, 0.109, -0, -0.109, 0.994)},
	},
	[0.25] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, -0, 1, 0, 0, 0, 0.998, 0.055, 0, -0.055, 0.998)},
	},
	[0.267] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -0.38, -2.797, -0.999, 0.003, 0.039, -0.039, -0.065, -0.997, -0, -0.998, 0.065)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.989, -0.151, 0, 0.151, 0.989)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.972, 0.068, 0.224, -0.123, 0.963, 0.242, -0.199, -0.263, 0.944)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.981, -0.047, -0.186, 0.104, 0.946, 0.306, 0.162, -0.32, 0.933)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.995, -0.041, 0.094, 0.001, 0.923, 0.385, -0.103, -0.383, 0.918)},
	},
	[0.333] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -0.38, -2.797, -0.999, 0.001, 0.039, -0.039, -0.034, -0.999, -0, -0.999, 0.034)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, -0, 1, 0, 0, 0, 0.987, -0.161, 0, 0.161, 0.987)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, 0.049, 0.224, -0.104, 0.965, 0.242, -0.204, -0.259, 0.944)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.982, -0.037, -0.186, 0.094, 0.947, 0.306, 0.165, -0.318, 0.933)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.995, 0.041, 0.094, -0.074, 0.92, 0.385, -0.071, -0.39, 0.918)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, -0, 1, 0, 0, 0, 0.985, 0.172, 0, -0.172, 0.985)},
	},
	[0.667] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -0.38, -2.788, -0.999, 0.002, 0.039, -0.039, -0.04, -0.998, -0, -0.999, 0.04)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.996, -0.094, 0, 0.094, 0.996)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.975, 0, 0.224, -0.055, 0.969, 0.242, -0.217, -0.248, 0.944)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.982, 0, -0.186, 0.058, 0.95, 0.306, 0.177, -0.312, 0.933)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.996, 0, 0.094, -0.036, 0.922, 0.385, -0.087, -0.387, 0.918)},
	},
}

PlayAnimation("Sex2", Sex2)

-- // female

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = riggy
local Humanoid = Character:WaitForChild("Humanoid")

local RunService = game:GetService("RunService")

local CurrentAnimation = nil
local Running = false

if game.Players.LocalPlayer.Character:FindFirstChild("LavanderHair") then
game.Players.LocalPlayer.Character.Model.LavanderHair.Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.Model["Kate Hair"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.Model["Pal Hair"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.Model.Hat1.Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.Model.SeeMonkey.Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.LavanderHair.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character["Kate Hair"].Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character["Pal Hair"].Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.Hat1.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.SeeMonkey.Handle.AccessoryWeld:Destroy()
AlignCharacter(game.Players.LocalPlayer.Character.LavanderHair.Handle, riggy["Right Arm"], Vector3.new(0, 0, 0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character["Kate Hair"].Handle, riggy["Left Arm"], Vector3.new(0,0,0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character["Pal Hair"].Handle, riggy["Right Leg"], Vector3.new(0,0,0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.Hat1.Handle, riggy["Left Leg"], Vector3.new(0,0,0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.SeeMonkey.Handle, riggy.Torso, Vector3.new(0,0,0), Vector3.new(90, 0, 0))
for index, asset in pairs(riggy:GetChildren()) do
		if asset:IsA("BasePart") then
			asset.Transparency = 1
		end
	end
    else
    sendNotification("Moon Convert", "It is recommended to wear the hats used for this script... You can get the hats by using \"get hats;doll\"", 7)
end

local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)

for _, v in pairs(Animator:GetPlayingAnimationTracks()) do
	v:Stop()
end

local Motor6DMap = {
    ["Head"] = "Neck",
    ["Torso"] = "RootJoint",
    ["Left Arm"] = "Left Shoulder",
    ["Right Arm"] = "Right Shoulder",
    ["Left Leg"] = "Left Hip",
    ["Right Leg"] = "Right Hip"
}

local Motors = {}
for PartName, MotorName in pairs(Motor6DMap) do
	local Motor = Character:FindFirstChild(MotorName, true)
	if Motor then
		Motors[PartName] = {
			Motor = Motor,
			OriginalC0 = Motor.C0
		}
	end
end

-- Stores all running animations
local ActiveAnimations = {}

local function BuildPartAnimations(AnimationTable)
	local PartAnimations = {}
	local SortedTimestamps = {}
	for Timestamp in pairs(AnimationTable) do
		table.insert(SortedTimestamps, Timestamp)
	end
	table.sort(SortedTimestamps)

	for _, Timestamp in ipairs(SortedTimestamps) do
		local Poses = AnimationTable[Timestamp]
		for PartName, PoseData in pairs(Poses) do
			if not PartAnimations[PartName] then
				PartAnimations[PartName] = {}
			end
			table.insert(PartAnimations[PartName], {
				Timestamp,
				PoseData.CFrame,
				PoseData.Style or Enum.EasingStyle.Linear,
				PoseData.Direction or Enum.EasingDirection.In
			})
		end
	end
	return PartAnimations
end

function PlayAnimation(Name, AnimationTable, Loop, Speed)
	Speed = Speed or 1
	Loop = Loop ~= false
	StopAnimation(Name)

	local PartAnimations = BuildPartAnimations(AnimationTable)
	ActiveAnimations[Name] = {}

	for PartName, Keyframes in pairs(PartAnimations) do
		if Motors[PartName] then
			local Thread = task.spawn(function()
				while Loop do
					for i = 1, #Keyframes do
						local Frame = Keyframes[i]
						local PrevFrame = Keyframes[i - 1]
						local Duration = (Frame[1] - (PrevFrame and PrevFrame[1] or 0)) / Speed
						local TweenInfoObj = TweenInfo.new(Duration, Frame[3], Frame[4])
						local Tween = TweenService:Create(
							Motors[PartName].Motor,
							TweenInfoObj,
							{C0 = Motors[PartName].OriginalC0 * Frame[2]}
						)
						Tween:Play()
						task.wait(Duration)
					end
					task.wait()
				end
			end)
			ActiveAnimations[Name][PartName] = Thread
		end
	end
end

local function TransitionAnimation(NewAnimTable, Duration)
	local FirstTimestamp = math.huge
	for Timestamp in pairs(NewAnimTable) do
		if Timestamp < FirstTimestamp then
			FirstTimestamp = Timestamp
		end
	end

	for PartName, MotorData in pairs(Motors) do
		local PoseData = NewAnimTable[FirstTimestamp] and NewAnimTable[FirstTimestamp][PartName]
		if PoseData then
			local TargetC0 = MotorData.OriginalC0 * PoseData.CFrame
			local TweenInfoObj = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
			local Tween = TweenService:Create(MotorData.Motor, TweenInfoObj, {C0 = TargetC0})
			Tween:Play()
		end
	end

	task.wait(Duration)
end

function StopAnimation(Name)
	local Anim = ActiveAnimations[Name]
	if Anim then
		for _, Thread in pairs(Anim) do
			task.cancel(Thread)
		end
		ActiveAnimations[Name] = nil
	end
end

function StopAllAnimations()
	for Name in pairs(ActiveAnimations) do
		StopAnimation(Name)
	end
end

local Sex2 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.591, 1, -0, 0, 0, 0.925, -0.381, 0, 0.381, 0.925)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, 0, 0.997, -0.036, -0.066, 0.022, 0.981, -0.194, 0.071, 0.192, 0.979)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.028, -0.81, -0.474, 0.732, 0.584, -0.351, -0.646, 0.758, -0.086, 0.216, 0.29, 0.932)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.657, 0.093, 0.175, 0.719, -0.689, -0.093, 0.682, 0.672, 0.289, -0.137, -0.271, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.246, -0.653, -0.366, 0.73, -0.423, 0.537, 0.505, 0.863, -0.007, -0.46, 0.277, 0.844)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.495, -0.225, 0.106, 0.729, 0.677, 0.099, -0.654, 0.646, 0.395, 0.204, -0.353, 0.913)},
	},
	[0.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.782, 1, -0, 0, 0, 0.908, -0.418, 0, 0.418, 0.908)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.06, -0.706, -0.433, 0.704, 0.624, -0.34, -0.681, 0.728, -0.073, 0.202, 0.283, 0.938)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.635, 0.216, 0.175, 0.695, -0.713, -0.093, 0.704, 0.648, 0.289, -0.146, -0.266, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.102, -0.616, -0.366, 0.664, -0.543, 0.513, 0.62, 0.784, 0.027, -0.417, 0.3, 0.858)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.526, -0.211, 0.106, 0.674, 0.732, 0.099, -0.702, 0.593, 0.395, 0.231, -0.336, 0.913)},
	},
	[0.133] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.976, 1, -0, 0, 0, 0.928, -0.373, 0, 0.373, 0.928)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.136, -0.618, -0.399, 0.704, 0.624, -0.34, -0.681, 0.728, -0.073, 0.202, 0.283, 0.938)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.665, 0.243, 0.175, 0.596, -0.797, -0.093, 0.782, 0.552, 0.289, -0.179, -0.245, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.008, -0.508, -0.366, 0.684, -0.518, 0.513, 0.589, 0.808, 0.031, -0.431, 0.281, 0.858)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.484, -0.109, 0.106, 0.608, 0.788, 0.099, -0.75, 0.53, 0.395, 0.259, -0.315, 0.913)},
	},
	[0.2] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -1.076, 1, -0, 0, 0, 0.958, -0.286, 0, 0.286, 0.958)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.173, -0.533, -0.391, 0.723, 0.602, -0.34, -0.658, 0.749, -0.073, 0.211, 0.277, 0.938)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.625, 0.42, 0.175, 0.564, -0.82, -0.093, 0.804, 0.52, 0.289, -0.189, -0.238, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.078, -0.421, -0.366, 0.729, -0.424, 0.538, 0.512, 0.859, -0.016, -0.455, 0.287, 0.843)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.344, 0.083, 0.106, 0.609, 0.787, 0.099, -0.75, 0.53, 0.395, 0.259, -0.315, 0.913)},
	},
	[0.267] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.871, 1, -0, 0, 0, 0.972, -0.236, 0, 0.236, 0.972)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.089, -0.628, -0.428, 0.782, 0.515, -0.351, -0.576, 0.812, -0.091, 0.238, 0.274, 0.932)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.673, 0.259, 0.166, 0.498, -0.862, -0.093, 0.842, 0.455, 0.289, -0.207, -0.222, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.032, -0.623, -0.366, 0.756, -0.346, 0.556, 0.449, 0.891, -0.057, -0.476, 0.293, 0.829)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.257, -0.075, 0.106, 0.609, 0.787, 0.099, -0.75, 0.53, 0.395, 0.259, -0.315, 0.913)},
	},
	[0.333] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.673, 1, -0, 0, 0, 0.978, -0.208, 0, 0.208, 0.978)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.024, -0.755, -0.456, 0.831, 0.429, -0.354, -0.491, 0.865, -0.102, 0.263, 0.259, 0.93)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.662, 0.133, 0.175, 0.51, -0.855, -0.093, 0.836, 0.467, 0.289, -0.204, -0.225, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.164, -0.738, -0.393, 0.785, -0.255, 0.564, 0.372, 0.923, -0.1, -0.495, 0.288, 0.819)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.275, -0.195, 0.106, 0.609, 0.787, 0.099, -0.75, 0.53, 0.395, 0.259, -0.315, 0.913)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.476, 1, -0, 0, 0, 0.982, -0.191, 0, 0.191, 0.982)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.049, -0.916, -0.489, 0.855, 0.376, -0.358, -0.441, 0.89, -0.116, 0.274, 0.257, 0.927)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.66, -0.071, 0.175, 0.499, -0.862, -0.093, 0.842, 0.456, 0.289, -0.207, -0.222, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.175, -0.872, -0.396, 0.796, -0.229, 0.561, 0.341, 0.934, -0.102, -0.5, 0.272, 0.822)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.224, -0.27, 0.106, 0.663, 0.742, 0.099, -0.71, 0.583, 0.395, 0.235, -0.332, 0.913)},
	},
	[0.5] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.383, 1, -0, 0, 0, 0.97, -0.242, 0, 0.242, 0.97)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.087, -1.007, -0.51, 0.823, 0.442, -0.358, -0.508, 0.854, -0.114, 0.255, 0.276, 0.927)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.69, -0.149, 0.175, 0.557, -0.825, -0.093, 0.808, 0.513, 0.289, -0.191, -0.236, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.265, -0.888, -0.44, 0.798, -0.239, 0.553, 0.329, 0.942, -0.068, -0.505, 0.236, 0.83)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.245, -0.295, 0.106, 0.719, 0.688, 0.099, -0.663, 0.636, 0.395, 0.209, -0.35, 0.913)},
	},
	[0.583] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.43, 1, -0, 0, 0, 0.955, -0.296, 0, 0.296, 0.955)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.066, -0.974, -0.491, 0.777, 0.521, -0.354, -0.584, 0.806, -0.095, 0.236, 0.28, 0.93)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.71, -0.102, 0.175, 0.633, -0.769, -0.093, 0.756, 0.587, 0.289, -0.168, -0.253, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.363, -0.765, -0.473, 0.795, -0.26, 0.548, 0.336, 0.941, -0.04, -0.506, 0.216, 0.835)},
	},
	[0.667] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.503, -0.591, 1, -0, 0, 0, 0.925, -0.381, 0, 0.381, 0.925)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.028, -0.81, -0.474, 0.732, 0.584, -0.351, -0.646, 0.758, -0.086, 0.216, 0.29, 0.932)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.657, 0.093, 0.175, 0.719, -0.689, -0.093, 0.682, 0.672, 0.289, -0.137, -0.271, 0.953)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.246, -0.653, -0.366, 0.73, -0.423, 0.537, 0.505, 0.863, -0.007, -0.46, 0.277, 0.844)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.495, -0.225, 0.106, 0.729, 0.677, 0.099, -0.654, 0.646, 0.395, 0.204, -0.353, 0.913)},
	},
}

PlayAnimation("Sex2", Sex2)
