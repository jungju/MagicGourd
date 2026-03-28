print("MagicGourd server started")

local InsertService = game:GetService("InsertService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local map = Workspace:WaitForChild("Map")
local runtimeFolder = map:FindFirstChild("Runtime") or Instance.new("Folder")
runtimeFolder.Name = "Runtime"
runtimeFolder.Parent = map

local placedAssets = runtimeFolder:FindFirstChild("PlacedAssets") or Instance.new("Folder")
placedAssets.Name = "PlacedAssets"
placedAssets.Parent = runtimeFolder

local interactionFolder = runtimeFolder:FindFirstChild("InteractionNodes") or Instance.new("Folder")
interactionFolder.Name = "InteractionNodes"
interactionFolder.Parent = runtimeFolder

local wanderFolder = runtimeFolder:FindFirstChild("WanderNodes") or Instance.new("Folder")
wanderFolder.Name = "WanderNodes"
wanderFolder.Parent = runtimeFolder

local sharedFolder = ReplicatedStorage:FindFirstChild("Shared") or ReplicatedStorage
local dialogueEvent = sharedFolder:FindFirstChild("DialogueEvent") or Instance.new("RemoteEvent")
dialogueEvent.Name = "DialogueEvent"
dialogueEvent.Parent = sharedFolder

local effectEvent = sharedFolder:FindFirstChild("StoryEffectEvent") or Instance.new("RemoteEvent")
effectEvent.Name = "StoryEffectEvent"
effectEvent.Parent = sharedFolder

local endingChoiceEvent = sharedFolder:FindFirstChild("EndingChoiceEvent") or Instance.new("RemoteEvent")
endingChoiceEvent.Name = "EndingChoiceEvent"
endingChoiceEvent.Parent = sharedFolder

local endingChoiceResponseEvent = sharedFolder:FindFirstChild("EndingChoiceResponseEvent") or Instance.new("RemoteEvent")
endingChoiceResponseEvent.Name = "EndingChoiceResponseEvent"
endingChoiceResponseEvent.Parent = sharedFolder

local QUEST = {
	INTRO = 0,
	MEET_HEUNGBU = 1,
	PLANT_FIRST = 2,
	HARVEST_FIRST = 3,
	DELIVER_FIRST = 4,
	CLAIM_HELP = 5,
	HEAR_NOLBU = 6,
	DELIVER_TRIBUTE = 7,
	INVESTIGATE_SWALLOW = 8,
	GATHER_HERBS = 9,
	BRING_HERBS = 10,
	BLESSED_SEED = 11,
	GROW_BLESSED = 12,
	HARVEST_BLESSED = 13,
	MAGIC_PAYOFF = 14,
	NOLBU_RETALIATION = 15,
	CLEAR_BRAMBLES = 16,
	FINAL_AUDIENCE = 17,
	CHOOSE_ENDING = 18,
	ENDING_RESTORATION = 19,
	ENDING_TRIBUTE = 20,
	COMPLETE = 21,
}

local QUEST_TITLES = {
	[QUEST.INTRO] = "Village Rumor",
	[QUEST.MEET_HEUNGBU] = "A Kind Request",
	[QUEST.PLANT_FIRST] = "Plant Hope",
	[QUEST.HARVEST_FIRST] = "Harvest Time",
	[QUEST.DELIVER_FIRST] = "Bring the Gourd",
	[QUEST.CLAIM_HELP] = "Heungbu's Thanks",
	[QUEST.HEAR_NOLBU] = "Nolbu's Demand",
	[QUEST.DELIVER_TRIBUTE] = "One More Delivery",
	[QUEST.INVESTIGATE_SWALLOW] = "The Hurt Swallow",
	[QUEST.GATHER_HERBS] = "Find Healing Herbs",
	[QUEST.BRING_HERBS] = "Bring the Herbs Home",
	[QUEST.BLESSED_SEED] = "Blessed Seed",
	[QUEST.GROW_BLESSED] = "Golden Vine",
	[QUEST.HARVEST_BLESSED] = "True Magic Gourd",
	[QUEST.MAGIC_PAYOFF] = "Heungbu's Reward",
	[QUEST.NOLBU_RETALIATION] = "A Jealous Brother",
	[QUEST.CLEAR_BRAMBLES] = "Clear the Brambles",
	[QUEST.FINAL_AUDIENCE] = "Final Audience",
	[QUEST.CHOOSE_ENDING] = "Choose the Valley's Path",
	[QUEST.ENDING_RESTORATION] = "Ending: Restored Valley",
	[QUEST.ENDING_TRIBUTE] = "Ending: Tribute Road",
	[QUEST.COMPLETE] = "Village Aftermath",
}

local QUEST_OBJECTIVES = {
	[QUEST.INTRO] = "Read the Story Stone or speak with Heungbu.",
	[QUEST.MEET_HEUNGBU] = "Collect a seed from the village basket.",
	[QUEST.PLANT_FIRST] = "Plant the seed in Heungbu's patch.",
	[QUEST.HARVEST_FIRST] = "Wait for the vine, then harvest the ripe gourd.",
	[QUEST.DELIVER_FIRST] = "Deliver the gourd to Heungbu.",
	[QUEST.CLAIM_HELP] = "Speak with Heungbu again to hear what comes next.",
	[QUEST.HEAR_NOLBU] = "Listen to Nolbu near his estate gate.",
	[QUEST.DELIVER_TRIBUTE] = "Grow one more gourd and bring it to Nolbu's gate.",
	[QUEST.INVESTIGATE_SWALLOW] = "Check the injured swallow near Nolbu's wall.",
	[QUEST.GATHER_HERBS] = "Gather healing herbs from the village well garden.",
	[QUEST.BRING_HERBS] = "Carry the healing herbs to Heungbu.",
	[QUEST.BLESSED_SEED] = "Plant Heungbu's blessed seed in the patch.",
	[QUEST.GROW_BLESSED] = "Wait for the glowing vine to mature.",
	[QUEST.HARVEST_BLESSED] = "Harvest the true magic gourd.",
	[QUEST.MAGIC_PAYOFF] = "Bring the true magic gourd to Heungbu.",
	[QUEST.NOLBU_RETALIATION] = "Go hear Nolbu's reaction at the estate gate.",
	[QUEST.CLEAR_BRAMBLES] = "Clear the brambles from Heungbu's patch.",
	[QUEST.FINAL_AUDIENCE] = "Return to Heungbu's yard and decide what kind of harvest the valley should protect.",
	[QUEST.CHOOSE_ENDING] = "Choose between Heungbu's shared harvest and Nolbu's tribute road.",
	[QUEST.ENDING_RESTORATION] = "You stood with Heungbu. Let the valley breathe and keep growing.",
	[QUEST.ENDING_TRIBUTE] = "You appeased Nolbu. Keep the harvest coming under tribute.",
	[QUEST.COMPLETE] = "Your ending is set. Keep growing gourds for coins and see the village live with it.",
}

local villageState = {
	gourdsHarvested = 0,
	heungbuDeliveries = 0,
	nolbuTributes = 0,
	herbBundlesPicked = 0,
	swallowHelped = 0,
	magicPayoffs = 0,
	retaliations = 0,
	restorationEndings = 0,
	tributeEndings = 0,
}

local playerData = {}

local villageLayout = {
	heungbu = {
		housePad = { name = "HeungbuYardPad", size = Vector3.new(34, 0.8, 24), position = Vector3.new(-72, 1.0, 48), yaw = -20 },
		talkPart = { name = "HeungbuTalkPart", position = Vector3.new(-72, 5, 44), size = Vector3.new(8, 8, 8) },
		patchPart = { name = "PlantPatch", position = Vector3.new(-96, 3, 13), size = Vector3.new(10, 6, 10) },
	},
	nolbu = {
		yardPad = { name = "NolbuFrontYard", size = Vector3.new(40, 0.8, 28), position = Vector3.new(74, 1.0, 44), yaw = 18 },
		talkPart = { name = "NolbuComplaint", position = Vector3.new(74, 5, 48), size = Vector3.new(8, 8, 8) },
		tributePart = { name = "NolbuTribute", position = Vector3.new(84, 4.2, 57), size = Vector3.new(8, 5, 8) },
		swallowPart = { name = "InjuredSwallow", position = Vector3.new(61, 3.8, 56), size = Vector3.new(6, 5, 6) },
	},
	village = {
		well = { name = "VillageWell", size = Vector3.new(10, 5, 10), position = Vector3.new(0, 3.1, 36) },
		seedMat = { name = "SeedMat", size = Vector3.new(12, 0.6, 10), position = Vector3.new(-24, 1.2, 34) },
		storyStone = { name = "FestivalStone", size = Vector3.new(8, 2, 8), position = Vector3.new(22, 1.8, 54) },
		gourdPatch = { name = "GourdPatch", size = Vector3.new(14, 1, 12), position = Vector3.new(-96, 1.5, 13) },
		herbPatch = { name = "HealingHerbPatch", size = Vector3.new(9, 1, 7), position = Vector3.new(-8, 1.7, 50) },
		clothesline = { name = "HeungbuClothesline", size = Vector3.new(16, 0.8, 2), position = Vector3.new(-56, 7.5, 56) },
	},
}

local housePlacementSpecs = {
	HeungbuHouse = {
		padName = villageLayout.heungbu.housePad.name,
		padPosition = villageLayout.heungbu.housePad.position,
		orientationCorrection = Vector3.new(90, 0, 0),
		facingYaw = -22,
		groundOffset = 0,
		visualOffset = Vector3.new(0, 0, -2),
		fallbackFootprint = Vector3.new(34, 18, 26),
		narrativeRole = "humble",
	},
	NolbuHouse = {
		padName = villageLayout.nolbu.yardPad.name,
		padPosition = villageLayout.nolbu.yardPad.position,
		orientationCorrection = Vector3.new(90, 0, 0),
		facingYaw = 20,
		groundOffset = 0,
		visualOffset = Vector3.new(0, 0, -8),
		fallbackFootprint = Vector3.new(42, 22, 30),
		narrativeRole = "imposing",
	},
}

local function getPlayerProfile(player)
	local profile = playerData[player]
	if profile then
		return profile
	end

	profile = {
		seeds = 1,
		gourds = 0,
		herbs = 0,
		coins = 0,
		blessedSeeds = 0,
		blessedGourds = 0,
		questStage = QUEST.INTRO,
		heungbuDeliveries = 0,
		nolbuTributes = 0,
		bonusSeedsClaimed = false,
		swallowInspected = false,
		swallowHelped = false,
		magicPayoffDone = false,
		retaliationTriggered = false,
		bramblesCleared = false,
		endingChoice = "none",
		endingResolved = false,
		endingSelectionOpen = false,
		activePresentationToken = 0,
		presentationBusy = false,
	}
	playerData[player] = profile
	return profile
end

local function setQuestStage(player, stage)
	local profile = getPlayerProfile(player)
	if stage > profile.questStage then
		profile.questStage = stage
	end
end

local function getEndingName(choice)
	if choice == "restoration" then
		return "Restored Valley"
	elseif choice == "tribute" then
		return "Tribute Road"
	end
	return "Unwritten"
end

local function getEndingHint(choice)
	if choice == "restoration" then
		return "Ending: Restored Valley · The village protects shared harvests."
	elseif choice == "tribute" then
		return "Ending: Tribute Road · The harvest still grows under Nolbu's shadow."
	end
	return "Watch the village signs for story changes."
end

local function syncPlayerAttributes(player)
	local profile = getPlayerProfile(player)
	player:SetAttribute("Seeds", profile.seeds)
	player:SetAttribute("Gourds", profile.gourds)
	player:SetAttribute("Herbs", profile.herbs)
	player:SetAttribute("Coins", profile.coins)
	player:SetAttribute("BlessedSeeds", profile.blessedSeeds)
	player:SetAttribute("BlessedGourds", profile.blessedGourds)
	player:SetAttribute("QuestStage", profile.questStage)
	player:SetAttribute("QuestTitle", QUEST_TITLES[profile.questStage] or "Village Tale")
	player:SetAttribute("QuestObjective", QUEST_OBJECTIVES[profile.questStage] or "Help the village.")
	player:SetAttribute("QuestHint", getEndingHint(profile.endingChoice))
	player:SetAttribute("HeungbuDeliveries", profile.heungbuDeliveries)
	player:SetAttribute("NolbuTributes", profile.nolbuTributes)
	player:SetAttribute("EndingName", getEndingName(profile.endingChoice))
end


local function showDialogue(player, speaker, lines, accent)
	dialogueEvent:FireClient(player, { speaker = speaker, lines = lines, accent = accent })
end

local function showEffect(player, kind, title, body, color, duration, pulseCount)
	effectEvent:FireClient(player, {
		kind = kind,
		title = title,
		body = body,
		color = color,
		duration = duration,
		pulseCount = pulseCount,
	})
end

local function startPresentation(player)
	local profile = getPlayerProfile(player)
	profile.activePresentationToken += 1
	profile.presentationBusy = true
	return profile.activePresentationToken
end

local function finishPresentation(player, token)
	local profile = getPlayerProfile(player)
	if profile.activePresentationToken == token then
		profile.presentationBusy = false
	end
end

local function playPresentationSequence(player, beats, onComplete)
	local token = startPresentation(player)
	task.spawn(function()
		for index, beat in ipairs(beats) do
			local profile = getPlayerProfile(player)
			if profile.activePresentationToken ~= token then
				return
			end
			if beat.onStart then
				beat.onStart(index, token)
			end
			if beat.effect then
				showEffect(
					player,
					beat.effect.kind,
					beat.effect.title,
					beat.effect.body,
					beat.effect.color,
					beat.effect.duration,
					beat.effect.pulseCount
				)
			end
			if beat.dialogue then
				showDialogue(player, beat.dialogue.speaker, beat.dialogue.lines, beat.dialogue.accent)
			end
			if beat.delay and beat.delay > 0 then
				task.wait(beat.delay)
			end
			profile = getPlayerProfile(player)
			if profile.activePresentationToken ~= token then
				return
			end
			if beat.onComplete then
				beat.onComplete(index, token)
			end
		end
		local profile = getPlayerProfile(player)
		if profile.activePresentationToken ~= token then
			return
		end
		if onComplete then
			onComplete(token)
		end
		finishPresentation(player, token)
	end)
end

Players.PlayerAdded:Connect(function(player)
	syncPlayerAttributes(player)
	showDialogue(player, "Village", {
		"A small valley waits for a kind harvest.",
		"Read the Story Stone or find Heungbu to begin.",
	}, Color3.fromRGB(219, 198, 140))
end)

Players.PlayerRemoving:Connect(function(player)
	playerData[player] = nil
end)

local function clearExisting(name)
	local existing = placedAssets:FindFirstChild(name)
	if existing then existing:Destroy() end
end

local function clearInteraction(name)
	local existing = interactionFolder:FindFirstChild(name)
	if existing then existing:Destroy() end
end

local function getPrimary(instance)
	if instance:IsA("Model") then
		return instance.PrimaryPart or instance:FindFirstChildWhichIsA("BasePart", true)
	elseif instance:IsA("BasePart") then
		return instance
	end
	return nil
end

local function setModelCollision(model, canCollide)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then descendant.CanCollide = canCollide end
	end
end

local function anchorModel(model, anchored)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then descendant.Anchored = anchored end
	end
end

local function addPart(parent, name, size, cf, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Size = size
	part.CFrame = cf
	part.Color = color
	part.Material = material
	part.Parent = parent
	return part
end

local function addCylinder(parent, name, size, cf, color, material)
	local part = addPart(parent, name, size, cf, color, material)
	part.Shape = Enum.PartType.Cylinder
	return part
end

local function resolvePlacementSpec(def)
	if def.kind ~= "house" then
		return nil
	end

	local spec = housePlacementSpecs[def.name]
	if not spec then
		return nil
	end

	local anchorPosition = spec.padPosition or def.position or Vector3.zero
	local visualOffset = spec.visualOffset or Vector3.zero
	local worldPosition = Vector3.new(
		anchorPosition.X + visualOffset.X,
		(spec.position and spec.position.Y) or anchorPosition.Y + visualOffset.Y,
		anchorPosition.Z + visualOffset.Z
	)

	return {
		padName = spec.padName,
		position = worldPosition,
		orientationCorrection = spec.orientationCorrection or Vector3.zero,
		facingYaw = spec.facingYaw or 0,
		groundOffset = spec.groundOffset or 0,
		visualOffset = visualOffset,
		fallbackFootprint = spec.fallbackFootprint,
		narrativeRole = spec.narrativeRole,
	}
end

local function createFallbackHouse(def)
	local model = Instance.new("Model")
	model.Name = def.name
	local placement = resolvePlacementSpec(def) or {}
	local yaw = math.rad(placement.facingYaw or (def.rotation and def.rotation.Y) or 0)
	local basePosition = placement.position or def.position or Vector3.zero
	local baseCf = CFrame.new(basePosition) * CFrame.Angles(0, yaw, 0)
	local footprint = placement.fallbackFootprint or def.footprint or Vector3.new(26, 18, 22)
	local floor = addPart(model, "Floor", Vector3.new(footprint.X, 1, footprint.Z), baseCf, Color3.fromRGB(111, 78, 55), Enum.Material.WoodPlanks)
	local body = addPart(model, "Body", Vector3.new(footprint.X, footprint.Y, footprint.Z), baseCf * CFrame.new(0, footprint.Y / 2, 0), Color3.fromRGB(179, 146, 101), Enum.Material.Wood)
	local roofLeft = addPart(model, "RoofLeft", Vector3.new(footprint.X + 4, 1.2, footprint.Z / 2 + 3), baseCf * CFrame.new(0, footprint.Y + 4, -2) * CFrame.Angles(math.rad(-28), 0, 0), Color3.fromRGB(55, 34, 24), Enum.Material.WoodPlanks)
	local roofRight = addPart(model, "RoofRight", Vector3.new(footprint.X + 4, 1.2, footprint.Z / 2 + 3), baseCf * CFrame.new(0, footprint.Y + 4, 2) * CFrame.Angles(math.rad(28), 0, 0), Color3.fromRGB(55, 34, 24), Enum.Material.WoodPlanks)
	local porch = addPart(model, "Porch", Vector3.new(footprint.X * 0.45, 0.7, 6), baseCf * CFrame.new(0, 0.9, footprint.Z / 2 + 2), Color3.fromRGB(129, 95, 68), Enum.Material.WoodPlanks)
	body.Transparency = 0.08
	roofLeft.CanCollide = false
	roofRight.CanCollide = false
	porch.CanCollide = true
	model.PrimaryPart = floor
	if placement.padName then
		model:SetAttribute("PlacementPad", placement.padName)
	end
	if placement.narrativeRole then
		model:SetAttribute("NarrativeRole", placement.narrativeRole)
	end
	model.Parent = placedAssets
	return model
end

local function createFallbackNpc(def)
	local model = Instance.new("Model")
	model.Name = def.name
	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Size = Vector3.new(2, 2, 1)
	root.Transparency = 1
	root.CanCollide = false
	root.Anchored = false
	root.Parent = model
	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.Color = Color3.fromRGB(82, 55, 36)
	torso.Material = Enum.Material.Fabric
	torso.Anchored = false
	torso.Parent = model
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(2, 1, 1)
	head.Color = Color3.fromRGB(232, 190, 153)
	head.Material = Enum.Material.SmoothPlastic
	head.Anchored = false
	head.Parent = model
	local hat = Instance.new("Part")
	hat.Name = "Hat"
	hat.Size = Vector3.new(3, 0.6, 3)
	hat.Color = Color3.fromRGB(24, 24, 24)
	hat.Material = Enum.Material.Slate
	hat.Anchored = false
	hat.Parent = model
	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = def.walkSpeed or 8
	humanoid.AutoRotate = true
	humanoid.Parent = model
	local rootJoint = Instance.new("Motor6D")
	rootJoint.Part0 = root
	rootJoint.Part1 = torso
	rootJoint.Parent = root
	local neck = Instance.new("Motor6D")
	neck.Part0 = torso
	neck.Part1 = head
	neck.C0 = CFrame.new(0, 1.5, 0)
	neck.Parent = torso
	local hatWeld = Instance.new("WeldConstraint")
	hatWeld.Part0 = head
	hatWeld.Part1 = hat
	hatWeld.Parent = hat
	model.PrimaryPart = root
	model:PivotTo(CFrame.new(def.position) * CFrame.Angles(0, math.rad((def.rotation and def.rotation.Y) or 0), 0))
	head.Position = root.Position + Vector3.new(0, 2.5, 0)
	torso.Position = root.Position + Vector3.new(0, 1, 0)
	hat.Position = head.Position + Vector3.new(0, 0.9, 0)
	model.Parent = placedAssets
	return model
end

local function applyPlacement(candidate, def)
	local placement = resolvePlacementSpec(def)
	local rotation = def.rotation or Vector3.zero
	local correction = placement and placement.orientationCorrection or rotation
	local facingYaw = placement and placement.facingYaw or rotation.Y
	local targetPosition = placement and placement.position or def.position
	local groundY = (placement and placement.position and placement.position.Y) or (def.position and def.position.Y) or 0
	local groundOffset = placement and placement.groundOffset or def.groundOffset or 0
	local cf = CFrame.new(targetPosition) * CFrame.Angles(math.rad(correction.X), math.rad(facingYaw), math.rad(correction.Z))

	if candidate:IsA("Model") then
		local primary = getPrimary(candidate)
		if not primary then return false, "model has no basepart" end
		candidate.PrimaryPart = primary
		if typeof(def.scale) == "number" and def.scale > 0 and def.scale ~= 1 then pcall(function() candidate:ScaleTo(def.scale) end) end
		candidate:PivotTo(cf)
		local boxCf, boxSize = candidate:GetBoundingBox()
		local bottomY = boxCf.Position.Y - (boxSize.Y / 2)
		local lift = groundY - bottomY + groundOffset
		if math.abs(lift) > 0.001 then candidate:PivotTo(candidate:GetPivot() + Vector3.new(0, lift, 0)) end
		if placement then
			candidate:SetAttribute("PlacementPad", placement.padName)
			candidate:SetAttribute("NarrativeRole", placement.narrativeRole)
		end
		return true
	elseif candidate:IsA("BasePart") then
		if typeof(def.scale) == "number" and def.scale > 0 and def.scale ~= 1 then candidate.Size = candidate.Size * def.scale end
		candidate.CFrame = cf
		candidate.Anchored = true
		local bottomY = candidate.Position.Y - (candidate.Size.Y / 2)
		local lift = groundY - bottomY + groundOffset
		candidate.Position += Vector3.new(0, lift, 0)
		return true
	end
	return false, "unsupported instance type"
end

local function tryLoadAsset(def)
	local ok, container = pcall(function() return InsertService:LoadAsset(def.assetId) end)
	if not ok then return nil, tostring(container) end
	local candidate = container:GetChildren()[1]
	if not candidate then container:Destroy() return nil, "asset returned no children" end
	candidate.Name = def.name
	candidate.Parent = placedAssets
	local placedOk, placeError = applyPlacement(candidate, def)
	container:Destroy()
	if not placedOk then candidate:Destroy() return nil, placeError end
	return candidate
end

local function ensureInteractionPart(name, position, size)
	clearInteraction(name)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = size or Vector3.new(8, 6, 8)
	part.Position = position
	part.Parent = interactionFolder
	return part
end

local function createPrompt(parent, actionText, objectText, holdDuration, maxDistance)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.HoldDuration = holdDuration or 0.2
	prompt.MaxActivationDistance = maxDistance or 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = parent
	return prompt
end

local function attachBillboard(parent, title, body, color)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Info"
	billboard.Size = UDim2.fromOffset(240, 70)
	billboard.StudsOffset = Vector3.new(0, 4.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = parent
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 0.25
	frame.BackgroundColor3 = Color3.fromRGB(28, 20, 14)
	frame.BorderSizePixel = 0
	frame.Size = UDim2.fromScale(1, 1)
	frame.Parent = billboard
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(226, 186, 94)
	stroke.Thickness = 2
	stroke.Parent = frame
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -12, 0, 24)
	titleLabel.Position = UDim2.fromOffset(6, 6)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextColor3 = Color3.fromRGB(255, 239, 204)
	titleLabel.TextScaled = true
	titleLabel.Text = title
	titleLabel.Parent = frame
	local bodyLabel = Instance.new("TextLabel")
	bodyLabel.Name = "Body"
	bodyLabel.BackgroundTransparency = 1
	bodyLabel.Size = UDim2.new(1, -12, 1, -34)
	bodyLabel.Position = UDim2.fromOffset(6, 28)
	bodyLabel.Font = Enum.Font.Gotham
	bodyLabel.TextColor3 = Color3.fromRGB(234, 226, 214)
	bodyLabel.TextWrapped = true
	bodyLabel.TextScaled = true
	bodyLabel.Text = body
	bodyLabel.Parent = frame
	return billboard
end

local function setBillboardBody(billboard, text)
	local frame = billboard:FindFirstChildWhichIsA("Frame")
	local body = frame and frame:FindFirstChild("Body")
	if body and body:IsA("TextLabel") then body.Text = text end
end

local function makeWanderNode(name, position)
	local part = wanderFolder:FindFirstChild(name)
	if part then part.Position = position return part end
	part = Instance.new("Part")
	part.Name = name
	part.Size = Vector3.new(2, 2, 2)
	part.Position = position
	part.Transparency = 1
	part.CanCollide = false
	part.Anchored = true
	part.Parent = wanderFolder
	return part
end

local function buildWanderRing(prefix, center, radius, points)
	local nodes = {}
	for index = 1, points do
		local angle = ((index - 1) / points) * math.pi * 2
		table.insert(nodes, makeWanderNode(string.format("%s_%d", prefix, index), center + Vector3.new(math.cos(angle) * radius, 2, math.sin(angle) * radius)))
	end
	return nodes
end

local function startWanderNpc(model, def)
	local humanoid = model:FindFirstChildWhichIsA("Humanoid", true)
	local root = model:FindFirstChild("HumanoidRootPart", true) or getPrimary(model)
	if not humanoid or not root or not root:IsA("BasePart") then return end
	anchorModel(model, false)
	setModelCollision(model, true)
	for _, descendant in ipairs(model:GetDescendants()) do if descendant:IsA("BasePart") and descendant ~= root then descendant.Massless = true end end
	root:SetNetworkOwner(nil)
	root.CanCollide = false
	humanoid.WalkSpeed = def.walkSpeed or humanoid.WalkSpeed
	task.spawn(function()
		local nodes = def.nodes
		local index = 1
		while model.Parent do
			local target = nodes[index]
			if target and target.Parent then
				local path = PathfindingService:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true, WaypointSpacing = 4 })
				local ok = pcall(function() path:ComputeAsync(root.Position, target.Position) end)
				local traversed = false
				if ok and path.Status == Enum.PathStatus.Success then
					traversed = true
					for _, waypoint in ipairs(path:GetWaypoints()) do
						if waypoint.Action == Enum.PathWaypointAction.Jump then humanoid.Jump = true end
						humanoid:MoveTo(waypoint.Position)
						local reached = humanoid.MoveToFinished:Wait()
						if not reached or not model.Parent then traversed = false break end
					end
				end
				if not traversed then humanoid:MoveTo(target.Position) humanoid.MoveToFinished:Wait() end
				if root.Parent then root.CFrame = CFrame.lookAt(root.Position, target.Position) end
				task.wait(0.5 + math.random() * 1.1)
			end
			index += 1
			if index > #nodes then index = 1 end
		end
	end)
