function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local split = param:split(",")

	if split[3] == nil then
		player:sendCancelMessage("Insufficient parameters.")
		return false
	end

	local position = Position(split[1], split[2], split[3])
--	position = player:getClosestFreePosition(position, false)

	if position.x == 0 then
		player:sendCancelMessage("You cannot teleport there.")
		return false
	end

	player:teleportTo(position)
	return false
end
