print("MagicGourd arcade client started")

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local shared = ReplicatedStorage:WaitForChild("Shared")
local ArcadeConfig = require(shared:WaitForChild("ArcadeConfig"))

local healSwallowRemote = shared:WaitForChild(ArcadeConfig.RemoteNames.HealSwallow)
local useSeedRemote = shared:WaitForChild(ArcadeConfig.RemoteNames.UseSeed)
local hitPumpkinRemote = shared:WaitForChild(ArcadeConfig.RemoteNames.HitPumpkin)
local feedbackRemote = shared:WaitForChild(ArcadeConfig.RemoteNames.Feedback)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MagicGourdArcadeHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local rootFrame = Instance.new("Frame")
rootFrame.Name = "HUD"
rootFrame.AnchorPoint = Vector2.new(0, 0)
rootFrame.Position = UDim2.fromOffset(18, 18)
rootFrame.Size = UDim2.fromOffset(360, 280)
rootFrame.BackgroundColor3 = Color3.fromRGB(26, 20, 15)
rootFrame.BackgroundTransparency = 0.18
rootFrame.BorderSizePixel = 0
rootFrame.Parent = screenGui

local rootCorner = Instance.new("UICorner")
rootCorner.CornerRadius = UDim.new(0, 16)
rootCorner.Parent = rootFrame

local rootStroke = Instance.new("UIStroke")
rootStroke.Color = Color3.fromRGB(230, 196, 117)
rootStroke.Thickness = 2
rootStroke.Parent = rootFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.fromOffset(14, 12)
titleLabel.Size = UDim2.new(1, -28, 0, 28)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Heungbu Arcade Loop"
titleLabel.TextColor3 = Color3.fromRGB(252, 241, 218)
titleLabel.TextScaled = true
titleLabel.Parent = rootFrame

local resourcesLabel = Instance.new("TextLabel")
resourcesLabel.BackgroundTransparency = 1
resourcesLabel.Position = UDim2.fromOffset(14, 46)
resourcesLabel.Size = UDim2.new(1, -28, 0, 24)
resourcesLabel.Font = Enum.Font.GothamBold
resourcesLabel.TextColor3 = Color3.fromRGB(242, 232, 213)
resourcesLabel.TextWrapped = true
resourcesLabel.TextScaled = true
resourcesLabel.Parent = rootFrame

local nextLabel = Instance.new("TextLabel")
nextLabel.BackgroundTransparency = 1
nextLabel.Position = UDim2.fromOffset(14, 74)
nextLabel.Size = UDim2.new(1, -28, 0, 42)
nextLabel.Font = Enum.Font.GothamBold
nextLabel.TextColor3 = Color3.fromRGB(212, 234, 192)
nextLabel.TextWrapped = true
nextLabel.TextXAlignment = Enum.TextXAlignment.Left
nextLabel.TextYAlignment = Enum.TextYAlignment.Top
nextLabel.TextScaled = true
nextLabel.Parent = rootFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.fromOffset(14, 118)
statusLabel.Size = UDim2.new(1, -28, 0, 18)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextColor3 = Color3.fromRGB(245, 215, 152)
statusLabel.TextScaled = true
statusLabel.Parent = rootFrame

local upgradesFrame = Instance.new("Frame")
upgradesFrame.BackgroundTransparency = 1
upgradesFrame.Position = UDim2.fromOffset(14, 144)
upgradesFrame.Size = UDim2.new(1, -28, 0, 94)
upgradesFrame.Parent = rootFrame

local upgradesTitle = Instance.new("TextLabel")
upgradesTitle.BackgroundTransparency = 1
upgradesTitle.Position = UDim2.fromOffset(0, 0)
upgradesTitle.Size = UDim2.new(1, 0, 0, 18)
upgradesTitle.Font = Enum.Font.GothamBold
upgradesTitle.Text = "Plaza Upgrades"
upgradesTitle.TextColor3 = Color3.fromRGB(229, 197, 118)
upgradesTitle.TextScaled = true
upgradesTitle.Parent = upgradesFrame

