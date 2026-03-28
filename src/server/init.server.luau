print("MagicGourd server started")

local InsertService = game:GetService("InsertService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local map = Workspace:WaitForChild("Map")
local runtimeFolder = map:FindFirstChild("Runtime")
if not runtimeFolder then
	runtimeFolder = Instance.new("Folder")
	runtimeFolder.Name = "Runtime"
	runtimeFolder.Parent = map
end

local placedAssets = runtimeFolder:FindFirstChild("PlacedAssets")
if not placedAssets then
	placedAssets = Instance.new("Folder")
	placedAssets.Name = "PlacedAssets"
	placedAssets.Parent = runtimeFolder
end

local interactionFolder = runtimeFolder:FindFirstChild("InteractionNodes")
if not interactionFolder then
	interactionFolder = Instance.new("Folder")
	interactionFolder.Name = "InteractionNodes"
	interactionFolder.Parent = runtimeFolder
end

local wanderFolder = runtimeFolder:FindFirstChild("WanderNodes")
if not wanderFolder then
	wanderFolder = Instance.new("Folder")
	wanderFolder.Name = "WanderNodes"
	wanderFolder.Parent = runtimeFolder
end

local sharedFolder = ReplicatedStorage:FindFirstChild("Shared") or ReplicatedStorage
local dialogueEvent = sharedFolder:FindFirstChild("DialogueEvent")
if not dialogueEvent then
	dialogueEvent = Instance.new("RemoteEvent")
	dialogueEvent.Name = "DialogueEvent"
	dialogueEvent.Parent = sharedFolder
end

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
	COMPLETE = 11,
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
	[QUEST.COMPLETE] = "Village Friend",
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
	[QUEST.COMPLETE] = "Keep helping the village. Extra gourds still earn coins from Heungbu.",
}

local villageState = {
	gourdsHarvested = 0,
	heungbuDeliveries = 0,
	nolbuTributes = 0,
	herbBundlesPicked = 0,
	swallowHelped = 0,
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
		questStage = QUEST.INTRO,
		heungbuDeliveries = 0,
		nolbuTributes = 0,
		bonusSeedsClaimed = false,
		swallowInspected = false,
		swallowHelped = false,
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

local function syncPlayerAttributes(player)
	local profile = getPlayerProfile(player)
	local title = QUEST_TITLES[profile.questStage] or "Village Tale"
	local objective = QUEST_OBJECTIVES[profile.questStage] or "Help the village."

	player:SetAttribute("Seeds", profile.seeds)
	player:SetAttribute("Gourds", profile.gourds)
	player:SetAttribute("Herbs", profile.herbs)
	player:SetAttribute("Coins", profile.coins)
	player:SetAttribute("QuestStage", profile.questStage)
	player:SetAttribute("QuestTitle", title)
	player:SetAttribute("QuestObjective", objective)
	player:SetAttribute("HeungbuDeliveries", profile.heungbuDeliveries)
	player:SetAttribute("NolbuTributes", profile.nolbuTributes)
end

local function showDialogue(player, speaker, lines, accent)
	dialogueEvent:FireClient(player, {
		speaker = speaker,
		lines = lines,
		accent = accent,
	})
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
	if existing then
		existing:Destroy()
	end
end

local function clearInteraction(name)
	local existing = interactionFolder:FindFirstChild(name)
	if existing then
		existing:Destroy()
	end
end

local function getPrimary(instance)
	if instance:IsA("Model") then
		if instance.PrimaryPart then
			return instance.PrimaryPart
		end
		return instance:FindFirstChildWhichIsA("BasePart", true)
	elseif instance:IsA("BasePart") then
		return instance
	end
	return nil
end

local function setModelCollision(model, canCollide)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = canCollide
		end
	end
end

local function anchorModel(model, anchored)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = anchored
		end
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

local function createFallbackHouse(def)
	local model = Instance.new("Model")
	model.Name = def.name

	local yaw = math.rad((def.rotation and def.rotation.Y) or 0)
	local baseCf = CFrame.new(def.position) * CFrame.Angles(0, yaw, 0)
	local footprint = def.footprint or Vector3.new(26, 18, 22)

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
	rootJoint.Name = "RootJoint"
	rootJoint.Part0 = root
	rootJoint.Part1 = torso
	rootJoint.Parent = root

	local neck = Instance.new("Motor6D")
	neck.Name = "Neck"
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
	local rotation = def.rotation or Vector3.zero
	local cf = CFrame.new(def.position) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))

	if candidate:IsA("Model") then
		local primary = getPrimary(candidate)
		if not primary then
			return false, "model has no basepart"
		end

		candidate.PrimaryPart = primary
		if typeof(def.scale) == "number" and def.scale > 0 and def.scale ~= 1 then
			pcall(function()
				candidate:ScaleTo(def.scale)
			end)
		end

		candidate:PivotTo(cf)
		local boxCf, boxSize = candidate:GetBoundingBox()
		local bottomY = boxCf.Position.Y - (boxSize.Y / 2)
		local lift = def.position.Y - bottomY + (def.groundOffset or 0)
		if math.abs(lift) > 0.001 then
			candidate:PivotTo(candidate:GetPivot() + Vector3.new(0, lift, 0))
		end
		return true
	elseif candidate:IsA("BasePart") then
		if typeof(def.scale) == "number" and def.scale > 0 and def.scale ~= 1 then
			candidate.Size = candidate.Size * def.scale
		end
		candidate.CFrame = cf
		candidate.Anchored = true
		local bottomY = candidate.Position.Y - (candidate.Size.Y / 2)
		local lift = def.position.Y - bottomY + (def.groundOffset or 0)
		candidate.Position += Vector3.new(0, lift, 0)
		return true
	end

	return false, "unsupported instance type"