end

local assetDefinitions = {
	{ name = "HeungbuHouse", assetId = 93969099298348, kind = "house", position = Vector3.new(-72, 1.0, 28), rotation = Vector3.new(90, -22, 0), scale = 6, footprint = Vector3.new(34, 18, 26) },
	{ name = "NolbuHouse", assetId = 76012677304613, kind = "house", position = Vector3.new(74, 1.0, 18), rotation = Vector3.new(90, 20, 0), scale = 10, footprint = Vector3.new(42, 22, 30) },
	{ name = "NolbuPatrolA", assetId = 81648951264309, kind = "npc", position = Vector3.new(58, 3.2, 34), rotation = Vector3.new(0, 180, 0), scale = 1, walkSpeed = 8 },
	{ name = "NolbuPatrolB", assetId = 81648951264309, kind = "npc", position = Vector3.new(92, 3.2, 42), rotation = Vector3.new(0, 110, 0), scale = 1, walkSpeed = 7 },
}

local placedByName = {}
for _, def in ipairs(assetDefinitions) do
	clearExisting(def.name)
	local candidate, err = tryLoadAsset(def)
	if not candidate then
		warn(string.format("[MagicGourd] Falling back for %s: %s", def.name, tostring(err)))
		candidate = def.kind == "house" and createFallbackHouse(def) or createFallbackNpc(def)
	end
	placedByName[def.name] = candidate
