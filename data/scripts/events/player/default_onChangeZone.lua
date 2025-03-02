local event = Event()

function sendEffectZone(zone, area)
    local zoneAreas = zone:getRange()
    zoneArea = zoneAreas[area]

   local topLeft = zoneArea[1]
   local bottomRight = zoneArea[2]

   for x = topLeft.x, bottomRight.x do
       for y = topLeft.y, bottomRight.y do
           local pos = Position(x, y, 7)
        --    pos:sendMagicEffect(27)
		   Game.createItem(390, 1, pos)
        --    Game.sendAnimatedText(pos, "Zone Id:" .. zone:getId(), math.random(255))
       end
   end
end

-- /lua sendEffectZone(Zone(2), 5)

event.onChangeCustomZone = function(self, oldZone, newZone, isTeleport)
    if newZone then
		if newZone:getId() == ZONE_CEU and not isTeleport then
			self:sendTextMessage(MESSAGE_EVENT_DEFAULT, "Você não pode acessar!")
			return false
		end
		if newZone:getId() == 2 then
			sendEffectZone(newZone, 1)
			-- self:sendTextMessage(MESSAGE_EVENT_DEFAULT, "Você não pode acessar!")
			return false
		end
	end
	return true
end

event:register()