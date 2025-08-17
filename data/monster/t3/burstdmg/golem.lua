
local mType = Game.createMonsterType("Golem")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Golem"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 76
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "rock"
pokemon.race2 = "ground"
pokemon.corpse = 26937
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
    minimumLevel = 80,
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
    moveMagicAttackBase = 165,
    moveMagicDefenseBase = 115,
    catchChance = 250,
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
{id = "small stone", chance = 8000000, maxCount = 13},
{id = "stone orb", chance = 3250000, maxCount = 1},
{id = "rock stone", chance = 150000, maxCount = 1},
{id = "earth ball", chance = 8000000, maxCount = 13},
{id = "sandbag", chance = 3250000, maxCount = 1},
{id = "earth stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "Rock Throw", power = 5, interval = 15000},
    {name = "Rock Slide", power = 12, interval = 20000},
    {name = "Ancient Power", power = 10, interval = 40000},
    {name = "Rock Blast", power = 15, interval = 50000},
    {name = "Rock Wrecker", power = 20, interval = 70000},
    {name = "Falling Rocks", power = 25, interval = 70000},
    {name = "Harden", power = 0, interval = 30000},
    {name = "Rollout", power = 2, interval = 40000},
    {name = "Swagger", power = 0, interval = 40000},
    {name = "Explosion", power = 30, interval = 40000},
}



pokemon.attacks = {
    {name = "Rock Throw", power = 5, interval = 15000},
    {name = "Rock Slide", power = 5, interval = 20000},
    {name = "Ancient Power", power = 20, interval = 40000},
    {name = "Rock Blast", power = 15, interval = 50000},
    {name = "Rock Wrecker", power = 25, interval = 70000},
    {name = "Falling Rocks", power = 30, interval = 70000},
    {name = "Harden", power = 0, interval = 30000},
    {name = "Rollout", power = 12, interval = 40000},
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
