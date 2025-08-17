local mType = Game.createMonsterType("Bug Dummy")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Dummy"
pokemon.experience = 1
pokemon.outfit = {
	lookType = 100
}

pokemon.health = 10000000
pokemon.maxHealth = pokemon.health
pokemon.race = "bug"
pokemon.race2 = "none"
pokemon.corpse = 0
pokemon.speed = 0
pokemon.maxSummons = 0

pokemon.changeTarget = {}
pokemon.wild = {
    health = pokemon.health * 1.8,
    maxHealth = pokemon.health * 1.8,
    speed = 220
}

pokemon.flags = {
	attackable = true,
    summonable = true,
    passive = false,
	hostile = false,
	convinceable = true,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	targetDistance = 0,
	staticAttackChance = 0,
    pokemonRank = "",
    hasShiny = 0,
    hasMega = 0,
    moveMagicAttackBase = 0,
    moveMagicDefenseBase = 100,
    catchChance = 150,
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

pokemon.voices = {}

pokemon.loot = {}

pokemon.attacks = {}

pokemon.moves = {}

pokemon.defenses = {}

pokemon.elements = {}

pokemon.immunities = {}

mType.onThink = function(pokemon, interval)
    pokemon:addHealth(pokemon:getMaxHealth())
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
