print("MagicGourd client started")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local shared = ReplicatedStorage:WaitForChild("Shared")
local dialogueEvent = shared:WaitForChild("DialogueEvent")
local effectEvent = shared:WaitForChild("StoryEffectEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MagicGourdHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local questFrame = Instance.new("Frame")
questFrame.Name = "QuestTracker"
questFrame.Position = UDim2.fromOffset(20, 20)
questFrame.Size = UDim2.fromOffset(420, 140)
questFrame.BackgroundColor3 = Color3.fromRGB(26, 18, 12)
questFrame.BackgroundTransparency = 0.2
questFrame.BorderSizePixel = 0
questFrame.Parent = screenGui

local questCorner = Instance.new("UICorner")
questCorner.CornerRadius = UDim.new(0, 14)
questCorner.Parent = questFrame

local questStroke = Instance.new("UIStroke")
questStroke.Color = Color3.fromRGB(227, 188, 96)
questStroke.Thickness = 2
questStroke.Parent = questFrame

local questTitle = Instance.new("TextLabel")
questTitle.BackgroundTransparency = 1
questTitle.Position = UDim2.fromOffset(12, 10)
questTitle.Size = UDim2.new(1, -24, 0, 30)
questTitle.Font = Enum.Font.GothamBold
questTitle.TextXAlignment = Enum.TextXAlignment.Left
questTitle.TextColor3 = Color3.fromRGB(255, 239, 204)
questTitle.TextScaled = true
questTitle.Text = "Village Rumor"
questTitle.Parent = questFrame

local questBody = Instance.new("TextLabel")
questBody.BackgroundTransparency = 1
questBody.Position = UDim2.fromOffset(12, 42)
questBody.Size = UDim2.new(1, -24, 0, 52)
questBody.Font = Enum.Font.Gotham
questBody.TextXAlignment = Enum.TextXAlignment.Left
questBody.TextYAlignment = Enum.TextYAlignment.Top
questBody.TextWrapped = true
questBody.TextColor3 = Color3.fromRGB(240, 231, 214)
questBody.TextScaled = true
questBody.Text = "Read the Story Stone or speak with Heungbu."
questBody.Parent = questFrame

local statsLabel = Instance.new("TextLabel")
statsLabel.BackgroundTransparency = 1
statsLabel.Position = UDim2.fromOffset(12, 98)
statsLabel.Size = UDim2.new(1, -24, 0, 20)
statsLabel.Font = Enum.Font.GothamMedium
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextColor3 = Color3.fromRGB(214, 201, 180)
statsLabel.TextScaled = true
statsLabel.Text = "Seeds 0 · Gourds 0 · Herbs 0 · Coins 0"
statsLabel.Parent = questFrame

local hintLabel = Instance.new("TextLabel")
hintLabel.BackgroundTransparency = 1
hintLabel.Position = UDim2.fromOffset(12, 118)
hintLabel.Size = UDim2.new(1, -24, 0, 14)
hintLabel.Font = Enum.Font.Gotham
hintLabel.TextXAlignment = Enum.TextXAlignment.Left
hintLabel.TextColor3 = Color3.fromRGB(180, 168, 148)
hintLabel.TextScaled = true
hintLabel.Text = "Watch the village signs for story changes."
hintLabel.Parent = questFrame

local dialogueFrame = Instance.new("Frame")
dialogueFrame.Name = "DialogueBox"
dialogueFrame.AnchorPoint = Vector2.new(0.5, 1)
dialogueFrame.Position = UDim2.new(0.5, 0, 1, -28)
dialogueFrame.Size = UDim2.fromOffset(620, 130)
dialogueFrame.BackgroundColor3 = Color3.fromRGB(22, 15, 10)
dialogueFrame.BackgroundTransparency = 0.18
dialogueFrame.BorderSizePixel = 0
dialogueFrame.Visible = false
dialogueFrame.Parent = screenGui

local dialogueCorner = Instance.new("UICorner")
dialogueCorner.CornerRadius = UDim.new(0, 16)
dialogueCorner.Parent = dialogueFrame

local dialogueStroke = Instance.new("UIStroke")
dialogueStroke.Color = Color3.fromRGB(111, 224, 128)
dialogueStroke.Thickness = 2
dialogueStroke.Parent = dialogueFrame

local speakerLabel = Instance.new("TextLabel")
speakerLabel.BackgroundTransparency = 1
speakerLabel.Position = UDim2.fromOffset(16, 10)
speakerLabel.Size = UDim2.new(1, -32, 0, 24)
speakerLabel.Font = Enum.Font.GothamBold
speakerLabel.TextXAlignment = Enum.TextXAlignment.Left
speakerLabel.TextColor3 = Color3.fromRGB(255, 236, 199)
speakerLabel.TextScaled = true
speakerLabel.Text = "Speaker"
speakerLabel.Parent = dialogueFrame

local bodyLabel = Instance.new("TextLabel")
bodyLabel.BackgroundTransparency = 1
bodyLabel.Position = UDim2.fromOffset(16, 38)
bodyLabel.Size = UDim2.new(1, -32, 1, -56)
bodyLabel.Font = Enum.Font.Gotham
bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
bodyLabel.TextWrapped = true
bodyLabel.TextColor3 = Color3.fromRGB(243, 236, 226)
bodyLabel.TextScaled = true
bodyLabel.Text = ""
bodyLabel.Parent = dialogueFrame

local eventBanner = Instance.new("Frame")
eventBanner.Name = "StoryBanner"
eventBanner.AnchorPoint = Vector2.new(0.5, 0)
eventBanner.Position = UDim2.new(0.5, 0, 0, -90)
eventBanner.Size = UDim2.fromOffset(460, 84)
eventBanner.BackgroundColor3 = Color3.fromRGB(36, 24, 14)
eventBanner.BackgroundTransparency = 0.1
eventBanner.BorderSizePixel = 0
eventBanner.Parent = screenGui

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 16)
bannerCorner.Parent = eventBanner

