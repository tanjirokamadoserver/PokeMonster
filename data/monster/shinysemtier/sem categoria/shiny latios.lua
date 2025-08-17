
local mType = Game.createMonsterType("Latios")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Latios"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1629
}

pokemon.health = 5000
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
{id = "dragon scale", chance = 8000000, maxCount = 13},
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Psychock", power = 5, interval = 30000},
    {name = "Psywave", power = 5, interval = 15000},
    {name = "Ice Beam", power = 5, interval = 20000},
    {name = "Charge Beam", power = 5, interval = 30000},
    {name = "Dragon Flight", power = 5, interval = 22000},
    {name = "Dragon Breath", power = 5, interval = 25000},
    {name = "Twister", power = 5, interval = 35000},
    {name = "Luster Purge", power = 5, interval = 50000},
    {name = "Dragon Pulse", power = 5, interval = 40000},
    {name = "Draco Meteor", power = 5, interval = 80000},
    {name = "Safeguard", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "Psychock", power = 5, interval = 30000, chance = 100},
    {name = "Psywave", power = 5, interval = 15000, chance = 100},
    {name = "Ice Beam", power = 5, interval = 20000, chance = 100},
    {name = "Charge Beam", power = 5, interval = 30000, chance = 100},
    {name = "Dragon Flight", power = 5, interval = 22000, chance = 100},
    {name = "Dragon Breath", power = 5, interval = 25000, chance = 100},
    {name = "Twister", power = 5, interval = 35000, chance = 100},
    {name = "Luster Purge", power = 5, interval = 50000, chance = 100},
    {name = "Dragon Pulse", power = 5, interval = 40000, chance = 100},
    {name = "Draco Meteor", power = 5, interval = 80000, chance = 100},
    {name = "Safeguard", power = 5, interval = 40000, chance = 100},
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
