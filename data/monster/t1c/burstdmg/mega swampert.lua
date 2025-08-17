
local mType = Game.createMonsterType("Mega Swampert")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Swampert"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 1703
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "ground"
pokemon.corpse = 27832
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
{id = "earth ball", chance = 8000000, maxCount = 13},
{id = "sandbag", chance = 3250000, maxCount = 1},
{id = "earth stone", chance = 150000, maxCount = 1},
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Aqua Tail", power = 5, interval = 10000},
    {name = "Mud-Slap", power = 5, interval = 25000},
    {name = "Water Gun", power = 5, interval = 20000},
    {name = "Water Ball", power = 5, interval = 25000},
    {name = "Hammer Arm", power = 5, interval = 35000},
    {name = "Muddy Water", power = 5, interval = 30000},
    {name = "Earth Power", power = 5, interval = 45000},
    {name = "Earthquake", power = 5, interval = 60000},
    {name = "Hydro Pump", power = 5, interval = 80000},
    {name = "Protect", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "Aqua Tail", power = 5, interval = 10000, chance = 100},
    {name = "Mud-Slap", power = 5, interval = 25000, chance = 100},
    {name = "Water Gun", power = 5, interval = 20000, chance = 100},
    {name = "Water Ball", power = 5, interval = 25000, chance = 100},
    {name = "Hammer Arm", power = 5, interval = 35000, chance = 100},
    {name = "Muddy Water", power = 5, interval = 30000, chance = 100},
    {name = "Earth Power", power = 5, interval = 45000, chance = 100},
    {name = "Earthquake", power = 5, interval = 60000, chance = 100},
    {name = "Hydro Pump", power = 5, interval = 80000, chance = 100},
    {name = "Protect", power = 5, interval = 40000, chance = 100},
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
