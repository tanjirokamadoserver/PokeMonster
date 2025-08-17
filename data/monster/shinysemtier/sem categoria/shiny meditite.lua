
local mType = Game.createMonsterType("Shiny Meditite")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Meditite"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1750
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "fighting"
pokemon.race2 = "psychic"
pokemon.corpse = 28362
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
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "band aid", chance = 8000000, maxCount = 13},
}

pokemon.moves = {
    {name = "Low Kick", power = 5, interval = 10000},
    {name = "Mega Kick", power = 5, interval = 20000},
    {name = "Drain Punch", power = 5, interval = 35000},
    {name = "Confusion", power = 5, interval = 30000},
    {name = "Psychic", power = 5, interval = 35000},
    {name = "Hi Jump Kick", power = 5, interval = 50000},
}



pokemon.attacks = {
    {name = "Low Kick", power = 5, interval = 10000, chance = 100},
    {name = "Mega Kick", power = 5, interval = 20000, chance = 100},
    {name = "Drain Punch", power = 5, interval = 35000, chance = 100},
    {name = "Confusion", power = 5, interval = 30000, chance = 100},
    {name = "Psychic", power = 5, interval = 35000, chance = 100},
    {name = "Hi Jump Kick", power = 5, interval = 50000, chance = 100},
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
