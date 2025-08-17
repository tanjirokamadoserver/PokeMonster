
local mType = Game.createMonsterType("Tyranitar")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Tyranitar"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 924
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "rock"
pokemon.race2 = "dark"
pokemon.corpse = 27109
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
    minimumLevel = 100,
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
    moveMagicAttackBase = 160,
    moveMagicDefenseBase = 130,
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
{id = "dark gem", chance = 8000000, maxCount = 13},
{id = "darkness stone", chance = 150000, maxCount = 1},
{id = "small stone", chance = 8000000, maxCount = 13},
{id = "stone orb", chance = 3250000, maxCount = 1},
{id = "rock stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Bite", power = 9, interval = 15000},
    {name = "Dragon Claw", power = 12, interval = 20000},
    {name = "Rock Tomb", power = 7, interval = 18000},
    {name = "Rock Slide", power = 15, interval = 15000},
    {name = "Stone Edge", power = 7, interval = 25000},
    {name = "Rock Blast", power = 15, interval = 50000},
    {name = "Ancient Power", power = 20, interval = 35000},
    {name = "Falling Rocks", power = 30, interval = 70000},
    {name = "Sandstorm", power = 20, interval = 45000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Bite", power = 9, interval = 15000, chance = 100},
    {name = "Dragon Claw", power = 12, interval = 20000, chance = 100},
    {name = "Rock Tomb", power = 7, interval = 18000, chance = 100},
    {name = "Rock Slide", power = 15, interval = 15000, chance = 100},
    {name = "Stone Edge", power = 7, interval = 25000, chance = 100},
    {name = "Rock Blast", power = 15, interval = 50000, chance = 100},
    {name = "Ancient Power", power = 20, interval = 35000, chance = 100},
    {name = "Falling Rocks", power = 30, interval = 70000, chance = 100},
    {name = "Sandstorm", power = 20, interval = 45000, chance = 100},
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
