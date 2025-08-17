
local mType = Game.createMonsterType("Shiny Qwilfish")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Qwilfish"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 1026
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "poison"
pokemon.corpse = 28180
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
{id = "bottle of poison", chance = 8000000, maxCount = 13},
{id = "venom stone", chance = 150000, maxCount = 1},
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Tackle", power = 5, interval = 15000},
    {name = "Poison Sting", power = 5, interval = 10000},
    {name = "Toxic Spikes", power = 5, interval = 20000},
    {name = "Poison Tail", power = 5, interval = 20000},
    {name = "Toxic", power = 5, interval = 30000},
    {name = "Mortal Gas", power = 5, interval = 60000},
    {name = "Spike Skin", power = 5, interval = 50000},
    {name = "Minimize", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "Tackle", power = 5, interval = 15000, chance = 100},
    {name = "Poison Sting", power = 5, interval = 10000, chance = 100},
    {name = "Toxic Spikes", power = 5, interval = 20000, chance = 100},
    {name = "Poison Tail", power = 5, interval = 20000, chance = 100},
    {name = "Toxic", power = 5, interval = 30000, chance = 100},
    {name = "Mortal Gas", power = 5, interval = 60000, chance = 100},
    {name = "Spike Skin", power = 5, interval = 50000, chance = 100},
    {name = "Minimize", power = 5, interval = 40000, chance = 100},
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
