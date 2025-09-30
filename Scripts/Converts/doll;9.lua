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

local Sex9 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.532, -2.484, 1, 0, 0, 0, -0.003, 1, 0, -1, -0.003)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0, -0.163, 0.191, 1, -0, -0, 0, 0.804, 0.594, 0, -0.594, 0.804)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.172, -0, 0.265, 0.988, -0.152, 0, 0.144, 0.937, 0.317, -0.048, -0.313, 0.948)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0, -0.165, 0.196, 1, 0, -0, 0, 0.804, 0.595, 0, -0.595, 0.804)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.172, -0, 0.265, 0.988, 0.152, 0, -0.144, 0.938, 0.316, 0.048, -0.313, 0.949)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(-0, -0, -0, 1, -0.011, -0.019, 0.017, 0.949, 0.313, 0.015, -0.314, 0.949)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 1, 0, 0, 0, 0.828, -0.561, 0, 0.561, 0.828)},
	},
	[0.117] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.964, 0.14, 0.225, 0.011, 0.827, -0.562, -0.265, 0.544, 0.796)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0.07, -0.072, 0.167, 0.926, 0.153, 0.344, 0.019, 0.893, -0.449, -0.376, 0.422, 0.825)},
	},
	[0.3] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0.047, -0.048, 0.111, 0.924, 0.073, 0.376, 0.024, 0.969, -0.246, -0.382, 0.236, 0.894)},
	},
	[0.383] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.944, 0.02, 0.329, 0.014, 0.995, -0.102, -0.33, 0.101, 0.939)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(-0, 0, -0, 1, -0.008, -0.017, 0.015, 0.912, 0.41, 0.012, -0.411, 0.912)},
	},
	[0.45] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.967, -0, 0.254, 0.006, 1, -0.022, -0.254, 0.023, 0.967)},
	},
	[0.55] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.996, -0.012, 0.093, 0.008, 0.999, 0.047, -0.094, -0.046, 0.995)},
	},
	[0.617] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.533, -2.466, 1, 0, 0, 0, -0.031, 1, 0, -1, -0.031)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, -0.018, 0, 0.018, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0, -0.163, 0.191, 1, -0.026, -0, 0.021, 0.804, 0.594, -0.015, -0.594, 0.804)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.167, -0.02, 0.272, 0.98, -0.199, 0, 0.189, 0.929, 0.317, -0.063, -0.311, 0.948)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0, -0.165, 0.196, 1, 0.026, 0, -0.021, 0.804, 0.595, 0.015, -0.594, 0.804)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.167, -0.02, 0.271, 0.98, 0.199, -0, -0.189, 0.93, 0.316, 0.063, -0.31, 0.949)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.999, -0.012, -0.044, 0.014, 0.998, 0.059, 0.043, -0.059, 0.997)},
	},
	[0.717] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.533, -2.467, 1, 0, 0, 0, -0.029, 1, 0, -1, -0.029)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, -0.017, 0, 0.017, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0, -0.163, 0.191, 1, -0.025, 0, 0.02, 0.804, 0.594, -0.015, -0.594, 0.804)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.168, -0.019, 0.272, 0.98, -0.197, -0, 0.187, 0.93, 0.317, -0.062, -0.311, 0.948)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0, -0.165, 0.196, 1, 0.025, 0, -0.02, 0.804, 0.595, 0.015, -0.594, 0.804)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.168, -0.019, 0.271, 0.98, 0.197, -0, -0.187, 0.93, 0.316, 0.062, -0.31, 0.949)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.979, -0.014, -0.202, 0.011, 1, -0.014, 0.202, 0.011, 0.979)},
	},
	[0.75] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.971, -0.018, -0.237, 0.002, 0.998, -0.067, 0.238, 0.064, 0.969)},
	},
	[0.85] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0.046, -0.062, 0.145, 0.957, -0.067, -0.283, -0.028, 0.947, -0.32, 0.29, 0.314, 0.904)},
	},
	[0.867] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0.061, -0.082, 0.193, 0.957, -0.08, -0.279, -0.033, 0.926, -0.377, 0.289, 0.37, 0.883)},
	},
	[0.967] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.979, -0.082, -0.186, -0.033, 0.838, -0.545, 0.2, 0.54, 0.817)},
	},
	[1.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0.532, -2.484, 1, 0, 0, 0, -0.003, 1, 0, -1, -0.003)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0, -0.163, 0.191, 1, -0, -0, 0, 0.804, 0.594, 0, -0.594, 0.804)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.172, -0, 0.265, 0.988, -0.152, 0, 0.144, 0.937, 0.317, -0.048, -0.313, 0.948)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0, -0.165, 0.196, 1, 0, -0, 0, 0.804, 0.595, 0, -0.595, 0.804)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.172, -0, 0.265, 0.988, 0.152, 0, -0.144, 0.938, 0.316, 0.048, -0.313, 0.949)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(-0, 0, -0, 1, -0.011, -0.019, 0.017, 0.95, 0.312, 0.015, -0.313, 0.95)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 1, 0, 0, 0, 0.828, -0.561, 0, 0.561, 0.828)},
	},
}

