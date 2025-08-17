
local mType = Game.createMonsterType("Golduck")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Golduck"
pokemon.experience = 2935
pokemon.outfit = {
    lookType = 55
}

pokemon.health = 8833
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "none"
pokemon.corpse = 26916
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
    minimumLevel = 70,
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
    moveMagicAttackBase = 125,
    moveMagicDefenseBase = 95,
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
    {name = "Water Gun", power = 8, interval = 15000},
    {name = "Fury Swipes", power = 12, interval = 18000},
    {name = "Water Pulse", power = 9, interval = 25000},
    {name = "Confusion", power = 10, interval = 35000},
    {name = "Psychic", power = 12, interval = 35000},
    {name = "Surf", power = 20, interval = 50000},
    {name = "Hydro Pump", power = 20, interval = 50000},
    {name = "Stunning Confusion", power = 12, interval = 50000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Water Gun", power = 8, interval = 15000, chance = 100},
    {name = "Fury Swipes", power = 12, interval = 18000, chance = 100},
    {name = "Water Pulse", power = 9, interval = 25000, chance = 100},
    {name = "Confusion", power = 10, interval = 35000, chance = 100},
    {name = "Psychic", power = 12, interval = 35000, chance = 100},
    {name = "Surf", power = 20, interval = 50000, chance = 100},
    {name = "Hydro Pump", power = 20, interval = 50000, chance = 100},
    {name = "Stunning Confusion", power = 12, interval = 50000, chance = 100},
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