end

local heungbuPad = addPart(placedAssets, villageLayout.heungbu.housePad.name, villageLayout.heungbu.housePad.size, CFrame.new(villageLayout.heungbu.housePad.position) * CFrame.Angles(0, math.rad(villageLayout.heungbu.housePad.yaw), 0), Color3.fromRGB(133, 99, 63), Enum.Material.Ground)
local nolbuPad = addPart(placedAssets, villageLayout.nolbu.yardPad.name, villageLayout.nolbu.yardPad.size, CFrame.new(villageLayout.nolbu.yardPad.position) * CFrame.Angles(0, math.rad(villageLayout.nolbu.yardPad.yaw), 0), Color3.fromRGB(142, 111, 77), Enum.Material.Ground)
local villageWell = addPart(placedAssets, villageLayout.village.well.name, villageLayout.village.well.size, CFrame.new(villageLayout.village.well.position), Color3.fromRGB(114, 101, 86), Enum.Material.Slate)
local marketMat = addPart(placedAssets, villageLayout.village.seedMat.name, villageLayout.village.seedMat.size, CFrame.new(villageLayout.village.seedMat.position), Color3.fromRGB(156, 106, 64), Enum.Material.WoodPlanks)
local gourdPatch = addPart(placedAssets, villageLayout.village.gourdPatch.name, villageLayout.village.gourdPatch.size, CFrame.new(villageLayout.village.gourdPatch.position), Color3.fromRGB(80, 55, 34), Enum.Material.Mud)
local festivalStone = addPart(placedAssets, villageLayout.village.storyStone.name, villageLayout.village.storyStone.size, CFrame.new(villageLayout.village.storyStone.position), Color3.fromRGB(124, 118, 112), Enum.Material.Slate)
local tributeBasket = addPart(placedAssets, "NolbuTributeBasket", Vector3.new(6, 2.2, 6), CFrame.new(villageLayout.nolbu.tributePart.position.X, 2.2, villageLayout.nolbu.tributePart.position.Z), Color3.fromRGB(101, 71, 43), Enum.Material.WoodPlanks)
local herbPatch = addPart(placedAssets, villageLayout.village.herbPatch.name, villageLayout.village.herbPatch.size, CFrame.new(villageLayout.village.herbPatch.position), Color3.fromRGB(73, 107, 49), Enum.Material.Grass)
local clotheslineBeam = addPart(placedAssets, villageLayout.village.clothesline.name, villageLayout.village.clothesline.size, CFrame.new(villageLayout.village.clothesline.position), Color3.fromRGB(104, 78, 58), Enum.Material.WoodPlanks)
addPart(placedAssets, "ClothesPoleA", Vector3.new(1, 8, 1), CFrame.new(villageLayout.village.clothesline.position + Vector3.new(-7, -4, 0)), Color3.fromRGB(117, 86, 61), Enum.Material.Wood)
addPart(placedAssets, "ClothesPoleB", Vector3.new(1, 8, 1), CFrame.new(villageLayout.village.clothesline.position + Vector3.new(7, -4, 0)), Color3.fromRGB(117, 86, 61), Enum.Material.Wood)
addPart(placedAssets, "DryingClothA", Vector3.new(3, 2.5, 0.2), CFrame.new(villageLayout.village.clothesline.position + Vector3.new(-3, -1, 0.3)), Color3.fromRGB(222, 219, 204), Enum.Material.Fabric)
addPart(placedAssets, "DryingClothB", Vector3.new(3, 2.5, 0.2), CFrame.new(villageLayout.village.clothesline.position + Vector3.new(2, -1.2, -0.3)), Color3.fromRGB(196, 214, 164), Enum.Material.Fabric)
local swallowNest = addCylinder(placedAssets, "SwallowNest", Vector3.new(2.2, 1.6, 2.2), CFrame.new(villageLayout.nolbu.swallowPart.position + Vector3.new(0, -2.2, 0)) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(111, 79, 49), Enum.Material.WoodPlanks)
local injuredSwallowMarker = addPart(placedAssets, "InjuredSwallowMarker", Vector3.new(1.6, 0.6, 2.4), CFrame.new(villageLayout.nolbu.swallowPart.position + Vector3.new(0, -1.1, 0)) * CFrame.Angles(0, math.rad(-24), math.rad(14)), Color3.fromRGB(43, 43, 46), Enum.Material.SmoothPlastic)
injuredSwallowMarker.CanCollide = false
local swallowWing = addPart(placedAssets, "SwallowWing", Vector3.new(2.8, 0.2, 1.1), injuredSwallowMarker.CFrame * CFrame.new(0, 0.15, 0), Color3.fromRGB(222, 226, 234), Enum.Material.SmoothPlastic)
swallowWing.CanCollide = false

