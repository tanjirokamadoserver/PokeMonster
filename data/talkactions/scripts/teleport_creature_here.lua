function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local creature
	local newPosition

	-- Check if the input is in the format "x, y, z" (three numbers separated by commas)
	local x, y, z = param:match("(%d+), (%d+), (%d+)")
	if x and y and z then
		newPosition = Position(tonumber(x), tonumber(y), tonumber(z))
	else
		creature = Player(param)
		if not creature then
			player:sendCancelMessage("A player with that name could not be found.")
			return false
		end

		newPosition = player:getPosition() -- or creature:getClosestFreePosition(player:getPosition(), false)
		if newPosition and newPosition.x == 0 then
			player:sendCancelMessage("You cannot teleport " .. creature:getName() .. ".")
			return false
		end
	end

	if newPosition and creature then
		creature:teleportTo(newPosition)
		if not creature:isInGhostMode() then
			-- oldPosition:sendMagicEffect(CONST_ME_POFF)
			newPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	elseif newPosition then
		player:teleportTo(newPosition)
		newPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end

	return false
end
