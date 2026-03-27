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
		position = Vector3.new(-72, 1.0, 28),
		rotation = Vector3.new(-90, 0, 0),
		scale = 10,
		groundOffset = 0,
	},
	{
		name = "NolbuHouse",
		assetId = 76012677304613,
		position = Vector3.new(74, 1.0, 18),
		rotation = Vector3.new(-90, 0, 0),
		scale = 10,
		groundOffset = 0,
	},
	{
		name = "Nolbu",
		assetId = 81648951264309,
		position = Vector3.new(58, 3.2, 34),
		rotation = Vector3.new(0, 180, 0),
		scale = 1,
		groundOffset = 0,
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

	local rotation = def.rotation or Vector3.zero
	local cf = CFrame.new(def.position)
		* CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))

	if candidate:IsA("Model") then
		local primary = getPrimary(candidate)
		if primary then
			candidate.PrimaryPart = primary

			if typeof(def.scale) == "number" and def.scale > 0 and def.scale ~= 1 then
				pcall(function()
					candidate:ScaleTo(def.scale)
				end)
			end

			candidate:PivotTo(cf)

			local boxCf, boxSize = candidate:GetBoundingBox()
			local bottomY = boxCf.Position.Y - (boxSize.Y / 2)
			local lift = def.position.Y - bottomY + (def.groundOffset or 0)
			if math.abs(lift) > 0.001 then
				candidate:PivotTo(candidate:GetPivot() + Vector3.new(0, lift, 0))
			end
		else
			warn(string.format("[MagicGourd] Asset %s has no BasePart to pivot", def.name))
		end
	elseif candidate:IsA("BasePart") then
		if typeof(def.scale) == "number" and def.scale > 0 and def.scale ~= 1 then
			candidate.Size = candidate.Size * def.scale
		end
		candidate.CFrame = cf
		candidate.Anchored = true
		local bottomY = candidate.Position.Y - (candidate.Size.Y / 2)
		local lift = def.position.Y - bottomY + (def.groundOffset or 0)
		candidate.Position += Vector3.new(0, lift, 0)
	end

	container:Destroy()
end

for _, def in ipairs(assets) do
	placeAsset(def)
end
