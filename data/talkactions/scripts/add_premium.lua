function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local split = param:split(",")
	local targetName = split[1]

	local target = Player(targetName)
	if target == nil then
		player:sendCancelMessage("A player with that name is not online.")
		return false
	end

	local days = split[2]
	if days == nil then
		days = 30
	end

	target:addPremiumDays(days)

	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You got " .. days .. " days of VIP.")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You gave " .. days .. " days of VIP to " .. target:getName() .. ".")
	return false
end
