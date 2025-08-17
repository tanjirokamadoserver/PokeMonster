
local mType = Game.createMonsterType("Mew")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Mew"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 151
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "psychic"
pokemon.race2 = "none"
pokemon.corpse = 27012
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
    moveMagicAttackBase = 10,
    moveMagicDefenseBase = 15,
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
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 1, interval = 2000},
    {name = "Shadow Ball", power = 1, interval = 5000},
    {name = "Brine", power = 1, interval = 5000},
    {name = "Flamethrower", power = 1, interval = 5000},
    {name = "Thunderbolt", power = 1, interval = 5000},
    {name = "Psychic", power = 1, interval = 20000},
    {name = "Instant Teleportation", power = 1, interval = 10000},
    {name = "Hydro Cannon", power = 1, interval = 35000},
    {name = "Solar Beam", power = 1, interval = 35000},
    {name = "Ancient Power", power = 1, interval = 35000},
    {name = "Metronome", power = 1, interval = 35000},
    {name = "Barrier", power = 1, interval = 30000},
    {name = "Reflect", power = 1, interval = 10000},
    {name = "Recover", power = 1, interval = 60000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Shadow Ball", power = 1, interval = 5000, chance = 100},
    {name = "Brine", power = 1, interval = 5000, chance = 100},
    {name = "Flamethrower", power = 1, interval = 5000, chance = 100},
    {name = "Thunderbolt", power = 1, interval = 5000, chance = 100},
    {name = "Psychic", power = 1, interval = 20000, chance = 100},
    {name = "Instant Teleportation", power = 1, interval = 10000, chance = 100},
    {name = "Hydro Cannon", power = 1, interval = 35000, chance = 100},
    {name = "Solar Beam", power = 1, interval = 35000, chance = 100},
    {name = "Ancient Power", power = 1, interval = 35000, chance = 100},
    {name = "Metronome", power = 1, interval = 35000, chance = 100},
    {name = "Barrier", power = 1, interval = 30000, chance = 100},
    {name = "Reflect", power = 1, interval = 10000, chance = 100},
    {name = "Recover", power = 1, interval = 60000, chance = 100},
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
