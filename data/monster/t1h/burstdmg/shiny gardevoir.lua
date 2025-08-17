
local mType = Game.createMonsterType("Shiny Gardevoir")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Gardevoir"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 111
}

pokemon.health = 18566
pokemon.maxHealth = pokemon.health
pokemon.race = "psychic"
pokemon.race2 = "fairy"
pokemon.corpse = 28338
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
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "darkness stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Psy Ball", power = 5, interval = 20000},
    {name = "Psy Pulse", power = 5, interval = 18000},
    {name = "Dazzling Gleam", power = 5, interval = 20000},
    {name = "Synchronoise", power = 5, interval = 40000},
    {name = "Heart Pound", power = 5, interval = 40000},
    {name = "Psychic", power = 5, interval = 35000},
    {name = "Stored Power", power = 5, interval = 50000},
    {name = "Moonblast", power = 5, interval = 40000},
    {name = "Shadow Down", power = 5, interval = 50000},
}



pokemon.attacks = {
    {name = "Psy Ball", power = 5, interval = 20000, chance = 100},
    {name = "Psy Pulse", power = 5, interval = 18000, chance = 100},
    {name = "Dazzling Gleam", power = 5, interval = 20000, chance = 100},
    {name = "Synchronoise", power = 5, interval = 40000, chance = 100},
    {name = "Heart Pound", power = 5, interval = 40000, chance = 100},
    {name = "Psychic", power = 5, interval = 35000, chance = 100},
    {name = "Stored Power", power = 5, interval = 50000, chance = 100},
    {name = "Moonblast", power = 5, interval = 40000, chance = 100},
    {name = "Shadow Down", power = 5, interval = 50000, chance = 100},
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
