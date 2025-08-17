
local mType = Game.createMonsterType("Beautifly")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Beautifly"
pokemon.experience = 1454
pokemon.outfit = {
    lookType = 1515
}

pokemon.health = 4640
pokemon.maxHealth = pokemon.health
pokemon.race = "bug"
pokemon.race2 = "flying"
pokemon.corpse = 27839
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
    minimumLevel = 50,
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
    moveMagicAttackBase = 85,
    moveMagicDefenseBase = 65,
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
{id = "cocoon stone", chance = 150000, maxCount = 1},
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
{id = "feather stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Struggle Bug", power = 7, interval = 15000},
    {name = "Bug Bite", power = 9, interval = 10000},
    {name = "Silver Wind", power = 15, interval = 10000},
    {name = "U-Turn", power = 15, interval = 15000},
    {name = "Aerial Ace", power = 7, interval = 60000},
    {name = "Infestation", power = 7, interval = 60000},
    {name = "Morning Sun", power = 25, interval = 100000},
    {name = "Quiver Dance", power = 7, interval = 70000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Struggle Bug", power = 7, interval = 15000, chance = 100},
    {name = "Bug Bite", power = 9, interval = 10000, chance = 100},
    {name = "Silver Wind", power = 15, interval = 10000, chance = 100},
    {name = "U-Turn", power = 15, interval = 15000, chance = 100},
    {name = "Aerial Ace", power = 7, interval = 60000, chance = 100},
    {name = "Infestation", power = 7, interval = 60000, chance = 100},
    {name = "Morning Sun", power = 25, interval = 100000, chance = 100},
    {name = "Quiver Dance", power = 7, interval = 70000, chance = 100},
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
