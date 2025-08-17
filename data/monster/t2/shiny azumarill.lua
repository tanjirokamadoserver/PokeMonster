
local mType = Game.createMonsterType("Shiny Azumarill")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Azumarill"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 1000
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "fairy"
pokemon.corpse = 28153
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
{id = "rubber ball", chance = 8000000, maxCount = 13},
{id = "comb", chance = 1950000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1}
}

pokemon.moves = {
    {name = "Play Rough", power = 5, interval = 8000},
    {name = "Bubbles", power = 5, interval = 10000},
    {name = "Bubble Beam", power = 5, interval = 28000},
    {name = "Belle Fleur", power = 5, interval = 25000},
    {name = "Waterfall", power = 5, interval = 25000},
    {name = "Dazzling Burst", power = 5, interval = 28000},
    {name = "Surf", power = 5, interval = 50000},
    {name = "Misty Explosion", power = 5, interval = 60000},
    {name = "Protect", power = 5, interval = 50000},
}



pokemon.attacks = {
    {name = "Play Rough", power = 5, interval = 8000, chance = 100},
    {name = "Bubbles", power = 5, interval = 10000, chance = 100},
    {name = "Bubble Beam", power = 5, interval = 28000, chance = 100},
    {name = "Belle Fleur", power = 5, interval = 25000, chance = 100},
    {name = "Waterfall", power = 5, interval = 25000, chance = 100},
    {name = "Dazzling Burst", power = 5, interval = 28000, chance = 100},
    {name = "Surf", power = 5, interval = 50000, chance = 100},
    {name = "Misty Explosion", power = 5, interval = 60000, chance = 100},
    {name = "Protect", power = 5, interval = 50000, chance = 100},
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
