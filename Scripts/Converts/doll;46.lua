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

local Sex46 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0.031, -1.464, 1, 0, 0, 0, 0.95, -0.311, 0, 0.311, 0.95)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.65, -0.326, -0, 0.297, 0.937, -0.184, -0.952, 0.306, 0.017, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.396, 0.283, 0.349, 0.328, -0.943, 0.059, 0.944, 0.329, 0.004, -0.023, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.65, -0.326, -0, 0.297, -0.937, 0.184, 0.952, 0.306, 0.017, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.396, 0.283, 0.349, 0.328, 0.943, -0.059, -0.944, 0.329, 0.004, 0.023, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.993, -0.119, 0, 0.119, 0.993)},
	},
	[0.017] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0.029, -1.463, 1, -0, 0, 0, 0.95, -0.313, -0, 0.313, 0.95)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.002, 0, -0.002, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.651, -0.326, -0, 0.296, 0.937, -0.184, -0.953, 0.304, 0.017, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.399, 0.284, 0.349, 0.33, -0.942, 0.059, 0.944, 0.331, 0.004, -0.023, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.651, -0.326, -0, 0.296, -0.937, 0.184, 0.953, 0.304, 0.017, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.399, 0.284, 0.349, 0.33, 0.942, -0.059, -0.944, 0.331, 0.004, 0.023, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.993, -0.12, -0, 0.12, 0.993)},
	},
	[0.033] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0.024, -1.462, 1, -0, 0, 0, 0.948, -0.318, -0, 0.318, 0.948)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.006, 0, -0.006, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.655, -0.324, -0, 0.291, 0.939, -0.184, -0.954, 0.299, 0.018, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.408, 0.289, 0.349, 0.335, -0.94, 0.059, 0.942, 0.336, 0.004, -0.023, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.655, -0.324, -0, 0.291, -0.939, 0.184, 0.954, 0.299, 0.018, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.408, 0.289, 0.349, 0.335, 0.94, -0.059, -0.942, 0.336, 0.004, 0.023, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.992, -0.123, -0, 0.123, 0.992)},
	},
	[0.05] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0.016, -1.46, 1, -0, 0, 0, 0.946, -0.325, -0, 0.325, 0.946)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.012, 0, -0.012, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.66, -0.322, 0, 0.284, 0.941, -0.184, -0.956, 0.293, 0.02, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.42, 0.296, 0.35, 0.342, -0.938, 0.059, 0.939, 0.343, 0.004, -0.024, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.66, -0.322, 0, 0.284, -0.941, 0.184, 0.956, 0.293, 0.02, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.42, 0.296, 0.35, 0.342, 0.938, -0.059, -0.939, 0.343, 0.004, 0.024, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.992, -0.126, 0, 0.126, 0.992)},
	},
	[0.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0.008, -1.457, 1, -0, 0, 0, 0.943, -0.332, -0, 0.332, 0.943)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.018, 0, -0.018, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.665, -0.32, 0, 0.277, 0.943, -0.184, -0.958, 0.285, 0.021, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.433, 0.303, 0.35, 0.349, -0.935, 0.059, 0.937, 0.35, 0.004, -0.025, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.665, -0.32, 0, 0.277, -0.943, 0.184, 0.958, 0.285, 0.021, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.433, 0.303, 0.35, 0.349, 0.935, -0.059, -0.937, 0.35, 0.004, 0.025, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, -0, -0, 0.991, -0.13, 0, 0.13, 0.991)},
	},
	[0.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0, -1.455, 1, -0, 0, 0, 0.941, -0.339, -0, 0.339, 0.941)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.025, 0, -0.025, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.671, -0.317, 0, 0.27, 0.945, -0.183, -0.96, 0.279, 0.022, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.445, 0.31, 0.35, 0.356, -0.932, 0.059, 0.934, 0.357, 0.005, -0.026, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.671, -0.317, 0, 0.27, -0.945, 0.183, 0.96, 0.279, 0.022, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.445, 0.31, 0.35, 0.356, 0.932, -0.059, -0.934, 0.357, 0.005, 0.026, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, 0, 1, 0, -0, -0, 0.991, -0.134, -0, 0.134, 0.991)},
	},
	[0.1] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, 0.006, -1.453, 1, -0, 0, 0, 0.939, -0.344, -0, 0.344, 0.939)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.029, 0, -0.029, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.675, -0.316, 0, 0.265, 0.947, -0.183, -0.962, 0.273, 0.023, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.455, 0.315, 0.35, 0.362, -0.93, 0.059, 0.932, 0.363, 0.005, -0.026, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.675, -0.316, 0, 0.265, -0.947, 0.183, 0.962, 0.273, 0.023, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.455, 0.315, 0.35, 0.362, 0.93, -0.059, -0.932, 0.363, 0.005, 0.026, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, -0, 0, 0.991, -0.137, 0, 0.137, 0.991)},
	},
	[0.117] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, 0.009, -1.453, 1, -0, 0, 0, 0.938, -0.347, -0, 0.347, 0.938)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.032, 0, -0.032, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.676, -0.315, 0, 0.262, 0.948, -0.183, -0.962, 0.271, 0.024, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.459, 0.318, 0.35, 0.364, -0.929, 0.059, 0.931, 0.365, 0.005, -0.026, 0.053, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.676, -0.315, 0, 0.262, -0.948, 0.183, 0.962, 0.271, 0.024, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.459, 0.318, 0.35, 0.364, 0.929, -0.059, -0.931, 0.365, 0.005, 0.026, 0.053, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, -0, -0, 0.99, -0.138, 0, 0.138, 0.99)},
	},
	[0.133] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, 0.008, -1.453, 1, -0, 0, 0, 0.938, -0.346, -0, 0.346, 0.938)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.03, 0, -0.03, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.676, -0.315, 0, 0.263, 0.947, -0.183, -0.962, 0.272, 0.024, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.457, 0.317, 0.35, 0.363, -0.93, 0.059, 0.931, 0.364, 0.005, -0.026, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.676, -0.315, 0, 0.263, -0.947, 0.183, 0.962, 0.272, 0.024, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.457, 0.317, 0.35, 0.363, 0.93, -0.059, -0.931, 0.364, 0.005, 0.026, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, -0, -0, 0.99, -0.138, -0, 0.138, 0.99)},
	},
	[0.15] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, 0, -1.455, 1, -0, 0, 0, 0.941, -0.339, -0, 0.339, 0.941)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.025, 0, -0.025, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.671, -0.317, 0, 0.27, 0.945, -0.183, -0.96, 0.278, 0.022, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.446, 0.311, 0.35, 0.357, -0.932, 0.059, 0.934, 0.358, 0.005, -0.026, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.671, -0.317, 0, 0.27, -0.945, 0.183, 0.96, 0.278, 0.022, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.446, 0.311, 0.35, 0.357, 0.932, -0.059, -0.934, 0.358, 0.005, 0.026, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, -0, 0, 0.991, -0.134, 0, 0.134, 0.991)},
	},
	[0.167] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0.014, -1.459, 1, -0, 0, 0, 0.945, -0.327, -0, 0.327, 0.945)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0.014, 0, -0.014, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.662, -0.321, 0, 0.282, 0.942, -0.184, -0.957, 0.29, 0.02, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.424, 0.298, 0.35, 0.344, -0.937, 0.059, 0.939, 0.345, 0.004, -0.024, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.662, -0.321, 0, 0.282, -0.942, 0.184, 0.957, 0.29, 0.02, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.424, 0.298, 0.35, 0.344, 0.937, -0.059, -0.939, 0.345, 0.004, 0.024, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, -0, 0, 0.992, -0.128, 0, 0.128, 0.992)},
	},
	[0.183] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0.036, -1.465, 1, -0, 0, 0, 0.952, -0.307, -0, 0.307, 0.952)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 1, -0.004, 0, 0.004, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.647, -0.328, -0, 0.301, 0.936, -0.184, -0.951, 0.309, 0.016, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.389, 0.279, 0.349, 0.324, -0.944, 0.059, 0.946, 0.325, 0.004, -0.022, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.647, -0.328, -0, 0.301, -0.936, 0.184, 0.951, 0.309, 0.016, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.389, 0.279, 0.349, 0.324, 0.944, -0.059, -0.946, 0.325, 0.004, 0.022, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.993, -0.117, -0, 0.117, 0.993)},
	},
	[0.2] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.029, -0.068, -1.474, 1, -0, 0, 0, 0.96, -0.279, -0, 0.279, 0.96)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, 0, 1, 0, 0, 0, 1, -0.028, 0, 0.028, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.626, -0.337, -0, 0.329, 0.926, -0.184, -0.942, 0.337, 0.011, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.338, 0.251, 0.348, 0.295, -0.954, 0.058, 0.955, 0.296, 0.002, -0.02, 0.055, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.626, -0.337, -0, 0.329, -0.926, 0.184, 0.942, 0.337, 0.011, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.338, 0.251, 0.348, 0.295, 0.954, -0.058, -0.955, 0.296, 0.002, 0.02, 0.055, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.995, -0.102, -0, 0.102, 0.995)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.029, -0.11, -1.486, 1, -0, 0, 0, 0.971, -0.24, -0, 0.24, 0.971)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.998, -0.062, 0, 0.062, 0.998)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.598, -0.349, -0, 0.365, 0.912, -0.185, -0.928, 0.373, 0.004, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.271, 0.214, 0.347, 0.256, -0.965, 0.058, 0.967, 0.256, 0.001, -0.016, 0.055, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.598, -0.349, -0, 0.365, -0.912, 0.185, 0.928, 0.373, 0.004, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.271, 0.214, 0.347, 0.256, 0.965, -0.058, -0.967, 0.256, 0.001, 0.016, 0.055, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, -0, 1, 0, -0, 0, 0.997, -0.082, 0, 0.082, 0.997)},
	},
	[0.233] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.03, -0.165, -1.501, 1, -0, 0, 0, 0.982, -0.19, -0, 0.19, 0.982)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.995, -0.104, 0, 0.104, 0.995)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.562, -0.365, -0, 0.412, 0.892, -0.185, -0.909, 0.418, -0.006, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.184, 0.166, 0.345, 0.204, -0.977, 0.057, 0.979, 0.205, -0.001, -0.011, 0.056, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.562, -0.365, -0, 0.412, -0.892, 0.185, 0.909, 0.418, -0.006, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.184, 0.166, 0.345, 0.204, 0.977, -0.057, -0.979, 0.205, -0.001, 0.011, 0.056, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.998, -0.056, -0, 0.056, 0.998)},
	},
	[0.25] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.031, -0.233, -1.52, 1, -0, 0, 0, 0.992, -0.127, -0, 0.127, 0.992)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.988, -0.157, 0, 0.157, 0.988)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.517, -0.384, -0, 0.468, 0.865, -0.184, -0.881, 0.473, -0.017, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.076, 0.106, 0.343, 0.14, -0.989, 0.056, 0.99, 0.14, -0.003, -0.005, 0.056, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.517, -0.384, -0, 0.468, -0.865, 0.184, 0.881, 0.473, -0.017, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.076, 0.106, 0.343, 0.14, 0.989, -0.056, -0.99, 0.14, -0.003, 0.005, 0.056, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 1, -0.023, -0, 0.023, 1)},
	},
	[0.267] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.032, -0.302, -1.539, 1, -0, 0, 0, 0.998, -0.064, -0, 0.064, 0.998)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.978, -0.21, 0, 0.21, 0.978)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.473, -0.404, -0, 0.522, 0.833, -0.182, -0.85, 0.526, -0.029, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.969, 0.046, 0.341, 0.075, -0.996, 0.056, 0.997, 0.075, -0.006, 0.001, 0.056, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.473, -0.404, -0, 0.522, -0.833, 0.182, 0.85, 0.526, -0.029, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.969, 0.046, 0.341, 0.075, 0.996, -0.056, -0.997, 0.075, -0.006, -0.001, 0.056, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 1, 0.01, -0, -0.01, 1)},
	},
	[0.283] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.032, -0.356, -1.554, 1, -0, 0, 0, 1, -0.013, -0, 0.013, 1)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.968, -0.251, 0, 0.251, 0.968)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.437, -0.42, -0, 0.564, 0.806, -0.181, -0.823, 0.567, -0.038, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.882, -0.002, 0.34, 0.022, -0.998, 0.055, 1, 0.022, -0.008, 0.006, 0.056, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.437, -0.42, -0, 0.564, -0.806, 0.181, 0.823, 0.567, -0.038, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.882, -0.002, 0.34, 0.022, 0.998, -0.055, -1, 0.022, -0.008, -0.006, 0.056, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.999, 0.036, -0, -0.036, 0.999)},
	},
	[0.3] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.033, -0.399, -1.566, 1, -0, 0, 0, 1, 0.027, -0, -0.027, 1)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.959, -0.284, 0, 0.284, 0.959)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.409, -0.432, -0, 0.595, 0.783, -0.179, -0.8, 0.598, -0.045, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.814, -0.039, 0.338, -0.019, -0.998, 0.055, 1, -0.019, -0.009, 0.01, 0.055, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.409, -0.432, -0, 0.595, -0.783, 0.179, 0.8, 0.598, -0.045, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.814, -0.039, 0.338, -0.019, 0.998, -0.055, -1, -0.019, -0.009, -0.01, 0.055, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.998, 0.056, -0, -0.056, 0.998)},
	},
	[0.317] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.033, -0.431, -1.575, 1, -0, -0, 0, 0.998, 0.057, -0, -0.057, 0.998)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.952, -0.307, 0, 0.307, 0.952)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.388, -0.441, -0, 0.618, 0.765, -0.178, -0.782, 0.621, -0.05, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.764, -0.067, 0.337, -0.049, -0.997, 0.055, 0.999, -0.05, -0.01, 0.013, 0.055, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.388, -0.441, -0, 0.618, -0.765, 0.178, 0.782, 0.621, -0.05, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.764, -0.067, 0.337, -0.049, 0.997, -0.055, -0.999, -0.05, -0.01, -0.013, 0.055, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.997, 0.071, -0, -0.071, 0.997)},
	},
	[0.333] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.033, -0.453, -1.581, 1, -0, -0, 0, 0.997, 0.078, -0, -0.078, 0.997)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.946, -0.324, 0, 0.324, 0.946)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.373, -0.448, -0, 0.634, 0.753, -0.177, -0.77, 0.636, -0.054, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.729, -0.086, 0.337, -0.071, -0.996, 0.055, 0.997, -0.071, -0.011, 0.015, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.373, -0.448, -0, 0.634, -0.753, 0.177, 0.77, 0.636, -0.054, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.729, -0.086, 0.337, -0.071, 0.996, -0.055, -0.997, -0.071, -0.011, -0.015, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.997, 0.082, -0, -0.082, 0.997)},
	},
	[0.35] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.034, -0.467, -1.585, 1, -0, -0, 0, 0.996, 0.091, -0, -0.091, 0.996)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.942, -0.334, 0, 0.334, 0.942)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.364, -0.452, -0, 0.644, 0.744, -0.176, -0.761, 0.646, -0.056, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.707, -0.099, 0.336, -0.084, -0.995, 0.055, 0.996, -0.085, -0.012, 0.016, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.364, -0.452, -0, 0.644, -0.744, 0.176, 0.761, 0.646, -0.056, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.707, -0.099, 0.336, -0.084, 0.995, -0.055, -0.996, -0.085, -0.012, -0.016, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.996, 0.089, -0, -0.089, 0.996)},
	},
	[0.367] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.034, -0.474, -1.587, 1, -0, -0, 0, 0.995, 0.097, -0, -0.097, 0.995)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.941, -0.339, 0, 0.339, 0.941)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.359, -0.454, -0, 0.649, 0.74, -0.176, -0.757, 0.651, -0.057, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.695, -0.105, 0.336, -0.091, -0.994, 0.055, 0.996, -0.092, -0.012, 0.017, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.359, -0.454, -0, 0.649, -0.74, 0.176, 0.757, 0.651, -0.057, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.695, -0.105, 0.336, -0.091, 0.994, -0.055, -0.996, -0.092, -0.012, -0.017, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.996, 0.092, 0, -0.092, 0.996)},
	},
	[0.383] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.034, -0.476, -1.587, 1, -0, -0, 0, 0.995, 0.099, -0, -0.099, 0.995)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.94, -0.34, 0, 0.34, 0.94)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.358, -0.454, -0, 0.65, 0.739, -0.176, -0.756, 0.652, -0.057, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.693, -0.106, 0.336, -0.092, -0.994, 0.055, 0.996, -0.093, -0.012, 0.017, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.358, -0.454, -0, 0.65, -0.739, 0.176, 0.756, 0.652, -0.057, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.693, -0.106, 0.336, -0.092, 0.994, -0.055, -0.996, -0.093, -0.012, -0.017, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.996, 0.093, -0, -0.093, 0.996)},
	},
	[0.4] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.034, -0.473, -1.586, 1, -0, -0, 0, 0.995, 0.096, -0, -0.096, 0.995)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.941, -0.338, 0, 0.338, 0.941)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.36, -0.453, -0, 0.648, 0.741, -0.176, -0.758, 0.65, -0.057, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.698, -0.104, 0.336, -0.09, -0.994, 0.055, 0.996, -0.09, -0.012, 0.017, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.36, -0.453, -0, 0.648, -0.741, 0.176, 0.758, 0.65, -0.057, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.698, -0.104, 0.336, -0.09, 0.994, -0.055, -0.996, -0.09, -0.012, -0.017, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.996, 0.091, -0, -0.091, 0.996)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.034, -0.467, -1.585, 1, -0, -0, 0, 0.996, 0.09, -0, -0.09, 0.996)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.943, -0.334, 0, 0.334, 0.943)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.364, -0.451, -0, 0.644, 0.745, -0.176, -0.762, 0.645, -0.056, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.707, -0.098, 0.336, -0.084, -0.995, 0.055, 0.996, -0.085, -0.012, 0.016, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.364, -0.451, -0, 0.644, -0.745, 0.176, 0.762, 0.645, -0.056, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.707, -0.098, 0.336, -0.084, 0.995, -0.055, -0.996, -0.085, -0.012, -0.016, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.996, 0.089, -0, -0.089, 0.996)},
	},
	[0.433] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.034, -0.459, -1.582, 1, -0, -0, 0, 0.997, 0.083, -0, -0.083, 0.997)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.945, -0.328, 0, 0.328, 0.945)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.369, -0.449, -0, 0.638, 0.749, -0.176, -0.766, 0.64, -0.055, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.72, -0.091, 0.337, -0.076, -0.996, 0.055, 0.997, -0.077, -0.011, 0.015, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.369, -0.449, -0, 0.638, -0.749, 0.176, 0.766, 0.64, -0.055, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.72, -0.091, 0.337, -0.076, 0.996, -0.055, -0.997, -0.077, -0.011, -0.015, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.996, 0.085, -0, -0.085, 0.996)},
	},
	[0.45] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.033, -0.45, -1.58, 1, -0, -0, 0, 0.997, 0.075, -0, -0.075, 0.997)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.947, -0.322, 0, 0.322, 0.947)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.375, -0.447, -0, 0.632, 0.754, -0.177, -0.771, 0.634, -0.053, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.733, -0.084, 0.337, -0.068, -0.996, 0.055, 0.998, -0.069, -0.011, 0.015, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.375, -0.447, -0, 0.632, -0.754, 0.177, 0.771, 0.634, -0.053, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.733, -0.084, 0.337, -0.068, 0.996, -0.055, -0.998, -0.069, -0.011, -0.015, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.997, 0.081, -0, -0.081, 0.997)},
	},
	[0.467] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.033, -0.443, -1.578, 1, -0, -0, 0, 0.998, 0.068, -0, -0.068, 0.998)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.949, -0.316, 0, 0.316, 0.949)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.38, -0.445, -0, 0.627, 0.758, -0.177, -0.776, 0.629, -0.052, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.745, -0.077, 0.337, -0.061, -0.997, 0.055, 0.998, -0.062, -0.011, 0.014, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.38, -0.445, -0, 0.627, -0.758, 0.177, 0.776, 0.629, -0.052, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.745, -0.077, 0.337, -0.061, 0.997, -0.055, -0.998, -0.062, -0.011, -0.014, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.997, 0.077, -0, -0.077, 0.997)},
	},
	[0.483] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.033, -0.437, -1.576, 1, -0, -0, 0, 0.998, 0.063, -0, -0.063, 0.998)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.95, -0.312, 0, 0.312, 0.95)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.383, -0.443, -0, 0.623, 0.762, -0.177, -0.779, 0.625, -0.051, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.754, -0.073, 0.337, -0.056, -0.997, 0.055, 0.998, -0.056, -0.01, 0.014, 0.055, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.383, -0.443, -0, 0.623, -0.762, 0.177, 0.779, 0.625, -0.051, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.754, -0.073, 0.337, -0.056, 0.997, -0.055, -0.998, -0.056, -0.01, -0.014, 0.055, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.997, 0.075, -0, -0.075, 0.997)},
	},
	[0.5] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.033, -0.435, -1.576, 1, -0, 0, 0, 0.998, 0.061, 0, -0.061, 0.998)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, 0, 0, 0.951, -0.311, 0, 0.311, 0.951)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.385, -0.442, -0, 0.622, 0.763, -0.178, -0.78, 0.624, -0.051, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.757, -0.071, 0.337, -0.054, -0.997, 0.055, 0.998, -0.054, -0.01, 0.013, 0.055, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.385, -0.442, -0, 0.622, -0.763, 0.178, 0.78, 0.624, -0.051, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.757, -0.071, 0.337, -0.054, 0.997, -0.055, -0.998, -0.054, -0.01, -0.013, 0.055, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, 0, 0.997, 0.074, -0, -0.074, 0.997)},
	},
	[1] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.028, -0.031, -1.464, 1, 0, 0, 0, 0.95, -0.311, 0, 0.311, 0.95)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.65, -0.326, -0, 0.297, 0.937, -0.184, -0.952, 0.306, 0.017, 0.072, 0.17, 0.983)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-1.396, 0.283, 0.349, 0.328, -0.943, 0.059, 0.944, 0.329, 0.004, -0.023, 0.054, 0.998)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.65, -0.326, -0, 0.297, -0.937, 0.184, 0.952, 0.306, 0.017, -0.072, 0.17, 0.983)},
		["Right Leg"] = {["CFrame"] = CFrame.new(1.396, 0.283, 0.349, 0.328, 0.943, -0.059, -0.944, 0.329, 0.004, 0.023, 0.054, 0.998)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 1, 0, -0, -0, 0.993, -0.119, 0, 0.119, 0.993)},
	},
}
PlayAnimation("Sex46", Sex46)

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

