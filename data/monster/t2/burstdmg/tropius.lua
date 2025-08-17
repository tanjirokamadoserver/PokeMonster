
local mType = Game.createMonsterType("Tropius")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Tropius"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 1605
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "flying"
pokemon.corpse = 27929
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
    passive = true,
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
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
{id = "feather stone", chance = 150000, maxCount = 1},
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
{id = "leaf stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Seed Bomb", power = 8, interval = 40000},
    {name = "Razor Leaf", power = 2, interval = 10000},
    {name = "Magical Leaf", power = 3, interval = 25000},
    {name = "Leafage", power = 6, interval = 30000},
    {name = "Stomp", power = 8, interval = 25000},
    {name = "Leaf Tornado", power = 8, interval = 60000},
    {name = "Leaf Storm", power = 205, interval = 60000},
    {name = "Growth", power = 7, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Seed Bomb", power = 7, interval = 40000, chance = 100},
    {name = "Razor Leaf", power = 7, interval = 10000, chance = 100},
    {name = "Magical Leaf", power = 12, interval = 25000, chance = 100},
    {name = "Leafage", power = 7, interval = 30000, chance = 100},
    {name = "Stomp", power = 10, interval = 25000, chance = 100},
    {name = "Leaf Tornado", power = 15, interval = 60000, chance = 100},
    {name = "Leaf Storm", power = 20, interval = 60000, chance = 100},
    {name = "Growth", power = 7, interval = 40000, chance = 100},
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
