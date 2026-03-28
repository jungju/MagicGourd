local Workspace = game:GetService("Workspace")

local ArcadeWorld = {}
local UPGRADE_PROMPT_DISTANCE = 9

local function createFolder(parent, name)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function createPart(parent, name, size, cframe, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Color = color
	part.Material = material
	part.Parent = parent
	return part
end

local function createPrompt(parent, actionText, objectText, maxDistance)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.MaxActivationDistance = maxDistance or 12
	prompt.RequiresLineOfSight = false
	prompt.HoldDuration = 0
	prompt.Parent = parent
	return prompt
end

local function attachBillboard(part, title, body, color)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Sign"
	billboard.Size = UDim2.fromOffset(220, 82)
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
	billboard.AlwaysOnTop = true
	billboard.Adornee = part
	billboard.Parent = part

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(20, 18, 16)
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = 2
	stroke.Parent = frame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.fromOffset(10, 8)
	titleLabel.Size = UDim2.new(1, -20, 0, 22)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(248, 240, 218)
	titleLabel.TextScaled = true
	titleLabel.Parent = frame

	local bodyLabel = Instance.new("TextLabel")
	bodyLabel.BackgroundTransparency = 1
	bodyLabel.Position = UDim2.fromOffset(10, 32)
	bodyLabel.Size = UDim2.new(1, -20, 1, -40)
	bodyLabel.Font = Enum.Font.Gotham
	bodyLabel.Text = body
	bodyLabel.TextWrapped = true
	bodyLabel.TextColor3 = Color3.fromRGB(232, 226, 214)
	bodyLabel.TextScaled = true
	bodyLabel.Parent = frame
end

local function createLantern(parent, name, position, color)
	createPart(parent, name .. "Post", Vector3.new(0.45, 6, 0.45), CFrame.new(position + Vector3.new(0, 3, 0)), Color3.fromRGB(77, 60, 46), Enum.Material.Wood)

	local lightPart = createPart(parent, name .. "Lamp", Vector3.new(1.2, 1.2, 1.2), CFrame.new(position + Vector3.new(0, 6.3, 0)), color, Enum.Material.Neon)
	lightPart.Shape = Enum.PartType.Ball
	lightPart.CanCollide = false

	local pointLight = Instance.new("PointLight")
	pointLight.Brightness = 1.2
	pointLight.Range = 18
	pointLight.Color = color
	pointLight.Parent = lightPart
end

function ArcadeWorld.build(config)
	local map = Workspace:FindFirstChild("Map")
	if not map then
		map = Instance.new("Folder")
		map.Name = "Map"
		map.Parent = Workspace
	end

	local runtime = map:FindFirstChild("Runtime")
	if not runtime then
		runtime = Instance.new("Folder")
		runtime.Name = "Runtime"
		runtime.Parent = map
	end

	runtime:ClearAllChildren()

	local root = createFolder(runtime, "ArcadeLoop")
	local staticFolder = createFolder(root, "Static")
	local swallowFolder = createFolder(root, "Swallows")
	local pumpkinFolder = createFolder(root, "Pumpkins")
	local goblinFolder = createFolder(root, "Goblins")

	for zoneName, zone in pairs(config.World.Zones) do
		local pad = createPart(
			staticFolder,
			zoneName .. "Pad",
			zone.size,
			CFrame.new(zone.center),
			zone.color,
			zone.material
		)
		attachBillboard(pad, zone.title, zone.body, zoneName == "NolbuDanger" and Color3.fromRGB(224, 126, 109) or Color3.fromRGB(229, 196, 124))
	end

	for _, path in ipairs(config.World.Paths) do
		createPart(staticFolder, path.name, path.size, path.cframe, path.color, Enum.Material.Cobblestone)
	end

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "ArcadeSpawn"
	spawn.Size = Vector3.new(10, 1, 10)
	spawn.CFrame = CFrame.new(config.World.SpawnPoint)
	spawn.Color = Color3.fromRGB(218, 190, 120)
	spawn.Material = Enum.Material.SmoothPlastic
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Transparency = 0.2
	spawn.CanCollide = true
	spawn.Parent = staticFolder

	attachBillboard(spawn, "Arcade Loop", "Heal -> Plant -> Break -> Buy.", Color3.fromRGB(240, 205, 117))

	local statue = createPart(staticFolder, "PumpkinStatue", Vector3.new(4, 4, 4), CFrame.new(config.World.SpawnPoint + Vector3.new(0, 3.2, -8)), Color3.fromRGB(211, 133, 46), Enum.Material.SmoothPlastic)
	statue.Shape = Enum.PartType.Ball

	local stem = createPart(staticFolder, "PumpkinStatueStem", Vector3.new(0.6, 1.2, 0.6), statue.CFrame + Vector3.new(0, 2.3, 0), Color3.fromRGB(80, 120, 68), Enum.Material.Wood)
	stem.CanCollide = false

	local upgradePrompts = {}
	for upgradeId, padDef in pairs(config.World.UpgradePads) do
		local pad = createPart(
			staticFolder,
			upgradeId .. "Pad",
			Vector3.new(8, 1.2, 8),
			CFrame.new(padDef.position),
			padDef.color,
			Enum.Material.WoodPlanks
		)
		pad:SetAttribute(config.Attributes.Interaction.UpgradeId, upgradeId)
		attachBillboard(pad, padDef.displayName, padDef.body, padDef.color)
		upgradePrompts[upgradeId] = createPrompt(pad, "Buy", padDef.displayName, UPGRADE_PROMPT_DISTANCE)
	end

	for index, point in ipairs(config.World.GoblinSpawnPoints) do
		createPart(staticFolder, "DangerRock" .. index, Vector3.new(5, 3, 4), CFrame.new(point + Vector3.new(0, 0.9, 0)), Color3.fromRGB(71, 63, 67), Enum.Material.Rock)
	end

	createLantern(staticFolder, "VillageLanternA", Vector3.new(-92, 0.5, 22), Color3.fromRGB(240, 211, 125))
	createLantern(staticFolder, "VillageLanternB", Vector3.new(-54, 0.5, 30), Color3.fromRGB(240, 211, 125))
	createLantern(staticFolder, "DangerLanternA", Vector3.new(58, 0.5, 12), Color3.fromRGB(236, 144, 104))
	createLantern(staticFolder, "DangerLanternB", Vector3.new(88, 0.5, 34), Color3.fromRGB(236, 144, 104))

	return {
		root = root,
		folders = {
			static = staticFolder,
			swallows = swallowFolder,
			pumpkins = pumpkinFolder,
			goblins = goblinFolder,
		},
		spawnLocation = spawn,
		spawnCFrame = spawn.CFrame + Vector3.new(0, 4, 0),
		swallowSpawnPoints = config.World.SwallowSpawnPoints,
		goblinSpawnPoints = config.World.GoblinSpawnPoints,
		upgradePrompts = upgradePrompts,
	}
end

return ArcadeWorld
