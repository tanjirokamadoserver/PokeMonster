local creatureevent = CreatureEvent("onLoginRev")

function creatureevent.onLogin(player)
	-- player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "Welcome!")
	return true
end

creatureevent:register()


local creatureevent = CreatureEvent("onLogoutRev")

function creatureevent.onLogout(player)
	return true
end

creatureevent:register()