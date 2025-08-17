
local mType = Game.createMonsterType("Natu")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Natu"
pokemon.experience = 407211
pokemon.outfit = {
    lookType = 828
}

pokemon.health = 1937
pokemon.maxHealth = pokemon.health
pokemon.race = "psychic"
pokemon.race2 = "flying"
pokemon.corpse = 27038
pokemon.speed = 180
pokemon.maxSummons = 0

pokemon.changeTarget = {
    interval = 4*1000,
    chance = 20
}
pokemon.wild = {
    health = pokemon.health * 1.4,
    maxHealth = pokemon.health * 1.4,
    speed = 220
}

pokemon.flags = {
    minimumLevel = 30,
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
    moveMagicAttackBase = 45,
    moveMagicDefenseBase = 35,
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
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Peck", power = 7, interval = 15000},
    {name = "Feather Dance", power = 12, interval = 10000},
    {name = "Confuse Ray", power = 7, interval = 32000},
    {name = "Psy Pulse", power = 12, interval = 15000},
    {name = "Night Shade", power = 7, interval = 25000},
    {name = "Psychic", power = 12, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Peck", power = 7, interval = 15000, chance = 100},
    {name = "Feather Dance", power = 12, interval = 10000, chance = 100},
    {name = "Confuse Ray", power = 7, interval = 32000, chance = 100},
    {name = "Psy Pulse", power = 12, interval = 15000, chance = 100},
    {name = "Night Shade", power = 7, interval = 25000, chance = 100},
    {name = "Psychic", power = 12, interval = 40000, chance = 100},
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
