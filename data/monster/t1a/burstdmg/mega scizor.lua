
local mType = Game.createMonsterType("Mega Scizor")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Scizor"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 1001
}

pokemon.health = 24379
pokemon.maxHealth = pokemon.health
pokemon.race = "rock"
pokemon.race2 = "none"
pokemon.corpse = 27073
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
{id = "small stone", chance = 8000000, maxCount = 13},
{id = "stone orb", chance = 3250000, maxCount = 1},
{id = "rock stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Mimic", power = 5, interval = 30000},
    {name = "Rock Throw", power = 5, interval = 10000},
    {name = "Rock Tomb", power = 5, interval = 15000},
    {name = "Stone Edge", power = 5, interval = 20000},
    {name = "Wood Hammer", power = 5, interval = 20000},
    {name = "Head Smash", power = 5, interval = 30000},
    {name = "Hammer Arm", power = 5, interval = 35000},
    {name = "Rock Wrecker", power = 5, interval = 60000},
    {name = "Fake Tears", power = 5, interval = 50000},
    {name = "Stealth Rock", power = 5, interval = 80000},
    {name = "Block", power = 5, interval = 60000},
}



pokemon.attacks = {
    {name = "Mimic", power = 5, interval = 30000, chance = 100},
    {name = "Rock Throw", power = 5, interval = 10000, chance = 100},
    {name = "Rock Tomb", power = 5, interval = 15000, chance = 100},
    {name = "Stone Edge", power = 5, interval = 20000, chance = 100},
    {name = "Wood Hammer", power = 5, interval = 20000, chance = 100},
    {name = "Head Smash", power = 5, interval = 30000, chance = 100},
    {name = "Hammer Arm", power = 5, interval = 35000, chance = 100},
    {name = "Rock Wrecker", power = 5, interval = 60000, chance = 100},
    {name = "Fake Tears", power = 5, interval = 50000, chance = 100},
    {name = "Stealth Rock", power = 5, interval = 80000, chance = 100},
    {name = "Block", power = 5, interval = 60000, chance = 100},
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