local footworkLabel = Instance.new("TextLabel")
footworkLabel.BackgroundTransparency = 1
footworkLabel.Position = UDim2.fromOffset(0, 24)
footworkLabel.Size = UDim2.new(1, 0, 0, 20)
footworkLabel.Font = Enum.Font.Gotham
footworkLabel.TextColor3 = Color3.fromRGB(220, 233, 241)
footworkLabel.TextScaled = true
footworkLabel.Parent = upgradesFrame

local handsLabel = Instance.new("TextLabel")
handsLabel.BackgroundTransparency = 1
handsLabel.Position = UDim2.fromOffset(0, 46)
handsLabel.Size = UDim2.new(1, 0, 0, 20)
handsLabel.Font = Enum.Font.Gotham
handsLabel.TextColor3 = Color3.fromRGB(240, 222, 184)
handsLabel.TextScaled = true
handsLabel.Parent = upgradesFrame

local blessingLabel = Instance.new("TextLabel")
blessingLabel.BackgroundTransparency = 1
blessingLabel.Position = UDim2.fromOffset(0, 68)
blessingLabel.Size = UDim2.new(1, 0, 0, 20)
blessingLabel.Font = Enum.Font.Gotham
blessingLabel.TextColor3 = Color3.fromRGB(214, 244, 202)
blessingLabel.TextScaled = true
blessingLabel.Parent = upgradesFrame

local tipLabel = Instance.new("TextLabel")
tipLabel.BackgroundTransparency = 1
tipLabel.Position = UDim2.fromOffset(14, 244)
tipLabel.Size = UDim2.new(1, -28, 0, 24)
tipLabel.Font = Enum.Font.Gotham
tipLabel.Text = "Loop: heal -> plant -> break -> buy."
tipLabel.TextColor3 = Color3.fromRGB(214, 206, 190)
tipLabel.TextWrapped = true
tipLabel.TextScaled = true
tipLabel.Parent = rootFrame

local feedbackLabel = Instance.new("TextLabel")
feedbackLabel.Name = "FeedbackLabel"
feedbackLabel.AnchorPoint = Vector2.new(0.5, 0)
feedbackLabel.Position = UDim2.new(0.5, 0, 0, 18)
feedbackLabel.Size = UDim2.fromOffset(360, 44)
feedbackLabel.BackgroundColor3 = Color3.fromRGB(33, 28, 23)
feedbackLabel.BackgroundTransparency = 0.2
feedbackLabel.BorderSizePixel = 0
feedbackLabel.Font = Enum.Font.GothamBold
feedbackLabel.Text = ""
feedbackLabel.TextColor3 = Color3.fromRGB(252, 241, 218)
feedbackLabel.TextScaled = true
feedbackLabel.Visible = false
feedbackLabel.Parent = screenGui

local feedbackCorner = Instance.new("UICorner")
feedbackCorner.CornerRadius = UDim.new(0, 14)
feedbackCorner.Parent = feedbackLabel

local feedbackStroke = Instance.new("UIStroke")
feedbackStroke.Thickness = 2
feedbackStroke.Color = Color3.fromRGB(229, 196, 124)
feedbackStroke.Parent = feedbackLabel

local useSeedButton = Instance.new("TextButton")
useSeedButton.Name = "UseSeedButton"
useSeedButton.AnchorPoint = Vector2.new(0.5, 1)
useSeedButton.Position = UDim2.new(0.5, 0, 1, -24)
useSeedButton.Size = UDim2.fromOffset(260, 64)
useSeedButton.BackgroundColor3 = Color3.fromRGB(97, 162, 88)
useSeedButton.BorderSizePixel = 0
useSeedButton.Font = Enum.Font.GothamBold
useSeedButton.TextColor3 = Color3.fromRGB(252, 247, 239)
useSeedButton.TextWrapped = true
useSeedButton.TextScaled = true
useSeedButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 16)
buttonCorner.Parent = useSeedButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(235, 219, 177)
buttonStroke.Thickness = 2
buttonStroke.Parent = useSeedButton

