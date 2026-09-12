--[[
	CombatConfig (ModuleScript, ReplicatedStorage)

	Jedno miejsce ze wszystkimi liczbami balansu walki.
	Zarówno serwer, jak i klient korzystają z tych samych wartości,
	więc nie trzeba pamiętać o zmianie liczby w dwóch miejscach naraz.
]]

local CombatConfig = {}

-- Atak gracza (melee, klik myszką)
CombatConfig.PlayerAttack = {
	Damage = 15,
	Range = 16,
	Cooldown = 0.6,
	AnimationId = "rbxassetid://180436148",
}

-- Wrogowie
CombatConfig.Enemy = {
	Count = 5,
	Health = 50,
	Damage = 8,
	AttackCooldown = 1.5,
	WalkSpeed = 10,
	DetectionRange = 40,
	AttackRange = 5,
	MinSpawnRadius = 25, -- nie spawnują się blisko SpawnLocation graczy
	MaxSpawnRadius = 120,
	RespawnDelay = 5, -- ile sekund po śmierci pojawia się nowy wróg
	XPReward = 25,
	GoldReward = 10,
}

-- Wygląd cyferek obrażeń
CombatConfig.DamageDisplay = {
	TextSize = 36,
	SpawnHeightOffset = 3, -- nad głową, nie w środku ciała
	RiseHeight = 4,
	RiseDuration = 1,
}

-- Prosta wygenerowana mapka (podłoga + mury + przeszkody)
CombatConfig.Map = {
	FloorSize = 300, -- bok kwadratowej podłogi w studach
	WallHeight = 20,
	WallThickness = 4,
	ObstacleCount = 10,
}

-- Startowe staty gracza
CombatConfig.PlayerStats = {
	HP = 100, MaxHP = 100,
	MP = 50, MaxMP = 50,
	XP = 0, Level = 1, XPToNextLevel = 100,
	Gold = 0,
}

-- Progresja levelowania
CombatConfig.Leveling = {
	XPMultiplierPerLevel = 1.5,
	HPGainPerLevel = 20,
	MPGainPerLevel = 10,
}

return CombatConfig