
local mType = Game.createMonsterType("Shiny Lanturn")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Lanturn"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 987
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "electric"
pokemon.corpse = 28140
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
{id = "screw", chance = 8000000, maxCount = 13},
{id = "electric box", chance = 3250000, maxCount = 1},
{id = "thunder stone", chance = 150000, maxCount = 1},
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Super Sonic", power = 5, interval = 25000},
    {name = "Bubbles", power = 5, interval = 8000},
    {name = "Bubble Beam", power = 5, interval = 20000},
    {name = "Spark", power = 5, interval = 12000},
    {name = "Thunder Wave", power = 5, interval = 25000},
    {name = "Water Pulse", power = 5, interval = 20000},
    {name = "Surf", power = 5, interval = 50000},
    {name = "Electro Ball", power = 5, interval = 30000},
    {name = "Hydro Pump", power = 5, interval = 60000},
    {name = "Illuminate", power = 5, interval = 50000},
}



pokemon.attacks = {
    {name = "Super Sonic", power = 5, interval = 25000, chance = 100},
    {name = "Bubbles", power = 5, interval = 8000, chance = 100},
    {name = "Bubble Beam", power = 5, interval = 20000, chance = 100},
    {name = "Spark", power = 5, interval = 12000, chance = 100},
    {name = "Thunder Wave", power = 5, interval = 25000, chance = 100},
    {name = "Water Pulse", power = 5, interval = 20000, chance = 100},
    {name = "Surf", power = 5, interval = 50000, chance = 100},
    {name = "Electro Ball", power = 5, interval = 30000, chance = 100},
    {name = "Hydro Pump", power = 5, interval = 60000, chance = 100},
    {name = "Illuminate", power = 5, interval = 50000, chance = 100},
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
