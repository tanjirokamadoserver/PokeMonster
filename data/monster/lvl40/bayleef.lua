
local mType = Game.createMonsterType("Bayleef")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Bayleef"
pokemon.experience = 625
pokemon.outfit = {
    lookType = 801
}

pokemon.health = 2897
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "none"
pokemon.corpse = 27014
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
    minimumLevel = 40,
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
    moveMagicAttackBase = 65,
    moveMagicDefenseBase = 55,
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
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
{id = "leaf stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Body Slam", power = 9, interval = 20000},
    {name = "Razor Leaf", power = 7, interval = 10000},
    {name = "Magical Leaf", power = 12, interval = 20000},
    {name = "Petal Dance", power = 12, interval = 25000},
    {name = "Synthesis", power = 7, interval = 80000},
    {name = "Leaf Tornado", power = 15, interval = 80000},
    {name = "Sleep Powder", power = 7, interval = 80000},
    {name = "Poison Powder", power = 7, interval = 20000},
    {name = "Light Screen", power = 0, interval = 50000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Body Slam", power = 9, interval = 20000, chance = 100},
    {name = "Razor Leaf", power = 7, interval = 10000, chance = 100},
    {name = "Magical Leaf", power = 12, interval = 20000, chance = 100},
    {name = "Petal Dance", power = 12, interval = 25000, chance = 100},
    {name = "Synthesis", power = 7, interval = 80000, chance = 100},
    {name = "Leaf Tornado", power = 15, interval = 80000, chance = 100},
    {name = "Sleep Powder", power = 7, interval = 80000, chance = 100},
    {name = "Poison Powder", power = 7, interval = 20000, chance = 100},
    {name = "Light Screen", power = 0, interval = 50000, chance = 100},
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
