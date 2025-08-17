
local mType = Game.createMonsterType("Wartortle")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Wartortle"
pokemon.experience = 625
pokemon.outfit = {
    lookType = 8
}

pokemon.health = 2897
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "none"
pokemon.corpse = 26869
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
    minimumLevel = 40,
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
    moveMagicAttackBase = 65,
    moveMagicDefenseBase = 55,
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
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Headbutt", power = 10, interval = 15000},
    {name = "Bubbles", power = 7, interval = 10000},
    {name = "Water Gun", power = 8, interval = 20000},
    {name = "Water Ball", power = 8, interval = 25000},
    {name = "Aqua Tail", power = 8, interval = 15000},
    {name = "Brine", power = 15, interval = 35000},
    {name = "Hydro Cannon", power = 15, interval = 60000},
    {name = "Skull Bash", power = 7, interval = 35000},
    {name = "Harden", power = 0, interval = 30000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Headbutt", power = 10, interval = 15000, chance = 100},
    {name = "Bubbles", power = 7, interval = 10000, chance = 100},
    {name = "Water Gun", power = 8, interval = 20000, chance = 100},
    {name = "Water Ball", power = 8, interval = 25000, chance = 100},
    {name = "Aqua Tail", power = 8, interval = 15000, chance = 100},
    {name = "Brine", power = 15, interval = 35000, chance = 100},
    {name = "Hydro Cannon", power = 15, interval = 60000, chance = 100},
    {name = "Skull Bash", power = 7, interval = 35000, chance = 100},
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
