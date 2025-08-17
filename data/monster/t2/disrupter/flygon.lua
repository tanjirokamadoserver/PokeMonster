
local mType = Game.createMonsterType("Flygon")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Flygon"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 1578
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "ground"
pokemon.race2 = "dragon"
pokemon.corpse = 27902
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
{id = "dragon scale", chance = 8000000, maxCount = 13},
{id = "crystal stone", chance = 150000, maxCount = 1},
{id = "earth ball", chance = 8000000, maxCount = 13},
{id = "sandbag", chance = 3250000, maxCount = 1},
{id = "earth stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Supersonic", power = 7, interval = 25000},
    {name = "Sand Attack", power = 7, interval = 10000},
    {name = "Sand Tomb", power = 7, interval = 40000},
    {name = "Dragon Flight", power = 7, interval = 20000},
    {name = "Bulldoze", power = 25, interval = 25000},
    {name = "Fissure", power = 15, interval = 45000},
    {name = "Hyper Beam", power = 15, interval = 60000},
    {name = "Earthquake", power = 7, interval = 60000},
    {name = "Sandstorm", power = 20, interval = 60000},
    {name = "Screech", power = 7, interval = 60000},
    {name = "Smack Down", power = 7, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Supersonic", power = 7, interval = 25000, chance = 100},
    {name = "Sand Attack", power = 7, interval = 10000, chance = 100},
    {name = "Sand Tomb", power = 7, interval = 40000, chance = 100},
    {name = "Dragon Flight", power = 7, interval = 20000, chance = 100},
    {name = "Bulldoze", power = 25, interval = 25000, chance = 100},
    {name = "Fissure", power = 15, interval = 45000, chance = 100},
    {name = "Hyper Beam", power = 15, interval = 60000, chance = 100},
    {name = "Earthquake", power = 7, interval = 60000, chance = 100},
    {name = "Sandstorm", power = 20, interval = 60000, chance = 100},
    {name = "Screech", power = 7, interval = 60000, chance = 100},
    {name = "Smack Down", power = 7, interval = 40000, chance = 100},
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
