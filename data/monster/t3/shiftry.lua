
local mType = Game.createMonsterType("Shiftry")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiftry"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 1523
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "dark"
pokemon.corpse = 27847
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
{id = "dark gem", chance = 8000000, maxCount = 13},
{id = "darkness stone", chance = 150000, maxCount = 1},
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
{id = "leaf stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Shadow Ball", power = 7, interval = 10000, level = 50},
    {name = "Knock Off", power = 7, interval = 20000},
    {name = "Sucker Punch", power = 15, interval = 15000},
    {name = "Beat Up", power = 9, interval = 10000},
    {name = "Leaf Blade", power = 10, interval = 25000},
    {name = "Payback", power = 25, interval = 60000},
    {name = "Solar Blade", power = 26, interval = 70000},
    {name = "Sunny Day", power = 7, interval = 30000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Shadow Ball", power = 7, interval = 10000, chance = 100},
    {name = "Knock Off", power = 7, interval = 20000, chance = 100},
    {name = "Sucker Punch", power = 15, interval = 15000, chance = 100},
    {name = "Beat Up", power = 9, interval = 10000, chance = 100},
    {name = "Leaf Blade", power = 10, interval = 25000, chance = 100},
    {name = "Payback", power = 25, interval = 60000, chance = 100},
    {name = "Solar Blade", power = 26, interval = 70000, chance = 100},
    {name = "Sunny Day", power = 7, interval = 30000, chance = 100},
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
