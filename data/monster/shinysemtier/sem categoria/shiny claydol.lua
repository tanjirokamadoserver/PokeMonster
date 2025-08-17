
local mType = Game.createMonsterType("Shiny Claydol")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Claydol"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1787
}

pokemon.health = 5000
pokemon.maxHealth = pokemon.health
pokemon.race = "ground"
pokemon.race2 = "psychic"
pokemon.corpse = 28398
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
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "earth ball", chance = 8000000, maxCount = 13},
{id = "sandbag", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
    {name = "Mud Sport", power = 5, interval = 32000},
    {name = "Extrasensory", power = 5, interval = 25000},
    {name = "Psybeam", power = 5, interval = 10000},
    {name = "Psychic", power = 5, interval = 30000},
    {name = "Earth Power", power = 5, interval = 35000},
    {name = "Earthquake", power = 5, interval = 60000},
    {name = "Sandstorm", power = 5, interval = 60000},
    {name = "Heal Block", power = 5, interval = 80000},
    {name = "Guard Split", power = 5, interval = 80000},
    {name = "Protect", power = 5, interval = 60000},
}



pokemon.attacks = {
    {name = "Mud Sport", power = 5, interval = 32000, chance = 100},
    {name = "Extrasensory", power = 5, interval = 25000, chance = 100},
    {name = "Psybeam", power = 5, interval = 10000, chance = 100},
    {name = "Psychic", power = 5, interval = 30000, chance = 100},
    {name = "Earth Power", power = 5, interval = 35000, chance = 100},
    {name = "Earthquake", power = 5, interval = 60000, chance = 100},
    {name = "Sandstorm", power = 5, interval = 60000, chance = 100},
    {name = "Heal Block", power = 5, interval = 80000, chance = 100},
    {name = "Guard Split", power = 5, interval = 80000, chance = 100},
    {name = "Protect", power = 5, interval = 60000, chance = 100},
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
