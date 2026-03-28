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

local endingAccentFolder = runtimeFolder:FindFirstChild("EndingAccentProps") or Instance.new("Folder")
endingAccentFolder.Name = "EndingAccentProps"
endingAccentFolder.Parent = runtimeFolder

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
	STABILIZE_VALLEY = 17,
	FINAL_AUDIENCE = 18,
	CHOOSE_ENDING = 19,
	ENDING_RESTORATION = 20,
	ENDING_TRIBUTE = 21,
	COMPLETE = 22,
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
	[QUEST.STABILIZE_VALLEY] = "Steady the Valley",
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
	[QUEST.STABILIZE_VALLEY] = "Repair the damaged yard marker near Heungbu's house.",
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
	sharedHarvestDrops = 0,
	tributeDuesPaid = 0,
}

local AMBIENT_ENDING = {
	NONE = "none",
	RESTORATION = "restoration",
	TRIBUTE = "tribute",
}

local ENDING_SUPPORT_ROTATION_THRESHOLD = 2
local ENDING_LANDMARK_TIER_ONE_THRESHOLD = 3
local ENDING_LANDMARK_TIER_TWO_THRESHOLD = 6

local ENDING_SUPPORT_POINTS = {
	restoration = {
		{ id = "sharedBasket", name = "Shared Basket", hint = "Shared harvests are being gathered at the basket by the well.", redirect = "The next shared drop is being gathered somewhere else in the village." },
		{ id = "wellPantry", name = "Well Pantry Drop", hint = "Shared harvests are being gathered by the well pantry drop.", redirect = "The well pantry is resting. The next shared drop is being gathered elsewhere." },
		{ id = "yardRelief", name = "Yard Relief Mat", hint = "Heungbu's yard marker now serves as the next relief drop.", redirect = "The relief mat is quiet for now. The next shared drop is being gathered elsewhere." },
	},
	tribute = {
		{ id = "roadStand", name = "Road Due", hint = "The next road due is being counted at the stand by Nolbu's road.", redirect = "Today's road due is being counted at another stand." },
		{ id = "gateTally", name = "Gate Tally Point", hint = "The next road due is being counted by Nolbu's gate.", redirect = "The gate tally point is idle. Today's road due is being counted elsewhere." },
		{ id = "routeMarker", name = "Route Marker Due", hint = "The road's route marker is collecting today's due.", redirect = "That marker is only keeping watch. Today's road due is being counted elsewhere." },
	},
}

