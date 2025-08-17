
local mType = Game.createMonsterType("Gengar")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Gengar"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 94
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "ghost"
pokemon.race2 = "poison"
pokemon.corpse = 26955
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
    moveMagicAttackBase = 160,
    moveMagicDefenseBase = 130,
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
{id = "ghost essence", chance = 8000000, maxCount = 13},
{id = "traces of ghost", chance = 3250000, maxCount = 1},
{id = "darkness stone", chance = 150000, maxCount = 1},
{id = "bottle of poison", chance = 8000000, maxCount = 13},
{id = "venom stone", chance = 8000000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Creepy Lick", power = 7, interval = 40000},
    {name = "Shadow Ball", power = 7, interval = 12000},
    {name = "Shadow Punch", power = 7, interval = 20000},
    {name = "Astonish", power = 17, interval = 40000},
    {name = "Shadow Storm", power = 25, interval = 60000},
    {name = "Vanish", power = 7, interval = 30000},
    {name = "Shadow Claw", power = 18, interval = 40000},
    {name = "Nightmare", power = 7, interval = 40000},
    {name = "Hypnosis", power = 7, interval = 40000},
    {name = "Dark Accurate", power = 7, interval = 15000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Creepy Lick", power = 7, interval = 40000, chance = 100},
    {name = "Shadow Ball", power = 7, interval = 12000, chance = 100},
    {name = "Shadow Punch", power = 7, interval = 20000, chance = 100},
    {name = "Astonish", power = 17, interval = 40000, chance = 100},
    {name = "Shadow Storm", power = 25, interval = 60000, chance = 100},
    {name = "Vanish", power = 7, interval = 30000, chance = 100},
    {name = "Shadow Claw", power = 18, interval = 40000, chance = 100},
    {name = "Nightmare", power = 7, interval = 40000, chance = 100},
    {name = "Hypnosis", power = 7, interval = 40000, chance = 100},
    {name = "Dark Accurate", power = 7, interval = 15000, chance = 100},
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
