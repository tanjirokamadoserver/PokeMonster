
local mType = Game.createMonsterType("Bisharp")
local pokemon = {}
pokemon.eventFile = false
pokemon.eventFile = "default" 
pokemon.description = "a Bisharp"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 841
}

pokemon.health = 14796
pokemon.maxHealth = pokemon.health
pokemon.race = "normal"
pokemon.race2 = "none"
pokemon.corpse = 0
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
{id = "rubber ball", chance = 8000000, maxCount = 13},
{id = "bitten apple", chance = 3250000, maxCount = 1},
{id = "heart stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Hone Claws", power = 7, interval = 35000},
    {name = "Iron Head", power = 10, interval = 10000},
    {name = "Sucker Punch", power = 7, interval = 30000},
    {name = "Dark Pulse", power = 8, interval = 20000},
    {name = "Foul Play", power = 12, interval = 30000},
    {name = "Night Slash", power = 12, interval = 25000},
    {name = "Metal Burst", power = 0, interval = 30000},
    {name = "Payback", power = 15, interval = 50000},
    {name = "Assurance", power = 0, interval = 50000},
    {name = "Swords Dance", power = 0, interval = 60000},
}

pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Hone Claws", power = 7, interval = 35000, chance = 100},
    {name = "Iron Head", power = 10, interval = 10000, chance = 100},
    {name = "Sucker Punch", power = 7, interval = 30000, chance = 100},
    {name = "Dark Pulse", power = 9, interval = 20000, chance = 100},
    {name = "Foul Play", power = 12, interval = 30000, chance = 100},
    {name = "Night Slash", power = 12, interval = 25000, chance = 100},
    {name = "Metal Burst", power = 25, interval = 30000, chance = 100},
    {name = "Payback", power = 20, interval = 50000, chance = 100},
    {name = "Assurance", power = 15, interval = 50000, chance = 100},
    {name = "Swords Dance", power = 0, interval = 60000, chance = 100},
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
