local UpgradeService = {}
UpgradeService.__index = UpgradeService

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

			local displayName = self.config.Upgrades.Definitions[upgradeId].DisplayName
			if success then
				self.feedbackRemote:FireClient(player, {
					text = string.format("%s upgraded to Lv.%d (-%d money)", displayName, newLevel, cost),
					tone = "good",
				})
			elseif reason == "money" then
				self.feedbackRemote:FireClient(player, {
					text = string.format("Need %d money for %s", cost, displayName),
					tone = "warn",
				})
			elseif reason == "max" then
				self.feedbackRemote:FireClient(player, {
					text = string.format("%s is already maxed", displayName),
					tone = "warn",
				})
			end
		end)
	end
end

return UpgradeService
