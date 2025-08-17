
local mType = Game.createMonsterType("Kyogre")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Kyogre"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1630
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "none"
pokemon.corpse = 27954
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
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 1, interval = 2000},
    {name = "Aqua Tail", power = 1, interval = 10000},
    {name = "Water Pulse", power = 1, interval = 12000},
    {name = "Ice Beam", power = 1, interval = 15000},
    {name = "Body Slam", power = 1, interval = 15000},
    {name = "Ancient Power", power = 1, interval = 22000},
    {name = "Surf", power = 1, interval = 30000},
    {name = "Water Spout", power = 1, interval = 50000},
    {name = "Hydro Pump", power = 1, interval = 40000},
    {name = "Sheer Cold", power = 1, interval = 45000},
    {name = "Origin Pulse", power = 1, interval = 60000},
    {name = "Calm Mind", power = 1, interval = 30000},
    {name = "Scary Face", power = 1, interval = 20000},
    {name = "Aqua Ring", power = 1, interval = 45000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Aqua Tail", power = 1, interval = 10000, chance = 100},
    {name = "Water Pulse", power = 1, interval = 12000, chance = 100},
    {name = "Ice Beam", power = 1, interval = 15000, chance = 100},
    {name = "Body Slam", power = 1, interval = 15000, chance = 100},
    {name = "Ancient Power", power = 1, interval = 22000, chance = 100},
    {name = "Surf", power = 1, interval = 30000, chance = 100},
    {name = "Water Spout", power = 1, interval = 50000, chance = 100},
    {name = "Hydro Pump", power = 1, interval = 40000, chance = 100},
    {name = "Sheer Cold", power = 1, interval = 45000, chance = 100},
    {name = "Origin Pulse", power = 1, interval = 60000, chance = 100},
    {name = "Calm Mind", power = 1, interval = 30000, chance = 100},
    {name = "Scary Face", power = 1, interval = 20000, chance = 100},
    {name = "Aqua Ring", power = 1, interval = 45000, chance = 100},
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
