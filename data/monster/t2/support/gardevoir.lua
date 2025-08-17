
local mType = Game.createMonsterType("Gardevoir")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Gardevoir"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 1530
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "psychic"
pokemon.race2 = "fairy"
pokemon.corpse = 27854
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
    moveMagicAttackBase = 100,
    moveMagicDefenseBase = 15,
    catchChance = 250,
    canControlMind = 0,
    canLevitate = 0,
    canLight = 0,
    canCut = 0,
    canSmash = 0,
    canDig = 0,
    canTeleport = 1,
    canBlink = 0,
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
{id = "rubber ball", chance = 8000000, maxCount = 13},
{id = "comb", chance = 1950000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "darkness stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Charm", power = 7, interval = 60000},
    {name = "Dazzling Gleam", power = 7, interval = 15000},
    {name = "Instant Teleportation", power = 7, interval = 15000},
    {name = "Confusion", power = 10, interval = 25000},
    {name = "Psychic", power = 12, interval = 25000},
    {name = "Stored Power", power = 7, interval = 60000},
    {name = "Healing Wish", power = 8, interval = 150000},
    {name = "Moonblast", power = 7, interval = 50000},
    {name = "Miracle Eye", power = 0, interval = 15000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Charm", power = 7, interval = 60000, chance = 100},
    {name = "Dazzling Gleam", power = 7, interval = 15000, chance = 100},
    {name = "Instant Teleportation", power = 7, interval = 15000, chance = 100},
    {name = "Confusion", power = 10, interval = 25000, chance = 100},
    {name = "Psychic", power = 12, interval = 25000, chance = 100},
    {name = "Stored Power", power = 7, interval = 60000, chance = 100},
    {name = "Healing Wish", power = 7, interval = 150000, chance = 100},
    {name = "Moonblast", power = 7, interval = 50000, chance = 100},
    {name = "Miracle Eye", power = 0, interval = 15000, chance = 100},
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
