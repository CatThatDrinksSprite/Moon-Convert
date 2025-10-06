local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
game:GetService("TextChatService").TextChannels.RBXGeneral:DisplaySystemMessage("<font color='rgb(111, 0, 222)'>thanks for using meow dances v1\nthis is basically kdv3 but not made by a zoophile\nbinds:\nq: boogie down\ne: drill\nr: rich dance</font>")
local Humanoid = Character:WaitForChild("Humanoid")

local RunService = game:GetService("RunService")

local CurrentAnimation = nil
local Running = false

Character.Animate.Enabled = false

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
