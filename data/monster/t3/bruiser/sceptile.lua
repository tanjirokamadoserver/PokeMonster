
local mType = Game.createMonsterType("Sceptile")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Sceptile"
pokemon.experience = 3426
pokemon.outfit = {
    lookType = 1502
}

pokemon.health = 17796
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "none"
pokemon.corpse = 27826
pokemon.speed = 450
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
    moveMagicAttackBase = 155,
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
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
{id = "leaf stone", chance = 8000000, maxCount = 1}, --comum
--{id = "feather stone", chance = 16000, maxCount = 1}, -- elemento duplo comum
--{id = "cocoon stone", chance = 16000, maxCount = 1}, -- elemento duplo comum
--{id = "crystal stone", chance = 108000, maxCount = 1}, -- outland/phenac
--{id = "fire stone", chance = 1000, maxCount = 1}, -- epic
--{id = "water stone", chance = 10, maxCount = 1}, -- lendário
}


pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Leaf Blade", power = 9, interval = 10000},
    {name = "Magical Leaf", power = 9, interval = 20000},
    {name = "Night Slash", power = 12, interval = 25000},
    {name = "Leafage", power = 18, interval = 50000},
    {name = "Frenzy Plant", power = 20, interval = 60000},
    {name = "Leaf Storm", power = 25, interval = 70000},
    {name = "Swords Dance", power = 0, interval = 60000},
    {name = "Leaf Guard", power = 0, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Leaf Blade", power = 9, interval = 10000, chance = 100},
    {name = "Magical Leaf", power = 9, interval = 20000, chance = 100},
    {name = "Night Slash", power = 12, interval = 25000, chance = 100},
    {name = "Leafage", power = 18, interval = 50000, chance = 100},
    {name = "Frenzy Plant", power = 20, interval = 60000, chance = 100},
    {name = "Leaf Storm", power = 25, interval = 70000, chance = 100},
    {name = "Swords Dance", power = 0, interval = 60000, chance = 100},
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
