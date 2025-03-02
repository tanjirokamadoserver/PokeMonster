function onAdvance(player, skill, oldLevel, newLevel)
	-- player = Player(player)


	if skill ~= SKILL_LEVEL then
		return true
	end

	if player:getSummons() then
		local summons = player:getSummons()
		if not summons[1] then return true end
		local summon = Creature(summons[1])

		local maxHealth = summon:getTotalHealth()
		summon:setHealth(maxHealth)
	end


	return true
end
