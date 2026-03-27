print("MagicGourd server started")

local InsertService = game:GetService("InsertService")
local Workspace = game:GetService("Workspace")

local map = Workspace:WaitForChild("Map")
local placedAssets = map:FindFirstChild("PlacedAssets")
if not placedAssets then
	placedAssets = Instance.new("Folder")
	placedAssets.Name = "PlacedAssets"
	placedAssets.Parent = map
end

local assets = {
	{
		name = "HeungbuHouse",
		assetId = 93969099298348,
		position = Vector3.new(-72, 1.6, 28),
		yaw = 30,
	},
	{
		name = "NolbuHouse",
		assetId = 76012677304613,
		position = Vector3.new(74, 1.6, 18),
		yaw = -35,
	},
	{
		name = "Nolbu",
		assetId = 81648951264309,
		position = Vector3.new(58, 3.2, 34),
		yaw = 180,
	},
}

local function clearExisting(name: string)
	local existing = placedAssets:FindFirstChild(name)
	if existing then
		existing:Destroy()
	end
end

local function getPrimary(instance: Instance): BasePart?
	if instance:IsA("Model") then
		if instance.PrimaryPart then
			return instance.PrimaryPart
		end
		return instance:FindFirstChildWhichIsA("BasePart", true)
	elseif instance:IsA("BasePart") then
		return instance
	end
	return nil
end

local function placeAsset(def)
	clearExisting(def.name)

	local ok, container = pcall(function()
		return InsertService:LoadAsset(def.assetId)
	end)

	if not ok then
		warn(string.format("[MagicGourd] Failed to load asset %s (%d): %s", def.name, def.assetId, tostring(container)))
		return
	end

	local candidate = container:GetChildren()[1]
	if not candidate then
		warn(string.format("[MagicGourd] Asset %s (%d) returned no children", def.name, def.assetId))
		container:Destroy()
		return
	end

	candidate.Name = def.name
	candidate.Parent = placedAssets

	local cf = CFrame.new(def.position) * CFrame.Angles(0, math.rad(def.yaw), 0)

	if candidate:IsA("Model") then
		local primary = getPrimary(candidate)
		if primary then
			candidate.PrimaryPart = primary
			candidate:PivotTo(cf)
		else
			warn(string.format("[MagicGourd] Asset %s has no BasePart to pivot", def.name))
		end
	elseif candidate:IsA("BasePart") then
		candidate.CFrame = cf
		candidate.Anchored = true
	end

	container:Destroy()
end

for _, def in ipairs(assets) do
	placeAsset(def)
end
