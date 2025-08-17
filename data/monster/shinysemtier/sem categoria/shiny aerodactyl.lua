
local mType = Game.createMonsterType("Aerodactyl")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Aerodactyl"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 360
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "rock"
pokemon.race2 = "flying"
pokemon.corpse = 27624
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
{id = "small stone", chance = 8000000, maxCount = 13},
{id = "stone orb", chance = 3250000, maxCount = 1},
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Roar", power = 5, interval = 30000},
    {name = "Super Sonic", power = 5, interval = 40000},
    {name = "Bite", power = 5, interval = 5000},
    {name = "Pluck", power = 5, interval = 10000},
    {name = "Rock Throw", power = 5, interval = 10000},
    {name = "Rock Slide", power = 5, interval = 15000},
    {name = "Air Cutter", power = 5, interval = 25000},
    {name = "Wing Attack", power = 5, interval = 25000},
    {name = "Falling Rocks", power = 5, interval = 60000},
    {name = "Hyper Beam", power = 5, interval = 45000},
    {name = "Ancient Power", power = 5, interval = 50000},
}



pokemon.attacks = {
    {name = "Roar", power = 5, interval = 30000, chance = 100},
    {name = "Super Sonic", power = 5, interval = 40000, chance = 100},
    {name = "Bite", power = 5, interval = 5000, chance = 100},
    {name = "Pluck", power = 5, interval = 10000, chance = 100},
    {name = "Rock Throw", power = 5, interval = 10000, chance = 100},
    {name = "Rock Slide", power = 5, interval = 15000, chance = 100},
    {name = "Air Cutter", power = 5, interval = 25000, chance = 100},
    {name = "Wing Attack", power = 5, interval = 25000, chance = 100},
    {name = "Falling Rocks", power = 5, interval = 60000, chance = 100},
    {name = "Hyper Beam", power = 5, interval = 45000, chance = 100},
    {name = "Ancient Power", power = 5, interval = 50000, chance = 100},
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
