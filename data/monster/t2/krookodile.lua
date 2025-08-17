
local mType = Game.createMonsterType("Krookodile")
local pokemon = {}
pokemon.eventFile = false
pokemon.eventFile = "default"
pokemon.description = "a Krookodile"
pokemon.experience = 6752
pokemon.outfit = {
    lookType = 3268
}

pokemon.health = 463891
pokemon.maxHealth = pokemon.health
pokemon.race = "ground"
pokemon.race2 = "none"
pokemon.corpse = 41617
pokemon.speed = 230
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
    moveMagicAttackBase = 260,
    moveMagicDefenseBase = 160,
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

pokemon.loot = {}

pokemon.moves = {
	{name = "melee", power = 4, interval = 2000},
    {name = "Crunch", power = 3, interval = 10000},
    {name = "Stomping Tantrum", power = 3, interval = 15000},
    {name = "Dig", power = 3, interval = 20000},
    {name = "Dragon Claw", power = 8, interval = 30000},
    {name = "Bulldoze", power = 252, interval = 40000},
    {name = "Payback", power = 258, interval = 50000},
    {name = "Power Trip", power = 20, interval = 50000},
    {name = "Intimidate", power = 21, interval = 60000},
    {name = "Scary Face", power = 0, interval = 45000},
    -- {name = "Moxie", power = 7, interval = 45000},
}

pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Crunch", power = 3, interval = 10000, chance= 100},
    {name = "Stomping Tantrum", power = 3, interval = 15000, chance= 100},
    {name = "Dig", power = 3, interval = 20000, chance= 100},
    {name = "Dragon Claw", power = 8, interval = 30000, chance= 100},
    {name = "Bulldoze", power = 252, interval = 40000, chance= 100},
    {name = "Payback", power = 258, interval = 50000, chance= 100},
    {name = "Power Trip", power = 20, interval = 50000, chance= 100},
    {name = "Intimidate", power = 21, interval = 60000, chance= 100},
    {name = "Scary Face", power = 0, interval = 45000, chance= 100},
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
