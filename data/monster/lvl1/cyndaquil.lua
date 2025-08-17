
local mType = Game.createMonsterType("Cyndaquil")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Cyndaquil"
pokemon.experience = 737
pokemon.outfit = {
    lookType = 803
}

pokemon.health = 928
pokemon.maxHealth = pokemon.health
pokemon.race = "fire"
pokemon.race2 = "none"
pokemon.corpse = 27016
pokemon.speed = 180
pokemon.maxSummons = 0


pokemon.changeTarget = {
    interval = 4*1000,
    chance = 20
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
    moveMagicAttackBase = 20,
    moveMagicDefenseBase = 7,
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
{id = "essence of fire", chance = 8000000, maxCount = 13},
{id = "pot of lava", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Quick Attack", power = 2, interval = 15000}, -- ok
    {name = "Swift", power = 2, interval = 12000}, -- 0k
    {name = "Ember", power = 2, interval = 10000},
    {name = "Flamethrower", power = 3, interval = 18000},
    {name = "Smokescreen", power = 1, interval = 28000},
    {name = "Overheat", power = 5, interval = 60000},
    {name = "Defense Curl", power = 0, interval = 30000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Quick Attack", power = 1, interval = 15000, chance = 100},
    {name = "Swift", power = 1, interval = 12000, chance = 100},
    {name = "Ember", power = 1, interval = 10000, chance = 100},
    {name = "Flamethrower", power = 1, interval = 18000, chance = 100},
    {name = "Smokescreen", power = 1, interval = 28000, chance = 100},
    {name = "Overheat", power = 1, interval = 60000, chance = 100},
    {name = "Defense Curl", power = 1, interval = 30000, chance = 100},
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
