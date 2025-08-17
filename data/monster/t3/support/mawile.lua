
local mType = Game.createMonsterType("Mawile")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Mawile"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 1551
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "steel"
pokemon.race2 = "fairy"
pokemon.corpse = 27875
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
    moveMagicAttackBase = 145,
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
{id = "rubber ball", chance = 8000000, maxCount = 13},
{id = "comb", chance = 1950000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
{id = "piece of steel", chance = 8000000, maxCount = 13},
{id = "metal stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Iron Head", power = 7, interval = 10000},
    {name = "Bite", power = 9, interval = 15000},
    {name = "Play Rough", power = 9, interval = 20000},
    {name = "Impale", power = 10, interval = 40000},
    {name = "Flash Cannon", power = 15, interval = 50000},
    {name = "Spit Up", power = 7, interval = 30000},
    {name = "Swallow", power = 20, interval = 150000},
    {name = "Stockpile", power = 0, interval = 5000},
    {name = "Fake Tears", power = 7, interval = 50000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Iron Head", power = 7, interval = 10000, chance = 100},
    {name = "Bite", power = 9, interval = 15000, chance = 100},
    {name = "Play Rough", power = 9, interval = 20000, chance = 100},
    {name = "Impale", power = 10, interval = 40000, chance = 100},
    {name = "Flash Cannon", power = 15, interval = 50000, chance = 100},
    {name = "Spit Up", power = 10, interval = 30000, chance = 100},
    {name = "Swallow", power = 20, interval = 150000, chance = 100},
    {name = "Stockpile", power = 0, interval = 5000, chance = 100},
    {name = "Fake Tears", power = 0, interval = 50000, chance = 100},
    {name = "Clear Pile", power = 0, interval = 50000, chance = 100},
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