end

local function tryLoadAsset(def)
	local ok, container = pcall(function()
		return InsertService:LoadAsset(def.assetId)
	end)
	if not ok then
		return nil, tostring(container)
	end

	local candidate = container:GetChildren()[1]
	if not candidate then
		container:Destroy()
		return nil, "asset returned no children"
	end

	candidate.Name = def.name
	candidate.Parent = placedAssets

	local placedOk, placeError = applyPlacement(candidate, def)
	container:Destroy()

	if not placedOk then
		candidate:Destroy()
		return nil, placeError
	end

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
	if body and body:IsA("TextLabel") then
		body.Text = text
	end
end

local function makeWanderNode(name, position)
	local part = wanderFolder:FindFirstChild(name)
	if part then
		part.Position = position
		return part
	end

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
		local position = center + Vector3.new(math.cos(angle) * radius, 2, math.sin(angle) * radius)
		table.insert(nodes, makeWanderNode(string.format("%s_%d", prefix, index), position))
	end
	return nodes
end

local function startWanderNpc(model, def)
	local humanoid = model:FindFirstChildWhichIsA("Humanoid", true)
	local root = model:FindFirstChild("HumanoidRootPart", true) or getPrimary(model)
	if not humanoid or not root or not root:IsA("BasePart") then
		warn(string.format("[MagicGourd] Cannot wander %s; missing humanoid/root", model.Name))
		return
	end

	anchorModel(model, false)
	setModelCollision(model, true)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant ~= root then
			descendant.Massless = true
		end
	end
	root:SetNetworkOwner(nil)
	root.CanCollide = false
	humanoid.WalkSpeed = def.walkSpeed or humanoid.WalkSpeed
	humanoid.AutoRotate = true

	task.spawn(function()
		local nodes = def.nodes
		local index = 1
		while model.Parent do
			local target = nodes[index]
			if target and target.Parent then
				local path = PathfindingService:CreatePath({
					AgentRadius = 2,
					AgentHeight = 5,
					AgentCanJump = true,
					WaypointSpacing = 4,
				})
				local ok = pcall(function()
					path:ComputeAsync(root.Position, target.Position)
				end)
				local traversed = false
				if ok and path.Status == Enum.PathStatus.Success then
					traversed = true
					for _, waypoint in ipairs(path:GetWaypoints()) do
						if waypoint.Action == Enum.PathWaypointAction.Jump then
							humanoid.Jump = true
						end
						humanoid:MoveTo(waypoint.Position)
						local reached = humanoid.MoveToFinished:Wait()
						if not reached or not model.Parent then
							traversed = false
							break
						end
					end
				end
				if not traversed then
					humanoid:MoveTo(target.Position)
					humanoid.MoveToFinished:Wait()
				end
				if root.Parent then
					root.CFrame = CFrame.lookAt(root.Position, target.Position)
				end
				task.wait(0.5 + math.random() * 1.1)
			end
			index += 1
			if index > #nodes then
				index = 1
			end
		end
	end)
