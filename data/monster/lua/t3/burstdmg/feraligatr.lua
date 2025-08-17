
local mType = Game.createMonsterType("Feraligatr")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Feraligatr"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 811
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "none"
pokemon.corpse = 27021
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
	{name = "Crunch", power = 9, interval = 2000},
	{name = "Bubble", power = 12, interval = 15000},
	{name = "Water Pulse", power = 7, interval = 30000},
	{name = "Ice Fang", power = 10, interval = 30000},
	{name = "Thrash", power = 15, interval = 35000},
	{name = "Hydro Cannon", power = 15, interval = 50000},
	{name = "Waterfall", power = 20, interval = 35000},
	{name = "Water Spout", power = 30, interval = 50000},
	{name = "Scary Face", power = 0, interval = 40000},
	{name = "Agility", power = 0, interval = 40000},

}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
	{name = "Crunch", power = 9, interval = 15000, chance=100},
	{name = "Bubble", power = 12, interval = 15000, chance=100},
	{name = "Water Pulse", power = 7, interval = 30000, chance=100},
	{name = "Ice Fang", power = 10, interval = 30000, chance=100},
	{name = "Thrash", power = 15, interval = 35000, chance=100},
	{name = "Hydro Cannon", power = 15, interval = 50000, chance=100},
	{name = "Waterfall", power = 20, interval = 35000, chance=100},
	{name = "Water Spout", power = 30, interval = 50000, chance=100},
	{name = "Scary Face", power = 0, interval = 40000, chance=100},
	{name = "Agility", power = 0, interval = 40000, chance=100},
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
