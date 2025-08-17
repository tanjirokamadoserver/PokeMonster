
local mType = Game.createMonsterType("Metagross")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Metagross"
pokemon.experience = 22752
pokemon.outfit = {
    lookType = 1624
}

pokemon.health = 22232
pokemon.maxHealth = pokemon.health
pokemon.race = "steel"
pokemon.race2 = "psychic"
pokemon.corpse = 27948
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
{id = "piece of steel", chance = 8000000, maxCount = 13},
{id = "metal stone", chance = 150000, maxCount = 1},
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "darkness stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Iron Head", power = 7, interval = 15000},
    {name = "Psy Pulse", power = 12, interval = 10000},
    {name = "Zen Headbutt", power = 15, interval = 40000},
    {name = "Swagger", power = 0, interval = 40000},
    {name = "Psychic", power = 12, interval = 30000},
    {name = "Metal Claw", power = 7, interval = 32000},
    {name = "Meteor Mash", power = 12, interval = 40000},
    {name = "Flash Cannon", power = 15, interval = 45000},
    {name = "Iron Defense", power = 7, interval = 60000},
    {name = "Miracle Eye", power = 0, interval = 15000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Iron Head", power = 7, interval = 15000, chance = 100},
    {name = "Psy Pulse", power = 12, interval = 10000, chance = 100},
    {name = "Zen Headbutt", power = 15, interval = 40000, chance = 100},
    {name = "Swagger", power = 0, interval = 40000, chance = 100},
    {name = "Psychic", power = 12, interval = 30000, chance = 100},
    {name = "Metal Claw", power = 7, interval = 32000, chance = 100},
    {name = "Meteor Mash", power = 12, interval = 40000, chance = 100},
    {name = "Flash Cannon", power = 15, interval = 45000, chance = 100},
    {name = "Iron Defense", power = 7, interval = 60000, chance = 100},
    {name = "Miracle Eye", power = 0, interval = 15000, chance = 100},
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
