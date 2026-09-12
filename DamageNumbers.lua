--[[
	DamageNumbers (LocalScript, StarterPlayerScripts)

	Pokazuje unoszące się cyferki obrażeń nad każdym trafionym celem
	(graczem lub wrogiem) - wywoływane przez serwer przez DamageEvent.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local CombatConfig = require(ReplicatedStorage:WaitForChild("CombatConfig"))
local DISPLAY = CombatConfig.DamageDisplay

local damageEvent = ReplicatedStorage:WaitForChild("DamageEvent")

local function createDamageNumber(position, amount)
	-- Losowy odstęp w bok, żeby kolejne trafienia się na sobie nie stackowały
	local jitter = Vector3.new(math.random(-15, 15) / 10, 0, math.random(-15, 15) / 10)
	local spawnPosition = position + Vector3.new(0, DISPLAY.SpawnHeightOffset, 0) + jitter

	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(0.1, 0.1, 0.1)
	part.CFrame = CFrame.new(spawnPosition)
	part.Parent = workspace

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 160, 0, 60)
	billboard.AlwaysOnTop = true -- rysowane NAD postaciami - nie da się ich zasłonić
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "-" .. amount
	label.TextColor3 = Color3.fromRGB(255, 220, 60)
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.GothamBlack
	label.TextSize = DISPLAY.TextSize
	label.Parent = billboard

	local tweenInfo = TweenInfo.new(
		DISPLAY.RiseDuration,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)
	
	local tween = TweenService:Create(part, tweenInfo, {
		CFrame = part.CFrame * CFrame.new(0, DISPLAY.RiseHeight, 0)
	})
	tween:Play()

	local fadeTweenInfo = TweenInfo.new(
		DISPLAY.RiseDuration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In
	)
	
	local fadeTween = TweenService:Create(label, fadeTweenInfo, {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	})
	fadeTween:Play()

	-- Czyszczenie po zakończeniu animacji
	tween.Completed:Connect(function()
		if part and part.Parent then
			part:Destroy()
		end
	end)
end

damageEvent.OnClientEvent:Connect(function(position, amount)
	if position and amount then
		createDamageNumber(position, amount)
	end
end)
