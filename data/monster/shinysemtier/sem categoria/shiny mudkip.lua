
local mType = Game.createMonsterType("Shiny Mudkip")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Mudkip"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1701
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "none"
pokemon.corpse = 28315
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
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Tackle", power = 5, interval = 12000},
    {name = "Mud-Slap", power = 5, interval = 20000},
    {name = "Water Gun", power = 5, interval = 18000},
    {name = "Aqua Tail", power = 5, interval = 10000},
    {name = "Water Ball", power = 5, interval = 22000},
    {name = "Muddy Water", power = 5, interval = 35000},
    {name = "Water Pulse", power = 5, interval = 30000},
    {name = "Earth Power", power = 5, interval = 30000},
}



pokemon.attacks = {
    {name = "Tackle", power = 5, interval = 12000, chance = 100},
    {name = "Mud-Slap", power = 5, interval = 20000, chance = 100},
    {name = "Water Gun", power = 5, interval = 18000, chance = 100},
    {name = "Aqua Tail", power = 5, interval = 10000, chance = 100},
    {name = "Water Ball", power = 5, interval = 22000, chance = 100},
    {name = "Muddy Water", power = 5, interval = 35000, chance = 100},
    {name = "Water Pulse", power = 5, interval = 30000, chance = 100},
    {name = "Earth Power", power = 5, interval = 30000, chance = 100},
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
