
local mType = Game.createMonsterType("Shiny Murkrow")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Murkrow"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1014
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "dark"
pokemon.race2 = "flying"
pokemon.corpse = 28167
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
{id = "dark gem", chance = 8000000, maxCount = 13},
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Peck", power = 5, interval = 15000},
    {name = "Pursuit", power = 5, interval = 10000},
    {name = "Flatter", power = 5, interval = 35000},
    {name = "Wing Attack", power = 5, interval = 25000},
    {name = "Sucker Punch", power = 5, interval = 45000},
    {name = "Tailwind", power = 5, interval = 40000},
    {name = "Dark Pulse", power = 5, interval = 20000},
    {name = "Torment", power = 5, interval = 60000},
}



pokemon.attacks = {
    {name = "Peck", power = 5, interval = 15000, chance = 100},
    {name = "Pursuit", power = 5, interval = 10000, chance = 100},
    {name = "Flatter", power = 5, interval = 35000, chance = 100},
    {name = "Wing Attack", power = 5, interval = 25000, chance = 100},
    {name = "Sucker Punch", power = 5, interval = 45000, chance = 100},
    {name = "Tailwind", power = 5, interval = 40000, chance = 100},
    {name = "Dark Pulse", power = 5, interval = 20000, chance = 100},
    {name = "Torment", power = 5, interval = 60000, chance = 100},
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
