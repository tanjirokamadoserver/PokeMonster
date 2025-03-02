local hyperPotion = 27643
-- se quiser pode criar uma variavel aqui pra adicionar nova potion, ou pode só colocar lá em baixo o ID direto:  itemId = 12345 exemplo<

local totaltime = 5  -- seconds 


local exhaust = Condition(CONDITION_EXHAUST_HEAL)
exhaust:setParameter(CONDITION_PARAM_TICKS, totaltime * 1000)
-- 1000 - 100 due to exact condition timing. -100 doesn't hurt us, and players don't have reminding ~50ms exhaustion.

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target == nil or not isSummon(target) then
	player:say("This potion can only be consumed by pokemons.", TALKTYPE_MONSTER_SAY)
		return true
	end

	if player:getCondition(CONDITION_EXHAUST_HEAL) then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_YOUAREEXHAUSTED))
		return true
	end

	local itemId = item:getId()

	if itemId == hyperPotion then
		
		local health = target:getTotalHealth() / 20 -- 5%
		
		local condition = Condition(CONDITION_REGENERATION)
		condition:setParameter(CONDITION_PARAM_SUBID, 3)
		condition:setParameter(CONDITION_PARAM_TICKS, totaltime * 1000) -- se ele esta curando por 10 segundos, vai curar 50% ( health(5%) x 10 )
		condition:setParameter(CONDITION_PARAM_HEALTHGAIN, health) -- quantidade de cura. ( 5% )
		condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 1000) -- a cada quantos segundos vai curar// 1000 = 1s
		condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	
			
		target:addCondition(condition)	
		player:addCondition(exhaust)
		
		target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
		item:remove(1)
	elseif itemId == 27646 then

		 local health = target:getTotalHealth() / 10 -- 5%

		 local condition = Condition(CONDITION_REGENERATION)
		 condition:setParameter(CONDITION_PARAM_SUBID, 3)
		 condition:setParameter(CONDITION_PARAM_TICKS, totaltime * 1000) -- se ele esta curando por 10 segundos, vai curar 50% ( health(5%) x 10 )
		 condition:setParameter(CONDITION_PARAM_HEALTHGAIN, health) -- quantidade de cura. ( 5% )
		 condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 1000) -- a cada quantos segundos vai curar// 1000 = 1s
		 condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)


		 target:addCondition(condition)
		 player:addCondition(exhaust)

		 target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
		 item:remove(1)
		 	elseif itemId == 27642 then

		 local health = target:getTotalHealth() / 35 -- 5%

		 local condition = Condition(CONDITION_REGENERATION)
		 condition:setParameter(CONDITION_PARAM_SUBID, 3)
		 condition:setParameter(CONDITION_PARAM_TICKS, totaltime * 1000) -- se ele esta curando por 10 segundos, vai curar 50% ( health(5%) x 10 )
		 condition:setParameter(CONDITION_PARAM_HEALTHGAIN, health) -- quantidade de cura. ( 5% )
		 condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 1000) -- a cada quantos segundos vai curar// 1000 = 1s
		 condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)


		 target:addCondition(condition)
		 player:addCondition(exhaust)

		 target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
		 item:remove(1)
		 	elseif itemId == 27647 then

		 local health = target:getTotalHealth() / 22 -- 5%

		 local condition = Condition(CONDITION_REGENERATION)
		 condition:setParameter(CONDITION_PARAM_SUBID, 3)
		 condition:setParameter(CONDITION_PARAM_TICKS, totaltime * 1000) -- se ele esta curando por 10 segundos, vai curar 50% ( health(5%) x 10 )
		 condition:setParameter(CONDITION_PARAM_HEALTHGAIN, health) -- quantidade de cura. ( 5% )
		 condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 1000) -- a cada quantos segundos vai curar// 1000 = 1s
		 condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)


		 target:addCondition(condition)
		 player:addCondition(exhaust)

		 target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
		 item:remove(1)
		 	elseif itemId == 27641 then

		 local health = target:getTotalHealth() / 18 -- 5%

		 local condition = Condition(CONDITION_REGENERATION)
		 condition:setParameter(CONDITION_PARAM_SUBID, 3)
		 condition:setParameter(CONDITION_PARAM_TICKS, totaltime * 1000) -- se ele esta curando por 10 segundos, vai curar 50% ( health(5%) x 10 )
		 condition:setParameter(CONDITION_PARAM_HEALTHGAIN, health) -- quantidade de cura. ( 5% )
		 condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 1000) -- a cada quantos segundos vai curar// 1000 = 1s
		 condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)


		 target:addCondition(condition)
		 player:addCondition(exhaust)

		 target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
		 item:remove(1)

		-- pra criar nova potion é só fazer um elseif novo, \/ 
		
		--elseif itemId == ID_POTION then
		
		-- local health = target:getTotalHealth() / 20 -- 5%
		
		-- local condition = Condition(CONDITION_REGENERATION)
		-- condition:setParameter(CONDITION_PARAM_SUBID, 3)
		-- condition:setParameter(CONDITION_PARAM_TICKS, totaltime * 1000) -- se ele esta curando por 10 segundos, vai curar 50% ( health(5%) x 10 )
		-- condition:setParameter(CONDITION_PARAM_HEALTHGAIN, health) -- quantidade de cura. ( 5% )
		-- condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 1000) -- a cada quantos segundos vai curar// 1000 = 1s
		-- condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	
			
		-- target:addCondition(condition)	
		-- player:addCondition(exhaust)
		
		-- target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
		-- item:remove(1)
		
	end
	
	return true
end