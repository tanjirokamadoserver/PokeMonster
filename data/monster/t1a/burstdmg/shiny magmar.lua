
local mType = Game.createMonsterType("Shiny Magmar")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Magmar"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 344
}

pokemon.health = 24379
pokemon.maxHealth = pokemon.health
pokemon.race = "fire"
pokemon.race2 = "none"
pokemon.corpse = 27611
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
{id = "essence of fire", chance = 8000000, maxCount = 13},
{id = "pot of lava", chance = 3250000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Scratch", power = 5, interval = 10000},
    {name = "Smog", power = 5, interval = 30000},
    {name = "Fire Punch", power = 5, interval = 25000},
    {name = "Ember", power = 5, interval = 8000},
    {name = "Fire Spin", power = 5, interval = 32000},
    {name = "Overheat", power = 5, interval = 35000},
    {name = "Fire Blast", power = 5, interval = 35000},
    {name = "Magma Fist", power = 5, interval = 40000},
    {name = "Magma Storm", power = 5, interval = 60000},
}



pokemon.attacks = {
    {name = "Scratch", power = 5, interval = 10000, chance = 100},
    {name = "Smog", power = 5, interval = 30000, chance = 100},
    {name = "Fire Punch", power = 5, interval = 25000, chance = 100},
    {name = "Ember", power = 5, interval = 8000, chance = 100},
    {name = "Fire Spin", power = 5, interval = 32000, chance = 100},
    {name = "Overheat", power = 5, interval = 35000, chance = 100},
    {name = "Fire Blast", power = 5, interval = 35000, chance = 100},
    {name = "Magma Fist", power = 5, interval = 40000, chance = 100},
    {name = "Magma Storm", power = 5, interval = 60000, chance = 100},
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
