function doPlayerSendEffect(cid, effect)
	local player = Player(cid)
	if player then
		player:getPosition():sendMagicEffect(effect)
	end
	return true
end

function doPlayerAddExperience(cid, exp)
	local player = Player(cid)
	if player then
		player:addExperience(exp, true)
	end
	return true
end

function isPokemonNormal(name)
	name = name:lower()
	local isShiny = string.find(name, "shiny ")
	local isMega = string.find(name, "mega ")
	return not isShiny and not isMega
end

function isPokemonShiny(name)
	name = name:lower()
	local isShiny = string.find(name, "shiny ")
	return isShiny
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(toPosition)
	if not tile or not tile:getTopDownItem() or (not ItemType(tile:getTopDownItem():getId()):isCorpse() and not string.find(ItemType(tile:getTopDownItem():getId()):getName(), "fainted")) then
		return false
	end
	local targetCorpse = tile:getTopDownItem()

	local owner = targetCorpse:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
	if owner ~= 0 and owner ~= player:getId() then
		player:sendCancelMessage("Sorry, not possible. You are not the owner.")
		return true
	end

	local ballKey = getBallKey(item:getId())
	local playerPos = getPlayerPosition(player)
	local d = getDistanceBetween(playerPos, toPosition)
	local delay = d * 80
	local delayMessage = delay + 2800
	local name = targetCorpse:getName()

	name = string.gsub(name, " a ", "")
	name = string.gsub(name, " an ", "")
	name = string.gsub(name, "fainted ", "")
	name = capitalizeFirstLetter(name)

	local monsterType = MonsterType(name)
	if not monsterType then return false end

	local type = monsterType:getRaceName()
	local type2 = monsterType:getRace2Name()
	if not type then
		type = "none"
	end
	if not type2 then
		type2 = "none"
	end
	local pontos = 0
	if isInArray(LOWER_PALWORLD_MONSTERS, string.lower(name)) then
		type = "palworld"
		type2 = "palworld"
	end

	local pontuacao1 = TYPES_POINTS[type][item.itemid] or 0
	local pontuacao2 = TYPES_POINTS[type2][item.itemid] or 0

	pontos = math.max(pontuacao1, pontuacao2)


	if not monsterType then
		print("WARNING! Monster " .. name .. " with bug on catch!")
		player:sendCancelMessage("Sorry, not possible. This problem was reported.")
		playerPos:sendMagicEffect(CONST_ME_POFF)
		targetCorpse:remove()
		return true
	end

	if isInArray(LOWER_PALWORLD_MONSTERS, string.lower(name)) then
		if not isInArray(ALLOWED_POKEBALLS_PALWORLD, item.itemid) then
			player:sendCancelMessage("Você só pode capturar pals com esferas.")
			return true
		end
	end

	if isInArray(LOWER_MASTERBALL_BLOCKED, string.lower(name)) then
		if item.itemid == 13228 then
			player:sendCancelMessage("Esse pokémon é bloqueado o uso de masterball.")
			return true
		end
	end

	local chanceBase = monsterType:catchChance()
	if chanceBase == 0 then
		playerPos:sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("Sorry, it is impossible to catch this monster.")
		return true
	end

	local guild = player:getGuild()
	if guild then
		local hasCriticalCatchBuff = guild:hasBuff(COLUMN_4, CRITICAL_CATCH_BUFF)
		if (hasCriticalCatchBuff) then
			if (math.random(0,100) <= GUILD_BUFF_LUCKY) then
				chanceBase = chanceBase * 2
				(toPosition + Position(1, 1, 0)):sendMagicEffect(2511);
				(toPosition + Position(1, 1, 0)):sendMagicEffect(2512)
			end
		end
	end

	local chance = chanceBase * balls[ballKey].chanceMultiplier

	doSendDistanceShoot(playerPos, toPosition, balls[ballKey].missile)
	item:remove(1)
	targetCorpse:remove()

	if math.random(0, 10000) <= chance or INFOS_CATCH[string.lower(name)] and (pontos+player:getCatchPoints(name)) >= INFOS_CATCH[string.lower(name)].pontos then
		if player:getSlotItem(CONST_SLOT_BACKPACK) and player:getSlotItem(CONST_SLOT_BACKPACK):getEmptySlots() >= 1 and player:getFreeCapacity() >= 1 then -- add to backpack
			-- addEvent(doAddPokeball, delayMessage, player:getId(), name, item.itemid)
			player:addPokemon(name, item.itemid)
		else
			player:addPokemon(name, item.itemid)
		end
		player:resetCatchTry(name)
		local playerLevel = player:getLevel()
		local maxExp = getNeededExp(playerLevel + 2) - getNeededExp(playerLevel)
		local maxExpShiny = getNeededExp(playerLevel + 5) - getNeededExp(playerLevel)

		addEvent(doSendMagicEffect, delay, toPosition, balls[ballKey].effectSucceed)
		addEvent(doPlayerSendTextMessage, delayMessage, player:getId(), MESSAGE_EVENT_ADVANCE, "Parabéns! Você pegou um " .. name .. "!, Seu Pokemon Foi Para O Depot!.")
		addEvent(doPlayerSendEffect, delayMessage, player:getId(), 179)
	else
		addEvent(doSendMagicEffect, delay, toPosition, balls[ballKey].effectFail)
		addEvent(doPlayerSendEffect, delayMessage, player:getId(), 170)
		addEvent(function() 
				if Player(player:getId()) then
					player:addCatchTry(name, BALLS_CATCH_ID[item.itemid], pontos)
				end 
			end,
		delay)
		return true
	end	

	return true
end
