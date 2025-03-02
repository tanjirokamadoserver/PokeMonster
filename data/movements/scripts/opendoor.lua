local range = 3
local rangeCheck = range - 1
local initialDoors = {34096, 34280}
local delayOpened = 4000

function doOpenDoor(tile, direction, initialDoor, count)
	if direction == "open" and count == 3 then --check if there are players around the door
		local position = tile:getPosition()
		position.x = position.x - 1
		for x = position.x - rangeCheck, position.x + rangeCheck do
			for y = position.y - rangeCheck, position.y + rangeCheck do
				if Tile(x, y, position.z):getCreatureCount() > 0 then
					addEvent(doOpenDoor, delayOpened, tile, direction, initialDoor, count)
					return
				end
			end
		end
	end
	local door = tile:getItemById(initialDoor - count)
	if door then
		if count >= 3 then direction = "close" end
		if direction == "close" and count == 0 then return end
		if direction == "open" then
			count = count + 1
		else
			count = count - 1
		end
		if direction == "open" and count == 3 then
			delay = delayOpened
		else
			delay = 200
		end
		door:transform(initialDoor - count)
		addEvent(doOpenDoor, delay, tile, direction, initialDoor, count)
	end
end

function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	for x = position.x - range, position.x + range do
		for y = position.y - range, position.y + range do
			local tile = Tile(x, y, position.z)
			if tile then
				local items = tile:getItems()
				local initialDoor
				if items then
					for i = 1, #items do
						local doorId = items[i]:getId()
						if isInArray(initialDoors, doorId) then
							initialDoor = doorId
						end
					end
				end
				 
				if initialDoor then
					doOpenDoor(tile, "open", initialDoor, 0)
					break
				end
			end
		end
	end

	return true
end
