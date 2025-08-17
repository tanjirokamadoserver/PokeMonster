
local mType = Game.createMonsterType("Roserade")
local pokemon = {}
pokemon.eventFile = false
pokemon.eventFile = "default" 
pokemon.description = "a Roserade"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 2044
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "poison"
pokemon.corpse = 0
pokemon.speed = 180
pokemon.maxSummons = 0

pokemon.changeTarget = {
    interval = 4*1000,
    chance = 20
}
pokemon.wild = {
    health = pokemon.health * 1.8,
    maxHealth = pokemon.health * 1.8,
    speed = 220
}

pokemon.flags = {
    minimumLevel = 100,
    attackable = true,
    summonable = true,
    passive = false,
    hostile = true,
    convinceable = true,
    illusionable = true,
    canPushItems = false,
    canPushCreatures = false,
    targetDistance = 1,
    staticAttackChance = 97,
    pokemonRank = "",
    hasShiny = 1,
    hasMega = 0,
    moveMagicAttackBase = 160,
    moveMagicDefenseBase = 130,
    catchChance = 250,
    canControlMind = 0,
    canLevitate = 0,
    canLight = 0,
    canCut = 0,
    canSmash = 0,
    canDig = 0,
    canTeleport = 0,
    canBlink = 0,
    isSurfable = 0,
    isRideable = 0,
    isFlyable = 0,
}

pokemon.events = {
    "MonsterHealthChange"
}
pokemon.summons = {}

pokemon.voices = {
    interval = 5000,
    chance = 65,
    {text = "ABUUUH!", yell = FALSE},
}

pokemon.loot = {
{id = "bottle of poison", chance = 8000000, maxCount = 13},
{id = "venom stone", chance = 150000, maxCount = 1},
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
{id = "leaf stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Razor Leaf", power = 2, interval = 12000},
    {name = "Magical Leaf", power = 2, interval = 15000},
    {name = "Poison Jab", power = 2, interval = 15000},
    {name = "Synthesis ", power = 8, interval = 80000},
    {name = "Petal Blizzard", power = 28, interval = 50000},
    {name = "Petal Dance", power = 28, interval = 50000},
    {name = "Solar Beam", power = 22, interval = 40000},
    {name = "Sunny Day", power = 7, interval = 40000},
}

pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Sand Attack", power = 7, interval = 10000, chance = 100},
    {name = "Doubleslap", power = 10, interval = 5000, chance = 100},
    {name = "Scratch", power = 7, interval = 10000, chance = 100},
    {name = "Swift", power = 7, interval = 10000, chance = 100},
    {name = "Fury Swipes", power = 12, interval = 20000, chance = 100},
    {name = "Last Resort", power = 20, interval = 25000, chance = 100},
    {name = "Agility", power = 0, interval = 40000, chance = 100},
}

pokemon.defenses = {}
pokemon.elements = {}
pokemon.immunities = {}

mType.onThink = function(pokemon, interval)
end

mType.onAppear = function(pokemon, creature)
end

mType.onDisappear = function(pokemon, creature)
end

mType.onMove = function(pokemon, creature, fromPosition, toPosition)
end

mType.onSay = function(pokemon, creature, type, message)
end

mType:register(pokemon)
