
local mType = Game.createMonsterType("Blastoise")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Blastoise"
pokemon.experience = 4583
pokemon.outfit = {
    lookType = 9
}

pokemon.health = 22796
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "none"
pokemon.corpse = 26870
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
    moveMagicDefenseBase = 120,
    catchChance = 250,
    canControlMind = 0,
    canLevitate = 0,
    canLight = 0,
    canCut = 0,
    canSmash = 0,
    canDig = 0,
    canTeleport = 0,
    canBlink = 0,
    isSurfable = 164,
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
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
{id = "water stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Headbutt", power = 7, interval = 20000, level = 50},
    {name = "Bubbles", power = 7, interval = 20000, level = 50},
    {name = "Water Gun", power = 8, interval = 20000, level = 50},
    {name = "Water Ball", power = 7, interval = 20000, level = 50},
    {name = "Water Pulse", power = 10, interval = 20000, level = 50},
    {name = "Muddy Water", power = 12, interval = 20000, level = 50},
    {name = "Hydro Cannon", power = 12, interval = 20000, level = 50},
    {name = "Withdraw", power = 7, interval = 20000, level = 50},
    {name = "Hydro Pump", power = 17, interval = 20000, level = 50},
    {name = "Harden", power = 0, interval = 20000, level = 50},
    {name = "Protector", power = 0, interval = 20000, level = 50},

}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Headbutt", power = 7, interval = 4000, chance = 20},
    {name = "Bubbles", power = 7, interval = 4000, chance = 20},
    {name = "Water Gun", power = 8, interval = 600, chance = 10},
    {name = "Water Ball", power = 7, interval = 25000, chance = 10},
    {name = "Water Pulse", power = 10, interval = 30000, chance = 10},
    {name = "Muddy Water", power = 12, interval = 40000, chance = 10},
    {name = "Hydro Cannon", power = 18, interval = 50000, chance = 10},
    {name = "Hydro Pump", power = 17, interval = 50000, chance = 10},
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
