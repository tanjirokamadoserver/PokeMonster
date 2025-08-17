
local mType = Game.createMonsterType("Shiny Slowking")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Slowking"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1015
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "psychic"
pokemon.corpse = 28168
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
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Water Ball", power = 5, interval = 12000},
    {name = "Instant Teleportation", power = 5, interval = 15000},
    {name = "Psy Ball", power = 5, interval = 10000},
    {name = "Confusion", power = 5, interval = 25000},
    {name = "Surf", power = 5, interval = 50000},
    {name = "Psy Impact", power = 5, interval = 60000},
    {name = "Calm Mind", power = 5, interval = 40000},
    {name = "Future Sight", power = 5, interval = 35000},
    {name = "Nasty Plot", power = 5, interval = 60000},
    {name = "Miracle Eye", power = 5, interval = 15000},
}



pokemon.attacks = {
    {name = "Water Ball", power = 5, interval = 12000, chance = 100},
    {name = "Instant Teleportation", power = 5, interval = 15000, chance = 100},
    {name = "Psy Ball", power = 5, interval = 10000, chance = 100},
    {name = "Confusion", power = 5, interval = 25000, chance = 100},
    {name = "Surf", power = 5, interval = 50000, chance = 100},
    {name = "Psy Impact", power = 5, interval = 60000, chance = 100},
    {name = "Calm Mind", power = 5, interval = 40000, chance = 100},
    {name = "Future Sight", power = 5, interval = 35000, chance = 100},
    {name = "Nasty Plot", power = 5, interval = 60000, chance = 100},
    {name = "Miracle Eye", power = 5, interval = 15000, chance = 100},
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
