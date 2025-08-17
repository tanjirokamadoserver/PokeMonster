
local mType = Game.createMonsterType("Shiny Nidorino")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Nidorino"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 241
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "poison"
pokemon.race2 = "none"
pokemon.corpse = 27533
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
{id = "bottle of poison", chance = 8000000, maxCount = 13},
}

pokemon.moves = {
    {name = "Quick Attack", power = 5, interval = 8000},
    {name = "Horn Attack", power = 5, interval = 20000},
    {name = "Poison Jab", power = 5, interval = 20000},
    {name = "Poison Fang", power = 5, interval = 20000},
    {name = "Dig", power = 5, interval = 40000},
    {name = "Cross Poison", power = 5, interval = 40000},
    {name = "Rage", power = 5, interval = 30000},
}



pokemon.attacks = {
    {name = "Quick Attack", power = 5, interval = 8000, chance = 100},
    {name = "Horn Attack", power = 5, interval = 20000, chance = 100},
    {name = "Poison Jab", power = 5, interval = 20000, chance = 100},
    {name = "Poison Fang", power = 5, interval = 20000, chance = 100},
    {name = "Dig", power = 5, interval = 40000, chance = 100},
    {name = "Cross Poison", power = 5, interval = 40000, chance = 100},
    {name = "Rage", power = 5, interval = 30000, chance = 100},
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
