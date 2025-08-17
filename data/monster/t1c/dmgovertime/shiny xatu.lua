
local mType = Game.createMonsterType("Shiny Xatu")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Xatu"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 994
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "psychic"
pokemon.race2 = "flying"
pokemon.corpse = 28147
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
    minimumLevel = 150,
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
{id = "darkness stone", chance = 150000, maxCount = 1},
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
{id = "feather stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Peck", power = 5, interval = 8000},
    {name = "Shadow Sphere", power = 5, interval = 12000},
    {name = "Confuse Ray", power = 5, interval = 32000},
    {name = "Shadow Ball", power = 5, interval = 10000},
    {name = "Night Shade", power = 5, interval = 25000},
    {name = "Astonish", power = 5, interval = 35000},
    {name = "Tailwind", power = 5, interval = 50000},
    {name = "Predict", power = 5, interval = 40000},
    {name = "Double Team", power = 5, interval = 20000},
}



pokemon.attacks = {
    {name = "Peck", power = 5, interval = 8000, chance = 100},
    {name = "Shadow Sphere", power = 5, interval = 12000, chance = 100},
    {name = "Confuse Ray", power = 5, interval = 32000, chance = 100},
    {name = "Shadow Ball", power = 5, interval = 10000, chance = 100},
    {name = "Night Shade", power = 5, interval = 25000, chance = 100},
    {name = "Astonish", power = 5, interval = 35000, chance = 100},
    {name = "Tailwind", power = 5, interval = 50000, chance = 100},
    {name = "Predict", power = 5, interval = 40000, chance = 100},
    {name = "Double Team", power = 5, interval = 20000, chance = 100},
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
