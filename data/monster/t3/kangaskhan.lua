
local mType = Game.createMonsterType("Kangaskhan")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Kangaskhan"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 115
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "normal"
pokemon.race2 = "none"
pokemon.corpse = 26976
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
{id = "bitten apple", chance = 3250000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Bite", power = 9, interval = 10000},
    {name = "Dizzy Punch", power = 7, interval = 30000},
    {name = "Headbutt", power = 10, interval = 15000},
    {name = "Mega Punch", power = 12, interval = 25000},
    {name = "Crunch", power = 9, interval = 15000},
    {name = "Sucker Punch", power = 15, interval = 30000},
    {name = "Comet Punch", power = 20, interval = 35000},
    {name = "Epicenter", power = 25, interval = 70000},
    {name = "Rage", power = 7, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Bite", power = 9, interval = 10000, chance = 100},
    {name = "Dizzy Punch", power = 7, interval = 30000, chance = 100},
    {name = "Headbutt", power = 10, interval = 15000, chance = 100},
    {name = "Mega Punch", power = 12, interval = 25000, chance = 100},
    {name = "Crunch", power = 9, interval = 15000, chance = 100},
    {name = "Sucker Punch", power = 15, interval = 30000, chance = 100},
    {name = "Comet Punch", power = 20, interval = 35000, chance = 100},
    {name = "Epicenter", power = 25, interval = 70000, chance = 100},
    {name = "Rage", power = 7, interval = 40000, chance = 100},
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
