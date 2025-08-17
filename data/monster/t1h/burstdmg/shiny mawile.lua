
local mType = Game.createMonsterType("Shiny Mawile")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Mawile"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 1746
}

pokemon.health = 18566
pokemon.maxHealth = pokemon.health
pokemon.race = "steel"
pokemon.race2 = "fairy"
pokemon.corpse = 28358
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
{id = "rubber ball", chance = 8000000, maxCount = 13},
{id = "comb", chance = 1950000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
{id = "piece of steel", chance = 8000000, maxCount = 13},
{id = "metal stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Iron Head", power = 5, interval = 15000},
    {name = "Bite", power = 5, interval = 18000},
    {name = "Play Rough", power = 5, interval = 20000},
    {name = "Scrap Shot", power = 5, interval = 15000},
    {name = "Impale", power = 5, interval = 40000},
    {name = "Secret Power", power = 5, interval = 50000},
    {name = "Heavy Metal", power = 5, interval = 50000},
    {name = "Torment", power = 5, interval = 40000},
    {name = "Shadow Adamant", power = 5, interval = 50000},
}



pokemon.attacks = {
    {name = "Iron Head", power = 5, interval = 15000, chance = 100},
    {name = "Bite", power = 5, interval = 18000, chance = 100},
    {name = "Play Rough", power = 5, interval = 20000, chance = 100},
    {name = "Scrap Shot", power = 5, interval = 15000, chance = 100},
    {name = "Impale", power = 5, interval = 40000, chance = 100},
    {name = "Secret Power", power = 5, interval = 50000, chance = 100},
    {name = "Heavy Metal", power = 5, interval = 50000, chance = 100},
    {name = "Torment", power = 5, interval = 40000, chance = 100},
    {name = "Shadow Adamant", power = 5, interval = 50000, chance = 100},
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
