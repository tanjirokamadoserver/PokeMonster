
local mType = Game.createMonsterType("Shiny Beedrill")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Shiny Beedrill"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 223
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "bug"
pokemon.race2 = "poison"
pokemon.corpse = 27515
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
    moveMagicAttackBase = 155,
    moveMagicDefenseBase = 100,
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
{id = "bug gosme", chance = 8000000, maxCount = 13},
{id = "pot of moss bug", chance = 3250000, maxCount = 1},
{id = "cocoon stone", chance = 150000, maxCount = 1},
{id = "bottle of poison", chance = 8000000, maxCount = 13},
{id = "venom stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
    {name = "melee", power = 9, interval = 2000},
    {name = "String Shot", power = 5, interval = 15000},
    {name = "Bug Bite", power = 9, interval = 10000},
    {name = "U-Turn", power = 12, interval = 15000},
    {name = "Pin Missile", power = 20, interval = 12000},
    {name = "Fell Sting", power = 15, interval = 40000},
    {name = "Twineedle", power = 25, interval = 40000},
    {name = "Savage Spirit", power = 30, interval = 50000},
    {name = "Swagger", power = 0, interval = 40000},
    {name = "Swords Dance", power = 5, interval = 40000},
}



pokemon.attacks = {
    {name = "melee", power = 9, interval = 2000, chance = 100},
    {name = "String Shot", power = 9, interval = 15000, chance = 100},
    {name = "Bug Bite", power = 12, interval = 10000, chance = 100},
    {name = "U-Turn", power = 15, interval = 15000, chance = 100},
    {name = "Pin Missile", power = 20, interval = 12000, chance = 100},
    {name = "Fell Sting", power = 15, interval = 40000, chance = 100},
    {name = "Twineedle", power = 25, interval = 40000, chance = 100},
    {name = "Savage Spirit", power = 30, interval = 50000, chance = 100},
    {name = "Swagger", power = 0, interval = 40000, chance = 100},
    {name = "Swords Dance", power = 5, interval = 40000, chance = 100},
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
