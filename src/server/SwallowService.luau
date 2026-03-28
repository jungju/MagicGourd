local SwallowService = {}
SwallowService.__index = SwallowService

local function getRootPart(player)
	local character = player.Character
	if not character then
		return nil
	end

	return character:FindFirstChild("HumanoidRootPart")
end

local function createPrompt(parent, actionText, objectText, maxDistance)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.MaxActivationDistance = maxDistance
	prompt.RequiresLineOfSight = false
	prompt.HoldDuration = 0
	prompt.Parent = parent
	return prompt
end

function SwallowService.new(config, world, playerState)
	local self = setmetatable({}, SwallowService)
	self.config = config
	self.world = world
	self.playerState = playerState
	self.nextId = 0
	self.spawnCursor = 0
	self.swallows = {}
	self.occupiedSpawnIndices = {}
	self.random = Random.new()
	return self
end

function SwallowService:start(remotes)
	self.feedbackRemote = remotes.Feedback

	remotes.HealSwallow.OnServerEvent:Connect(function(player, swallowId)
		self:_healSwallow(player, swallowId)
	end)

	for _ = 1, self.config.Swallows.ActiveCount do
		self:_spawnSwallow()
	end
end

function SwallowService:_healSwallow(player, swallowId)
	local swallow = self.swallows[swallowId]
	local root = swallow and swallow.root
	local playerRoot = getRootPart(player)
	if not swallow or not root or not playerRoot then
		return
	end

	if (playerRoot.Position - root.Position).Magnitude > self.config.Swallows.HealDistance then
		return
	end

	local reward = self.playerState:getSeedReward(player)
	self.playerState:addSeeds(player, reward)

	if self.feedbackRemote then
		self.feedbackRemote:FireClient(player, {
			text = string.format("Swallow healed! +%d seed%s", reward, reward == 1 and "" or "s"),
			tone = "good",
		})
	end

	self:_destroySwallow(swallowId)
	self:_maintainSwallows()
end

function SwallowService:_maintainSwallows()
	while self:_activeCount() < self.config.Swallows.ActiveCount do
		self:_spawnSwallow()
	end
end

function SwallowService:_activeCount()
	local count = 0
	for _ in pairs(self.swallows) do
		count += 1
	end
	return count
end

function SwallowService:_spawnSwallow()
	local spawnIndex = self:_takeOpenSpawnIndex()
	if not spawnIndex then
		return
	end

	self.nextId += 1
	local swallowId = self.nextId
	local position = self.world.swallowSpawnPoints[spawnIndex]

	local model = Instance.new("Model")
	model.Name = "Swallow" .. swallowId
	model.Parent = self.world.folders.swallows

	local nest = Instance.new("Part")
	nest.Name = "Nest"
	nest.Shape = Enum.PartType.Cylinder
	nest.Size = Vector3.new(2.2, 0.35, 2.2)
	nest.CFrame = CFrame.new(position + Vector3.new(0, -1.15, 0)) * CFrame.Angles(0, 0, math.rad(90))
	nest.Anchored = true
	nest.CanCollide = false
	nest.Color = Color3.fromRGB(112, 83, 56)
	nest.Material = Enum.Material.WoodPlanks
	nest.Parent = model

	local root = Instance.new("Part")
	root.Name = "SwallowRoot"
	root.Size = Vector3.new(1.7, 0.9, 2.1)
	root.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(self.random:NextInteger(-30, 30)), math.rad(14))
	root.Anchored = true
	root.CanCollide = false
	root.Color = Color3.fromRGB(56, 58, 67)
	root.Material = Enum.Material.SmoothPlastic
	root.Parent = model

	local wing = Instance.new("Part")
	wing.Name = "Wing"
	wing.Size = Vector3.new(2.3, 0.2, 0.95)
	wing.CFrame = root.CFrame * CFrame.new(0, 0.2, 0.15) * CFrame.Angles(0, 0, math.rad(-18))
	wing.Anchored = true
	wing.CanCollide = false
	wing.Color = Color3.fromRGB(220, 224, 235)
	wing.Material = Enum.Material.SmoothPlastic
	wing.Parent = model

	root:SetAttribute(self.config.Attributes.Interaction.Kind, "Swallow")
	root:SetAttribute(self.config.Attributes.Interaction.EntityId, swallowId)
	createPrompt(root, "Heal", "Injured Swallow", self.config.Swallows.PromptDistance)

	self.swallows[swallowId] = {
		model = model,
		root = root,
		spawnIndex = spawnIndex,
	}
end

function SwallowService:_destroySwallow(swallowId)
	local swallow = self.swallows[swallowId]
	if not swallow then
		return
	end

	self.occupiedSpawnIndices[swallow.spawnIndex] = nil
	self.swallows[swallowId] = nil

	if swallow.model then
		swallow.model:Destroy()
	end
end

function SwallowService:_takeOpenSpawnIndex()
	local totalSpawns = #self.world.swallowSpawnPoints
	if totalSpawns == 0 then
		return nil
	end

	for step = 1, totalSpawns do
		local index = ((self.spawnCursor + step - 1) % totalSpawns) + 1
		if not self.occupiedSpawnIndices[index] then
			self.spawnCursor = index
			self.occupiedSpawnIndices[index] = true
			return index
		end
	end

	return nil
end

return SwallowService
