
local mType = Game.createMonsterType("Magneton")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Magneton"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 82
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "electric"
pokemon.race2 = "steel"
pokemon.corpse = 26943
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
    minimumLevel = 80,
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
    moveMagicAttackBase = 165,
    moveMagicDefenseBase = 115,
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
{id = "piece of steel", chance = 8000000, maxCount = 13},
{id = "metal stone", chance = 150000, maxCount = 1},
{id = "screw", chance = 8000000, maxCount = 13},
{id = "electric box", chance = 3250000, maxCount = 1},
{id = "thunder stone", chance = 150000, maxCount = 1}
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Iron Spiner", power = 7, interval = 15000},
    {name = "Thunder Shock", power = 9, interval = 10000},
    {name = "Scrap Throw", power = 12, interval = 15000},
    {name = "Tri-Attack", power = 15, interval = 30000},
    {name = "Gyro Ball", power = 25, interval = 40000},
    {name = "Magnet Pull", power = 20, interval = 40000},
    {name = "Heavy Metal", power = 30, interval = 50000},
    {name = "Gravity", power = 0, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Iron Spiner", power = 7, interval = 15000, chance = 100},
    {name = "Thunder Shock", power = 9, interval = 10000, chance = 100},
    {name = "Scrap Throw", power = 12, interval = 15000, chance = 100},
    {name = "Tri-Attack", power = 15, interval = 30000, chance = 100},
    {name = "Gyro Ball", power = 25, interval = 40000, chance = 100},
    {name = "Magnet Pull", power = 20, interval = 40000, chance = 100},
    {name = "Heavy Metal", power = 30, interval = 50000, chance = 100},
    {name = "Gravity", power = 7, interval = 40000, chance = 100},
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
