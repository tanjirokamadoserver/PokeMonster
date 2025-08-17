
local mType = Game.createMonsterType("Iron Steelix")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Steelix"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 884
}

pokemon.health = 18556
pokemon.maxHealth = pokemon.health
pokemon.race = "steel"
pokemon.race2 = "ground"
pokemon.corpse = 27069
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
    moveMagicAttackBase = 140,
    moveMagicDefenseBase = 163,
    catchChance = 0,
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
{id = "piece of steel", chance = 8000000, maxCount = 13},
{id = "earth ball", chance = 8000000, maxCount = 13},
{id = "sandbag", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Iron Tail", power = 5, interval = 10000},
    {name = "Iron Head", power = 5, interval = 15000},
    {name = "Sand Tomb", power = 5, interval = 45000},
    {name = "Rock Tomb", power = 5, interval = 20000},
    {name = "Stone Edge", power = 5, interval = 15000},
    {name = "Earth Power", power = 5, interval = 40000},
    {name = "Sand Eruption", power = 5, interval = 60000},
    {name = "Fissure", power = 5, interval = 60000},
    {name = "Harden", power = 5, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Iron Tail", power = 5, interval = 10000, chance = 100},
    {name = "Iron Head", power = 5, interval = 15000, chance = 100},
    {name = "Sand Tomb", power = 5, interval = 45000, chance = 100},
    {name = "Rock Tomb", power = 5, interval = 20000, chance = 100},
    {name = "Stone Edge", power = 5, interval = 15000, chance = 100},
    {name = "Earth Power", power = 5, interval = 40000, chance = 100},
    {name = "Sand Eruption", power = 5, interval = 60000, chance = 100},
    {name = "Fissure", power = 5, interval = 60000, chance = 100},
    {name = "Harden", power = 5, interval = 40000, chance = 100},
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