local playerAttributes = ArcadeConfig.Attributes.Player
local interactionAttributes = ArcadeConfig.Attributes.Interaction
local upgradeDefinitions = ArcadeConfig.Upgrades.Definitions
local upgradeCosts = ArcadeConfig.Upgrades.Costs

local feedbackColors = {
	good = {
		background = Color3.fromRGB(52, 98, 58),
		stroke = Color3.fromRGB(170, 234, 164),
		text = Color3.fromRGB(243, 252, 231),
	},
	warn = {
		background = Color3.fromRGB(112, 73, 45),
		stroke = Color3.fromRGB(244, 193, 121),
		text = Color3.fromRGB(255, 240, 214),
	},
	info = {
		background = Color3.fromRGB(44, 65, 92),
		stroke = Color3.fromRGB(155, 212, 241),
		text = Color3.fromRGB(239, 248, 255),
	},
}

local feedbackToken = 0

local function getAttribute(name)
	return player:GetAttribute(name)
end

local function getFeedbackColors(tone)
	return feedbackColors[tone] or feedbackColors.info
end

local function getAffordableUpgradeIds(money)
	local affordable = {}

	for _, upgradeId in ipairs(ArcadeConfig.Upgrades.Order) do
		local definition = upgradeDefinitions[upgradeId]
		local currentLevel = getAttribute(definition.AttributeName) or 0
		local nextCost = upgradeCosts[currentLevel + 1]
		if nextCost and money >= nextCost then
			table.insert(affordable, upgradeId)
		end
	end

	return affordable
end

local function formatDelta(value)
	if math.abs(value - math.floor(value)) < 0.001 then
		return tostring(math.floor(value))
	end

	return string.format("%.2f", value)
end

local function getUpgradeBenefitText(upgradeId, currentLevel)
	local values = upgradeDefinitions[upgradeId].Values
	local currentValue = values[currentLevel + 1]
	local nextValue = values[currentLevel + 2]
	if not nextValue then
		return "MAX"
	end

	if upgradeId == "MoveSpeed" then
		return string.format("%s -> %s speed", formatDelta(currentValue), formatDelta(nextValue))
	elseif upgradeId == "AttackSpeed" then
		return string.format("%ss -> %ss hit gap", formatDelta(currentValue), formatDelta(nextValue))
	elseif upgradeId == "SeedMultiplier" then
		return string.format("%s -> %s seeds/heal", formatDelta(currentValue), formatDelta(nextValue))
	end

	return tostring(nextValue)
end

local function formatUpgradeRow(upgradeId, money)
	local definition = upgradeDefinitions[upgradeId]
	local currentLevel = getAttribute(definition.AttributeName) or 0
	local nextLevel = currentLevel + 1
	local nextCost = upgradeCosts[nextLevel]
	local baseColor = upgradeId == "MoveSpeed" and Color3.fromRGB(220, 233, 241)
		or upgradeId == "AttackSpeed" and Color3.fromRGB(240, 222, 184)
		or Color3.fromRGB(214, 244, 202)

	if not nextCost then
		return string.format("%s Lv.%d | MAX", definition.DisplayName, currentLevel), Color3.fromRGB(171, 190, 160)
	end

	local benefitText = getUpgradeBenefitText(upgradeId, currentLevel)
	if money >= nextCost then
		return string.format("%s Lv.%d -> Lv.%d | %s | Buy now", definition.DisplayName, currentLevel, nextLevel, benefitText), baseColor
	end

	local missing = nextCost - money
	return string.format(
		"%s Lv.%d -> Lv.%d | %s | Need %d more",
		definition.DisplayName,
		currentLevel,
		nextLevel,
		benefitText,
		missing
	), Color3.fromRGB(baseColor.R * 255 * 0.78, baseColor.G * 255 * 0.78, baseColor.B * 255 * 0.78)
