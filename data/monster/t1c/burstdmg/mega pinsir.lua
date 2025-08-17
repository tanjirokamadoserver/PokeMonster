
local mType = Game.createMonsterType("Mega Pinsir")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Pinsir"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 345
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "bug"
pokemon.race2 = "none"
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
{id = "bug gosme", chance = 8000000, maxCount = 13},
{id = "pot of moss bug", chance = 3250000, maxCount = 1},
{id = "cocoon stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Bug Bite", power = 5, interval = 8000},
    {name = "Vital Throw", power = 5, interval = 30000},
    {name = "Bind", power = 5, interval = 30000},
    {name = "Fury cutter", power = 5, interval = 15000},
    {name = "Guillotine", power = 5, interval = 30000},
    {name = "X-Scissor", power = 5, interval = 30000},
    {name = "Savage Spirit", power = 5, interval = 60000},
    {name = "Secret Power", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "Bug Bite", power = 5, interval = 8000, chance = 100},
    {name = "Vital Throw", power = 5, interval = 30000, chance = 100},
    {name = "Bind", power = 5, interval = 30000, chance = 100},
    {name = "Fury cutter", power = 5, interval = 15000, chance = 100},
    {name = "Guillotine", power = 5, interval = 30000, chance = 100},
    {name = "X-Scissor", power = 5, interval = 30000, chance = 100},
    {name = "Savage Spirit", power = 5, interval = 60000, chance = 100},
    {name = "Secret Power", power = 5, interval = 40000, chance = 100},
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
