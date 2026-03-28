local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")

local ArcadeConfig = require(Shared:WaitForChild("ArcadeConfig"))
local ArcadeWorld = require(script.Parent:WaitForChild("ArcadeWorld"))
local GoblinService = require(script.Parent:WaitForChild("GoblinService"))
local PlayerStateService = require(script.Parent:WaitForChild("PlayerStateService"))
local PumpkinService = require(script.Parent:WaitForChild("PumpkinService"))
local SwallowService = require(script.Parent:WaitForChild("SwallowService"))
local UpgradeService = require(script.Parent:WaitForChild("UpgradeService"))

local ArcadeRuntime = {}

local function ensureRemotes(sharedFolder)
	local allowedRemotes = {}
	local remotes = {}

	for _, remoteName in pairs(ArcadeConfig.RemoteNames) do
		allowedRemotes[remoteName] = true
	end

	for _, child in ipairs(sharedFolder:GetChildren()) do
		if child:IsA("RemoteEvent") and not allowedRemotes[child.Name] then
			child:Destroy()
		end
	end

	for key, remoteName in pairs(ArcadeConfig.RemoteNames) do
		local remote = sharedFolder:FindFirstChild(remoteName)
		if not remote then
			remote = Instance.new("RemoteEvent")
			remote.Name = remoteName
			remote.Parent = sharedFolder
		end
		remotes[key] = remote
	end

	return remotes
end

function ArcadeRuntime.start()
	print("MagicGourd arcade server started")

	local remotes = ensureRemotes(Shared)
	local world = ArcadeWorld.build(ArcadeConfig)
	local playerState = PlayerStateService.new(ArcadeConfig, world)
	local pumpkinService = PumpkinService.new(ArcadeConfig, world, playerState)
	local swallowService = SwallowService.new(ArcadeConfig, world, playerState)
	local upgradeService = UpgradeService.new(ArcadeConfig, world, playerState)
	local goblinService = GoblinService.new(ArcadeConfig, world, playerState)

	playerState:registerCleanup(function(player)
		pumpkinService:destroyPlayerPumpkins(player)
	end)

	playerState:start()
	upgradeService:start(remotes)
	swallowService:start(remotes)
	pumpkinService:start(remotes)
	goblinService:start(remotes)
end

return ArcadeRuntime