local bannerStroke = Instance.new("UIStroke")
bannerStroke.Color = Color3.fromRGB(245, 211, 94)
bannerStroke.Thickness = 2
bannerStroke.Parent = eventBanner

local bannerTitle = Instance.new("TextLabel")
bannerTitle.BackgroundTransparency = 1
bannerTitle.Position = UDim2.fromOffset(14, 8)
bannerTitle.Size = UDim2.new(1, -28, 0, 30)
bannerTitle.Font = Enum.Font.GothamBold
bannerTitle.TextColor3 = Color3.fromRGB(255, 240, 206)
bannerTitle.TextScaled = true
bannerTitle.Text = ""
bannerTitle.Parent = eventBanner

local bannerBody = Instance.new("TextLabel")
bannerBody.BackgroundTransparency = 1
bannerBody.Position = UDim2.fromOffset(14, 38)
bannerBody.Size = UDim2.new(1, -28, 0, 28)
bannerBody.Font = Enum.Font.Gotham
bannerBody.TextColor3 = Color3.fromRGB(241, 232, 216)
bannerBody.TextScaled = true
bannerBody.Text = ""
bannerBody.Parent = eventBanner

eventBanner.Visible = false

local flash = Instance.new("Frame")
flash.BackgroundColor3 = Color3.fromRGB(255, 236, 180)
flash.BackgroundTransparency = 1
flash.Size = UDim2.fromScale(1, 1)
flash.BorderSizePixel = 0
flash.Parent = screenGui

local activeDialogueToken = 0
local activeBannerToken = 0
local activeBannerPulseToken = 0

local kindStyles = {
	banner = {
		background = Color3.fromRGB(36, 24, 14),
		stroke = Color3.fromRGB(245, 211, 94),
		title = Color3.fromRGB(255, 240, 206),
		body = Color3.fromRGB(241, 232, 216),
		flash = Color3.fromRGB(255, 236, 180),
		flashTransparency = 0.45,
	},
	celebration = {
		background = Color3.fromRGB(56, 33, 14),
		stroke = Color3.fromRGB(250, 218, 120),
		title = Color3.fromRGB(255, 243, 214),
		body = Color3.fromRGB(255, 234, 196),
		flash = Color3.fromRGB(255, 232, 160),
		flashTransparency = 0.32,
	},
	blessing = {
		background = Color3.fromRGB(48, 34, 18),
		stroke = Color3.fromRGB(244, 222, 152),
		title = Color3.fromRGB(255, 245, 222),
		body = Color3.fromRGB(246, 236, 210),
		flash = Color3.fromRGB(255, 242, 196),
		flashTransparency = 0.38,
	},
	warning = {
		background = Color3.fromRGB(56, 23, 16),
		stroke = Color3.fromRGB(226, 117, 94),
		title = Color3.fromRGB(255, 224, 214),
		body = Color3.fromRGB(247, 219, 204),
		flash = Color3.fromRGB(255, 170, 150),
		flashTransparency = 0.4,
	},
	restoration = {
		background = Color3.fromRGB(27, 41, 19),
		stroke = Color3.fromRGB(142, 220, 116),
		title = Color3.fromRGB(232, 255, 222),
		body = Color3.fromRGB(214, 244, 204),
		flash = Color3.fromRGB(188, 255, 170),
		flashTransparency = 0.42,
	},
}

