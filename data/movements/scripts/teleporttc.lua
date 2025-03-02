function onStepIn(creature, item, position, fromPosition)

	if not creature:isPlayer() then return false end
	local teleport = Teleport(item.uid)
	if not teleport then return false end

	if item.actionid == 102 then -- entrance
		local destination = teleport:getDestination()
		local tileDestination = Tile(destination)
		if not tileDestination then return false end
		local itemsDestination = tileDestination:getItems()

		for i = 1, #itemsDestination do
			local itemDestination = itemsDestination[i]
			local teleportDestination = Teleport(itemDestination.uid)
			if teleportDestination then
				print("WARNING! Teleport on position " .. destination.x .. "," .. destination.y .. "," .. destination.z .. " sending to another teleport.")
				creature:teleportTo(creature:getTown():getTemplePosition())
				return false
			end
		end
		creature:setStorageValue(storageTeleportTc, creature:getPosition():getClosestTownId())

	elseif item.actionid == 103 then
		local town = Town(creature:getStorageValue(storageTeleportTc))
		if not town then
			town = Town("Saffron")
		end
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		creature:teleportTo(town:getTemplePosition())
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end