PlayAnimation("Sex9", Sex9)

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

local Sex9 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.039, 0.745, -0.938, -1, 0, -0, -0, -0.545, 0.838, 0, 0.838, 0.545)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, -0, 1, 0, 0, 0, 0.887, -0.462, 0, 0.462, 0.887)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.298, 0.16, -0, 0.517, 0.844, 0.145, -0.818, 0.537, -0.205, -0.251, -0.012, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.037, 0.429, 0.826, 0.744, 0.568, 0.352, -0.392, 0.798, -0.458, -0.541, 0.203, 0.816)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.298, 0.16, 0, 0.557, -0.818, -0.144, 0.792, 0.576, -0.205, 0.251, -0, 0.968)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.037, 0.428, 0.826, 0.744, -0.568, -0.352, 0.393, 0.798, -0.457, 0.54, 0.202, 0.817)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DPurs"] = {["CFrame"] = CFrame.new(0.056, 0.159, -0.096, 1, -0, -0, -0, 1, 0, -0, 0, 1)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[0.117] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.039, 0.745, -0.938, -0.996, -0.018, -0.089, -0.064, -0.554, 0.83, -0.065, 0.832, 0.551)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.999, -0.022, -0.04, 0, 0.881, -0.472, 0.046, 0.472, 0.88)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.258, 0.185, -0.025, 0.524, 0.843, 0.124, -0.841, 0.535, -0.079, -0.133, -0.063, 0.989)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0.009, 0.574, 0.869, 0.731, 0.578, 0.363, -0.443, 0.807, -0.392, -0.519, 0.126, 0.845)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.369, 0.099, -0.004, 0.569, -0.802, -0.178, 0.748, 0.596, -0.293, 0.341, 0.033, 0.939)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.138, 0.296, 0.778, 0.795, -0.518, -0.318, 0.323, 0.803, -0.501, 0.514, 0.296, 0.805)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.038, 0.76, -0.902, -0.989, -0.035, -0.144, -0.103, -0.537, 0.837, -0.106, 0.843, 0.527)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, 0, 0.998, -0.03, -0.063, -0.001, 0.891, -0.454, 0.07, 0.453, 0.889)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.241, 0.195, -0.036, 0.508, 0.853, 0.119, -0.858, 0.514, -0.023, -0.08, -0.09, 0.993)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0.023, 0.629, 0.888, 0.7, 0.61, 0.372, -0.498, 0.789, -0.359, -0.512, 0.066, 0.856)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.418, 0.059, -0.008, 0.571, -0.801, -0.18, 0.728, 0.595, -0.339, 0.379, 0.063, 0.923)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.222, 0.188, 0.73, 0.805, -0.518, -0.29, 0.307, 0.781, -0.544, 0.508, 0.349, 0.788)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.01, 0, 1, 0, 0, 0, 0.999, -0.038, 0, 0.038, 0.999)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, -0.01, 0, 1, 0, 0, 0, 0.999, -0.038, 0, 0.038, 0.999)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[0.283] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.037, 0.779, -0.855, -0.985, -0.047, -0.166, -0.119, -0.508, 0.853, -0.125, 0.86, 0.494)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.241, 0.195, -0.036, 0.483, 0.867, 0.124, -0.872, 0.489, -0.02, -0.078, -0.098, 0.992)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0.015, 0.62, 0.888, 0.663, 0.647, 0.377, -0.543, 0.762, -0.353, -0.516, 0.03, 0.856)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.442, 0.043, -0.01, 0.568, -0.807, -0.161, 0.731, 0.584, -0.353, 0.379, 0.083, 0.922)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.275, 0.12, 0.693, 0.791, -0.549, -0.269, 0.326, 0.751, -0.575, 0.518, 0.367, 0.773)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.024, 0, 1, 0, 0, 0, 0.996, -0.089, 0, 0.089, 0.996)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, -0.024, 0, 1, 0, 0, 0, 0.996, -0.089, 0, 0.089, 0.996)},
	},
	[0.383] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.035, 0.808, -0.784, -0.985, -0.06, -0.162, -0.12, -0.434, 0.893, -0.123, 0.899, 0.42)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.24, 0.195, -0.026, 0.445, 0.887, 0.119, -0.894, 0.449, -0.001, -0.055, -0.106, 0.993)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.068, 0.559, 0.888, 0.594, 0.727, 0.344, -0.618, 0.687, -0.383, -0.515, 0.015, 0.857)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.452, 0.038, -0.012, 0.517, -0.846, -0.128, 0.767, 0.525, -0.369, 0.38, 0.092, 0.92)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.337, 0.03, 0.648, 0.719, -0.657, -0.226, 0.419, 0.669, -0.614, 0.555, 0.347, 0.756)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.009, 0.005, 1, -0, 0, 0, 0.994, -0.105, 0, 0.105, 0.994)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0.001, 0.008, 0.006, 1, -0, 0, 0, 0.994, -0.105, 0, 0.105, 0.994)},
	},
	[0.45] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.033, 0.827, -0.737, -0.989, -0.061, -0.135, -0.104, -0.363, 0.926, -0.105, 0.93, 0.353)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.996, -0.023, -0.086, -0.008, 0.94, -0.34, 0.089, 0.34, 0.936)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.239, 0.195, -0.014, 0.42, 0.901, 0.109, -0.907, 0.42, 0.021, -0.027, -0.108, 0.994)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.17, 0.486, 0.889, 0.536, 0.792, 0.292, -0.67, 0.609, -0.424, -0.514, 0.031, 0.857)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.443, 0.048, -0.01, 0.45, -0.887, -0.103, 0.808, 0.454, -0.375, 0.379, 0.086, 0.921)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.367, -0.02, 0.624, 0.624, -0.759, -0.187, 0.515, 0.579, -0.632, 0.588, 0.298, 0.752)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, 0.024, 0.011, 1, -0, 0, 0, 0.997, -0.076, 0, 0.076, 0.997)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0.001, 0.065, 0.013, 1, -0, 0, 0, 0.997, -0.076, 0, 0.076, 0.997)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[0.55] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.032, 0.841, -0.702, -0.998, -0.019, -0.053, -0.045, -0.304, 0.952, -0.034, 0.952, 0.303)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, -0.021, -0.069, -0.002, 0.945, -0.327, 0.072, 0.326, 0.943)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.274, 0.1, -0.004, 0.393, 0.917, 0.076, -0.919, 0.393, 0.009, -0.021, -0.074, 0.997)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.316, 0.317, 0.834, 0.505, 0.839, 0.203, -0.688, 0.534, -0.491, -0.521, 0.108, 0.847)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.38, 0.075, -0.013, 0.366, -0.925, -0.102, 0.87, 0.379, -0.316, 0.331, 0.027, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.32, 0.052, 0.653, 0.504, -0.838, -0.208, 0.592, 0.511, -0.624, 0.629, 0.192, 0.753)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, 0.052, 0.016, 1, 0, -0, -0, 0.997, -0.076, 0, 0.076, 0.997)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0.002, 0.072, 0.004, 1, 0, -0, -0, 0.997, -0.076, 0, 0.076, 0.997)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[0.617] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.032, 0.841, -0.702, -0.999, 0.036, 0.03, 0.018, -0.301, 0.954, 0.044, 0.953, 0.3)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.999, -0.022, -0.04, 0.007, 0.94, -0.341, 0.045, 0.341, 0.939)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.321, -0.027, -0.003, 0.382, 0.923, 0.041, -0.923, 0.384, -0.03, -0.043, -0.027, 0.999)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.408, 0.164, 0.76, 0.529, 0.837, 0.14, -0.665, 0.511, -0.544, -0.527, 0.195, 0.827)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.306, 0.1, -0.018, 0.324, -0.937, -0.129, 0.909, 0.347, -0.233, 0.263, -0.042, 0.964)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.227, 0.2, 0.716, 0.45, -0.849, -0.276, 0.61, 0.518, -0.599, 0.652, 0.101, 0.751)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0.055, 0.017, 1, 0, -0, -0, 0.994, -0.105, 0, 0.105, 0.994)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0.003, 0.024, -0.016, 1, 0, -0, -0, 0.994, -0.105, 0, 0.105, 0.994)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[0.717] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.032, 0.84, -0.75, -0.988, 0.091, 0.127, 0.088, -0.345, 0.934, 0.129, 0.934, 0.333)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0, 0, 1, -0.022, -0.018, 0.014, 0.933, -0.359, 0.025, 0.359, 0.933)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.347, -0.163, -0.006, 0.424, 0.905, -0, -0.904, 0.423, -0.065, -0.059, 0.028, 0.998)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.419, 0.002, 0.664, 0.585, 0.805, 0.093, -0.624, 0.521, -0.583, -0.518, 0.283, 0.807)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.221, 0.128, -0.026, 0.294, -0.941, -0.166, 0.933, 0.321, -0.166, 0.209, -0.107, 0.972)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.054, 0.376, 0.765, 0.411, -0.835, -0.366, 0.622, 0.551, -0.556, 0.666, 0.001, 0.746)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(-0, 0.046, 0.014, 1, 0, -0, -0, 0.995, -0.101, 0, 0.101, 0.995)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0.003, -0.01, -0.025, 1, 0, -0, -0, 0.995, -0.101, 0, 0.101, 0.995)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[0.75] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.032, 0.839, -0.782, -0.984, 0.099, 0.15, 0.103, -0.374, 0.921, 0.147, 0.922, 0.358)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.022, -0.018, 0.014, 0.931, -0.364, 0.025, 0.363, 0.931)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.341, -0.19, -0.008, 0.457, 0.89, -0.009, -0.888, 0.455, -0.07, -0.058, 0.04, 0.997)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.381, -0.029, 0.637, 0.61, 0.787, 0.093, -0.607, 0.54, -0.583, -0.509, 0.299, 0.807)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.202, 0.135, -0.029, 0.294, -0.939, -0.176, 0.933, 0.322, -0.162, 0.209, -0.117, 0.971)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.016, 0.42, 0.766, 0.414, -0.822, -0.392, 0.621, 0.57, -0.539, 0.666, -0.02, 0.746)},
	},
	[0.85] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.032, 0.837, -0.878, -0.985, 0.085, 0.153, 0.098, -0.456, 0.885, 0.145, 0.886, 0.441)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.01, -0.018, 0.002, 0.924, -0.382, 0.02, 0.381, 0.924)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.294, -0.163, -0.016, 0.503, 0.864, 0.02, -0.856, 0.501, -0.127, -0.12, 0.047, 0.992)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.217, 0.021, 0.647, 0.686, 0.711, 0.155, -0.527, 0.632, -0.567, -0.502, 0.307, 0.809)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.169, 0.149, -0.031, 0.372, -0.911, -0.18, 0.903, 0.4, -0.158, 0.216, -0.104, 0.971)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.135, 0.48, 0.757, 0.486, -0.752, -0.445, 0.57, 0.659, -0.491, 0.663, -0.015, 0.748)},
	},
	[0.867] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.032, 0.837, -0.894, -0.987, 0.077, 0.142, 0.089, -0.469, 0.879, 0.134, 0.88, 0.456)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, -0, 1, -0.006, -0.018, -0.002, 0.923, -0.385, 0.018, 0.385, 0.923)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.282, -0.139, -0.017, 0.502, 0.864, 0.035, -0.853, 0.502, -0.143, -0.141, 0.042, 0.989)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.182, 0.053, 0.664, 0.698, 0.695, 0.175, -0.509, 0.653, -0.561, -0.504, 0.302, 0.809)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.168, 0.15, -0.03, 0.397, -0.9, -0.177, 0.892, 0.424, -0.158, 0.217, -0.095, 0.971)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.139, 0.478, 0.753, 0.508, -0.735, -0.45, 0.553, 0.678, -0.484, 0.661, -0.003, 0.75)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(-0, 0.012, 0.003, 1, 0, -0, -0, 1, -0.025, 0, 0.025, 1)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0.001, -0.002, -0.006, 1, 0, -0, -0, 1, -0.025, 0, 0.025, 1)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[0.967] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.034, 0.808, -0.941, -0.996, 0.038, 0.075, 0.045, -0.517, 0.855, 0.072, 0.855, 0.514)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.005, -0.012, -0.009, 0.909, -0.416, 0.009, 0.416, 0.909)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.261, -0.001, -0.015, 0.504, 0.858, 0.098, -0.835, 0.513, -0.196, -0.218, 0.017, 0.976)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.065, 0.233, 0.748, 0.735, 0.621, 0.271, -0.433, 0.739, -0.516, -0.521, 0.262, 0.812)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.205, 0.156, -0.02, 0.498, -0.852, -0.16, 0.836, 0.521, -0.173, 0.231, -0.047, 0.972)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.097, 0.46, 0.767, 0.626, -0.65, -0.431, 0.468, 0.755, -0.459, 0.624, 0.086, 0.777)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
	[1.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.039, 0.745, -0.938, -1, 0, -0, -0, -0.545, 0.838, 0, 0.838, 0.545)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, -0, 1, 0, 0, 0, 0.887, -0.462, 0, 0.462, 0.887)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.298, 0.16, -0, 0.517, 0.844, 0.145, -0.818, 0.537, -0.205, -0.251, -0.012, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.037, 0.429, 0.826, 0.744, 0.568, 0.352, -0.392, 0.798, -0.458, -0.541, 0.203, 0.816)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.298, 0.16, 0, 0.557, -0.818, -0.144, 0.792, 0.576, -0.205, 0.251, -0, 0.968)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.037, 0.428, 0.826, 0.744, -0.568, -0.352, 0.393, 0.798, -0.457, 0.54, 0.202, 0.817)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.969, -0.249, 0, 0.249, 0.969)},
	},
}

PlayAnimation("Sex9", Sex9)
