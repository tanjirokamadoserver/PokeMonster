function onSay(player, words)
	if not player:isOnFly() then
		player:sendCancelMessage("You are not flying.")
		return false
	end

	if words == "h1" then
		local ret = player:upFly()
		if ret == false then
			player:sendCancelMessage("You can not fly up.")
		else
			player:ativeFly()
		end
	elseif words == "h2" then
		local ret = player:downFly()
		if ret == false then
			player:sendCancelMessage("You can not fly down.")
		else
			player:desativeFly()
		end
	end
	return false
end