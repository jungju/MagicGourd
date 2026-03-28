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
			local promptParent = prompt.Parent
			local promptPosition = promptParent and promptParent:IsA("BasePart") and promptParent.Position or nil
			if success then
				self.feedbackRemote:FireClient(player, {
					text = string.format("Bought %s Lv.%d (-%d money)", displayName, newLevel, cost),
					detail = "Your next loop should feel faster right away.",
					worldText = string.format("%s Up", displayName),
					worldPosition = promptPosition,
					tone = "good",
				})
			elseif reason == "money" then
				self.feedbackRemote:FireClient(player, {
					text = string.format("Need %d money for %s", cost, displayName),
					detail = "Break another pumpkin or two, then come back to the plaza.",
					tone = "warn",
				})
			elseif reason == "max" then
				self.feedbackRemote:FireClient(player, {
					text = string.format("%s is maxed", displayName),
					detail = "Buy a different upgrade or keep the loop moving.",
					tone = "warn",
				})
			end
		end)
	end
end

return UpgradeService
