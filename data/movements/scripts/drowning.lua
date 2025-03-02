local condition = Condition(CONDITION_DROWN)
condition:setParameter(CONDITION_PARAM_PERIODICDAMAGE, -10)
condition:setParameter(CONDITION_PARAM_TICKS, -1)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 2000)

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if player == nil then
		return true
	end

	if math.random(1, 10) == 1 then
		position:sendMagicEffect(CONST_ME_BUBBLES)
	end
	if math.random(1, 100) <= 10 then
		player:addCondition(condition)
	end
	return true
end

function onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if player == nil then
		return true
	end

	player:removeCondition(CONDITION_DROWN)
	return true
end
