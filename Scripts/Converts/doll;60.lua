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

local Sex60 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.195, -0.023, -0.014, 0.966, 0.259, 0, -0.166, 0.621, -0.766, -0.198, 0.74, 0.643)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.989, -0.146, 0.015, 0.136, 0.95, 0.282, -0.056, -0.277, 0.959)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.376, -0.137, -0, 0.257, 0.913, -0.316, -0.966, 0.238, -0.099, -0.015, 0.33, 0.944)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.341, 0.037, 0.363, 0.81, 0.513, 0.285, -0.569, 0.804, 0.172, -0.141, -0.301, 0.943)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.376, -0.137, -0, 0.237, -0.889, 0.392, 0.971, 0.207, -0.118, 0.023, 0.408, 0.913)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.651, -0.273, 0.328, 0.569, -0.815, -0.108, 0.709, 0.552, -0.439, 0.417, 0.173, 0.892)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.983, 0.169, -0.073, -0.173, 0.71, -0.683, -0.064, 0.684, 0.727)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.976, 0.198, -0.089, -0.198, 0.643, -0.74, -0.089, 0.74, 0.667)},
		["MeatBalls"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.855, 0.518, 0, -0.518, 0.855)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.508, -0.861, 0, 0.861, 0.508)},
		["Sausage2"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage3"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage4"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.977, 0.213, 0, -0.213, 0.977)},
	},
	[0.017] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.983, 0.171, -0.072, -0.175, 0.723, -0.669, -0.063, 0.67, 0.74)},
	},
	[0.033] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.192, -0.026, -0.015, 0.946, 0.323, -0.006, -0.206, 0.589, -0.781, -0.249, 0.74, 0.624)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.979, -0.206, -0.011, 0.197, 0.921, 0.336, -0.059, -0.331, 0.942)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.298, -0.147, 0.016, 0.253, 0.931, -0.263, -0.967, 0.247, -0.058, 0.011, 0.269, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.233, 0.003, 0.371, 0.769, 0.534, 0.352, -0.613, 0.772, 0.168, -0.182, -0.345, 0.921)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.428, -0.141, -0.031, 0.221, -0.859, 0.462, 0.975, 0.212, -0.072, -0.036, 0.466, 0.884)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.746, -0.297, 0.251, 0.552, -0.833, -0.036, 0.737, 0.508, -0.446, 0.39, 0.22, 0.894)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.982, 0.178, -0.067, -0.181, 0.76, -0.624, -0.06, 0.625, 0.778)},
	},
	[0.05] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.98, 0.189, -0.058, -0.19, 0.816, -0.545, -0.055, 0.546, 0.836)},
	},
	[0.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.978, 0.202, -0.045, -0.201, 0.882, -0.427, -0.047, 0.426, 0.903)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.98, 0.185, -0.066, -0.18, 0.707, -0.684, -0.08, 0.683, 0.726)},
	},
	[0.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.175, -0.043, -0.02, 0.935, 0.355, 0.01, -0.221, 0.604, -0.765, -0.278, 0.713, 0.643)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.971, -0.235, -0.034, 0.233, 0.912, 0.339, -0.049, -0.337, 0.94)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.237, -0.19, 0.035, 0.274, 0.932, -0.236, -0.961, 0.274, -0.033, 0.034, 0.236, 0.971)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.148, -0.017, 0.391, 0.778, 0.5, 0.382, -0.595, 0.781, 0.189, -0.204, -0.374, 0.905)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.43, -0.183, -0.066, 0.231, -0.84, 0.491, 0.971, 0.229, -0.065, -0.058, 0.492, 0.868)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.741, -0.33, 0.206, 0.581, -0.813, -0.014, 0.717, 0.521, -0.463, 0.384, 0.259, 0.886)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.976, 0.216, -0.024, -0.215, 0.941, -0.263, -0.034, 0.261, 0.965)},
	},
	[0.1] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.974, 0.228, 0.003, -0.228, 0.972, -0.052, -0.015, 0.05, 0.999)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.983, 0.178, -0.053, -0.17, 0.747, -0.643, -0.075, 0.641, 0.764)},
	},
	[0.117] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.137, -0.079, -0.029, 0.948, 0.314, 0.06, -0.188, 0.7, -0.689, -0.258, 0.642, 0.722)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.978, -0.203, -0.041, 0.207, 0.947, 0.247, -0.012, -0.25, 0.968)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.226, -0.283, 0.055, 0.332, 0.905, -0.267, -0.942, 0.331, -0.05, 0.043, 0.268, 0.962)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.135, -0.004, 0.43, 0.87, 0.37, 0.325, -0.456, 0.854, 0.251, -0.184, -0.367, 0.912)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.336, -0.285, -0.098, 0.291, -0.852, 0.436, 0.957, 0.261, -0.129, -0.004, 0.455, 0.891)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.55, -0.369, 0.238, 0.681, -0.726, -0.096, 0.603, 0.63, -0.489, 0.416, 0.276, 0.867)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.972, 0.234, 0.033, -0.236, 0.958, 0.161, 0.006, -0.165, 0.986)},
		["MeatBalls"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.86, -0.51, 0, 0.51, 0.86)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
	[0.133] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.971, 0.234, 0.057, -0.24, 0.913, 0.33, 0.025, -0.334, 0.942)},
	},
	[0.15] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.231, 0.076, -0.24, 0.858, 0.455, 0.039, -0.459, 0.887)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.983, 0.177, -0.043, -0.168, 0.784, -0.598, -0.072, 0.595, 0.8)},
	},
	[0.167] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.086, -0.128, -0.043, 0.97, 0.213, 0.119, -0.114, 0.826, -0.552, -0.216, 0.522, 0.825)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.99, -0.13, -0.046, 0.133, 0.987, 0.088, 0.034, -0.093, 0.995)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.25, -0.408, 0.075, 0.413, 0.848, -0.332, -0.909, 0.404, -0.099, 0.05, 0.343, 0.938)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.169, 0.031, 0.482, 0.968, 0.156, 0.194, -0.212, 0.926, 0.313, -0.131, -0.344, 0.93)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.178, -0.426, -0.127, 0.373, -0.874, 0.312, 0.921, 0.31, -0.235, 0.109, 0.375, 0.921)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.235, -0.413, 0.32, 0.788, -0.562, -0.249, 0.398, 0.775, -0.491, 0.469, 0.288, 0.835)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.227, 0.09, -0.239, 0.808, 0.538, 0.05, -0.544, 0.838)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage2"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.968, 0.249, 0, -0.249, 0.968)},
		["Sausage3"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.952, 0.305, 0, -0.305, 0.952)},
	},
	[0.183] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.053, -0.16, -0.051, 0.98, 0.138, 0.146, -0.059, 0.892, -0.448, -0.192, 0.43, 0.882)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.995, -0.079, -0.055, 0.077, 0.997, -0.024, 0.056, 0.019, 0.998)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.275, -0.494, 0.087, 0.462, 0.805, -0.373, -0.885, 0.444, -0.138, 0.055, 0.394, 0.918)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.201, 0.051, 0.514, 0.995, 0.004, 0.097, -0.036, 0.943, 0.332, -0.091, -0.334, 0.938)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.078, -0.518, -0.145, 0.415, -0.883, 0.22, 0.89, 0.343, -0.3, 0.189, 0.321, 0.928)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.026, -0.438, 0.381, 0.83, -0.434, -0.352, 0.246, 0.849, -0.467, 0.501, 0.301, 0.811)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.224, 0.097, -0.238, 0.774, 0.586, 0.056, -0.591, 0.804)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.982, 0.184, -0.037, -0.173, 0.818, -0.548, -0.071, 0.545, 0.835)},
	},
	[0.2] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.223, 0.1, -0.238, 0.763, 0.602, 0.058, -0.607, 0.793)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.982, 0.188, -0.034, -0.178, 0.834, -0.522, -0.07, 0.519, 0.852)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.223, 0.099, -0.238, 0.765, 0.599, 0.058, -0.604, 0.795)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.76, -0.65, 0, 0.65, 0.76)},
	},
	[0.233] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.016, -0.196, -0.061, 0.986, 0.046, 0.16, 0.006, 0.951, -0.31, -0.166, 0.307, 0.937)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.997, -0.021, -0.07, 0.009, 0.986, -0.165, 0.073, 0.164, 0.984)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.323, -0.613, 0.098, 0.509, 0.753, -0.417, -0.859, 0.475, -0.193, 0.053, 0.456, 0.888)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.25, 0.054, 0.544, 0.981, -0.191, -0.02, 0.187, 0.926, 0.328, -0.044, -0.325, 0.945)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.015, -0.63, -0.166, 0.442, -0.89, 0.11, 0.851, 0.377, -0.366, 0.284, 0.255, 0.924)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.211, -0.462, 0.469, 0.846, -0.258, -0.467, 0.051, 0.91, -0.411, 0.531, 0.324, 0.783)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.224, 0.098, -0.238, 0.771, 0.59, 0.057, -0.596, 0.801)},
		["MeatBalls"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.547, -0.837, 0, 0.837, 0.547)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
	[0.25] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.225, 0.096, -0.238, 0.782, 0.576, 0.055, -0.581, 0.812)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.98, 0.196, -0.028, -0.185, 0.86, -0.475, -0.068, 0.47, 0.88)},
	},
	[0.267] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.002, -0.213, -0.065, 0.989, -0.001, 0.15, 0.035, 0.974, -0.223, -0.146, 0.226, 0.963)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.997, 0.008, -0.079, -0.028, 0.965, -0.262, 0.074, 0.264, 0.962)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.39, -0.713, 0.099, 0.517, 0.736, -0.438, -0.855, 0.462, -0.235, 0.029, 0.496, 0.868)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.302, 0.014, 0.543, 0.944, -0.32, -0.081, 0.33, 0.894, 0.305, -0.025, -0.314, 0.949)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.011, -0.695, -0.178, 0.429, -0.902, 0.055, 0.84, 0.375, -0.392, 0.333, 0.214, 0.918)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.315, -0.459, 0.548, 0.839, -0.133, -0.527, -0.075, 0.931, -0.356, 0.538, 0.338, 0.772)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.226, 0.092, -0.239, 0.797, 0.555, 0.052, -0.561, 0.826)},
	},
	[0.283] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.228, 0.088, -0.239, 0.814, 0.529, 0.049, -0.534, 0.844)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.979, 0.201, -0.027, -0.192, 0.876, -0.442, -0.066, 0.438, 0.897)},
	},
	[0.3] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.229, 0.083, -0.24, 0.835, 0.495, 0.044, -0.5, 0.865)},
	},
	[0.317] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.005, -0.216, -0.066, 0.991, -0.017, 0.13, 0.039, 0.984, -0.172, -0.125, 0.175, 0.977)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.997, 0.018, -0.079, -0.043, 0.943, -0.331, 0.068, 0.333, 0.94)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.47, -0.801, 0.092, 0.499, 0.743, -0.446, -0.866, 0.422, -0.267, -0.01, 0.52, 0.854)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.356, -0.056, 0.522, 0.907, -0.408, -0.105, 0.421, 0.863, 0.279, -0.023, -0.297, 0.955)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.058, -0.729, -0.185, 0.393, -0.919, 0.038, 0.85, 0.347, -0.395, 0.35, 0.188, 0.918)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.33, -0.44, 0.621, 0.831, -0.047, -0.554, -0.154, 0.938, -0.311, 0.534, 0.344, 0.772)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.231, 0.076, -0.24, 0.858, 0.455, 0.039, -0.459, 0.887)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage2"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.819, 0.574, 0, -0.574, 0.819)},
		["Sausage3"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.927, 0.375, 0, -0.375, 0.927)},
	},
	[0.333] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.232, 0.069, -0.24, 0.881, 0.407, 0.034, -0.411, 0.911)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.978, 0.205, -0.028, -0.197, 0.883, -0.425, -0.062, 0.421, 0.905)},
	},
	[0.35] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.002, -0.214, -0.066, 0.994, -0.021, 0.109, 0.036, 0.989, -0.141, -0.105, 0.144, 0.984)},
		["Head"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.997, 0.022, -0.075, -0.049, 0.923, -0.382, 0.061, 0.384, 0.921)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.546, -0.872, 0.083, 0.471, 0.758, -0.452, -0.881, 0.374, -0.292, -0.052, 0.535, 0.843)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.408, -0.125, 0.497, 0.877, -0.468, -0.113, 0.48, 0.839, 0.256, -0.025, -0.279, 0.96)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.139, -0.747, -0.187, 0.351, -0.936, 0.036, 0.866, 0.31, -0.392, 0.355, 0.169, 0.919)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.314, -0.415, 0.684, 0.824, 0.013, -0.566, -0.204, 0.939, -0.276, 0.528, 0.343, 0.777)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.97, 0.234, 0.061, -0.24, 0.905, 0.351, 0.027, -0.355, 0.935)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.978, 0.206, -0.029, -0.199, 0.885, -0.421, -0.061, 0.418, 0.906)},
	},
	[0.367] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.971, 0.234, 0.051, -0.239, 0.928, 0.287, 0.02, -0.291, 0.957)},
	},
	[0.383] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.971, 0.234, 0.04, -0.238, 0.947, 0.214, 0.012, -0.218, 0.976)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.978, 0.208, -0.033, -0.203, 0.885, -0.419, -0.058, 0.416, 0.907)},
		["MeatBalls"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.91, -0.414, 0, 0.414, 0.91)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
	[0.4] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.011, -0.201, -0.062, 0.996, -0.011, 0.093, 0.026, 0.987, -0.157, -0.09, 0.159, 0.983)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.998, 0.02, -0.067, -0.044, 0.92, -0.391, 0.054, 0.393, 0.918)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.592, -0.885, 0.07, 0.429, 0.779, -0.456, -0.899, 0.323, -0.295, -0.082, 0.537, 0.84)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.451, -0.159, 0.472, 0.881, -0.463, -0.101, 0.473, 0.846, 0.245, -0.028, -0.264, 0.964)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.202, -0.731, -0.176, 0.306, -0.951, 0.053, 0.886, 0.264, -0.381, 0.349, 0.163, 0.923)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.255, -0.388, 0.713, 0.829, 0.008, -0.559, -0.191, 0.944, -0.269, 0.525, 0.33, 0.784)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.972, 0.234, 0.029, -0.235, 0.963, 0.134, 0.003, -0.137, 0.991)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.973, 0.231, 0.016, -0.232, 0.972, 0.045, -0.006, -0.047, 0.999)},
	},
	[0.433] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.039, -0.174, -0.055, 0.996, 0.018, 0.085, 0.003, 0.97, -0.242, -0.087, 0.241, 0.967)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.999, 0.006, -0.051, -0.023, 0.942, -0.336, 0.046, 0.337, 0.94)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.593, -0.811, 0.05, 0.366, 0.811, -0.457, -0.926, 0.268, -0.267, -0.094, 0.52, 0.849)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.481, -0.139, 0.447, 0.931, -0.36, -0.059, 0.363, 0.898, 0.25, -0.037, -0.254, 0.967)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.238, -0.667, -0.147, 0.254, -0.962, 0.097, 0.911, 0.204, -0.359, 0.326, 0.18, 0.928)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.133, -0.357, 0.69, 0.847, -0.095, -0.523, -0.08, 0.95, -0.303, 0.525, 0.298, 0.797)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.974, 0.228, 0.003, -0.228, 0.972, -0.052, -0.015, 0.05, 0.999)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.977, 0.21, -0.039, -0.205, 0.872, -0.444, -0.059, 0.442, 0.895)},
	},
	[0.45] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.975, 0.223, -0.01, -0.222, 0.964, -0.148, -0.024, 0.146, 0.989)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage2"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.819, 0.574, 0, -0.574, 0.819)},
		["Sausage3"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.927, 0.375, 0, -0.375, 0.927)},
	},
	[0.467] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.976, 0.218, -0.021, -0.217, 0.947, -0.235, -0.031, 0.234, 0.972)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.977, 0.21, -0.047, -0.205, 0.844, -0.495, -0.064, 0.493, 0.867)},
	},
	[0.483] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.078, -0.136, -0.045, 0.995, 0.059, 0.076, -0.027, 0.929, -0.369, -0.093, 0.365, 0.926)},
		["Head"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.999, -0.016, -0.033, 0.008, 0.972, -0.237, 0.036, 0.236, 0.971)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.565, -0.68, 0.027, 0.287, 0.845, -0.451, -0.954, 0.208, -0.218, -0.09, 0.492, 0.866)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.501, -0.085, 0.423, 0.984, -0.181, 0.004, 0.174, 0.951, 0.254, -0.05, -0.249, 0.967)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.256, -0.569, -0.105, 0.195, -0.968, 0.158, 0.936, 0.136, -0.326, 0.294, 0.212, 0.932)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.031, -0.322, 0.633, 0.848, -0.264, -0.46, 0.097, 0.93, -0.354, 0.521, 0.255, 0.815)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.977, 0.212, -0.031, -0.211, 0.926, -0.314, -0.038, 0.313, 0.949)},
	},
	[0.5] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.978, 0.206, -0.04, -0.205, 0.9, -0.385, -0.044, 0.384, 0.922)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage2"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage3"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
	[0.517] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.112, -0.103, -0.036, 0.993, 0.095, 0.066, -0.052, 0.876, -0.479, -0.103, 0.472, 0.876)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.536, -0.559, 0.007, 0.217, 0.871, -0.441, -0.973, 0.154, -0.173, -0.083, 0.467, 0.881)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.517, -0.032, 0.402, 0.998, -0.011, 0.061, -0.005, 0.969, 0.249, -0.062, -0.249, 0.967)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.267, -0.48, -0.067, 0.144, -0.967, 0.211, 0.953, 0.078, -0.292, 0.266, 0.243, 0.933)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.177, -0.293, 0.578, 0.821, -0.412, -0.395, 0.256, 0.884, -0.39, 0.51, 0.219, 0.832)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.979, 0.2, -0.047, -0.2, 0.872, -0.446, -0.048, 0.446, 0.894)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage2"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
	[0.533] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.98, 0.194, -0.053, -0.194, 0.844, -0.5, -0.052, 0.5, 0.865)},
		["MeatBalls"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.964, 0.267, 0, -0.267, 0.964)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
	[0.55] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.151, -0.065, -0.026, 0.99, 0.136, 0.048, -0.081, 0.799, -0.596, -0.119, 0.586, 0.802)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.499, -0.417, -0.014, 0.145, 0.895, -0.423, -0.987, 0.101, -0.125, -0.069, 0.435, 0.898)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.526, 0.025, 0.38, 0.974, 0.186, 0.126, -0.211, 0.95, 0.231, -0.077, -0.251, 0.965)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.282, -0.376, -0.026, 0.092, -0.959, 0.27, 0.969, 0.023, -0.247, 0.231, 0.284, 0.931)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.345, -0.261, 0.512, 0.758, -0.572, -0.312, 0.431, 0.8, -0.418, 0.489, 0.183, 0.853)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.98, 0.189, -0.058, -0.19, 0.816, -0.545, -0.055, 0.546, 0.836)},
	},
	[0.567] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.981, 0.184, -0.063, -0.185, 0.79, -0.584, -0.058, 0.584, 0.809)},
	},
	[0.583] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.982, 0.179, -0.066, -0.182, 0.767, -0.615, -0.06, 0.616, 0.786)},
	},
	[0.6] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.18, -0.038, -0.018, 0.983, 0.179, 0.029, -0.111, 0.721, -0.684, -0.143, 0.67, 0.729)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.458, -0.293, -0.023, 0.125, 0.911, -0.393, -0.991, 0.095, -0.096, -0.051, 0.401, 0.915)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.499, 0.058, 0.365, 0.919, 0.347, 0.187, -0.383, 0.9, 0.207, -0.097, -0.262, 0.96)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.307, -0.278, 0.001, 0.09, -0.943, 0.32, 0.98, 0.026, -0.198, 0.178, 0.331, 0.927)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.489, -0.247, 0.445, 0.681, -0.695, -0.231, 0.568, 0.7, -0.432, 0.462, 0.163, 0.872)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.982, 0.176, -0.069, -0.179, 0.747, -0.64, -0.061, 0.641, 0.765)},
	},
	[0.617] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.982, 0.173, -0.071, -0.176, 0.731, -0.659, -0.062, 0.66, 0.749)},
	},
	[0.633] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.192, -0.025, -0.015, 0.974, 0.226, 0.011, -0.144, 0.657, -0.74, -0.174, 0.719, 0.672)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.41, -0.193, -0.013, 0.186, 0.918, -0.35, -0.982, 0.164, -0.094, -0.029, 0.361, 0.932)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.417, 0.054, 0.362, 0.854, 0.459, 0.246, -0.506, 0.842, 0.185, -0.123, -0.283, 0.951)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.345, -0.191, 0.006, 0.162, -0.917, 0.363, 0.982, 0.115, -0.148, 0.094, 0.381, 0.92)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.595, -0.257, 0.375, 0.61, -0.777, -0.156, 0.662, 0.608, -0.438, 0.435, 0.164, 0.886)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.983, 0.171, -0.072, -0.174, 0.719, -0.673, -0.063, 0.673, 0.737)},
	},
	[0.65] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.983, 0.17, -0.073, -0.173, 0.712, -0.68, -0.063, 0.681, 0.729)},
	},
	[0.667] = {
		["Torso"] = {["CFrame"] = CFrame.new(0.195, -0.023, -0.014, 0.968, 0.25, 0.003, -0.161, 0.629, -0.761, -0.192, 0.736, 0.649)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.989, -0.146, 0.015, 0.136, 0.95, 0.282, -0.056, -0.277, 0.959)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.385, -0.15, -0.004, 0.237, 0.916, -0.325, -0.971, 0.217, -0.097, -0.018, 0.338, 0.941)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.362, 0.042, 0.362, 0.82, 0.501, 0.275, -0.555, 0.813, 0.175, -0.136, -0.296, 0.945)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.368, -0.15, 0.002, 0.216, -0.898, 0.385, 0.976, 0.181, -0.125, 0.043, 0.402, 0.915)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.638, -0.268, 0.34, 0.578, -0.807, -0.12, 0.699, 0.565, -0.439, 0.422, 0.17, 0.891)},
		["M6DOrbs"] = {["CFrame"] = CFrame.new(0.053, -0.089, 0.198, 0.983, 0.169, -0.073, -0.173, 0.71, -0.683, -0.064, 0.684, 0.727)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.976, 0.198, -0.089, -0.198, 0.643, -0.74, -0.089, 0.74, 0.667)},
		["MeatBalls"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.878, 0.479, 0, -0.479, 0.878)},
		["Peener"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["Sausage1"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.422, -0.907, 0, 0.907, 0.422)},
	},
}