local function formatStats()
	local seeds = player:GetAttribute("Seeds") or 0
	local gourds = player:GetAttribute("Gourds") or 0
	local herbs = player:GetAttribute("Herbs") or 0
	local coins = player:GetAttribute("Coins") or 0
	local blessedSeeds = player:GetAttribute("BlessedSeeds") or 0
	local blessedGourds = player:GetAttribute("BlessedGourds") or 0
	statsLabel.Text = string.format("Seeds %d · Gourds %d · Blessed %d · Magic %d · Herbs %d · Coins %d", seeds, gourds, blessedSeeds, blessedGourds, herbs, coins)
end

local function refreshQuest()
	questTitle.Text = player:GetAttribute("QuestTitle") or "Village Rumor"
	questBody.Text = player:GetAttribute("QuestObjective") or "Help the village."
	formatStats()
end

local function showDialogue(payload)
	activeDialogueToken += 1
	local token = activeDialogueToken
	speakerLabel.Text = payload.speaker or "Village"
	dialogueStroke.Color = payload.accent or Color3.fromRGB(111, 224, 128)
	dialogueFrame.Visible = true
	dialogueFrame.BackgroundTransparency = 0.35
	TweenService:Create(dialogueFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.18 }):Play()
	bodyLabel.Text = table.concat(payload.lines or {}, "\n\n")
	task.delay(5.5, function()
		if activeDialogueToken ~= token then return end
		dialogueFrame.Visible = false
	end)
end

local function showBanner(payload)
	activeBannerToken += 1
	local token = activeBannerToken
	local style = kindStyles[payload.kind or "banner"] or kindStyles.banner
	bannerTitle.Text = payload.title or "Story Beat"
	bannerBody.Text = payload.body or ""
	eventBanner.BackgroundColor3 = style.background
	bannerStroke.Color = payload.color or style.stroke
	bannerTitle.TextColor3 = style.title
	bannerBody.TextColor3 = style.body
	eventBanner.Visible = true
	local targetPosition = UDim2.new(0.5, 0, 0, 18)
	local currentY = eventBanner.Position.Y.Offset
	eventBanner.Position = currentY > -70 and UDim2.new(0.5, 0, 0, math.min(currentY, 18)) or UDim2.new(0.5, 0, 0, -90)
	TweenService:Create(eventBanner, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPosition }):Play()
	local duration = payload.duration or ((payload.kind == "blessing" or payload.kind == "restoration") and 4.6 or 3.8)
	task.delay(duration, function()
		if activeBannerToken ~= token then return end
		local tween = TweenService:Create(eventBanner, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -90) })
		tween:Play()
		tween.Completed:Wait()
		if activeBannerToken == token then eventBanner.Visible = false end
	end)
end

local function doFlash(color, targetTransparency)
	flash.BackgroundColor3 = color or Color3.fromRGB(255, 236, 180)
	flash.BackgroundTransparency = 1
	TweenService:Create(flash, TweenInfo.new(0.12), { BackgroundTransparency = targetTransparency or 0.45 }):Play()
	task.delay(0.12, function()
		TweenService:Create(flash, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
	end)
end

local function pulseFlash(payload)
	activeBannerPulseToken += 1
	local token = activeBannerPulseToken
	local style = kindStyles[payload.kind or "banner"] or kindStyles.banner
	local pulses = math.max(payload.pulseCount or 1, 1)
	task.spawn(function()
		for index = 1, pulses do
			if activeBannerPulseToken ~= token then
				return
			end
			doFlash(payload.color or style.flash, style.flashTransparency)
			if index < pulses then
				task.wait(0.18)
			end
		end
	end)
end

for _, attributeName in ipairs({ "QuestTitle", "QuestObjective", "Seeds", "Gourds", "Herbs", "Coins", "BlessedSeeds", "BlessedGourds" }) do
	player:GetAttributeChangedSignal(attributeName):Connect(refreshQuest)
end

refreshQuest()
dialogueEvent.OnClientEvent:Connect(showDialogue)
effectEvent.OnClientEvent:Connect(function(payload)
	showBanner(payload)
	pulseFlash(payload)
end)