print("MagicGourd arcade client started")

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
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
local activeWorldPopupCounts = {}
local activeWorldPopupState = {}
local activeWorldPopupEntries = {}
local recentLoopReset = nil
local feedbackConfig = ArcadeConfig.Feedback or {}
local defaultIntensity = feedbackConfig.DefaultIntensity or "T2"
local popupYieldWindow = feedbackConfig.PopupYieldWindow or 0.3
local bannerDurationByIntensity = feedbackConfig.BannerDurationByIntensity or {}
local worldPopupByIntensity = feedbackConfig.WorldPopupByIntensity or {}
local worldPopupPriorityByIntensity = feedbackConfig.WorldPopupPriorityByIntensity or {}

local function getWorldPopupBucketKey(worldPosition)
	local bucketSize = 10
	return string.format(
		"%d:%d:%d",
		math.floor(worldPosition.X / bucketSize + 0.5),
		math.floor(worldPosition.Y / bucketSize + 0.5),
		math.floor(worldPosition.Z / bucketSize + 0.5)
	)
end

local function getAttribute(name)
	return player:GetAttribute(name)
end

local function getFeedbackColors(tone)
	return feedbackColors[tone] or feedbackColors.info
end

local function getFeedbackIntensity(payload)
	if typeof(payload) == "table" and type(payload.intensity) == "string" then
		return payload.intensity
	end

	return defaultIntensity
end

local function getBannerDuration(payload)
	return bannerDurationByIntensity[getFeedbackIntensity(payload)] or 2.2
end

local function getWorldPopupPriority(payload)
	local intensity = getFeedbackIntensity(payload)
	return worldPopupPriorityByIntensity[intensity] or worldPopupPriorityByIntensity[defaultIntensity] or 2
end

local function getWorldPopupProfile(payload, text)
	local profile = worldPopupByIntensity[getFeedbackIntensity(payload)] or worldPopupByIntensity[defaultIntensity] or {}
	local width = profile.size and profile.size.X or (string.len(text) > 12 and 210 or 170)
	local height = profile.size and profile.size.Y or (string.len(text) > 12 and 54 or 46)

	return {
		duration = profile.duration or 0.9,
		rise = profile.rise or 2.4,
		maxDistance = profile.maxDistance or 110,
		size = Vector2.new(width, height),
	}
end

local function dismissWorldPopupEntry(entry, bucketKey)
	if not entry or entry.dismissed then
		return
	end

	entry.dismissed = true
	if entry.fadeTween then
		entry.fadeTween:Cancel()
	end
	if entry.riseTween then
		entry.riseTween:Cancel()
	end
	if entry.label and entry.label.Parent then
		entry.label.TextTransparency = 1
		entry.label.TextStrokeTransparency = 1
	end
	if entry.part and entry.part.Parent then
		entry.part:Destroy()
	end

	activeWorldPopupCounts[bucketKey] = math.max((activeWorldPopupCounts[bucketKey] or 1) - 1, 0)
	if activeWorldPopupCounts[bucketKey] == 0 then
		activeWorldPopupCounts[bucketKey] = nil
	end
end

local function removeWorldPopupEntry(bucketKey, entry)
	local entries = activeWorldPopupEntries[bucketKey]
	if not entries then
		return
	end

	for index = #entries, 1, -1 do
		if entries[index] == entry then
			table.remove(entries, index)
			break
		end
	end

	if #entries == 0 then
		activeWorldPopupEntries[bucketKey] = nil
	end
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

local function findPumpkinFolder()
	local mapFolder = Workspace:FindFirstChild("Map")
	local runtimeFolder = mapFolder and mapFolder:FindFirstChild("Runtime")
	if not runtimeFolder then
		return nil
	end

	local arcadeLoopFolder = runtimeFolder:FindFirstChild("ArcadeLoop")
	if arcadeLoopFolder then
		local pumpkinsFolder = arcadeLoopFolder:FindFirstChild("Pumpkins")
		if pumpkinsFolder then
			return pumpkinsFolder
		end
	end

	return runtimeFolder:FindFirstChild("Pumpkins")
