
local mType = Game.createMonsterType("Gloom")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Gloom"
pokemon.experience = 958
pokemon.outfit = {
    lookType = 44
}

pokemon.health = 1871
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "poison"
pokemon.corpse = 26905
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
    passive = true,
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
{id = "bottle of poison", chance = 8000000, maxCount = 13},
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Absorb", power = 7, interval = 20000},
    {name = "Leech Seed", power = 15, interval = 15000},
    {name = "Acid", power = 7, interval = 8000},
    {name = "Poison Bomb", power = 7, interval = 25000},
    {name = "Poison Gas", power = 12, interval = 50000},
    {name = "Sleep Powder", power = 7, interval = 60000},
    {name = "Stun Spore", power = 7, interval = 40000},
    {name = "Poison Powder", power = 0.02, interval = 10000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Absorb", power = 7, interval = 20000, chance = 100},
    {name = "Leech Seed", power = 15, interval = 15000, chance = 100},
    {name = "Acid", power = 7, interval = 8000, chance = 100},
    {name = "Poison Bomb", power = 7, interval = 25000, chance = 100},
    {name = "Poison Gas", power = 12, interval = 50000, chance = 100},
    {name = "Sleep Powder", power = 7, interval = 60000, chance = 100},
    {name = "Stun Spore", power = 7, interval = 40000, chance = 100},
    {name = "Poison Powder", power = 7, interval = 10000, chance = 100},
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
