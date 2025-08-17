
local mType = Game.createMonsterType("Charizard")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Charizard"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 6
}

pokemon.health = 18796
pokemon.maxHealth = pokemon.health
pokemon.race = "fire"
pokemon.race2 = "flying"
pokemon.corpse = 26867
pokemon.speed = 220
pokemon.maxSummons = 0

pokemon.changeTarget = {
    interval = 1000,
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
    moveMagicAttackBase = 140,
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
    isSurfable = 1,
    isRideable = 0,
    isFlyable = 0,
    minimumLevel = 80,
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
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
{id = "feather stone", chance = 150000, maxCount = 1},
{id = "essence of fire", chance = 8000000, maxCount = 13},
{id = "pot of lava", chance = 3250000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Ember", power = 10, interval = 10000},
    {name = "Flamethrower", power = 10, interval = 20000},
    {name = "Fire Ball", power = 10, interval = 25000},
    {name = "Fire Punch", power = 7, interval = 20000},
    {name = "Flame Burst", power = 15, interval = 35000},
    {name = "Fire Blast", power = 20, interval = 60000},
    {name = "Air Slash", power = 12, interval = 35000},
    {name = "Wing Attack", power = 15, interval = 35000},
    {name = "Magma Storm", power = 25, interval = 60000},
    {name = "Sunny Day", power = 7, interval = 60000},
    {name = "Ancient Fury", power = 7, interval = 45000},
}

pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Ember", power = 10, interval = 10000, chance = 100},
    {name = "Flamethrower", power = 10, interval = 20000, chance = 100},
    {name = "Fire Ball", power = 10, interval = 25000, chance = 100},
    {name = "Fire Punch", power = 7, interval = 20000, chance = 100},
    {name = "Flame Burst", power = 15, interval = 35000, chance = 100},
    {name = "Fire Blast", power = 20, interval = 60000, chance = 100},
    {name = "Air Slash", power = 12, interval = 35000, chance = 100},
    {name = "Wing Attack", power = 15, interval = 35000, chance = 100},
    {name = "Magma Storm", power = 25, interval = 60000, chance = 100},
    {name = "Sunny Day", power = 7, interval = 60000, chance = 100},
    {name = "Ancient Fury", power = 7, interval = 45000, chance = 100},
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
