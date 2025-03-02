local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition)
	if not target or type(target) ~= "userdata" then
		return true
	end
	local summon = player:getSummon()
	if not summon then return true end
	if target ~= summon then
		return true
	end

	for _, condition in pairs(CONST_NEGATIVE_CONDITIONS) do
		if summon:hasCondition(condition) then
			summon:removeCondition(condition)
		end
	end
	toPosition:sendMagicEffect(15)
	-- summon:say("Aahhh!", TALKTYPE_MONSTER_SAY)
    return true
end

action:id(27644)
action:allowFarUse(true)
action:register()