local ENDING_WITNESSES = {
	wellNeighbor = {
		branch = "restoration",
		speaker = "Well Neighbor",
		title = "Well Neighbor",
		prompt = "Check In",
		color = Color3.fromRGB(142, 220, 116),
		generic = {
			"The well mostly trades little rumors and water still.",
			"If the valley changes again, people here will notice before the signs do.",
		},
		base = {
			{ "Someone left another gourd by the well. Feels like the village has started trusting tomorrow again.", "Shared food looks small until the day someone actually needs it." },
			{ "The well pantry makes kindness look ordinary.", "That is how a restored valley starts feeling real instead of ceremonial." },
			{ "People come here for water and leave talking about supper.", "That is a better story than fear ever managed." },
		},
		tier1 = {
			{ "The pantry is staying stocked between drops now.", "You can hear it in the way people stop worrying out loud." },
			{ "Relief is turning into routine by the well.", "That makes the whole village breathe easier." },
		},
		tier2 = {
			{ "The well has started looking like a place that expects abundance to return.", "Even the quiet here sounds more confident." },
			{ "These stores are not for show anymore.", "The village trusts the next shared harvest will actually arrive." },
		},
		pointLines = {
			wellPantry = {
				{ "The pantry is taking the next drop itself today.", "That keeps the middle path feeling cared for." },
			},
		},
	},
	yardHelper = {
		branch = "restoration",
		speaker = "Yard Helper",
		title = "Yard Helper",
		prompt = "Listen",
		color = Color3.fromRGB(142, 220, 116),
		generic = {
			"Heungbu's yard is quiet, but never empty for long.",
			"People keep an eye on this corner whenever the valley grows hopeful.",
		},
		base = {
			{ "Heungbu's yard used to just endure. Now even this corner passes food onward.", "A repaired marker means more when it helps more than one family." },
			{ "The mat makes this yard feel less private and more trusted.", "That is the kind of change people remember." },
			{ "It is easier to believe in the patch when the yard shares with it.", "Kindness looks sturdier when it leaves supplies behind." },
		},
		tier1 = {
			{ "There are small relief bundles here now, not just good intentions.", "That is when recovery starts feeling dependable." },
		},
		tier2 = {
			{ "This marker used to point at one house. Now it feels like it points at the whole valley.", "That is what restored trust looks like." },
			{ "The yard has become the sort of place neighbors expect to help from.", "That is bigger than any single harvest." },
		},
		pointLines = {
			yardRelief = {
				{ "The active drop shifted to the yard today.", "People will notice before sunset that this house keeps passing relief onward." },
			},
		},
	},
	roadClerk = {
		branch = "tribute",
		speaker = "Road Clerk",
		title = "Road Clerk",
		prompt = "Check Count",
		color = Color3.fromRGB(226, 117, 94),
		generic = {
			"The road stays quiet when no one gives it a reason not to.",
			"People read the tally points before they read each other these days.",
		},
		base = {
			{ "The due moved to the road again. Best not arrive empty-handed when the count is this close.", "No one argues much once the stand is already waiting." },
			{ "Funny how fast a road starts feeling official once every marker learns to ask.", "Order travels faster than comfort." },
			{ "Counted harvests keep the patrols calm.", "That is not warmth, but it is the arrangement people understand." },
		},
		tier1 = {
			{ "The tally routine is settling in now.", "People speak about the road due like weather—annoying, familiar, and hard to refuse." },
		},
		tier2 = {
			{ "The road does not even need to raise its voice anymore.", "Tribute has started sounding like habit." },
			{ "You can tell the order has sunk in when the stand looks almost ordinary.", "That is how supervision wins." },
		},
		pointLines = {
			roadStand = {
				{ "Today's count is anchored right here by the road stand.", "The closer the due stays to the road, the faster everyone falls in line." },
			},
		},
	},
	gateWatcher = {
		branch = "tribute",
		speaker = "Gate Watcher",
		title = "Gate Watcher",
		prompt = "Listen",
		color = Color3.fromRGB(226, 117, 94),
		generic = {
			"Nolbu's gate never forgets to look official.",
			"Even on quiet days, the road learns its manners here.",
		},
		base = {
			{ "No one argues when the tally is already waiting for them at the gate.", "That is the sort of order Nolbu likes best." },
			{ "The gate makes every harvest feel inspected before it even arrives.", "People stand straighter here without meaning to." },
			{ "A due counted at the gate sounds final in a different way.", "The road starts at the house, and so does the pressure." },
		},
		tier1 = {
			{ "The gate tally is becoming part of the village routine.", "Cold habits are still habits once enough people obey them." },
		},
		tier2 = {
			{ "The gate looks less like a checkpoint now and more like a permanent office.", "That is not a comforting improvement." },
			{ "Even silence feels supervised when the tally post settles in this deeply.", "Tribute has learned to decorate itself." },
		},
		pointLines = {
			gateTally = {
				{ "The active due shifted to Nolbu's gate today.", "That makes the count feel personal before it feels public." },
			},
			routeMarker = {
				{ "The route marker is claiming the next due, but the gate still makes everyone think twice.", "Once a tally culture settles in, every stop starts helping the others." },
			},
		},
	},
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
		padYaw = villageLayout.heungbu.housePad.yaw,
		orientationCorrection = Vector3.new(90, 0, 0),
		yawOffset = -2,
		groundOffset = 0,
		visualOffset = Vector3.new(0, 0, -2),
		fallbackFootprint = Vector3.new(34, 18, 26),
		narrativeRole = "humble",
		frontClearance = 4,
		talkOffset = Vector3.new(0, 5, 2.5),
		yardMarkerOffset = Vector3.new(7, 0.8, -6),
	},
	NolbuHouse = {
		padName = villageLayout.nolbu.yardPad.name,
		padPosition = villageLayout.nolbu.yardPad.position,
		padYaw = villageLayout.nolbu.yardPad.yaw,
		orientationCorrection = Vector3.new(90, 0, 0),
		yawOffset = 2,
		groundOffset = 0,
		visualOffset = Vector3.new(0, 0, -8),
		fallbackFootprint = Vector3.new(42, 22, 30),
		narrativeRole = "imposing",
		frontClearance = 5,
		talkOffset = Vector3.new(0, 5, 2),
		tributeOffset = Vector3.new(10, -1.6, 8),
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
		valleyStabilized = false,
		endingChoice = "none",
		endingResolved = false,
		endingSelectionOpen = false,
		activePresentationToken = 0,
		presentationBusy = false,
		ambientDialogueCursor = {},
		witnessDialogueCursor = {},
		sharedHarvestDrops = 0,
		tributeDuesPaid = 0,
		restorationSupportPointIndex = 1,
		tributeSupportPointIndex = 1,
		restorationRotationStep = 0,
		tributeRotationStep = 0,
		endingErrandCooldownAt = 0,
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

local function getSupportPointList(errandKind)
	return ENDING_SUPPORT_POINTS[errandKind] or {}
end

local function getEndingLandmarkTierFromCount(count)
	if count >= ENDING_LANDMARK_TIER_TWO_THRESHOLD then
		return 2
	elseif count >= ENDING_LANDMARK_TIER_ONE_THRESHOLD then
		return 1
	end
	return 0
end

local function getEndingLandmarkTier(profile, errandKind)
	if errandKind == "restoration" then
		local drops = profile and profile.sharedHarvestDrops or 0
		return getEndingLandmarkTierFromCount(drops)
	elseif errandKind == "tribute" then
		local dues = profile and profile.tributeDuesPaid or 0
		return getEndingLandmarkTierFromCount(dues)
	end
	return 0
end

local function getVillageEndingLandmarkTier(errandKind)
	if errandKind == "restoration" then
		return getEndingLandmarkTierFromCount(villageState.sharedHarvestDrops)
	elseif errandKind == "tribute" then
		return getEndingLandmarkTierFromCount(villageState.tributeDuesPaid)
	end
	return 0
end

local function getActiveVillageSupportPointId(errandKind)
	local points = getSupportPointList(errandKind)
	if #points == 0 then
		return nil
	end
	local count = errandKind == "restoration" and villageState.sharedHarvestDrops or villageState.tributeDuesPaid
	local index = ((count // ENDING_SUPPORT_ROTATION_THRESHOLD) % #points) + 1
	return points[index].id
end

local function getActiveSupportPoint(profile, errandKind)
	local points = getSupportPointList(errandKind)
	if #points == 0 then
		return nil, 0
	end

	local index = errandKind == "restoration" and profile.restorationSupportPointIndex or profile.tributeSupportPointIndex
	if type(index) ~= "number" or index < 1 or index > #points then
		index = 1
		if errandKind == "restoration" then
			profile.restorationSupportPointIndex = index
		else
			profile.tributeSupportPointIndex = index
		end
	end

	return points[index], index
end

local function getEndingHint(choice, profile)
	if choice == "restoration" then
		local drops = profile and profile.sharedHarvestDrops or 0
		local activePoint = profile and getActiveSupportPoint(profile, "restoration") or nil
		local activeHint = activePoint and activePoint.hint or "Shared harvests are being gathered near the well."
		local tier = getEndingLandmarkTier(profile, "restoration")
		if tier >= 2 then
			return string.format("Ending: Restored Valley · The valley now keeps visible stores near its shared drop points (%d drops). %s", drops, activeHint)
		elseif tier >= 1 then
			return string.format("Ending: Restored Valley · The village pantry is starting to stay stocked between shared drops (%d drops). %s", drops, activeHint)
		end
		return string.format("Ending: Restored Valley · Shared harvests are being gathered near the well (%d drops). %s", drops, activeHint)
	elseif choice == "tribute" then
		local dues = profile and profile.tributeDuesPaid or 0
		local activePoint = profile and getActiveSupportPoint(profile, "tribute") or nil
		local activeHint = activePoint and activePoint.hint or "The next road due is being counted by Nolbu's road."
		local tier = getEndingLandmarkTier(profile, "tribute")
		if tier >= 2 then
			return string.format("Ending: Tribute Road · The road's due now reads like a standing village habit (%d dues). %s", dues, activeHint)
		elseif tier >= 1 then
			return string.format("Ending: Tribute Road · Nolbu's tally points are settling into a stricter routine (%d dues). %s", dues, activeHint)
		end
		return string.format("Ending: Tribute Road · The next road due is being counted nearby (%d dues). %s", dues, activeHint)
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
	player:SetAttribute("QuestHint", getEndingHint(profile.endingChoice, profile))
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

local function getPlayerAmbientEndingChoice(player)
	local profile = getPlayerProfile(player)
	if profile.endingResolved and (profile.endingChoice == AMBIENT_ENDING.RESTORATION or profile.endingChoice == AMBIENT_ENDING.TRIBUTE) then
		return profile.endingChoice
	end
	return AMBIENT_ENDING.NONE
end

local function getVillageAmbientEndingChoice()
	if villageState.restorationEndings > 0 or villageState.tributeEndings > 0 then
		if villageState.restorationEndings >= villageState.tributeEndings then
			return AMBIENT_ENDING.RESTORATION
		end
		return AMBIENT_ENDING.TRIBUTE
	end
	return AMBIENT_ENDING.NONE
end

local function getNextAmbientLine(player, key, lines)
	local profile = getPlayerProfile(player)
	profile.ambientDialogueCursor[key] = (profile.ambientDialogueCursor[key] or 0) + 1
	local index = ((profile.ambientDialogueCursor[key] - 1) % #lines) + 1
	return lines[index]
end

local function getWitnessContext(player, witnessId)
	local profile = getPlayerProfile(player)
	local witness = ENDING_WITNESSES[witnessId]
	if not witness then
		return nil, profile
	end

	local tier = getEndingLandmarkTier(profile, witness.branch)
	local activePoint = getActiveSupportPoint(profile, witness.branch)
	return {
		branch = witness.branch,
		tier = tier,
		activePointId = activePoint and activePoint.id or nil,
		endingResolved = profile.endingResolved,
		questStage = profile.questStage,
		endingChoice = profile.endingChoice,
	}, profile
end

local function getWitnessLineSet(player, witnessId)
	local witness = ENDING_WITNESSES[witnessId]
	if not witness then
		return { "The village has nothing clear to say here yet." }
	end

	local context, profile = getWitnessContext(player, witnessId)
	if not context then
		return witness.generic
	end

	if context.questStage < QUEST.COMPLETE or not context.endingResolved or context.endingChoice ~= witness.branch then
		return witness.generic
	end

	local pools = {}
	if witness.pointLines and context.activePointId and witness.pointLines[context.activePointId] then
		table.insert(pools, witness.pointLines[context.activePointId])
	end
	if context.tier >= 2 and witness.tier2 then
		table.insert(pools, witness.tier2)
	end
	if context.tier >= 1 and witness.tier1 then
		table.insert(pools, witness.tier1)
	end
	if witness.base then
		table.insert(pools, witness.base)
	end

	local merged = {}
	for _, pool in ipairs(pools) do
		for _, lines in ipairs(pool) do
			table.insert(merged, lines)
		end
	end
	if #merged == 0 then
		return witness.generic
	end

	profile.witnessDialogueCursor[witnessId] = (profile.witnessDialogueCursor[witnessId] or 0) + 1
	local index = ((profile.witnessDialogueCursor[witnessId] - 1) % #merged) + 1
	return merged[index]
end

local function playWitnessBark(player, witnessId)
	local witness = ENDING_WITNESSES[witnessId]
	if not witness then
		return
	end
	showDialogue(player, witness.speaker, getWitnessLineSet(player, witnessId), witness.color)
end

local refreshVillageSigns
local updateEndingSupportSigns
local updateEndingWitnessSigns

local function advanceEndingSupportPoint(profile, errandKind)
	local points = getSupportPointList(errandKind)
	if #points <= 1 then
		return nil, nil
	end

	local indexField = errandKind == "restoration" and "restorationSupportPointIndex" or "tributeSupportPointIndex"
	local oldPoint = points[profile[indexField]] or points[1]
	local nextIndex = (profile[indexField] % #points) + 1
	profile[indexField] = nextIndex
	return oldPoint, points[nextIndex]
end

local function canUseEndingErrand(player, errandKind, pointId)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.COMPLETE or not profile.endingResolved then
		return false, "The village is still deciding what your ending means."
	end
	local requiredChoice = errandKind == "restoration" and AMBIENT_ENDING.RESTORATION or AMBIENT_ENDING.TRIBUTE
	if profile.endingChoice ~= requiredChoice then
		return false, errandKind == "restoration"
			and "This basket belongs to the valley Heungbu protected, not the road you chose."
			or "This road due belongs to Nolbu's counted ending, not the valley you chose to restore."
	end

	local activePoint = getActiveSupportPoint(profile, errandKind)
	if pointId and activePoint and activePoint.id ~= pointId then
		return false, activePoint.redirect
	end

	if profile.gourds <= 0 then
		return false, errandKind == "restoration"
			and "Bring one fresh gourd if you want to leave something for the village."
			or "Bring one fresh gourd if you want to keep the road settled."
	end
	if profile.endingErrandCooldownAt > os.clock() then
		return false, errandKind == "restoration"
			and "Let the basket settle for a breath before you leave another shared harvest."
			or "The tally stand is still being marked. Give it a breath before the next due."
	end
	return true, nil, activePoint
end

local function completeEndingErrand(player, errandKind, pointId)
	local profile = getPlayerProfile(player)
	local ok, message, activePoint = canUseEndingErrand(player, errandKind, pointId)
	if not ok then
		return false, message
	end

	profile.gourds -= 1
	profile.endingErrandCooldownAt = os.clock() + 2.5

	local rewardSummary
	local ambientLineKey
	local milestoneLine
	local milestoneEffect
	local rotatedFromPoint
	local rotatedToPoint

	if errandKind == "restoration" then
		profile.coins += 2
		profile.sharedHarvestDrops += 1
		villageState.sharedHarvestDrops += 1
		rewardSummary = "+2 coins"
		ambientLineKey = "RestorationErrand"

		if profile.sharedHarvestDrops % 3 == 0 then
			profile.seeds += 1
			rewardSummary = rewardSummary .. " · +1 seed returned"
			milestoneLine = {
				"Someone has tucked a good seed back into the basket for the next planter.",
				"That is what a shared harvest becomes when the valley starts trusting itself again.",
			}
			milestoneEffect = {
				kind = "restoration",
				title = "Shared Harvest Grows Back",
				body = "+2 coins · +1 seed returned by the village.",
				color = Color3.fromRGB(142, 220, 116),
				duration = 4,
				pulseCount = 2,
			}
		end
	else
		profile.coins += 3
		profile.tributeDuesPaid += 1
		villageState.tributeDuesPaid += 1
		rewardSummary = "+3 coins"
		ambientLineKey = "TributeErrand"

		if profile.tributeDuesPaid % 3 == 0 then
			profile.coins += 1
			rewardSummary = rewardSummary .. " · +1 inspection coin"
			milestoneLine = {
				"The stand marks your name with practiced approval and slides one extra coin back.",
				"Steady tribute makes the road feel even colder, but undeniably smoother.",
			}
			milestoneEffect = {
				kind = "warning",
				title = "Road Count Recognized",
				body = "+3 coins · +1 inspection coin for reliable tribute.",
				color = Color3.fromRGB(226, 117, 94),
				duration = 4,
				pulseCount = 2,
			}
		end
	end

	local rotationStepField = errandKind == "restoration" and "restorationRotationStep" or "tributeRotationStep"
	profile[rotationStepField] += 1
	if profile[rotationStepField] >= ENDING_SUPPORT_ROTATION_THRESHOLD then
		profile[rotationStepField] = 0
		rotatedFromPoint, rotatedToPoint = advanceEndingSupportPoint(profile, errandKind)
	end

	syncPlayerAttributes(player)
	refreshVillageSigns()
	return true, rewardSummary, ambientLineKey, milestoneLine, milestoneEffect, activePoint, rotatedFromPoint, rotatedToPoint
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
	local padYaw = spec.padYaw or (def.rotation and def.rotation.Y) or 0
	local yawOffset = spec.yawOffset or 0
	local facingYaw = spec.facingYaw or (padYaw + yawOffset)
	local visualOffset = spec.visualOffset or Vector3.zero
	local facingCf = CFrame.new(anchorPosition) * CFrame.Angles(0, math.rad(facingYaw), 0)
	local worldOffset = facingCf:VectorToWorldSpace(visualOffset)
	local worldPosition = Vector3.new(
		anchorPosition.X + worldOffset.X,
		(spec.position and spec.position.Y) or anchorPosition.Y + visualOffset.Y,
		anchorPosition.Z + worldOffset.Z
	)
	local frontClearance = spec.frontClearance or 0

	return {
		padName = spec.padName,
		padPosition = anchorPosition,
		padYaw = padYaw,
		position = worldPosition,
		orientationCorrection = spec.orientationCorrection or Vector3.zero,
		facingYaw = facingYaw,
		groundOffset = spec.groundOffset or 0,
		visualOffset = visualOffset,
		fallbackFootprint = spec.fallbackFootprint,
		narrativeRole = spec.narrativeRole,
		frontClearance = frontClearance,
	}
end

local function stampHousePlacementAttributes(instance, placement, boxCf, boxSize)
	if not placement then
		return
	end

	if placement.padName then
		instance:SetAttribute("PlacementPad", placement.padName)
	end
	if placement.narrativeRole then
		instance:SetAttribute("NarrativeRole", placement.narrativeRole)
	end
	instance:SetAttribute("FacingYaw", placement.facingYaw or 0)
	instance:SetAttribute("GroundY", (placement.padPosition and placement.padPosition.Y) or 0)
	instance:SetAttribute("BoundsCenterX", boxCf.Position.X)
	instance:SetAttribute("BoundsCenterY", boxCf.Position.Y)
	instance:SetAttribute("BoundsCenterZ", boxCf.Position.Z)
	instance:SetAttribute("BoundsSizeX", boxSize.X)
	instance:SetAttribute("BoundsSizeY", boxSize.Y)
	instance:SetAttribute("BoundsSizeZ", boxSize.Z)
	instance:SetAttribute("TopY", boxCf.Position.Y + (boxSize.Y / 2))

	local clearance = placement.frontClearance or 0
	local frontDirection = CFrame.Angles(0, math.rad(placement.facingYaw or 0), 0).LookVector
	local frontPosition = boxCf.Position + (frontDirection * ((boxSize.Z / 2) + clearance))
	instance:SetAttribute("FrontX", frontPosition.X)
	instance:SetAttribute("FrontY", frontPosition.Y)
	instance:SetAttribute("FrontZ", frontPosition.Z)
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
	model.Parent = placedAssets
	local boxCf, boxSize = model:GetBoundingBox()
	stampHousePlacementAttributes(model, placement, boxCf, boxSize)
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
	local groundY = (placement and placement.padPosition and placement.padPosition.Y) or (def.position and def.position.Y) or 0
	local groundOffset = placement and placement.groundOffset or def.groundOffset or 0
	local orientationCf = CFrame.Angles(math.rad(correction.X), 0, math.rad(correction.Z))
	local yawCf = CFrame.Angles(0, math.rad(facingYaw), 0)
	local cf = CFrame.new(targetPosition) * yawCf * orientationCf

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
		boxCf, boxSize = candidate:GetBoundingBox()
		stampHousePlacementAttributes(candidate, placement, boxCf, boxSize)
		return true
	elseif candidate:IsA("BasePart") then
		if typeof(def.scale) == "number" and def.scale > 0 and def.scale ~= 1 then candidate.Size = candidate.Size * def.scale end
		candidate.CFrame = cf
		candidate.Anchored = true
		local bottomY = candidate.Position.Y - (candidate.Size.Y / 2)
		local lift = groundY - bottomY + groundOffset
		candidate.Position += Vector3.new(0, lift, 0)
		if placement then
			candidate:SetAttribute("PlacementPad", placement.padName)
			candidate:SetAttribute("FacingYaw", placement.facingYaw)
		end
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

local function getHouseFrontPosition(name, fallbackPosition)
	local house = placedByName[name]
	if not house then
		return fallbackPosition
	end

	local frontX = house:GetAttribute("FrontX")
	local frontY = house:GetAttribute("FrontY")
	local frontZ = house:GetAttribute("FrontZ")
	if typeof(frontX) == "number" and typeof(frontY) == "number" and typeof(frontZ) == "number" then
		return Vector3.new(frontX, frontY, frontZ)
	end

	return fallbackPosition
end

local function getHouseFacingYaw(name, fallbackYaw)
	local house = placedByName[name]
	if not house then
		return fallbackYaw
	end

	local facingYaw = house:GetAttribute("FacingYaw")
	if typeof(facingYaw) == "number" then
		return facingYaw
	end

	return fallbackYaw
end

local function toWorldOffset(origin, yaw, offset)
	return origin + (CFrame.Angles(0, math.rad(yaw), 0):VectorToWorldSpace(offset))
end

local function getPlacementOffset(name, field, fallback)
	local spec = housePlacementSpecs[name]
	local value = spec and spec[field]
	if typeof(value) == "Vector3" then
		return value
	end
	return fallback
end

local heungbuFront = getHouseFrontPosition("HeungbuHouse", villageLayout.heungbu.talkPart.position)
local nolbuFront = getHouseFrontPosition("NolbuHouse", villageLayout.nolbu.talkPart.position)
local heungbuFacingYaw = getHouseFacingYaw("HeungbuHouse", villageLayout.heungbu.housePad.yaw)
local nolbuFacingYaw = getHouseFacingYaw("NolbuHouse", villageLayout.nolbu.yardPad.yaw)
local heungbuTalkPosition = toWorldOffset(heungbuFront, heungbuFacingYaw, getPlacementOffset("HeungbuHouse", "talkOffset", Vector3.new(0, 5, 0)))
local nolbuTalkPosition = toWorldOffset(nolbuFront, nolbuFacingYaw, getPlacementOffset("NolbuHouse", "talkOffset", Vector3.new(0, 5, 0)))

local heungbuPad = addPart(placedAssets, villageLayout.heungbu.housePad.name, villageLayout.heungbu.housePad.size, CFrame.new(villageLayout.heungbu.housePad.position) * CFrame.Angles(0, math.rad(villageLayout.heungbu.housePad.yaw), 0), Color3.fromRGB(133, 99, 63), Enum.Material.Ground)
local nolbuPad = addPart(placedAssets, villageLayout.nolbu.yardPad.name, villageLayout.nolbu.yardPad.size, CFrame.new(villageLayout.nolbu.yardPad.position) * CFrame.Angles(0, math.rad(villageLayout.nolbu.yardPad.yaw), 0), Color3.fromRGB(142, 111, 77), Enum.Material.Ground)
local villageWell = addPart(placedAssets, villageLayout.village.well.name, villageLayout.village.well.size, CFrame.new(villageLayout.village.well.position), Color3.fromRGB(114, 101, 86), Enum.Material.Slate)
local marketMat = addPart(placedAssets, villageLayout.village.seedMat.name, villageLayout.village.seedMat.size, CFrame.new(villageLayout.village.seedMat.position), Color3.fromRGB(156, 106, 64), Enum.Material.WoodPlanks)
local gourdPatch = addPart(placedAssets, villageLayout.village.gourdPatch.name, villageLayout.village.gourdPatch.size, CFrame.new(villageLayout.village.gourdPatch.position), Color3.fromRGB(80, 55, 34), Enum.Material.Mud)
local festivalStone = addPart(placedAssets, villageLayout.village.storyStone.name, villageLayout.village.storyStone.size, CFrame.new(villageLayout.village.storyStone.position), Color3.fromRGB(124, 118, 112), Enum.Material.Slate)
local tributeBasketPosition = toWorldOffset(nolbuFront, nolbuFacingYaw, getPlacementOffset("NolbuHouse", "tributeOffset", Vector3.new(10, -1.6, 8)))
local tributeBasket = addPart(placedAssets, "NolbuTributeBasket", Vector3.new(6, 2.2, 6), CFrame.new(tributeBasketPosition.X, 2.2, tributeBasketPosition.Z), Color3.fromRGB(101, 71, 43), Enum.Material.WoodPlanks)
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
local wellSign = attachBillboard(villageWell, "Village Well", "The center of the little valley.", Color3.fromRGB(98, 197, 215))
attachBillboard(marketMat, "Seed Mat", "Pick up a seed pouch if you need one.", Color3.fromRGB(227, 188, 96))
local storyStoneSign = attachBillboard(festivalStone, "Story Stone", "A tale of kindness, greed, and a magic gourd.", Color3.fromRGB(194, 162, 255))
local tributeSign = attachBillboard(tributeBasket, "Tribute Basket", "Nolbu demands proof that your harvest is real.", Color3.fromRGB(240, 154, 107))
local herbSign = attachBillboard(herbPatch, "Herb Garden", "Mint and mugwort grow near the well.", Color3.fromRGB(103, 220, 117))
local swallowSign = attachBillboard(injuredSwallowMarker, "Wall Swallow", "Something small is trembling by Nolbu's wall.", Color3.fromRGB(167, 205, 255))
attachBillboard(clotheslineBeam, "Laundry Line", "Patched cloth dries in the morning wind.", Color3.fromRGB(230, 218, 188))

local restorationLantern = addPart(endingAccentFolder, "RestorationLantern", Vector3.new(1.2, 3.2, 1.2), CFrame.new(heungbuFront + Vector3.new(8, 2.5, 4)), Color3.fromRGB(232, 198, 110), Enum.Material.WoodPlanks)
local restorationLanternGlow = Instance.new("PointLight")
restorationLanternGlow.Color = Color3.fromRGB(255, 225, 162)
restorationLanternGlow.Range = 14
restorationLanternGlow.Brightness = 0
restorationLanternGlow.Parent = restorationLantern
local restorationCrate = addPart(endingAccentFolder, "RestorationSeedCrate", Vector3.new(3.2, 1.4, 2.4), CFrame.new(villageLayout.heungbu.patchPart.position + Vector3.new(7, 1, -1)), Color3.fromRGB(143, 103, 64), Enum.Material.WoodPlanks)
local tributeLedger = addPart(endingAccentFolder, "TributeLedgerStand", Vector3.new(2.4, 3.2, 1.8), CFrame.new(tributeBasketPosition + Vector3.new(5, 1.6, 0)), Color3.fromRGB(95, 70, 49), Enum.Material.WoodPlanks)
local repairMarkerBasePosition = toWorldOffset(heungbuFront, heungbuFacingYaw, getPlacementOffset("HeungbuHouse", "yardMarkerOffset", Vector3.new(7, 0.8, -6)))
local restorationErrandBasket = addPart(endingAccentFolder, "CommunityBasket", Vector3.new(4.2, 1.8, 4.2), CFrame.new(villageWell.Position + Vector3.new(-8, 1.6, 6)), Color3.fromRGB(136, 96, 58), Enum.Material.WoodPlanks)
local restorationPantryCrate = addPart(endingAccentFolder, "WellPantryDrop", Vector3.new(4.2, 1.6, 3.6), CFrame.new(villageWell.Position + Vector3.new(7, 1.2, -3)), Color3.fromRGB(149, 110, 72), Enum.Material.WoodPlanks)
local restorationReliefMat = addPart(endingAccentFolder, "YardReliefMat", Vector3.new(4.8, 0.45, 3.6), CFrame.new(repairMarkerBasePosition + Vector3.new(2.8, 0.4, -2.8)), Color3.fromRGB(164, 203, 116), Enum.Material.Fabric)
local tributeErrandStand = addPart(endingAccentFolder, "RoadDueBasket", Vector3.new(4.4, 2.4, 4.4), CFrame.new(tributeBasketPosition + Vector3.new(9, 2, -5)), Color3.fromRGB(108, 80, 55), Enum.Material.WoodPlanks)
local tributeGateTallyStand = addPart(endingAccentFolder, "GateTallyStand", Vector3.new(3.2, 2.4, 2.6), CFrame.new(nolbuFront + Vector3.new(-5, 1.8, 8)), Color3.fromRGB(113, 83, 60), Enum.Material.WoodPlanks)
local tributeRouteMarker = addPart(endingAccentFolder, "TributeRouteMarker", Vector3.new(1.2, 4.6, 1.2), CFrame.new(tributeBasketPosition + Vector3.new(16, 2.3, 6)), Color3.fromRGB(89, 69, 51), Enum.Material.Wood)
local tributeBanner = addPart(endingAccentFolder, "TributeRoadMarker", Vector3.new(0.6, 6, 0.6), CFrame.new(nolbuFront + Vector3.new(-10, 3, 3)), Color3.fromRGB(86, 67, 55), Enum.Material.Wood)
local tributeBannerCloth = addPart(endingAccentFolder, "TributeRoadCloth", Vector3.new(2.4, 3.2, 0.2), tributeBanner.CFrame * CFrame.new(1.3, 0.7, 0), Color3.fromRGB(123, 77, 69), Enum.Material.Fabric)
local restorationBasketTierOneCrate = addPart(endingAccentFolder, "RestorationBasketTierOneCrate", Vector3.new(2.2, 1.1, 1.8), restorationErrandBasket.CFrame * CFrame.new(-2.6, -0.2, 1.8), Color3.fromRGB(171, 126, 82), Enum.Material.WoodPlanks)
local restorationBasketTierOneGourd = addPart(endingAccentFolder, "RestorationBasketTierOneGourd", Vector3.new(1.1, 1.1, 1.1), restorationErrandBasket.CFrame * CFrame.new(-2.1, 0.9, 1.6), Color3.fromRGB(194, 154, 85), Enum.Material.SmoothPlastic)
local restorationPantryTierOneSack = addPart(endingAccentFolder, "RestorationPantryTierOneSack", Vector3.new(1.5, 1.7, 1.5), restorationPantryCrate.CFrame * CFrame.new(2.8, 0.1, -0.6), Color3.fromRGB(206, 194, 153), Enum.Material.Fabric)
local restorationPantryTierOneGourd = addPart(endingAccentFolder, "RestorationPantryTierOneGourd", Vector3.new(0.9, 0.9, 0.9), restorationPantryCrate.CFrame * CFrame.new(2.5, 1.1, -0.4), Color3.fromRGB(196, 151, 92), Enum.Material.SmoothPlastic)
local restorationBasketTierTwoCrate = addPart(endingAccentFolder, "RestorationBasketTierTwoCrate", Vector3.new(1.9, 0.95, 1.6), restorationErrandBasket.CFrame * CFrame.new(2.7, -0.25, -1.7), Color3.fromRGB(162, 118, 76), Enum.Material.WoodPlanks)
local restorationBasketTierTwoCloth = addPart(endingAccentFolder, "RestorationBasketTierTwoCloth", Vector3.new(1.8, 0.18, 1.4), restorationErrandBasket.CFrame * CFrame.new(2.7, 0.37, -1.7), Color3.fromRGB(222, 214, 178), Enum.Material.Fabric)
local restorationPantryTierTwoLantern = addPart(endingAccentFolder, "RestorationPantryTierTwoLantern", Vector3.new(0.7, 1.6, 0.7), restorationPantryCrate.CFrame * CFrame.new(-2.5, 1.2, 0.8), Color3.fromRGB(232, 198, 110), Enum.Material.WoodPlanks)
local restorationPantryTierTwoLanternGlow = Instance.new("PointLight")
restorationPantryTierTwoLanternGlow.Color = Color3.fromRGB(255, 225, 162)
restorationPantryTierTwoLanternGlow.Range = 10
restorationPantryTierTwoLanternGlow.Brightness = 0
restorationPantryTierTwoLanternGlow.Parent = restorationPantryTierTwoLantern
local restorationReliefTierOneBundle = addPart(endingAccentFolder, "RestorationReliefTierOneBundle", Vector3.new(1.3, 0.9, 1.3), restorationReliefMat.CFrame * CFrame.new(-1.6, 0.7, 0.9), Color3.fromRGB(201, 188, 146), Enum.Material.Fabric)
local restorationReliefTierOneGourd = addPart(endingAccentFolder, "RestorationReliefTierOneGourd", Vector3.new(0.95, 0.95, 0.95), restorationReliefMat.CFrame * CFrame.new(-1.2, 1.25, 0.6), Color3.fromRGB(195, 152, 88), Enum.Material.SmoothPlastic)
local restorationReliefTierTwoTray = addPart(endingAccentFolder, "RestorationReliefTierTwoTray", Vector3.new(1.7, 0.22, 1.4), restorationReliefMat.CFrame * CFrame.new(1.7, 0.4, -0.8), Color3.fromRGB(165, 122, 81), Enum.Material.WoodPlanks)
local restorationReliefTierTwoSeedSack = addPart(endingAccentFolder, "RestorationReliefTierTwoSeedSack", Vector3.new(1.15, 1.4, 1.15), restorationReliefMat.CFrame * CFrame.new(1.7, 1.15, -0.8), Color3.fromRGB(214, 204, 168), Enum.Material.Fabric)
local tributeStandTierOneLedger = addPart(endingAccentFolder, "TributeStandTierOneLedger", Vector3.new(1.8, 0.35, 1.4), tributeErrandStand.CFrame * CFrame.new(2.5, 1.4, 1.4), Color3.fromRGB(108, 81, 61), Enum.Material.WoodPlanks)
local tributeStandTierOneStone = addPart(endingAccentFolder, "TributeStandTierOneStone", Vector3.new(0.9, 0.7, 0.9), tributeErrandStand.CFrame * CFrame.new(2.2, 1.85, 1.1), Color3.fromRGB(128, 121, 114), Enum.Material.Slate)
local tributeGateTierOneLedger = addPart(endingAccentFolder, "TributeGateTierOneLedger", Vector3.new(1.6, 0.3, 1.1), tributeGateTallyStand.CFrame * CFrame.new(-2.1, 1.05, -0.3), Color3.fromRGB(99, 73, 54), Enum.Material.WoodPlanks)
local tributeGateTierOneRope = addPart(endingAccentFolder, "TributeGateTierOneRope", Vector3.new(2.2, 0.18, 0.18), tributeGateTallyStand.CFrame * CFrame.new(-0.4, 0.8, 1.6) * CFrame.Angles(0, math.rad(18), 0), Color3.fromRGB(164, 137, 104), Enum.Material.Fabric)
local tributeStandTierTwoLedger = addPart(endingAccentFolder, "TributeStandTierTwoLedger", Vector3.new(1.7, 0.32, 1.2), tributeErrandStand.CFrame * CFrame.new(-2.6, 1.35, -1.5), Color3.fromRGB(92, 68, 50), Enum.Material.WoodPlanks)
local tributeStandTierTwoStone = addPart(endingAccentFolder, "TributeStandTierTwoStone", Vector3.new(0.8, 0.65, 0.8), tributeErrandStand.CFrame * CFrame.new(-2.8, 1.8, -1.8), Color3.fromRGB(115, 108, 103), Enum.Material.Slate)
local tributeGateTierTwoPost = addPart(endingAccentFolder, "TributeGateTierTwoPost", Vector3.new(0.35, 2.6, 0.35), tributeGateTallyStand.CFrame * CFrame.new(2.6, 1.3, 1.1), Color3.fromRGB(87, 68, 51), Enum.Material.Wood)
local tributeGateTierTwoCloth = addPart(endingAccentFolder, "TributeGateTierTwoCloth", Vector3.new(1.3, 1.7, 0.16), tributeGateTierTwoPost.CFrame * CFrame.new(0.7, 0.2, 0), Color3.fromRGB(132, 84, 77), Enum.Material.Fabric)
local tributeRouteTierOneLantern = addPart(endingAccentFolder, "TributeRouteTierOneLantern", Vector3.new(0.65, 1.5, 0.65), tributeRouteMarker.CFrame * CFrame.new(1.4, 0.2, 0.5), Color3.fromRGB(171, 136, 90), Enum.Material.WoodPlanks)
local tributeRouteTierOneLedger = addPart(endingAccentFolder, "TributeRouteTierOneLedger", Vector3.new(1.2, 0.22, 0.9), tributeRouteMarker.CFrame * CFrame.new(1.8, -1.35, 0.3), Color3.fromRGB(103, 76, 56), Enum.Material.WoodPlanks)
local tributeRouteTierTwoRope = addPart(endingAccentFolder, "TributeRouteTierTwoRope", Vector3.new(2.4, 0.16, 0.16), tributeRouteMarker.CFrame * CFrame.new(-1.1, -0.7, 1.5) * CFrame.Angles(0, math.rad(26), 0), Color3.fromRGB(160, 133, 101), Enum.Material.Fabric)
local tributeRouteTierTwoStone = addPart(endingAccentFolder, "TributeRouteTierTwoStone", Vector3.new(0.85, 0.7, 0.85), tributeRouteMarker.CFrame * CFrame.new(-1.7, -1.45, 1.7), Color3.fromRGB(118, 112, 105), Enum.Material.Slate)
local repairMarkerBase = addPart(placedAssets, "HeungbuYardMarkerBase", Vector3.new(3.2, 0.8, 3.2), CFrame.new(repairMarkerBasePosition), Color3.fromRGB(104, 81, 57), Enum.Material.WoodPlanks)
local repairMarkerPost = addPart(placedAssets, "HeungbuYardMarkerPost", Vector3.new(0.8, 4.8, 0.8), repairMarkerBase.CFrame * CFrame.new(0, 2.8, 0), Color3.fromRGB(122, 90, 62), Enum.Material.Wood)
local repairMarkerCrossbeam = addPart(placedAssets, "HeungbuYardMarkerCrossbeam", Vector3.new(3, 0.5, 0.8), repairMarkerPost.CFrame * CFrame.new(0, 1.3, 0), Color3.fromRGB(131, 97, 68), Enum.Material.WoodPlanks)
local repairMarkerCloth = addPart(placedAssets, "HeungbuYardMarkerCloth", Vector3.new(2.2, 2.6, 0.2), repairMarkerPost.CFrame * CFrame.new(0.9, 0.2, 0), Color3.fromRGB(162, 201, 115), Enum.Material.Fabric)
local repairMarkerBrokenBeam = addPart(placedAssets, "HeungbuYardMarkerBrokenBeam", Vector3.new(2.6, 0.5, 0.8), repairMarkerPost.CFrame * CFrame.new(-0.4, 0.2, 0) * CFrame.Angles(0, 0, math.rad(-38)), Color3.fromRGB(108, 77, 52), Enum.Material.WoodPlanks)
local repairMarkerBramble = addPart(placedAssets, "HeungbuYardMarkerBramble", Vector3.new(1.4, 2.4, 1.4), repairMarkerPost.CFrame * CFrame.new(-0.7, -0.2, 0), Color3.fromRGB(81, 100, 50), Enum.Material.Grass)

local restorationLandmarkTierOneParts = {
	restorationBasketTierOneCrate,
	restorationBasketTierOneGourd,
	restorationPantryTierOneSack,
	restorationPantryTierOneGourd,
	restorationReliefTierOneBundle,
	restorationReliefTierOneGourd,
}

local restorationLandmarkTierTwoParts = {
	restorationBasketTierTwoCrate,
	restorationBasketTierTwoCloth,
	restorationPantryTierTwoLantern,
	restorationReliefTierTwoTray,
	restorationReliefTierTwoSeedSack,
}

local tributeLandmarkTierOneParts = {
	tributeStandTierOneLedger,
	tributeStandTierOneStone,
	tributeGateTierOneLedger,
	tributeGateTierOneRope,
	tributeRouteTierOneLantern,
	tributeRouteTierOneLedger,
}

local tributeLandmarkTierTwoParts = {
	tributeStandTierTwoLedger,
	tributeStandTierTwoStone,
	tributeGateTierTwoPost,
	tributeGateTierTwoCloth,
	tributeRouteTierTwoRope,
	tributeRouteTierTwoStone,
}

for _, accentPart in ipairs({ restorationLantern, restorationCrate, restorationErrandBasket, restorationPantryCrate, restorationReliefMat, tributeLedger, tributeErrandStand, tributeGateTallyStand, tributeRouteMarker, tributeBanner, tributeBannerCloth, restorationBasketTierOneCrate, restorationBasketTierOneGourd, restorationPantryTierOneSack, restorationPantryTierOneGourd, restorationBasketTierTwoCrate, restorationBasketTierTwoCloth, restorationPantryTierTwoLantern, restorationReliefTierOneBundle, restorationReliefTierOneGourd, restorationReliefTierTwoTray, restorationReliefTierTwoSeedSack, tributeStandTierOneLedger, tributeStandTierOneStone, tributeGateTierOneLedger, tributeGateTierOneRope, tributeStandTierTwoLedger, tributeStandTierTwoStone, tributeGateTierTwoPost, tributeGateTierTwoCloth, tributeRouteTierOneLantern, tributeRouteTierOneLedger, tributeRouteTierTwoRope, tributeRouteTierTwoStone }) do
	accentPart.Transparency = 1
	accentPart.CanCollide = false
end

for _, repairPart in ipairs({ repairMarkerBase, repairMarkerPost, repairMarkerCrossbeam, repairMarkerCloth, repairMarkerBrokenBeam, repairMarkerBramble }) do
	repairPart.CanCollide = false
end

local patrolANodes = buildWanderRing("NolbuPatrolA", Vector3.new(72, 2, 34), 18, 6)
local patrolBNodes = buildWanderRing("NolbuPatrolB", Vector3.new(92, 2, 30), 14, 5)
if placedByName.NolbuPatrolA then startWanderNpc(placedByName.NolbuPatrolA, { walkSpeed = 8, nodes = patrolANodes }) end
if placedByName.NolbuPatrolB then startWanderNpc(placedByName.NolbuPatrolB, { walkSpeed = 7, nodes = patrolBNodes }) end

local heungbuTalkPart = ensureInteractionPart(villageLayout.heungbu.talkPart.name, heungbuTalkPosition, villageLayout.heungbu.talkPart.size)
local heungbuPrompt = createPrompt(heungbuTalkPart, "Talk", "Heungbu", 0.2, 14)
local heungbuSign = attachBillboard(heungbuTalkPart, "Heungbu", "He keeps smiling even when the house is quiet.", Color3.fromRGB(111, 224, 128))
local seedPart = ensureInteractionPart("SeedBasket", villageLayout.village.seedMat.position + Vector3.new(0, 1.8, 0), Vector3.new(8, 6, 8))
local seedPrompt = createPrompt(seedPart, "Collect", "Seed Basket", 0.15, 12)
local patchPart = ensureInteractionPart(villageLayout.heungbu.patchPart.name, villageLayout.heungbu.patchPart.position, villageLayout.heungbu.patchPart.size)
local plantPrompt = createPrompt(patchPart, "Plant / Harvest", "Gourd Patch", 0.25, 14)
local patchSign = attachBillboard(patchPart, "Gourd Patch", "Bring a seed, then return when the vine is ready.", Color3.fromRGB(120, 219, 95))
local nolbuTalkPart = ensureInteractionPart(villageLayout.nolbu.talkPart.name, nolbuTalkPosition, villageLayout.nolbu.talkPart.size)
local nolbuPrompt = createPrompt(nolbuTalkPart, "Listen", "Nolbu", 0.15, 12)
local tributePosition = tributeBasketPosition + Vector3.new(0, 2, 0)
local tributePart = ensureInteractionPart(villageLayout.nolbu.tributePart.name, tributePosition, villageLayout.nolbu.tributePart.size)
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
local repairMarkerPromptPart = ensureInteractionPart("RepairMarkerPrompt", repairMarkerBase.Position + Vector3.new(0, 2.6, 0), Vector3.new(7, 6, 7))
local repairMarkerPrompt = createPrompt(repairMarkerPromptPart, "Repair", "Yard Marker", 0.25, 12)
repairMarkerPrompt.Enabled = false
local repairMarkerSign = attachBillboard(repairMarkerPromptPart, "Yard Marker", "A little post keeps Heungbu's yard feeling welcoming.", Color3.fromRGB(142, 220, 116))
local restorationErrandPromptPart = ensureInteractionPart("CommunityBasketPrompt", restorationErrandBasket.Position + Vector3.new(0, 2.4, 0), Vector3.new(7, 6, 7))
local restorationErrandPrompt = createPrompt(restorationErrandPromptPart, "Leave", "Shared Basket", 0.2, 12)
local restorationErrandSign = attachBillboard(restorationErrandPromptPart, "Shared Basket", "Leave a fresh gourd so the valley keeps eating together.", Color3.fromRGB(142, 220, 116))
local restorationPantryPromptPart = ensureInteractionPart("WellPantryDropPrompt", restorationPantryCrate.Position + Vector3.new(0, 2.2, 0), Vector3.new(7, 6, 7))
local restorationPantryPrompt = createPrompt(restorationPantryPromptPart, "Leave", "Well Pantry", 0.2, 12)
local restorationPantrySign = attachBillboard(restorationPantryPromptPart, "Well Pantry Drop", "The village pantry by the well stays ready for the next shared harvest.", Color3.fromRGB(142, 220, 116))
local restorationReliefPromptPart = ensureInteractionPart("YardReliefMatPrompt", restorationReliefMat.Position + Vector3.new(0, 2.1, 0), Vector3.new(7, 5, 7))
local restorationReliefPrompt = createPrompt(restorationReliefPromptPart, "Leave", "Relief Mat", 0.2, 12)
local restorationReliefSign = attachBillboard(restorationReliefPromptPart, "Yard Relief Mat", "The repaired yard marker can steady one more family when the valley shares.", Color3.fromRGB(142, 220, 116))
local tributeErrandPromptPart = ensureInteractionPart("RoadDuePrompt", tributeErrandStand.Position + Vector3.new(0, 2.6, 0), Vector3.new(7, 6, 7))
local tributeErrandPrompt = createPrompt(tributeErrandPromptPart, "Surrender", "Road Due", 0.2, 12)
local tributeErrandSign = attachBillboard(tributeErrandPromptPart, "Road Due", "One more gourd keeps Nolbu's road quiet for another day.", Color3.fromRGB(226, 117, 94))
local tributeGatePromptPart = ensureInteractionPart("GateTallyPrompt", tributeGateTallyStand.Position + Vector3.new(0, 2.2, 0), Vector3.new(7, 6, 7))
local tributeGatePrompt = createPrompt(tributeGatePromptPart, "Surrender", "Gate Tally", 0.2, 12)
local tributeGateSign = attachBillboard(tributeGatePromptPart, "Gate Tally Point", "Nolbu's gate keeps a stricter count when tribute is due.", Color3.fromRGB(226, 117, 94))
local tributeRoutePromptPart = ensureInteractionPart("RouteMarkerDuePrompt", tributeRouteMarker.Position + Vector3.new(0, 2.8, 0), Vector3.new(7, 6, 7))
local tributeRoutePrompt = createPrompt(tributeRoutePromptPart, "Surrender", "Route Marker", 0.2, 12)
local tributeRouteSign = attachBillboard(tributeRoutePromptPart, "Route Marker Due", "The roadside marker watches for whichever harvest the road claims next.", Color3.fromRGB(226, 117, 94))
local wellWitnessPart = ensureInteractionPart("WellNeighborPrompt", restorationPantryCrate.Position + Vector3.new(-4, 2.3, 4), Vector3.new(6, 5, 6))
local wellWitnessPrompt = createPrompt(wellWitnessPart, "Check In", "Well Neighbor", 0.1, 12)
local wellWitnessSign = attachBillboard(wellWitnessPart, "Well Neighbor", "Someone by the well keeps track of what shared harvests mean to the village.", Color3.fromRGB(142, 220, 116))
local yardWitnessPart = ensureInteractionPart("YardHelperPrompt", restorationReliefMat.Position + Vector3.new(4, 2.2, -2), Vector3.new(6, 5, 6))
local yardWitnessPrompt = createPrompt(yardWitnessPart, "Listen", "Yard Helper", 0.1, 12)
local yardWitnessSign = attachBillboard(yardWitnessPart, "Yard Helper", "A nearby helper watches how Heungbu's yard changes after the ending.", Color3.fromRGB(142, 220, 116))
local roadWitnessPart = ensureInteractionPart("RoadClerkPrompt", tributeErrandStand.Position + Vector3.new(-4, 2.4, 5), Vector3.new(6, 5, 6))
local roadWitnessPrompt = createPrompt(roadWitnessPart, "Check Count", "Road Clerk", 0.1, 12)
local roadWitnessSign = attachBillboard(roadWitnessPart, "Road Clerk", "Someone by the road stand notices how quickly tribute becomes routine.", Color3.fromRGB(226, 117, 94))
local gateWitnessPart = ensureInteractionPart("GateWatcherPrompt", tributeGateTallyStand.Position + Vector3.new(4, 2.1, -2), Vector3.new(6, 5, 6))
local gateWitnessPrompt = createPrompt(gateWitnessPart, "Listen", "Gate Watcher", 0.1, 12)
local gateWitnessSign = attachBillboard(gateWitnessPart, "Gate Watcher", "A watcher near Nolbu's gate has opinions about counted harvests.", Color3.fromRGB(226, 117, 94))

local currentCrop = { state = "empty", owner = nil, readyAt = 0, cropType = "normal" }
local bramblesActive = false
local supportPointDisrupted = false
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

local function setSupportPointState(mode)
	supportPointDisrupted = mode == "disrupted"
	repairMarkerPrompt.Enabled = supportPointDisrupted
	repairMarkerCrossbeam.Transparency = supportPointDisrupted and 1 or 0
	repairMarkerCloth.Transparency = supportPointDisrupted and 1 or 0
	repairMarkerBrokenBeam.Transparency = supportPointDisrupted and 0 or 1
	repairMarkerBramble.Transparency = supportPointDisrupted and 0.12 or 1
	setBillboardBody(repairMarkerSign, supportPointDisrupted and "Nolbu's spite snapped the yard marker. Repair it once the patch can breathe." or "The yard marker stands steady again beside Heungbu's house.")
end

setSupportPointState("restored")

local function setLandmarkTierVisibility(parts, visible)
	for _, part in ipairs(parts) do
		part.Transparency = visible and 0 or 1
	end
end

local function updateEndingLandmarkProps(mode)
	local restorationTier = mode == AMBIENT_ENDING.RESTORATION and getVillageEndingLandmarkTier("restoration") or 0
	local tributeTier = mode == AMBIENT_ENDING.TRIBUTE and getVillageEndingLandmarkTier("tribute") or 0
	setLandmarkTierVisibility(restorationLandmarkTierOneParts, restorationTier >= 1)
	setLandmarkTierVisibility(restorationLandmarkTierTwoParts, restorationTier >= 2)
	setLandmarkTierVisibility(tributeLandmarkTierOneParts, tributeTier >= 1)
	setLandmarkTierVisibility(tributeLandmarkTierTwoParts, tributeTier >= 2)
	restorationPantryTierTwoLanternGlow.Brightness = restorationTier >= 2 and 0.85 or 0
end

local function setEndingAccentVisibility(mode)
	local restorationVisible = mode == AMBIENT_ENDING.RESTORATION
	local tributeVisible = mode == AMBIENT_ENDING.TRIBUTE
	for _, part in ipairs({ restorationLantern, restorationCrate, restorationErrandBasket, restorationPantryCrate, restorationReliefMat }) do
		part.Transparency = restorationVisible and 0 or 1
	end
	for _, part in ipairs({ tributeLedger, tributeErrandStand, tributeGateTallyStand, tributeRouteMarker, tributeBanner, tributeBannerCloth }) do
		part.Transparency = tributeVisible and 0 or 1
	end
	restorationLanternGlow.Brightness = restorationVisible and 1.2 or 0
	for _, prompt in ipairs({ restorationErrandPrompt, restorationPantryPrompt, restorationReliefPrompt }) do
		prompt.Enabled = restorationVisible
	end
	for _, prompt in ipairs({ tributeErrandPrompt, tributeGatePrompt, tributeRoutePrompt }) do
		prompt.Enabled = tributeVisible
	end
	updateEndingLandmarkProps(mode)
end

local function applyAmbientPatchState(mode)
	if bramblesActive or currentCrop.state ~= "empty" then
		return
	end
	if mode == AMBIENT_ENDING.RESTORATION then
		gourdPatch.Color = Color3.fromRGB(108, 82, 48)
		gourdPatch.Material = Enum.Material.Ground
		patchGlowLight.Color = Color3.fromRGB(186, 236, 140)
		patchGlowLight.Brightness = 0.65
		setPatchText("The patch stays open. Plant here for a harvest the whole valley can share.")
	elseif mode == AMBIENT_ENDING.TRIBUTE then
		gourdPatch.Color = Color3.fromRGB(92, 69, 44)
		gourdPatch.Material = Enum.Material.Mud
		patchGlowLight.Color = Color3.fromRGB(177, 132, 102)
		patchGlowLight.Brightness = 0.18
		setPatchText("The patch still grows, but every harvest now feels counted.")
	else
		setPatchMood("idle")
		setPatchText("Bring a seed, then return when the vine is ready.")
	end
end

local function getRetaliationPressureMode()
	for _, player in ipairs(Players:GetPlayers()) do
		local profile = playerData[player]
		if profile and profile.retaliationTriggered and not profile.valleyStabilized and profile.questStage >= QUEST.CLEAR_BRAMBLES and profile.questStage < QUEST.FINAL_AUDIENCE then
			if profile.questStage >= QUEST.STABILIZE_VALLEY then
				return "stabilize"
			end
			return "brambles"
		end
	end
	return "none"
end

refreshVillageSigns = function()
	local ambientMode = getVillageAmbientEndingChoice()
	local retaliationMode = getRetaliationPressureMode()
	setBillboardBody(heungbuSign, string.format("Deliveries: %d · Swallows helped: %d · Magic opened: %d", villageState.heungbuDeliveries, villageState.swallowHelped, villageState.magicPayoffs))
	if retaliationMode == "stabilize" then
		setBillboardBody(heungbuPadSign, "The patch is open again, but the yard marker still needs steady hands.")
		setBillboardBody(nolbuPadSign, string.format("Patrols circling: %d · Nolbu's envy reached farther than the vines.", #patrolANodes + #patrolBNodes))
		setBillboardBody(tributeSign, string.format("Tributes paid: %d · Even the basket can feel the village holding its breath.", villageState.nolbuTributes))
		setBillboardBody(storyStoneSign, "The valley is not deciding its future yet. First it has to steady what spite bent.")
		setBillboardBody(wellSign, "The village well watches the yard recover one landmark at a time.")
	elseif ambientMode == AMBIENT_ENDING.RESTORATION then
		local restorationTier = getVillageEndingLandmarkTier("restoration")
		setBillboardBody(heungbuPadSign, string.format("The yard stays open to all. Restoration endings: %d · Shared drops: %d", villageState.restorationEndings, villageState.sharedHarvestDrops))
		setBillboardBody(nolbuPadSign, string.format("Patrols circling: %d · The gate watches a valley that chose warmth over tribute.", #patrolANodes + #patrolBNodes))
		setBillboardBody(tributeSign, string.format("Tributes once paid: %d · The basket remains as a warning, not a rule.", villageState.nolbuTributes))
		setBillboardBody(storyStoneSign, restorationTier >= 2 and "The stone now speaks of a valley that shares enough to plant again." or restorationTier >= 1 and "The stone now tells of a pantry learning how to stay stocked." or "The valley remembers the day kindness held the patch open.")
		setBillboardBody(wellSign, restorationTier >= 2 and string.format("Shared harvests left here: %d · Visible stores now sit beside the village well.", villageState.sharedHarvestDrops) or restorationTier >= 1 and string.format("Shared harvests left here: %d · The village pantry is starting to stay stocked between drops.", villageState.sharedHarvestDrops) or string.format("Shared harvests left here: %d · The center of the valley feels calmer after restoration.", villageState.sharedHarvestDrops))
		setBillboardBody(restorationErrandSign, restorationTier >= 2 and string.format("Leave a fresh gourd. The basket now sends food and seed back through the valley. Shared drops: %d", villageState.sharedHarvestDrops) or restorationTier >= 1 and string.format("Leave a fresh gourd. The basket is starting to keep communal stock between drops. Shared drops: %d", villageState.sharedHarvestDrops) or string.format("Leave a fresh gourd so the valley keeps eating together. Shared drops so far: %d", villageState.sharedHarvestDrops))
		setBillboardBody(tributeErrandSign, "The road-due stand looks out of place in a restored valley.")
	elseif ambientMode == AMBIENT_ENDING.TRIBUTE then
		local tributeTier = getVillageEndingLandmarkTier("tribute")
		setBillboardBody(heungbuPadSign, string.format("Hope survives under count and caution. Tribute endings lived: %d", villageState.tributeEndings))
		setBillboardBody(nolbuPadSign, string.format("Patrols circling: %d · Tribute order holds the road in a colder peace.", #patrolANodes + #patrolBNodes))
		setBillboardBody(tributeSign, string.format("Tributes paid: %d · Nolbu's basket has become part of the road.", villageState.nolbuTributes))
		setBillboardBody(storyStoneSign, tributeTier >= 2 and "The stone now tells of a valley so practiced at tribute that even the road expects it." or tributeTier >= 1 and "The stone now tells of tally points settling into a stricter routine." or "The stone now tells of a valley that survives by paying what it owes.")
		setBillboardBody(wellSign, tributeTier >= 2 and string.format("The center of the valley now reads like a standing habit of tribute (%d counted dues).", villageState.tributeDuesPaid) or tributeTier >= 1 and string.format("The center of the valley is marked by tally points settling into routine (%d counted dues).", villageState.tributeDuesPaid) or "The center of the valley is busy, productive, and a little quieter than before.")
		setBillboardBody(restorationErrandSign, "The shared basket is quiet here; the road now asks to be counted instead.")
		setBillboardBody(tributeErrandSign, tributeTier >= 2 and string.format("One more gourd keeps Nolbu's road quiet. The road now expects tribute as routine order. Dues: %d", villageState.tributeDuesPaid) or tributeTier >= 1 and string.format("One more gourd keeps Nolbu's tally points in rhythm. Counted dues: %d", villageState.tributeDuesPaid) or string.format("One more gourd keeps Nolbu's road quiet for another day. Dues paid: %d", villageState.tributeDuesPaid))
	else
		setBillboardBody(heungbuPadSign, villageState.magicPayoffs > 0 and string.format("The yard glows a little brighter. Retaliations weathered: %d", villageState.retaliations) or string.format("Harvests gathered: %d · Kindness still lives here.", villageState.gourdsHarvested))
		setBillboardBody(nolbuPadSign, string.format("Patrols circling: %d · Tributes demanded: %d", #patrolANodes + #patrolBNodes, villageState.nolbuTributes))
		setBillboardBody(tributeSign, string.format("Tributes paid: %d · Nolbu still wants more.", villageState.nolbuTributes))
		setBillboardBody(storyStoneSign, "A tale of kindness, greed, and a magic gourd.")
		setBillboardBody(wellSign, "The center of the little valley.")
		setBillboardBody(restorationErrandSign, "Leave a fresh gourd so the valley keeps eating together.")
		setBillboardBody(tributeErrandSign, "One more gourd keeps Nolbu's road quiet for another day.")
	end
	setBillboardBody(herbSign, string.format("Herb bundles picked: %d · The well garden smells sharp and clean.", villageState.herbBundlesPicked))
	setBillboardBody(swallowSign, villageState.swallowHelped > 0 and "The swallow has been tended. It twitches with a little strength now." or "Something small is trembling by Nolbu's wall.")
	setEndingAccentVisibility(ambientMode)
	updateEndingSupportSigns()
	updateEndingWitnessSigns()
	applyAmbientPatchState(ambientMode)
end

updateEndingSupportSigns = function()
	local ambientMode = getVillageAmbientEndingChoice()

	if ambientMode == AMBIENT_ENDING.RESTORATION then
		local restorationTier = getVillageEndingLandmarkTier("restoration")
		local activeRestorationId = getActiveVillageSupportPointId("restoration")
		local pantryBody = activeRestorationId == "wellPantry"
			and (restorationTier >= 2
				and string.format("Shared stores now gather here by the well between village drops. Village-wide drops: %d", villageState.sharedHarvestDrops)
				or restorationTier >= 1
					and string.format("The pantry is staying stocked between shared drops here by the well. Village-wide drops: %d", villageState.sharedHarvestDrops)
					or string.format("Shared harvests are currently being gathered here by the well. Village-wide drops: %d", villageState.sharedHarvestDrops))
			or restorationTier >= 2
				and string.format("The well pantry now keeps visible stores even while the active drop rotates elsewhere. Shared drops so far: %d", villageState.sharedHarvestDrops)
			or restorationTier >= 1
				and string.format("The well pantry is taking turns with the basket and starting to stay stocked. Shared drops so far: %d", villageState.sharedHarvestDrops)
				or "The well pantry waits nearby in case the next shared harvest shifts toward the village center."
		local reliefBody = activeRestorationId == "yardRelief"
			and (restorationTier >= 2
				and "Heungbu's yard marker now keeps seed and supper set aside. Leave the next relief harvest here if your own route points this way."
				or restorationTier >= 1
					and "The active shared drop has shifted to Heungbu's yard marker. Small relief bundles are starting to collect here."
					or "The active shared drop has shifted to Heungbu's yard marker. Leave the next relief harvest here if your own route points this way.")
			or restorationTier >= 2
				and "Heungbu's repaired yard marker now looks lived-in, with relief stores ready for the next family in need."
			or restorationTier >= 1
				and "Heungbu's repaired yard marker is starting to hold small relief bundles between shared drops."
				or "The relief mat waits by Heungbu's marker for when the valley needs one more shared stop."
		setBillboardBody(restorationPantrySign, pantryBody)
		setBillboardBody(restorationReliefSign, reliefBody)
		setBillboardBody(tributeGateSign, "Nolbu's tally post is no longer the valley's rule; it stands here as a colder reminder.")
		setBillboardBody(tributeRouteSign, restorationTier >= 2 and "The route marker still watches the road, but the restored valley now keeps fuller relief stops elsewhere." or "The route marker still watches the road, but restored harvests are being claimed elsewhere.")
	elseif ambientMode == AMBIENT_ENDING.TRIBUTE then
		local tributeTier = getVillageEndingLandmarkTier("tribute")
		local activeTributeId = getActiveVillageSupportPointId("tribute")
		local gateBody = activeTributeId == "gateTally"
			and (tributeTier >= 2
				and string.format("Today's counted road due is being marked at Nolbu's gate beneath a settled tally post. Village-wide dues: %d", villageState.tributeDuesPaid)
				or tributeTier >= 1
					and string.format("Today's counted road due is being marked at Nolbu's gate as the tally routine settles in. Village-wide dues: %d", villageState.tributeDuesPaid)
					or string.format("Today's counted road due is being marked at Nolbu's gate. Village-wide dues: %d", villageState.tributeDuesPaid))
			or tributeTier >= 2
				and string.format("Nolbu's gate now reads like a standing checkpoint even when the due rotates away. Counted dues so far: %d", villageState.tributeDuesPaid)
			or tributeTier >= 1
				and string.format("Nolbu's gate keeps a stricter count now. Counted dues so far: %d", villageState.tributeDuesPaid)
				or "Nolbu's gate keeps a stricter count when tribute shifts away from the main road stand."
		local routeBody = activeTributeId == "routeMarker"
			and (tributeTier >= 2
				and "The active road due has shifted to the route marker. The road now expects a counted harvest here as routine order."
				or tributeTier >= 1
					and "The active road due has shifted to the route marker. Ledger props and guide rope now make the count feel more official."
					or "The active road due has shifted to the route marker. Surrender the next counted harvest here if your own tally points this way.")
			or tributeTier >= 2
				and "The roadside route marker now reads like part of a standing due route before the basket is even reached."
			or tributeTier >= 1
				and "The roadside route marker has started to look like a formal tally stop before the basket."
				or "The roadside marker waits for the road's claim whenever the tally shifts off the main stand."
		setBillboardBody(restorationPantrySign, tributeTier >= 2 and "The pantry still stands, but the road's count now reaches farther than the shared table." or "The pantry still stands, though tribute is pulling attention toward the tally route.")
		setBillboardBody(restorationReliefSign, tributeTier >= 2 and "Heungbu's marker stays standing, but the village now leaves more ropes and counts than open relief." or "Heungbu's marker stays standing, though tribute leaves little room for open relief.")
		setBillboardBody(tributeGateSign, gateBody)
		setBillboardBody(tributeRouteSign, routeBody)
	else
		setBillboardBody(restorationPantrySign, "The village pantry by the well stays ready for the next shared harvest.")
		setBillboardBody(restorationReliefSign, "The repaired yard marker can steady one more family when the valley shares.")
		setBillboardBody(tributeGateSign, "Nolbu's gate keeps a stricter count when tribute is due.")
		setBillboardBody(tributeRouteSign, "The roadside marker watches for whichever harvest the road claims next.")
	end
end

updateEndingWitnessSigns = function()
	local ambientMode = getVillageAmbientEndingChoice()
	if ambientMode == AMBIENT_ENDING.RESTORATION then
		local restorationTier = getVillageEndingLandmarkTier("restoration")
		local activeRestorationId = getActiveVillageSupportPointId("restoration")
		setBillboardBody(wellWitnessSign, activeRestorationId == "wellPantry"
			and "The well neighbor is already talking about today's active pantry drop."
			or restorationTier >= 2 and "The well neighbor says the village now expects the pantry to stay stocked."
			or restorationTier >= 1 and "The well neighbor says shared drops are starting to feel ordinary here."
			or "The well neighbor watches for the next shared harvest to pass through the center path.")
		setBillboardBody(yardWitnessSign, activeRestorationId == "yardRelief"
			and "The yard helper is watching today's active relief stop by Heungbu's marker."
			or restorationTier >= 2 and "The yard helper says this corner now helps the whole valley, not just one house."
			or restorationTier >= 1 and "The yard helper says small relief bundles are becoming a regular sight here."
			or "The yard helper keeps noticing how differently Heungbu's yard feels after the ending.")
		setBillboardBody(roadWitnessSign, "The road clerk has less to say when the restored valley keeps choosing shared harvests.")
		setBillboardBody(gateWitnessSign, "The gate watcher still keeps score in his head, even if the valley chose warmth.")
	elseif ambientMode == AMBIENT_ENDING.TRIBUTE then
		local tributeTier = getVillageEndingLandmarkTier("tribute")
		local activeTributeId = getActiveVillageSupportPointId("tribute")
		setBillboardBody(roadWitnessSign, activeTributeId == "roadStand"
			and "The road clerk is following today's active due at the stand."
			or tributeTier >= 2 and "The road clerk says tribute now reads like a standing habit."
			or tributeTier >= 1 and "The road clerk says the tally routine is settling into the village."
			or "The road clerk notices whichever stop is currently taking the next counted due.")
		setBillboardBody(gateWitnessSign, activeTributeId == "gateTally"
			and "The gate watcher is already studying today's active tally at Nolbu's gate."
			or tributeTier >= 2 and "The gate watcher says supervision now feels built into the road itself."
			or tributeTier >= 1 and "The gate watcher says the tally post is becoming part of everyday routine."
			or "The gate watcher notices how quickly counted harvests change the mood near the house.")
		setBillboardBody(wellWitnessSign, "The well neighbor lowers his voice; the road count reaches farther than the pantry now.")
		setBillboardBody(yardWitnessSign, "The yard helper says even repaired corners feel cautious when tribute leads the valley.")
	else
		setBillboardBody(wellWitnessSign, "Someone by the well keeps track of what shared harvests mean to the village.")
		setBillboardBody(yardWitnessSign, "A nearby helper watches how Heungbu's yard changes after the ending.")
		setBillboardBody(roadWitnessSign, "Someone by the road stand notices how quickly tribute becomes routine.")
		setBillboardBody(gateWitnessSign, "A watcher near Nolbu's gate has opinions about counted harvests.")
	end
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
		plantPrompt.ObjectText = "Gourd Patch"
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
		if profile.questStage == QUEST.STABILIZE_VALLEY then
			showDialogue(player, "Heungbu", { "You drove the thorns off, but Nolbu also snapped the yard marker by my house.", "Set it upright again and the valley can decide its future without staring at his damage." }, Color3.fromRGB(111, 224, 128))
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
			local lines
			if profile.endingChoice == AMBIENT_ENDING.RESTORATION then
				lines = getNextAmbientLine(player, "HeungbuCompleteRestoration", {
					{ "The yard sounds different now. People stop here because they expect sharing, not fear.", "Keep the patch alive and the restored valley will keep feeling true." },
					{ "You chose warmth, so even small harvests feel bigger here.", "Plant what you can. The point is that no one reaches this patch alone anymore." },
					{ "The brambles never really won, did they?", "Every gourd you grow now reminds the valley what kindness protected." },
				})
			elseif profile.endingChoice == AMBIENT_ENDING.TRIBUTE then
				lines = getNextAmbientLine(player, "HeungbuCompleteTribute", {
					{ "We still plant, even under another man's count.", "If you keep growing, perhaps one day the valley can ask for more than peace." },
					{ "This patch survives because people keep working, even when the road asks for too much.", "Bring harvest if you can. Endurance is its own kind of courage." },
					{ "The valley is quieter now, but not empty.", "Every seed we keep alive is proof that tribute did not take everything." },
				})
			else
				lines = { "The patch is breathing again.", "If you keep planting, the story can stay alive a while longer." }
			end
			showDialogue(player, "Heungbu", lines, Color3.fromRGB(111, 224, 128))
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
		profile.valleyStabilized = false
		villageState.retaliations += 1
		setQuestStage(player, QUEST.CLEAR_BRAMBLES)
		setBramblesVisible(true)
		setSupportPointState("disrupted")
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
		local lines
		if profile.endingChoice == AMBIENT_ENDING.TRIBUTE then
			lines = getNextAmbientLine(player, "NolbuCompleteTribute", {
				{ "You chose the road that keeps the loudest quarrels quiet.", "Keep the tribute moving and even this valley can look orderly." },
				{ "People complain about the tally board until the road stays open because of it.", "That is the difference between warmth and management." },
				{ "A counted harvest is still a harvest.", "Remember that the next time Heungbu mistakes relief for leadership." },
			})
		elseif profile.endingChoice == AMBIENT_ENDING.RESTORATION then
			lines = getNextAmbientLine(player, "NolbuCompleteRestoration", {
				{ "You chose Heungbu's warmth over my order.", "Do not act surprised if a generous valley still needs defending." },
				{ "The whole road feels softer now, and somehow more inconvenient.", "If the patch stays open, someone still has to keep score when kindness gets sloppy." },
				{ "Even restored valleys need strong gates.", "You may call it resentment. I call it being the only one still watching the road." },
			})
		else
			lines = { "The village keeps moving, with or without a proper accountant." }
		end
		showDialogue(player, "Nolbu", lines, Color3.fromRGB(226, 117, 94))
		return
	end
	showDialogue(player, "Nolbu", { string.format("My estate still has %d patrol steps and %d reasons to stay impressed.", #patrolANodes + #patrolBNodes, villageState.nolbuTributes), profile.retaliationTriggered and "If Heungbu cannot keep brambles out, perhaps he does not deserve a harvest." or "If you have a spare gourd, the basket is right there." }, Color3.fromRGB(226, 117, 94))
end)

local function handleEndingSupportPrompt(player, errandKind, pointId, speaker, accent, successTitle, successBody, ambientLines)
	local ok, message, rewardSummary, ambientLineKey, milestoneLine, milestoneEffect, _, rotatedFromPoint, rotatedToPoint = completeEndingErrand(player, errandKind, pointId)
	if not ok then
		showDialogue(player, speaker, { message }, accent)
		return
	end

	if milestoneEffect then
		showEffect(player, milestoneEffect.kind, milestoneEffect.title, milestoneEffect.body, milestoneEffect.color, milestoneEffect.duration, milestoneEffect.pulseCount)
		showDialogue(player, speaker, milestoneLine, accent)
	else
		showEffect(player, errandKind == "restoration" and "restoration" or "warning", successTitle, string.format("%s · %s", rewardSummary, successBody), accent, 3.6, 1)
		showDialogue(player, speaker, getNextAmbientLine(player, ambientLineKey, ambientLines), accent)
	end

	if rotatedToPoint then
		showEffect(
			player,
			errandKind == "restoration" and "restoration" or "warning",
			errandKind == "restoration" and "Shared Route Shifts" or "Road Count Shifts",
			string.format("%s now points toward %s.", rotatedFromPoint and rotatedFromPoint.name or "The village", rotatedToPoint.name),
			accent,
			3.4,
			1
		)
		showDialogue(player, speaker, {
			string.format("This stop is settled for now. Take the next one to %s.", rotatedToPoint.name),
			rotatedToPoint.hint,
		}, accent)
	end
end

restorationErrandPrompt.Triggered:Connect(function(player)
	handleEndingSupportPrompt(
		player,
		"restoration",
		"sharedBasket",
		"Shared Basket",
		Color3.fromRGB(142, 220, 116),
		"Shared Harvest",
		"A fresh gourd is left where the valley can reach it.",
		{
			{ "The basket grows warmer every time someone leaves a real harvest here.", "The village answers with small thanks, not demands." },
			{ "Another fresh gourd for the shared table.", "Kindness feels more believable when it keeps costing something small and real." },
			{ "Someone will come by the well and find this before dusk.", "That is what a restored valley is supposed to feel like." },
		}
	)
end)

restorationPantryPrompt.Triggered:Connect(function(player)
	handleEndingSupportPrompt(
		player,
		"restoration",
		"wellPantry",
		"Well Pantry Drop",
		Color3.fromRGB(142, 220, 116),
		"Well Pantry Stocked",
		"A fresh gourd is tucked by the village pantry where the center path can reach it.",
		{
			{ "The well pantry keeps the middle of the village from feeling forgotten.", "A shared harvest belongs in the places everyone passes." },
			{ "Someone fetching water will see this before long.", "That is how relief starts looking ordinary instead of heroic." },
			{ "The pantry takes the gourd without ceremony.", "The valley only needs a quiet place to keep feeding itself." },
		}
	)
end)

restorationReliefPrompt.Triggered:Connect(function(player)
	handleEndingSupportPrompt(
		player,
		"restoration",
		"yardRelief",
		"Yard Relief Mat",
		Color3.fromRGB(142, 220, 116),
		"Relief Mat Filled",
		"A fresh gourd is left beside Heungbu's repaired marker for the next family that needs it.",
		{
			{ "Heungbu's marker used to only defend one yard.", "Now even this corner can pass a harvest onward." },
			{ "The mat makes the yard feel less private and more trusted.", "That is a better ending than any banner could manage." },
			{ "A repaired landmark means more when it starts feeding someone besides its owner.", "The valley remembers that." },
		}
	)
end)

tributeErrandPrompt.Triggered:Connect(function(player)
	handleEndingSupportPrompt(
		player,
		"tribute",
		"roadStand",
		"Road Due",
		Color3.fromRGB(226, 117, 94),
		"Road Due Paid",
		"The tally stand swallows another counted harvest.",
		{
			{ "The stand takes its share and the road stays quiet for one more day.", "No one cheers. That is how you know it is working." },
			{ "Counted. Accepted. The patrol route will sleep easier tonight.", "Tribute is not warmth, but it does keep arguments off the road." },
			{ "Another due paid without complaint.", "Nolbu would call that peace. Heungbu would call it endurance." },
		}
	)
end)

tributeGatePrompt.Triggered:Connect(function(player)
	handleEndingSupportPrompt(
		player,
		"tribute",
		"gateTally",
		"Gate Tally Point",
		Color3.fromRGB(226, 117, 94),
		"Gate Tally Marked",
		"Another gourd is counted under Nolbu's gate before it ever reaches the road.",
		{
			{ "The gate clerk's table feels colder than the stand by the road.", "Everything here is measured before it is accepted." },
			{ "A due paid at the gate saves the road a complaint later.", "Order likes to start as close to the house as possible." },
			{ "The tally mark dries quickly in the shade of Nolbu's gate.", "Official routines always look most natural where they are least questioned." },
		}
	)
end)

tributeRoutePrompt.Triggered:Connect(function(player)
	handleEndingSupportPrompt(
		player,
		"tribute",
		"routeMarker",
		"Route Marker Due",
		Color3.fromRGB(226, 117, 94),
		"Route Marker Claimed",
		"The roadside marker quietly claims another harvest for the road's account.",
		{
			{ "The route marker does not need a basket to feel demanding.", "It only needs everyone to know what happens if they pass it empty-handed." },
			{ "Another counted harvest disappears into the road's routine.", "Even the silence here feels supervised." },
			{ "The marker keeps watch like a threat dressed up as administration.", "Tribute survives because places like this make surrender feel ordinary." },
		}
	)
end)

wellWitnessPrompt.Triggered:Connect(function(player)
	playWitnessBark(player, "wellNeighbor")
end)

yardWitnessPrompt.Triggered:Connect(function(player)
	playWitnessBark(player, "yardHelper")
end)

roadWitnessPrompt.Triggered:Connect(function(player)
	playWitnessBark(player, "roadClerk")
end)

gateWitnessPrompt.Triggered:Connect(function(player)
	playWitnessBark(player, "gateWatcher")
end)

tributePrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.DELIVER_TRIBUTE then
		showDialogue(player, "Tribute Basket", { "The basket sits empty.", "Nolbu has not asked anything from you yet." }, Color3.fromRGB(240, 154, 107))
		return
	end
	if profile.questStage >= QUEST.COMPLETE then
		if profile.endingChoice == AMBIENT_ENDING.RESTORATION then
			showDialogue(player, "Tribute Basket", getNextAmbientLine(player, "TributeBasketRestoration", {
				{ "The basket still sits here, but the valley no longer bows to it.", "It remains as a reminder of what was resisted." },
				{ "A few splinters and an empty mouth.", "After the restored ending, this basket feels more like a warning than a rule." },
			}), Color3.fromRGB(240, 154, 107))
		elseif profile.endingChoice == AMBIENT_ENDING.TRIBUTE then
			showDialogue(player, "Tribute Basket", getNextAmbientLine(player, "TributeBasketTribute", {
				{ "The basket is part of the road now.", "No new quest hangs on it, but everyone understands what it means." },
				{ "Fresh harvest, counted harvest, quiet road.", "That is how tribute survives after the ending." },
			}), Color3.fromRGB(240, 154, 107))
		else
			showDialogue(player, "Tribute Basket", { "The tribute road is quiet for now.", "The basket waits to see what kind of story the valley chooses." }, Color3.fromRGB(240, 154, 107))
		end
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
		setQuestStage(player, QUEST.STABILIZE_VALLEY)
		syncPlayerAttributes(player)
		refreshVillageSigns()
		setPatchText("The patch is open again, but the damaged yard marker still needs steady hands.")
		showDialogue(player, "Village", {
			"The brambles are gone, but Nolbu's damage still leans over Heungbu's yard.",
			"Repair the snapped yard marker near Heungbu's house before the final audience.",
		}, Color3.fromRGB(194, 162, 255))
	end)
end)

repairMarkerPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage == QUEST.CLEAR_BRAMBLES then
		showDialogue(player, "Yard Marker", { "The marker can wait one more moment.", "Clear the patch brambles first so the yard can breathe again." }, Color3.fromRGB(142, 220, 116))
		return
	end
	if profile.questStage < QUEST.STABILIZE_VALLEY then
		showDialogue(player, "Yard Marker", { "The marker sways a little, but the valley is not asking you to fix it yet." }, Color3.fromRGB(142, 220, 116))
		return
	end
	if not supportPointDisrupted or profile.valleyStabilized then
		showDialogue(player, "Yard Marker", { "The marker stands steady again beside Heungbu's house." }, Color3.fromRGB(142, 220, 116))
		return
	end

	profile.valleyStabilized = true
	profile.coins += 5
	profile.seeds += 1
	setSupportPointState("restored")
	refreshVillageSigns()
	playPresentationSequence(player, {
		{
			effect = {
				kind = "restoration",
				title = "The Yard Stands Again",
				body = "You repair the damaged marker and steady Heungbu's side of the village.",
				color = Color3.fromRGB(142, 220, 116),
				duration = 4.6,
				pulseCount = 1,
			},
			dialogue = {
				speaker = "Heungbu",
				lines = {
					"There. Now the yard looks like hope lives here on purpose again.",
					"You answered Nolbu's spite with repair. Come back to me, and we'll decide the valley's path.",
				},
				accent = Color3.fromRGB(111, 224, 128),
			},
			delay = 0.2,
		},
	}, function()
		setQuestStage(player, QUEST.FINAL_AUDIENCE)
		syncPlayerAttributes(player)
		refreshVillageSigns()
		setPatchText("The patch and yard are steady again. Return to Heungbu and decide what kind of harvest the valley will protect.")
		showDialogue(player, "Village", {
			"The yard stands steady again.",
			"Return to Heungbu for the valley's final audience.",
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
