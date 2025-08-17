
local mType = Game.createMonsterType("Latios")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Latios"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1629
}

pokemon.health = 18545
pokemon.maxHealth = pokemon.health
pokemon.race = "dragon"
pokemon.race2 = "psychic"
pokemon.corpse = 27953
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
{id = "dragon scale", chance = 8000000, maxCount = 13},
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 1, interval = 2000},
    {name = "Psychock", power = 1, interval = 30000},
    {name = "Psywave", power = 1, interval = 15000},
    {name = "Ice Beam", power = 1, interval = 20000},
    {name = "Charge Beam", power = 1, interval = 30000},
    {name = "Dragon Flight", power = 1, interval = 22000},
    {name = "Dragon Breath", power = 1, interval = 25000},
    {name = "Twister", power = 1, interval = 35000},
    {name = "Luster Purge", power = 1, interval = 50000},
    {name = "Dragon Pulse", power = 1, interval = 40000},
    {name = "Draco Meteor", power = 1, interval = 80000},
    {name = "Safeguard", power = 1, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Psychock", power = 1, interval = 30000, chance = 100},
    {name = "Psywave", power = 1, interval = 15000, chance = 100},
    {name = "Ice Beam", power = 1, interval = 20000, chance = 100},
    {name = "Charge Beam", power = 1, interval = 30000, chance = 100},
    {name = "Dragon Flight", power = 1, interval = 22000, chance = 100},
    {name = "Dragon Breath", power = 1, interval = 25000, chance = 100},
    {name = "Twister", power = 1, interval = 35000, chance = 100},
    {name = "Luster Purge", power = 1, interval = 50000, chance = 100},
    {name = "Dragon Pulse", power = 1, interval = 40000, chance = 100},
    {name = "Draco Meteor", power = 1, interval = 80000, chance = 100},
    {name = "Safeguard", power = 1, interval = 40000, chance = 100},
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
