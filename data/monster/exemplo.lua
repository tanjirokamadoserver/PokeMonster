
local mType = Game.createMonsterType("exemplo")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a exmeplo"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1627
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "steel"
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
    {id = "piece of steel", chance = 8000000, maxCount = 13},
}

pokemon.evolutions = {
    {
        pokeName = "poke_name",
        level = 10,
        chance = 0,
        stones = {
            {stoneId = 0, stoneCount = 5},
            {stoneId = 1, stoneCount = 5}
        }
    },
    {
        pokeName = "poke_name2",
        level = 10,
        chance = 0,
        stones = {
            {stoneId = 26728, stoneCount = 5}
        }
    },
    ---...
}

pokemon.moves = {
	{name = "melee", power = 1, interval = 2000},
    {name = "Iron Spinner", power = 1, interval = 5000},
    {name = "Iron Head", power = 1, interval = 20000},
    {name = "Iron Tail", power = 1, interval = 15000},
    {name = "Hammer Arm", power = 1, interval = 25000},
    {name = "Ancient Power", power = 1, interval = 50000},
    {name = "Metal Burst", power = 1, interval = 25000},
    {name = "Metal Claw", power = 1, interval = 35000},
    {name = "Meteor Mash", power = 1, interval = 35000},
    {name = "Flash Cannon", power = 1, interval = 40000},
    {name = "Hyper Beam", power = 1, interval = 50000},
    {name = "Harden", power = 1, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Iron Spinner", power = 1, interval = 5000, chance = 100},
    {name = "Iron Head", power = 1, interval = 20000, chance = 100},
    {name = "Iron Tail", power = 1, interval = 15000, chance = 100},
    {name = "Hammer Arm", power = 1, interval = 25000, chance = 100},
    {name = "Ancient Power", power = 1, interval = 50000, chance = 100},
    {name = "Metal Burst", power = 1, interval = 25000, chance = 100},
    {name = "Metal Claw", power = 1, interval = 35000, chance = 100},
    {name = "Meteor Mash", power = 1, interval = 35000, chance = 100},
    {name = "Flash Cannon", power = 1, interval = 40000, chance = 100},
    {name = "Hyper Beam", power = 1, interval = 50000, chance = 100},
    {name = "Harden", power = 1, interval = 40000, chance = 100},
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
