
local mType = Game.createMonsterType("Dragonair")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Dragonair"
pokemon.experience = 1235
pokemon.outfit = {
    lookType = 148
}

pokemon.health = 7640
pokemon.maxHealth = pokemon.health
pokemon.race = "dragon"
pokemon.race2 = "none"
pokemon.corpse = 27009
pokemon.speed = 180
pokemon.maxSummons = 0

pokemon.changeTarget = {
    interval = 4*1000,
    chance = 20
}
pokemon.wild = {
    health = pokemon.health * 1.8,
    maxHealth = pokemon.health * 1.8,
    speed = 280  -- Pode ajustar a velocidade se necess�rio
}

pokemon.flags = {
    minimumLevel = 60,
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
    moveMagicAttackBase = 105,
    moveMagicDefenseBase = 75,
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
{id = "dragon scale", chance = 8000000, maxCount = 13},
{id = "crystal stone", chance = 8000000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Aqua Tail", power = 8, interval = 20000},
    {name = "Thunder Wave", power = 15, interval = 20000},
    {name = "Slam", power = 7, interval = 10000},
    {name = "Wrap", power = 7, interval = 20000},
    {name = "Dragon Tail", power = 10, interval = 20000},
    {name = "Dragon Breath", power = 15, interval = 25000},
    {name = "Twister", power = 7, interval = 35000},
    {name = "Hyper Beam", power = 15, interval = 50000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Aqua Tail", power = 8, interval = 20000, chance = 100},
    {name = "Thunder Wave", power = 15, interval = 20000, chance = 100},
    {name = "Slam", power = 7, interval = 10000, chance = 100},
    {name = "Wrap", power = 7, interval = 20000, chance = 100},
    {name = "Dragon Tail", power = 10, interval = 20000, chance = 100},
    {name = "Dragon Breath", power = 15, interval = 25000, chance = 100},
    {name = "Twister", power = 7, interval = 35000, chance = 100},
    {name = "Hyper Beam", power = 15, interval = 50000, chance = 100},
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