end

local assetDefinitions = {
	{
		name = "HeungbuHouse",
		assetId = 93969099298348,
		kind = "house",
		position = Vector3.new(-72, 1.0, 28),
		rotation = Vector3.new(90, -22, 0),
		scale = 6,
		groundOffset = 0,
		footprint = Vector3.new(34, 18, 26),
		fallbackLabel = "Heungbu's Home",
		fallbackText = "A humble house filled with hope.",
	},
	{
		name = "NolbuHouse",
		assetId = 76012677304613,
		kind = "house",
		position = Vector3.new(74, 1.0, 18),
		rotation = Vector3.new(90, 20, 0),
		scale = 10,
		groundOffset = 0,
		footprint = Vector3.new(42, 22, 30),
		fallbackLabel = "Nolbu's Estate",
		fallbackText = "Bigger, louder, and much less welcoming.",
	},
	{
		name = "NolbuPatrolA",
		assetId = 81648951264309,
		kind = "npc",
		position = Vector3.new(58, 3.2, 34),
		rotation = Vector3.new(0, 180, 0),
		scale = 1,
		groundOffset = 0,
		walkSpeed = 8,
	},
	{
		name = "NolbuPatrolB",
		assetId = 81648951264309,
		kind = "npc",
		position = Vector3.new(92, 3.2, 42),
		rotation = Vector3.new(0, 110, 0),
		scale = 1,
		groundOffset = 0,
		walkSpeed = 7,
	},
}

local placedByName = {}

for _, def in ipairs(assetDefinitions) do
	clearExisting(def.name)
	local candidate, err = tryLoadAsset(def)
	if not candidate then
		warn(string.format("[MagicGourd] Falling back for %s: %s", def.name, tostring(err)))
		if def.kind == "house" then
			candidate = createFallbackHouse(def)
		elseif def.kind == "npc" then
			candidate = createFallbackNpc(def)
		end
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
local clothesPoleA = addPart(placedAssets, "ClothesPoleA", Vector3.new(1, 8, 1), CFrame.new(villageLayout.village.clothesline.position + Vector3.new(-7, -4, 0)), Color3.fromRGB(117, 86, 61), Enum.Material.Wood)
local clothesPoleB = addPart(placedAssets, "ClothesPoleB", Vector3.new(1, 8, 1), CFrame.new(villageLayout.village.clothesline.position + Vector3.new(7, -4, 0)), Color3.fromRGB(117, 86, 61), Enum.Material.Wood)
local clothA = addPart(placedAssets, "DryingClothA", Vector3.new(3, 2.5, 0.2), CFrame.new(villageLayout.village.clothesline.position + Vector3.new(-3, -1, 0.3)), Color3.fromRGB(222, 219, 204), Enum.Material.Fabric)
local clothB = addPart(placedAssets, "DryingClothB", Vector3.new(3, 2.5, 0.2), CFrame.new(villageLayout.village.clothesline.position + Vector3.new(2, -1.2, -0.3)), Color3.fromRGB(196, 214, 164), Enum.Material.Fabric)
local swallowNest = addCylinder(placedAssets, "SwallowNest", Vector3.new(2.2, 1.6, 2.2), CFrame.new(villageLayout.nolbu.swallowPart.position + Vector3.new(0, -2.2, 0)) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(111, 79, 49), Enum.Material.WoodPlanks)
local injuredSwallowMarker = addPart(placedAssets, "InjuredSwallowMarker", Vector3.new(1.6, 0.6, 2.4), CFrame.new(villageLayout.nolbu.swallowPart.position + Vector3.new(0, -1.1, 0)) * CFrame.Angles(0, math.rad(-24), math.rad(14)), Color3.fromRGB(43, 43, 46), Enum.Material.SmoothPlastic)
injuredSwallowMarker.CanCollide = false
local swallowWing = addPart(placedAssets, "SwallowWing", Vector3.new(2.8, 0.2, 1.1), injuredSwallowMarker.CFrame * CFrame.new(0, 0.15, 0), Color3.fromRGB(222, 226, 234), Enum.Material.SmoothPlastic)
swallowWing.CanCollide = false

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

