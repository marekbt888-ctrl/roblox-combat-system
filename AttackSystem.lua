--[[
	AttackSystem (LocalScript, StarterPlayerScripts)

	Obsługuje klikanie w cel (melee), podświetlenie wroga pod myszką
	i wysyłanie próby ataku do serwera. Animacja ataku jest odtwarzana
	dopiero gdy serwer potwierdzi trafienie (AttackAnimEvent) - dzięki
	temu wszyscy gracze widzą te same ciosy w tym samym momencie.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local CombatConfig = require(ReplicatedStorage:WaitForChild("CombatConfig"))
local ATTACK = CombatConfig.PlayerAttack

local attackEvent = ReplicatedStorage:WaitForChild("AttackEvent")
local attackAnimEvent = ReplicatedStorage:WaitForChild("AttackAnimEvent")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local lastAttack = 0
local attackAnimCache = {} -- animacja per character
local isAttacking = false -- flaga aby zapobiec spamowaniu

-- ===== Cel pod myszką =====

local function getTargetUnderMouse()
	local hit = mouse.Target
	if not hit then return nil end

	local model = hit:FindFirstAncestorOfClass("Model")
	if not model then return nil end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return nil end
	if model == player.Character then return nil end

	return model
end

-- ===== Animacja (odtwarzana po potwierdzeniu z serwera) =====

local function playAttackAnimation(character)
	if not character then return end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then return end

	local track = attackAnimCache[character]
	if not track then
		local anim = Instance.new("Animation")
		anim.AnimationId = ATTACK.AnimationId
		track = animator:LoadAnimation(anim)
		attackAnimCache[character] = track
	end
	
	if track then
		track:Stop()
		task.wait(0.05)
		track:Play()
	end
end

attackAnimEvent.OnClientEvent:Connect(function(character)
	playAttackAnimation(character)
end)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(newChar)
		-- wyczyść cache dla starego charakteru
		for char, track in pairs(attackAnimCache) do
			if not char.Parent then
				attackAnimCache[char] = nil
			end
		end
	end)
end)

-- ===== Klikanie = próba ataku =====

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

	local now = tick()
	if now - lastAttack < ATTACK.Cooldown then return end
	
	local character = player.Character
	if not character or isAttacking then return end
	
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local target = getTargetUnderMouse()
	if not target then return end
	
	local targetRoot = target:FindFirstChild("HumanoidRootPart")
	if not targetRoot then return end

	local distance = (targetRoot.Position - root.Position).Magnitude
	if distance > ATTACK.Range then return end

	-- Obróć postać w stronę celu
	local look = Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z)
	root.CFrame = CFrame.lookAt(root.Position, look)

	lastAttack = now
	isAttacking = true
	
	-- Serwer sam zdecyduje czy atak się liczy i odtworzy animację
	attackEvent:FireServer(target)
	
	task.wait(ATTACK.Cooldown)
	isAttacking = false
end)

-- ===== Podświetlenie celu pod myszką =====

local currentHighlight = nil
RunService.RenderStepped:Connect(function()
	local target = getTargetUnderMouse()

	if currentHighlight then
		if currentHighlight.Parent then
			currentHighlight:Destroy()
		end
		currentHighlight = nil
	end

	if target then
		local h = Instance.new("Highlight")
		h.FillColor = Color3.fromRGB(255, 60, 60)
		h.OutlineColor = Color3.new(1, 1, 1)
		h.FillTransparency = 0.7
		h.Parent = target
		currentHighlight = h
	end
end)
