loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Other/sendNotification.lua", true))()
loadstring(game:HttpGet("https://github.com/sharkywhiskersmeow/Moon-Convert/raw/main/Scripts/Other/AlignCharacter.lua", true))()

local sounds = {
	["Impacts"] = {8142423452},
	["Exhales"] = {4792915329},
	["Nuts"] = {9114687069}
}

local Converted = {
	["_Cumscene"] = Instance.new("ScreenGui");
	["_CumFrame"] = Instance.new("ImageLabel");
	["_Cum"] = Instance.new("TextButton");
	["_UICorner"] = Instance.new("UICorner");
}



Converted["_Cumscene"].IgnoreGuiInset = true
Converted["_Cumscene"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Converted["_Cumscene"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_Cumscene"].Name = "Cumscene"
Converted["_Cumscene"].Parent = game.Players.LocalPlayer.PlayerGui

Converted["_CumFrame"].Image = "rbxassetid://12293645094"
Converted["_CumFrame"].ImageTransparency = 1
Converted["_CumFrame"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_CumFrame"].BackgroundTransparency = 1
Converted["_CumFrame"].BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036)
Converted["_CumFrame"].Position = UDim2.new(-0.5, 0, -0.126505986, 0)
Converted["_CumFrame"].Size = UDim2.new(2, 0, 1.25, 0)
Converted["_CumFrame"].Name = "CumFrame"
Converted["_CumFrame"].Parent = Converted["_Cumscene"]

Converted["_Cum"].Font = Enum.Font.SourceSans
Converted["_Cum"].Text = "Cum"
Converted["_Cum"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Cum"].TextScaled = true
Converted["_Cum"].TextSize = 14
Converted["_Cum"].TextWrapped = true
Converted["_Cum"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Cum"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Cum"].BorderSizePixel = 0
Converted["_Cum"].Position = UDim2.new(0.812599659, 0, 0.469287455, 0)
Converted["_Cum"].Size = UDim2.new(0, 200, 0, 50)
Converted["_Cum"].Name = "Cum"
Converted["_Cum"].Parent = Converted["_Cumscene"]

Converted["_UICorner"].Parent = Converted["_Cum"]

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

local Sex21 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.553, 1, 0, -0, 0, 0.096, 0.995, -0, -0.995, 0.096)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, 0, -0, 0, 0.856, -0.516, -0, 0.516, 0.856)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.11, 0.077, -0.135, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.132, 0, -0.132, 0.991, 0, 0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.127, -0.045, 0.135, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.132, 0, 0.132, 0.991, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.95, -0.311, 0.013, 0.139, 0.462, 0.876, -0.278, -0.831, 0.482)},
	},
	[0.017] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.553, 1, 0, 0, -0, 0.096, 0.995, -0, -0.995, 0.096)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.856, -0.516, 0, 0.516, 0.856)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.11, 0.077, -0.135, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.133, 0, -0.133, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.127, -0.045, 0.135, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.133, 0, 0.133, 0.991, 0, -0, -0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.95, -0.311, 0.013, 0.139, 0.462, 0.876, -0.278, -0.831, 0.482)},
	},
	[0.033] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.553, 1, 0, 0, -0, 0.097, 0.995, -0, -0.995, 0.097)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.856, -0.517, 0, 0.517, 0.856)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.111, 0.077, -0.135, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.134, 0, -0.134, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.127, -0.045, 0.135, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.134, 0, 0.134, 0.991, 0, -0, -0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.95, -0.311, 0.012, 0.139, 0.461, 0.876, -0.278, -0.831, 0.482)},
	},
	[0.05] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.552, 1, 0, 0, -0, 0.098, 0.995, -0, -0.995, 0.098)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.856, -0.517, 0, 0.517, 0.856)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.111, 0.078, -0.136, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.135, 0, -0.135, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.128, -0.045, 0.136, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.135, 0, 0.135, 0.991, 0, -0, -0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.95, -0.311, 0.011, 0.14, 0.461, 0.876, -0.277, -0.832, 0.481)},
	},
	[0.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.551, 1, 0, 0, -0, 0.099, 0.995, -0, -0.995, 0.099)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.856, -0.518, 0, 0.518, 0.856)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.013, -0, 0.991, 0.112, 0.078, -0.136, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.137, 0, -0.137, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.013, -0, 0.991, -0.129, -0.045, 0.136, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.137, 0, 0.137, 0.991, 0, -0, -0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.95, -0.311, 0.01, 0.141, 0.46, 0.877, -0.277, -0.832, 0.481)},
	},
	[0.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.55, 1, 0, 0, -0, 0.102, 0.995, -0, -0.995, 0.102)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.855, -0.519, 0, 0.519, 0.855)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.013, -0, 0.991, 0.113, 0.079, -0.137, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.99, 0.14, 0, -0.14, 0.99, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.013, -0, 0.991, -0.129, -0.046, 0.137, 0.934, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.99, -0.14, 0, 0.14, 0.99, 0, -0, -0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.951, -0.311, 0.008, 0.142, 0.458, 0.877, -0.276, -0.833, 0.48)},
	},
	[0.1] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.549, 1, 0, 0, -0, 0.104, 0.995, -0, -0.995, 0.104)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.854, -0.519, 0, 0.519, 0.854)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.013, -0, 0.99, 0.114, 0.079, -0.138, 0.831, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.99, 0.143, 0, -0.143, 0.99, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.013, -0, 0.99, -0.131, -0.046, 0.138, 0.934, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.99, -0.143, 0, 0.143, 0.99, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.951, -0.311, 0.006, 0.144, 0.457, 0.878, -0.275, -0.834, 0.479)},
	},
	[0.117] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.548, 1, 0, 0, -0, 0.107, 0.994, -0, -0.994, 0.107)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.854, -0.521, 0, 0.521, 0.854)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.014, -0, 0.99, 0.115, 0.08, -0.14, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.989, 0.147, 0, -0.147, 0.989, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.014, -0, 0.99, -0.132, -0.046, 0.14, 0.934, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.989, -0.147, 0, 0.147, 0.989, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.951, -0.311, 0.003, 0.146, 0.455, 0.879, -0.274, -0.835, 0.478)},
	},
	[0.133] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.546, 1, 0, 0, -0, 0.111, 0.994, -0, -0.994, 0.111)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.853, -0.522, 0, 0.522, 0.853)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.015, -0, 0.99, 0.116, 0.081, -0.141, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.989, 0.151, 0, -0.151, 0.989, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.015, -0, 0.99, -0.133, -0.047, 0.141, 0.934, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.989, -0.151, 0, 0.151, 0.989, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.951, -0.311, 0, 0.148, 0.453, 0.879, -0.273, -0.836, 0.476)},
	},
	[0.15] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.544, 1, 0, 0, -0, 0.115, 0.993, -0, -0.993, 0.115)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.852, -0.523, 0, 0.523, 0.852)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.016, -0, 0.99, 0.117, 0.082, -0.143, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.988, 0.156, 0, -0.156, 0.988, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.016, -0, 0.99, -0.135, -0.047, 0.143, 0.934, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.988, -0.156, 0, 0.156, 0.988, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.951, -0.311, -0.003, 0.15, 0.451, 0.88, -0.272, -0.837, 0.475)},
	},
	[0.167] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.542, 1, 0, 0, -0, 0.119, 0.993, -0, -0.993, 0.119)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.851, -0.525, 0, 0.525, 0.851)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.016, -0, 0.989, 0.119, 0.083, -0.145, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.987, 0.162, 0, -0.162, 0.987, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.016, -0, 0.989, -0.137, -0.048, 0.145, 0.933, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.987, -0.162, 0, 0.162, 0.987, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.951, -0.311, -0.006, 0.152, 0.449, 0.881, -0.271, -0.838, 0.474)},
	},
	[0.183] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.54, 1, 0, 0, -0, 0.124, 0.992, -0, -0.992, 0.124)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.85, -0.527, 0, 0.527, 0.85)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.017, -0, 0.989, 0.121, 0.084, -0.147, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.986, 0.168, 0, -0.168, 0.986, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.017, -0, 0.989, -0.139, -0.049, 0.147, 0.933, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.986, -0.168, 0, 0.168, 0.986, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.951, -0.311, -0.008, 0.153, 0.447, 0.881, -0.27, -0.839, 0.473)},
	},
	[0.2] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.538, 1, 0, 0, -0, 0.129, 0.992, -0, -0.992, 0.129)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.849, -0.529, 0, 0.529, 0.849)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.019, -0, 0.989, 0.123, 0.085, -0.15, 0.829, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.985, 0.175, 0, -0.175, 0.985, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.018, -0, 0.989, -0.141, -0.05, 0.15, 0.933, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.985, -0.175, 0, 0.175, 0.985, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.95, -0.311, -0.01, 0.155, 0.446, 0.882, -0.27, -0.84, 0.472)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.535, 1, 0, 0, -0, 0.135, 0.991, -0, -0.991, 0.135)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.847, -0.531, 0, 0.531, 0.847)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.02, -0, 0.988, 0.125, 0.087, -0.152, 0.829, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.983, 0.182, 0, -0.182, 0.983, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.02, -0, 0.988, -0.144, -0.051, 0.152, 0.932, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.983, -0.182, 0, 0.182, 0.983, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, 0, -0, 0.95, -0.311, -0.011, 0.156, 0.445, 0.882, -0.269, -0.84, 0.471)},
	},
	[0.233] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.532, 1, 0, 0, -0, 0.141, 0.99, -0, -0.99, 0.141)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.846, -0.533, 0, 0.533, 0.846)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.021, -0, 0.988, 0.127, 0.088, -0.155, 0.829, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.982, 0.189, 0, -0.189, 0.982, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.021, -0, 0.988, -0.146, -0.051, 0.155, 0.932, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.982, -0.189, 0, 0.189, 0.982, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.95, -0.311, -0.012, 0.156, 0.444, 0.882, -0.269, -0.84, 0.471)},
	},
	[0.25] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.53, 1, 0, 0, -0, 0.146, 0.989, -0, -0.989, 0.146)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.844, -0.536, 0, 0.536, 0.844)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.022, -0, 0.988, 0.129, 0.09, -0.157, 0.828, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.981, 0.196, 0, -0.196, 0.981, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.022, -0, 0.988, -0.148, -0.052, 0.157, 0.932, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.981, -0.196, 0, 0.196, 0.981, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.95, -0.311, -0.013, 0.157, 0.444, 0.882, -0.268, -0.841, 0.47)},
	},
	[0.267] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.528, 1, 0, 0, -0, 0.151, 0.989, -0, -0.989, 0.151)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.843, -0.539, 0, 0.539, 0.843)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.023, -0, 0.987, 0.131, 0.091, -0.159, 0.828, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.979, 0.202, 0, -0.202, 0.979, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.023, -0, 0.987, -0.15, -0.053, 0.159, 0.931, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.979, -0.202, 0, 0.202, 0.979, 0, -0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, -0, 0.95, -0.311, -0.013, 0.157, 0.444, 0.882, -0.268, -0.841, 0.47)},
	},
	[0.283] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.526, 1, 0, 0, -0, 0.156, 0.988, -0, -0.988, 0.156)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.841, -0.541, 0, 0.541, 0.841)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.024, -0, 0.987, 0.133, 0.092, -0.161, 0.828, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.978, 0.208, 0, -0.208, 0.978, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.024, -0, 0.987, -0.152, -0.054, 0.161, 0.931, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.978, -0.208, 0, 0.208, 0.978, 0, -0, 0, 1)},
	},
	[0.3] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.524, 1, 0, 0, -0, 0.159, 0.987, -0, -0.987, 0.159)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.839, -0.544, 0, 0.544, 0.839)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.025, -0, 0.987, 0.134, 0.093, -0.163, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.977, 0.212, 0, -0.212, 0.977, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.025, -0, 0.987, -0.154, -0.054, 0.163, 0.931, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.977, -0.212, 0, 0.212, 0.977, 0, -0, 0, 1)},
	},
	[0.317] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.522, 1, 0, 0, -0, 0.163, 0.987, -0, -0.987, 0.163)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.837, -0.548, 0, 0.548, 0.837)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.025, -0, 0.986, 0.136, 0.094, -0.165, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.976, 0.217, 0, -0.217, 0.976, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.025, -0, 0.986, -0.155, -0.055, 0.165, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.976, -0.217, 0, 0.217, 0.976, 0, -0, 0, 1)},
	},
	[0.333] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.521, 1, 0, 0, -0, 0.166, 0.986, -0, -0.986, 0.166)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.835, -0.551, 0, 0.551, 0.835)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.026, -0, 0.986, 0.137, 0.094, -0.166, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.975, 0.221, 0, -0.221, 0.975, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.026, -0, 0.986, -0.157, -0.055, 0.166, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.975, -0.221, 0, 0.221, 0.975, 0, -0, 0, 1)},
	},
	[0.35] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.52, 1, 0, 0, -0, 0.168, 0.986, -0, -0.986, 0.168)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.832, -0.554, 0, 0.554, 0.832)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.026, -0, 0.986, 0.138, 0.095, -0.167, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.975, 0.224, 0, -0.224, 0.975, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.026, -0, 0.986, -0.158, -0.055, 0.167, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.975, -0.224, 0, 0.224, 0.975, 0, -0, 0, 1)},
	},
	[0.367] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.519, 1, 0, 0, -0, 0.171, 0.985, -0, -0.985, 0.171)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.83, -0.558, 0, 0.558, 0.83)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.986, 0.138, 0.095, -0.168, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.974, 0.226, 0, -0.226, 0.974, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.986, -0.159, -0.056, 0.168, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.974, -0.226, 0, 0.226, 0.974, 0, -0, 0, 1)},
	},
	[0.383] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.437, -2.518, 1, 0, 0, -0, 0.172, 0.985, -0, -0.985, 0.172)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.828, -0.561, 0, 0.561, 0.828)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.986, 0.139, 0.096, -0.169, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.974, 0.228, 0, -0.228, 0.974, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.986, -0.159, -0.056, 0.169, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.974, -0.228, 0, 0.228, 0.974, 0, -0, 0, 1)},
	},
	[0.4] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.437, -2.517, 1, 0, 0, -0, 0.173, 0.985, -0, -0.985, 0.173)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.826, -0.564, 0, 0.564, 0.826)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.986, 0.14, 0.096, -0.169, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.973, 0.23, 0, -0.23, 0.973, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.986, -0.16, -0.056, 0.169, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, -0.23, 0, 0.23, 0.973, 0, -0, 0, 1)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.437, -2.517, 1, 0, 0, -0, 0.174, 0.985, -0, -0.985, 0.174)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.824, -0.567, 0, 0.567, 0.824)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.985, 0.14, 0.096, -0.17, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.973, 0.231, 0, -0.231, 0.973, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.985, -0.16, -0.056, 0.17, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, -0.231, 0, 0.231, 0.973, 0, -0, 0, 1)},
	},
	[0.433] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.437, -2.517, 1, 0, -0, 0, 0.174, 0.985, -0, -0.985, 0.174)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.822, -0.569, 0, 0.569, 0.822)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.028, -0, 0.985, 0.14, 0.096, -0.17, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.973, 0.231, 0, -0.231, 0.973, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.028, -0, 0.985, -0.16, -0.056, 0.17, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, -0.231, 0, 0.231, 0.973, 0, -0, 0, 1)},
	},
	[0.45] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.437, -2.517, 1, 0, 0, -0, 0.174, 0.985, -0, -0.985, 0.174)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.82, -0.572, 0, 0.572, 0.82)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.985, 0.14, 0.096, -0.17, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.973, 0.231, 0, -0.231, 0.973, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.985, -0.16, -0.056, 0.17, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, -0.231, 0, 0.231, 0.973, 0, -0, 0, 1)},
	},
	[0.467] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.437, -2.517, 1, 0, 0, -0, 0.174, 0.985, -0, -0.985, 0.174)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.819, -0.574, 0, 0.574, 0.819)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.986, 0.14, 0.096, -0.17, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.973, 0.23, 0, -0.23, 0.973, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.986, -0.16, -0.056, 0.17, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, -0.23, 0, 0.23, 0.973, 0, -0, 0, 1)},
	},
	[0.483] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.437, -2.517, 1, 0, 0, -0, 0.173, 0.985, -0, -0.985, 0.173)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.817, -0.576, 0, 0.576, 0.817)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.986, 0.14, 0.096, -0.169, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.973, 0.23, 0, -0.23, 0.973, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.986, -0.16, -0.056, 0.169, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, -0.23, 0, 0.23, 0.973, 0, -0, 0, 1)},
	},
	[0.5] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.437, -2.518, 1, 0, 0, -0, 0.173, 0.985, -0, -0.985, 0.173)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.816, -0.578, 0, 0.578, 0.816)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.986, 0.139, 0.096, -0.169, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.973, 0.229, 0, -0.229, 0.973, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.986, -0.159, -0.056, 0.169, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.973, -0.229, 0, 0.229, 0.973, 0, -0, 0, 1)},
	},
	[0.517] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.518, 1, 0, 0, -0, 0.172, 0.985, -0, -0.985, 0.172)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.815, -0.58, 0, 0.58, 0.815)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.986, 0.139, 0.096, -0.169, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.974, 0.228, 0, -0.228, 0.974, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.986, -0.159, -0.056, 0.169, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.974, -0.228, 0, 0.228, 0.974, 0, -0, 0, 1)},
	},
	[0.533] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.519, 1, 0, 0, -0, 0.171, 0.985, -0, -0.985, 0.171)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.814, -0.581, 0, 0.581, 0.814)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.027, -0, 0.986, 0.138, 0.095, -0.168, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.974, 0.226, 0, -0.226, 0.974, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.027, -0, 0.986, -0.159, -0.056, 0.168, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.974, -0.226, 0, 0.226, 0.974, 0, -0, 0, 1)},
	},
	[0.55] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.519, 1, 0, 0, -0, 0.169, 0.986, -0, -0.986, 0.169)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.813, -0.583, 0, 0.583, 0.813)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.026, -0, 0.986, 0.138, 0.095, -0.168, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.974, 0.225, 0, -0.225, 0.974, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.026, -0, 0.986, -0.158, -0.056, 0.168, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.974, -0.225, 0, 0.225, 0.974, 0, -0, 0, 1)},
	},
	[0.567] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.52, 1, 0, 0, -0, 0.168, 0.986, -0, -0.986, 0.168)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.812, -0.584, 0, 0.584, 0.812)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.026, -0, 0.986, 0.137, 0.095, -0.167, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.975, 0.223, 0, -0.223, 0.975, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.026, -0, 0.986, -0.157, -0.055, 0.167, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.975, -0.223, 0, 0.223, 0.975, 0, -0, 0, 1)},
	},
	[0.583] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.521, 1, 0, 0, -0, 0.166, 0.986, -0, -0.986, 0.166)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.811, -0.585, 0, 0.585, 0.811)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.026, -0, 0.986, 0.137, 0.094, -0.166, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.975, 0.221, 0, -0.221, 0.975, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.026, -0, 0.986, -0.157, -0.055, 0.166, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.975, -0.221, 0, 0.221, 0.975, 0, -0, 0, 1)},
	},
	[0.6] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.522, 1, 0, 0, -0, 0.164, 0.986, -0, -0.986, 0.164)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.81, -0.586, 0, 0.586, 0.81)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.12, -0.025, -0, 0.986, 0.136, 0.094, -0.165, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.976, 0.218, 0, -0.218, 0.976, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.12, -0.025, -0, 0.986, -0.156, -0.055, 0.165, 0.93, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.976, -0.218, 0, 0.218, 0.976, 0, -0, 0, 1)},
	},
	[0.617] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.523, 1, 0, 0, -0, 0.162, 0.987, -0, -0.987, 0.162)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.81, -0.587, 0, 0.587, 0.81)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.025, -0, 0.986, 0.135, 0.093, -0.164, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.977, 0.215, 0, -0.215, 0.977, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.025, -0, 0.986, -0.155, -0.054, 0.164, 0.931, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.977, -0.215, 0, 0.215, 0.977, 0, -0, 0, 1)},
	},
	[0.633] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.524, 1, 0, 0, -0, 0.159, 0.987, -0, -0.987, 0.159)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.809, -0.587, 0, 0.587, 0.809)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.025, -0, 0.987, 0.134, 0.093, -0.163, 0.827, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.977, 0.212, 0, -0.212, 0.977, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.025, -0, 0.987, -0.154, -0.054, 0.163, 0.931, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.977, -0.212, 0, 0.212, 0.977, 0, -0, 0, 1)},
	},
	[0.65] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.525, 1, 0, 0, -0, 0.157, 0.988, -0, -0.988, 0.157)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.809, -0.588, 0, 0.588, 0.809)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.024, -0, 0.987, 0.133, 0.092, -0.162, 0.828, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.978, 0.209, 0, -0.209, 0.978, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.024, -0, 0.987, -0.153, -0.054, 0.162, 0.931, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.978, -0.209, 0, 0.209, 0.978, 0, -0, 0, 1)},
	},
	[0.667] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.526, 1, 0, 0, -0, 0.154, 0.988, -0, -0.988, 0.154)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.809, -0.588, 0, 0.588, 0.809)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.023, -0, 0.987, 0.132, 0.091, -0.161, 0.828, 0.537, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.979, 0.206, 0, -0.206, 0.979, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.023, -0, 0.987, -0.152, -0.053, 0.161, 0.931, 0.327, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.979, -0.206, 0, 0.206, 0.979, 0, -0, 0, 1)},
	},
	[0.683] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.528, 1, 0, 0, -0, 0.151, 0.989, -0, -0.989, 0.151)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, 0, -0, 0, 0.809, -0.588, -0, 0.588, 0.809)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.023, -0, 0.987, 0.131, 0.091, -0.159, 0.828, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.979, 0.202, 0, -0.202, 0.979, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.023, -0, 0.987, -0.15, -0.053, 0.159, 0.931, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.979, -0.202, 0, 0.202, 0.979, 0, -0, 0, 1)},
	},
	[0.7] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.529, 1, 0, 0, -0, 0.148, 0.989, -0, -0.989, 0.148)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.809, -0.588, 0, 0.588, 0.809)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.022, -0, 0.987, 0.13, 0.09, -0.158, 0.828, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.98, 0.198, 0, -0.198, 0.98, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.022, -0, 0.987, -0.149, -0.052, 0.158, 0.932, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.98, -0.198, 0, 0.198, 0.98, 0, -0, 0, 1)},
	},
	[0.717] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.438, -2.531, 1, 0, 0, -0, 0.144, 0.99, -0, -0.99, 0.144)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.809, -0.587, 0, 0.587, 0.809)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.022, -0, 0.988, 0.129, 0.089, -0.156, 0.828, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.981, 0.194, 0, -0.194, 0.981, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.022, -0, 0.988, -0.148, -0.052, 0.156, 0.932, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.981, -0.194, 0, 0.194, 0.981, 0, -0, 0, 1)},
	},
	[0.733] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.532, 1, 0, 0, -0, 0.141, 0.99, -0, -0.99, 0.141)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.81, -0.586, 0, 0.586, 0.81)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.021, -0, 0.988, 0.127, 0.088, -0.155, 0.829, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.982, 0.189, 0, -0.189, 0.982, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.021, -0, 0.988, -0.146, -0.051, 0.155, 0.932, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.982, -0.189, 0, 0.189, 0.982, 0, -0, 0, 1)},
	},
	[0.75] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.534, 1, 0, 0, -0, 0.137, 0.991, -0, -0.991, 0.137)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.812, -0.584, 0, 0.584, 0.812)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.121, -0.02, -0, 0.988, 0.126, 0.087, -0.153, 0.829, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.983, 0.184, 0, -0.184, 0.983, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.121, -0.02, -0, 0.988, -0.144, -0.051, 0.153, 0.932, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.983, -0.184, 0, 0.184, 0.983, 0, -0, 0, 1)},
	},
	[0.767] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.536, 1, 0, 0, -0, 0.133, 0.991, -0, -0.991, 0.133)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.813, -0.582, 0, 0.582, 0.813)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.019, -0, 0.988, 0.124, 0.086, -0.151, 0.829, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.984, 0.179, 0, -0.179, 0.984, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.019, -0, 0.988, -0.143, -0.05, 0.151, 0.932, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.984, -0.179, 0, 0.179, 0.984, 0, -0, 0, 1)},
	},
	[0.783] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.538, 1, 0, 0, -0, 0.129, 0.992, -0, -0.992, 0.129)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.815, -0.579, 0, 0.579, 0.815)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.019, -0, 0.989, 0.123, 0.085, -0.15, 0.829, 0.538, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.985, 0.175, 0, -0.175, 0.985, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.018, -0, 0.989, -0.141, -0.05, 0.15, 0.933, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.985, -0.175, 0, 0.175, 0.985, 0, -0, 0, 1)},
	},
	[0.8] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.539, 1, 0, 0, -0, 0.126, 0.992, -0, -0.992, 0.126)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.817, -0.576, 0, 0.576, 0.817)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.018, -0, 0.989, 0.122, 0.085, -0.148, 0.829, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.985, 0.17, 0, -0.17, 0.985, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.018, -0, 0.989, -0.14, -0.049, 0.148, 0.933, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.985, -0.17, 0, 0.17, 0.985, 0, -0, 0, 1)},
	},
	[0.817] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.541, 1, 0, 0, -0, 0.122, 0.993, -0, -0.993, 0.122)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.82, -0.573, 0, 0.573, 0.82)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.017, -0, 0.989, 0.12, 0.084, -0.147, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.986, 0.166, 0, -0.166, 0.986, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.017, -0, 0.989, -0.138, -0.049, 0.147, 0.933, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.986, -0.166, 0, 0.166, 0.986, 0, -0, 0, 1)},
	},
	[0.833] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.542, 1, 0, 0, -0, 0.119, 0.993, -0, -0.993, 0.119)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.823, -0.568, 0, 0.568, 0.823)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.016, -0, 0.989, 0.119, 0.083, -0.145, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.987, 0.162, 0, -0.162, 0.987, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.016, -0, 0.989, -0.137, -0.048, 0.145, 0.933, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.987, -0.162, 0, 0.162, 0.987, 0, -0, 0, 1)},
	},
	[0.85] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.544, 1, 0, 0, -0, 0.116, 0.993, -0, -0.993, 0.116)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.826, -0.564, 0, 0.564, 0.826)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.016, -0, 0.99, 0.118, 0.082, -0.144, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.987, 0.158, 0, -0.158, 0.987, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.016, -0, 0.99, -0.136, -0.048, 0.144, 0.934, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.987, -0.158, 0, 0.158, 0.987, 0, -0, 0, 1)},
	},
	[0.867] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.545, 1, 0, 0, -0, 0.113, 0.994, -0, -0.994, 0.113)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.83, -0.558, 0, 0.558, 0.83)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.015, -0, 0.99, 0.117, 0.081, -0.142, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.988, 0.154, 0, -0.154, 0.988, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.015, -0, 0.99, -0.134, -0.047, 0.142, 0.934, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.988, -0.154, 0, 0.154, 0.988, 0, -0, 0, 1)},
	},
	[0.883] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.439, -2.546, 1, 0, 0, -0, 0.111, 0.994, -0, -0.994, 0.111)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.833, -0.553, 0, 0.553, 0.833)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.015, -0, 0.99, 0.116, 0.081, -0.141, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.989, 0.151, 0, -0.151, 0.989, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.015, -0, 0.99, -0.133, -0.047, 0.141, 0.934, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.989, -0.151, 0, 0.151, 0.989, 0, -0, 0, 1)},
	},
	[0.9] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.547, 1, 0, 0, -0, 0.108, 0.994, -0, -0.994, 0.108)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.837, -0.547, 0, 0.547, 0.837)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.122, -0.014, -0, 0.99, 0.115, 0.08, -0.14, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.989, 0.148, 0, -0.148, 0.989, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.122, -0.014, -0, 0.99, -0.132, -0.047, 0.14, 0.934, 0.328, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.989, -0.148, 0, 0.148, 0.989, 0, -0, 0, 1)},
	},
	[0.917] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.548, 1, 0, 0, -0, 0.106, 0.994, -0, -0.994, 0.106)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.841, -0.542, 0, 0.542, 0.841)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.014, -0, 0.99, 0.114, 0.08, -0.139, 0.83, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.989, 0.145, 0, -0.145, 0.989, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.014, -0, 0.99, -0.131, -0.046, 0.139, 0.934, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.989, -0.145, 0, 0.145, 0.989, 0, -0, 0, 1)},
	},
	[0.933] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.549, 1, 0, 0, -0, 0.104, 0.995, -0, -0.995, 0.104)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.844, -0.537, 0, 0.537, 0.844)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.013, -0, 0.99, 0.114, 0.079, -0.138, 0.831, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.99, 0.143, 0, -0.143, 0.99, -0, -0, -0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.013, -0, 0.99, -0.131, -0.046, 0.138, 0.934, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.99, -0.143, 0, 0.143, 0.99, 0, -0, 0, 1)},
	},
	[0.95] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.55, 1, 0, 0, -0, 0.102, 0.995, -0, -0.995, 0.102)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.846, -0.533, 0, 0.533, 0.846)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.013, -0, 0.99, 0.113, 0.079, -0.138, 0.831, 0.539, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.99, 0.141, 0, -0.141, 0.99, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.013, -0, 0.99, -0.13, -0.046, 0.138, 0.934, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.99, -0.141, 0, 0.141, 0.99, 0, -0, -0, 1)},
	},
	[0.967] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.551, 1, 0, 0, -0, 0.101, 0.995, -0, -0.995, 0.101)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.849, -0.529, 0, 0.529, 0.849)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.013, -0, 0.991, 0.112, 0.078, -0.137, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.99, 0.139, 0, -0.139, 0.99, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.013, -0, 0.991, -0.129, -0.045, 0.137, 0.934, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.99, -0.139, 0, 0.139, 0.99, 0, -0, -0, 1)},
	},
	[0.983] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.551, 1, 0, 0, -0, 0.099, 0.995, -0, -0.995, 0.099)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.851, -0.526, 0, 0.526, 0.851)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.013, -0, 0.991, 0.112, 0.078, -0.136, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.137, 0, -0.137, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.013, -0, 0.991, -0.129, -0.045, 0.136, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.137, 0, 0.137, 0.991, 0, -0, -0, 1)},
	},
	[1] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.552, 1, 0, 0, -0, 0.098, 0.995, -0, -0.995, 0.098)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.853, -0.523, 0, 0.523, 0.853)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.111, 0.078, -0.136, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.136, 0, -0.136, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.128, -0.045, 0.136, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.136, 0, 0.136, 0.991, 0, -0, -0, 1)},
	},
	[1.017] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.552, 1, 0, 0, -0, 0.097, 0.995, -0, -0.995, 0.097)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.854, -0.52, 0, 0.52, 0.854)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.111, 0.078, -0.135, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.134, 0, -0.134, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.128, -0.045, 0.135, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.134, 0, 0.134, 0.991, 0, -0, -0, 1)},
	},
	[1.033] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.553, 1, 0, 0, -0, 0.097, 0.995, -0, -0.995, 0.097)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.855, -0.519, 0, 0.519, 0.855)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.111, 0.077, -0.135, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.134, 0, -0.134, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.127, -0.045, 0.135, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.134, 0, 0.134, 0.991, 0, -0, -0, 1)},
	},
	[1.05] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.553, 1, 0, 0, -0, 0.096, 0.995, -0, -0.995, 0.096)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.856, -0.517, 0, 0.517, 0.856)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.111, 0.077, -0.135, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.133, 0, -0.133, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.127, -0.045, 0.135, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.133, 0, 0.133, 0.991, 0, -0, -0, 1)},
	},
	[1.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.553, 1, 0, 0, -0, 0.096, 0.995, -0, -0.995, 0.096)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, -0, -0, 0, 0.856, -0.517, 0, 0.517, 0.856)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.11, 0.077, -0.135, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.133, 0, -0.133, 0.991, -0, -0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.127, -0.045, 0.135, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.133, 0, 0.133, 0.991, 0, -0, -0, 1)},
	},
	[1.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(0, 1.44, -2.553, 1, 0, -0, 0, 0.096, 0.995, -0, -0.995, 0.096)},
		["Head"] = {["CFrame"] = CFrame.new(-0, 0.014, 0.15, 1, 0, -0, 0, 0.856, -0.516, -0, 0.516, 0.856)},
		["Left Arm"] = {["CFrame"] = CFrame.new(0.123, -0.012, -0, 0.991, 0.11, 0.077, -0.135, 0.831, 0.54, -0.005, -0.545, 0.838)},
		["Left Leg"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.991, 0.132, 0, -0.132, 0.991, 0, 0, 0, 1)},
		["Right Arm"] = {["CFrame"] = CFrame.new(-0.123, -0.012, -0, 0.991, -0.127, -0.045, 0.135, 0.935, 0.329, 0, -0.332, 0.943)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0, 0, 0, 0.991, -0.132, 0, 0.132, 0.991, 0, 0, 0, 1)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, -0, 0.95, -0.311, 0.013, 0.139, 0.462, 0.876, -0.278, -0.831, 0.482)},
	},
}