end

local function getOwnedPumpkinCount()
	local runtimeFolder = findPumpkinFolder()

	if not runtimeFolder then
		return 0
	end

	local ownedCount = 0
	for _, descendant in ipairs(runtimeFolder:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local ownerUserId = descendant:GetAttribute(ArcadeConfig.Attributes.Pumpkin.Owner)
			local pumpkinKind = descendant:GetAttribute(interactionAttributes.Kind)
			if ownerUserId == player.UserId and pumpkinKind == "Pumpkin" then
				ownedCount += 1
			end
		end
	end

	return ownedCount
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

local function getZoneState(rootPosition)
	local zones = ArcadeConfig.World and ArcadeConfig.World.Zones
	if typeof(rootPosition) ~= "Vector3" or type(zones) ~= "table" then
		return {
			inDanger = false,
			nearDangerEdge = false,
			inPlaza = false,
		}
	end

	local function isInsideZone(zone)
		if type(zone) ~= "table" or typeof(zone.center) ~= "Vector3" or typeof(zone.size) ~= "Vector3" then
			return false
		end

		local halfSize = zone.size * 0.5
		local delta = rootPosition - zone.center
		return math.abs(delta.X) <= halfSize.X and math.abs(delta.Z) <= halfSize.Z
	end

	local dangerZone = zones.NolbuDanger
	local plazaZone = zones.CentralPlaza
	local inDanger = isInsideZone(dangerZone)
	local inPlaza = isInsideZone(plazaZone)
	local nearDangerEdge = false

	if type(dangerZone) == "table" and typeof(dangerZone.center) == "Vector3" and typeof(dangerZone.size) == "Vector3" then
		local edgePadding = 16
		local delta = rootPosition - dangerZone.center
		local expandedHalfSize = dangerZone.size * 0.5 + Vector3.new(edgePadding, 0, edgePadding)
		nearDangerEdge = math.abs(delta.X) <= expandedHalfSize.X and math.abs(delta.Z) <= expandedHalfSize.Z
	end

	return {
		inDanger = inDanger,
		nearDangerEdge = nearDangerEdge,
		inPlaza = inPlaza,
	}
end

local function getPrimaryGuidance(playerState)
	if playerState.isSlowed then
		if playerState.zoneState.inDanger or playerState.zoneState.nearDangerEdge then
			return "Next: Pull back toward Central Plaza.", Color3.fromRGB(245, 188, 150)
		end
		return "Next: Recover from the goblin slow.", Color3.fromRGB(245, 188, 150)
	end

	if playerState.ownedPumpkins > 0 then
		return "Next: Break your pumpkin for money.", Color3.fromRGB(240, 224, 163)
	end

	if playerState.seeds > 0 then
		if playerState.recentRecovery and not playerState.zoneState.inDanger then
			return "Next: Plant on the safe side.", Color3.fromRGB(220, 235, 196)
		end
		return "Next: Plant a pumpkin nearby.", Color3.fromRGB(220, 235, 196)
	end

	if #playerState.affordableUpgradeIds > 0 then
		return "Next: Return to Central Plaza for an upgrade.", Color3.fromRGB(240, 224, 163)
	end

	if playerState.seeds <= 0 then
		return "Next: Heal a swallow in Heungbu Village for seeds.", Color3.fromRGB(206, 232, 190)
	end

	return "Next: Return to Heungbu Village for seeds.", Color3.fromRGB(206, 232, 190)
end

local function getRecentLoopReset(playerState)
	if not recentLoopReset then
		return nil
	end

	if os.clock() > recentLoopReset.expiresAt then
		recentLoopReset = nil
		return nil
	end

	if recentLoopReset.kind == "upgradePurchase" and not playerState.isSlowed then
		return recentLoopReset
	end

	return nil
end

local function getStatusSummary(playerState)
	if playerState.isSlowed then
		if playerState.zoneState.inDanger or playerState.zoneState.nearDangerEdge then
			return "Status: Under danger pressure", Color3.fromRGB(240, 149, 112)
		end
		return "Status: Goblin slow active", Color3.fromRGB(240, 149, 112)
	end

	if playerState.zoneState.inDanger then
		return "Status: Inside slow zone", Color3.fromRGB(232, 170, 126)
	end

	if playerState.ownedPumpkins > 0 then
		return playerState.ownedPumpkins == 1 and "Status: Pumpkin ready" or string.format("Status: %d pumpkins ready", playerState.ownedPumpkins), Color3.fromRGB(245, 215, 152)
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
		if playerState.zoneState.inDanger or playerState.zoneState.nearDangerEdge then
			if playerState.ownedPumpkins > 0 then
				return "Back toward the plaza lane first, then cash out your waiting pumpkin."
			end
			if playerState.seeds > 0 then
				return "Retreat toward the plaza lane first, then plant once your pace is back."
			end
			return "Use the plaza-side lane to reset, then rejoin the loop."
		end
		if playerState.ownedPumpkins > 0 then
			return "Recover first, then get back to your pumpkin cash-out."
		end
		if playerState.seeds > 0 then
			return "Recover first, then plant once your pace is back."
		end
		return "Recover first, then rejoin the loop from the safe side."
	end

	if playerState.recentRecovery and not playerState.zoneState.inDanger then
		if playerState.ownedPumpkins > 0 then
			return "You made it out — cash in before another danger push."
		end
		if playerState.seeds > 0 then
			return "You are clear again — plant nearby before risking another push."
		end
		if #playerState.affordableUpgradeIds > 0 then
			return "The lane is clear again — buy now if you want a stronger re-entry."
		end
		return "You are back on the safe side — rebuild the loop from the village."
	end

	if playerState.zoneState.inDanger and playerState.seeds > 0 then
		return "Danger is for pressure, not setup — step back before planting if the lane feels messy."
	end

	if playerState.ownedPumpkins > 0 and #playerState.affordableUpgradeIds > 0 then
		return "Cash out your pumpkin first, then decide if this is the plaza trip."
	end

	if playerState.ownedPumpkins > 0 then
		return "Break first, then replant or head back to the plaza."
	end

	if #playerState.affordableUpgradeIds > 0 and playerState.seeds <= 0 then
		return "Buy now, then return to Heungbu Village for fresh seeds."
	end

	if #playerState.affordableUpgradeIds > 0 then
		return "Plant first, or swing by the plaza if you want a stronger next route."
	end

	return "Loop: heal -> plant -> break -> buy."
end

local function showFeedback(payload)
	local text = payload and payload.text
	local tone = payload and payload.tone
	local detail = payload and payload.detail

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

	task.delay(getBannerDuration(payload), function()
		if feedbackToken ~= activeToken then
			return
		end

		feedbackLabel.Visible = false
		feedbackLabel.Text = ""
	end)
end

local wasSlowed = getAttribute(playerAttributes.IsSlowed) or false

local function showWorldPopup(payload)
	local text = payload and (payload.worldText or payload.text)
	local tone = payload and payload.tone
	local worldPosition = payload and payload.worldPosition
	if typeof(worldPosition) ~= "Vector3" or text == nil or text == "" then
		return
	end

	local now = os.clock()
	local bucketKey = getWorldPopupBucketKey(worldPosition)
	local priority = getWorldPopupPriority(payload)
	local bucketState = activeWorldPopupState[bucketKey]
	if bucketState and now - bucketState.lastShownAt <= popupYieldWindow and priority < bucketState.priority then
		return
	end

	local existingEntries = activeWorldPopupEntries[bucketKey]
	if existingEntries and now - (bucketState and bucketState.lastShownAt or 0) <= popupYieldWindow then
		for index = #existingEntries, 1, -1 do
			local entry = existingEntries[index]
			if entry and priority >= entry.priority then
				dismissWorldPopupEntry(entry, bucketKey)
				removeWorldPopupEntry(bucketKey, entry)
			end
		end
	end

	local colors = getFeedbackColors(tone)
	local profile = getWorldPopupProfile(payload, text)
	local activeCount = activeWorldPopupCounts[bucketKey] or 0
	activeWorldPopupCounts[bucketKey] = activeCount + 1
	activeWorldPopupState[bucketKey] = {
		priority = priority,
		lastShownAt = now,
	}

	local lateralOffset = ((activeCount % 3) - 1) * 1.2
	local verticalOffset = 3.6 + math.min(activeCount, 3) * 1.15
	local popupPart = Instance.new("Part")
	popupPart.Name = "ArcadeFeedbackAnchor"
	popupPart.Anchored = true
	popupPart.CanCollide = false
	popupPart.CanTouch = false
	popupPart.CanQuery = false
	popupPart.Transparency = 1
	popupPart.Size = Vector3.new(0.2, 0.2, 0.2)
	popupPart.CFrame = CFrame.new(worldPosition + Vector3.new(lateralOffset, verticalOffset, 0))
	popupPart.Parent = Workspace

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ArcadeFeedbackBillboard"
	billboard.Size = UDim2.fromOffset(profile.size.X, profile.size.Y)
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = profile.maxDistance
	billboard.Parent = popupPart

	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(0.5, 0.5)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextWrapped = true
	label.TextStrokeTransparency = 0.4
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextColor3 = colors.text
	label.Text = text
	label.Parent = billboard

	local riseTween = TweenService:Create(
		popupPart,
		TweenInfo.new(profile.duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ CFrame = popupPart.CFrame + Vector3.new(0, profile.rise, 0) }
	)
	local fadeTween = TweenService:Create(
		label,
		TweenInfo.new(profile.duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{ TextTransparency = 1, TextStrokeTransparency = 1 }
	)
	local entry = {
		priority = priority,
		createdAt = now,
		part = popupPart,
		label = label,
		riseTween = riseTween,
		fadeTween = fadeTween,
		dismissed = false,
	}
	activeWorldPopupEntries[bucketKey] = activeWorldPopupEntries[bucketKey] or {}
	table.insert(activeWorldPopupEntries[bucketKey], entry)

	riseTween:Play()
	fadeTween:Play()
	fadeTween.Completed:Connect(function()
		local didFinishNaturally = not entry.dismissed
		removeWorldPopupEntry(bucketKey, entry)
		if didFinishNaturally then
			activeWorldPopupCounts[bucketKey] = math.max((activeWorldPopupCounts[bucketKey] or 1) - 1, 0)
			if activeWorldPopupCounts[bucketKey] == 0 then
				activeWorldPopupCounts[bucketKey] = nil
			end
			if popupPart.Parent then
				popupPart:Destroy()
			end
		end
		if activeWorldPopupState[bucketKey] and activeWorldPopupState[bucketKey].lastShownAt == now then
			activeWorldPopupState[bucketKey] = nil
		end
	end)
end

local function refreshHud()
	local seeds = getAttribute(playerAttributes.Seeds) or 0
	local money = getAttribute(playerAttributes.Money) or 0
	local isSlowed = getAttribute(playerAttributes.IsSlowed) or false
	local affordableUpgradeIds = getAffordableUpgradeIds(money)
	local ownedPumpkins = getOwnedPumpkinCount()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local zoneState = getZoneState(root and root.Position or nil)
	local playerState = {
		seeds = seeds,
		money = money,
		isSlowed = isSlowed,
		affordableUpgradeIds = affordableUpgradeIds,
		ownedPumpkins = ownedPumpkins,
		zoneState = zoneState,
		recentRecovery = recentLoopReset ~= nil and recentLoopReset.kind == "slowRecovery" and os.clock() <= recentLoopReset.expiresAt,
	}
	local recentReset = getRecentLoopReset(playerState)

	resourcesLabel.Text = string.format("Seeds %d   |   Money %d", seeds, money)

	local nextText, nextColor
	if recentReset and recentReset.kind == "upgradePurchase" then
		if seeds > 0 then
			nextText = "Next: Plant a pumpkin and feel the upgrade on this run."
			nextColor = Color3.fromRGB(220, 235, 196)
		else
			nextText = "Next: Return to Heungbu Village for fresh seeds."
			nextColor = Color3.fromRGB(206, 232, 190)
		end
	else
		nextText, nextColor = getPrimaryGuidance(playerState)
	end
	nextLabel.Text = nextText
	nextLabel.TextColor3 = nextColor

	local statusText, statusColor
	if recentReset and recentReset.kind == "upgradePurchase" then
		statusText = "Status: Upgrade applied"
		statusColor = Color3.fromRGB(245, 215, 152)
	else
		statusText, statusColor = getStatusSummary(playerState)
	end
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

	if recentReset and recentReset.kind == "upgradePurchase" then
		if recentReset.upgradeId == "MoveSpeed" then
			tipLabel.Text = seeds > 0 and "Plant now, then take the village route again and feel the lighter pace." or "Take the village route again and feel the lighter pace."
		elseif recentReset.upgradeId == "AttackSpeed" then
			tipLabel.Text = seeds > 0 and "Plant now and cash out the next pumpkin faster." or "Heal once more, then cash out the next pumpkin faster."
		elseif recentReset.upgradeId == "SeedMultiplier" then
			tipLabel.Text = seeds > 0 and "Plant if you want, or heal again to turn one swallow into a bigger setup." or "Go heal again to turn one swallow into a bigger setup."
		else
			tipLabel.Text = getSupportTip(playerState)
		end
	else
		tipLabel.Text = getSupportTip(playerState)
	end

	useSeedButton.Active = seeds > 0
	useSeedButton.AutoButtonColor = seeds > 0

	if seeds > 0 then
		local buttonTitle = "Plant Pumpkin [Q]"
		local secondLine = string.format("Spend 1 seed and grow your own pumpkin (%d ready)", seeds)
		local backgroundColor = Color3.fromRGB(97, 162, 88)
		local strokeColor = Color3.fromRGB(235, 219, 177)
		local textColor = Color3.fromRGB(252, 247, 239)

		if isSlowed then
			buttonTitle = "Plant After Recovery [Q]"
			secondLine = string.format("You can plant now, but recovering first keeps the loop cleaner (%d seed%s ready)", seeds, seeds == 1 and "" or "s")
			backgroundColor = Color3.fromRGB(128, 104, 78)
			strokeColor = Color3.fromRGB(245, 188, 150)
		elseif ownedPumpkins > 0 then
			buttonTitle = "Plant Another Pumpkin [Q]"
			secondLine = string.format("Break yours first for the clean cash-out, or spend another seed now (%d ready)", seeds)
			backgroundColor = Color3.fromRGB(132, 110, 72)
			strokeColor = Color3.fromRGB(240, 224, 163)
		elseif #affordableUpgradeIds > 0 then
			secondLine = string.format("Plant first to keep momentum, or swing by the plaza instead (%d seed%s ready)", seeds, seeds == 1 and "" or "s")
		end

		useSeedButton.BackgroundColor3 = backgroundColor
		buttonStroke.Color = strokeColor
		useSeedButton.TextColor3 = textColor
		useSeedButton.Text = string.format("%s\n%s", buttonTitle, secondLine)
	else
		useSeedButton.BackgroundColor3 = Color3.fromRGB(88, 82, 78)
		buttonStroke.Color = Color3.fromRGB(235, 219, 177)
		useSeedButton.TextColor3 = Color3.fromRGB(252, 247, 239)
		useSeedButton.Text = "Need Seeds\nHeal a swallow first"
	end
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

local function connectPumpkinFolder(folder)
	if not folder then
		return
	end

	folder.ChildAdded:Connect(refreshHud)
	folder.ChildRemoved:Connect(refreshHud)

	for _, descendant in ipairs(folder:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant:GetAttributeChangedSignal(ArcadeConfig.Attributes.Pumpkin.Owner):Connect(refreshHud)
		end
	end

	folder.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			descendant:GetAttributeChangedSignal(ArcadeConfig.Attributes.Pumpkin.Owner):Connect(refreshHud)
			refreshHud()
		end
	end)

	folder.DescendantRemoving:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			refreshHud()
		end
	end)
end

local function connectRuntimeFolder(runtimeFolder)
	if not runtimeFolder then
		return
	end

	connectPumpkinFolder(findPumpkinFolder())

	local function onRuntimeChildAdded(child)
		if child.Name == "Pumpkins" then
			connectPumpkinFolder(child)
			refreshHud()
			return
		end

		if child.Name == "ArcadeLoop" then
			connectPumpkinFolder(child:FindFirstChild("Pumpkins"))
			child.ChildAdded:Connect(function(grandChild)
				if grandChild.Name == "Pumpkins" then
					connectPumpkinFolder(grandChild)
					refreshHud()
				end
			end)
			refreshHud()
		end
	end

	runtimeFolder.ChildAdded:Connect(onRuntimeChildAdded)

	local arcadeLoopFolder = runtimeFolder:FindFirstChild("ArcadeLoop")
	if arcadeLoopFolder then
		connectPumpkinFolder(arcadeLoopFolder:FindFirstChild("Pumpkins"))
		arcadeLoopFolder.ChildAdded:Connect(function(child)
			if child.Name == "Pumpkins" then
				connectPumpkinFolder(child)
				refreshHud()
			end
		end)
	end
end

local mapFolder = Workspace:FindFirstChild("Map")
if mapFolder then
	connectRuntimeFolder(mapFolder:FindFirstChild("Runtime"))

	mapFolder.ChildAdded:Connect(function(child)
		if child.Name ~= "Runtime" then
			return
		end

		connectRuntimeFolder(child)
		refreshHud()
	end)
end

player:GetAttributeChangedSignal(playerAttributes.IsSlowed):Connect(function()
	local isSlowed = getAttribute(playerAttributes.IsSlowed) or false
	if wasSlowed and not isSlowed then
		recentLoopReset = {
			kind = "slowRecovery",
			expiresAt = os.clock() + 1.8,
		}
		showFeedback({
			text = "Slow faded.",
			detail = "You are back to full pace.",
			tone = "good",
			intensity = "T1",
		})
		task.delay(1.8, function()
			if recentLoopReset and recentLoopReset.kind == "slowRecovery" and os.clock() >= recentLoopReset.expiresAt then
				recentLoopReset = nil
				refreshHud()
			end
		end)
	end
	wasSlowed = isSlowed
end)

feedbackRemote.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	if payload.context == "UpgradePurchase" then
		recentLoopReset = {
			kind = "upgradePurchase",
			upgradeId = payload.upgradeId,
			expiresAt = os.clock() + 2.8,
		}
		task.delay(2.8, function()
			if recentLoopReset and recentLoopReset.kind == "upgradePurchase" and recentLoopReset.upgradeId == payload.upgradeId and os.clock() >= recentLoopReset.expiresAt then
				recentLoopReset = nil
				refreshHud()
			end
		end)
	end

	showFeedback(payload)
	showWorldPopup(payload)
	refreshHud()
end)

local lastHudPosition
RunService.RenderStepped:Connect(function()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		if lastHudPosition ~= nil then
			lastHudPosition = nil
			refreshHud()
		end
		return
	end

	if not lastHudPosition or (root.Position - lastHudPosition).Magnitude >= 4 then
		lastHudPosition = root.Position
		refreshHud()
	end
end)

refreshHud()
