function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	if creature:getPremiumDays() < 1 then
		creature:sendTextMessage(MESSAGE_INFO_DESCR, "You need premium account to pass.")
		creature:teleportTo(fromPosition, true)
		return false
	end

	return true
end
