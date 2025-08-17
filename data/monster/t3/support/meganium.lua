
local mType = Game.createMonsterType("Meganium")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Meganium"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 802
}

pokemon.health = 13560
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "none"
pokemon.corpse = 27015
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
    moveMagicAttackBase = 80,
    moveMagicDefenseBase = 45,
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
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
{id = "leaf stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Razor Leaf", power = 7, interval = 10000},
    {name = "Magical Leaf", power = 12, interval = 25000},
    {name = "Petal Bullets", power = 10, interval = 25000},
    {name = "Petal Dance", power = 12, interval = 50000},
    {name = "Ingrain", power = 20, interval = 150000},
    {name = "Sweet Scent", power = 0, interval = 50000},
    {name = "Protection", power = 0, interval = 35000},
    {name = "Emergency Call", power = 0, interval = 40000},
    {name = "Reflect", power = 0, interval = 60000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Razor Leaf", power = 8, interval = 4000, chance = 100},
    {name = "Magical Leaf", power = 9, interval = 4000, chance = 30},
    {name = "Petal Bullets", power = 6, interval = 9000, chance = 40},
    {name = "Petal Dance", power = 8, interval = 6000, chance = 30},
    {name = "Ingrain", power = 8, interval = 40000, chance = 20},
    {name = "Sweet Scent", power = 9, interval = 50000, chance = 10},

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
