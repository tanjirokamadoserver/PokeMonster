
local mType = Game.createMonsterType("Furious Ampharos")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Ampharos"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 832
}

pokemon.health = 18556
pokemon.maxHealth = pokemon.health
pokemon.race = "electric"
pokemon.race2 = "none"
pokemon.corpse = 27042
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
    moveMagicDefenseBase = 155,
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
{id = "screw", chance = 8000000, maxCount = 13},
{id = "electric box", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Defense curl", power = 5, interval = 40000},
    {name = "Swift", power = 5, interval = 15000},
    {name = "Thunder Punch", power = 5, interval = 25000},
    {name = "Thunderbolt", power = 5, interval = 20000},
    {name = "Thunder Wrath", power = 5, interval = 45000},
    {name = "Electro Field", power = 5, interval = 60000},
    {name = "Electric Storm", power = 5, interval = 60000},
    {name = "Protect", power = 5, interval = 50000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Defense curl", power = 5, interval = 40000, chance = 100},
    {name = "Swift", power = 5, interval = 15000, chance = 100},
    {name = "Thunder Punch", power = 5, interval = 25000, chance = 100},
    {name = "Thunderbolt", power = 5, interval = 20000, chance = 100},
    {name = "Thunder Wrath", power = 5, interval = 45000, chance = 100},
    {name = "Electro Field", power = 5, interval = 60000, chance = 100},
    {name = "Electric Storm", power = 5, interval = 60000, chance = 100},
    {name = "Protect", power = 5, interval = 50000, chance = 100},
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
