
local mType = Game.createMonsterType("Shiny Rapidash")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Rapidash"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 296
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "fire"
pokemon.race2 = "none"
pokemon.corpse = 27568
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
    canBlink = 1,
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
{id = "essence of fire", chance = 8000000, maxCount = 13},
{id = "pot of lava", chance = 3250000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Quick Attack", power = 5, interval = 10000},
    {name = "Ember", power = 5, interval = 8000},
    {name = "Stomp", power = 5, interval = 32000},
    {name = "Flame Charge", power = 12, interval = 40000},
    {name = "Flare Blitz", power = 5, interval = 60000},
    {name = "Hypnosis", power = 5, interval = 45000},
    {name = "Tail Whip", power = 5, interval = 40000},
    {name = "Morning Sun", power = 5, interval = 150000},
    {name = "Confide", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "Quick Attack", power = 5, interval = 10000, chance = 100},
    {name = "Ember", power = 5, interval = 8000, chance = 100},
    {name = "Stomp", power = 5, interval = 32000, chance = 100},
    {name = "Flame Charge", power = 12, interval = 40000, chance = 100},
    {name = "Flare Blitz", power = 5, interval = 60000, chance = 100},
    {name = "Hypnosis", power = 5, interval = 45000, chance = 100},
    {name = "Tail Whip", power = 5, interval = 40000, chance = 100},
    {name = "Morning Sun", power = 5, interval = 150000, chance = 100},
    {name = "Confide", power = 5, interval = 40000, chance = 100},
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
