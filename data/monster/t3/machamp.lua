
local mType = Game.createMonsterType("Machamp")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Machamp"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 68
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "fighting"
pokemon.race2 = "none"
pokemon.corpse = 26929
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
    minimumLevel = 80,
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
    moveMagicAttackBase = 165,
    moveMagicDefenseBase = 115,
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
{id = "band aid", chance = 8000000, maxCount = 13},
{id = "punch stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Triple Punch", power = 7, interval = 10000},
    {name = "Karate Chop", power = 7, interval = 15000},
    {name = "Low Kick", power = 10, interval = 15000},
    {name = "Focus Blast", power = 12, interval = 50000},
    {name = "Arm Thrust", power = 15, interval = 40000},
    {name = "Vacuum Wave", power = 25, interval = 45000},
    {name = "Dynamic Punch", power = 15, interval = 50000},
    {name = "Agility", power = 0, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Triple Punch", power = 7, interval = 10000, chance = 100},
    {name = "Karate Chop", power = 7, interval = 15000, chance = 100},
    {name = "Low Kick", power = 10, interval = 15000, chance = 100},
    {name = "Focus Blast", power = 12, interval = 50000, chance = 100},
    {name = "Arm Thrust", power = 15, interval = 40000, chance = 100},
    {name = "Vacuum Wave", power = 25, interval = 45000, chance = 100},
    {name = "Dynamic Punch", power = 15, interval = 50000, chance = 100},
    {name = "Agility", power = 0, interval = 40000, chance = 100},
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
