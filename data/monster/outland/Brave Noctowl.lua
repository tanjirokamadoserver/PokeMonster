
local mType = Game.createMonsterType("Brave Noctowl")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Noctowl"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 815
}

pokemon.health = 18556
pokemon.maxHealth = pokemon.health
pokemon.race = "normal"
pokemon.race2 = "flying"
pokemon.corpse = 27025
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
    moveMagicAttackBase = 140,
    moveMagicDefenseBase = 163,
    catchChance = 0,
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
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
{id = "rubber ball", chance = 8000000, maxCount = 13},
{id = "bitten apple", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Quick Attack", power = 5, interval = 10000},
    {name = "Peck", power = 5, interval = 12000},
    {name = "Drill Peck", power = 9, interval = 18000},
    {name = "Confusion", power = 5, interval = 30000},
    {name = "Echoed Voice", power = 5, interval = 20000},
    {name = "Air Slash", power = 9, interval = 30000},
    {name = "Dream Eater", power = 5, interval = 40000},
    {name = "Hypnosis", power = 5, interval = 40000},
    {name = "Roost", power = 5, interval = 80000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Quick Attack", power = 5, interval = 10000, chance = 100},
    {name = "Peck", power = 5, interval = 12000, chance = 100},
    {name = "Drill Peck", power = 9, interval = 18000, chance = 100},
    {name = "Confusion", power = 5, interval = 30000, chance = 100},
    {name = "Echoed Voice", power = 5, interval = 20000, chance = 100},
    {name = "Air Slash", power = 9, interval = 30000, chance = 100},
    {name = "Dream Eater", power = 5, interval = 40000, chance = 100},
    {name = "Hypnosis", power = 5, interval = 40000, chance = 100},
    {name = "Roost", power = 5, interval = 80000, chance = 100},
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
