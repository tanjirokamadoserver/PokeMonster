
local mType = Game.createMonsterType("Slaking")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Slaking"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 1537
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "normal"
pokemon.race2 = "none"
pokemon.corpse = 27861
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
    minimumLevel = 150,
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
    moveMagicAttackBase = 190,
    moveMagicDefenseBase = 150,
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
    {name = "Covet", power = 7, interval = 10000},
    {name = "Fury Swipes", power = 12, interval = 15000},
    {name = "Rock Tomb", power = 7, interval = 22000},
    {name = "Focus Punch", power = 7, interval = 30000},
    {name = "Focus Blast", power = 12, interval = 40000},
    {name = "Hammer Arm", power = 17, interval = 30000},
    {name = "Hyper Beam", power = 15, interval = 50000},
    {name = "Slack Off", power = 7, interval = 100000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Covet", power = 7, interval = 10000, chance = 100},
    {name = "Fury Swipes", power = 12, interval = 15000, chance = 100},
    {name = "Rock Tomb", power = 7, interval = 22000, chance = 100},
    {name = "Focus Punch", power = 7, interval = 30000, chance = 100},
    {name = "Focus Blast", power = 12, interval = 40000, chance = 100},
    {name = "Hammer Arm", power = 17, interval = 30000, chance = 100},
    {name = "Hyper Beam", power = 15, interval = 50000, chance = 100},
    {name = "Slack Off", power = 7, interval = 100000, chance = 100},
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
