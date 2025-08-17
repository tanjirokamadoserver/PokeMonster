
local mType = Game.createMonsterType("Entei")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Entei"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 920
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "fire"
pokemon.race2 = "none"
pokemon.corpse = 27105
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
{id = "essence of fire", chance = 8000000, maxCount = 13},
{id = "pot of lava", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 1, interval = 2000},
    {name = "Roar", power = 1, interval = 30000},
    {name = "Ember", power = 1, interval = 6000},
    {name = "Fire Ball", power = 1, interval = 9000},
    {name = "Incinerate", power = 1, interval = 8000},
    {name = "Sacred Fire", power = 1, interval = 29000},
    {name = "Flame Wheel", power = 1, interval = 20000},
    {name = "Flame Circle", power = 1, interval = 15000},
    {name = "Inferno", power = 1, interval = 26000},
    {name = "Magma Storm", power = 1, interval = 45000},
    {name = "Eruption", power = 1, interval = 43000},
    {name = "Extreme Speed", power = 1, interval = 5000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Roar", power = 1, interval = 30000, chance = 100},
    {name = "Ember", power = 1, interval = 6000, chance = 100},
    {name = "Fire Ball", power = 1, interval = 9000, chance = 100},
    {name = "Incinerate", power = 1, interval = 8000, chance = 100},
    {name = "Sacred Fire", power = 1, interval = 29000, chance = 100},
    {name = "Flame Wheel", power = 1, interval = 20000, chance = 100},
    {name = "Flame Circle", power = 1, interval = 15000, chance = 100},
    {name = "Inferno", power = 1, interval = 26000, chance = 100},
    {name = "Magma Storm", power = 1, interval = 45000, chance = 100},
    {name = "Eruption", power = 1, interval = 43000, chance = 100},
    {name = "Extreme Speed", power = 1, interval = 5000, chance = 100},
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