end

local function getPrimaryGuidance(playerState)
	if playerState.isSlowed then
		return "Next: Recover from the goblin slow before pushing deeper.", Color3.fromRGB(245, 188, 150)
	end

	if playerState.seeds > 0 then
		return "Next: Plant a pumpkin nearby, then break it for money.", Color3.fromRGB(220, 235, 196)
	end

	if #playerState.affordableUpgradeIds > 0 then
		return "Next: Return to Central Plaza - you can buy an upgrade.", Color3.fromRGB(240, 224, 163)
	end

	if playerState.seeds <= 0 then
		return "Next: Heal a swallow in Heungbu Village for seeds.", Color3.fromRGB(206, 232, 190)
	end

	return "Next: Keep the loop moving and buy when the pace boost matters.", Color3.fromRGB(240, 224, 163)
end

local function getStatusSummary(playerState)
	if playerState.isSlowed then
		return "Status: Goblin slow active", Color3.fromRGB(240, 149, 112)
	end

	if playerState.seeds > 0 then
		return "Status: Seed-ready", Color3.fromRGB(196, 233, 170)
	end

	if #playerState.affordableUpgradeIds > 0 then
		return "Status: Upgrade available", Color3.fromRGB(245, 215, 152)
	end

	return "Status: Safe to farm", Color3.fromRGB(245, 215, 152)
end

local function getSupportTip(playerState)
	if playerState.isSlowed then
		return "Loop paused: recover, then restart the chain."
	end

	if #playerState.affordableUpgradeIds > 0 and playerState.seeds <= 0 then
		return "Buy one upgrade, then return to Heungbu Village for fresh seeds."
	end

	if #playerState.affordableUpgradeIds > 0 then
		return "Plant first if you want, or cash out now for a faster next run."
	end

	return "Loop: heal -> plant -> break -> buy."
end

local function showFeedback(text, tone, detail)
	feedbackToken += 1
	local activeToken = feedbackToken
	local colors = getFeedbackColors(tone)

	if detail and detail ~= "" then
		feedbackLabel.Text = string.format("%s\n%s", text or "", detail)
	else
		feedbackLabel.Text = text or ""
	end
	feedbackLabel.BackgroundColor3 = colors.background
	feedbackLabel.TextColor3 = colors.text
	feedbackStroke.Color = colors.stroke
	feedbackLabel.Visible = text ~= nil and text ~= ""

	if not feedbackLabel.Visible then
		return
	end

	task.delay(2.2, function()
		if feedbackToken ~= activeToken then
			return
		end

		feedbackLabel.Visible = false
		feedbackLabel.Text = ""
	end)
end

local wasSlowed = getAttribute(playerAttributes.IsSlowed) or false

local function showWorldPopup(text, tone, worldPosition)
	if typeof(worldPosition) ~= "Vector3" or text == nil or text == "" then
		return
	end

	local colors = getFeedbackColors(tone)
	local popupPart = Instance.new("Part")
	popupPart.Name = "ArcadeFeedbackAnchor"
	popupPart.Anchored = true
	popupPart.CanCollide = false
	popupPart.CanTouch = false
	popupPart.CanQuery = false
	popupPart.Transparency = 1
	popupPart.Size = Vector3.new(0.2, 0.2, 0.2)
	popupPart.CFrame = CFrame.new(worldPosition + Vector3.new(0, 3.6, 0))
	popupPart.Parent = Workspace

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ArcadeFeedbackBillboard"
	billboard.Size = UDim2.fromOffset(170, 46)
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 110
	billboard.Parent = popupPart

	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(0.5, 0.5)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextStrokeTransparency = 0.4
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextColor3 = colors.text
	label.Text = text
	label.Parent = billboard

	local riseTween = TweenService:Create(
		popupPart,
		TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ CFrame = popupPart.CFrame + Vector3.new(0, 2.2, 0) }
	)
	local fadeTween = TweenService:Create(
		label,
		TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{ TextTransparency = 1, TextStrokeTransparency = 1 }
	)

	riseTween:Play()
	fadeTween:Play()
	fadeTween.Completed:Connect(function()
		popupPart:Destroy()
	end)
