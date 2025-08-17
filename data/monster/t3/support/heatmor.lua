
local mType = Game.createMonsterType("Heatmor")
local pokemon = {}
pokemon.eventFile = false
pokemon.eventFile = "default" 
pokemon.description = "a Heatmor"
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
    {name = "Incinerate", power = 7, interval = 25000},
    {name = "Flamethrower", power = 10, interval = 18000},
    {name = "Fire Lash", power = 9, interval = 18000},
    {name = "Inferno", power = 20, interval = 70000},
    {name = "Sunny Day", power = 12, interval = 60000},
    {name = "Swallow", power = 20, interval = 100000},
    {name = "Stockpile", power = 0, interval = 30000},
    {name = "Protect", power = 0, interval = 80000},
    {name = "Blue Flames", power = 0, interval = 40000},
    {name = "Clear Pile", power = 0, interval = 40000},
}

pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Incinerate", power = 7, interval = 25000, chance = 100},
    {name = "Flamethrower", power = 10, interval = 18000, chance = 100},
    {name = "Fire Lash", power = 9, interval = 18000, chance = 100},
    {name = "Inferno", power = 20, interval = 70000, chance = 100},
    {name = "Sunny Day", power = 0, interval = 60000, chance = 100},
    {name = "Swallow", power = 20, interval = 100000, chance = 100},
    {name = "Stockpile", power = 0, interval = 30000, chance = 100},
    {name = "Protect", power = 0, interval = 80000, chance = 100},
    {name = "Blue Flames", power = 0, interval = 40000, chance = 100},
    {name = "Clear Pile", power = 0, interval = 40000, chance = 100},
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
