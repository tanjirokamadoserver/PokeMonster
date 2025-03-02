function onPrepareDeath(creature, killer)
	if creature:getStorageValue(storageArenaEvent) == 2 then
		arenaLastPlayerId = creature:getId()
		creature:teleportTo(creature:getTown():getTemplePosition())
		creature:addHealth(creature:getMaxHealth() - creature:getHealth())
		arenaEventTryStop()
		creature:setStorageValue(storageArenaEvent, -1)
		creature:unregisterEvent("PrepareDeathArena")
		return false
	end
	return true
end
