
local mType = Game.createMonsterType("Deoxys")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Deoxys"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1634
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "none"
pokemon.race2 = "none"
pokemon.corpse = 27958
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

pokemon.loot = {}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Rock Slide", power = 15, interval = 15000},
    {name = "Bubbles", power = 7, interval = 8000},
    {name = "Ember", power = 10, interval = 8000},
    {name = "Sludge", power = 7, interval = 15000},
    {name = "Razor Leaf", power = 7, interval = 10000},
    {name = "Thunderbolt", power = 9, interval = 20000},
    {name = "Swift", power = 7, interval = 13000},
    {name = "Shadow Ball", power = 7, interval = 5000},
    {name = "Psy Ball", power = 7, interval = 12000},
    {name = "Mud Sport", power = 7, interval = 22000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Rock Slide", power = 15, interval = 15000, chance = 100},
    {name = "Bubbles", power = 7, interval = 8000, chance = 100},
    {name = "Ember", power = 10, interval = 8000, chance = 100},
    {name = "Sludge", power = 7, interval = 15000, chance = 100},
    {name = "Razor Leaf", power = 7, interval = 10000, chance = 100},
    {name = "Thunderbolt", power = 9, interval = 20000, chance = 100},
    {name = "Swift", power = 7, interval = 13000, chance = 100},
    {name = "Shadow Ball", power = 7, interval = 5000, chance = 100},
    {name = "Psy Ball", power = 7, interval = 12000, chance = 100},
    {name = "Mud Sport", power = 7, interval = 22000, chance = 100},
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