PlayAnimation("Sex60", Sex60)

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

local Sex60 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.6, -1.7, 1, -0, 0, 0, -0.707, -0.707, -0, 0.707, -0.707)},
		["Head"] = {["CFrame"] = CFrame.new(-0.064, 0.409, 0.009, 0.746, -0.666, 0.017, 0.067, 0.101, 0.993, -0.663, -0.739, 0.12)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.377, 0.578, -0.341, -0.635, -0.448, 0.629, 0.729, -0.618, 0.295, 0.257, 0.646, 0.719)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.279, 0.037, 0.342, -0.489, 0.777, -0.395, -0.757, -0.604, -0.25, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.387, 0.51, -0.139, -0.754, 0.36, -0.549, -0.633, -0.621, 0.463, -0.174, 0.696, 0.696)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.206, -0.028, 0.368, -0.497, -0.822, 0.278, 0.791, -0.56, -0.245, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
	[0.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.504, -1.7, 1, -0, 0, 0, -0.646, -0.764, -0, 0.764, -0.646)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.456, 0.631, -0.341, -0.69, -0.423, 0.588, 0.688, -0.636, 0.349, 0.226, 0.645, 0.73)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.267, -0.029, 0.342, -0.489, 0.777, -0.395, -0.757, -0.604, -0.25, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.467, 0.564, -0.139, -0.802, 0.335, -0.496, -0.58, -0.636, 0.509, -0.145, 0.696, 0.703)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.194, -0.094, 0.368, -0.497, -0.822, 0.278, 0.791, -0.56, -0.245, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.038, -0.029, 1, 0, 0, 0, 0.997, -0.083, 0, 0.083, 0.997)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, -0.038, -0.029, 1, 0, 0, 0, 0.997, -0.083, 0, 0.083, 0.997)},
	},
	[0.117] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.465, -1.7, 1, -0, 0, 0, -0.618, -0.787, -0, 0.787, -0.618)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.493, 0.654, -0.341, -0.713, -0.411, 0.568, 0.668, -0.644, 0.373, 0.213, 0.645, 0.734)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.261, -0.054, 0.342, -0.486, 0.78, -0.394, -0.759, -0.6, -0.252, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.504, 0.587, -0.139, -0.821, 0.323, -0.471, -0.556, -0.641, 0.529, -0.131, 0.696, 0.706)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.188, -0.119, 0.368, -0.493, -0.825, 0.277, 0.793, -0.557, -0.246, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.056, -0.043, 1, 0, 0, 0, 0.993, -0.121, 0, 0.121, 0.993)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, -0.056, -0.043, 1, 0, 0, 0, 0.993, -0.121, 0, 0.121, 0.993)},
	},
	[0.167] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.479, -1.7, 1, -0, 0, 0, -0.618, -0.786, -0, 0.786, -0.618)},
		["Head"] = {["CFrame"] = CFrame.new(-0.064, 0.409, 0.009, 0.746, -0.666, 0.017, -0.129, -0.118, 0.985, -0.654, -0.736, -0.174)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.505, 0.654, -0.341, -0.715, -0.411, 0.565, 0.667, -0.644, 0.375, 0.21, 0.645, 0.735)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.258, -0.034, 0.342, -0.47, 0.792, -0.389, -0.769, -0.584, -0.26, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.515, 0.586, -0.139, -0.823, 0.323, -0.468, -0.554, -0.641, 0.531, -0.128, 0.696, 0.707)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.185, -0.098, 0.368, -0.476, -0.836, 0.271, 0.804, -0.539, -0.252, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.066, -0.049, 1, 0, 0, 0, 0.992, -0.127, 0, 0.127, 0.992)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, -0.066, -0.049, 1, 0, 0, 0, 0.992, -0.127, 0, 0.127, 0.992)},
	},
	[0.183] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.506, -1.7, 1, -0, 0, 0, -0.629, -0.777, -0, 0.777, -0.629)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.501, 0.644, -0.341, -0.708, -0.416, 0.57, 0.673, -0.641, 0.369, 0.212, 0.645, 0.734)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.257, -0.006, 0.342, -0.457, 0.802, -0.384, -0.777, -0.57, -0.267, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.512, 0.576, -0.139, -0.817, 0.328, -0.474, -0.561, -0.639, 0.526, -0.131, 0.696, 0.706)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.184, -0.071, 0.368, -0.462, -0.845, 0.267, 0.812, -0.525, -0.256, 0.357, 0.098, 0.929)},
	},
	[0.2] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.062, -0.043, 1, 0, 0, 0, 0.996, -0.085, 0, 0.085, 0.996)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, -0.062, -0.043, 1, 0, 0, 0, 0.996, -0.085, 0, 0.085, 0.996)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.629, -1.7, 1, -0, 0, 0, -0.687, -0.726, -0, 0.726, -0.687)},
		["Head"] = {["CFrame"] = CFrame.new(-0.064, 0.409, 0.009, 0.746, -0.666, 0.017, -0.17, -0.165, 0.972, -0.644, -0.727, -0.236)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.459, 0.593, -0.341, -0.666, -0.44, 0.603, 0.709, -0.625, 0.327, 0.233, 0.645, 0.728)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.255, 0.109, 0.342, -0.413, 0.833, -0.369, -0.801, -0.525, -0.288, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.469, 0.525, -0.139, -0.781, 0.351, -0.516, -0.606, -0.626, 0.49, -0.151, 0.696, 0.702)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.182, 0.044, 0.368, -0.417, -0.873, 0.252, 0.836, -0.477, -0.271, 0.357, 0.098, 0.929)},
	},
	[0.25] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.722, -1.7, 1, -0, 0, 0, -0.73, -0.683, -0, 0.683, -0.73)},
		["Head"] = {["CFrame"] = CFrame.new(-0.064, 0.409, 0.009, 0.746, -0.666, 0.017, -0.192, -0.19, 0.963, -0.638, -0.721, -0.27)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.418, 0.552, -0.341, -0.63, -0.455, 0.629, 0.734, -0.613, 0.292, 0.252, 0.645, 0.721)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.244, 0.197, 0.34, -0.38, 0.853, -0.357, -0.817, -0.491, -0.302, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.428, 0.484, -0.139, -0.751, 0.367, -0.549, -0.639, -0.617, 0.46, -0.17, 0.696, 0.698)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.172, 0.132, 0.367, -0.383, -0.892, 0.241, 0.852, -0.442, -0.281, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.049, -0.028, 1, 0, 0, 0, 1, -0.012, 0, 0.012, 1)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, -0.049, -0.028, 1, 0, 0, 0, 1, -0.012, 0, 0.012, 1)},
	},
	[0.3] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.789, -1.7, 1, -0, 0, 0, -0.762, -0.648, -0, 0.648, -0.762)},
		["Head"] = {["CFrame"] = CFrame.new(-0.064, 0.409, 0.009, 0.746, -0.666, 0.017, -0.187, -0.184, 0.965, -0.64, -0.723, -0.261)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.377, 0.52, -0.341, -0.603, -0.463, 0.649, 0.75, -0.607, 0.264, 0.271, 0.646, 0.714)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.216, 0.268, 0.337, -0.355, 0.868, -0.348, -0.828, -0.464, -0.313, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.388, 0.452, -0.139, -0.727, 0.376, -0.575, -0.661, -0.612, 0.435, -0.188, 0.696, 0.693)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.144, 0.201, 0.365, -0.356, -0.905, 0.233, 0.864, -0.414, -0.288, 0.357, 0.098, 0.929)},
	},
	[0.333] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.823, -1.7, 1, -0, 0, 0, -0.779, -0.627, -0, 0.627, -0.779)},
		["Head"] = {["CFrame"] = CFrame.new(-0.064, 0.409, 0.009, 0.746, -0.666, 0.017, -0.163, -0.157, 0.974, -0.646, -0.729, -0.225)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.343, 0.501, -0.341, -0.588, -0.463, 0.663, 0.756, -0.607, 0.247, 0.288, 0.646, 0.707)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.177, 0.31, 0.333, -0.341, 0.876, -0.342, -0.834, -0.449, -0.319, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.353, 0.433, -0.139, -0.714, 0.375, -0.591, -0.67, -0.612, 0.42, -0.204, 0.696, 0.688)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.106, 0.243, 0.363, -0.341, -0.912, 0.228, 0.87, -0.398, -0.292, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.014, 0.012, 1, 0, 0, 0, 0.984, 0.176, 0, -0.176, 0.984)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, -0.014, 0.012, 1, 0, 0, 0, 0.984, 0.176, 0, -0.176, 0.984)},
	},
	[0.383] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.843, -1.7, 1, -0, 0, 0, -0.791, -0.612, -0, 0.612, -0.791)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.312, 0.488, -0.341, -0.578, -0.461, 0.673, 0.758, -0.608, 0.234, 0.301, 0.646, 0.701)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.137, 0.341, 0.329, -0.331, 0.881, -0.338, -0.838, -0.439, -0.323, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.323, 0.42, -0.139, -0.704, 0.373, -0.604, -0.676, -0.613, 0.409, -0.217, 0.696, 0.684)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.067, 0.273, 0.361, -0.331, -0.916, 0.224, 0.873, -0.388, -0.294, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0.027, 1, 0, 0, 0, 0.969, 0.247, 0, -0.247, 0.969)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0.027, 1, 0, 0, 0, 0.969, 0.247, 0, -0.247, 0.969)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.848, -1.7, 1, -0, 0, 0, -0.797, -0.604, -0, 0.604, -0.797)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.293, 0.485, -0.341, -0.573, -0.461, 0.678, 0.76, -0.609, 0.229, 0.307, 0.646, 0.699)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.108, 0.353, 0.328, -0.329, 0.882, -0.338, -0.839, -0.437, -0.324, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.303, 0.417, -0.139, -0.7, 0.373, -0.609, -0.678, -0.613, 0.405, -0.223, 0.696, 0.682)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.038, 0.284, 0.36, -0.329, -0.917, 0.223, 0.874, -0.385, -0.295, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0.01, 0.036, 1, 0, 0, 0, 0.959, 0.283, 0, -0.283, 0.959)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0.01, 0.036, 1, 0, 0, 0, 0.959, 0.283, 0, -0.283, 0.959)},
	},
	[0.467] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.827, -1.7, 1, -0, 0, 0, -0.795, -0.607, -0, 0.607, -0.795)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.29, 0.497, -0.341, -0.578, -0.461, 0.673, 0.758, -0.608, 0.234, 0.302, 0.646, 0.701)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.095, 0.337, 0.329, -0.338, 0.877, -0.341, -0.836, -0.446, -0.32, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.301, 0.429, -0.139, -0.704, 0.373, -0.604, -0.676, -0.613, 0.409, -0.218, 0.696, 0.684)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.025, 0.269, 0.361, -0.338, -0.913, 0.227, 0.871, -0.395, -0.293, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0.013, 0.036, 1, 0, 0, 0, 0.963, 0.269, 0, -0.269, 0.963)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0.013, 0.036, 1, 0, 0, 0, 0.963, 0.269, 0, -0.269, 0.963)},
	},
	[0.5] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.79, -1.7, 1, -0, 0, 0, -0.787, -0.617, -0, 0.617, -0.787)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.299, 0.52, -0.341, -0.588, -0.463, 0.663, 0.755, -0.607, 0.246, 0.289, 0.646, 0.707)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.093, 0.302, 0.333, -0.354, 0.868, -0.347, -0.829, -0.463, -0.314, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.31, 0.452, -0.139, -0.713, 0.375, -0.592, -0.67, -0.612, 0.42, -0.205, 0.696, 0.688)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.022, 0.235, 0.363, -0.355, -0.905, 0.232, 0.864, -0.413, -0.288, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0.011, 0.03, 1, 0, 0, 0, 0.975, 0.221, 0, -0.221, 0.975)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0.011, 0.03, 1, 0, 0, 0, 0.975, 0.221, 0, -0.221, 0.975)},
	},
	[0.517] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.783, -1.7, 1, -0, 0, 0, -0.785, -0.619, -0, 0.619, -0.785)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.301, 0.524, -0.341, -0.59, -0.463, 0.661, 0.755, -0.607, 0.249, 0.286, 0.646, 0.708)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.093, 0.296, 0.334, -0.357, 0.867, -0.348, -0.828, -0.466, -0.312, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.311, 0.456, -0.139, -0.715, 0.375, -0.59, -0.669, -0.612, 0.422, -0.203, 0.696, 0.688)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.022, 0.228, 0.363, -0.358, -0.904, 0.233, 0.863, -0.416, -0.287, 0.357, 0.098, 0.929)},
	},
	[0.55] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.74, -1.7, 1, -0, 0, 0, -0.774, -0.633, -0, 0.633, -0.774)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.314, 0.548, -0.341, -0.602, -0.464, 0.65, 0.751, -0.606, 0.262, 0.272, 0.646, 0.713)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.101, 0.252, 0.338, -0.378, 0.855, -0.356, -0.818, -0.488, -0.303, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.324, 0.48, -0.139, -0.725, 0.376, -0.577, -0.662, -0.611, 0.434, -0.189, 0.696, 0.692)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.028, 0.185, 0.365, -0.38, -0.893, 0.24, 0.854, -0.439, -0.281, 0.357, 0.098, 0.929)},
	},
	[0.6] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.693, -1.7, 1, -0, 0, 0, -0.757, -0.653, -0, 0.653, -0.757)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.331, 0.566, -0.341, -0.614, -0.462, 0.64, 0.745, -0.608, 0.275, 0.262, 0.646, 0.717)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.136, 0.191, 0.34, -0.408, 0.836, -0.367, -0.803, -0.52, -0.29, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.342, 0.498, -0.139, -0.736, 0.374, -0.564, -0.653, -0.613, 0.445, -0.179, 0.696, 0.695)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.063, 0.125, 0.367, -0.412, -0.876, 0.251, 0.838, -0.472, -0.272, 0.357, 0.098, 0.929)},
	},
	[0.633] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.639, -1.7, 1, -0, 0, 0, -0.73, -0.684, -0, 0.684, -0.73)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.357, 0.575, -0.341, -0.626, -0.455, 0.633, 0.736, -0.613, 0.287, 0.257, 0.646, 0.719)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.212, 0.105, 0.342, -0.454, 0.804, -0.383, -0.779, -0.567, -0.268, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.367, 0.507, -0.139, -0.747, 0.367, -0.554, -0.642, -0.617, 0.456, -0.175, 0.696, 0.696)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.139, 0.04, 0.368, -0.46, -0.847, 0.266, 0.813, -0.522, -0.257, 0.357, 0.098, 0.929)},
	},
	[0.667] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, -1.6, -1.7, 1, -0, 0, 0, -0.707, -0.707, -0, 0.707, -0.707)},
		["Head"] = {["CFrame"] = CFrame.new(-0.064, 0.409, 0.009, 0.746, -0.666, 0.017, 0.067, 0.101, 0.993, -0.663, -0.739, 0.12)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.377, 0.578, -0.341, -0.635, -0.448, 0.629, 0.729, -0.618, 0.295, 0.257, 0.646, 0.719)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.279, 0.037, 0.342, -0.489, 0.777, -0.395, -0.757, -0.604, -0.25, -0.433, 0.177, 0.884)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.387, 0.51, -0.139, -0.754, 0.36, -0.549, -0.633, -0.621, 0.463, -0.174, 0.696, 0.696)},
		["Right Leg"] = {["CFrame"] = CFrame.new(0.206, -0.028, 0.368, -0.497, -0.822, 0.278, 0.791, -0.56, -0.245, 0.357, 0.098, 0.929)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	},
}

PlayAnimation("Sex60", Sex60)