if placedByName.NolbuPatrolA then
	startWanderNpc(placedByName.NolbuPatrolA, {
		walkSpeed = 8,
		nodes = patrolANodes,
	})
end

if placedByName.NolbuPatrolB then
	startWanderNpc(placedByName.NolbuPatrolB, {
		walkSpeed = 7,
		nodes = patrolBNodes,
	})
end

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

local currentCrop = {
	state = "empty",
	owner = nil,
	readyAt = 0,
}

local function setPatchText(text)
	setBillboardBody(patchSign, text)
end

local function refreshVillageSigns()
	setBillboardBody(heungbuSign, string.format("Deliveries: %d · Swallows helped: %d", villageState.heungbuDeliveries, villageState.swallowHelped))
	setBillboardBody(heungbuPadSign, string.format("Harvests gathered: %d · Kindness still lives here.", villageState.gourdsHarvested))
	setBillboardBody(nolbuPadSign, string.format("Patrols circling: %d · Tributes demanded: %d", #patrolANodes + #patrolBNodes, villageState.nolbuTributes))
	setBillboardBody(tributeSign, string.format("Tributes paid: %d · Nolbu still wants more.", villageState.nolbuTributes))
	setBillboardBody(herbSign, string.format("Herb bundles picked: %d · The well garden smells sharp and clean.", villageState.herbBundlesPicked))
	setBillboardBody(swallowSign, villageState.swallowHelped > 0 and "The swallow has been tended. It twitches with a little strength now." or "Something small is trembling by Nolbu's wall.")
end

refreshVillageSigns()

seedPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	profile.seeds += 1
	if profile.questStage <= QUEST.MEET_HEUNGBU then
		setQuestStage(player, QUEST.PLANT_FIRST)
	end
	syncPlayerAttributes(player)
	seedPrompt.ObjectText = string.format("Seed Basket · %s now has %d", player.Name, profile.seeds)
	showDialogue(player, "Seed Basket", {
		"You take a small seed pouch.",
		"Maybe this harvest can change the mood of the village.",
	}, Color3.fromRGB(227, 188, 96))
	task.delay(2, function()
		if seedPrompt.Parent then
			seedPrompt.ObjectText = "Seed Basket"
		end
	end)
end)

plantPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)

	if currentCrop.state == "empty" then
		if profile.seeds <= 0 then
			plantPrompt.ObjectText = "Need a Seed"
			showDialogue(player, "Patch", {
				"The soil is ready, but your hands are empty.",
				"Grab another seed from the basket in the village.",
			}, Color3.fromRGB(170, 115, 82))
			task.delay(2, function()
				if plantPrompt.Parent then
					plantPrompt.ObjectText = "Gourd Patch"
				end
			end)
			return
		end

		profile.seeds -= 1
		setQuestStage(player, QUEST.HARVEST_FIRST)
		currentCrop.state = "growing"
		currentCrop.owner = player
		currentCrop.readyAt = os.clock() + 20
		gourdPatch.Color = Color3.fromRGB(84, 124, 52)
		setPatchText("A vine is curling out of the soil. Give it a moment.")
		plantPrompt.ObjectText = "Growing..."
		syncPlayerAttributes(player)
		showDialogue(player, "Patch", {
			"The seed sinks into the earth.",
			"A green vine begins to wake beneath the soil.",
		}, Color3.fromRGB(120, 219, 95))

		task.delay(20, function()
			if currentCrop.state == "growing" then
				currentCrop.state = "ready"
				gourdPatch.Color = Color3.fromRGB(196, 138, 58)
				setPatchText("The vine is heavy now. The gourd is ready to harvest.")
				if plantPrompt.Parent then
					plantPrompt.ObjectText = "Harvest Gourd"
				end
			end
		end)
		return
	end

	if currentCrop.state == "growing" then
		plantPrompt.ObjectText = "Still Growing"
		showDialogue(player, "Patch", {
			"Not yet.",
			"The vine still needs a little time.",
		}, Color3.fromRGB(120, 219, 95))
		task.delay(2, function()
			if plantPrompt.Parent then
				plantPrompt.ObjectText = "Growing..."
			end
		end)
		return
	end

	if currentCrop.state == "ready" then
		profile.gourds += 1
		setQuestStage(player, math.max(profile.questStage, QUEST.DELIVER_FIRST))
		villageState.gourdsHarvested += 1
		currentCrop.state = "empty"
		currentCrop.owner = nil
		currentCrop.readyAt = 0
		gourdPatch.Color = Color3.fromRGB(80, 55, 34)
		setPatchText("Bring a seed, then return when the vine is ready.")
		plantPrompt.ObjectText = "Gourd Patch"
		syncPlayerAttributes(player)
		refreshVillageSigns()
		showDialogue(player, "Harvest", {
			"You lift a ripe gourd from the vine.",
			"Someone in the village could really use this.",
		}, Color3.fromRGB(235, 179, 92))
	end
