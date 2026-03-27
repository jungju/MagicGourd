print("MagicGourd server started")

local InsertService = game:GetService("InsertService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
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

local villageState = {
	gourdsHarvested = 0,
}

local playerData = {}

local function getPlayerProfile(player)
	local profile = playerData[player]
	if profile then
		return profile
	end

	profile = {
		seeds = 1,
		gourds = 0,
		coins = 0,
		questStage = 0,
	}
	playerData[player] = profile
	return profile
end

local function syncPlayerAttributes(player)
	local profile = getPlayerProfile(player)
	player:SetAttribute("Seeds", profile.seeds)
	player:SetAttribute("Gourds", profile.gourds)
	player:SetAttribute("Coins", profile.coins)
	player:SetAttribute("QuestStage", profile.questStage)
end

Players.PlayerAdded:Connect(function(player)
	syncPlayerAttributes(player)
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
	root:SetNetworkOwner(nil)
	humanoid.WalkSpeed = def.walkSpeed or humanoid.WalkSpeed

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
				})
				local ok = pcall(function()
					path:ComputeAsync(root.Position, target.Position)
				end)
				if ok and path.Status == Enum.PathStatus.Success then
					for _, waypoint in ipairs(path:GetWaypoints()) do
						if waypoint.Action == Enum.PathWaypointAction.Jump then
							humanoid.Jump = true
						end
						humanoid:MoveTo(waypoint.Position)
						local reached = humanoid.MoveToFinished:Wait()
						if not reached or not model.Parent then
							break
						end
					end
				else
					humanoid:MoveTo(target.Position)
					humanoid.MoveToFinished:Wait()
				end
				task.wait(0.4 + math.random() * 1.2)
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

local heungbuPad = addPart(placedAssets, "HeungbuYardPad", Vector3.new(34, 0.8, 24), CFrame.new(-72, 1.0, 48) * CFrame.Angles(0, math.rad(-20), 0), Color3.fromRGB(133, 99, 63), Enum.Material.Ground)
local nolbuPad = addPart(placedAssets, "NolbuFrontYard", Vector3.new(40, 0.8, 28), CFrame.new(74, 1.0, 44) * CFrame.Angles(0, math.rad(18), 0), Color3.fromRGB(142, 111, 77), Enum.Material.Ground)
local villageWell = addPart(placedAssets, "VillageWell", Vector3.new(10, 5, 10), CFrame.new(0, 3.1, 36), Color3.fromRGB(114, 101, 86), Enum.Material.Slate)
local marketMat = addPart(placedAssets, "SeedMat", Vector3.new(12, 0.6, 10), CFrame.new(-24, 1.2, 34), Color3.fromRGB(156, 106, 64), Enum.Material.WoodPlanks)
local gourdPatch = addPart(placedAssets, "GourdPatch", Vector3.new(14, 1, 12), CFrame.new(-96, 1.5, 13), Color3.fromRGB(80, 55, 34), Enum.Material.Mud)
local festivalStone = addPart(placedAssets, "FestivalStone", Vector3.new(8, 2, 8), CFrame.new(22, 1.8, 54), Color3.fromRGB(124, 118, 112), Enum.Material.Slate)

attachBillboard(heungbuPad, "Heungbu Yard", "A small place to plant hope.", Color3.fromRGB(111, 224, 128))
attachBillboard(nolbuPad, "Nolbu Gate", "His workers keep pacing the road.", Color3.fromRGB(226, 117, 94))
attachBillboard(villageWell, "Village Well", "The center of the little valley.", Color3.fromRGB(98, 197, 215))
attachBillboard(marketMat, "Seed Mat", "Pick up a seed pouch if you need one.", Color3.fromRGB(227, 188, 96))
attachBillboard(festivalStone, "Story Stone", "Villagers whisper about a magic gourd.", Color3.fromRGB(194, 162, 255))

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

local heungbuTalkPart = ensureInteractionPart("HeungbuTalkPart", Vector3.new(-72, 5, 44), Vector3.new(8, 8, 8))
local heungbuPrompt = createPrompt(heungbuTalkPart, "Talk", "Heungbu", 0.2, 14)
local heungbuSign = attachBillboard(heungbuTalkPart, "Heungbu", "Needs one healthy gourd to lift the family's spirits.", Color3.fromRGB(111, 224, 128))

local seedPart = ensureInteractionPart("SeedBasket", Vector3.new(-24, 3, 34), Vector3.new(8, 6, 8))
local seedPrompt = createPrompt(seedPart, "Collect", "Seed Basket", 0.15, 12)

local patchPart = ensureInteractionPart("PlantPatch", Vector3.new(-96, 3, 13), Vector3.new(10, 6, 10))
local plantPrompt = createPrompt(patchPart, "Plant / Harvest", "Gourd Patch", 0.25, 14)
local patchSign = attachBillboard(patchPart, "Gourd Patch", "Bring a seed, then return when the vine is ready.", Color3.fromRGB(120, 219, 95))

