function onLogout(player)

	if not playerLoginStatus[player:getName()] then
		return true
	end

	nextUseStaminaTime[player.uid] = nil

	if hasSummons(player) then
		local ball = player:getUsingBall()
		if ball then
			local ballId = ball:getId()
			local ballKey = getBallKey(ballId)
			if ballId == balls[ballKey].usedOff then
				local summons = player:getSummons()
				local summon = summons[1]
				ball:transform(balls[ballKey].usedOn)
				ball:setSpecialAttribute("isBeingUsed", 0)
				ball:setSpecialAttribute("pokeHealth", summon:getHealth())
			end
		end
		doRemoveSummon(player:getId())
	end

	if player:getStorageValue(storageBike) > 0 then
		player:removeCondition(CONDITION_OUTFIT)
		player:changeSpeed(-player:getStorageValue(storageBike))
		player:setStorageValue(storageBike, -1)
	end

	if player:getStorageValue(storageArenaEvent) == 2 then
		local town = player:getTown()
		player:teleportTo(town:getTemplePosition())
		player:unregisterEvent("PrepareDeathArena")
		player:setStorageValue(storageArenaEvent, -1)
	end
	
			
	local playerName = player:getName()
	
	local pokeballs = player:getPokeballsCached()

	local pokemons = {}
	 
	for i = 1, #pokeballs do
		local pokemon = {}
	    local name = pokeballs[i]:getSpecialAttribute("pokeName")
			
		if not name then return true end
	    pokemon.name = name
	    local monsterType = MonsterType(name)
		if not monsterType then print(name ..  " não existe") return true end

	 	local boost = pokeballs[i]:getSpecialAttribute("pokeBoost") or 0
	    pokemon.boost = boost
	
	    local level = pokeballs[i]:getSpecialAttribute("pokeLevel") or 0
	    pokemon.level = level

		pokemon.looktype  = {lookType = monsterType:outfit().lookType}

		table.insert(pokemons, pokemon)
	end
	
	local playerPokemons = json.encode(pokemons)
	
	
	db.query("UPDATE `players` SET `pokemons` = '" .. playerPokemons .. "' WHERE `name` = '" .. playerName .. "';")
	playerLoginStatus[player:getName()] = nil
	return true
end
