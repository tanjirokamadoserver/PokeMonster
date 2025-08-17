
local mType = Game.createMonsterType("Cloyster")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Cloyster"
pokemon.experience = 1235
pokemon.outfit = {
    lookType = 91
}

pokemon.health = 7640
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "ice"
pokemon.corpse = 26952
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
    minimumLevel = 60,
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
    moveMagicAttackBase = 105,
    moveMagicDefenseBase = 75,
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
{id = "snow ball", chance = 8000000, maxCount = 13},
{id = "ice orb", chance = 3250000, maxCount = 1},
{id = "ice stone", chance = 150000, maxCount = 1},
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Lick", power = 7, interval = 30000},
    {name = "Super Sonic", power = 7, interval = 35000},
    {name = "Clamp", power = 7, interval = 10000},
    {name = "Bubbles", power = 7, interval = 10000},
    {name = "Ice Beam", power = 12, interval = 20000},
    {name = "Aurora Beam", power = 7, interval = 60000},
    {name = "Blizzard", power = 25, interval = 90000},
    {name = "Harden", power = 0, interval = 30000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Lick", power = 7, interval = 30000, chance = 100},
    {name = "Super Sonic", power = 7, interval = 35000, chance = 100},
    {name = "Clamp", power = 7, interval = 10000, chance = 100},
    {name = "Bubbles", power = 7, interval = 10000, chance = 100},
    {name = "Ice Beam", power = 12, interval = 20000, chance = 100},
    {name = "Aurora Beam", power = 7, interval = 60000, chance = 100},
    {name = "Blizzard", power = 25, interval = 90000, chance = 100},
    {name = "Harden", power = 0, interval = 30000, chance = 100},
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
