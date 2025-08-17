
local mType = Game.createMonsterType("Salamence")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Salamence"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 1621
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "dragon"
pokemon.race2 = "flying"
pokemon.corpse = 27945
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
    minimumLevel = 150,
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
    moveMagicAttackBase = 190,
    moveMagicDefenseBase = 150,
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
{id = "dragon scale", chance = 8000000, maxCount = 13},
{id = "crystal stone", chance = 150000, maxCount = 1},
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
{id = "feather stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Roar", power = 7, interval = 45000},
    {name = "Fire Fang", power = 7, interval = 22000},
    {name = "Dragon Tail", power = 10, interval = 10000},
    {name = "Dragon Claw", power = 12, interval = 20000},
    {name = "Dragon Breath", power = 15, interval = 30000},
    {name = "Dragon Pulse", power = 7, interval = 35000},
    {name = "Scary Face", power = 0, interval = 40000},
    {name = "Intimidate", power = 7, interval = 60000},
    {name = "Draco Meteor", power = 20, interval = 70000},
    {name = "Dragon Dance", power = 7, interval = 60000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Roar", power = 7, interval = 45000, chance = 100},
    {name = "Fire Fang", power = 7, interval = 22000, chance = 100},
    {name = "Dragon Tail", power = 10, interval = 10000, chance = 100},
    {name = "Dragon Claw", power = 12, interval = 20000, chance = 100},
    {name = "Dragon Breath", power = 15, interval = 30000, chance = 100},
    {name = "Dragon Pulse", power = 7, interval = 35000, chance = 100},
    {name = "Scary Face", power = 0, interval = 40000, chance = 100},
    {name = "Intimidate", power = 7, interval = 60000, chance = 100},
    {name = "Draco Meteor", power = 20, interval = 70000, chance = 100},
    {name = "Dragon Dance", power = 7, interval = 60000, chance = 100},
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
