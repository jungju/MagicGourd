print("MagicGourd client started")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local shared = ReplicatedStorage:WaitForChild("Shared")
local dialogueEvent = shared:WaitForChild("DialogueEvent")
local effectEvent = shared:WaitForChild("StoryEffectEvent")
local endingChoiceEvent = shared:WaitForChild("EndingChoiceEvent")
local endingChoiceResponseEvent = shared:WaitForChild("EndingChoiceResponseEvent")

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

local endingFrame = Instance.new("Frame")
endingFrame.Name = "EndingChoicePanel"
endingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
endingFrame.Position = UDim2.fromScale(0.5, 0.53)
endingFrame.Size = UDim2.fromOffset(560, 310)
endingFrame.BackgroundColor3 = Color3.fromRGB(28, 18, 12)
endingFrame.BackgroundTransparency = 0.08
endingFrame.BorderSizePixel = 0
endingFrame.Visible = false
endingFrame.ZIndex = 10
endingFrame.Parent = screenGui

local endingCorner = Instance.new("UICorner")
endingCorner.CornerRadius = UDim.new(0, 18)
endingCorner.Parent = endingFrame

local endingStroke = Instance.new("UIStroke")
endingStroke.Color = Color3.fromRGB(227, 188, 96)
endingStroke.Thickness = 2
endingStroke.Parent = endingFrame

local endingTitle = Instance.new("TextLabel")
endingTitle.BackgroundTransparency = 1
endingTitle.Position = UDim2.fromOffset(20, 18)
endingTitle.Size = UDim2.new(1, -40, 0, 34)
endingTitle.Font = Enum.Font.GothamBold
endingTitle.TextColor3 = Color3.fromRGB(255, 239, 204)
endingTitle.TextScaled = true
endingTitle.Text = "The Valley Waits"
endingTitle.ZIndex = 11
endingTitle.Parent = endingFrame

local endingBody = Instance.new("TextLabel")
endingBody.BackgroundTransparency = 1
endingBody.Position = UDim2.fromOffset(20, 58)
endingBody.Size = UDim2.new(1, -40, 0, 58)
endingBody.Font = Enum.Font.Gotham
endingBody.TextColor3 = Color3.fromRGB(235, 226, 210)
endingBody.TextWrapped = true
endingBody.TextYAlignment = Enum.TextYAlignment.Top
endingBody.TextScaled = true
endingBody.Text = "Choose what kind of harvest the valley should protect."
endingBody.ZIndex = 11
endingBody.Parent = endingFrame

local endingStatus = Instance.new("TextLabel")
endingStatus.BackgroundTransparency = 1
endingStatus.Position = UDim2.fromOffset(20, 118)
endingStatus.Size = UDim2.new(1, -40, 0, 18)
endingStatus.Font = Enum.Font.GothamMedium
endingStatus.TextColor3 = Color3.fromRGB(194, 180, 158)
endingStatus.TextScaled = true
endingStatus.Text = "Choose once. Your ending will shape the village mood."
endingStatus.ZIndex = 11
endingStatus.Parent = endingFrame

local choiceButtons = {}

local function createChoiceButton(name, position, strokeColor)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Position = position
	button.Size = UDim2.fromOffset(244, 128)
	button.AutoButtonColor = true
	button.BackgroundColor3 = Color3.fromRGB(46, 30, 22)
	button.BorderSizePixel = 0
	button.Text = ""
	button.ZIndex = 11
	button.Parent = endingFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = strokeColor
	stroke.Thickness = 2
	stroke.Parent = button

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(14, 12)
	title.Size = UDim2.new(1, -28, 0, 30)
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.fromRGB(255, 239, 204)
	title.TextWrapped = true
	title.TextScaled = true
	title.ZIndex = 12
	title.Parent = button

	local body = Instance.new("TextLabel")
	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.Position = UDim2.fromOffset(14, 46)
	body.Size = UDim2.new(1, -28, 1, -58)
	body.Font = Enum.Font.Gotham
	body.TextColor3 = Color3.fromRGB(231, 222, 208)
	body.TextWrapped = true
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.TextScaled = true
	body.ZIndex = 12
	body.Parent = button

	button:SetAttribute("ChoiceId", name:lower())
	choiceButtons[#choiceButtons + 1] = button
	return button
end

local restorationButton = createChoiceButton("Restoration", UDim2.fromOffset(20, 148), Color3.fromRGB(142, 220, 116))
local tributeButton = createChoiceButton("Tribute", UDim2.fromOffset(296, 148), Color3.fromRGB(226, 117, 94))

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
local endingChoiceOpen = false
local endingChoiceLocked = false

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
	hintLabel.Text = player:GetAttribute("QuestHint") or "Watch the village signs for story changes."
	formatStats()
end

local function setChoiceButtonState(button, enabled)
	button.Active = enabled
	button.AutoButtonColor = enabled
	button.BackgroundTransparency = enabled and 0 or 0.25
end

local function closeEndingChoice()
	endingChoiceOpen = false
	endingChoiceLocked = false
	endingFrame.Visible = false
	for _, button in ipairs(choiceButtons) do
		setChoiceButtonState(button, true)
	end
	endingStatus.Text = "Choose once. Your ending will shape the village mood."
end

local function openEndingChoice(payload)
	endingChoiceOpen = true
	endingChoiceLocked = false
	endingFrame.Visible = true
	endingTitle.Text = payload.title or "The Valley Waits"
	endingBody.Text = payload.body or "Choose what kind of harvest the valley should protect."
	endingStatus.Text = "Choose once. Your ending will shape the village mood."

	local choices = payload.choices or {}
	local mappedButtons = { restorationButton, tributeButton }
	for index, button in ipairs(mappedButtons) do
		local choice = choices[index]
		button.Visible = choice ~= nil
		if choice then
			button:SetAttribute("ChoiceId", choice.id)
			button.Title.Text = choice.title or "Choice"
			button.Body.Text = choice.body or ""
			setChoiceButtonState(button, true)
		end
	end
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

for _, button in ipairs(choiceButtons) do
	button.MouseButton1Click:Connect(function()
		if not endingChoiceOpen or endingChoiceLocked then
			return
		end
		endingChoiceLocked = true
		for _, otherButton in ipairs(choiceButtons) do
			setChoiceButtonState(otherButton, false)
		end
		endingStatus.Text = "The valley is listening..."
		endingChoiceResponseEvent:FireServer(button:GetAttribute("ChoiceId"))
		task.delay(0.45, function()
			if endingChoiceOpen then
				endingFrame.Visible = false
			end
		end)
	end)
end

for _, attributeName in ipairs({ "QuestTitle", "QuestObjective", "QuestHint", "Seeds", "Gourds", "Herbs", "Coins", "BlessedSeeds", "BlessedGourds" }) do
	player:GetAttributeChangedSignal(attributeName):Connect(refreshQuest)
end

player:GetAttributeChangedSignal("EndingName"):Connect(function()
	if (player:GetAttribute("EndingName") or "Unwritten") ~= "Unwritten" then
		closeEndingChoice()
	end
end)

refreshQuest()
dialogueEvent.OnClientEvent:Connect(showDialogue)
effectEvent.OnClientEvent:Connect(function(payload)
	showBanner(payload)
	pulseFlash(payload)
end)
endingChoiceEvent.OnClientEvent:Connect(openEndingChoice)