PlayAnimation("Sex21", Sex21)

-- // female

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = riggy
local Humanoid = Character:WaitForChild("Humanoid")

local RunService = game:GetService("RunService")

local CurrentAnimation = nil
local Running = false

if game.Players.LocalPlayer.Character:FindFirstChild("LavanderHair") and game.Players.LocalPlayer.Character:FindFirstChild("Kate Hair") and game.Players.LocalPlayer.Character:FindFirstChild("Pal Hair") and game.Players.LocalPlayer.Character:FindFirstChild("Hat1") and game.Players.LocalPlayer.Character:FindFirstChild("Pink Hair") and game.Players.LocalPlayer:FindFirstChild("Robloxclassicred") then
game.Players.LocalPlayer.Character.MyWorldDetection.LavanderHair.Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.MyWorldDetection["Kate Hair"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.MyWorldDetection["Pal Hair"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.MyWorldDetection.Hat1.Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.MyWorldDetection["Pink Hair"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.MyWorldDetection["Robloxclassicred"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character.LavanderHair.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character["Kate Hair"].Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character["Pal Hair"].Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character.Hat1.Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character["Pink Hair"].Handle.AccessoryWeld:Destroy()
game.Players.LocalPlayer.Character["Robloxclassicred"].Handle.AccessoryWeld:Destroy()
AlignCharacter(game.Players.LocalPlayer.Character.LavanderHair.Handle, riggy["Right Arm"], Vector3.new(0, 0, 0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character["Kate Hair"].Handle, riggy["Left Arm"], Vector3.new(0, 0, 0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character["Pal Hair"].Handle, riggy["Right Leg"], Vector3.new(0, 0, 0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character.Hat1.Handle, riggy["Left Leg"], Vector3.new(0, 0, 0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character["Pink Hair"].Handle, riggy.Torso, Vector3.new(0.5, 0, 0), Vector3.new(90, 0, 0))
AlignCharacter(game.Players.LocalPlayer.Character["Robloxclassicred"].Handle, riggy.Torso, Vector3.new(-0.5, 0, 0), Vector3.new(90, 0, 0))
for index, asset in pairs(riggy:GetChildren()) do
		if asset:IsA("BasePart") then
			asset.Transparency = 1
		end
	end
    else
    sendNotification("Moon Convert", "It is recommended to wear the hats used for this script... You can get the hats by using \"get hats;doll\"", 7)
end
coroutine.resume(coroutine.create(function()
	while true do
		local sfx = Instance.new("Sound")
		sfx.Parent = riggy.Torso
		sfx.Volume = 1
		sfx.SoundId = "rbxassetid://" .. sounds.Impacts[math.random(1, #sounds.Impacts)]
		sfx:Play()
		if math.random() <= 0.4 then
					local sfx = Instance.new("Sound")
					sfx.Parent = riggy.Torso
					sfx.Volume = 1
					sfx.SoundId = "rbxassetid://" .. sounds.Exhales[math.random(1, #sounds.Exhales)]
					sfx:Play()
		end
		sfx.Ended:Wait()
	end
end))
local debounce = false
Converted["_Cum"].MouseButton1Click:Connect(function()
	if debounce == false then
			debounce = true
			Converted["_Cum"].TextColor3 = Color3.fromRGB(104, 104, 104)
			game:GetService("TweenService"):Create(game.Workspace.CurrentCamera, TweenInfo.new(1), { FieldOfView = 50 }):Play()
			game:GetService("TweenService"):Create(Converted["_CumFrame"], TweenInfo.new(1), { ImageTransparency = 0 }):Play()
			local sfx = Instance.new("Sound")
			sfx.Parent = riggy.Torso
			sfx.Volume = 1
			sfx.SoundId = "rbxassetid://" .. sounds.Nuts[math.random(1, #sounds.Nuts)]
			sfx:Play()
			task.wait(4)
			game:GetService("TweenService"):Create(game.Workspace.CurrentCamera, TweenInfo.new(1), { FieldOfView = 70 }):Play()
			game:GetService("TweenService"):Create(Converted["_CumFrame"], TweenInfo.new(1), { ImageTransparency = 1 }):Play()
			Converted["_Cum"].TextColor3 = Color3.fromRGB(255,255,255)
			debounce = false
	end
end)

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

local Sex21 = {
	[0] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.112, -1.541, -1.284, 0.951, 0.309, -0.006, -0.179, 0.536, -0.825, -0.251, 0.785, 0.566)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.017, 0.338, 0.924, -0.179, -0.758, 0.38, 0.53, 0.558, -0.043, 0.829)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.34, -0.302, -0.247, 0.308, 0.919, 0.244, -0.949, 0.316, 0.007, -0.071, -0.234, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.304, -0.007, 0.488, 0.868, -0.493, -0.055, 0.489, 0.869, -0.073, 0.084, 0.037, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.955, -0.255, -0.536, 0.634, -0.772, -0.035, 0.605, 0.524, -0.6, 0.482, 0.359, 0.799)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.142, 0.385, 0.217, 0.915, -0.403, -0.002, 0.403, 0.915, 0.006, -0, -0.006, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.995, 0.095, -0.018, -0.04, 0.574, 0.818, 0.089, -0.814, 0.575)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.995, 0.095, -0.018, -0.04, 0.574, 0.818, 0.089, -0.814, 0.575)},
		["M6DRod"] = {["CFrame"] = CFrame.new(-0, -0, 0, 0.997, 0.012, 0.076, 0.017, 0.93, -0.367, -0.075, 0.367, 0.927)},
	},
	[0.017] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.112, -1.539, -1.285, 0.951, 0.309, -0.006, -0.179, 0.536, -0.825, -0.251, 0.786, 0.565)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.017, 0.338, 0.924, -0.179, -0.758, 0.38, 0.53, 0.558, -0.043, 0.829)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.34, -0.302, -0.247, 0.307, 0.92, 0.244, -0.949, 0.315, 0.007, -0.071, -0.234, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.304, -0.006, 0.488, 0.868, -0.493, -0.055, 0.489, 0.869, -0.074, 0.084, 0.037, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.955, -0.254, -0.535, 0.634, -0.773, -0.035, 0.605, 0.523, -0.6, 0.482, 0.36, 0.799)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.142, 0.387, 0.217, 0.915, -0.404, -0.002, 0.404, 0.915, 0.006, -0, -0.007, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.995, 0.096, -0.018, -0.04, 0.574, 0.818, 0.089, -0.813, 0.575)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0, -0, -0, 0.995, 0.095, -0.018, -0.04, 0.574, 0.818, 0.088, -0.813, 0.575)},
	},
	[0.033] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.112, -1.535, -1.288, 0.951, 0.309, -0.007, -0.18, 0.536, -0.825, -0.251, 0.786, 0.565)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.016, 0.338, 0.924, -0.179, -0.758, 0.38, 0.531, 0.558, -0.043, 0.828)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.339, -0.3, -0.248, 0.305, 0.92, 0.245, -0.95, 0.313, 0.007, -0.07, -0.234, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.305, -0.001, 0.488, 0.868, -0.493, -0.054, 0.489, 0.869, -0.074, 0.083, 0.038, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.953, -0.249, -0.534, 0.633, -0.773, -0.033, 0.606, 0.522, -0.601, 0.482, 0.36, 0.799)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.142, 0.392, 0.217, 0.914, -0.405, -0.003, 0.405, 0.914, 0.007, -0, -0.007, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.001, 0, 0.995, 0.097, -0.019, -0.041, 0.575, 0.817, 0.09, -0.812, 0.577)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0, -0.001, -0, 0.995, 0.094, -0.019, -0.039, 0.575, 0.817, 0.088, -0.812, 0.576)},
	},
	[0.05] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.111, -1.528, -1.293, 0.951, 0.309, -0.008, -0.18, 0.535, -0.825, -0.25, 0.786, 0.565)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.016, 0.337, 0.924, -0.179, -0.757, 0.38, 0.532, 0.559, -0.044, 0.828)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.338, -0.297, -0.249, 0.301, 0.922, 0.245, -0.951, 0.309, 0.007, -0.069, -0.235, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.305, 0.005, 0.489, 0.869, -0.493, -0.053, 0.489, 0.869, -0.075, 0.083, 0.039, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.951, -0.241, -0.532, 0.631, -0.775, -0.032, 0.607, 0.519, -0.602, 0.483, 0.361, 0.798)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.143, 0.4, 0.218, 0.914, -0.406, -0.003, 0.406, 0.914, 0.008, -0, -0.008, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.002, 0.001, 0.995, 0.098, -0.019, -0.041, 0.578, 0.815, 0.091, -0.81, 0.579)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0, -0.003, -0, 0.996, 0.092, -0.02, -0.037, 0.578, 0.816, 0.087, -0.811, 0.578)},
	},
	[0.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.11, -1.518, -1.3, 0.951, 0.308, -0.009, -0.181, 0.534, -0.826, -0.25, 0.787, 0.564)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.016, 0.337, 0.924, -0.18, -0.756, 0.38, 0.533, 0.561, -0.044, 0.827)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.336, -0.293, -0.251, 0.296, 0.923, 0.245, -0.953, 0.304, 0.008, -0.068, -0.236, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.306, 0.015, 0.489, 0.869, -0.493, -0.051, 0.488, 0.869, -0.076, 0.081, 0.041, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.947, -0.23, -0.529, 0.629, -0.777, -0.029, 0.609, 0.516, -0.603, 0.483, 0.361, 0.797)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.145, 0.411, 0.218, 0.913, -0.409, -0.004, 0.409, 0.913, 0.009, -0, -0.01, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.003, 0.001, 0.995, 0.1, -0.02, -0.043, 0.581, 0.813, 0.093, -0.808, 0.582)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0, -0.005, -0.001, 0.996, 0.089, -0.022, -0.034, 0.581, 0.813, 0.085, -0.809, 0.581)},
	},
	[0.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.109, -1.505, -1.309, 0.951, 0.308, -0.011, -0.182, 0.533, -0.826, -0.249, 0.788, 0.564)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.337, 0.924, -0.181, -0.755, 0.38, 0.535, 0.563, -0.044, 0.825)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.334, -0.289, -0.253, 0.289, 0.925, 0.246, -0.955, 0.297, 0.008, -0.066, -0.237, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.306, 0.027, 0.49, 0.869, -0.492, -0.048, 0.488, 0.869, -0.077, 0.08, 0.044, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.943, -0.216, -0.526, 0.626, -0.779, -0.026, 0.611, 0.511, -0.604, 0.484, 0.363, 0.797)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.147, 0.426, 0.219, 0.911, -0.412, -0.004, 0.412, 0.911, 0.011, -0.001, -0.012, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.005, 0.002, 0.994, 0.103, -0.021, -0.044, 0.585, 0.81, 0.096, -0.805, 0.586)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.001, -0.008, -0.001, 0.996, 0.086, -0.025, -0.03, 0.585, 0.811, 0.084, -0.807, 0.585)},
	},
	[0.1] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.107, -1.49, -1.32, 0.951, 0.308, -0.013, -0.184, 0.532, -0.826, -0.247, 0.789, 0.563)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.337, 0.924, -0.181, -0.753, 0.38, 0.537, 0.565, -0.044, 0.824)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.331, -0.282, -0.255, 0.281, 0.927, 0.247, -0.958, 0.288, 0.008, -0.063, -0.239, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.307, 0.042, 0.491, 0.869, -0.492, -0.045, 0.488, 0.869, -0.079, 0.078, 0.046, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.938, -0.199, -0.521, 0.623, -0.782, -0.022, 0.614, 0.506, -0.606, 0.485, 0.364, 0.795)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.149, 0.444, 0.22, 0.909, -0.416, -0.005, 0.416, 0.909, 0.013, -0.001, -0.014, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.007, 0.003, 0.994, 0.107, -0.022, -0.046, 0.589, 0.807, 0.099, -0.801, 0.591)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.001, -0.011, -0.001, 0.996, 0.081, -0.027, -0.026, 0.589, 0.808, 0.082, -0.804, 0.589)},
	},
	[0.117] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.106, -1.471, -1.333, 0.951, 0.308, -0.016, -0.185, 0.531, -0.827, -0.246, 0.79, 0.562)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.336, 0.924, -0.182, -0.751, 0.38, 0.54, 0.568, -0.044, 0.822)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.327, -0.275, -0.258, 0.271, 0.93, 0.248, -0.961, 0.278, 0.009, -0.06, -0.24, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.308, 0.06, 0.492, 0.87, -0.492, -0.042, 0.488, 0.869, -0.081, 0.076, 0.05, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.932, -0.179, -0.516, 0.619, -0.785, -0.017, 0.617, 0.5, -0.608, 0.486, 0.365, 0.794)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.152, 0.465, 0.221, 0.907, -0.42, -0.006, 0.42, 0.907, 0.016, -0.001, -0.017, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.01, 0.004, 0.994, 0.111, -0.023, -0.048, 0.595, 0.802, 0.102, -0.796, 0.597)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.001, -0.015, -0.002, 0.997, 0.076, -0.031, -0.021, 0.595, 0.804, 0.079, -0.8, 0.594)},
	},
	[0.133] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.104, -1.45, -1.348, 0.951, 0.307, -0.019, -0.187, 0.529, -0.828, -0.244, 0.791, 0.561)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.336, 0.924, -0.183, -0.749, 0.38, 0.543, 0.571, -0.045, 0.82)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.324, -0.267, -0.262, 0.26, 0.933, 0.249, -0.964, 0.266, 0.01, -0.057, -0.242, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.31, 0.08, 0.493, 0.87, -0.491, -0.038, 0.487, 0.869, -0.083, 0.074, 0.054, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.925, -0.155, -0.51, 0.614, -0.789, -0.012, 0.621, 0.492, -0.61, 0.487, 0.367, 0.792)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.155, 0.49, 0.222, 0.905, -0.425, -0.008, 0.425, 0.905, 0.019, -0.001, -0.02, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.012, 0.005, 0.993, 0.115, -0.024, -0.05, 0.602, 0.797, 0.107, -0.791, 0.603)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.001, -0.02, -0.002, 0.997, 0.07, -0.034, -0.015, 0.601, 0.799, 0.077, -0.796, 0.6)},
	},
	[0.15] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.101, -1.426, -1.365, 0.951, 0.307, -0.023, -0.189, 0.527, -0.829, -0.242, 0.793, 0.559)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.335, 0.924, -0.185, -0.747, 0.38, 0.546, 0.574, -0.045, 0.817)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.319, -0.258, -0.265, 0.247, 0.936, 0.25, -0.968, 0.252, 0.01, -0.053, -0.244, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.311, 0.104, 0.494, 0.871, -0.491, -0.033, 0.487, 0.869, -0.086, 0.071, 0.058, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.917, -0.129, -0.503, 0.609, -0.793, -0.005, 0.625, 0.484, -0.612, 0.488, 0.369, 0.791)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.158, 0.517, 0.224, 0.902, -0.431, -0.009, 0.431, 0.902, 0.022, -0.002, -0.024, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.016, 0.006, 0.992, 0.12, -0.026, -0.053, 0.609, 0.792, 0.111, -0.784, 0.61)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.002, -0.025, -0.003, 0.997, 0.063, -0.039, -0.008, 0.608, 0.794, 0.074, -0.791, 0.607)},
	},
	[0.167] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.099, -1.399, -1.384, 0.952, 0.306, -0.026, -0.192, 0.524, -0.83, -0.24, 0.794, 0.558)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.335, 0.924, -0.186, -0.744, 0.38, 0.55, 0.578, -0.046, 0.814)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.314, -0.247, -0.27, 0.232, 0.94, 0.251, -0.971, 0.237, 0.011, -0.049, -0.247, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.313, 0.13, 0.495, 0.871, -0.49, -0.028, 0.486, 0.869, -0.089, 0.068, 0.063, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.908, -0.099, -0.496, 0.602, -0.798, 0.002, 0.63, 0.474, -0.615, 0.49, 0.371, 0.789)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.162, 0.548, 0.225, 0.899, -0.438, -0.011, 0.438, 0.899, 0.026, -0.002, -0.028, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.02, 0.008, 0.992, 0.126, -0.028, -0.056, 0.617, 0.785, 0.116, -0.777, 0.619)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.002, -0.031, -0.004, 0.998, 0.056, -0.043, -0, 0.616, 0.788, 0.07, -0.786, 0.614)},
	},
	[0.183] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.096, -1.369, -1.405, 0.952, 0.306, -0.031, -0.195, 0.522, -0.831, -0.238, 0.796, 0.556)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.054, 0.016, 0.334, 0.924, -0.187, -0.741, 0.38, 0.554, 0.583, -0.046, 0.811)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.309, -0.236, -0.274, 0.216, 0.943, 0.253, -0.975, 0.22, 0.012, -0.044, -0.249, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.314, 0.158, 0.497, 0.872, -0.49, -0.023, 0.486, 0.869, -0.092, 0.065, 0.069, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.898, -0.066, -0.487, 0.596, -0.803, 0.01, 0.635, 0.464, -0.618, 0.492, 0.374, 0.786)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.166, 0.583, 0.227, 0.896, -0.445, -0.012, 0.445, 0.895, 0.03, -0.002, -0.033, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.024, 0.009, 0.991, 0.132, -0.031, -0.06, 0.626, 0.778, 0.122, -0.769, 0.628)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.003, -0.038, -0.005, 0.998, 0.047, -0.048, 0.008, 0.624, 0.781, 0.067, -0.78, 0.623)},
	},
	[0.2] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.093, -1.337, -1.428, 0.952, 0.305, -0.035, -0.197, 0.519, -0.832, -0.235, 0.798, 0.554)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.054, 0.016, 0.333, 0.924, -0.189, -0.737, 0.38, 0.558, 0.587, -0.046, 0.808)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.302, -0.223, -0.279, 0.198, 0.947, 0.254, -0.979, 0.202, 0.013, -0.039, -0.251, 0.967)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.316, 0.19, 0.498, 0.872, -0.489, -0.017, 0.485, 0.869, -0.095, 0.061, 0.075, 0.995)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.887, -0.031, -0.478, 0.588, -0.809, 0.018, 0.641, 0.452, -0.621, 0.494, 0.377, 0.784)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.171, 0.62, 0.229, 0.892, -0.452, -0.015, 0.453, 0.891, 0.035, -0.003, -0.038, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.028, 0.011, 0.99, 0.139, -0.033, -0.064, 0.635, 0.77, 0.128, -0.76, 0.637)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.003, -0.045, -0.006, 0.998, 0.038, -0.054, 0.018, 0.634, 0.773, 0.063, -0.773, 0.632)},
	},
	[0.217] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.089, -1.301, -1.453, 0.952, 0.305, -0.041, -0.201, 0.516, -0.833, -0.233, 0.801, 0.552)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.054, 0.016, 0.332, 0.924, -0.191, -0.734, 0.38, 0.563, 0.593, -0.047, 0.804)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.296, -0.209, -0.285, 0.179, 0.95, 0.256, -0.983, 0.182, 0.014, -0.033, -0.254, 0.967)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.318, 0.224, 0.5, 0.873, -0.488, -0.01, 0.485, 0.869, -0.099, 0.057, 0.082, 0.995)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.875, 0.008, -0.468, 0.58, -0.814, 0.028, 0.647, 0.439, -0.624, 0.496, 0.379, 0.781)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.176, 0.661, 0.231, 0.887, -0.461, -0.017, 0.461, 0.886, 0.04, -0.003, -0.043, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.002, -0.033, 0.013, 0.988, 0.147, -0.036, -0.068, 0.645, 0.761, 0.135, -0.75, 0.648)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.004, -0.053, -0.007, 0.998, 0.027, -0.059, 0.028, 0.643, 0.765, 0.059, -0.765, 0.641)},
	},
	[0.233] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.086, -1.266, -1.478, 0.952, 0.304, -0.046, -0.204, 0.513, -0.834, -0.23, 0.803, 0.55)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.053, 0.016, 0.331, 0.924, -0.193, -0.73, 0.38, 0.568, 0.598, -0.048, 0.8)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.289, -0.195, -0.291, 0.16, 0.953, 0.258, -0.987, 0.161, 0.015, -0.027, -0.257, 0.966)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.32, 0.258, 0.502, 0.873, -0.487, -0.003, 0.484, 0.869, -0.103, 0.053, 0.088, 0.995)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.863, 0.047, -0.458, 0.571, -0.82, 0.037, 0.652, 0.426, -0.627, 0.498, 0.382, 0.779)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.181, 0.702, 0.233, 0.883, -0.469, -0.019, 0.469, 0.882, 0.045, -0.004, -0.049, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.002, -0.038, 0.015, 0.987, 0.155, -0.04, -0.073, 0.656, 0.751, 0.142, -0.739, 0.659)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.004, -0.061, -0.008, 0.998, 0.016, -0.065, 0.039, 0.654, 0.756, 0.055, -0.757, 0.652)},
	},
	[0.25] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.083, -1.233, -1.501, 0.952, 0.303, -0.05, -0.207, 0.51, -0.835, -0.227, 0.805, 0.548)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.053, 0.016, 0.33, 0.924, -0.195, -0.725, 0.381, 0.574, 0.604, -0.048, 0.796)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.283, -0.183, -0.296, 0.142, 0.955, 0.259, -0.99, 0.143, 0.016, -0.022, -0.259, 0.966)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.322, 0.289, 0.504, 0.874, -0.486, 0.003, 0.484, 0.869, -0.106, 0.049, 0.094, 0.994)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.853, 0.083, -0.449, 0.564, -0.825, 0.046, 0.658, 0.415, -0.629, 0.5, 0.385, 0.776)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.186, 0.739, 0.235, 0.879, -0.477, -0.021, 0.477, 0.877, 0.049, -0.005, -0.054, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.002, -0.044, 0.017, 0.986, 0.163, -0.043, -0.078, 0.667, 0.741, 0.15, -0.727, 0.67)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.005, -0.07, -0.009, 0.997, 0.004, -0.072, 0.051, 0.664, 0.746, 0.05, -0.747, 0.662)},
	},
	[0.267] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.08, -1.203, -1.522, 0.952, 0.303, -0.055, -0.209, 0.508, -0.836, -0.225, 0.807, 0.547)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.053, 0.015, 0.329, 0.923, -0.197, -0.721, 0.381, 0.58, 0.61, -0.049, 0.791)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.278, -0.171, -0.3, 0.125, 0.957, 0.261, -0.992, 0.125, 0.017, -0.017, -0.261, 0.965)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.324, 0.318, 0.505, 0.874, -0.485, 0.008, 0.483, 0.869, -0.11, 0.046, 0.1, 0.994)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.843, 0.116, -0.44, 0.557, -0.829, 0.054, 0.662, 0.404, -0.631, 0.502, 0.387, 0.774)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.19, 0.773, 0.237, 0.875, -0.484, -0.023, 0.484, 0.873, 0.053, -0.005, -0.058, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.002, -0.05, 0.019, 0.984, 0.172, -0.047, -0.084, 0.679, 0.729, 0.158, -0.714, 0.683)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.005, -0.08, -0.01, 0.997, -0.009, -0.078, 0.064, 0.676, 0.735, 0.046, -0.737, 0.674)},
	},
	[0.283] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.077, -1.176, -1.541, 0.951, 0.302, -0.058, -0.212, 0.506, -0.836, -0.223, 0.808, 0.545)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.052, 0.015, 0.328, 0.923, -0.199, -0.715, 0.381, 0.586, 0.617, -0.05, 0.786)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.273, -0.161, -0.305, 0.111, 0.959, 0.262, -0.994, 0.11, 0.017, -0.012, -0.262, 0.965)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.325, 0.344, 0.507, 0.875, -0.485, 0.014, 0.483, 0.868, -0.112, 0.043, 0.105, 0.994)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.834, 0.146, -0.433, 0.55, -0.833, 0.061, 0.666, 0.394, -0.633, 0.504, 0.389, 0.772)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.194, 0.804, 0.239, 0.871, -0.49, -0.025, 0.49, 0.87, 0.057, -0.006, -0.062, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.003, -0.056, 0.022, 0.982, 0.182, -0.052, -0.09, 0.691, 0.717, 0.166, -0.699, 0.695)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.006, -0.09, -0.011, 0.996, -0.023, -0.085, 0.078, 0.687, 0.722, 0.041, -0.726, 0.686)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.997, 0.025, 0.072, 0.016, 0.852, -0.523, -0.074, 0.523, 0.849)},
	},
	[0.3] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.075, -1.152, -1.558, 0.951, 0.302, -0.062, -0.214, 0.503, -0.837, -0.221, 0.81, 0.544)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.052, 0.015, 0.327, 0.923, -0.202, -0.71, 0.381, 0.592, 0.624, -0.05, 0.78)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.268, -0.151, -0.309, 0.097, 0.96, 0.263, -0.995, 0.096, 0.018, -0.008, -0.264, 0.965)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.327, 0.367, 0.508, 0.875, -0.484, 0.018, 0.482, 0.868, -0.115, 0.04, 0.109, 0.993)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.826, 0.172, -0.426, 0.544, -0.836, 0.067, 0.67, 0.385, -0.635, 0.505, 0.391, 0.77)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.198, 0.832, 0.24, 0.868, -0.495, -0.027, 0.496, 0.866, 0.06, -0.007, -0.066, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.003, -0.063, 0.025, 0.98, 0.192, -0.057, -0.097, 0.704, 0.703, 0.175, -0.684, 0.709)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.007, -0.101, -0.013, 0.995, -0.038, -0.092, 0.092, 0.699, 0.709, 0.037, -0.714, 0.699)},
	},
	[0.317] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.073, -1.131, -1.573, 0.951, 0.301, -0.065, -0.216, 0.502, -0.838, -0.22, 0.811, 0.542)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.052, 0.015, 0.326, 0.923, -0.204, -0.704, 0.381, 0.599, 0.631, -0.051, 0.774)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.264, -0.143, -0.312, 0.086, 0.961, 0.265, -0.996, 0.084, 0.018, -0.005, -0.265, 0.964)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.328, 0.387, 0.509, 0.875, -0.483, 0.022, 0.482, 0.868, -0.117, 0.038, 0.113, 0.993)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.819, 0.196, -0.42, 0.539, -0.839, 0.073, 0.673, 0.377, -0.636, 0.507, 0.392, 0.768)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.201, 0.857, 0.241, 0.865, -0.5, -0.028, 0.501, 0.863, 0.063, -0.007, -0.069, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.003, -0.07, 0.027, 0.977, 0.202, -0.062, -0.105, 0.717, 0.689, 0.184, -0.667, 0.722)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.008, -0.113, -0.014, 0.994, -0.054, -0.099, 0.108, 0.711, 0.695, 0.032, -0.701, 0.712)},
	},
	[0.333] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.071, -1.113, -1.586, 0.951, 0.301, -0.068, -0.218, 0.5, -0.838, -0.218, 0.812, 0.541)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.051, 0.015, 0.324, 0.923, -0.207, -0.699, 0.381, 0.606, 0.638, -0.052, 0.768)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.261, -0.136, -0.315, 0.075, 0.961, 0.266, -0.997, 0.073, 0.019, -0.002, -0.266, 0.964)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.329, 0.405, 0.51, 0.875, -0.483, 0.026, 0.482, 0.868, -0.119, 0.035, 0.117, 0.993)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.813, 0.216, -0.414, 0.534, -0.842, 0.078, 0.676, 0.37, -0.638, 0.508, 0.393, 0.766)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.203, 0.878, 0.242, 0.863, -0.504, -0.03, 0.505, 0.861, 0.066, -0.008, -0.072, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.004, -0.078, 0.03, 0.975, 0.213, -0.068, -0.113, 0.731, 0.673, 0.194, -0.648, 0.736)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.008, -0.125, -0.016, 0.992, -0.071, -0.106, 0.124, 0.723, 0.679, 0.028, -0.687, 0.726)},
	},
	[0.35] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.07, -1.097, -1.597, 0.951, 0.3, -0.07, -0.219, 0.499, -0.839, -0.217, 0.813, 0.54)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.051, 0.015, 0.323, 0.923, -0.209, -0.693, 0.381, 0.612, 0.644, -0.053, 0.763)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.258, -0.13, -0.317, 0.067, 0.962, 0.266, -0.998, 0.064, 0.019, 0.001, -0.267, 0.964)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.33, 0.42, 0.511, 0.876, -0.482, 0.028, 0.482, 0.868, -0.121, 0.034, 0.12, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.807, 0.233, -0.41, 0.531, -0.844, 0.082, 0.678, 0.364, -0.639, 0.509, 0.394, 0.765)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.206, 0.896, 0.243, 0.861, -0.508, -0.031, 0.509, 0.858, 0.068, -0.008, -0.074, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.004, -0.086, 0.033, 0.972, 0.224, -0.075, -0.121, 0.744, 0.657, 0.203, -0.629, 0.751)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.009, -0.138, -0.017, 0.99, -0.089, -0.112, 0.142, 0.735, 0.663, 0.024, -0.672, 0.74)},
	},
	[0.367] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.068, -1.084, -1.606, 0.951, 0.3, -0.072, -0.22, 0.498, -0.839, -0.216, 0.814, 0.539)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.05, 0.015, 0.322, 0.923, -0.211, -0.688, 0.381, 0.617, 0.65, -0.053, 0.758)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.256, -0.125, -0.319, 0.06, 0.962, 0.267, -0.998, 0.057, 0.019, 0.003, -0.268, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.331, 0.432, 0.512, 0.876, -0.482, 0.031, 0.482, 0.868, -0.122, 0.032, 0.122, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.803, 0.247, -0.406, 0.527, -0.845, 0.086, 0.68, 0.359, -0.639, 0.51, 0.395, 0.764)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.207, 0.91, 0.244, 0.859, -0.511, -0.032, 0.512, 0.856, 0.07, -0.008, -0.076, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.004, -0.094, 0.037, 0.968, 0.235, -0.082, -0.13, 0.758, 0.64, 0.213, -0.609, 0.764)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.01, -0.151, -0.019, 0.987, -0.107, -0.119, 0.159, 0.747, 0.646, 0.02, -0.656, 0.754)},
	},
	[0.383] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.067, -1.074, -1.613, 0.951, 0.3, -0.073, -0.221, 0.497, -0.839, -0.215, 0.814, 0.539)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.05, 0.014, 0.321, 0.923, -0.213, -0.683, 0.381, 0.622, 0.656, -0.054, 0.753)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.254, -0.121, -0.321, 0.054, 0.962, 0.268, -0.999, 0.051, 0.019, 0.005, -0.268, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.331, 0.442, 0.512, 0.876, -0.481, 0.033, 0.481, 0.868, -0.123, 0.031, 0.124, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.8, 0.258, -0.404, 0.525, -0.847, 0.088, 0.681, 0.356, -0.64, 0.51, 0.396, 0.763)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.209, 0.922, 0.245, 0.858, -0.513, -0.033, 0.514, 0.855, 0.071, -0.009, -0.078, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.005, -0.102, 0.04, 0.965, 0.246, -0.089, -0.139, 0.77, 0.623, 0.221, -0.589, 0.777)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.011, -0.163, -0.02, 0.984, -0.125, -0.125, 0.176, 0.757, 0.629, 0.016, -0.641, 0.767)},
	},
	[0.4] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.067, -1.067, -1.618, 0.951, 0.3, -0.074, -0.222, 0.496, -0.839, -0.215, 0.815, 0.538)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.05, 0.014, 0.32, 0.923, -0.215, -0.679, 0.381, 0.627, 0.661, -0.054, 0.748)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.252, -0.118, -0.322, 0.05, 0.962, 0.268, -0.999, 0.047, 0.019, 0.006, -0.269, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.332, 0.449, 0.512, 0.876, -0.481, 0.034, 0.481, 0.868, -0.124, 0.03, 0.125, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.797, 0.266, -0.402, 0.523, -0.847, 0.09, 0.682, 0.353, -0.64, 0.511, 0.397, 0.763)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.21, 0.93, 0.245, 0.857, -0.515, -0.033, 0.516, 0.854, 0.072, -0.009, -0.079, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.005, -0.109, 0.042, 0.962, 0.255, -0.095, -0.147, 0.781, 0.607, 0.229, -0.57, 0.789)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.012, -0.174, -0.022, 0.981, -0.141, -0.13, 0.191, 0.766, 0.613, 0.013, -0.627, 0.779)},
	},
	[0.417] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.066, -1.063, -1.621, 0.951, 0.3, -0.075, -0.222, 0.496, -0.84, -0.214, 0.815, 0.538)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.319, 0.923, -0.217, -0.675, 0.381, 0.632, 0.666, -0.055, 0.744)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.252, -0.116, -0.323, 0.048, 0.962, 0.268, -0.999, 0.044, 0.02, 0.007, -0.269, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.332, 0.453, 0.513, 0.876, -0.481, 0.035, 0.481, 0.868, -0.125, 0.03, 0.126, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.796, 0.271, -0.4, 0.522, -0.848, 0.091, 0.683, 0.352, -0.641, 0.511, 0.397, 0.762)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.21, 0.935, 0.245, 0.856, -0.516, -0.033, 0.517, 0.853, 0.073, -0.009, -0.079, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.005, -0.116, 0.045, 0.959, 0.264, -0.102, -0.155, 0.791, 0.592, 0.237, -0.552, 0.799)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.012, -0.185, -0.023, 0.978, -0.157, -0.135, 0.206, 0.775, 0.598, 0.011, -0.613, 0.79)},
	},
	[0.433] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.066, -1.062, -1.622, 0.951, 0.3, -0.075, -0.222, 0.496, -0.84, -0.214, 0.815, 0.538)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.318, 0.923, -0.218, -0.671, 0.381, 0.636, 0.67, -0.056, 0.74)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.251, -0.116, -0.323, 0.047, 0.962, 0.268, -0.999, 0.043, 0.02, 0.007, -0.269, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.332, 0.454, 0.513, 0.876, -0.481, 0.035, 0.481, 0.868, -0.125, 0.03, 0.126, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.796, 0.272, -0.4, 0.522, -0.848, 0.092, 0.683, 0.351, -0.641, 0.511, 0.397, 0.762)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.211, 0.937, 0.245, 0.856, -0.516, -0.034, 0.517, 0.853, 0.073, -0.009, -0.08, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.006, -0.122, 0.048, 0.956, 0.272, -0.108, -0.163, 0.8, 0.578, 0.244, -0.535, 0.809)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.013, -0.196, -0.024, 0.975, -0.171, -0.139, 0.22, 0.782, 0.583, 0.008, -0.599, 0.801)},
	},
	[0.45] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.066, -1.062, -1.622, 0.951, 0.3, -0.075, -0.222, 0.496, -0.84, -0.214, 0.815, 0.538)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.317, 0.923, -0.22, -0.667, 0.381, 0.64, 0.674, -0.056, 0.737)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.252, -0.116, -0.323, 0.047, 0.962, 0.268, -0.999, 0.044, 0.02, 0.007, -0.269, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.332, 0.454, 0.513, 0.876, -0.481, 0.035, 0.481, 0.868, -0.125, 0.03, 0.126, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.796, 0.271, -0.4, 0.522, -0.848, 0.092, 0.683, 0.351, -0.641, 0.511, 0.397, 0.762)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.211, 0.936, 0.245, 0.856, -0.516, -0.033, 0.517, 0.853, 0.073, -0.009, -0.08, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.006, -0.128, 0.05, 0.953, 0.28, -0.114, -0.17, 0.808, 0.564, 0.25, -0.519, 0.818)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.014, -0.205, -0.026, 0.972, -0.185, -0.142, 0.233, 0.789, 0.569, 0.007, -0.586, 0.81)},
	},
	[0.467] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.066, -1.064, -1.62, 0.951, 0.3, -0.075, -0.222, 0.496, -0.839, -0.215, 0.815, 0.538)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.316, 0.923, -0.221, -0.664, 0.381, 0.643, 0.677, -0.056, 0.733)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.252, -0.117, -0.322, 0.049, 0.962, 0.268, -0.999, 0.045, 0.02, 0.007, -0.269, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.332, 0.452, 0.513, 0.876, -0.481, 0.035, 0.481, 0.868, -0.125, 0.03, 0.126, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.796, 0.269, -0.401, 0.522, -0.848, 0.091, 0.683, 0.352, -0.64, 0.511, 0.397, 0.763)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.21, 0.934, 0.245, 0.856, -0.515, -0.033, 0.516, 0.853, 0.072, -0.009, -0.079, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.006, -0.134, 0.052, 0.95, 0.287, -0.119, -0.177, 0.815, 0.551, 0.256, -0.503, 0.826)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.014, -0.214, -0.027, 0.969, -0.198, -0.145, 0.246, 0.794, 0.556, 0.005, -0.574, 0.819)},
	},
	[0.483] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.067, -1.067, -1.618, 0.951, 0.3, -0.074, -0.222, 0.496, -0.839, -0.215, 0.815, 0.538)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.315, 0.923, -0.222, -0.661, 0.382, 0.646, 0.681, -0.057, 0.73)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.252, -0.118, -0.322, 0.05, 0.962, 0.268, -0.999, 0.047, 0.019, 0.006, -0.269, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.332, 0.449, 0.512, 0.876, -0.481, 0.034, 0.481, 0.868, -0.124, 0.03, 0.125, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.797, 0.266, -0.402, 0.523, -0.847, 0.09, 0.682, 0.353, -0.64, 0.511, 0.397, 0.763)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.21, 0.93, 0.245, 0.857, -0.515, -0.033, 0.516, 0.854, 0.072, -0.009, -0.079, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.006, -0.139, 0.054, 0.948, 0.293, -0.125, -0.183, 0.822, 0.539, 0.261, -0.488, 0.833)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.015, -0.223, -0.028, 0.966, -0.21, -0.148, 0.257, 0.799, 0.543, 0.004, -0.563, 0.827)},
	},
	[0.5] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.067, -1.072, -1.615, 0.951, 0.3, -0.073, -0.221, 0.497, -0.839, -0.215, 0.815, 0.539)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.048, 0.014, 0.315, 0.923, -0.223, -0.659, 0.382, 0.648, 0.683, -0.057, 0.728)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.253, -0.12, -0.321, 0.053, 0.962, 0.268, -0.999, 0.049, 0.019, 0.005, -0.268, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.331, 0.445, 0.512, 0.876, -0.481, 0.033, 0.481, 0.868, -0.124, 0.031, 0.124, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.799, 0.261, -0.403, 0.524, -0.847, 0.089, 0.682, 0.355, -0.64, 0.51, 0.396, 0.763)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.209, 0.925, 0.245, 0.857, -0.514, -0.033, 0.515, 0.854, 0.071, -0.009, -0.078, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.007, -0.144, 0.056, 0.945, 0.299, -0.13, -0.19, 0.828, 0.528, 0.265, -0.474, 0.839)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.016, -0.231, -0.029, 0.964, -0.221, -0.15, 0.268, 0.804, 0.531, 0.003, -0.552, 0.834)},
	},
	[0.517] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.068, -1.077, -1.611, 0.951, 0.3, -0.073, -0.221, 0.497, -0.839, -0.216, 0.814, 0.539)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.314, 0.923, -0.224, -0.657, 0.382, 0.651, 0.686, -0.057, 0.726)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.254, -0.122, -0.32, 0.056, 0.962, 0.267, -0.998, 0.053, 0.019, 0.004, -0.268, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.331, 0.439, 0.512, 0.876, -0.481, 0.032, 0.481, 0.868, -0.123, 0.031, 0.123, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.801, 0.255, -0.404, 0.526, -0.846, 0.087, 0.681, 0.357, -0.64, 0.51, 0.396, 0.764)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.208, 0.918, 0.244, 0.858, -0.512, -0.032, 0.513, 0.855, 0.071, -0.008, -0.077, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.007, -0.148, 0.058, 0.943, 0.304, -0.135, -0.195, 0.833, 0.517, 0.27, -0.462, 0.845)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.016, -0.238, -0.03, 0.961, -0.232, -0.152, 0.277, 0.808, 0.52, 0.002, -0.542, 0.84)},
	},
	[0.533] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.068, -1.084, -1.606, 0.951, 0.3, -0.072, -0.22, 0.498, -0.839, -0.216, 0.814, 0.539)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.314, 0.923, -0.225, -0.655, 0.382, 0.653, 0.688, -0.058, 0.724)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.256, -0.125, -0.319, 0.06, 0.962, 0.267, -0.998, 0.057, 0.019, 0.003, -0.268, 0.963)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.331, 0.432, 0.512, 0.876, -0.482, 0.031, 0.482, 0.868, -0.122, 0.032, 0.122, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.803, 0.247, -0.406, 0.527, -0.845, 0.086, 0.68, 0.359, -0.639, 0.51, 0.395, 0.764)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.207, 0.91, 0.244, 0.859, -0.511, -0.032, 0.512, 0.856, 0.07, -0.008, -0.076, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.007, -0.153, 0.059, 0.941, 0.309, -0.139, -0.2, 0.838, 0.508, 0.273, -0.45, 0.85)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.016, -0.244, -0.03, 0.958, -0.241, -0.154, 0.286, 0.811, 0.51, 0.002, -0.533, 0.846)},
	},
	[0.55] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.069, -1.092, -1.6, 0.951, 0.3, -0.07, -0.219, 0.498, -0.839, -0.217, 0.813, 0.54)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.313, 0.923, -0.225, -0.653, 0.382, 0.654, 0.689, -0.058, 0.722)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.257, -0.128, -0.318, 0.064, 0.962, 0.267, -0.998, 0.061, 0.019, 0.002, -0.267, 0.964)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.33, 0.425, 0.511, 0.876, -0.482, 0.029, 0.482, 0.868, -0.121, 0.033, 0.121, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.806, 0.238, -0.409, 0.529, -0.844, 0.083, 0.679, 0.363, -0.639, 0.509, 0.395, 0.765)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.206, 0.901, 0.243, 0.86, -0.509, -0.031, 0.51, 0.858, 0.069, -0.008, -0.075, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.007, -0.156, 0.061, 0.939, 0.313, -0.143, -0.205, 0.842, 0.499, 0.277, -0.439, 0.855)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.017, -0.25, -0.031, 0.956, -0.25, -0.155, 0.294, 0.814, 0.501, 0.001, -0.525, 0.851)},
	},
	[0.567] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.07, -1.102, -1.594, 0.951, 0.3, -0.069, -0.219, 0.499, -0.838, -0.217, 0.813, 0.541)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.313, 0.923, -0.226, -0.652, 0.382, 0.655, 0.691, -0.058, 0.721)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.259, -0.132, -0.316, 0.069, 0.961, 0.266, -0.998, 0.067, 0.019, 0, -0.267, 0.964)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.33, 0.415, 0.511, 0.876, -0.482, 0.028, 0.482, 0.868, -0.12, 0.034, 0.119, 0.992)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.809, 0.228, -0.411, 0.532, -0.843, 0.081, 0.677, 0.366, -0.638, 0.508, 0.394, 0.766)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.205, 0.89, 0.243, 0.862, -0.507, -0.031, 0.508, 0.859, 0.067, -0.008, -0.074, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.007, -0.16, 0.062, 0.937, 0.317, -0.147, -0.209, 0.845, 0.491, 0.28, -0.43, 0.859)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.017, -0.256, -0.032, 0.954, -0.257, -0.157, 0.301, 0.816, 0.493, 0.001, -0.517, 0.856)},
	},
	[0.583] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.071, -1.113, -1.586, 0.951, 0.301, -0.068, -0.218, 0.5, -0.838, -0.218, 0.812, 0.541)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.313, 0.923, -0.226, -0.651, 0.382, 0.656, 0.692, -0.058, 0.72)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.261, -0.136, -0.315, 0.075, 0.961, 0.266, -0.997, 0.073, 0.019, -0.002, -0.266, 0.964)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.329, 0.405, 0.51, 0.875, -0.483, 0.026, 0.482, 0.868, -0.119, 0.035, 0.117, 0.993)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.813, 0.216, -0.414, 0.534, -0.842, 0.078, 0.676, 0.37, -0.638, 0.508, 0.393, 0.766)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.203, 0.878, 0.242, 0.863, -0.504, -0.03, 0.505, 0.861, 0.066, -0.008, -0.072, 0.997)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.162, 0.063, 0.935, 0.321, -0.15, -0.213, 0.849, 0.484, 0.282, -0.421, 0.862)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.018, -0.26, -0.032, 0.952, -0.264, -0.158, 0.307, 0.818, 0.486, 0.001, -0.51, 0.86)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.997, 0.026, 0.072, 0.016, 0.846, -0.533, -0.074, 0.532, 0.843)},
	},
	[0.6] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.072, -1.125, -1.578, 0.951, 0.301, -0.066, -0.217, 0.501, -0.838, -0.219, 0.811, 0.542)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.313, 0.922, -0.226, -0.65, 0.382, 0.657, 0.692, -0.058, 0.719)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.263, -0.14, -0.313, 0.082, 0.961, 0.265, -0.997, 0.08, 0.018, -0.004, -0.266, 0.964)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.328, 0.394, 0.509, 0.875, -0.483, 0.023, 0.482, 0.868, -0.118, 0.037, 0.115, 0.993)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.816, 0.203, -0.418, 0.537, -0.84, 0.075, 0.674, 0.375, -0.637, 0.507, 0.393, 0.767)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.202, 0.864, 0.242, 0.865, -0.502, -0.029, 0.502, 0.862, 0.064, -0.007, -0.07, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.165, 0.064, 0.934, 0.323, -0.153, -0.217, 0.851, 0.478, 0.284, -0.414, 0.865)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.018, -0.264, -0.033, 0.95, -0.27, -0.158, 0.313, 0.82, 0.479, 0.001, -0.505, 0.863)},
	},
	[0.617] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.073, -1.138, -1.568, 0.951, 0.301, -0.064, -0.215, 0.502, -0.838, -0.22, 0.811, 0.543)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.313, 0.922, -0.226, -0.65, 0.382, 0.657, 0.692, -0.058, 0.719)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.266, -0.145, -0.311, 0.089, 0.96, 0.264, -0.996, 0.088, 0.018, -0.006, -0.265, 0.964)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.327, 0.381, 0.509, 0.875, -0.483, 0.021, 0.482, 0.868, -0.117, 0.038, 0.112, 0.993)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.821, 0.188, -0.422, 0.541, -0.838, 0.071, 0.672, 0.379, -0.636, 0.506, 0.392, 0.768)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.2, 0.849, 0.241, 0.866, -0.499, -0.028, 0.499, 0.864, 0.062, -0.007, -0.068, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.167, 0.065, 0.933, 0.326, -0.155, -0.219, 0.853, 0.473, 0.286, -0.407, 0.867)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.018, -0.268, -0.033, 0.948, -0.275, -0.159, 0.317, 0.821, 0.474, 0, -0.5, 0.866)},
	},
	[0.633] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.075, -1.152, -1.558, 0.951, 0.302, -0.062, -0.214, 0.503, -0.837, -0.221, 0.81, 0.544)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.313, 0.923, -0.226, -0.651, 0.382, 0.657, 0.692, -0.058, 0.72)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.268, -0.151, -0.309, 0.097, 0.96, 0.263, -0.995, 0.096, 0.018, -0.008, -0.264, 0.965)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.327, 0.367, 0.508, 0.875, -0.484, 0.018, 0.482, 0.868, -0.115, 0.04, 0.109, 0.993)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.826, 0.172, -0.426, 0.544, -0.836, 0.067, 0.67, 0.385, -0.635, 0.505, 0.391, 0.77)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.198, 0.832, 0.24, 0.868, -0.495, -0.027, 0.496, 0.866, 0.06, -0.007, -0.066, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.169, 0.066, 0.932, 0.328, -0.157, -0.222, 0.855, 0.469, 0.288, -0.402, 0.869)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.018, -0.271, -0.034, 0.947, -0.279, -0.16, 0.321, 0.823, 0.469, 0, -0.496, 0.868)},
	},
	[0.65] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.076, -1.168, -1.547, 0.951, 0.302, -0.06, -0.213, 0.505, -0.837, -0.222, 0.809, 0.544)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.313, 0.923, -0.226, -0.652, 0.382, 0.656, 0.691, -0.058, 0.72)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.271, -0.157, -0.306, 0.106, 0.959, 0.263, -0.994, 0.105, 0.017, -0.011, -0.263, 0.965)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.326, 0.352, 0.507, 0.875, -0.484, 0.015, 0.483, 0.868, -0.113, 0.042, 0.106, 0.993)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.831, 0.155, -0.43, 0.548, -0.834, 0.063, 0.668, 0.391, -0.634, 0.504, 0.389, 0.771)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.195, 0.814, 0.239, 0.87, -0.492, -0.026, 0.492, 0.868, 0.058, -0.006, -0.063, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.17, 0.066, 0.931, 0.329, -0.158, -0.223, 0.856, 0.466, 0.289, -0.398, 0.871)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.018, -0.273, -0.034, 0.946, -0.282, -0.16, 0.324, 0.823, 0.466, 0, -0.493, 0.87)},
	},
	[0.667] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.078, -1.185, -1.535, 0.952, 0.302, -0.057, -0.211, 0.506, -0.836, -0.224, 0.808, 0.545)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.313, 0.923, -0.225, -0.653, 0.382, 0.654, 0.689, -0.058, 0.722)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.274, -0.164, -0.303, 0.115, 0.958, 0.262, -0.993, 0.115, 0.017, -0.014, -0.262, 0.965)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.325, 0.335, 0.506, 0.875, -0.485, 0.012, 0.483, 0.869, -0.112, 0.044, 0.103, 0.994)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.837, 0.136, -0.435, 0.552, -0.832, 0.058, 0.665, 0.397, -0.633, 0.503, 0.388, 0.772)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.193, 0.794, 0.238, 0.873, -0.488, -0.025, 0.488, 0.871, 0.056, -0.006, -0.061, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.171, 0.067, 0.93, 0.33, -0.16, -0.225, 0.857, 0.463, 0.29, -0.395, 0.872)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.018, -0.274, -0.034, 0.945, -0.284, -0.16, 0.326, 0.824, 0.463, 0, -0.49, 0.872)},
	},
	[0.683] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.08, -1.203, -1.522, 0.952, 0.303, -0.055, -0.209, 0.508, -0.836, -0.225, 0.807, 0.547)},
		["Head"] = {["CFrame"] = CFrame.new(-0.047, -0.048, 0.014, 0.314, 0.923, -0.225, -0.655, 0.382, 0.652, 0.687, -0.058, 0.724)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.278, -0.171, -0.3, 0.125, 0.957, 0.261, -0.992, 0.125, 0.017, -0.017, -0.261, 0.965)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.324, 0.318, 0.505, 0.874, -0.485, 0.008, 0.483, 0.869, -0.11, 0.046, 0.1, 0.994)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.843, 0.116, -0.44, 0.557, -0.829, 0.054, 0.662, 0.404, -0.631, 0.502, 0.387, 0.774)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.19, 0.773, 0.237, 0.875, -0.484, -0.023, 0.484, 0.873, 0.053, -0.005, -0.058, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.172, 0.067, 0.93, 0.331, -0.16, -0.225, 0.858, 0.462, 0.29, -0.393, 0.872)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.019, -0.275, -0.034, 0.945, -0.285, -0.16, 0.327, 0.824, 0.462, 0, -0.489, 0.872)},
	},
	[0.7] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.082, -1.223, -1.508, 0.952, 0.303, -0.052, -0.208, 0.509, -0.835, -0.227, 0.805, 0.548)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.048, 0.014, 0.315, 0.923, -0.223, -0.658, 0.382, 0.649, 0.684, -0.057, 0.727)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.281, -0.179, -0.297, 0.136, 0.956, 0.26, -0.99, 0.137, 0.016, -0.02, -0.26, 0.966)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.323, 0.299, 0.504, 0.874, -0.486, 0.005, 0.484, 0.869, -0.107, 0.048, 0.096, 0.994)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.849, 0.095, -0.446, 0.561, -0.826, 0.048, 0.659, 0.411, -0.63, 0.501, 0.385, 0.775)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.187, 0.751, 0.236, 0.878, -0.479, -0.022, 0.48, 0.876, 0.051, -0.005, -0.055, 0.998)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.172, 0.067, 0.93, 0.331, -0.16, -0.226, 0.858, 0.461, 0.29, -0.393, 0.873)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.019, -0.276, -0.034, 0.945, -0.286, -0.16, 0.328, 0.824, 0.461, 0, -0.489, 0.873)},
	},
	[0.717] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.084, -1.244, -1.494, 0.952, 0.303, -0.049, -0.206, 0.511, -0.834, -0.228, 0.804, 0.549)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.315, 0.923, -0.222, -0.661, 0.382, 0.646, 0.681, -0.057, 0.73)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.285, -0.187, -0.294, 0.148, 0.955, 0.259, -0.989, 0.149, 0.016, -0.024, -0.258, 0.966)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.321, 0.279, 0.503, 0.874, -0.486, 0.001, 0.484, 0.869, -0.105, 0.05, 0.092, 0.994)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.856, 0.072, -0.452, 0.566, -0.823, 0.043, 0.656, 0.418, -0.628, 0.499, 0.384, 0.777)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.184, 0.727, 0.235, 0.88, -0.474, -0.021, 0.475, 0.879, 0.048, -0.005, -0.052, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.171, 0.067, 0.93, 0.33, -0.16, -0.225, 0.857, 0.463, 0.29, -0.395, 0.872)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.019, -0.275, -0.034, 0.945, -0.284, -0.16, 0.326, 0.824, 0.463, 0, -0.49, 0.872)},
	},
	[0.733] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.086, -1.266, -1.478, 0.952, 0.304, -0.046, -0.204, 0.513, -0.834, -0.23, 0.803, 0.55)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.316, 0.923, -0.221, -0.665, 0.381, 0.642, 0.677, -0.056, 0.734)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.289, -0.195, -0.291, 0.16, 0.953, 0.258, -0.987, 0.161, 0.015, -0.027, -0.257, 0.966)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.32, 0.258, 0.502, 0.873, -0.487, -0.003, 0.484, 0.869, -0.103, 0.053, 0.088, 0.995)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.863, 0.047, -0.458, 0.571, -0.82, 0.037, 0.652, 0.426, -0.627, 0.498, 0.382, 0.779)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.181, 0.702, 0.233, 0.883, -0.469, -0.019, 0.469, 0.882, 0.045, -0.004, -0.049, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.169, 0.066, 0.931, 0.328, -0.158, -0.222, 0.855, 0.468, 0.288, -0.401, 0.87)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.018, -0.271, -0.034, 0.947, -0.28, -0.16, 0.322, 0.823, 0.468, 0, -0.495, 0.869)},
	},
	[0.75] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.088, -1.289, -1.462, 0.952, 0.304, -0.042, -0.202, 0.515, -0.833, -0.232, 0.801, 0.552)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.317, 0.923, -0.219, -0.669, 0.381, 0.637, 0.672, -0.056, 0.739)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.294, -0.204, -0.287, 0.172, 0.951, 0.256, -0.985, 0.175, 0.014, -0.031, -0.255, 0.966)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.319, 0.235, 0.501, 0.873, -0.488, -0.008, 0.485, 0.869, -0.1, 0.056, 0.084, 0.995)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.871, 0.022, -0.464, 0.577, -0.816, 0.031, 0.649, 0.435, -0.625, 0.496, 0.38, 0.78)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.178, 0.675, 0.232, 0.886, -0.464, -0.018, 0.464, 0.885, 0.042, -0.004, -0.045, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.166, 0.065, 0.933, 0.325, -0.154, -0.218, 0.852, 0.475, 0.285, -0.41, 0.866)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.018, -0.266, -0.033, 0.949, -0.273, -0.159, 0.315, 0.821, 0.476, 0.001, -0.502, 0.865)},
	},
	[0.767] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.09, -1.313, -1.445, 0.952, 0.305, -0.039, -0.2, 0.517, -0.832, -0.234, 0.8, 0.553)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.049, 0.014, 0.319, 0.923, -0.217, -0.674, 0.381, 0.632, 0.666, -0.055, 0.744)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.298, -0.214, -0.283, 0.186, 0.949, 0.255, -0.982, 0.188, 0.014, -0.035, -0.253, 0.967)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.317, 0.212, 0.5, 0.873, -0.488, -0.012, 0.485, 0.869, -0.098, 0.058, 0.079, 0.995)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.879, -0.005, -0.471, 0.583, -0.812, 0.024, 0.645, 0.444, -0.623, 0.495, 0.378, 0.782)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.174, 0.647, 0.23, 0.889, -0.458, -0.016, 0.458, 0.888, 0.038, -0.003, -0.041, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.008, -0.162, 0.063, 0.936, 0.32, -0.149, -0.212, 0.848, 0.486, 0.282, -0.424, 0.861)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.017, -0.259, -0.032, 0.952, -0.262, -0.157, 0.306, 0.818, 0.488, 0.001, -0.512, 0.859)},
	},
	[0.783] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.093, -1.337, -1.428, 0.952, 0.305, -0.035, -0.197, 0.519, -0.832, -0.235, 0.798, 0.554)},
		["Head"] = {["CFrame"] = CFrame.new(-0.048, -0.05, 0.014, 0.32, 0.923, -0.215, -0.68, 0.381, 0.626, 0.66, -0.054, 0.749)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.302, -0.223, -0.279, 0.198, 0.947, 0.254, -0.979, 0.202, 0.013, -0.039, -0.251, 0.967)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.316, 0.19, 0.498, 0.872, -0.489, -0.017, 0.485, 0.869, -0.095, 0.061, 0.075, 0.995)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.887, -0.031, -0.478, 0.588, -0.809, 0.018, 0.641, 0.452, -0.621, 0.494, 0.377, 0.784)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.171, 0.62, 0.229, 0.892, -0.452, -0.015, 0.453, 0.891, 0.035, -0.003, -0.038, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.007, -0.156, 0.061, 0.939, 0.313, -0.142, -0.205, 0.841, 0.5, 0.276, -0.441, 0.854)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.017, -0.25, -0.031, 0.956, -0.249, -0.155, 0.293, 0.814, 0.502, 0.001, -0.526, 0.851)},
	},
	[0.8] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.095, -1.359, -1.413, 0.952, 0.306, -0.032, -0.195, 0.521, -0.831, -0.237, 0.797, 0.556)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.05, 0.015, 0.321, 0.923, -0.212, -0.686, 0.381, 0.62, 0.653, -0.054, 0.756)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.307, -0.231, -0.276, 0.21, 0.944, 0.253, -0.977, 0.214, 0.012, -0.042, -0.25, 0.967)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.315, 0.168, 0.497, 0.872, -0.489, -0.021, 0.486, 0.869, -0.093, 0.063, 0.071, 0.995)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.894, -0.055, -0.484, 0.593, -0.805, 0.012, 0.637, 0.46, -0.619, 0.492, 0.375, 0.786)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.168, 0.595, 0.228, 0.894, -0.447, -0.013, 0.447, 0.894, 0.032, -0.002, -0.034, 0.999)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.007, -0.149, 0.058, 0.943, 0.305, -0.135, -0.195, 0.833, 0.517, 0.27, -0.461, 0.845)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.016, -0.238, -0.03, 0.961, -0.232, -0.152, 0.278, 0.808, 0.52, 0.002, -0.542, 0.841)},
	},
	[0.817] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.097, -1.379, -1.398, 0.952, 0.306, -0.029, -0.194, 0.523, -0.83, -0.239, 0.796, 0.557)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.051, 0.015, 0.323, 0.923, -0.209, -0.693, 0.381, 0.612, 0.645, -0.053, 0.762)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.31, -0.24, -0.273, 0.222, 0.942, 0.252, -0.974, 0.226, 0.012, -0.046, -0.248, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.314, 0.148, 0.496, 0.871, -0.49, -0.025, 0.486, 0.869, -0.091, 0.066, 0.067, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.901, -0.078, -0.49, 0.598, -0.802, 0.007, 0.634, 0.467, -0.617, 0.491, 0.373, 0.787)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.165, 0.571, 0.226, 0.897, -0.442, -0.012, 0.442, 0.896, 0.029, -0.002, -0.031, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.007, -0.14, 0.055, 0.947, 0.295, -0.126, -0.185, 0.823, 0.537, 0.262, -0.485, 0.834)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.015, -0.225, -0.028, 0.966, -0.213, -0.148, 0.259, 0.8, 0.54, 0.004, -0.56, 0.828)},
	},
	[0.833] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.099, -1.399, -1.384, 0.952, 0.306, -0.026, -0.192, 0.524, -0.83, -0.24, 0.794, 0.558)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.051, 0.015, 0.324, 0.923, -0.206, -0.7, 0.381, 0.604, 0.637, -0.052, 0.769)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.314, -0.247, -0.27, 0.232, 0.94, 0.251, -0.971, 0.237, 0.011, -0.049, -0.247, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.313, 0.13, 0.495, 0.871, -0.49, -0.028, 0.486, 0.869, -0.089, 0.068, 0.063, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.908, -0.099, -0.496, 0.602, -0.798, 0.002, 0.63, 0.474, -0.615, 0.49, 0.371, 0.789)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.162, 0.548, 0.225, 0.899, -0.438, -0.011, 0.438, 0.899, 0.026, -0.002, -0.028, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.006, -0.13, 0.051, 0.952, 0.283, -0.116, -0.173, 0.811, 0.559, 0.252, -0.512, 0.821)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.014, -0.209, -0.026, 0.971, -0.19, -0.143, 0.238, 0.791, 0.564, 0.006, -0.582, 0.813)},
	},
	[0.85] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.1, -1.417, -1.371, 0.952, 0.307, -0.024, -0.19, 0.526, -0.829, -0.242, 0.793, 0.559)},
		["Head"] = {["CFrame"] = CFrame.new(-0.049, -0.052, 0.015, 0.326, 0.923, -0.203, -0.707, 0.381, 0.596, 0.627, -0.051, 0.777)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.317, -0.254, -0.267, 0.242, 0.937, 0.25, -0.969, 0.247, 0.011, -0.052, -0.245, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.311, 0.112, 0.494, 0.871, -0.491, -0.032, 0.487, 0.869, -0.087, 0.07, 0.06, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.914, -0.119, -0.501, 0.607, -0.795, -0.003, 0.627, 0.481, -0.613, 0.489, 0.37, 0.79)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.159, 0.527, 0.224, 0.901, -0.433, -0.01, 0.433, 0.901, 0.024, -0.002, -0.025, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.006, -0.119, 0.046, 0.957, 0.269, -0.105, -0.159, 0.796, 0.584, 0.241, -0.542, 0.805)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.013, -0.191, -0.024, 0.977, -0.165, -0.137, 0.214, 0.779, 0.589, 0.009, -0.605, 0.796)},
	},
	[0.867] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.102, -1.434, -1.359, 0.951, 0.307, -0.021, -0.189, 0.527, -0.828, -0.243, 0.792, 0.56)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.052, 0.015, 0.328, 0.923, -0.2, -0.714, 0.381, 0.587, 0.618, -0.05, 0.785)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.321, -0.261, -0.264, 0.251, 0.935, 0.249, -0.966, 0.257, 0.01, -0.055, -0.244, 0.968)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.311, 0.096, 0.493, 0.87, -0.491, -0.035, 0.487, 0.869, -0.085, 0.072, 0.057, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.92, -0.138, -0.506, 0.61, -0.792, -0.007, 0.624, 0.487, -0.611, 0.488, 0.369, 0.791)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.157, 0.508, 0.223, 0.903, -0.429, -0.008, 0.429, 0.903, 0.021, -0.001, -0.023, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.005, -0.107, 0.042, 0.963, 0.253, -0.093, -0.145, 0.778, 0.611, 0.227, -0.575, 0.786)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.012, -0.171, -0.021, 0.982, -0.137, -0.129, 0.187, 0.764, 0.617, 0.014, -0.63, 0.776)},
	},
	[0.883] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.104, -1.45, -1.348, 0.951, 0.307, -0.019, -0.187, 0.529, -0.828, -0.244, 0.791, 0.561)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.053, 0.015, 0.329, 0.923, -0.197, -0.721, 0.381, 0.579, 0.609, -0.049, 0.791)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.324, -0.267, -0.262, 0.26, 0.933, 0.249, -0.964, 0.266, 0.01, -0.057, -0.242, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.31, 0.08, 0.493, 0.87, -0.491, -0.038, 0.487, 0.869, -0.083, 0.074, 0.054, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.925, -0.155, -0.51, 0.614, -0.789, -0.012, 0.621, 0.492, -0.61, 0.487, 0.367, 0.792)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.155, 0.49, 0.222, 0.905, -0.425, -0.008, 0.425, 0.905, 0.019, -0.001, -0.02, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.004, -0.093, 0.036, 0.969, 0.234, -0.081, -0.129, 0.757, 0.641, 0.212, -0.61, 0.763)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.01, -0.15, -0.019, 0.987, -0.106, -0.118, 0.157, 0.746, 0.647, 0.02, -0.658, 0.753)},
	},
	[0.9] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.105, -1.464, -1.338, 0.951, 0.307, -0.017, -0.186, 0.53, -0.827, -0.245, 0.79, 0.561)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.053, 0.016, 0.331, 0.924, -0.194, -0.727, 0.38, 0.571, 0.601, -0.048, 0.798)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.326, -0.273, -0.259, 0.268, 0.931, 0.248, -0.962, 0.274, 0.009, -0.059, -0.241, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.309, 0.066, 0.492, 0.87, -0.492, -0.041, 0.487, 0.869, -0.082, 0.075, 0.051, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.93, -0.171, -0.514, 0.617, -0.787, -0.015, 0.619, 0.497, -0.608, 0.486, 0.366, 0.794)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.153, 0.473, 0.221, 0.907, -0.422, -0.007, 0.422, 0.907, 0.017, -0.001, -0.018, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.004, -0.079, 0.031, 0.974, 0.214, -0.069, -0.113, 0.732, 0.672, 0.194, -0.647, 0.738)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.009, -0.126, -0.016, 0.992, -0.073, -0.106, 0.126, 0.724, 0.678, 0.027, -0.686, 0.727)},
	},
	[0.917] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.106, -1.478, -1.329, 0.951, 0.308, -0.015, -0.185, 0.531, -0.827, -0.246, 0.789, 0.562)},
		["Head"] = {["CFrame"] = CFrame.new(-0.05, -0.054, 0.016, 0.332, 0.924, -0.191, -0.733, 0.38, 0.564, 0.594, -0.047, 0.803)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.329, -0.278, -0.257, 0.275, 0.929, 0.247, -0.96, 0.281, 0.009, -0.061, -0.24, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.308, 0.054, 0.491, 0.87, -0.492, -0.043, 0.488, 0.869, -0.08, 0.077, 0.049, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.934, -0.186, -0.518, 0.62, -0.784, -0.019, 0.616, 0.502, -0.607, 0.485, 0.365, 0.795)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.151, 0.458, 0.221, 0.908, -0.419, -0.006, 0.419, 0.908, 0.015, -0.001, -0.016, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.003, -0.065, 0.025, 0.979, 0.195, -0.058, -0.099, 0.708, 0.7, 0.177, -0.679, 0.712)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.007, -0.104, -0.013, 0.995, -0.042, -0.093, 0.096, 0.702, 0.706, 0.036, -0.711, 0.702)},
	},
	[0.933] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.107, -1.49, -1.32, 0.951, 0.308, -0.013, -0.184, 0.532, -0.826, -0.247, 0.789, 0.563)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.054, 0.016, 0.333, 0.924, -0.189, -0.738, 0.38, 0.558, 0.587, -0.046, 0.808)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.331, -0.282, -0.255, 0.281, 0.927, 0.247, -0.958, 0.288, 0.008, -0.063, -0.239, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.307, 0.042, 0.491, 0.869, -0.492, -0.045, 0.488, 0.869, -0.079, 0.078, 0.046, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.938, -0.199, -0.521, 0.623, -0.782, -0.022, 0.614, 0.506, -0.606, 0.485, 0.364, 0.795)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.149, 0.444, 0.22, 0.909, -0.416, -0.005, 0.416, 0.909, 0.013, -0.001, -0.014, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.002, -0.053, 0.021, 0.983, 0.177, -0.049, -0.087, 0.684, 0.724, 0.162, -0.707, 0.688)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.006, -0.084, -0.01, 0.997, -0.015, -0.081, 0.07, 0.681, 0.729, 0.044, -0.733, 0.679)},
	},
	[0.95] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.108, -1.5, -1.313, 0.951, 0.308, -0.012, -0.183, 0.533, -0.826, -0.248, 0.788, 0.563)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.054, 0.016, 0.334, 0.924, -0.187, -0.742, 0.38, 0.552, 0.581, -0.046, 0.813)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.333, -0.287, -0.254, 0.287, 0.926, 0.246, -0.956, 0.294, 0.008, -0.065, -0.238, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.307, 0.032, 0.49, 0.869, -0.492, -0.047, 0.488, 0.869, -0.078, 0.079, 0.044, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.942, -0.211, -0.524, 0.625, -0.78, -0.025, 0.612, 0.51, -0.605, 0.484, 0.363, 0.796)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.147, 0.432, 0.219, 0.911, -0.413, -0.005, 0.413, 0.911, 0.012, -0.001, -0.013, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.002, -0.042, 0.016, 0.986, 0.16, -0.042, -0.076, 0.663, 0.745, 0.147, -0.732, 0.666)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.004, -0.067, -0.008, 0.998, 0.009, -0.069, 0.046, 0.66, 0.75, 0.052, -0.751, 0.658)},
	},
	[0.967] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.109, -1.51, -1.306, 0.951, 0.308, -0.01, -0.182, 0.534, -0.826, -0.249, 0.787, 0.564)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.335, 0.924, -0.185, -0.746, 0.38, 0.547, 0.575, -0.045, 0.817)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.335, -0.29, -0.252, 0.292, 0.924, 0.246, -0.954, 0.299, 0.008, -0.066, -0.237, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.306, 0.023, 0.49, 0.869, -0.492, -0.049, 0.488, 0.869, -0.077, 0.081, 0.043, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.945, -0.221, -0.527, 0.627, -0.778, -0.027, 0.61, 0.513, -0.604, 0.484, 0.362, 0.797)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.146, 0.421, 0.219, 0.912, -0.411, -0.004, 0.411, 0.912, 0.01, -0.001, -0.011, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.032, 0.012, 0.989, 0.145, -0.036, -0.067, 0.643, 0.763, 0.134, -0.752, 0.645)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.003, -0.051, -0.006, 0.998, 0.03, -0.058, 0.026, 0.641, 0.767, 0.06, -0.767, 0.639)},
	},
	[0.983] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.11, -1.518, -1.3, 0.951, 0.308, -0.009, -0.181, 0.534, -0.826, -0.25, 0.787, 0.564)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.336, 0.924, -0.183, -0.749, 0.38, 0.542, 0.571, -0.045, 0.82)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.336, -0.293, -0.251, 0.296, 0.923, 0.245, -0.953, 0.304, 0.008, -0.068, -0.236, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.306, 0.015, 0.489, 0.869, -0.493, -0.051, 0.488, 0.869, -0.076, 0.081, 0.041, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.947, -0.23, -0.529, 0.629, -0.777, -0.029, 0.609, 0.516, -0.603, 0.483, 0.361, 0.797)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.145, 0.411, 0.218, 0.913, -0.409, -0.004, 0.409, 0.913, 0.009, -0, -0.01, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.023, 0.009, 0.991, 0.132, -0.03, -0.059, 0.625, 0.778, 0.122, -0.769, 0.627)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.003, -0.038, -0.005, 0.998, 0.047, -0.048, 0.008, 0.624, 0.781, 0.067, -0.78, 0.622)},
	},
	[1] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.111, -1.525, -1.295, 0.951, 0.308, -0.008, -0.181, 0.535, -0.825, -0.25, 0.786, 0.565)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.336, 0.924, -0.182, -0.752, 0.38, 0.539, 0.567, -0.044, 0.823)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.337, -0.296, -0.25, 0.3, 0.922, 0.245, -0.952, 0.307, 0.007, -0.069, -0.235, 0.969)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.305, 0.008, 0.489, 0.869, -0.493, -0.052, 0.489, 0.869, -0.075, 0.082, 0.04, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.95, -0.238, -0.531, 0.631, -0.775, -0.031, 0.608, 0.518, -0.602, 0.483, 0.361, 0.798)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.144, 0.403, 0.218, 0.913, -0.407, -0.003, 0.407, 0.913, 0.008, -0, -0.009, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0.001, -0.016, 0.006, 0.992, 0.121, -0.026, -0.053, 0.61, 0.791, 0.112, -0.783, 0.612)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.002, -0.026, -0.003, 0.997, 0.062, -0.039, -0.007, 0.609, 0.793, 0.073, -0.791, 0.608)},
	},
	[1.017] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.111, -1.531, -1.291, 0.951, 0.309, -0.007, -0.18, 0.536, -0.825, -0.251, 0.786, 0.565)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.055, 0.016, 0.337, 0.924, -0.181, -0.754, 0.38, 0.535, 0.563, -0.044, 0.825)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.338, -0.298, -0.249, 0.303, 0.921, 0.245, -0.951, 0.311, 0.007, -0.07, -0.235, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.305, 0.003, 0.488, 0.869, -0.493, -0.053, 0.489, 0.869, -0.074, 0.083, 0.039, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.952, -0.244, -0.533, 0.632, -0.774, -0.032, 0.607, 0.52, -0.601, 0.482, 0.36, 0.798)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.143, 0.397, 0.218, 0.914, -0.406, -0.003, 0.406, 0.914, 0.007, -0, -0.008, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.01, 0.004, 0.993, 0.112, -0.023, -0.048, 0.597, 0.801, 0.104, -0.794, 0.598)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.001, -0.017, -0.002, 0.997, 0.074, -0.032, -0.019, 0.597, 0.802, 0.079, -0.799, 0.596)},
	},
	[1.033] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.112, -1.535, -1.288, 0.951, 0.309, -0.007, -0.18, 0.536, -0.825, -0.251, 0.786, 0.565)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.016, 0.337, 0.924, -0.18, -0.756, 0.38, 0.533, 0.561, -0.044, 0.827)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.339, -0.3, -0.248, 0.305, 0.92, 0.245, -0.95, 0.313, 0.007, -0.07, -0.234, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.305, -0.001, 0.488, 0.868, -0.493, -0.054, 0.489, 0.869, -0.074, 0.083, 0.038, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.953, -0.249, -0.534, 0.633, -0.773, -0.033, 0.606, 0.522, -0.601, 0.482, 0.36, 0.799)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.142, 0.392, 0.217, 0.914, -0.405, -0.003, 0.405, 0.914, 0.007, -0, -0.007, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.006, 0.002, 0.994, 0.105, -0.021, -0.045, 0.587, 0.808, 0.097, -0.803, 0.588)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0.001, -0.009, -0.001, 0.996, 0.084, -0.026, -0.028, 0.587, 0.809, 0.083, -0.806, 0.587)},
	},
	[1.05] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.112, -1.538, -1.286, 0.951, 0.309, -0.006, -0.18, 0.536, -0.825, -0.251, 0.786, 0.565)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.016, 0.337, 0.924, -0.179, -0.757, 0.38, 0.531, 0.559, -0.044, 0.828)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.34, -0.301, -0.248, 0.307, 0.92, 0.244, -0.949, 0.315, 0.007, -0.071, -0.234, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.305, -0.005, 0.488, 0.868, -0.493, -0.055, 0.489, 0.869, -0.074, 0.084, 0.037, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.954, -0.252, -0.535, 0.634, -0.773, -0.034, 0.605, 0.523, -0.6, 0.482, 0.36, 0.799)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.142, 0.388, 0.217, 0.915, -0.404, -0.002, 0.404, 0.915, 0.006, -0, -0.007, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.003, 0.001, 0.995, 0.1, -0.019, -0.042, 0.58, 0.814, 0.092, -0.809, 0.581)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0, -0.004, -0.001, 0.996, 0.09, -0.022, -0.035, 0.579, 0.814, 0.086, -0.81, 0.58)},
	},
	[1.067] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.112, -1.54, -1.285, 0.951, 0.309, -0.006, -0.179, 0.536, -0.825, -0.251, 0.786, 0.566)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.016, 0.338, 0.924, -0.179, -0.758, 0.38, 0.53, 0.558, -0.043, 0.829)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.34, -0.302, -0.247, 0.308, 0.92, 0.244, -0.949, 0.316, 0.007, -0.071, -0.234, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.304, -0.006, 0.488, 0.868, -0.493, -0.055, 0.489, 0.869, -0.073, 0.084, 0.037, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.955, -0.255, -0.536, 0.634, -0.773, -0.035, 0.605, 0.523, -0.6, 0.482, 0.36, 0.799)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.142, 0.386, 0.217, 0.915, -0.403, -0.002, 0.403, 0.915, 0.006, -0, -0.006, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, -0.001, 0, 0.995, 0.097, -0.018, -0.041, 0.575, 0.817, 0.089, -0.812, 0.576)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(-0, -0.001, -0, 0.995, 0.094, -0.019, -0.039, 0.575, 0.817, 0.088, -0.813, 0.576)},
	},
	[1.083] = {
		["Torso"] = {["CFrame"] = CFrame.new(-0.112, -1.541, -1.284, 0.951, 0.309, -0.006, -0.179, 0.536, -0.825, -0.251, 0.785, 0.566)},
		["Head"] = {["CFrame"] = CFrame.new(-0.051, -0.056, 0.017, 0.338, 0.924, -0.179, -0.758, 0.38, 0.53, 0.558, -0.043, 0.829)},
		["Left Arm"] = {["CFrame"] = CFrame.new(-0.34, -0.302, -0.247, 0.308, 0.919, 0.244, -0.949, 0.316, 0.007, -0.071, -0.234, 0.97)},
		["Left Leg"] = {["CFrame"] = CFrame.new(-0.304, -0.007, 0.488, 0.868, -0.493, -0.055, 0.489, 0.869, -0.073, 0.084, 0.037, 0.996)},
		["Right Arm"] = {["CFrame"] = CFrame.new(0.955, -0.255, -0.536, 0.634, -0.772, -0.035, 0.605, 0.524, -0.6, 0.482, 0.359, 0.799)},
		["Right Leg"] = {["CFrame"] = CFrame.new(-0.142, 0.385, 0.217, 0.915, -0.403, -0.002, 0.403, 0.915, 0.006, -0, -0.006, 1)},
		["M6DLowerL"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.995, 0.095, -0.018, -0.04, 0.574, 0.818, 0.089, -0.814, 0.575)},
		["M6DLowerR"] = {["CFrame"] = CFrame.new(0, 0, 0, 0.995, 0.095, -0.018, -0.04, 0.574, 0.818, 0.089, -0.814, 0.575)},
		["M6DRod"] = {["CFrame"] = CFrame.new(0, -0, 0, 0.997, 0.01, 0.076, 0.017, 0.939, -0.343, -0.075, 0.344, 0.936)},
	},
}

PlayAnimation("Sex21", Sex21)
