local Players = game:GetService("Players")

local GoblinService = {}
GoblinService.__index = GoblinService

local function getPlayerFromHit(hit)
	if not hit then
		return nil
	end

	local model = hit:FindFirstAncestorOfClass("Model")
	if not model then
		return nil
	end

	return Players:GetPlayerFromCharacter(model)
end

function GoblinService.new(config, world, playerState)
	local self = setmetatable({}, GoblinService)
	self.config = config
	self.world = world
	self.playerState = playerState
	self.goblins = {}
	self.random = Random.new()
	return self
end

function GoblinService:start(remotes)
	self.feedbackRemote = remotes and remotes.Feedback or nil

	for index = 1, self.config.Goblins.ActiveCount do
		local spawnIndex = ((index - 1) % #self.world.goblinSpawnPoints) + 1
		self:_spawnGoblin(index, self.world.goblinSpawnPoints[spawnIndex])
	end
end

function GoblinService:_spawnGoblin(index, position)
	local model = Instance.new("Model")
	model.Name = "Goblin" .. index
	model.Parent = self.world.folders.goblins

	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Size = Vector3.new(2.2, 2.2, 1.6)
	root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
	root.Transparency = 1
	root.Anchored = false
	root.CanCollide = true
	root.Parent = model

	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2.8, 2.6, 1.8)
	torso.CFrame = root.CFrame + Vector3.new(0, 0.8, 0)
	torso.Anchored = false
	torso.CanCollide = false
	torso.Massless = true
	torso.Color = Color3.fromRGB(84, 120, 86)
	torso.Material = Enum.Material.SmoothPlastic
	torso.Parent = model

	local head = Instance.new("Part")
	head.Name = "Head"
	head.Shape = Enum.PartType.Ball
	head.Size = Vector3.new(1.8, 1.8, 1.8)
	head.CFrame = root.CFrame + Vector3.new(0, 2.6, 0)
	head.Anchored = false
	head.CanCollide = false
	head.Massless = true
	head.Color = Color3.fromRGB(110, 162, 98)
	head.Material = Enum.Material.SmoothPlastic
	head.Parent = model

	local weldTorso = Instance.new("WeldConstraint")
	weldTorso.Part0 = root
	weldTorso.Part1 = torso
	weldTorso.Parent = root

	local weldHead = Instance.new("WeldConstraint")
	weldHead.Part0 = root
	weldHead.Part1 = head
	weldHead.Parent = root

	local club = Instance.new("Part")
	club.Name = "Club"
	club.Size = Vector3.new(0.4, 2.2, 0.4)
	club.CFrame = root.CFrame * CFrame.new(1.2, 0.8, 0)
	club.Anchored = false
	club.CanCollide = false
	club.Massless = true
	club.Color = Color3.fromRGB(90, 66, 46)
	club.Material = Enum.Material.Wood
	club.Parent = model

	local weldClub = Instance.new("WeldConstraint")
	weldClub.Part0 = root
	weldClub.Part1 = club
	weldClub.Parent = root

	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = self.config.Goblins.WalkSpeed
	humanoid.JumpPower = 0
	humanoid.AutoJumpEnabled = false
	humanoid.HipHeight = 1.6
	humanoid.Parent = model

	model.PrimaryPart = root
	model:PivotTo(CFrame.new(position + Vector3.new(0, 3, 0)))

	pcall(function()
		root:SetNetworkOwner(nil)
	end)

	local goblin = {
		model = model,
		root = root,
		humanoid = humanoid,
		home = position,
		touchCooldowns = {},
	}

	self.goblins[index] = goblin

	root.Touched:Connect(function(hit)
		self:_onTouched(index, hit)
	end)

	task.spawn(function()
		self:_runLoop(index)
	end)
end

function GoblinService:_onTouched(index, hit)
	local goblin = self.goblins[index]
	local player = goblin and getPlayerFromHit(hit)
	if not goblin or not player then
		return
	end

	local now = os.clock()
	local nextTouchAt = goblin.touchCooldowns[player] or 0
	if now < nextTouchAt then
		return
	end

	goblin.touchCooldowns[player] = now + self.config.Goblins.TouchCooldown
	self.playerState:applySlow(player, self.config.Goblins.TouchSlowDuration)

	if self.feedbackRemote then
		local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		self.feedbackRemote:FireClient(player, {
			text = "Goblin hit. Slowed.",
			detail = "Back off for a moment, then re-enter when your speed recovers.",
			worldText = "Slowed",
			worldPosition = playerRoot and playerRoot.Position or goblin.root.Position,
			tone = "warn",
			intensity = "T4",
		})
	end
end

function GoblinService:_runLoop(index)
	while self.goblins[index] do
		local goblin = self.goblins[index]
		if not goblin.model.Parent then
			self.goblins[index] = nil
			break
		end

		if goblin.root.Position.Y < -20 then
			goblin.model:PivotTo(CFrame.new(goblin.home + Vector3.new(0, 3, 0)))
		end

		goblin.humanoid:MoveTo(self:_getNextDestination(goblin))
		task.wait(self.config.Goblins.RetargetInterval)
	end
end

function GoblinService:_getNextDestination(goblin)
	local closestRoot
	local closestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if humanoid and root and humanoid.Health > 0 then
			local distanceFromGoblin = (root.Position - goblin.root.Position).Magnitude
			local distanceFromHome = (root.Position - goblin.home).Magnitude
			if distanceFromGoblin < closestDistance and distanceFromHome <= self.config.Goblins.ChaseRange then
				closestDistance = distanceFromGoblin
				closestRoot = root
			end
		end
	end

	if closestRoot then
		return Vector3.new(closestRoot.Position.X, goblin.root.Position.Y, closestRoot.Position.Z)
	end

	local roamOffset = Vector3.new(
		self.random:NextNumber(-self.config.Goblins.LeashRadius, self.config.Goblins.LeashRadius),
		0,
		self.random:NextNumber(-self.config.Goblins.LeashRadius, self.config.Goblins.LeashRadius)
	)
	local roamTarget = goblin.home + roamOffset
	return Vector3.new(roamTarget.X, goblin.root.Position.Y, roamTarget.Z)
end

return GoblinService
