local Players = game:GetService("Players")

local PlayerStateService = {}
PlayerStateService.__index = PlayerStateService

function PlayerStateService.new(config, world)
	local self = setmetatable({}, PlayerStateService)
	self.config = config
	self.world = world
	self.playerData = {}
	self.cleanupCallbacks = {}
	return self
end

function PlayerStateService:registerCleanup(callback)
	table.insert(self.cleanupCallbacks, callback)
end

function PlayerStateService:start()
	Players.PlayerAdded:Connect(function(player)
		self:_onPlayerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:_onPlayerRemoving(player)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		self:_onPlayerAdded(player)
	end
end

function PlayerStateService:getData(player)
	return self.playerData[player]
end

function PlayerStateService:getSeedReward(player)
	local data = self.playerData[player]
	if not data then
		return self.config.Upgrades.Definitions.SeedMultiplier.Values[1]
	end

	return self.config.Upgrades.Definitions.SeedMultiplier.Values[data.SeedMultiplierLevel + 1]
end

function PlayerStateService:getAttackCooldown(player)
	local data = self.playerData[player]
	if not data then
		return self.config.Upgrades.Definitions.AttackSpeed.Values[1]
	end

	return self.config.Upgrades.Definitions.AttackSpeed.Values[data.AttackSpeedLevel + 1]
end

function PlayerStateService:addSeeds(player, amount)
	local data = self.playerData[player]
	if not data then
		return
	end

	data.Seeds += amount
	self:_syncPlayer(player)
end

function PlayerStateService:addMoney(player, amount)
	local data = self.playerData[player]
	if not data then
		return
	end

	data.Money += amount
	self:_syncPlayer(player)
end

function PlayerStateService:tryConsumeSeed(player)
	local data = self.playerData[player]
	if not data or data.Seeds <= 0 then
		return false
	end

	data.Seeds -= 1
	self:_syncPlayer(player)
	return true
end

function PlayerStateService:tryPurchaseUpgrade(player, upgradeId)
	local data = self.playerData[player]
	local definition = self.config.Upgrades.Definitions[upgradeId]
	if not data or not definition then
		return false, "invalid"
	end

	local currentLevel = data[definition.AttributeName]
	local nextLevel = currentLevel + 1
	local cost = self.config.Upgrades.Costs[nextLevel]
	if not cost then
		return false, "max"
	end

	if data.Money < cost then
		return false, "money", cost
	end

	data.Money -= cost
	data[definition.AttributeName] = nextLevel
	self:_syncPlayer(player)
	self:_applyWalkSpeed(player)
	return true, "ok", cost, nextLevel
end

function PlayerStateService:applySlow(player, duration)
	local data = self.playerData[player]
	if not data then
		return
	end

	data.SlowToken += 1
	local slowToken = data.SlowToken
	data.IsSlowed = true
	self:_syncPlayer(player)
	self:_applyWalkSpeed(player)

	task.delay(duration, function()
		local currentData = self.playerData[player]
		if not currentData or currentData.SlowToken ~= slowToken then
			return
		end

		currentData.IsSlowed = false
		self:_syncPlayer(player)
		self:_applyWalkSpeed(player)
	end)
end

function PlayerStateService:_onPlayerAdded(player)
	if self.playerData[player] then
		return
	end

	local data = {
		Seeds = 0,
		Money = 0,
		MoveSpeedLevel = 0,
		AttackSpeedLevel = 0,
		SeedMultiplierLevel = 0,
		IsSlowed = false,
		SlowToken = 0,
		Connections = {},
	}

	self.playerData[player] = data
	self:_syncPlayer(player)

	data.Connections[#data.Connections + 1] = player.CharacterAdded:Connect(function(character)
		self:_setupCharacter(player, character)
	end)

	if player.Character then
		task.defer(function()
			self:_setupCharacter(player, player.Character)
		end)
	end
end

function PlayerStateService:_onPlayerRemoving(player)
	local data = self.playerData[player]
	if not data then
		return
	end

	for _, callback in ipairs(self.cleanupCallbacks) do
		callback(player)
	end

	for _, connection in ipairs(data.Connections) do
		connection:Disconnect()
	end

	self.playerData[player] = nil
end

function PlayerStateService:_setupCharacter(player, character)
	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
	local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
	if not humanoid or not root then
		return
	end

	local spreadX = ((player.UserId % 5) - 2) * 3
	local spreadZ = (((math.floor(player.UserId / 5)) % 5) - 2) * 3
	character:PivotTo(self.world.spawnCFrame + Vector3.new(spreadX, 0, spreadZ))
	self:_applyWalkSpeed(player)
end

function PlayerStateService:_applyWalkSpeed(player)
	local data = self.playerData[player]
	local character = player.Character
	if not data or not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	local baseSpeed = self.config.Upgrades.Definitions.MoveSpeed.Values[data.MoveSpeedLevel + 1]
	local speed = data.IsSlowed and (baseSpeed * self.config.Goblins.TouchSlowFactor) or baseSpeed
	humanoid.WalkSpeed = speed
end

function PlayerStateService:_syncPlayer(player)
	local data = self.playerData[player]
	if not data then
		return
	end

	local attributes = self.config.Attributes.Player
	player:SetAttribute(attributes.Seeds, data.Seeds)
	player:SetAttribute(attributes.Money, data.Money)
	player:SetAttribute(attributes.MoveSpeedLevel, data.MoveSpeedLevel)
	player:SetAttribute(attributes.AttackSpeedLevel, data.AttackSpeedLevel)
	player:SetAttribute(attributes.SeedMultiplierLevel, data.SeedMultiplierLevel)
	player:SetAttribute(attributes.IsSlowed, data.IsSlowed)
end

return PlayerStateService
