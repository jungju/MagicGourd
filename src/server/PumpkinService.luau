local Workspace = game:GetService("Workspace")

local PumpkinService = {}
PumpkinService.__index = PumpkinService

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

function PumpkinService.new(config, world, playerState)
	local self = setmetatable({}, PumpkinService)
	self.config = config
	self.world = world
	self.playerState = playerState
	self.nextId = 0
	self.pumpkins = {}
	self.playerPumpkins = {}
	self.lastHitTimes = {}
	self.random = Random.new()
	return self
end

function PumpkinService:start(remotes)
	self.feedbackRemote = remotes.Feedback

	remotes.UseSeed.OnServerEvent:Connect(function(player)
		self:_useSeed(player)
	end)

	remotes.HitPumpkin.OnServerEvent:Connect(function(player, pumpkinId)
		self:_hitPumpkin(player, pumpkinId)
	end)
end

function PumpkinService:destroyPlayerPumpkins(player)
	local ownedPumpkins = self.playerPumpkins[player]
	if not ownedPumpkins then
		return
	end

	local ids = {}
	for pumpkinId in pairs(ownedPumpkins) do
		ids[#ids + 1] = pumpkinId
	end

	for _, pumpkinId in ipairs(ids) do
		self:_destroyPumpkin(pumpkinId)
	end

	self.playerPumpkins[player] = nil
	self.lastHitTimes[player] = nil
end

function PumpkinService:_useSeed(player)
	local root = getRootPart(player)
	if not root then
		return
	end

	if not self.playerState:tryConsumeSeed(player) then
		return
	end

	self.nextId += 1
	local pumpkinId = self.nextId
	local position = self:_getSpawnPosition(player, root)
	local expiresAt = Workspace:GetServerTimeNow() + self.config.Pumpkins.Lifetime

	local model = Instance.new("Model")
	model.Name = "Pumpkin" .. pumpkinId
	model.Parent = self.world.folders.pumpkins

	local rootPart = Instance.new("Part")
	rootPart.Name = "PumpkinRoot"
	rootPart.Shape = Enum.PartType.Ball
	rootPart.Size = Vector3.new(3.4, 3.4, 3.4)
	rootPart.CFrame = CFrame.new(position)
	rootPart.Anchored = true
	rootPart.CanCollide = true
	rootPart.Color = Color3.fromRGB(212, 132, 47)
	rootPart.Material = Enum.Material.SmoothPlastic
	rootPart.Parent = model

	local stem = Instance.new("Part")
	stem.Name = "Stem"
	stem.Size = Vector3.new(0.5, 1.2, 0.5)
	stem.CFrame = rootPart.CFrame + Vector3.new(0, 2, 0)
	stem.Anchored = true
	stem.CanCollide = false
	stem.Color = Color3.fromRGB(86, 126, 70)
	stem.Material = Enum.Material.Wood
	stem.Parent = model

	local leaf = Instance.new("Part")
	leaf.Name = "Leaf"
	leaf.Size = Vector3.new(1.4, 0.2, 0.9)
	leaf.CFrame = stem.CFrame * CFrame.new(0.4, 0.25, 0) * CFrame.Angles(0, 0, math.rad(24))
	leaf.Anchored = true
	leaf.CanCollide = false
	leaf.Color = Color3.fromRGB(124, 182, 92)
	leaf.Material = Enum.Material.Grass
	leaf.Parent = model

	model.PrimaryPart = rootPart
	model:SetAttribute(self.config.Attributes.Pumpkin.Owner, player.UserId)
	rootPart:SetAttribute(self.config.Attributes.Pumpkin.Owner, player.UserId)
	rootPart:SetAttribute(self.config.Attributes.Pumpkin.Health, self.config.Pumpkins.Health)
	rootPart:SetAttribute(self.config.Attributes.Pumpkin.ExpiresAt, expiresAt)
	rootPart:SetAttribute(self.config.Attributes.Interaction.Kind, "Pumpkin")
	rootPart:SetAttribute(self.config.Attributes.Interaction.EntityId, pumpkinId)
	createPrompt(rootPart, "Break", "Owned Pumpkin", self.config.Pumpkins.PromptDistance)

	self.pumpkins[pumpkinId] = {
		id = pumpkinId,
		model = model,
		root = rootPart,
		owner = player,
	}

	self.playerPumpkins[player] = self.playerPumpkins[player] or {}
	self.playerPumpkins[player][pumpkinId] = true

	if self.feedbackRemote then
		self.feedbackRemote:FireClient(player, {
			text = "Pumpkin planted.",
			detail = string.format("Break it in %d hits before it fades for a money payout.", self.config.Pumpkins.Health),
			worldText = "Planted",
			worldPosition = rootPart.Position,
			tone = "info",
		})
	end

	task.delay(self.config.Pumpkins.Lifetime, function()
		if self.pumpkins[pumpkinId] then
			self:_destroyPumpkin(pumpkinId)
		end
	end)
end

function PumpkinService:_hitPumpkin(player, pumpkinId)
	local pumpkin = self.pumpkins[pumpkinId]
	local root = pumpkin and pumpkin.root
	local playerRoot = getRootPart(player)
	if not pumpkin or not root or not playerRoot or pumpkin.owner ~= player then
		return
	end

	if (playerRoot.Position - root.Position).Magnitude > self.config.Pumpkins.HitDistance then
		return
	end

	local now = os.clock()
	local lastHitAt = self.lastHitTimes[player] or 0
	if now - lastHitAt < self.playerState:getAttackCooldown(player) then
		return
	end

	self.lastHitTimes[player] = now

	local currentHealth = root:GetAttribute(self.config.Attributes.Pumpkin.Health) or self.config.Pumpkins.Health
	currentHealth -= 1
	root:SetAttribute(self.config.Attributes.Pumpkin.Health, currentHealth)

	if currentHealth <= 0 then
		self.playerState:addMoney(player, self.config.Pumpkins.Reward)
		if self.feedbackRemote then
			self.feedbackRemote:FireClient(player, {
				text = string.format("Pumpkin broken! +%d money", self.config.Pumpkins.Reward),
				detail = "Bring your money back to the plaza for upgrades, or plant again right away.",
				worldText = string.format("+%d Money", self.config.Pumpkins.Reward),
				worldPosition = root.Position,
				tone = "good",
			})
		end
		self:_destroyPumpkin(pumpkinId)
		return
	end

	if self.feedbackRemote then
		self.feedbackRemote:FireClient(player, {
			text = currentHealth == 1 and "Pumpkin cracked. One hit left." or string.format("Pumpkin cracked. %d hits left.", currentHealth),
			detail = currentHealth == 1 and "One more break for the money payout." or "Keep breaking to turn this planting into money.",
			worldText = currentHealth == 1 and "Final Hit" or string.format("%d Left", currentHealth),
			worldPosition = root.Position,
			tone = "info",
		})
	end
end

function PumpkinService:_destroyPumpkin(pumpkinId)
	local pumpkin = self.pumpkins[pumpkinId]
	if not pumpkin then
		return
	end

	self.pumpkins[pumpkinId] = nil

	local ownerPumpkins = self.playerPumpkins[pumpkin.owner]
	if ownerPumpkins then
		ownerPumpkins[pumpkinId] = nil
		if not next(ownerPumpkins) then
			self.playerPumpkins[pumpkin.owner] = nil
		end
	end

	if pumpkin.model then
		pumpkin.model:Destroy()
	end
end

function PumpkinService:_getSpawnPosition(player, root)
	local angle = self.random:NextNumber(0, math.pi * 2)
	local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * self.config.Pumpkins.SpawnRadius
	local targetPosition = root.Position + offset

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { player.Character, self.world.folders.pumpkins }

	local origin = targetPosition + Vector3.new(0, self.config.Pumpkins.SpawnHeight, 0)
	local result = Workspace:Raycast(origin, Vector3.new(0, -self.config.Pumpkins.SpawnHeight * 2, 0), rayParams)
	local groundY = result and result.Position.Y or root.Position.Y - 3

	return Vector3.new(targetPosition.X, groundY + 1.7, targetPosition.Z)
end

return PumpkinService
