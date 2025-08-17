
local mType = Game.createMonsterType("Jirachi")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Jirachi"
pokemon.experience = 1
pokemon.outfit = {
    lookType = 1633
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "steel"
pokemon.race2 = "psychic"
pokemon.corpse = 27957
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
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 1, interval = 2000},
    {name = "Meteor Beam", power = 1, interval = 50000},
    {name = "Swift", power = 1, interval = 5000},
    {name = "Confusion", power = 1, interval = 30000},
    {name = "Psychic", power = 1, interval = 30000},
    {name = "Zen Headbutt", power = 1, interval = 60000},
    {name = "Future Sight", power = 1, interval = 35000},
    {name = "Cosmic Power", power = 1, interval = 40000},
    {name = "Last Resort", power = 1, interval = 15000},
    {name = "Meteor Mash", power = 1, interval = 35000},
    {name = "Doom Desire", power = 1, interval = 25000},
    {name = "Healing Wish", power = 1, interval = 80000},
    {name = "Rest", power = 1, interval = 80000},
    {name = "Wish", power = 1, interval = 150000},
}



pokemon.attacks = {
	{name = "melee", power = 1, interval = 2000, chance = 100},
    {name = "Meteor Beam", power = 1, interval = 50000, chance = 100},
    {name = "Swift", power = 1, interval = 5000, chance = 100},
    {name = "Confusion", power = 1, interval = 30000, chance = 100},
    {name = "Psychic", power = 1, interval = 30000, chance = 100},
    {name = "Zen Headbutt", power = 1, interval = 60000, chance = 100},
    {name = "Future Sight", power = 1, interval = 35000, chance = 100},
    {name = "Cosmic Power", power = 1, interval = 40000, chance = 100},
    {name = "Last Resort", power = 1, interval = 15000, chance = 100},
    {name = "Meteor Mash", power = 1, interval = 35000, chance = 100},
    {name = "Doom Desire", power = 1, interval = 25000, chance = 100},
    {name = "Healing Wish", power = 1, interval = 80000, chance = 100},
    {name = "Rest", power = 1, interval = 80000, chance = 100},
    {name = "Wish", power = 1, interval = 150000, chance = 100},
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
