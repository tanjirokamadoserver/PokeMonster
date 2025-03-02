STORAGE_VIP = 1650000

function Player:addVipPlus(days)
	if not self:isVipPlus() then
		self:setStorageValue(STORAGE_VIP, os.time() + (days * 24 * 60 * 60))
	else
		local timeRemaining = self:getStorageValue(STORAGE_VIP)
		self:setStorageValue(STORAGE_VIP, timeRemaining + (days * 24 * 60 * 60))
	end
		self:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Você recebeu %d dias vip plus!", days))
	return true
end

function Player:isVipPlus()
	if self:getStorageValue(STORAGE_VIP) > os.time() then
		return true
	end
	return false
end

function Player:getVipPlusDaysFormatted()
	return convertTime(self:getStorageValue(STORAGE_VIP) - os.time())
end

function Player:sendVipPlusDays()
	self:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Você tem: %s VIP PLUS DAYS", self:getVipPlusDaysFormatted()))
end