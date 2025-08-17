
local mType = Game.createMonsterType("Shiny Exploud")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Exploud"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1738
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "normal"
pokemon.race2 = "none"
pokemon.corpse = 28351
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
{id = "rubber ball", chance = 8000000, maxCount = 13},
{id = "bitten apple", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Bite", power = 5, interval = 10000},
    {name = "Crunch", power = 5, interval = 10000},
    {name = "Fire Fang", power = 5, interval = 20000},
    {name = "Take Down", power = 5, interval = 30000},
    {name = "Boomburst", power = 5, interval = 50000},
    {name = "Echoed Voice", power = 5, interval = 30000},
    {name = "Hyper Voice", power = 5, interval = 40000},
    {name = "Hyper Beam", power = 5, interval = 45000},
}



pokemon.attacks = {
    {name = "Bite", power = 5, interval = 10000, chance = 100},
    {name = "Crunch", power = 5, interval = 10000, chance = 100},
    {name = "Fire Fang", power = 5, interval = 20000, chance = 100},
    {name = "Take Down", power = 5, interval = 30000, chance = 100},
    {name = "Boomburst", power = 5, interval = 50000, chance = 100},
    {name = "Echoed Voice", power = 5, interval = 30000, chance = 100},
    {name = "Hyper Voice", power = 5, interval = 40000, chance = 100},
    {name = "Hyper Beam", power = 5, interval = 45000, chance = 100},
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
