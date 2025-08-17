
local mType = Game.createMonsterType("Magcargo")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Magcargo"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 895
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "fire"
pokemon.race2 = "rock"
pokemon.corpse = 27080
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
{id = "small stone", chance = 8000000, maxCount = 13},
{id = "stone orb", chance = 3250000, maxCount = 1},
{id = "rock stone", chance = 150000, maxCount = 1},
{id = "essence of fire", chance = 8000000, maxCount = 13},
{id = "pot of lava", chance = 3250000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Ember", power = 10, interval = 10000},
    {name = "Rock Throw", power = 12, interval = 10000},
    {name = "Rock Slide", power = 15, interval = 15000},
    {name = "Flamethrower", power = 10, interval = 25000},
    {name = "Flame Burst", power = 10, interval = 25000},
    {name = "Incinerate", power = 12, interval = 25000},
    {name = "Fire Blast", power = 18, interval = 50000},
    {name = "Inferno", power = 25, interval = 80000},
    {name = "Harden", power = 0, interval = 35000},
    {name = "Sunny Day", power = 7, interval = 60000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Ember", power = 10, interval = 10000, chance = 100},
    {name = "Rock Throw", power = 12, interval = 10000, chance = 100},
    {name = "Rock Slide", power = 15, interval = 15000, chance = 100},
    {name = "Flamethrower", power = 10, interval = 25000, chance = 100},
    {name = "Flame Burst", power = 15, interval = 25000, chance = 100},
    {name = "Incinerate", power = 12, interval = 25000, chance = 100},
    {name = "Fire Blast", power = 20, interval = 50000, chance = 100},
    {name = "Inferno", power = 25, interval = 80000, chance = 100},
    {name = "Harden", power = 0, interval = 35000, chance = 100},
    {name = "Sunny Day", power = 7, interval = 60000, chance = 100},
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
