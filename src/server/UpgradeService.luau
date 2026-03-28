local UpgradeService = {}
UpgradeService.__index = UpgradeService

local PURCHASE_DETAILS = {
	MoveSpeed = "Your next route should feel lighter immediately.",
	AttackSpeed = "Your next pumpkin should cash out faster.",
	SeedMultiplier = "Your next swallow heal should feed a bigger loop.",
}

function UpgradeService.new(config, world, playerState)
	local self = setmetatable({}, UpgradeService)
	self.config = config
	self.world = world
	self.playerState = playerState
	return self
end

function UpgradeService:start(remotes)
	self.feedbackRemote = remotes and remotes.Feedback or nil

	for upgradeId, prompt in pairs(self.world.upgradePrompts) do
		prompt.Triggered:Connect(function(player)
			local success, reason, cost, newLevel = self.playerState:tryPurchaseUpgrade(player, upgradeId)
			if not self.feedbackRemote then
				return
			end

			local definition = self.config.Upgrades.Definitions[upgradeId]
			local displayName = definition.DisplayName
			local purchaseDetail = PURCHASE_DETAILS[upgradeId] or "Your next loop should feel better right away."
			local promptParent = prompt.Parent
			local promptPosition = promptParent and promptParent:IsA("BasePart") and promptParent.Position or nil
			if success then
				self.feedbackRemote:FireClient(player, {
					text = string.format("Bought %s Lv.%d (-%d money)", displayName, newLevel, cost),
					detail = purchaseDetail,
					worldText = string.format("%s Up", displayName),
					worldPosition = promptPosition,
					tone = "good",
					intensity = "T3",
					context = "UpgradePurchase",
					upgradeId = upgradeId,
				})
			elseif reason == "money" then
				self.feedbackRemote:FireClient(player, {
					text = string.format("Need %d money for %s", cost, displayName),
					detail = "Break another pumpkin or two, then come back to the plaza.",
					worldText = string.format("Need %d", cost),
					worldPosition = promptPosition,
					tone = "warn",
					intensity = "T1",
				})
			elseif reason == "max" then
				self.feedbackRemote:FireClient(player, {
					text = string.format("%s is maxed", displayName),
					detail = "Buy a different upgrade or keep the loop moving.",
					worldText = "MAX",
					worldPosition = promptPosition,
					tone = "warn",
					intensity = "T1",
				})
			end
		end)
	end
end

return UpgradeService
