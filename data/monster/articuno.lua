
local mType = Game.createMonsterType("Articuno")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Articuno"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 144
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "ice"
pokemon.race2 = "flying"
pokemon.corpse = 27005
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
    moveMagicAttackBase = 10,
    moveMagicDefenseBase = 15,
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
{id = "snow ball", chance = 8000000, maxCount = 13},
{id = "ice orb", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 1, interval = 2000},
    {name = "Peck", power = 1, interval = 10000},
    {name = "Ice Shard", power = 1, interval = 10000},
    {name = "Ice Beam", power = 1, interval = 10000},
    {name = "Drill Peck", power = 1, interval = 15000},
    {name = "Ancient Power", power = 1, interval = 30000},
    {name = "Frost Breath", power = 1, interval = 10000},
    {name = "Air Cutter", power = 1, interval = 15000},
    {name = "Pluck", power = 1, interval = 20000},
    {name = "Powder Snow", power = 1, interval = 20000},
    {name = "Aerial Ace", power = 1, interval = 40000},
    {name = "Aurora Beam", power = 1, interval = 40000},
    {name = "Blizzard", power = 1, interval = 40000},
    {name = "Iceshock", power = 1, interval = 40000},
    {name = "Frost Tornado", power = 1, interval = 60000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Peck", power = 1, interval = 10000, chance = 100},
    {name = "Ice Shard", power = 1, interval = 10000, chance = 100},
    {name = "Ice Beam", power = 1, interval = 10000, chance = 100},
    {name = "Drill Peck", power = 1, interval = 15000, chance = 100},
    {name = "Ancient Power", power = 1, interval = 30000, chance = 100},
    {name = "Frost Breath", power = 1, interval = 10000, chance = 100},
    {name = "Air Cutter", power = 1, interval = 15000, chance = 100},
    {name = "Pluck", power = 1, interval = 20000, chance = 100},
    {name = "Powder Snow", power = 1, interval = 20000, chance = 100},
    {name = "Aerial Ace", power = 1, interval = 40000, chance = 100},
    {name = "Aurora Beam", power = 1, interval = 40000, chance = 100},
    {name = "Blizzard", power = 1, interval = 40000, chance = 100},
    {name = "Iceshock", power = 1, interval = 40000, chance = 100},
    {name = "Frost Tornado", power = 1, interval = 60000, chance = 100},
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