end)

heungbuPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)

	if profile.questStage <= QUEST.MEET_HEUNGBU then
		setQuestStage(player, QUEST.MEET_HEUNGBU)
		syncPlayerAttributes(player)
		setBillboardBody(heungbuSign, "Heungbu: 'A single healthy gourd would lift the whole house.'")
		showDialogue(player, "Heungbu", {
			"Our home is plain, but hope still fits inside it.",
			"Could you grow one good gourd for my family?",
		}, Color3.fromRGB(111, 224, 128))
		return
	end

	if profile.questStage == QUEST.BRING_HERBS then
		if profile.herbs <= 0 then
			showDialogue(player, "Heungbu", {
				"The swallow is still breathing, but barely.",
				"Please bring fresh herbs from the well garden.",
			}, Color3.fromRGB(111, 224, 128))
			return
		end

		profile.herbs -= 1
		profile.coins += 10
		profile.seeds += 1
		profile.swallowHelped = true
		villageState.swallowHelped += 1
		setQuestStage(player, QUEST.COMPLETE)
		syncPlayerAttributes(player)
		refreshVillageSigns()
		setBillboardBody(heungbuSign, "Heungbu: 'Even a hurt swallow can find home again.'")
		showDialogue(player, "Heungbu", {
			"These herbs will do. My family knows how to bind a little wing.",
			"Kindness came back to the yard with you today.",
			"Take this seed and these coins. The next gourd may yet split this story wide open.",
		}, Color3.fromRGB(111, 224, 128))
		return
	end

	if profile.gourds <= 0 then
		if profile.questStage == QUEST.CLAIM_HELP then
			if not profile.bonusSeedsClaimed then
				profile.seeds += 2
				profile.bonusSeedsClaimed = true
			end
			setQuestStage(player, QUEST.HEAR_NOLBU)
			syncPlayerAttributes(player)
			showDialogue(player, "Heungbu", {
				"Your kindness reached our table before sunset.",
				"Take two more seeds. Nolbu has started boasting again at his gate.",
				"If you hear him out, maybe this story can grow a little further.",
			}, Color3.fromRGB(111, 224, 128))
			return
		end

		heungbuPrompt.ObjectText = "Heungbu Needs a Gourd"
		showDialogue(player, "Heungbu", {
			"I can wait, but the house is still hungry for good news.",
			"Bring a ripe gourd when you have one.",
		}, Color3.fromRGB(111, 224, 128))
		task.delay(2, function()
			if heungbuPrompt.Parent then
				heungbuPrompt.ObjectText = "Heungbu"
			end
		end)
		return
	end

	profile.gourds -= 1
	profile.coins += 5
	profile.heungbuDeliveries += 1
	villageState.heungbuDeliveries += 1
	if profile.questStage <= QUEST.DELIVER_FIRST then
		setQuestStage(player, QUEST.CLAIM_HELP)
	elseif profile.questStage >= QUEST.COMPLETE then
		profile.coins += 1
	end
	syncPlayerAttributes(player)
	refreshVillageSigns()
	heungbuPrompt.ObjectText = string.format("Blessings! %s earned %d coins.", player.Name, profile.questStage >= QUEST.COMPLETE and 6 or 5)
	showDialogue(player, "Heungbu", profile.questStage == QUEST.CLAIM_HELP and {
		"You brought back exactly what we needed.",
		"Please, talk to me once more. I have seeds to spare and a warning about Nolbu.",
	} or {
		"Another good gourd! You keep this valley cheerful.",
		"Please take these coins with my thanks.",
	}, Color3.fromRGB(111, 224, 128))
	task.delay(3, function()
		if heungbuPrompt.Parent then
			heungbuPrompt.ObjectText = "Heungbu"
		end
	end)
