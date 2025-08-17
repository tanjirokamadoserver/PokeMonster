
local mType = Game.createMonsterType("Shiny Spheal")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Spheal"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1806
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "ice"
pokemon.race2 = "water"
pokemon.corpse = 28415
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
{id = "snow ball", chance = 8000000, maxCount = 13},
{id = "ice orb", chance = 3250000, maxCount = 1},
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Ice Shards", power = 8, interval = 10000},
    {name = "Ice Fang", power = 5, interval = 25000},
    {name = "Ice Beam", power = 5, interval = 20000},
    {name = "Ice Ball", power = 5, interval = 28000},
    {name = "Frost Breath", power = 12, interval = 20000},
    {name = "Powder Snow", power = 5, interval = 40000},
    {name = "Defense Curl", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "Ice Shards", power = 8, interval = 10000, chance = 100},
    {name = "Ice Fang", power = 5, interval = 25000, chance = 100},
    {name = "Ice Beam", power = 5, interval = 20000, chance = 100},
    {name = "Ice Ball", power = 5, interval = 28000, chance = 100},
    {name = "Frost Breath", power = 12, interval = 20000, chance = 100},
    {name = "Powder Snow", power = 5, interval = 40000, chance = 100},
    {name = "Defense Curl", power = 5, interval = 40000, chance = 100},
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
