
local mType = Game.createMonsterType("Medicham")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Medicham"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 1556
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "fighting"
pokemon.race2 = "psychic"
pokemon.corpse = 27880
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
    moveMagicAttackBase = 145,
    moveMagicDefenseBase = 115,
    catchChance = 250,
    canControlMind = 0,
    canLevitate = 0,
    canLight = 0,
    canCut = 0,
    canSmash = 0,
    canDig = 0,
    canTeleport = 0,
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
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "darkness stone", chance = 150000, maxCount = 1},
{id = "band aid", chance = 8000000, maxCount = 13},
{id = "punch stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Low Kick", power = 10, interval = 10000},
    {name = "Thunder Punch", power = 7, interval = 18000},
    {name = "Zen Headbutt", power = 15, interval = 45000},
    {name = "Low Sweep", power = 12, interval = 40000},
    {name = "Psychic", power = 12, interval = 30000},
    {name = "High Jump Kick", power = 25, interval = 50000},
    {name = "Meditate", power = 7, interval = 50000},
    {name = "Focus Energy", power = 0, interval = 50000},
    {name = "Miracle Eye", power = 0, interval = 15000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Low Kick", power = 10, interval = 10000, chance = 100},
    {name = "Thunder Punch", power = 7, interval = 18000, chance = 100},
    {name = "Zen Headbutt", power = 15, interval = 45000, chance = 100},
    {name = "Low Sweep", power = 12, interval = 40000, chance = 100},
    {name = "Psychic", power = 12, interval = 30000, chance = 100},
    {name = "High Jump Kick", power = 7, interval = 50000, chance = 100},
    {name = "Meditate", power = 7, interval = 50000, chance = 100},
    {name = "Focus Energy", power = 0, interval = 50000, chance = 100},
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