local brambleParts = {
	addPart(placedAssets, "BrambleA", Vector3.new(6, 4, 1.2), CFrame.new(villageLayout.heungbu.patchPart.position + Vector3.new(0, 0, -2)), Color3.fromRGB(70, 90, 42), Enum.Material.Grass),
	addPart(placedAssets, "BrambleB", Vector3.new(5, 4.5, 1.2), CFrame.new(villageLayout.heungbu.patchPart.position + Vector3.new(1, 0.2, 1.5)) * CFrame.Angles(0, math.rad(22), 0), Color3.fromRGB(68, 83, 39), Enum.Material.Grass),
	addPart(placedAssets, "BrambleC", Vector3.new(5.5, 3.6, 1.2), CFrame.new(villageLayout.heungbu.patchPart.position + Vector3.new(-1.4, -0.1, 2.4)) * CFrame.Angles(0, math.rad(-18), 0), Color3.fromRGB(84, 98, 48), Enum.Material.Grass),
}
for _, part in ipairs(brambleParts) do part.Transparency = 1 part.CanCollide = false end

local heungbuPadSign = attachBillboard(heungbuPad, "Heungbu Yard", "A small place to plant hope.", Color3.fromRGB(111, 224, 128))
local nolbuPadSign = attachBillboard(nolbuPad, "Nolbu Gate", "His workers patrol the road with stiff little loops.", Color3.fromRGB(226, 117, 94))
attachBillboard(villageWell, "Village Well", "The center of the little valley.", Color3.fromRGB(98, 197, 215))
attachBillboard(marketMat, "Seed Mat", "Pick up a seed pouch if you need one.", Color3.fromRGB(227, 188, 96))
attachBillboard(festivalStone, "Story Stone", "A tale of kindness, greed, and a magic gourd.", Color3.fromRGB(194, 162, 255))
local tributeSign = attachBillboard(tributeBasket, "Tribute Basket", "Nolbu demands proof that your harvest is real.", Color3.fromRGB(240, 154, 107))
local herbSign = attachBillboard(herbPatch, "Herb Garden", "Mint and mugwort grow near the well.", Color3.fromRGB(103, 220, 117))
local swallowSign = attachBillboard(injuredSwallowMarker, "Wall Swallow", "Something small is trembling by Nolbu's wall.", Color3.fromRGB(167, 205, 255))
attachBillboard(clotheslineBeam, "Laundry Line", "Patched cloth dries in the morning wind.", Color3.fromRGB(230, 218, 188))

