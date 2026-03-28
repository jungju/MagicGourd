print("MagicGourd client started")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local shared = ReplicatedStorage:WaitForChild("Shared")
local dialogueEvent = shared:WaitForChild("DialogueEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MagicGourdHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local questFrame = Instance.new("Frame")
questFrame.Name = "QuestTracker"
questFrame.AnchorPoint = Vector2.new(0, 0)
questFrame.Position = UDim2.fromOffset(20, 20)
questFrame.Size = UDim2.fromOffset(360, 116)
questFrame.BackgroundColor3 = Color3.fromRGB(26, 18, 12)
questFrame.BackgroundTransparency = 0.2
questFrame.BorderSizePixel = 0
questFrame.Parent = screenGui

local questCorner = Instance.new("UICorner")
questCorner.CornerRadius = UDim.new(0, 14)
questCorner.Parent = questFrame

local questStroke = Instance.new("UIStroke")
questStroke.Color = Color3.fromRGB(227, 188, 96)
questStroke.Thickness = 2
questStroke.Parent = questFrame

local questTitle = Instance.new("TextLabel")
questTitle.BackgroundTransparency = 1
questTitle.Position = UDim2.fromOffset(12, 10)
questTitle.Size = UDim2.new(1, -24, 0, 28)
questTitle.Font = Enum.Font.GothamBold
questTitle.TextXAlignment = Enum.TextXAlignment.Left
questTitle.TextColor3 = Color3.fromRGB(255, 239, 204)
questTitle.TextScaled = true
questTitle.Text = "Village Rumor"
questTitle.Parent = questFrame

local questBody = Instance.new("TextLabel")
questBody.BackgroundTransparency = 1
questBody.Position = UDim2.fromOffset(12, 40)
questBody.Size = UDim2.new(1, -24, 0, 38)
questBody.Font = Enum.Font.Gotham
questBody.TextXAlignment = Enum.TextXAlignment.Left
questBody.TextYAlignment = Enum.TextYAlignment.Top
questBody.TextWrapped = true
questBody.TextColor3 = Color3.fromRGB(240, 231, 214)
questBody.TextScaled = true
questBody.Text = "Read the Story Stone or speak with Heungbu."
questBody.Parent = questFrame

local statsLabel = Instance.new("TextLabel")
statsLabel.BackgroundTransparency = 1
statsLabel.Position = UDim2.fromOffset(12, 82)
statsLabel.Size = UDim2.new(1, -24, 0, 22)
statsLabel.Font = Enum.Font.GothamMedium
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextColor3 = Color3.fromRGB(214, 201, 180)
statsLabel.TextScaled = true
statsLabel.Text = "Seeds 0 · Gourds 0 · Coins 0"
statsLabel.Parent = questFrame

local dialogueFrame = Instance.new("Frame")
dialogueFrame.Name = "DialogueBox"
dialogueFrame.AnchorPoint = Vector2.new(0.5, 1)
dialogueFrame.Position = UDim2.new(0.5, 0, 1, -28)
dialogueFrame.Size = UDim2.fromOffset(620, 130)
dialogueFrame.BackgroundColor3 = Color3.fromRGB(22, 15, 10)
dialogueFrame.BackgroundTransparency = 0.18
dialogueFrame.BorderSizePixel = 0
dialogueFrame.Visible = false
dialogueFrame.Parent = screenGui

local dialogueCorner = Instance.new("UICorner")
dialogueCorner.CornerRadius = UDim.new(0, 16)
dialogueCorner.Parent = dialogueFrame

local dialogueStroke = Instance.new("UIStroke")
dialogueStroke.Color = Color3.fromRGB(111, 224, 128)
dialogueStroke.Thickness = 2
dialogueStroke.Parent = dialogueFrame

local speakerLabel = Instance.new("TextLabel")
speakerLabel.BackgroundTransparency = 1
speakerLabel.Position = UDim2.fromOffset(16, 10)
speakerLabel.Size = UDim2.new(1, -32, 0, 24)
speakerLabel.Font = Enum.Font.GothamBold
speakerLabel.TextXAlignment = Enum.TextXAlignment.Left
speakerLabel.TextColor3 = Color3.fromRGB(255, 236, 199)
speakerLabel.TextScaled = true
speakerLabel.Text = "Speaker"
speakerLabel.Parent = dialogueFrame

local bodyLabel = Instance.new("TextLabel")
bodyLabel.BackgroundTransparency = 1
bodyLabel.Position = UDim2.fromOffset(16, 38)
bodyLabel.Size = UDim2.new(1, -32, 1, -56)
bodyLabel.Font = Enum.Font.Gotham
bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
bodyLabel.TextWrapped = true
bodyLabel.TextColor3 = Color3.fromRGB(243, 236, 226)
bodyLabel.TextScaled = true
bodyLabel.Text = ""
bodyLabel.Parent = dialogueFrame

local activeDialogueToken = 0

local function formatStats()
	local seeds = player:GetAttribute("Seeds") or 0
	local gourds = player:GetAttribute("Gourds") or 0
	local coins = player:GetAttribute("Coins") or 0
	statsLabel.Text = string.format("Seeds %d  ·  Gourds %d  ·  Coins %d", seeds, gourds, coins)
end

local function refreshQuest()
	questTitle.Text = player:GetAttribute("QuestTitle") or "Village Rumor"
	questBody.Text = player:GetAttribute("QuestObjective") or "Help the village."
	formatStats()
end

local function showDialogue(payload)
	activeDialogueToken += 1
	local token = activeDialogueToken
	local lines = payload.lines or {}
	speakerLabel.Text = payload.speaker or "Village"
	dialogueStroke.Color = payload.accent or Color3.fromRGB(111, 224, 128)
	dialogueFrame.Visible = true
	dialogueFrame.BackgroundTransparency = 0.35
	TweenService:Create(dialogueFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.18 }):Play()
	bodyLabel.Text = table.concat(lines, "\n\n")

	task.delay(5.5, function()
		if activeDialogueToken ~= token then
			return
		end
		dialogueFrame.Visible = false
	end)
end

for _, attributeName in ipairs({ "QuestTitle", "QuestObjective", "Seeds", "Gourds", "Coins" }) do
	player:GetAttributeChangedSignal(attributeName):Connect(refreshQuest)
end

refreshQuest()

dialogueEvent.OnClientEvent:Connect(showDialogue)
