
local mType = Game.createMonsterType("Shiny Blaziken")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Blaziken"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1700
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "fire"
pokemon.race2 = "fighting"
pokemon.corpse = 28314
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
{id = "band aid", chance = 8000000, maxCount = 13},
{id = "essence of fire", chance = 8000000, maxCount = 13},
{id = "pot of lava", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Low Kick", power = 5, interval = 15000},
    {name = "Ember", power = 5, interval = 10000},
    {name = "Mega Kick", power = 5, interval = 20000},
    {name = "Double Kick", power = 5, interval = 20000},
    {name = "Blaze Kick", power = 5, interval = 20000},
    {name = "Hi Jump Kick", power = 5, interval = 50000},
    {name = "Sky Uppercut", power = 5, interval = 30000},
    {name = "Close Combat", power = 5, interval = 50000},
    {name = "Flare Blitz", power = 5, interval = 60000},
    {name = "Bulk Up", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "Low Kick", power = 5, interval = 15000, chance = 100},
    {name = "Ember", power = 5, interval = 10000, chance = 100},
    {name = "Mega Kick", power = 5, interval = 20000, chance = 100},
    {name = "Double Kick", power = 5, interval = 20000, chance = 100},
    {name = "Blaze Kick", power = 5, interval = 20000, chance = 100},
    {name = "Hi Jump Kick", power = 5, interval = 50000, chance = 100},
    {name = "Sky Uppercut", power = 5, interval = 30000, chance = 100},
    {name = "Close Combat", power = 5, interval = 50000, chance = 100},
    {name = "Flare Blitz", power = 5, interval = 60000, chance = 100},
    {name = "Bulk Up", power = 5, interval = 40000, chance = 100},
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
