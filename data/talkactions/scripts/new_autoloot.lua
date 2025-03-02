function onSay(player, words, param)
	if player:isAutoLooting() then
		player:disableAutoLoot()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Autoloot desativado.")
	else
		player:enableAutoLoot()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Autoloot ativado.")
	end
	return false
end
