
local mType = Game.createMonsterType("Victreebel")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Victreebel"
pokemon.experience = 2935
pokemon.outfit = {
    lookType = 71
}

pokemon.health = 8833
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "poison"
pokemon.corpse = 26932
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
{id = "bottle of poison", chance = 8000000, maxCount = 13},
{id = "venom stone", chance = 150000, maxCount = 1},
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
{id = "leaf stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Razor Leaf", power = 7, interval = 10000},
    {name = "Vine Whip", power = 9, interval = 15000},
    {name = "Magical Leaf", power = 12, interval = 25000},
    {name = "Giga Drain", power = 12, interval = 50000},
    {name = "Poison Powder", power = 7, interval = 20000},
    {name = "Sleep Powder", power = 7, interval = 50000},
    {name = "Leaf Storm", power = 20, interval = 50000},
    {name = "Leaf Tornado", power = 15, interval = 50000},
    {name = "Growth", power = 7, interval = 50000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Razor Leaf", power = 7, interval = 10000, chance = 100},
    {name = "Vine Whip", power = 9, interval = 15000, chance = 100},
    {name = "Magical Leaf", power = 12, interval = 25000, chance = 100},
    {name = "Giga Drain", power = 12, interval = 50000, chance = 100},
    {name = "Poison Powder", power = 7, interval = 20000, chance = 100},
    {name = "Sleep Powder", power = 7, interval = 50000, chance = 100},
    {name = "Leaf Storm", power = 20, interval = 50000, chance = 100},
    {name = "Leaf Tornado", power = 15, interval = 50000, chance = 100},
    {name = "Growth", power = 7, interval = 50000, chance = 100},
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
