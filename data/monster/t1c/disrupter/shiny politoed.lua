
local mType = Game.createMonsterType("Shiny Politoed")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Politoed"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 1002
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "none"
pokemon.corpse = 28155
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
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Mud Shot", power = 5, interval = 18000},
    {name = "Doubleslap", power = 5, interval = 8000},
    {name = "Bubble Beam", power = 5, interval = 20000},
    {name = "Water Gun", power = 5, interval = 15000},
    {name = "Hyper Voice", power = 5, interval = 30000},
    {name = "Whirlpool", power = 5, interval = 35000},
    {name = "Tongue Hook", power = 5, interval = 10000},
    {name = "Tongue Grap", power = 5, interval = 50000},
    {name = "Hydro Pump", power = 5, interval = 60000},
    {name = "Hypnosis", power = 5, interval = 50000},
}



pokemon.attacks = {
    {name = "Mud Shot", power = 5, interval = 18000, chance = 100},
    {name = "Doubleslap", power = 5, interval = 8000, chance = 100},
    {name = "Bubble Beam", power = 5, interval = 20000, chance = 100},
    {name = "Water Gun", power = 5, interval = 15000, chance = 100},
    {name = "Hyper Voice", power = 5, interval = 30000, chance = 100},
    {name = "Whirlpool", power = 5, interval = 35000, chance = 100},
    {name = "Tongue Hook", power = 5, interval = 10000, chance = 100},
    {name = "Tongue Grap", power = 5, interval = 50000, chance = 100},
    {name = "Hydro Pump", power = 5, interval = 60000, chance = 100},
    {name = "Hypnosis", power = 5, interval = 50000, chance = 100},
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