end)

nolbuPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.HEAR_NOLBU then
		setQuestStage(player, QUEST.MEET_HEUNGBU)
		syncPlayerAttributes(player)
		showDialogue(player, "Nolbu", {
			"Even my gate has more attention than Heungbu's entire house.",
			"Run along. I only speak with people carrying results.",
		}, Color3.fromRGB(226, 117, 94))
		return
	end

	if profile.questStage == QUEST.HEAR_NOLBU then
		setQuestStage(player, QUEST.DELIVER_TRIBUTE)
		syncPlayerAttributes(player)
		showDialogue(player, "Nolbu", {
			"So Heungbu found help? Hah.",
			"If your harvest is truly special, put one gourd in my tribute basket.",
			"Then I might stop sneering long enough to notice you.",
		}, Color3.fromRGB(226, 117, 94))
		return
	end

	if profile.questStage >= QUEST.INVESTIGATE_SWALLOW and not profile.swallowHelped then
		showDialogue(player, "Nolbu", {
			"A bird hit my wall. Hardly my problem.",
			"If Heungbu wants to play healer, let him waste his morning on it.",
		}, Color3.fromRGB(226, 117, 94))
		return
	end

	showDialogue(player, "Nolbu", {
		string.format("My estate still has %d patrol steps and %d reasons to stay impressed.", #patrolANodes + #patrolBNodes, villageState.nolbuTributes),
		"If you have a spare gourd, the basket is right there.",
	}, Color3.fromRGB(226, 117, 94))
end)

tributePrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.DELIVER_TRIBUTE then
		showDialogue(player, "Tribute Basket", {
			"The basket sits empty.",
			"Nolbu has not asked anything from you yet.",
		}, Color3.fromRGB(240, 154, 107))
		return
	end

	if profile.questStage >= QUEST.INVESTIGATE_SWALLOW then
		showDialogue(player, "Tribute Basket", {
			"The tribute is already paid.",
			"Something more important is happening by the wall.",
		}, Color3.fromRGB(240, 154, 107))
		return
	end

	if profile.gourds <= 0 then
		showDialogue(player, "Tribute Basket", {
			"You have nothing to offer.",
			"Grow another gourd first.",
		}, Color3.fromRGB(240, 154, 107))
		return
	end

	profile.gourds -= 1
	profile.coins += 8
	profile.nolbuTributes += 1
	villageState.nolbuTributes += 1
	setQuestStage(player, QUEST.INVESTIGATE_SWALLOW)
	syncPlayerAttributes(player)
	refreshVillageSigns()
	showDialogue(player, "Nolbu", {
		"Hmph. At least the harvest looks worthy.",
		"Take your coin and move aside— ah, what was that fluttering by the wall?",
		"If you must fuss over it, do it somewhere else.",
	}, Color3.fromRGB(226, 117, 94))
