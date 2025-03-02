function Creature:onChangeOutfit(outfit)
	if self:isPlayer() then
		if self:isOnEvent() then
			return false
		end
		-- if self:isOnFly() or self:isOnRide() or self:isOnSurf() or self:isOnDive() or self:isOnEvent() then
		-- 	return false
		-- end
	end
	return true
end

function Creature:onAreaCombat(tile, isAggressive)
	if hasEventCallback(EVENT_CALLBACK_ONAREACOMBAT) then
		return EventCallback(EVENT_CALLBACK_ONAREACOMBAT, self, tile, isAggressive)
	else
		return RETURNVALUE_NOERROR
	end
end

function Creature:onTargetCombat(target)
	if not self then return false end
	if self:isPlayer() and target:isMonster() then
		if isSummon(target) and target:getMaster():isNpc() and not self:isDuelingWithNpc() then
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
		if isSummon(target) and target:getMaster() == self then
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
	elseif self:isPlayer() and target:isPlayer() then
		if hasSummons(target) then
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
	elseif self:isMonster() and target:isPlayer() then
		if isSummon(self) and self:getMaster():isNpc() then
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
		if hasSummons(target) then
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
	elseif self:isMonster() and target:isMonster() then
		if isSummon(self) and isSummon(target) and target:getMaster():isNpc() and self:getMaster():isPlayer() and not self:getMaster():isDuelingWithNpc() then
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
		if isSummon(self) and isSummon(target) and self:getMaster():isNpc() and target:getMaster():isPlayer() and not target:getMaster():isDuelingWithNpc() then
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
	end
	return RETURNVALUE_NOERROR
end

function Creature:onChangeZone(oldZone, newZone, isTeleport)
	return hasEvent.onChangeCustomZone and Event.onChangeCustomZone(self, oldZone, newZone, isTeleport)
end