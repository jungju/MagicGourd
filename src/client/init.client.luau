print("MagicGourd arcade client started")

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

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
rootFrame.Size = UDim2.fromOffset(340, 250)
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
resourcesLabel.Size = UDim2.new(1, -28, 0, 48)
resourcesLabel.Font = Enum.Font.GothamBold
resourcesLabel.TextColor3 = Color3.fromRGB(242, 232, 213)
resourcesLabel.TextWrapped = true
resourcesLabel.TextScaled = true
resourcesLabel.Parent = rootFrame

local upgradesFrame = Instance.new("Frame")
upgradesFrame.BackgroundTransparency = 1
upgradesFrame.Position = UDim2.fromOffset(14, 96)
upgradesFrame.Size = UDim2.new(1, -28, 0, 88)
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
footworkLabel.Position = UDim2.fromOffset(0, 22)
footworkLabel.Size = UDim2.new(1, 0, 0, 18)
footworkLabel.Font = Enum.Font.Gotham
footworkLabel.TextColor3 = Color3.fromRGB(220, 233, 241)
footworkLabel.TextScaled = true
footworkLabel.Parent = upgradesFrame

local handsLabel = Instance.new("TextLabel")
handsLabel.BackgroundTransparency = 1
handsLabel.Position = UDim2.fromOffset(0, 42)
handsLabel.Size = UDim2.new(1, 0, 0, 18)
handsLabel.Font = Enum.Font.Gotham
handsLabel.TextColor3 = Color3.fromRGB(240, 222, 184)
handsLabel.TextScaled = true
handsLabel.Parent = upgradesFrame

local blessingLabel = Instance.new("TextLabel")
blessingLabel.BackgroundTransparency = 1
blessingLabel.Position = UDim2.fromOffset(0, 62)
blessingLabel.Size = UDim2.new(1, 0, 0, 18)
blessingLabel.Font = Enum.Font.Gotham
blessingLabel.TextColor3 = Color3.fromRGB(214, 244, 202)
blessingLabel.TextScaled = true
blessingLabel.Parent = upgradesFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.fromOffset(14, 184)
statusLabel.Size = UDim2.new(1, -28, 0, 18)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextColor3 = Color3.fromRGB(245, 215, 152)
statusLabel.TextScaled = true
statusLabel.Parent = rootFrame

local objectiveLabel = Instance.new("TextLabel")
objectiveLabel.BackgroundTransparency = 1
objectiveLabel.Position = UDim2.fromOffset(14, 204)
objectiveLabel.Size = UDim2.new(1, -28, 0, 18)
objectiveLabel.Font = Enum.Font.GothamBold
objectiveLabel.TextColor3 = Color3.fromRGB(206, 232, 190)
objectiveLabel.TextScaled = true
objectiveLabel.Parent = rootFrame

local tipLabel = Instance.new("TextLabel")
tipLabel.BackgroundTransparency = 1
tipLabel.Position = UDim2.fromOffset(14, 222)
tipLabel.Size = UDim2.new(1, -28, 0, 16)
tipLabel.Font = Enum.Font.Gotham
tipLabel.Text = "Village: heal swallows. Anywhere: use seeds. Plaza: buy upgrades."
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

local function showFeedback(text, tone, detail)
	feedbackToken += 1
	local activeToken = feedbackToken
	local colors = feedbackColors[tone] or feedbackColors.info

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

local function refreshHud()
	local seeds = getAttribute(playerAttributes.Seeds) or 0
	local money = getAttribute(playerAttributes.Money) or 0
	local footworkLevel = getAttribute(playerAttributes.MoveSpeedLevel) or 0
	local handsLevel = getAttribute(playerAttributes.AttackSpeedLevel) or 0
	local blessingLevel = getAttribute(playerAttributes.SeedMultiplierLevel) or 0
	local isSlowed = getAttribute(playerAttributes.IsSlowed) or false

	resourcesLabel.Text = string.format("Seeds %d   |   Money %d", seeds, money)
	footworkLabel.Text = string.format("Footwork Lv.%d   Cost path: 20 / 40 / 80", footworkLevel)
	handsLabel.Text = string.format("Quick Hands Lv.%d   Faster pumpkin hits", handsLevel)
	blessingLabel.Text = string.format("Blessing Lv.%d   More seeds per heal", blessingLevel)
	statusLabel.Text = isSlowed and "Status: Goblin slow active" or "Status: Clear"
	statusLabel.TextColor3 = isSlowed and Color3.fromRGB(240, 149, 112) or Color3.fromRGB(245, 215, 152)

	if isSlowed then
		objectiveLabel.Text = "Objective: Shake the goblin slow, then get back to the loop."
		objectiveLabel.TextColor3 = Color3.fromRGB(245, 188, 150)
	elseif seeds <= 0 then
		objectiveLabel.Text = "Objective: Head left to Heungbu Village and heal a swallow."
		objectiveLabel.TextColor3 = Color3.fromRGB(206, 232, 190)
	elseif money >= 20 then
		objectiveLabel.Text = "Objective: Cash in at the plaza or keep farming for a bigger buy."
		objectiveLabel.TextColor3 = Color3.fromRGB(240, 224, 163)
	else
		objectiveLabel.Text = "Objective: Plant seeds nearby and crack pumpkins for money."
		objectiveLabel.TextColor3 = Color3.fromRGB(220, 235, 196)
	end

	useSeedButton.Active = seeds > 0
	useSeedButton.AutoButtonColor = seeds > 0
	useSeedButton.BackgroundColor3 = seeds > 0 and Color3.fromRGB(97, 162, 88) or Color3.fromRGB(88, 82, 78)
	useSeedButton.Text = seeds > 0 and string.format("Use Seed [Q]\nSpawn an owned pumpkin near you (%d ready)", seeds) or "Need a Seed\nHeal an injured swallow first"
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

feedbackRemote.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	showFeedback(payload.text, payload.tone, payload.detail)
end)

refreshHud()
