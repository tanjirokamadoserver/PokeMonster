
local mType = Game.createMonsterType("Yanma")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Yanma"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 844
}

pokemon.health = 7482
pokemon.maxHealth = pokemon.health
pokemon.race = "bug"
pokemon.race2 = "flying"
pokemon.corpse = 27054
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
{id = "bug gosme", chance = 8000000, maxCount = 13},
{id = "pot of moss bug", chance = 3250000, maxCount = 1},
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Super Sonic", power = 7, interval = 35000},
    {name = "Tackle", power = 7, interval = 15000},
    {name = "Quick Attack", power = 7, interval = 15000},
    {name = "U-Turn", power = 15, interval = 15000},
    {name = "Double Team", power = 7, interval = 50000},
    {name = "Wing Attack", power = 15, interval = 35000},
    {name = "Air Slash", power = 12, interval = 45000},
    {name = "Bug Buzz", power = 7, interval = 50000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Super Sonic", power = 7, interval = 35000, chance = 100},
    {name = "Tackle", power = 7, interval = 15000, chance = 100},
    {name = "Quick Attack", power = 7, interval = 15000, chance = 100},
    {name = "U-Turn", power = 15, interval = 15000, chance = 100},
    {name = "Double Team", power = 7, interval = 50000, chance = 100},
    {name = "Wing Attack", power = 15, interval = 35000, chance = 100},
    {name = "Air Slash", power = 12, interval = 45000, chance = 100},
    {name = "Bug Buzz", power = 7, interval = 50000, chance = 100},
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
