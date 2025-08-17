
local mType = Game.createMonsterType("Heracross")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Heracross"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 890
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "bug"
pokemon.race2 = "fighting"
pokemon.corpse = 27075
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
{id = "bug gosme", chance = 8000000, maxCount = 13},
{id = "pot of moss bug", chance = 3250000, maxCount = 1},
{id = "cocoon stone", chance = 150000, maxCount = 1},
{id = "band aid", chance = 8000000, maxCount = 13},
{id = "punch stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Low Kick", power = 10, interval = 10000},
    {name = "Horn Attack", power = 12, interval = 20000},
    {name = "Arm Thrust", power = 15, interval = 30000},
    {name = "Mega Punch", power = 12, interval = 20000},
    {name = "Close Combat", power = 7, interval = 15000},
    {name = "Revenge", power = 7, interval = 30000},
    {name = "Megahorn", power = 7, interval = 40000},
    {name = "Bug Figther", power = 7, interval = 30000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Low Kick", power = 10, interval = 10000, chance = 100},
    {name = "Horn Attack", power = 12, interval = 20000, chance = 100},
    {name = "Arm Thrust", power = 15, interval = 30000, chance = 100},
    {name = "Mega Punch", power = 12, interval = 20000, chance = 100},
    {name = "Close Combat", power = 7, interval = 15000, chance = 100},
    {name = "Revenge", power = 7, interval = 30000, chance = 100},
    {name = "Megahorn", power = 7, interval = 40000, chance = 100},
    {name = "Bug Figther", power = 7, interval = 30000, chance = 100},
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
