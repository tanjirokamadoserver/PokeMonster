local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookType = 267})
condition:setTicks(-1)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = item:getPosition()
	local newPosition = Position(position.x, position.y, position.z + 1)
	local tile = Tile(newPosition)

	if not tile then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	if tile:hasFlag(TILESTATE_PROTECTIONZONE) and player:isPzLocked() then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_PLAYERISPZLOCKED))
		return true
	end

	player:addCondition(condition)
	player:setStorageValue(storageDive, 1)
	player:teleportTo(newPosition, false)

	return true
end






