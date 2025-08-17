
local mType = Game.createMonsterType("Exeggutor")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Exeggutor"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 103
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "psychic"
pokemon.corpse = 26964
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
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "darkness stone", chance = 150000, maxCount = 1},
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
{id = "leaf stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Seed Bomb", power = 7, interval = 25000},
    {name = "Egg Bomb", power = 7, interval = 8000},
    {name = "Leaf Blade", power = 10, interval = 10000},
    {name = "Confusion", power = 10, interval = 25000},
    {name = "Psyshock", power = 15, interval = 30000},
    {name = "Wood Hammer", power = 7, interval = 30000},
    {name = "Solar Beam", power = 15, interval = 45000},
    {name = "Leaf Storm", power = 20, interval = 70000},
    {name = "Hypnosis", power = 7, interval = 50000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Seed Bomb", power = 7, interval = 25000, chance = 100},
    {name = "Egg Bomb", power = 7, interval = 8000, chance = 100},
    {name = "Leaf Blade", power = 10, interval = 10000, chance = 100},
    {name = "Confusion", power = 10, interval = 25000, chance = 100},
    {name = "Psyshock", power = 15, interval = 30000, chance = 100},
    {name = "Wood Hammer", power = 7, interval = 30000, chance = 100},
    {name = "Solar Beam", power = 15, interval = 45000, chance = 100},
    {name = "Leaf Storm", power = 20, interval = 70000, chance = 100},
    {name = "Hypnosis", power = 7, interval = 50000, chance = 100},
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