local patrolANodes = buildWanderRing("NolbuPatrolA", Vector3.new(72, 2, 34), 18, 6)
local patrolBNodes = buildWanderRing("NolbuPatrolB", Vector3.new(92, 2, 30), 14, 5)
if placedByName.NolbuPatrolA then startWanderNpc(placedByName.NolbuPatrolA, { walkSpeed = 8, nodes = patrolANodes }) end
if placedByName.NolbuPatrolB then startWanderNpc(placedByName.NolbuPatrolB, { walkSpeed = 7, nodes = patrolBNodes }) end

local heungbuTalkPart = ensureInteractionPart(villageLayout.heungbu.talkPart.name, villageLayout.heungbu.talkPart.position, villageLayout.heungbu.talkPart.size)
local heungbuPrompt = createPrompt(heungbuTalkPart, "Talk", "Heungbu", 0.2, 14)
local heungbuSign = attachBillboard(heungbuTalkPart, "Heungbu", "He keeps smiling even when the house is quiet.", Color3.fromRGB(111, 224, 128))
local seedPart = ensureInteractionPart("SeedBasket", villageLayout.village.seedMat.position + Vector3.new(0, 1.8, 0), Vector3.new(8, 6, 8))
local seedPrompt = createPrompt(seedPart, "Collect", "Seed Basket", 0.15, 12)
local patchPart = ensureInteractionPart(villageLayout.heungbu.patchPart.name, villageLayout.heungbu.patchPart.position, villageLayout.heungbu.patchPart.size)
local plantPrompt = createPrompt(patchPart, "Plant / Harvest", "Gourd Patch", 0.25, 14)
local patchSign = attachBillboard(patchPart, "Gourd Patch", "Bring a seed, then return when the vine is ready.", Color3.fromRGB(120, 219, 95))
local nolbuTalkPart = ensureInteractionPart(villageLayout.nolbu.talkPart.name, villageLayout.nolbu.talkPart.position, villageLayout.nolbu.talkPart.size)
local nolbuPrompt = createPrompt(nolbuTalkPart, "Listen", "Nolbu", 0.15, 12)
local tributePart = ensureInteractionPart(villageLayout.nolbu.tributePart.name, villageLayout.nolbu.tributePart.position, villageLayout.nolbu.tributePart.size)
local tributePrompt = createPrompt(tributePart, "Offer", "Tribute Basket", 0.15, 12)
local swallowPart = ensureInteractionPart(villageLayout.nolbu.swallowPart.name, villageLayout.nolbu.swallowPart.position, villageLayout.nolbu.swallowPart.size)
local swallowPrompt = createPrompt(swallowPart, "Inspect", "Injured Swallow", 0.1, 12)
local herbPart = ensureInteractionPart("HealingHerbs", villageLayout.village.herbPatch.position + Vector3.new(0, 1.8, 0), Vector3.new(7, 5, 7))
local herbPrompt = createPrompt(herbPart, "Gather", "Healing Herbs", 0.15, 12)
local storyStonePart = ensureInteractionPart("StoryStonePrompt", villageLayout.village.storyStone.position + Vector3.new(0, 1.7, 0), Vector3.new(8, 5, 8))
local storyPrompt = createPrompt(storyStonePart, "Read", "Story Stone", 0.1, 12)
local bramblePart = ensureInteractionPart("BrambleClearPrompt", villageLayout.heungbu.patchPart.position + Vector3.new(0, 1.4, 0), Vector3.new(9, 5, 9))
local bramblePrompt = createPrompt(bramblePart, "Clear", "Brambles", 0.3, 12)
bramblePrompt.Enabled = false

local currentCrop = { state = "empty", owner = nil, readyAt = 0, cropType = "normal" }
local bramblesActive = false
local patchGlowLight = Instance.new("PointLight")
patchGlowLight.Name = "PatchGlow"
patchGlowLight.Brightness = 0
patchGlowLight.Range = 18
patchGlowLight.Color = Color3.fromRGB(255, 225, 150)
patchGlowLight.Parent = gourdPatch

local function setPatchText(text) setBillboardBody(patchSign, text) end

local function setPatchMood(mode)
	if mode == "blessed" then
		gourdPatch.Color = Color3.fromRGB(246, 212, 92)
		gourdPatch.Material = Enum.Material.Neon
		patchGlowLight.Color = Color3.fromRGB(255, 224, 144)
		patchGlowLight.Brightness = 2.1
	elseif mode == "brambles" then
		gourdPatch.Color = Color3.fromRGB(66, 94, 45)
		gourdPatch.Material = Enum.Material.Grass
		patchGlowLight.Color = Color3.fromRGB(170, 112, 96)
		patchGlowLight.Brightness = 0.9
	else
		gourdPatch.Color = Color3.fromRGB(80, 55, 34)
		gourdPatch.Material = Enum.Material.Mud
		patchGlowLight.Color = Color3.fromRGB(255, 225, 150)
		patchGlowLight.Brightness = 0
	end
end

local function setBramblesVisible(visible)
	bramblesActive = visible
	bramblePrompt.Enabled = visible
	for _, part in ipairs(brambleParts) do part.Transparency = visible and 0.18 or 1 end
	setPatchMood(visible and "brambles" or "idle")
	setPatchText(visible and "Thorny brambles choke the patch. Clear them first." or "Bring a seed, then return when the vine is ready.")
end

