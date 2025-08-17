
local mType = Game.createMonsterType("Raikou")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Raikou"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 919
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "electric"
pokemon.race2 = "none"
pokemon.corpse = 27104
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
    moveMagicAttackBase = 10,
    moveMagicDefenseBase = 15,
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
{id = "screw", chance = 8000000, maxCount = 13},
{id = "electric box", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 1, interval = 2000},
    {name = "Thunder Shock", power = 1, interval = 6000},
    {name = "Bite", power = 1, interval = 8000},
    {name = "Thunder Fang", power = 1, interval = 29000},
    {name = "Thunder Wave", power = 1, interval = 14000},
    {name = "Flash", power = 1, interval = 27000},
    {name = "Thunder", power = 1, interval = 9000},
    {name = "Wild Charge", power = 1, interval = 21000},
    {name = "Discharge", power = 1, interval = 25000},
    {name = "Electro Field", power = 1, interval = 60000},
    {name = "Extreme Speed", power = 1, interval = 5000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Thunder Shock", power = 1, interval = 6000, chance = 100},
    {name = "Bite", power = 1, interval = 8000, chance = 100},
    {name = "Thunder Fang", power = 1, interval = 29000, chance = 100},
    {name = "Thunder Wave", power = 1, interval = 14000, chance = 100},
    {name = "Flash", power = 1, interval = 27000, chance = 100},
    {name = "Thunder", power = 1, interval = 9000, chance = 100},
    {name = "Wild Charge", power = 1, interval = 21000, chance = 100},
    {name = "Discharge", power = 1, interval = 25000, chance = 100},
    {name = "Electro Field", power = 1, interval = 60000, chance = 100},
    {name = "Extreme Speed", power = 1, interval = 5000, chance = 100},
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
