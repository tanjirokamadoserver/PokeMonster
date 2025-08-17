
local mType = Game.createMonsterType("Guardian Raikou")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Guardian Raikou"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 919
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "electric"
pokemon.race2 = "none"
pokemon.corpse = 27104
pokemon.speed = 650
pokemon.maxSummons = 0

pokemon.changeTarget = {
    interval = 1000,
    chance = 50
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
    -- pokemonRank = "S",
    hasShiny = 1,
    hasMega = 0,
    moveMagicAttackBase = 50,
    moveMagicDefenseBase = 15,
    catchChance = 150,
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

pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Ember", power = 5, interval = 15000, chance = 100},
    {name = "Whirlwind", power = 5, interval = 15000, chance = 100},
    {name = "fire damage", power = 70, interval = 8000, chance = 100},
    {name = "fire damage2", power = 5, interval = 17000, chance = 100},
    {name = "Ice Storm", power = 5, interval = 21000, chance = 100},
    {name = "Aerial Ace", power = 5, interval = 25000, chance = 100},
    {name = "Falling Rocks", power = 5, interval = 30000, chance = 100},
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