local Sex46 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.513, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.004, -0.01, 0.004, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.017, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.35, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.017, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.35, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.003, 0.096, 0.037, 1, -0.006, -0.014, -0.001, 0.9, -0.436, 0.015, 0.436, 0.9)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.002, -0.004, -0.003, 0.45, -0.893, 0.004, 0.893, 0.45)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
	[0.017] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.513, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.004, -0.01, 0.004, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.016, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.351, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.016, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.351, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0, 0, 0, 1, 0.001, -0, -0.001, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.001, -0, -0.001, 1, 0.001, 0, -0.001, 1)},
	},
	[0.033] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.511, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.004, -0.01, 0.004, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.014, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.353, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.014, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.352, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.001, 0.001, 0.001, 1, 0.005, -0.001, -0.005, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.002, -0.001, -0.002, 1, 0.004, 0.001, -0.004, 1)},
	},
	[0.05] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.508, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.003, -0.01, 0.004, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.012, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.356, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.012, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.355, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.001, 0.003, 0.001, 1, 0.009, -0.003, -0.009, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.004, -0.002, -0.004, 1, 0.008, 0.002, -0.008, 1)},
	},
	[0.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.505, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.003, -0.01, 0.005, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.009, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.359, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.008, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.358, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.002, 0.004, 0.002, 1, 0.014, -0.004, -0.014, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.007, -0.003, -0.007, 1, 0.012, 0.003, -0.012, 1)},
	},
	[0.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.502, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.002, -0.009, 0.005, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.005, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.362, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.005, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.361, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.003, 0.005, 0.003, 1, 0.019, -0.005, -0.019, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.009, -0.004, -0.009, 1, 0.016, 0.004, -0.016, 1)},
	},
	[0.1] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.499, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.002, -0.009, 0.005, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.061, -0.002, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.366, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.061, -0.002, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.627, 0.363, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.003, 0.006, 0.003, 1, 0.023, -0.006, -0.023, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.011, -0.005, -0.011, 1, 0.019, 0.005, -0.019, 1)},
	},
	[0.117] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.496, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.001, -0.009, 0.006, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.061, 0.001, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.369, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.061, 0.001, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.627, 0.366, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.004, 0.007, 0.003, 1, 0.025, -0.007, -0.025, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.012, -0.005, -0.011, 1, 0.02, 0.005, -0.02, 1)},
	},
	[0.133] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.494, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.001, -0.008, 0.006, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.061, 0.003, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.372, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.061, 0.003, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.627, 0.368, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.003, 0.006, 0.003, 1, 0.024, -0.007, -0.024, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.011, -0.005, -0.011, 1, 0.02, 0.005, -0.019, 1)},
	},
	[0.15] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.492, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.001, -0.008, 0.006, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.061, 0.005, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.373, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.061, 0.005, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.627, 0.369, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.003, 0.005, 0.003, 1, 0.019, -0.005, -0.019, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.009, -0.004, -0.009, 1, 0.016, 0.004, -0.016, 1)},
	},
	[0.167] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.492, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.001, -0.008, 0.006, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.061, 0.005, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.373, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.061, 0.005, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.627, 0.37, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.002, 0.003, 0.002, 1, 0.011, -0.003, -0.011, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.005, -0.002, -0.005, 1, 0.009, 0.002, -0.009, 1)},
	},
	[0.183] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.493, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.001, -0.008, 0.006, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.061, 0.003, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.372, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.061, 0.004, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.627, 0.368, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, -0.001, -0, 1, -0.003, 0.001, 0.003, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.001, 0.001, 0.001, 1, -0.002, -0.001, 0.002, 1)},
	},
	[0.2] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.496, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.001, -0.009, 0.006, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.061, 0, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.368, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.061, 0.001, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.627, 0.366, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.003, -0.006, -0.003, 1, -0.022, 0.006, 0.022, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.01, 0.005, 0.01, 1, -0.018, -0.005, 0.018, 1)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.502, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.002, -0.009, 0.005, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.061, -0.005, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.627, 0.363, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.061, -0.005, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.361, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.006, -0.013, -0.007, 0.999, -0.048, 0.013, 0.048, 0.999)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.022, 0.011, 0.023, 0.999, -0.039, -0.01, 0.04, 0.999)},
	},
	[0.233] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.509, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.003, -0.01, 0.004, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.013, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.355, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.012, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.354, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0.011, -0.023, -0.012, 0.997, -0.081, 0.022, 0.081, 0.996)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.999, -0.037, 0.019, 0.039, 0.997, -0.067, -0.016, 0.067, 0.998)},
	},
	[0.25] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.519, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.005, -0.011, 0.003, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.023, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.344, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.023, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.345, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.999, 0.015, -0.035, -0.019, 0.992, -0.122, 0.032, 0.123, 0.992)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.998, -0.056, 0.03, 0.059, 0.993, -0.1, -0.024, 0.102, 0.995)},
	},
	[0.267] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.532, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.007, -0.012, 0.001, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.036, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.33, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.036, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.333, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.999, 0.02, -0.047, -0.027, 0.986, -0.163, 0.043, 0.164, 0.986)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.996, -0.074, 0.041, 0.079, 0.988, -0.134, -0.03, 0.136, 0.99)},
	},
	[0.283] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.549, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.01, -0.014, -0.001, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.052, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.312, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.053, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.318, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.998, 0.023, -0.056, -0.033, 0.98, -0.196, 0.051, 0.197, 0.979)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.995, -0.088, 0.05, 0.095, 0.983, -0.16, -0.035, 0.164, 0.986)},
	},
	[0.3] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.568, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.013, -0.016, -0.003, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.063, -0.072, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.629, 0.291, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.063, -0.073, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.3, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.003, -0.004, -0.003, 0.385, -0.923, 0.004, 0.923, 0.385)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.998, 0.025, -0.064, -0.038, 0.975, -0.221, 0.057, 0.223, 0.973)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.993, -0.099, 0.058, 0.108, 0.978, -0.18, -0.039, 0.185, 0.982)},
	},
	[0.317] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.592, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.017, -0.019, -0.006, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.063, -0.096, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.629, 0.265, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.063, -0.097, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.629, 0.279, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.026, -0.07, -0.042, 0.97, -0.239, 0.062, 0.242, 0.968)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.992, -0.107, 0.064, 0.118, 0.974, -0.196, -0.041, 0.201, 0.979)},
	},
	[0.333] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.619, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.021, -0.021, -0.009, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.063, -0.124, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.63, 0.236, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.063, -0.126, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.629, 0.254, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.027, -0.074, -0.045, 0.967, -0.252, 0.065, 0.255, 0.965)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, -0.113, 0.068, 0.124, 0.971, -0.206, -0.043, 0.213, 0.976)},
	},
	[0.35] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.647, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.025, -0.024, -0.012, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.064, -0.152, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.63, 0.206, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.064, -0.154, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.63, 0.229, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.003, 0.096, 0.037, 1, -0.01, -0.019, -0.003, 0.797, -0.604, 0.021, 0.604, 0.797)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.002, -0.004, -0.003, 0.468, -0.884, 0.004, 0.884, 0.468)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.028, -0.077, -0.047, 0.964, -0.26, 0.067, 0.263, 0.962)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, -0.116, 0.07, 0.129, 0.969, -0.213, -0.044, 0.22, 0.975)},
	},
	[0.367] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.67, -2.503, -1, -0, -0, 0, -0.016, -1, -0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.029, -0.027, -0.015, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.064, -0.176, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.63, 0.18, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.064, -0.178, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.63, 0.208, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.028, -0.078, -0.048, 0.963, -0.265, 0.068, 0.267, 0.961)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.99, -0.118, 0.072, 0.131, 0.968, -0.216, -0.044, 0.223, 0.974)},
	},
	[0.383] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.69, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.032, -0.029, -0.018, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.196, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.159, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.198, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.63, 0.19, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.028, -0.078, -0.048, 0.963, -0.265, 0.068, 0.268, 0.961)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.99, -0.118, 0.072, 0.131, 0.967, -0.217, -0.044, 0.224, 0.974)},
	},
	[0.4] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.706, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.035, -0.031, -0.02, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.212, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.141, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.215, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.63, 0.175, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.028, -0.078, -0.047, 0.963, -0.264, 0.067, 0.266, 0.961)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, -0.117, 0.071, 0.13, 0.968, -0.215, -0.044, 0.222, 0.974)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.719, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.037, -0.032, -0.021, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.225, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.127, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.228, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.163, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.028, -0.076, -0.047, 0.964, -0.26, 0.067, 0.263, 0.963)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, -0.116, 0.07, 0.128, 0.969, -0.212, -0.043, 0.219, 0.975)},
	},
	[0.433] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.73, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.039, -0.033, -0.022, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.236, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.116, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.239, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.154, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.027, -0.075, -0.046, 0.966, -0.256, 0.065, 0.258, 0.964)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, -0.114, 0.069, 0.126, 0.97, -0.209, -0.043, 0.216, 0.976)},
	},
	[0.45] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.737, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.04, -0.034, -0.023, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.243, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.108, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.246, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.147, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.027, -0.073, -0.045, 0.967, -0.251, 0.064, 0.253, 0.965)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, -0.112, 0.067, 0.123, 0.971, -0.205, -0.042, 0.211, 0.976)},
	},
	[0.467] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.742, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.041, -0.034, -0.024, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.248, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.103, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.252, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.142, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.027, -0.072, -0.044, 0.968, -0.246, 0.063, 0.249, 0.966)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.992, -0.11, 0.066, 0.121, 0.972, -0.201, -0.042, 0.208, 0.977)},
	},
	[0.483] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.745, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.041, -0.035, -0.024, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.252, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.099, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.255, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.14, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.026, -0.071, -0.043, 0.969, -0.243, 0.062, 0.246, 0.967)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.992, -0.109, 0.065, 0.12, 0.973, -0.199, -0.041, 0.205, 0.978)},
	},
	[0.5] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.747, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.041, -0.035, -0.025, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.253, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.098, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.066, -0.256, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.138, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.002, -0.004, -0.002, 0.53, -0.848, 0.004, 0.848, 0.53)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.026, -0.071, -0.043, 0.969, -0.242, 0.062, 0.244, 0.968)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.992, -0.108, 0.064, 0.119, 0.973, -0.198, -0.041, 0.204, 0.978)},
	},
	[0.517] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.747, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.041, -0.035, -0.025, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.253, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.098, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.066, -0.256, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.139, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[0.533] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.745, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.041, -0.035, -0.024, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.251, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.099, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.255, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.14, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[0.55] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.743, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.041, -0.034, -0.024, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.249, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.102, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.252, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.142, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[0.567] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.74, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.04, -0.034, -0.024, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.246, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.105, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.249, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.144, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[0.583] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.737, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.04, -0.034, -0.023, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.243, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.632, 0.109, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.246, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.147, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[0.6] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.733, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.039, -0.033, -0.023, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.24, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.112, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.243, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.15, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.003, 0.096, 0.037, 1, -0.006, -0.014, -0.001, 0.889, -0.457, 0.016, 0.457, 0.889)},
	},
	[0.617] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.73, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.039, -0.033, -0.023, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.236, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.115, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.239, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.153, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[0.633] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.728, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.038, -0.033, -0.022, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.234, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.118, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.237, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.155, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[0.65] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.726, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.038, -0.033, -0.022, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.232, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.12, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.235, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.157, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[0.667] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.726, -2.503, -1, -0, -0, 0, -0.016, -1, -0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.651, 0.758, 0.038, -0.033, -0.022, 0.999)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.065, -0.232, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.631, 0.121, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.065, -0.234, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.631, 0.158, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
	},
	[1] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0, -2.513, -2.503, -1, -0, -0, 0, -0.016, -1, 0, -1, 0.016)},
		["Head"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.758, -0.652, 0.01, 0.652, 0.758, 0.004, -0.01, 0.004, 1)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.062, -0.017, 0.912, 0.985, 0.007, 0.173, -0.031, -0.975, 0.218, 0.171, -0.22, -0.96)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.628, 0.35, 0.317, 0.825, -0.565, 0.006, 0.521, 0.766, 0.376, -0.217, -0.307, 0.926)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.062, -0.017, 0.912, 0.985, -0.007, -0.173, 0.031, -0.975, 0.218, -0.171, -0.22, -0.96)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.628, 0.35, 0.317, 0.825, 0.565, -0.006, -0.521, 0.766, 0.376, 0.217, -0.307, 0.926)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.003, 0.096, 0.037, 1, -0.006, -0.014, -0.001, 0.9, -0.436, 0.015, 0.436, 0.9)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, -0.002, -0.004, -0.003, 0.45, -0.893, 0.004, 0.893, 0.45)},
		["M6DUpperL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DUpperR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
}

PlayAnimation("Sex46", Sex46)