end)

swallowPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.INVESTIGATE_SWALLOW then
		showDialogue(player, "Swallow", {
			"A little nest clings to the wall.",
			"Nothing has happened here yet.",
		}, Color3.fromRGB(167, 205, 255))
		return
	end

	if profile.swallowHelped then
		showDialogue(player, "Swallow", {
			"The swallow blinks and settles into the nest.",
			"It still looks fragile, but it is no longer alone.",
		}, Color3.fromRGB(167, 205, 255))
		return
	end

	if not profile.swallowInspected then
		profile.swallowInspected = true
		setQuestStage(player, QUEST.GATHER_HERBS)
		syncPlayerAttributes(player)
		setBillboardBody(swallowSign, "A swallow lies here with a bent wing. Heungbu might know how to help.")
		showDialogue(player, "Swallow", {
			"A swallow is shivering against the wall, one wing hanging low.",
			"There is a faint thread tied to its leg—as if it nested near Heungbu's yard before.",
			"Fresh herbs from the well garden might keep it alive long enough to carry home.",
		}, Color3.fromRGB(167, 205, 255))
		return
	end

	showDialogue(player, "Swallow", {
		"The bird gives a weak flutter.",
		"It still needs healing herbs from the village well.",
	}, Color3.fromRGB(167, 205, 255))
end)

herbPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage < QUEST.GATHER_HERBS then
		showDialogue(player, "Herb Garden", {
			"The herb patch smells fresh and sharp.",
			"You do not need anything from it yet.",
		}, Color3.fromRGB(103, 220, 117))
		return
	end

	if profile.questStage > QUEST.BRING_HERBS then
		showDialogue(player, "Herb Garden", {
			"The leaves sway quietly by the well.",
			"For now, the village only asks you to keep growing.",
		}, Color3.fromRGB(103, 220, 117))
		return
	end

	if profile.herbs > 0 then
		showDialogue(player, "Herb Garden", {
			"You already gathered a fresh bundle.",
			"Bring it to Heungbu before the leaves wilt.",
		}, Color3.fromRGB(103, 220, 117))
		return
	end

	profile.herbs += 1
	villageState.herbBundlesPicked += 1
	setQuestStage(player, QUEST.BRING_HERBS)
	syncPlayerAttributes(player)
	refreshVillageSigns()
	herbPrompt.ObjectText = string.format("Herbs for %s", player.Name)
	showDialogue(player, "Herb Garden", {
		"You gather a careful bundle of healing herbs.",
		"The leaves are cool with well mist.",
		"Bring them to Heungbu before the swallow fades.",
	}, Color3.fromRGB(103, 220, 117))
	task.delay(2, function()
		if herbPrompt.Parent then
			herbPrompt.ObjectText = "Healing Herbs"
		end
	end)
end)

storyPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.questStage == QUEST.INTRO then
		setQuestStage(player, QUEST.MEET_HEUNGBU)
		syncPlayerAttributes(player)
	end
	storyPrompt.ObjectText = string.format("Village harvests: %d", villageState.gourdsHarvested)
	showDialogue(player, "Story Stone", {
		"In this valley, kindness grows quietly and greed makes a lot of noise.",
		"Heungbu shares what little he has. Nolbu counts what everyone else owes.",
		"A single magic gourd can push their story forward, but even a swallow can change the ending.",
	}, Color3.fromRGB(194, 162, 255))
	task.delay(3, function()
		if storyPrompt.Parent then
			storyPrompt.ObjectText = "Story Stone"
		end
	end)
end)
