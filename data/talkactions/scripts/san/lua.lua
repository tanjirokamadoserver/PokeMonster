function onSay(player, words, param)
    player = Player(player)
	-- if not player:getGroup():getAccess() then
	-- 	return true
	-- end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end
    _G.player = player
    local f, err = loadstring(param)
    if f then
        local ret, err = pcall(f)
        if not ret then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Lua error:\n" .. err)
        end
    else
       player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Lua error:\n" .. err)
    end

	return false
end