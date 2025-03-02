function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	for _, jogador in pairs(Game.getPlayers()) do
		jogador:teleportTo(Position(3089, 2904, 7))
	end
	
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Command Done.")
	return false
end
