local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(-1)

function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	if creature:getStorageValue(storageBike) > 0 then
		creature:sendCancelMessage("Sorry, not possible while on bicycle.")
		creature:teleportTo(fromPosition, false)
		return false
	end

--	if fromPosition.x == position.x and fromPosition.y == position.y and fromPosition.z == position.z then
--			print("check 1")
--		creature:teleportTo(creature:getTown():getTemplePosition())
--			print("check 2")
--		return true
--	end

	local outfit = 267

	if hasSummons(creature) then

		local summon = creature:getSummon()
		local summonName = summon:getName()
		local summonSpeed = summon:getTotalSpeed()
		local monsterType = MonsterType(summonName)
		local surfOutfit = monsterType:isSurfable()

		if surfOutfit > 0 then
			if surfOutfit > 1 then outfit = surfOutfit end
			creature:changeSpeed(summonSpeed)
			creature:setStorageValue(storageSurf, outfit)
			condition:setOutfit({lookType = outfit})
			creature:addCondition(condition)
			doRemoveSummon(creature:getId(), false, nil, false)
			creature:say(summonName .. ", let's surf!", TALKTYPE_SAY)
		else
			creature:sendCancelMessage("Sorry, not possible. You summon can not surf.")
			creature:teleportTo(fromPosition, false)
			return false		
		end

	else

		if creature:getStorageValue(storageSurf) == -1 then
			creature:sendCancelMessage("Sorry, not possible. You need a summon to surf.")
			creature:teleportTo(fromPosition, false)
			return false
		else
			local surfOutfit = creature:getStorageValue(storageSurf)
			condition:setOutfit({lookType = surfOutfit})
			creature:addCondition(condition)			
		end

	end
	return true
end

function onStepOut(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end
	local tile = Tile(creature:getPosition())

	if not tile or not tile:getGround() then
		return false
	end

	local tileId = tile:getGround():getId()
	if (not isInArray(waterIds, tileId) and position == fromPosition) or (creature:getStorageValue(storageDive) > 0) then
		creature:changeSpeed(creature:getBaseSpeed()-creature:getSpeed())
		creature:setStorageValue(storageSurf, -1)
		doReleaseSummon(creature:getId(), creature:getPosition(), false, false)
		creature:say("Thanks!", TALKTYPE_SAY)
	end

	if not (creature:getStorageValue(storageRide) > 0 or creature:getStorageValue(storageFly) > 0 or creature:getStorageValue(storageBike) > 0 or creature:getStorageValue(storageDive) > 0) then
		creature:removeCondition(CONDITION_OUTFIT)
	end
	return true
end
