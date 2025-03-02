function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end
	local parts = param:split(",")

	local position = player:getPosition()
	local qtd = parts[2] or 1
	for i = 1, qtd do
		local monster = Game.createMonster(parts[1], position, false, true)
		local outfit = monster:getOutfit()
		local newOutfit = {
			lookType = outfit.lookType,
			lookHead = (parts[3] or 0),
			lookBody = (parts[4] or 0),
			lookLegs = (parts[5] or 0),
			lookFeet = (parts[6] or 0),
			lookAddons = (parts[7] or 0)
		}

		if monster ~= nil then
			monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			monster:setOutfit(newOutfit)
		end
	end
	return false
end
