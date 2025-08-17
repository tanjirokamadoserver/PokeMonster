
local mType = Game.createMonsterType("Shiny Electabuzz")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Electabuzz"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 343
}

pokemon.health = 24379
pokemon.maxHealth = pokemon.health
pokemon.race = "electric"
pokemon.race2 = "none"
pokemon.corpse = 27610
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
    minimumLevel = 200,
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
    moveMagicAttackBase = 220,
    moveMagicDefenseBase = 180,
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
{id = "screw", chance = 8000000, maxCount = 13},
{id = "electric box", chance = 3250000, maxCount = 1},
{id = "thunder stone", chance = 150000, maxCount = 1}
}

pokemon.moves = {
    {name = "Quick Attack", power = 5, interval = 15000},
    {name = "Electroweb", power = 5, interval = 32000},
    {name = "Thunder Punch", power = 5, interval = 25000},
    {name = "Thunder Shock", power = 5, interval = 8000},
    {name = "Thunderbolt", power = 5, interval = 20000},
    {name = "Lightning Fist", power = 5, interval = 40000},
    {name = "Thunder", power = 5, interval = 35000},
    {name = "Mamaragan", power = 5, interval = 60000},
}



pokemon.attacks = {
    {name = "Quick Attack", power = 5, interval = 15000, chance = 100},
    {name = "Electroweb", power = 5, interval = 32000, chance = 100},
    {name = "Thunder Punch", power = 5, interval = 25000, chance = 100},
    {name = "Thunder Shock", power = 5, interval = 8000, chance = 100},
    {name = "Thunderbolt", power = 5, interval = 20000, chance = 100},
    {name = "Lightning Fist", power = 5, interval = 40000, chance = 100},
    {name = "Thunder", power = 5, interval = 35000, chance = 100},
    {name = "Mamaragan", power = 5, interval = 60000, chance = 100},
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
