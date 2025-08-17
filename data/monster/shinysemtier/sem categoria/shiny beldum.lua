
local mType = Game.createMonsterType("Shiny Beldum")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Beldum"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1817
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "steel"
pokemon.race2 = "psychic"
pokemon.corpse = 28426
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
{id = "piece of steel", chance = 8000000, maxCount = 13},
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Iron Head", power = 5, interval = 20000},
    {name = "Psy Pulse", power = 5, interval = 8000},
    {name = "Hammer Arm", power = 5, interval = 40000},
    {name = "Psychic", power = 5, interval = 35000},
    {name = "Metal Claw", power = 5, interval = 35000},
}



pokemon.attacks = {
    {name = "Iron Head", power = 5, interval = 20000, chance = 100},
    {name = "Psy Pulse", power = 5, interval = 8000, chance = 100},
    {name = "Hammer Arm", power = 5, interval = 40000, chance = 100},
    {name = "Psychic", power = 5, interval = 35000, chance = 100},
    {name = "Metal Claw", power = 5, interval = 35000, chance = 100},
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
