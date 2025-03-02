local configs = {
	[4644] = {x = 0, y = -1},
	[4645] = {x = 1, y = 0}, 
	[4646] = {x = 0, y = 1},
	[4647] = {x = -1, y = 0}, 
	[4656] = {x = 0, y = -1},
	[4657] = {x = 0, y = 1},
	[4658] = {x = -1, y = 0},
	[4659] = {x = 1, y = 0},
	[4660] = {x = 0, y = -1},
	[4661] = {x = 0, y = 1},
	[4662] = {x = -1, y = 0}, 
	[4663] = {x = 1, y = 0}, 
	[4828] = {x = 0, y = -1},
	[4829] = {x = 1, y = 0}, 
	[4830] = {x = 0, y = 1},
	[4831] = {x = -1, y = 0},
	[4632] = {x = 0, y = -1},
	[4633] = {x = -1, y = 0}, 
	[4634] = {x = 0, y = 1},
	[4635] = {x = 1, y = 0}, 
	[6627] = {x = 0, y = -1},
	[6628] = {x = 1, y = 0}, 
	[6629] = {x = 0, y = 1},
	[6630] = {x = -1, y = 0}, 
	[6639] = {x = 0, y = -1},
	[6640] = {x = 1, y = 0}, 
	[6641] = {x = 0, y = 1},
	[6642] = {x = -1, y = 0},
	[6651] = {x = 0, y = -1},
	[6652] = {x = 1, y = 0}, 
	[6653] = {x = 0, y = 1},
	[6654] = {x = -1, y = 0}, 
	[6655] = {x = 0, y = -1},
	[6656] = {x = 1, y = 0},
	[6657] = {x = 0, y = 1},
	[6658] = {x = -1, y = 0},
	[6659] = {x = 0, y = -1},
	[6660] = {x = 1, y = 0}, 
	[6661] = {x = 0, y = 1},
	[6662] = {x = -1, y = 0}, 
	[6663] = {x = 0, y = -1},
	[6664] = {x = 1, y = 0}, 
	[6665] = {x = 0, y = 1},
	[6666] = {x = -1, y = 0}, 
	[6667] = {x = 0, y = -1},
	[6668] = {x = 1, y = 0}, 
	[6669] = {x = 0, y = 1},
	[6670] = {x = -1, y = 0}, 
	[6671] = {x = 0, y = -1},
	[6672] = {x = 1, y = 0}, 
	[6673] = {x = 0, y = 1},
	[6674] = {x = -1, y = 0}, 
	[6675] = {x = 0, y = 1},
	[6676] = {x = 1, y = 0}, 
	[6687] = {x = 0, y = -1},
	[6688] = {x = 1, y = 0}, 
	[6689] = {x = 0, y = 1},
	[6690] = {x = -1, y = 0},
	[6691] = {x = 0, y = -1},
	[6692] = {x = 1, y = 0}, 
	[6693] = {x = 0, y = 1},
	[6694] = {x = -1, y = 0}, 
	[7188] = {x = -1, y = 0}, 
	[7191] = {x = 0, y = -1},
	[7192] = {x = 0, y = 1},
	[7194] = {x = 1, y = 0}, 
	[7943] = {x = 0, y = -1},
	[7944] = {x = -1, y = 0}, 
	[7945] = {x = 0, y = 1},
	[7946] = {x = 1, y = 0},
}
 

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(-1)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getZoneId() == ZONE_CEU then
		return player:getPosition():sendMagicEffect(3) and player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você não pode fazer isso nessa zona!") and true
	end

	if player:getStorageValue(storageBike) > 0 then
		player:sendCancelMessage("Sorry, not possible while on bicycle.")
		return true
	end
	
	if not player:getSummon() and player:getStorageValue(storageSurf) == -1 then
		player:sendCancelMessage("Sorry, not possible. You need a summon to surf.")
		return true
	end

 if not configs[item.itemid] then 
	return true
 end
	if hasSummons(player) then
		local summon = player:getSummon()
		local summonName = summon:getName()
		local summonSpeed = summon:getTotalSpeed()
		local monsterType = MonsterType(summonName)
		local surfOutfit = monsterType:isSurfable()
		if surfOutfit > 0 and player:getStorageValue(storageSurf) == -1 then
				if surfOutfit > 1 then outfit = surfOutfit end
				player:changeSpeed(summonSpeed)
				player:setStorageValue(storageSurf, outfit)
				condition:setOutfit({lookType = outfit})
				player:addCondition(condition)
				doRemoveSummon(player:getId(), false, nil, false)
				player:teleportTo({x=fromPosition.x+configs[item.itemid].x, y=fromPosition.y+configs[item.itemid].y, z=fromPosition.z}, true)
				player:say(summonName .. ", let's surf!", TALKTYPE_SAY)
				return true
			else
				player:sendCancelMessage("Sorry, not possible. You summon can not surf.")
				return true
		end
	else 
		if player:getStorageValue(storageSurf) > 1 then
				player:changeSpeed(player:getBaseSpeed()-player:getSpeed())
				player:setStorageValue(storageSurf, -1)
				doReleaseSummon(player:getId(), player:getPosition(), false, false)
				local summons = player:getSummons()
				if #summons == 0 then return false end
				local summon = Creature(summons[1])
				if not summon then return false end
				summon:teleportTo({x=fromPosition.x-configs[item.itemid].x, y=fromPosition.y-configs[item.itemid].y, z=fromPosition.z}, true)
				player:say("Thanks!", TALKTYPE_SAY)
				player:teleportTo({x=fromPosition.x-configs[item.itemid].x, y=fromPosition.y-configs[item.itemid].y, z=fromPosition.z}, true)
				player:removeCondition(CONDITION_OUTFIT)
				return false
		end 
	end

	return true
end