local function refreshVillageSigns()
	setBillboardBody(heungbuSign, string.format("Deliveries: %d · Swallows helped: %d · Magic opened: %d", villageState.heungbuDeliveries, villageState.swallowHelped, villageState.magicPayoffs))
	if villageState.restorationEndings > 0 then
		setBillboardBody(heungbuPadSign, string.format("The yard stays open to all. Restoration endings: %d · Retaliations weathered: %d", villageState.restorationEndings, villageState.retaliations))
	elseif villageState.tributeEndings > 0 then
		setBillboardBody(heungbuPadSign, string.format("Hope survives, but the harvest now walks a tribute road. Tribute endings: %d", villageState.tributeEndings))
	else
		setBillboardBody(heungbuPadSign, villageState.magicPayoffs > 0 and string.format("The yard glows a little brighter. Retaliations weathered: %d", villageState.retaliations) or string.format("Harvests gathered: %d · Kindness still lives here.", villageState.gourdsHarvested))
	end
	if villageState.tributeEndings > 0 then
		setBillboardBody(nolbuPadSign, string.format("Patrols circling: %d · Tributes demanded: %d · Tribute endings claimed: %d", #patrolANodes + #patrolBNodes, villageState.nolbuTributes, villageState.tributeEndings))
	elseif villageState.restorationEndings > 0 then
		setBillboardBody(nolbuPadSign, string.format("Patrols circling: %d · The gate resents the restored valley.", #patrolANodes + #patrolBNodes))
	else
		setBillboardBody(nolbuPadSign, string.format("Patrols circling: %d · Tributes demanded: %d", #patrolANodes + #patrolBNodes, villageState.nolbuTributes))
	end
	setBillboardBody(tributeSign, villageState.tributeEndings > 0 and string.format("Tributes paid: %d · Nolbu calls this order.", villageState.nolbuTributes) or string.format("Tributes paid: %d · Nolbu still wants more.", villageState.nolbuTributes))
	setBillboardBody(herbSign, string.format("Herb bundles picked: %d · The well garden smells sharp and clean.", villageState.herbBundlesPicked))
	setBillboardBody(swallowSign, villageState.swallowHelped > 0 and "The swallow has been tended. It twitches with a little strength now." or "Something small is trembling by Nolbu's wall.")
end

local function resolveEndingChoice(player, choice)
	local profile = getPlayerProfile(player)
	if profile.endingResolved or not profile.endingSelectionOpen or profile.questStage < QUEST.CHOOSE_ENDING then
		return false
	end
	if choice ~= "restoration" and choice ~= "tribute" then
		return false
	end

	profile.endingSelectionOpen = false
	profile.endingResolved = true
	profile.endingChoice = choice

	if choice == "restoration" then
		profile.seeds += 2
		profile.coins += 6
		villageState.restorationEndings += 1
		setQuestStage(player, QUEST.ENDING_RESTORATION)
	else
		profile.coins += 14
		villageState.tributeEndings += 1
		setQuestStage(player, QUEST.ENDING_TRIBUTE)
	end

	syncPlayerAttributes(player)
	refreshVillageSigns()

	playPresentationSequence(player, {
		choice == "restoration" and {
			onStart = function()
				setPatchMood("idle")
				setPatchText("The patch is protected for everyone who still believes in shared harvests.")
			end,
			effect = {
				kind = "restoration",
				title = "Ending: Restored Valley",
				body = "You stand with Heungbu and protect the harvest for the whole valley.",
				color = Color3.fromRGB(142, 220, 116),
				duration = 5.2,
				pulseCount = 2,
			},
			dialogue = {
				speaker = "Heungbu",
				lines = {
					"Then let this patch stay open, and let the next harvest feed more than fear.",
					"Take these seeds. We will keep the valley warm together.",
				},
				accent = Color3.fromRGB(111, 224, 128),
			},
			delay = 0.6,
		} or {
			onStart = function()
				setPatchMood("idle")
				setPatchText("The patch survives, but everyone now counts what must be paid forward.")
			end,
			effect = {
				kind = "warning",
				title = "Ending: Tribute Road",
				body = "You accept Nolbu's order and keep the valley safe through tribute.",
				color = Color3.fromRGB(226, 117, 94),
				duration = 5.2,
				pulseCount = 2,
			},
			dialogue = {
				speaker = "Nolbu",
				lines = {
					"At last, someone here understands order. Let the harvest come through my gate first.",
					"Take your coin. Peace is expensive, but cheaper than chaos.",
				},
				accent = Color3.fromRGB(226, 117, 94),
			},
			delay = 0.6,
		},
	}, function()
		setQuestStage(player, QUEST.COMPLETE)
		syncPlayerAttributes(player)
		refreshVillageSigns()
	end)

	return true
end

endingChoiceResponseEvent.OnServerEvent:Connect(function(player, choice)
	resolveEndingChoice(player, choice)
end)

refreshVillageSigns()

seedPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	profile.seeds += 1
	if profile.questStage <= QUEST.MEET_HEUNGBU then setQuestStage(player, QUEST.PLANT_FIRST) end
	syncPlayerAttributes(player)
	showDialogue(player, "Seed Basket", { "You take a small seed pouch.", "Maybe this harvest can change the mood of the village." }, Color3.fromRGB(227, 188, 96))
end)

plantPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if bramblesActive then
		showDialogue(player, "Patch", { "Nolbu's brambles are tangled through the soil.", "Clear them before you try planting again." }, Color3.fromRGB(141, 194, 90))
		return
	end
	if currentCrop.state == "empty" then
		local wantsBlessed = profile.blessedSeeds > 0 and profile.questStage >= QUEST.BLESSED_SEED and not profile.magicPayoffDone
		if wantsBlessed then
			profile.blessedSeeds -= 1
			setQuestStage(player, QUEST.GROW_BLESSED)
			currentCrop.state = "growing"
			currentCrop.owner = player
			currentCrop.cropType = "blessed"
			currentCrop.readyAt = os.clock() + 14
			gourdPatch.Color = Color3.fromRGB(229, 191, 76)
			gourdPatch.Material = Enum.Material.Neon
			patchGlowLight.Color = Color3.fromRGB(255, 212, 120)
			patchGlowLight.Brightness = 1.2
			plantPrompt.ObjectText = "Golden Vine"
			setPatchText("A warm golden vine is coiling upward. This is no ordinary crop.")
			syncPlayerAttributes(player)
			showDialogue(player, "Patch", { "Heungbu's blessed seed sinks into the earth.", "A golden vine curls upward as if it already knows the story." }, Color3.fromRGB(244, 210, 102))
			task.delay(14, function()
				if currentCrop.state == "growing" and currentCrop.cropType == "blessed" then
					currentCrop.state = "ready"
					setPatchMood("blessed")
					plantPrompt.ObjectText = "Harvest Magic Gourd"
					setPatchText("The vine glows with a full true magic gourd. Harvest it.")
					if currentCrop.owner then
						setQuestStage(currentCrop.owner, QUEST.HARVEST_BLESSED)
						syncPlayerAttributes(currentCrop.owner)
						showEffect(currentCrop.owner, "banner", "Golden Vine Ready", "The true magic gourd is ready to harvest.", Color3.fromRGB(245, 211, 94))
					end
				end
			end)
			return
		end
		if profile.seeds <= 0 then
			showDialogue(player, "Patch", { "The soil is ready, but your hands are empty.", "Grab another seed from the basket in the village." }, Color3.fromRGB(170, 115, 82))
			return
		end
		profile.seeds -= 1
		setQuestStage(player, QUEST.HARVEST_FIRST)
		currentCrop.state = "growing"
		currentCrop.owner = player
		currentCrop.cropType = "normal"
		currentCrop.readyAt = os.clock() + 20
		gourdPatch.Color = Color3.fromRGB(84, 124, 52)
		gourdPatch.Material = Enum.Material.Grass
		patchGlowLight.Brightness = 0
		setPatchText("A vine is curling out of the soil. Give it a moment.")
		plantPrompt.ObjectText = "Growing..."
		syncPlayerAttributes(player)
		showDialogue(player, "Patch", { "The seed sinks into the earth.", "A green vine begins to wake beneath the soil." }, Color3.fromRGB(120, 219, 95))
		task.delay(20, function()
			if currentCrop.state == "growing" and currentCrop.cropType == "normal" then
				currentCrop.state = "ready"
				gourdPatch.Color = Color3.fromRGB(196, 138, 58)
				gourdPatch.Material = Enum.Material.Sand
				patchGlowLight.Brightness = 0
				setPatchText("The vine is heavy now. The gourd is ready to harvest.")
				plantPrompt.ObjectText = "Harvest Gourd"
			end
		end)
		return
	end
	if currentCrop.state == "growing" then
		showDialogue(player, "Patch", { currentCrop.cropType == "blessed" and "The golden vine is still gathering its warmth." or "Not yet.", currentCrop.cropType == "blessed" and "Give the true magic gourd a little more time." or "The vine still needs a little time." }, currentCrop.cropType == "blessed" and Color3.fromRGB(244, 210, 102) or Color3.fromRGB(120, 219, 95))
		return
	end
	if currentCrop.state == "ready" then
		if currentCrop.cropType == "blessed" then
			profile.blessedGourds += 1
			setQuestStage(player, QUEST.MAGIC_PAYOFF)
			showEffect(player, "blessing", "A True Magic Gourd", "The vine answers Heungbu's kindness. Bring the sacred harvest home.", Color3.fromRGB(245, 211, 94), 4.8, 2)
			showDialogue(player, "Harvest", { "The true magic gourd comes free with a warm golden hum.", "This is no market crop. Bring the sacred harvest back to Heungbu." }, Color3.fromRGB(245, 211, 94))
		else
			profile.gourds += 1
			setQuestStage(player, math.max(profile.questStage, QUEST.DELIVER_FIRST))
			showDialogue(player, "Harvest", { "You lift a ripe gourd from the vine.", "Someone in the village could really use this." }, Color3.fromRGB(235, 179, 92))
		end
		villageState.gourdsHarvested += 1
		currentCrop.state = "empty"
		currentCrop.owner = nil
		currentCrop.readyAt = 0
		currentCrop.cropType = "normal"
		setPatchMood("idle")
		plantPrompt.ObjectText = "Gourd Patch"
		setPatchText("Bring a seed, then return when the vine is ready.")
		syncPlayerAttributes(player)
		refreshVillageSigns()
	end
end)

heungbuPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage <= QUEST.MEET_HEUNGBU then
		setQuestStage(player, QUEST.MEET_HEUNGBU)
		syncPlayerAttributes(player)
		setBillboardBody(heungbuSign, "Heungbu: 'A single healthy gourd would lift the whole house.'")
		showDialogue(player, "Heungbu", { "Our home is plain, but hope still fits inside it.", "Could you grow one good gourd for my family?" }, Color3.fromRGB(111, 224, 128))
		return
	end
	if profile.questStage == QUEST.BRING_HERBS then
		if profile.herbs <= 0 then
			showDialogue(player, "Heungbu", { "The swallow is still breathing, but barely.", "Please bring fresh herbs from the well garden." }, Color3.fromRGB(111, 224, 128))
			return
		end
		profile.herbs -= 1
		profile.coins += 10
		profile.blessedSeeds += 1
		profile.swallowHelped = true
		villageState.swallowHelped += 1
		setQuestStage(player, QUEST.BLESSED_SEED)
		syncPlayerAttributes(player)
		refreshVillageSigns()
		showEffect(player, "banner", "Blessed Seed", "+1 blessed seed from Heungbu", Color3.fromRGB(245, 211, 94))
		showDialogue(player, "Heungbu", { "These herbs will do. My family can bind the swallow's wing.", "Take this blessed seed. The next gourd will not be an ordinary one.", "Plant it in our patch, and bring the true harvest back to me." }, Color3.fromRGB(111, 224, 128))
		return
	end
	if profile.blessedGourds > 0 and profile.questStage >= QUEST.MAGIC_PAYOFF and not profile.magicPayoffDone then
		if profile.presentationBusy then
			showDialogue(player, "Heungbu", { "Wait— let the blessing settle for a breath.", "This miracle should land cleanly, not all at once." }, Color3.fromRGB(111, 224, 128))
			return
		end
		profile.blessedGourds -= 1
		profile.magicPayoffDone = true
		villageState.magicPayoffs += 1
		playPresentationSequence(player, {
			{
				onStart = function()
					setPatchMood("blessed")
					setPatchText("The yard feels warm with a miracle harvest.")
				end,
				effect = {
					kind = "celebration",
					title = "Heungbu's Blessing",
					body = "The village gathers around the miracle harvest.",
					color = Color3.fromRGB(250, 218, 120),
					duration = 4.4,
					pulseCount = 2,
				},
				dialogue = {
					speaker = "Heungbu",
					lines = {
						"A true magic gourd... and it opened for a kind heart.",
						"Even this quiet yard feels full when a blessing arrives like this.",
					},
					accent = Color3.fromRGB(111, 224, 128),
				},
				delay = 1.75,
			},
			{
				onStart = function(_, token)
					local latestProfile = getPlayerProfile(player)
					if latestProfile.activePresentationToken ~= token then
						return
					end
					latestProfile.coins += 20
					latestProfile.seeds += 3
					setQuestStage(player, QUEST.NOLBU_RETALIATION)
					syncPlayerAttributes(player)
					refreshVillageSigns()
				end,
				effect = {
					kind = "celebration",
					title = "Prosperity Spreads",
					body = "You receive coins and blessed seed stock for future hope.",
					color = Color3.fromRGB(255, 224, 138),
					duration = 4.8,
					pulseCount = 2,
				},
				dialogue = {
					speaker = "Heungbu",
					lines = {
						"Take these coins and extra seeds. Let the valley remember this morning.",
						"Nolbu is already staring from his gate. Go hear what envy sounds like.",
					},
					accent = Color3.fromRGB(111, 224, 128),
				},
				delay = 0.5,
			},
		}, function()
			setPatchText("The blessed harvest is over, but the yard still carries its warmth.")
		end)
		return
	end
	if profile.gourds <= 0 then
		if profile.questStage == QUEST.CLAIM_HELP then
			if not profile.bonusSeedsClaimed then profile.seeds += 2 profile.bonusSeedsClaimed = true end
			setQuestStage(player, QUEST.HEAR_NOLBU)
			syncPlayerAttributes(player)
			showDialogue(player, "Heungbu", { "Your kindness reached our table before sunset.", "Take two more seeds. Nolbu has started boasting again at his gate.", "If you hear him out, maybe this story can grow a little further." }, Color3.fromRGB(111, 224, 128))
			return
		end
		if profile.questStage == QUEST.BLESSED_SEED or profile.questStage == QUEST.GROW_BLESSED or profile.questStage == QUEST.HARVEST_BLESSED then
			showDialogue(player, "Heungbu", { "The blessed seed carries a gentler light than the others.", "Plant it in the patch and bring the true magic gourd back to me." }, Color3.fromRGB(111, 224, 128))
			return
		end
		if profile.questStage == QUEST.NOLBU_RETALIATION or profile.questStage == QUEST.CLEAR_BRAMBLES then
			showDialogue(player, "Heungbu", { "The yard is brighter now, but Nolbu's envy will not stay quiet.", "See what he has done, then help me keep the patch alive." }, Color3.fromRGB(111, 224, 128))
			return
		end
		if profile.questStage == QUEST.FINAL_AUDIENCE then
			setQuestStage(player, QUEST.CHOOSE_ENDING)
			profile.endingSelectionOpen = true
			syncPlayerAttributes(player)
			endingChoiceEvent:FireClient(player, {
				title = "The Valley Waits",
				body = "Heungbu asks what kind of harvest should guide the valley now that the brambles are gone.",
				choices = {
					{ id = "restoration", title = "Stand with Heungbu", body = "Protect the patch and share future harvest hope." },
					{ id = "tribute", title = "Appease Nolbu", body = "Offer future harvest tribute to keep a colder peace." },
				},
			})
			showDialogue(player, "Heungbu", { "The thorns are gone, but the valley will remember what comes next.", "Choose what kind of harvest this place should protect." }, Color3.fromRGB(111, 224, 128))
			return
		end
		if profile.questStage == QUEST.CHOOSE_ENDING and not profile.endingResolved then
			showDialogue(player, "Heungbu", { "The valley is still waiting on your answer.", "If you want to protect the shared harvest, choose my path from the final audience panel." }, Color3.fromRGB(111, 224, 128))
			endingChoiceEvent:FireClient(player, {
				title = "Choose the Valley's Path",
				body = "The choice is still open.",
				choices = {
					{ id = "restoration", title = "Stand with Heungbu", body = "Protect the patch and share future harvest hope." },
					{ id = "tribute", title = "Appease Nolbu", body = "Offer future harvest tribute to keep a colder peace." },
				},
			})
			return
		end
		if profile.questStage >= QUEST.COMPLETE then
			showDialogue(player, "Heungbu", profile.endingChoice == "restoration" and { "The valley still feels lighter after your choice.", "Keep the patch alive, and the ending will keep meaning something." } or profile.endingChoice == "tribute" and { "We still plant, even under another man's count.", "If you keep growing, perhaps one day the valley can ask for more than peace." } or { "The patch is breathing again.", "If you keep planting, the story can stay alive a while longer." }, Color3.fromRGB(111, 224, 128))
			return
		end
		showDialogue(player, "Heungbu", { "I can wait, but the house is still hungry for good news.", "Bring a ripe gourd when you have one." }, Color3.fromRGB(111, 224, 128))
		return
	end
	profile.gourds -= 1
	profile.coins += 5
	profile.heungbuDeliveries += 1
	villageState.heungbuDeliveries += 1
	if profile.questStage <= QUEST.DELIVER_FIRST then setQuestStage(player, QUEST.CLAIM_HELP) elseif profile.questStage >= QUEST.COMPLETE then profile.coins += 1 end
	syncPlayerAttributes(player)
	refreshVillageSigns()
	showDialogue(player, "Heungbu", profile.questStage == QUEST.CLAIM_HELP and { "You brought back exactly what we needed.", "Please, talk to me once more. I have seeds to spare and a warning about Nolbu." } or { "Another good gourd! You keep this valley cheerful.", "Please take these coins with my thanks." }, Color3.fromRGB(111, 224, 128))
end)

nolbuPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.HEAR_NOLBU then
		setQuestStage(player, QUEST.MEET_HEUNGBU)
		syncPlayerAttributes(player)
		showDialogue(player, "Nolbu", { "Even my gate has more attention than Heungbu's entire house.", "Run along. I only speak with people carrying results." }, Color3.fromRGB(226, 117, 94))
		return
	end
	if profile.questStage == QUEST.HEAR_NOLBU then
		setQuestStage(player, QUEST.DELIVER_TRIBUTE)
		syncPlayerAttributes(player)
		showDialogue(player, "Nolbu", { "So Heungbu found help? Hah.", "If your harvest is truly special, put one gourd in my tribute basket.", "Then I might stop sneering long enough to notice you." }, Color3.fromRGB(226, 117, 94))
		return
	end
	if profile.questStage >= QUEST.INVESTIGATE_SWALLOW and not profile.swallowHelped then
		showDialogue(player, "Nolbu", { "A bird hit my wall. Hardly my problem.", "If Heungbu wants to play healer, let him waste his morning on it." }, Color3.fromRGB(226, 117, 94))
		return
	end
	if profile.questStage == QUEST.NOLBU_RETALIATION and not profile.retaliationTriggered then
		profile.retaliationTriggered = true
		villageState.retaliations += 1
		setQuestStage(player, QUEST.CLEAR_BRAMBLES)
		setBramblesVisible(true)
		syncPlayerAttributes(player)
		refreshVillageSigns()
		playPresentationSequence(player, {
			{
				effect = {
					kind = "warning",
					title = "Jealous Eyes Turn Here",
					body = "Nolbu sees the miracle and vows to ruin the patch.",
					color = Color3.fromRGB(226, 117, 94),
					duration = 4.2,
					pulseCount = 2,
				},
				dialogue = {
					speaker = "Nolbu",
					lines = {
						"A magic gourd in that shabby yard? Ridiculous.",
						"If Heungbu's patch grows miracles now, it can grow through thorns too.",
						"Go back and look. Envy leaves marks.",
					},
					accent = Color3.fromRGB(226, 117, 94),
				},
				delay = 0.25,
			},
		}, nil)
		return
	end
	if profile.questStage == QUEST.FINAL_AUDIENCE then
		showDialogue(player, "Nolbu", {
			"So the patch survived. Fine. Survival still needs someone willing to count the cost.",
			"Hear Heungbu out if you must, but do not pretend kindness is the only way to keep a valley standing.",
		}, Color3.fromRGB(226, 117, 94))
		return
	end
	if profile.questStage == QUEST.CHOOSE_ENDING and not profile.endingResolved then
		endingChoiceEvent:FireClient(player, {
			title = "Choose the Valley's Path",
			body = "Nolbu presses for tribute. Heungbu asks you to protect a shared harvest.",
			choices = {
				{ id = "restoration", title = "Stand with Heungbu", body = "Protect the patch and share future harvest hope." },
				{ id = "tribute", title = "Appease Nolbu", body = "Offer future harvest tribute to keep a colder peace." },
			},
		})
		showDialogue(player, "Nolbu", {
			"If you want peace, choose the road that pays for it.",
			"Heungbu calls it cold. I call it stable.",
		}, Color3.fromRGB(226, 117, 94))
		return
	end
	if profile.questStage >= QUEST.COMPLETE then
		showDialogue(player, "Nolbu", profile.endingChoice == "tribute" and {
			"You chose the road that keeps the loudest quarrels quiet.",
			"Keep the tribute moving and even this valley can look orderly.",
		} or profile.endingChoice == "restoration" and {
			"You chose Heungbu's warmth over my order.",
			"Do not act surprised if a generous valley still needs defending.",
		} or {
			"The village keeps moving, with or without a proper accountant.",
		}, Color3.fromRGB(226, 117, 94))
		return
	end
	showDialogue(player, "Nolbu", { string.format("My estate still has %d patrol steps and %d reasons to stay impressed.", #patrolANodes + #patrolBNodes, villageState.nolbuTributes), profile.retaliationTriggered and "If Heungbu cannot keep brambles out, perhaps he does not deserve a harvest." or "If you have a spare gourd, the basket is right there." }, Color3.fromRGB(226, 117, 94))
end)

tributePrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.DELIVER_TRIBUTE then
		showDialogue(player, "Tribute Basket", { "The basket sits empty.", "Nolbu has not asked anything from you yet." }, Color3.fromRGB(240, 154, 107))
		return
	end
	if profile.questStage >= QUEST.INVESTIGATE_SWALLOW then
		showDialogue(player, "Tribute Basket", { "The tribute is already paid.", "Something more important is happening by the wall." }, Color3.fromRGB(240, 154, 107))
		return
	end
	if profile.gourds <= 0 then
		showDialogue(player, "Tribute Basket", { "You have nothing to offer.", "Grow another gourd first." }, Color3.fromRGB(240, 154, 107))
		return
	end
	profile.gourds -= 1
	profile.coins += 8
	profile.nolbuTributes += 1
	villageState.nolbuTributes += 1
	setQuestStage(player, QUEST.INVESTIGATE_SWALLOW)
	syncPlayerAttributes(player)
	refreshVillageSigns()
	showDialogue(player, "Nolbu", { "Hmph. At least the harvest looks worthy.", "Take your coin and move aside— ah, what was that fluttering by the wall?", "If you must fuss over it, do it somewhere else." }, Color3.fromRGB(226, 117, 94))
end)

swallowPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.INVESTIGATE_SWALLOW then
		showDialogue(player, "Swallow", { "A little nest clings to the wall.", "Nothing has happened here yet." }, Color3.fromRGB(167, 205, 255))
		return
	end
	if profile.swallowHelped then
		showDialogue(player, "Swallow", { "The swallow blinks and settles into the nest.", "It still looks fragile, but it is no longer alone." }, Color3.fromRGB(167, 205, 255))
		return
	end
	if not profile.swallowInspected then
		profile.swallowInspected = true
		setQuestStage(player, QUEST.GATHER_HERBS)
		syncPlayerAttributes(player)
		setBillboardBody(swallowSign, "A swallow lies here with a bent wing. Heungbu might know how to help.")
		showDialogue(player, "Swallow", { "A swallow is shivering against the wall, one wing hanging low.", "There is a faint thread tied to its leg—as if it nested near Heungbu's yard before.", "Fresh herbs from the well garden might keep it alive long enough to carry home." }, Color3.fromRGB(167, 205, 255))
		return
	end
	showDialogue(player, "Swallow", { "The bird gives a weak flutter.", "It still needs healing herbs from the village well." }, Color3.fromRGB(167, 205, 255))
end)

herbPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.GATHER_HERBS then
		showDialogue(player, "Herb Garden", { "The herb patch smells fresh and sharp.", "You do not need anything from it yet." }, Color3.fromRGB(103, 220, 117))
		return
	end
	if profile.questStage > QUEST.BRING_HERBS then
		showDialogue(player, "Herb Garden", { "The leaves sway quietly by the well.", "For now, the village only asks you to keep growing." }, Color3.fromRGB(103, 220, 117))
		return
	end
	if profile.herbs > 0 then
		showDialogue(player, "Herb Garden", { "You already gathered a fresh bundle.", "Bring it to Heungbu before the leaves wilt." }, Color3.fromRGB(103, 220, 117))
		return
	end
	profile.herbs += 1
	villageState.herbBundlesPicked += 1
	setQuestStage(player, QUEST.BRING_HERBS)
	syncPlayerAttributes(player)
	refreshVillageSigns()
	showDialogue(player, "Herb Garden", { "You gather a careful bundle of healing herbs.", "The leaves are cool with well mist.", "Bring them to Heungbu before the swallow fades." }, Color3.fromRGB(103, 220, 117))
end)

bramblePrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if not bramblesActive or profile.questStage < QUEST.CLEAR_BRAMBLES then
		showDialogue(player, "Brambles", { "The patch is not tangled right now." }, Color3.fromRGB(142, 196, 94))
		return
	end
	profile.bramblesCleared = true
	profile.seeds += 1
	profile.coins += 4
	profile.endingSelectionOpen = false
	setBramblesVisible(false)
	syncPlayerAttributes(player)
	refreshVillageSigns()
	playPresentationSequence(player, {
		{
			onStart = function()
				setPatchText("Fresh air returns to the patch. The soil can breathe again.")
			end,
			effect = {
				kind = "restoration",
				title = "Hope Returns",
				body = "The patch breathes again. Kindness still grows here.",
				color = Color3.fromRGB(142, 220, 116),
				duration = 4.8,
				pulseCount = 1,
			},
			dialogue = {
				speaker = "Heungbu",
				lines = {
					"You cleared the patch before the thorns could win.",
					"Kindness grows back faster than spite here.",
					"Take one more seed. The valley can keep going now.",
				},
				accent = Color3.fromRGB(111, 224, 128),
			},
			delay = 0.2,
		},
	}, function()
		setQuestStage(player, QUEST.FINAL_AUDIENCE)
		syncPlayerAttributes(player)
		setPatchText("The patch is breathing again. Return to Heungbu and decide what kind of harvest the valley will protect.")
		showDialogue(player, "Village", {
			"The brambles are gone, but the story has not settled yet.",
			"Return to Heungbu's yard for the valley's final audience.",
		}, Color3.fromRGB(194, 162, 255))
	end)
end)

storyPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage == QUEST.INTRO then setQuestStage(player, QUEST.MEET_HEUNGBU) syncPlayerAttributes(player) end
	showDialogue(player, "Story Stone", {
		"In this valley, kindness grows quietly and greed makes a lot of noise.",
		villageState.magicPayoffs > 0 and "A true magic gourd has already opened once here. Envy heard it from across the road." or "A single magic gourd can push their story forward, but even a swallow can change the ending.",
		"Heungbu shares what little he has. Nolbu counts what everyone else owes.",
	}, Color3.fromRGB(194, 162, 255))
end)