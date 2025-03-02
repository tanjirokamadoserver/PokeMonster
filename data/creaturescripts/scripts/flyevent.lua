function onMove(creature, toPosition, fromPosition)
	local player = Player(creature:getId())
	
	if player:getStorageValue(235760) >= 1 or player:getStorageValue(235165) >= 1 then
		player:setStorageValue(235760, -1) -- reseta storage da minera��o.
		player:setStorageValue(235165, -1) -- reseta storage da coleta.
		player:removeCondition(CONDITION_OUTFIT)
	end

    if player:isOnFly() then
      toPosition:createFlyFloor()
    end
    return true
end
