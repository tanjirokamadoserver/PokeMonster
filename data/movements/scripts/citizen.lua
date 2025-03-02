actionIds = {
	sandHole = 100, -- hidden sand hole
	pickHole = 105, -- hidden mud hole
	drawWell = 106, -- draw well teleport
	levelDoor = 1000, -- level door
	citizenship = 30020, -- citizenship teleport
	citizenshipLast = 30050, -- citizenship teleport last
}

function onStepIn(creature, item, position, fromPosition)
	if item.actionid > actionIds.citizenship and item.actionid < actionIds.citizenshipLast then
		if not creature:isPlayer() then
			return false
		end
		local town = Town(item.actionid - actionIds.citizenship)
		if not town then
			return false
		end
		creature:setTown(town)
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are now a citizen of " .. town:getName() .. ".")
	end
	return true
end