
local mType = Game.createMonsterType("Mega Gyarados")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Gyarados"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 348
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "flying"
pokemon.corpse = 0
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
    minimumLevel = 150,
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
    catchChance = 1,
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
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Roar", power = 5, interval = 40000},
    {name = "Bind", power = 5, interval = 35000},
    {name = "Dragon Tail", power = 5, interval = 10000},
    {name = "Aqua Tail", power = 5, interval = 12000},
    {name = "Water Ball", power = 5, interval = 12000},
    {name = "Dragon Pulse", power = 5, interval = 35000},
    {name = "Hydro Cannon", power = 5, interval = 35000},
    {name = "Dragon Breath", power = 5, interval = 30000},
    {name = "Hyper Beam", power = 5, interval = 50000},
    {name = "Hydro Pump", power = 5, interval = 60000},
}



pokemon.attacks = {
    {name = "Roar", power = 5, interval = 40000, chance = 100},
    {name = "Bind", power = 5, interval = 35000, chance = 100},
    {name = "Dragon Tail", power = 5, interval = 10000, chance = 100},
    {name = "Aqua Tail", power = 5, interval = 12000, chance = 100},
    {name = "Water Ball", power = 5, interval = 12000, chance = 100},
    {name = "Dragon Pulse", power = 5, interval = 35000, chance = 100},
    {name = "Hydro Cannon", power = 5, interval = 35000, chance = 100},
    {name = "Dragon Breath", power = 5, interval = 30000, chance = 100},
    {name = "Hyper Beam", power = 5, interval = 50000, chance = 100},
    {name = "Hydro Pump", power = 5, interval = 60000, chance = 100},
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
