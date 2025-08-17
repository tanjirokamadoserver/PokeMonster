
local mType = Game.createMonsterType("Shiny Duskull")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Duskull"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1798
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "ghost"
pokemon.race2 = "none"
pokemon.corpse = 28408
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
{id = "ghost essence", chance = 8000000, maxCount = 13},
{id = "traces of ghost", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Shadow Ball", power = 5, interval = 10000},
    {name = "Shadow Punch", power = 5, interval = 20000},
    {name = "Night Shade", power = 5, interval = 30000},
    {name = "Confuse Ray", power = 5, interval = 40000},
    {name = "Dark Accurate", power = 5, interval = 15000},
}



pokemon.attacks = {
    {name = "Shadow Ball", power = 5, interval = 10000, chance = 100},
    {name = "Shadow Punch", power = 5, interval = 20000, chance = 100},
    {name = "Night Shade", power = 5, interval = 30000, chance = 100},
    {name = "Confuse Ray", power = 5, interval = 40000, chance = 100},
    {name = "Dark Accurate", power = 5, interval = 15000, chance = 100},
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