end

local function refreshHud()
	local seeds = getAttribute(playerAttributes.Seeds) or 0
	local money = getAttribute(playerAttributes.Money) or 0
	local isSlowed = getAttribute(playerAttributes.IsSlowed) or false
	local affordableUpgradeIds = getAffordableUpgradeIds(money)
	local playerState = {
		seeds = seeds,
		money = money,
		isSlowed = isSlowed,
		affordableUpgradeIds = affordableUpgradeIds,
	}

	resourcesLabel.Text = string.format("Seeds %d   |   Money %d", seeds, money)

	local nextText, nextColor = getPrimaryGuidance(playerState)
	nextLabel.Text = nextText
	nextLabel.TextColor3 = nextColor

	local statusText, statusColor = getStatusSummary(playerState)
	statusLabel.Text = statusText
	statusLabel.TextColor3 = statusColor

	local footworkText, footworkColor = formatUpgradeRow("MoveSpeed", money)
	footworkLabel.Text = footworkText
	footworkLabel.TextColor3 = footworkColor

	local handsText, handsColor = formatUpgradeRow("AttackSpeed", money)
	handsLabel.Text = handsText
	handsLabel.TextColor3 = handsColor

	local blessingText, blessingColor = formatUpgradeRow("SeedMultiplier", money)
	blessingLabel.Text = blessingText
	blessingLabel.TextColor3 = blessingColor

	tipLabel.Text = getSupportTip(playerState)

	useSeedButton.Active = seeds > 0
	useSeedButton.AutoButtonColor = seeds > 0
	useSeedButton.BackgroundColor3 = seeds > 0 and Color3.fromRGB(97, 162, 88) or Color3.fromRGB(88, 82, 78)
	useSeedButton.Text = seeds > 0 and string.format("Plant Pumpkin [Q]\nSpend 1 seed and grow your own pumpkin (%d ready)", seeds)
		or "Need Seeds\nHeal a swallow first"
end

local function useSeed()
	local seeds = getAttribute(playerAttributes.Seeds) or 0
	if seeds <= 0 then
		return
	end

	useSeedRemote:FireServer()
end

useSeedButton.MouseButton1Click:Connect(useSeed)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.Q then
		useSeed()
	end
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt, promptedPlayer)
	if promptedPlayer ~= player then
		return
	end

	local promptParent = prompt.Parent
	if not promptParent then
		return
	end

	local kind = promptParent:GetAttribute(interactionAttributes.Kind)
	local entityId = promptParent:GetAttribute(interactionAttributes.EntityId)
	if not entityId then
		return
	end

	if kind == "Swallow" then
		healSwallowRemote:FireServer(entityId)
	elseif kind == "Pumpkin" then
		hitPumpkinRemote:FireServer(entityId)
	end
end)

for _, attributeName in ipairs({
	playerAttributes.Seeds,
	playerAttributes.Money,
	playerAttributes.MoveSpeedLevel,
	playerAttributes.AttackSpeedLevel,
	playerAttributes.SeedMultiplierLevel,
	playerAttributes.IsSlowed,
}) do
	player:GetAttributeChangedSignal(attributeName):Connect(refreshHud)
end

player:GetAttributeChangedSignal(playerAttributes.IsSlowed):Connect(function()
	local isSlowed = getAttribute(playerAttributes.IsSlowed) or false
	if wasSlowed and not isSlowed then
		showFeedback("Slow faded.", "good", "You are back to full pace.")
	end
	wasSlowed = isSlowed
end)

feedbackRemote.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	showFeedback(payload.text, payload.tone, payload.detail)
	showWorldPopup(payload.worldText or payload.text, payload.tone, payload.worldPosition)
end)

refreshHud()
