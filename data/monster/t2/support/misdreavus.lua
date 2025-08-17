
local mType = Game.createMonsterType("Misdreavus")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Misdreavus"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 851
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "ghost"
pokemon.race2 = "none"
pokemon.corpse = 27061
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
{id = "ghost essence", chance = 8000000, maxCount = 13},
{id = "traces of ghost", chance = 3250000, maxCount = 1},
{id = "darkness stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Shadow Ball", power = 7, interval = 10000},
    {name = "Emergency Call", power = 0, interval = 30000},
    {name = "Confuse Ray", power = 7, interval = 32000},
    {name = "Black Box", power = 7, interval = 35000},
    {name = "Hex", power = 7, interval = 30000},
    {name = "Shadow Storm", power = 25, interval = 80000},
    {name = "Pain Split", power = 7, interval = 40000},
    {name = "Spite", power = 7, interval = 30000},
    {name = "Growl", power = 7, interval = 40000},
    {name = "Mean Look", power = 7, interval = 50000},
    {name = "Dark Accurate", power = 7, interval = 30000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Shadow Ball", power = 7, interval = 10000, chance = 100},
    {name = "Emergency Call", power = 0, interval = 30000, chance = 100},
    {name = "Confuse Ray", power = 7, interval = 32000, chance = 100},
    {name = "Black Box", power = 7, interval = 35000, chance = 100},
    {name = "Hex", power = 7, interval = 30000, chance = 100},
    {name = "Shadow Storm", power = 25, interval = 80000, chance = 100},
    {name = "Pain Split", power = 7, interval = 40000, chance = 100},
    {name = "Spite", power = 7, interval = 30000, chance = 100},
    {name = "Growl", power = 7, interval = 40000, chance = 100},
    {name = "Mean Look", power = 7, interval = 50000, chance = 100},
    {name = "Dark Accurate", power = 7, interval = 30000, chance = 100},
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
