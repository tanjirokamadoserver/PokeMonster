local event = Event()

event.onCheckImmunity = function(pokemon, combatType, conditionType)

	local pokemonType = MonsterType(pokemon:getName())
	local pokemonRace = pokemonType:race()
	local pokemonRace2 = pokemonType:race2()

	-- testar depois conditions e immunities
	if CONST_IMMUNITIES_RACE[combatType] == pokemonRace or CONST_IMMUNITIES_RACE[combatType] == pokemonRace2 then
		return true
	end

	if pokemon:isPokemon() then
		local master = pokemon:getMaster()
		local pokeball = master:getUsingBall()
		if pokeball then
			local ident = pokeball:getAttribute(ITEM_ATTRIBUTE_HELDY)
			local type = "cure"
			local isHeldCure = isHeld(type, ident)
			if isHeldCure then
				local tier = HELDS_Y_INFO[ident].tier
				local chance = HELDS_BONUS[type][tier]
				if math.random(100) <= chance then
					pokemon:getPosition():sendMagicEffect(CONST_ME_SKIP_CONDITION)
					return true
				end
			end

			local identU = pokeball:getAttribute(ITEM_ATTRIBUTE_HELDU)
			local isAntiPoison = isHeld("antipoison", identU)
			if conditionType == CONDITION_POISON and isAntiPoison then
				return true
			end

			local isAntiBurn = isHeld("antiburn", identU)
			if conditionType == CONDITION_FIRE and isAntiBurn then
				return true
			end
		end

		if pokemon:getBoost() >= CONST_BOOST_IMMUNITY then
			if math.random(100) <= CONST_CHANCE_SKIP_CONDITION then
				pokemon:getPosition():sendMagicEffect(CONST_ME_SKIP_CONDITION)
				return true
			end
		end
	end

	return false
end

event:register()