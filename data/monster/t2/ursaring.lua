
local mType = Game.createMonsterType("Ursaring")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Ursaring"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 893
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "normal"
pokemon.race2 = "none"
pokemon.corpse = 27078
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
    minimumLevel = 100,
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
    moveMagicAttackBase = 160,
    moveMagicDefenseBase = 130,
    catchChance = 250,
    canControlMind = 0,
    canLevitate = 0,
    canLight = 0,
    canCut = 0,
    canSmash = 0,
    canDig = 0,
    canTeleport = 0,
    canBlink = 0,
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
{id = "bitten apple", chance = 3250000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Scratch", power = 7, interval = 10000},
    {name = "Slash", power = 9, interval = 15000},
    {name = "Hammer Arm", power = 17, interval = 30000},
    {name = "Fury Swipes", power = 12, interval = 20000},
    {name = "Secret Power", power = 7, interval = 50000},
    {name = "Focus Blast", power = 12, interval = 50000},
    {name = "Hyper Beam", power = 15, interval = 50000},
    {name = "Magnitude", power = 15, interval = 60000},
    {name = "Fake Tears", power = 7, interval = 60000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Scratch", power = 7, interval = 10000, chance = 100},
    {name = "Slash", power = 9, interval = 15000, chance = 100},
    {name = "Hammer Arm", power = 17, interval = 30000, chance = 100},
    {name = "Fury Swipes", power = 12, interval = 20000, chance = 100},
    {name = "Secret Power", power = 7, interval = 50000, chance = 100},
    {name = "Focus Blast", power = 12, interval = 50000, chance = 100},
    {name = "Hyper Beam", power = 15, interval = 50000, chance = 100},
    {name = "Magnitude", power = 15, interval = 60000, chance = 100},
    {name = "Fake Tears", power = 7, interval = 60000, chance = 100},
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
