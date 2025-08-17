
local mType = Game.createMonsterType("Mewtwo")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Mewtwo"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 3016 --150 original
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "psychic"
pokemon.race2 = "none"
pokemon.corpse = 27011
pokemon.speed = 180
pokemon.maxSummons = 0

pokemon.changeTarget = {
    interval = 4*1000,
    chance = 20
}
pokemon.wild = {
    health = pokemon.health * 1.8,
    maxHealth = pokemon.health * 1.8,
    speed = 280  -- Pode ajustar a velocidade se necess�rio
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
    moveMagicAttackBase = 15000,
    moveMagicDefenseBase = 150,
    catchChance = 250,
    canControlMind = 0,
    canLevitate = 1,
    canLight = 1,
    canCut = 1,
    canSmash = 1,
    canDig = 1,
    canTeleport = 1,
    canBlink = 1,
    isSurfable = 1,
    isRideable = 0,
    isFlyable = 3184,
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
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Swift", power = 7, interval = 5000},
    {name = "Shadow Ball", power = 7, interval = 5000},
    {name = "Psybeam", power = 7, interval = 5000},
    {name = "Psywave", power = 7, interval = 5000},
    {name = "Confusion", power = 10, interval = 5000},
    {name = "Psychic", power = 12, interval = 20000},
    {name = "Psystrike", power = 7, interval = 30000},
    {name = "Recover", power = 20, interval = 60000},
    {name = "Barrier", power = 7, interval = 30000},
    {name = "Fear", power = 7, interval = 10000},
    {name = "Reflect", power = 0, interval = 10000},
    {name = "Miracle Eye", power = 0, interval = 10000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Swift", power = 7, interval = 5000, chance = 100},
    {name = "Shadow Ball", power = 7, interval = 5000, chance = 100},
    {name = "Psybeam", power = 7, interval = 5000, chance = 100},
    {name = "Psywave", power = 7, interval = 5000, chance = 100},
    {name = "Confusion", power = 10, interval = 5000, chance = 100},
    {name = "Psychic", power = 12, interval = 20000, chance = 100},
    {name = "Psystrike", power = 7, interval = 30000, chance = 100},
    {name = "Recover", power = 20, interval = 60000, chance = 100},
    {name = "Barrier", power = 7, interval = 30000, chance = 100},
    {name = "Fear", power = 7, interval = 10000, chance = 100},
    {name = "Reflect", power = 0, interval = 10000, chance = 100},
    {name = "Miracle Eye", power = 0, interval = 10000, chance = 100},
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