local nolbuTalkPart = ensureInteractionPart("NolbuComplaint", Vector3.new(74, 5, 48), Vector3.new(8, 8, 8))
local nolbuPrompt = createPrompt(nolbuTalkPart, "Listen", "Nolbu's Boast", 0.15, 12)

local storyStonePart = ensureInteractionPart("StoryStonePrompt", Vector3.new(22, 3.5, 54), Vector3.new(8, 5, 8))
local storyPrompt = createPrompt(storyStonePart, "Read", "Story Stone", 0.1, 12)

local currentCrop = {
	state = "empty",
	owner = nil,
	readyAt = 0,
}

local function setPatchText(text)
	local frame = patchSign:FindFirstChildWhichIsA("Frame")
	if not frame then
		return
	end
	local labels = frame:GetChildren()
	for _, child in ipairs(labels) do
		if child:IsA("TextLabel") and child.Name ~= "Title" then
			child.Text = text
		end
	end
end

seedPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	profile.seeds += 1
	if profile.questStage < 1 then
		profile.questStage = 1
	end
	syncPlayerAttributes(player)
	seedPrompt.ObjectText = string.format("Seed Basket · %s now has %d", player.Name, profile.seeds)
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
			task.delay(2, function()
				if plantPrompt.Parent then
					plantPrompt.ObjectText = "Gourd Patch"
				end
			end)
			return
		end

		profile.seeds -= 1
		profile.questStage = math.max(profile.questStage, 2)
		currentCrop.state = "growing"
		currentCrop.owner = player
		currentCrop.readyAt = os.clock() + 20
		gourdPatch.Color = Color3.fromRGB(84, 124, 52)
		setPatchText("A vine is growing. Return in a short while.")
		plantPrompt.ObjectText = "Growing..."
		syncPlayerAttributes(player)

		task.delay(20, function()
			if currentCrop.state == "growing" then
				currentCrop.state = "ready"
				gourdPatch.Color = Color3.fromRGB(196, 138, 58)
				setPatchText("The gourd is ready to harvest.")
				if plantPrompt.Parent then
					plantPrompt.ObjectText = "Harvest Gourd"
				end
			end
		end)
		return
	end

	if currentCrop.state == "growing" then
		plantPrompt.ObjectText = "Still Growing"
		task.delay(2, function()
			if plantPrompt.Parent then
				plantPrompt.ObjectText = "Growing..."
			end
		end)
		return
	end

	if currentCrop.state == "ready" then
		profile.gourds += 1
		profile.questStage = math.max(profile.questStage, 3)
		villageState.gourdsHarvested += 1
		currentCrop.state = "empty"
		currentCrop.owner = nil
		currentCrop.readyAt = 0
		gourdPatch.Color = Color3.fromRGB(80, 55, 34)
		setPatchText("Bring a seed, then return when the vine is ready.")
		plantPrompt.ObjectText = "Gourd Patch"
		syncPlayerAttributes(player)
	end
end)

heungbuPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	if profile.gourds <= 0 then
		heungbuPrompt.ObjectText = "Heungbu Needs a Gourd"
		task.delay(2, function()
			if heungbuPrompt.Parent then
				heungbuPrompt.ObjectText = "Heungbu"
			end
		end)
		return
	end

	profile.gourds -= 1
	profile.coins += 5
	profile.questStage = math.max(profile.questStage, 4)
	syncPlayerAttributes(player)
	heungbuPrompt.ObjectText = string.format("Blessings! %s earned 5 coins.", player.Name)
	local frame = heungbuSign:FindFirstChildWhichIsA("Frame")
	local bodyLabel = frame and frame:FindFirstChild("Body")
	if bodyLabel and bodyLabel:IsA("TextLabel") then
		bodyLabel.Text = string.format("Delivered gourds: %d · Coins earned: %d", villageState.gourdsHarvested, profile.coins)
	end
	task.delay(3, function()
		if heungbuPrompt.Parent then
			heungbuPrompt.ObjectText = "Heungbu"
		end
	end)
end)

nolbuPrompt.Triggered:Connect(function(player)
	local profile = getPlayerProfile(player)
	profile.questStage = math.max(profile.questStage, 1)
	syncPlayerAttributes(player)
	nolbuPrompt.ObjectText = string.format("Nolbu scoffs: 'I have %d workers, you have none!'", #patrolANodes + #patrolBNodes)
	task.delay(3, function()
		if nolbuPrompt.Parent then
			nolbuPrompt.ObjectText = "Nolbu's Boast"
		end
	end)
end)

storyPrompt.Triggered:Connect(function(player)
	storyPrompt.ObjectText = string.format("Village harvests: %d", villageState.gourdsHarvested)
	task.delay(3, function()
		if storyPrompt.Parent then
			storyPrompt.ObjectText = "Story Stone"
		end
	end)
	local profile = getPlayerProfile(player)
	if profile.questStage == 0 then
		profile.questStage = 1
		syncPlayerAttributes(player)
	end
end)
