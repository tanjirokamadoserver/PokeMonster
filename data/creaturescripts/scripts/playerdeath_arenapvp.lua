function onPrepareDeath(creature, killer)
	if creature:getStorageValue(storageArenaPvpEvent) == 2 then
		creature:teleportTo(creature:getTown():getTemplePosition())
		creature:addHealth(creature:getMaxHealth() - creature:getHealth())
		arenaPvpEventTryStop()
		creature:setStorageValue(storageArenaPvpEvent, -1)
		creature:setOutLeague()
		creature:unregisterEvent("PrepareDeathArenaPvp")
		return false
	end
	return true
end
