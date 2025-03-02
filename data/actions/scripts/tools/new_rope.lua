function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = item:getPosition()
	local newPosition = position:moveUpstairs()
	local tile = Tile(newPosition)

	if not tile then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	if tile:hasFlag(TILESTATE_PROTECTIONZONE) and player:isPzLocked() then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_PLAYERISPZLOCKED))
		return true
	end

	player:teleportTo(newPosition, false)
	return true
end
