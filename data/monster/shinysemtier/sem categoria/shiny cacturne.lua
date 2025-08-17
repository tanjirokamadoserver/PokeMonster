
local mType = Game.createMonsterType("Shiny Cacturne")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Cacturne"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1775
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "grass"
pokemon.race2 = "dark"
pokemon.corpse = 28387
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
{id = "dark gem", chance = 8000000, maxCount = 13},
{id = "seed", chance = 8000000, maxCount = 13},
{id = "leaves", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Dark Pulse", power = 5, interval = 8000},
    {name = "Sucker Punch", power = 5, interval = 15000},
    {name = "Foul Play", power = 5, interval = 12000},
    {name = "Needle Arm", power = 5, interval = 45000},
    {name = "Payback", power = 5, interval = 60000},
    {name = "Shadow Blast", power = 5, interval = 60000},
    {name = "Grass Whistle", power = 5, interval = 40000},
    {name = "Nasty Plot", power = 5, interval = 60000},
    {name = "Spiky Shield", power = 5, interval = 60000},
    {name = "Sandstorm", power = 5, interval = 50000},
}



pokemon.attacks = {
    {name = "Dark Pulse", power = 5, interval = 8000, chance = 100},
    {name = "Sucker Punch", power = 5, interval = 15000, chance = 100},
    {name = "Foul Play", power = 5, interval = 12000, chance = 100},
    {name = "Needle Arm", power = 5, interval = 45000, chance = 100},
    {name = "Payback", power = 5, interval = 60000, chance = 100},
    {name = "Shadow Blast", power = 5, interval = 60000, chance = 100},
    {name = "Grass Whistle", power = 5, interval = 40000, chance = 100},
    {name = "Nasty Plot", power = 5, interval = 60000, chance = 100},
    {name = "Spiky Shield", power = 5, interval = 60000, chance = 100},
    {name = "Sandstorm", power = 5, interval = 50000, chance = 100},
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
