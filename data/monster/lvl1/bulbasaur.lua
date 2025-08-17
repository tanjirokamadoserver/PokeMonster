
local mType = Game.createMonsterType("Bulbasaur")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Bulbasaur"
pokemon.experience = 57
pokemon.outfit = {
    lookType = 1
}

pokemon.health = 456
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "poison"
pokemon.corpse = 26862
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
    minimumLevel = 1,
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
    moveMagicAttackBase = 15,
    moveMagicDefenseBase = 5,
    catchChance = 400,
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
{id = "bottle of poison", chance = 8000000, maxCount = 13},
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Tackle", power = 7, interval = 12000},
    {name = "Razor Leaf", power = 7, interval = 10000},
    {name = "Vine Whip", power = 9, interval = 18000},
    {name = "Grass Knot", power = 7, interval = 20000},
    {name = "Leech Seed", power = 15, interval = 20000},
    {name = "Solar Beam", power = 15, interval = 60000},
    {name = "Stun Spore", power = 7, interval = 40000},
    {name = "Poison Powder", power = 7, interval = 20000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Tackle", power = 7, interval = 12000, chance = 100},
    {name = "Razor Leaf", power = 7, interval = 10000, chance = 100},
    {name = "Vine Whip", power = 9, interval = 18000, chance = 100},
    {name = "Grass Knot", power = 7, interval = 20000, chance = 100},
    {name = "Leech Seed", power = 15, interval = 20000, chance = 100},
    {name = "Solar Beam", power = 15, interval = 60000, chance = 100},
    {name = "Stun Spore", power = 7, interval = 40000, chance = 100},
    {name = "Poison Powder", power = 7, interval = 20000, chance = 100},
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
