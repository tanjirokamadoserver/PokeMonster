function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local monsterType = MonsterType(param)
	if not monsterType then
		player:sendCancelMessage("Pokemon not found.")
		return false		
	end

	player:addPokemon(param)
	return false
end
