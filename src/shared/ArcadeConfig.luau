local moveSpeedValues = { 16, 18, 20, 22 }
local attackSpeedValues = { 0.75, 0.6, 0.45, 0.3 }
local seedGainValues = { 1, 2, 3, 4 }

local config = {
	RemoteNames = {
		HealSwallow = "HealSwallow",
		UseSeed = "UseSeed",
		HitPumpkin = "HitPumpkin",
		Feedback = "ArcadeFeedback",
	},
	Attributes = {
		Player = {
			Seeds = "Seeds",
			Money = "Money",
			MoveSpeedLevel = "MoveSpeedLevel",
			AttackSpeedLevel = "AttackSpeedLevel",
			SeedMultiplierLevel = "SeedMultiplierLevel",
			IsSlowed = "IsSlowed",
		},
		Pumpkin = {
			Owner = "owner",
			Health = "Health",
			ExpiresAt = "ExpiresAt",
		},
		Interaction = {
			Kind = "InteractionKind",
			EntityId = "EntityId",
			UpgradeId = "UpgradeId",
		},
	},
	World = {
		SpawnPoint = Vector3.new(0, 2, 18),
		Zones = {
			CentralPlaza = {
				center = Vector3.new(0, 0.5, 18),
				size = Vector3.new(40, 1, 34),
				color = Color3.fromRGB(167, 147, 109),
				material = Enum.Material.Slate,
				title = "Central Plaza",
				body = "Buy upgrades, then reset for the next run.",
			},
			HeungbuVillage = {
				center = Vector3.new(-72, 0.5, 24),
				size = Vector3.new(46, 1, 38),
				color = Color3.fromRGB(111, 145, 88),
				material = Enum.Material.Grass,
				title = "Heungbu Village",
				body = "Heal swallows here for seeds.",
			},
			NolbuDanger = {
				center = Vector3.new(72, 0.5, 24),
				size = Vector3.new(44, 1, 36),
				color = Color3.fromRGB(82, 72, 76),
				material = Enum.Material.Slate,
				title = "Nolbu Area",
				body = "Goblins slow greedy pushes.",
			},
		},
		Paths = {
			{
				name = "VillagePathA",
				size = Vector3.new(48, 1, 12),
				cframe = CFrame.new(-35, 0.45, 22) * CFrame.Angles(0, math.rad(8), 0),
				color = Color3.fromRGB(138, 114, 84),
			},
			{
				name = "DangerPathA",
				size = Vector3.new(48, 1, 12),
				cframe = CFrame.new(35, 0.45, 22) * CFrame.Angles(0, math.rad(-8), 0),
				color = Color3.fromRGB(116, 98, 86),
			},
			{
				name = "CrossPath",
				size = Vector3.new(26, 1, 14),
				cframe = CFrame.new(0, 0.44, 34),
				color = Color3.fromRGB(129, 104, 80),
			},
		},
		LaneLandmarks = {
			{
				name = "VillageStartSign",
				position = Vector3.new(-24, 1.8, 20),
				color = Color3.fromRGB(214, 196, 124),
				title = "Village First",
				body = "Start left: heal for seeds.",
			},
			{
				name = "WorkLaneSign",
				position = Vector3.new(0, 1.8, 33),
				color = Color3.fromRGB(222, 170, 92),
				title = "Work Lane",
				body = "Plant and break here for money.",
			},
			{
				name = "DangerGateSign",
				position = Vector3.new(40, 1.8, 20),
				color = Color3.fromRGB(226, 135, 102),
				title = "Slow Zone",
				body = "Goblins punish greedy pushes.",
			},
			{
				name = "RetreatLaneSign",
				position = Vector3.new(28, 1.8, 29),
				color = Color3.fromRGB(237, 195, 123),
				title = "Reset Lane",
				body = "Tagged? Peel back toward the plaza.",
			},
		},
		WorkLanePosts = {
			Vector3.new(-10, 0.5, 33),
			Vector3.new(10, 0.5, 33),
		},
		UpgradePads = {
			MoveSpeed = {
				displayName = "Footwork",
				body = "Run faster between loop steps.",
				position = Vector3.new(-13, 1.3, 18),
				color = Color3.fromRGB(93, 174, 214),
			},
			AttackSpeed = {
				displayName = "Quick Hands",
				body = "Break pumpkins faster.",
				position = Vector3.new(0, 1.3, 18),
				color = Color3.fromRGB(223, 171, 88),
			},
			SeedMultiplier = {
				displayName = "Blessing",
				body = "Gain more seeds from each heal.",
				position = Vector3.new(13, 1.3, 18),
				color = Color3.fromRGB(121, 201, 127),
			},
		},
		SwallowSpawnPoints = {
			Vector3.new(-84, 2.3, 12),
			Vector3.new(-84, 2.3, 24),
			Vector3.new(-84, 2.3, 36),
			Vector3.new(-72, 2.3, 10),
			Vector3.new(-72, 2.3, 30),
			Vector3.new(-60, 2.3, 14),
			Vector3.new(-60, 2.3, 28),
			Vector3.new(-60, 2.3, 38),
			Vector3.new(-76, 2.3, 40),
			Vector3.new(-66, 2.3, 20),
		},
		GoblinSpawnPoints = {
			Vector3.new(62, 3.5, 14),
			Vector3.new(72, 3.5, 31),
			Vector3.new(86, 3.5, 16),
			Vector3.new(80, 3.5, 40),
		},
		DangerRockPositions = {
			Vector3.new(60, 0.5, 8),
			Vector3.new(72, 0.5, 41),
			Vector3.new(86, 0.5, 9),
			Vector3.new(96, 0.5, 36),
		},
	},
	Swallows = {
		ActiveCount = 6,
		HealDistance = 14,
		PromptDistance = 12,
	},
	Pumpkins = {
		Lifetime = 45,
		Health = 3,
		Reward = 10,
		SpawnRadius = 6,
		SpawnHeight = 24,
		SpawnAttempts = 9,
		ClearanceRadius = 2.6,
		HitDistance = 14,
		PromptDistance = 12,
		PlacementBias = {
			UpgradePadDistance = 8.5,
			SwallowDistance = 6.5,
			DangerRockDistance = 4.5,
			UpgradePadWeight = 2.8,
			SwallowWeight = 1.4,
			DangerRockWeight = 0.8,
		},
	},
	Goblins = {
		ActiveCount = 2,
		WalkSpeed = 10,
		ChaseRange = 84,
		LeashRadius = 18,
		ChaseZonePadding = 10,
		RetargetInterval = 0.75,
		TouchSlowDuration = 2.5,
		TouchSlowFactor = 0.55,
		TouchCooldown = 1.5,
	},
	Feedback = {
		DefaultIntensity = "T2",
		PopupYieldWindow = 0.32,
		MaxWorldPopupsPerBucket = 2,
		CrowdedBucketSuppressionPriority = 2,
		BannerDurationByIntensity = {
			T1 = 1.55,
			T2 = 2.1,
			T3 = 2.55,
			T4 = 2.65,
		},
		WorldPopupPriorityByIntensity = {
			T1 = 1,
			T2 = 2,
			T3 = 3,
			T4 = 4,
		},
		WorldPopupByIntensity = {
			T1 = {
				duration = 0.65,
				rise = 1.6,
				size = Vector2.new(158, 42),
				maxDistance = 95,
			},
			T2 = {
				duration = 0.82,
				rise = 2.2,
				size = Vector2.new(170, 46),
				maxDistance = 110,
			},
			T3 = {
				duration = 1.02,
				rise = 2.8,
				size = Vector2.new(188, 50),
				maxDistance = 120,
			},
			T4 = {
				duration = 1.1,
				rise = 3.0,
				size = Vector2.new(194, 54),
				maxDistance = 122,
			},
		},
	},
}

config.Upgrades = {
	Costs = { 20, 40, 80 },
	PromptDistance = 9,
	Order = { "MoveSpeed", "AttackSpeed", "SeedMultiplier" },
	Definitions = {
		MoveSpeed = {
			AttributeName = config.Attributes.Player.MoveSpeedLevel,
			DisplayName = "Footwork",
			Values = moveSpeedValues,
		},
		AttackSpeed = {
			AttributeName = config.Attributes.Player.AttackSpeedLevel,
			DisplayName = "Quick Hands",
			Values = attackSpeedValues,
		},
		SeedMultiplier = {
			AttributeName = config.Attributes.Player.SeedMultiplierLevel,
			DisplayName = "Blessing",
			Values = seedGainValues,
		},
	},
}

return config
