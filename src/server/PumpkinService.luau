local Workspace = game:GetService("Workspace")

local PumpkinService = {}
PumpkinService.__index = PumpkinService

local FALLBACK_SURFACE_OFFSET = 1.7

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
	prompt.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
	prompt.Parent = parent
	return prompt
end

local function addAnchorPenalty(spawnPosition, anchors, preferredDistance, weight)
	if preferredDistance <= 0 or weight <= 0 then
		return 0
	end

	local penalty = 0
	for _, anchorPosition in ipairs(anchors or {}) do
		local distance = (spawnPosition - anchorPosition).Magnitude
		if distance < preferredDistance then
			penalty += ((preferredDistance - distance) / preferredDistance) * weight
		end
	end

	return penalty
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
	createPrompt(rootPart, "Break", "Pumpkin", self.config.Pumpkins.PromptDistance)

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
			intensity = "T1",
		})
	end

	task.delay(self.config.Pumpkins.Lifetime, function()
		if self.pumpkins[pumpkinId] then
			self:_destroyPumpkin(pumpkinId, "expired")
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
				intensity = "T3",
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
			intensity = "T2",
		})
	end
end

function PumpkinService:_destroyPumpkin(pumpkinId, reason)
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

	if reason == "expired" and self.feedbackRemote and pumpkin.owner and pumpkin.owner.Parent then
		self.feedbackRemote:FireClient(pumpkin.owner, {
			text = "Pumpkin faded.",
			detail = "Break planted pumpkins before they time out, or plant again when you are ready.",
			worldText = "Faded",
			worldPosition = pumpkin.root and pumpkin.root.Position or nil,
			tone = "warn",
			intensity = "T1",
		})
	end

	if pumpkin.model then
		pumpkin.model:Destroy()
	end
end

function PumpkinService:_getSpawnPosition(player, root)
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { player.Character, self.world.folders.pumpkins }

	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { player.Character }

	local forward = root.CFrame.LookVector
	local forwardFlat = Vector3.new(forward.X, 0, forward.Z)
	if forwardFlat.Magnitude < 0.001 then
		forwardFlat = Vector3.new(0, 0, -1)
	else
		forwardFlat = forwardFlat.Unit
	end

	local spawnRadius = self.config.Pumpkins.SpawnRadius
	local clearanceRadius = self.config.Pumpkins.ClearanceRadius or 2.6
	local spawnAttempts = self.config.Pumpkins.SpawnAttempts or 8
	local placementBias = self.config.Pumpkins.PlacementBias or {}
	local upgradePadAnchors = {}
	for _, padDef in pairs(self.config.World.UpgradePads or {}) do
		if typeof(padDef.position) == "Vector3" then
			table.insert(upgradePadAnchors, padDef.position)
		end
	end
	local swallowAnchors = self.world.swallowSpawnPoints or self.config.World.SwallowSpawnPoints or {}
	local dangerRockAnchors = self.config.World.DangerRockPositions or {}
	local bestPosition
	local bestPenalty = math.huge

	for attempt = 1, spawnAttempts do
		local angleOffset = self.random:NextNumber(-math.pi * 0.85, math.pi * 0.85)
		local distanceScale = self.random:NextNumber(0.68, 1)
		local offsetDirection = CFrame.fromAxisAngle(Vector3.yAxis, angleOffset):VectorToWorldSpace(forwardFlat)
		local targetPosition = root.Position + (offsetDirection * spawnRadius * distanceScale)
		local origin = targetPosition + Vector3.new(0, self.config.Pumpkins.SpawnHeight, 0)
		local result = Workspace:Raycast(origin, Vector3.new(0, -self.config.Pumpkins.SpawnHeight * 2, 0), rayParams)
		local groundPosition = result and result.Position or Vector3.new(targetPosition.X, root.Position.Y - 3, targetPosition.Z)
		local spawnPosition = Vector3.new(targetPosition.X, groundPosition.Y + FALLBACK_SURFACE_OFFSET, targetPosition.Z)
		local overlapParts = Workspace:GetPartBoundsInRadius(spawnPosition, clearanceRadius, overlapParams)

		local penalty = 0
		for _, part in ipairs(overlapParts) do
			if part:IsDescendantOf(self.world.folders.pumpkins) then
				penalty += 100
			elseif part.CanCollide and not part:IsDescendantOf(player.Character) then
				penalty += 1
			end
		end

		penalty += addAnchorPenalty(
			spawnPosition,
			upgradePadAnchors,
			placementBias.UpgradePadDistance or 0,
			placementBias.UpgradePadWeight or 0
		)
		penalty += addAnchorPenalty(
			spawnPosition,
			swallowAnchors,
			placementBias.SwallowDistance or 0,
			placementBias.SwallowWeight or 0
		)
		penalty += addAnchorPenalty(
			spawnPosition,
			dangerRockAnchors,
			placementBias.DangerRockDistance or 0,
			placementBias.DangerRockWeight or 0
		)

		if penalty <= 0 then
			return spawnPosition
		end

		if penalty < bestPenalty then
			bestPenalty = penalty
			bestPosition = spawnPosition
		end
	end

	if bestPosition then
		return bestPosition
	end

	local fallbackTarget = root.Position + (forwardFlat * spawnRadius)
	return Vector3.new(fallbackTarget.X, root.Position.Y - 1.3, fallbackTarget.Z)
end

return PumpkinService
