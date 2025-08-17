
local mType = Game.createMonsterType("Shiny Delibird")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Delibird"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 1040
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "ice"
pokemon.race2 = "flying"
pokemon.corpse = 28194
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
    moveMagicAttackBase = 50,
    moveMagicDefenseBase = 15,
    catchChance = 150,
    canControlMind = 0,
    canLevitate = 0,
    canLight = 0,
    canCut = 0,
    canSmash = 0,
    canDig = 0,
    canTeleport = 0,
    canBlink = 1,
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
{id = "snow ball", chance = 8000000, maxCount = 13},
{id = "ice orb", chance = 3250000, maxCount = 1},
{id = "ice stone", chance = 150000, maxCount = 1}
}

pokemon.moves = {
    {name = "Melee", power = 3, interval = 2000},
    {name = "Drill Peck", power = 9, interval = 8000},
    {name = "Present", power = 7, interval = 25000},
    {name = "Ice Punch", power = 9, interval = 20000},
    {name = "Ice Shards", power = 8, interval = 10000},
    {name = "Frost Breath", power = 12, interval = 30000},
    {name = "Aurora Beam", power = 15, interval = 40000},
    {name = "Blizzard", power = 20, interval = 50000},
    {name = "Present Rain", power = 15, interval = 40000},
    {name = "Agility", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "Melee", power = 3, interval = 2000, chance= 100},
    {name = "Drill Peck", power = 9, interval = 8000, chance = 100},
    {name = "Present", power = 7, interval = 25000, chance = 100},
    {name = "Ice Punch", power = 9, interval = 20000, chance = 100},
    {name = "Ice Shards", power = 8, interval = 10000, chance = 100},
    {name = "Frost Breath", power = 12, interval = 30000, chance = 100},
    {name = "Aurora Beam", power = 15, interval = 40000, chance = 100},
    {name = "Blizzard", power = 20, interval = 50000, chance = 100},
    {name = "Present Rain", power = 15, interval = 40000, chance = 100},
    {name = "Agility", power = 5, interval = 40000, chance = 100},
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
