
local mType = Game.createMonsterType("Grimer")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Grimer"
pokemon.experience = 103
pokemon.outfit = {
    lookType = 88
}

pokemon.health = 932
pokemon.maxHealth = pokemon.health
pokemon.race = "poison"
pokemon.race2 = "none"
pokemon.corpse = 26949
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
    minimumLevel = 10,
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
    moveMagicAttackBase = 15,
    moveMagicDefenseBase = 10,
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
{id = "bottle of poison", chance = 8000000, maxCount = 13},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Mud Shot", power = 9, interval = 20000},
    {name = "Acid", power = 7, interval = 10000},
    {name = "Sludge", power = 7, interval = 15000},
    {name = "Mud Bomb", power = 7, interval = 25000},
    {name = "Poison Bomb", power = 7, interval = 28000},
    {name = "Harden", power = 0, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Mud Shot", power = 9, interval = 20000, chance = 100},
    {name = "Acid", power = 7, interval = 10000, chance = 100},
    {name = "Sludge", power = 7, interval = 15000, chance = 100},
    {name = "Mud Bomb", power = 7, interval = 25000, chance = 100},
    {name = "Poison Bomb", power = 7, interval = 28000, chance = 100},
    {name = "Harden", power = 0, interval = 40000, chance = 100},
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
