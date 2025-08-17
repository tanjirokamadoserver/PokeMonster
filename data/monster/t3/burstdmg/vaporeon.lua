local mType = Game.createMonsterType("Vaporeon")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Vaporeon"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 134
}

pokemon.health = 17796
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "none"
pokemon.corpse = 26995
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
    minimumLevel = 80,
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
    moveMagicAttackBase = 165,
    moveMagicDefenseBase = 115,
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
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
	{name = "Tackle", power = 9, interval = 2000},
	{name = "Water Gun", power = 12, interval = 2000},
	{name = "Bubble Beam", power = 8, interval = 2000},
	{name = "Water Ball", power = 12, interval = 25000},
	{name = "Water Pulse", power = 15, interval = 40000},
	{name = "Surf", power = 25, interval = 50000},
	{name = "Hydro Pump", power = 30, interval = 50000},
	{name = "Flip Turn", power = 20, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
	{name = "Tackle", power = 9, interval = 2000, chance = 100},
	{name = "Water Gun", power = 12, interval = 2000, chance = 100},
	{name = "Bubble Beam", power = 8, interval = 2000, chance = 100},
	{name = "Water Ball", power = 12, interval = 25000, chance = 100},
	{name = "Water Pulse", power = 15, interval = 40000, chance = 100},
	{name = "Surf", power = 25, interval = 50000, chance = 100},
	{name = "Hydro Pump", power = 30, interval = 50000, chance = 100},
	{name = "Flip Turn", power = 20, interval = 40000, chance = 100},
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
