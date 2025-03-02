customTitles = {
    ["Gabe"]             = {title = "<STAFF>",      font = "proximanova-bold-16", color = "#f01d32"},
    ["Icaro"]               = {title = "</STAFF>",  	font = "proximanova-bold-16", color = "#f01d32"},
    ["Baia"]               = {title = "</STAFF>",  	font = "proximanova-bold-16", color = "#f01d32"},

}

HOLDER_IDS = {
	[22963] = 22964,
	[22964] = 22963,
	[22965] = 22966,
	[22966] = 22965,
}

CONST_RESET_POINTS = 102231
CONST_MEGA_RESET_POINTS = 102331

playerIps = {}
playerLoginStatus = {}
registerEvents = {"partyUpdate", "OutfitTask", "GlobalBoss", "GlobalBossHeld", "spawnCatchPokes", "pixApi", "GameStoreExtended", "Dropmalefic", "GlobalBoss", "PlayerDeath", "DropLoot", "AutoLoot", "MonsterHealthChange", "pokehp", "ExtendedOpcode", "FlyEvent", "MaleficBoss"}
MAX_PLAYERS_PER_IP = 1
playersLiberados = {"Icaro", "Baia", "Gabe"}

function Player:loginHandler()
    self:iconsHandler()
    self:titleHandler()
	self:sendShopData()
    self:resetStorages()
    self:sendExtendedOpcode(67, json.encode(bossesToSend))
    self:registerEvents()
    self:startOnlinePoints()
    self:sendLoginMessages()
	self:sendBrokesToPlayer()
    self:checkCondition() -- //TODO: refazer saporra
	sendDexLists(self)
    -- doSendDonationGoalsInformation(self)
    self:addSlotItems()
    nextUseStaminaTime[self.uid] = 0
	self:setCapacity(6)
    playerLoginStatus[self:getName()] = true
	self:admLogin()
    return true
end

function Player:admLogin()
    if(not self:getGroup():getAccess()) or self:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
    end
	--self:setGhostMode(true)
end

function Player:checkCondition()
	if self:isOnDive() then
		doSetCreatureOutfit(self:getId(), {lookType = 267})
		return
	end

	local usingball = nil
	local balls = self:getPokeballsCached()

	for _, ball in ipairs(balls) do
		if ball:getSpecialAttribute("isBeingUsed") == 1 then
			usingball = ball
			break
		end
	end

	if not usingball then
		return
	end

	local summonName = usingball:getPokeName()
	local monsterType = MonsterType(summonName)
	if not monsterType then
		usingball:setSpecialAttribute("isBeingUsed", 0)
		return error(("[MonsterType - ERROR]: Não existe: %s"):format(summonName))
	end
	local totalSpeed = monsterType:getBaseSpeed()

	local isOnMount = false
    if self:isOnSurf() then
		self:changeSpeed(self:getSpeed() + totalSpeed)
		isOnMount = true
	elseif self:isOnRide() then
		self:changeSpeed(self:getSpeed() + totalSpeed)
		doSetCreatureOutfit(self:getId(), {lookType = monsterType:isRideable()})
		isOnMount = true
	elseif self:isOnFly() then
		local heldType = "wing"
		local ident = usingball:getAttribute(ITEM_ATTRIBUTE_HELDY)
		local isWingHeld = isHeld(heldType, ident)
		if isWingHeld then
			local tier = HELDS_Y_INFO[ident].tier
			local bonusHeld = HELDS_BONUS[heldType][tier]
			totalSpeed = totalSpeed + bonusHeld
		end

		self:changeSpeed(self:getSpeed() + totalSpeed)
		doSetCreatureOutfit(self:getId(), {lookType = monsterType:isFlyable()})
		self:activateFly()
		isOnMount = true
	end

	if not isOnMount then
		usingball:setSpecialAttribute("isBeingUsed", 0)
		return
	end
	self:setUsingPokeball(usingball)
end

function Player:iconsHandler()
    local playerName = self:getName()
    if bossRanking[playerName] then
        local rank = bossRanking[playerName]
        self:addCustomIcon(imagesBossRanking[rank].image, imagesBossRanking[rank].x, imagesBossRanking[rank].y)
    end
end

function Player:resetStorages()
    self:setStorageValue(235760, -1) -- reseta storage da minera??o.
    self:setStorageValue(235165, -1) -- reseta storage da coleta.
    self:setStorageValue(604000, -1) -- reseta storage da .
    self:setStorageValue(604000,0)
	self:setStorageValue(storageEvolving, -1)
	self:setStorageValue(storageEvolutionAncient, -1)
	self:setStorageValue(storageEvent, -1)
end

function Player:registerEvents()
	for _, event in pairs(registerEvents) do
		self:registerEvent(event)
	end
end

function Player:titleHandler()
    local playerName = self:getName()
    local info = customTitles[playerName]
    if info then
        self:sendFirstTitle(info.title, info.font, info.color)
	else
		if self:isVipPlus() then
			self:sendFirstTitle("VIP+", "proximanova-bold-16", "#a763ee")
		elseif self:isPremium() then
			self:sendFirstTitle("VIP", "proximanova-bold-16", "#a763ee")
		end
    end
end

function Player:sendLoginMessages()
    local loginStr = ""
	if self:getLastLoginSaved() <= 0 then
		self:enableAutoLoot()
	else

		self:sendTextMessage(MESSAGE_STATUS_DEFAULT, "Bem vindo ao " .. configManager.getString(configKeys.SERVER_NAME) .. "!")

		loginStr = string.format("Sua ultima visita foi em %s.", os.date("%a %b %d %X %Y", self:getLastLoginSaved()))
	end

	if ACTIVE_ZONE_EVENT then
		loginStr = loginStr .. "\n" .. string.format("[ZONE-EVENT] type: %s, zona: %s, rate: %d", ACTIVE_ZONE_TYPE, ACTIVE_ZONE_NAME, ACTIVE_ZONE_EVENT_RATE_LOOT)
	end

    local onlinePoints = self:getStorageValue(71344)
	if onlinePoints > 0 then
		loginStr = loginStr .. string.format("\nVocê está com: %d Online Points.", onlinePoints)
	else
		self:setStorageValue(71344,0)
		loginStr = loginStr .. "\nVocê está com: 0 Online Points."
	end

	if tonumber(getGlobalStorageValue(1)) > os.time() then 
		loginStr = loginStr .. "\nDouble exp ativo no servidor!"
	end

	if tonumber(getGlobalStorageValue(2)) > os.time() then 
		loginStr = loginStr .. "\nDouble loot ativo no servidor!"
	end

	if self:isVipPlus() then
		self:sendVipPlusDays()
	end

	self:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, loginStr)
end

function Player:startOnlinePoints()
	local pid = self:getId()
	addEvent(addOnlineBonus, 60000, pid)
end

function realPrint(...)
	io.flush()
	print(...)
	io.flush()
end

function Player:showOutfit(outfitId)
	local monster = Game.createMonster("Arbok", self:getPosition(), true, true, 0, 0)
	doSetCreatureOutfit(monster, {lookType = outfitId}, -1)
end

ICONES_RANKS_POKEMONS = {
	["A"] = {image = "A", offset = {x = -25, y = -5}},
	["A+"] = {image = "A+", offset = {x = -25, y = -5}},
	["S"] = {image = "S", offset = {x = -35, y = -5}},
	["S+"] = {image = "S+", offset = {x = -35, y = -5}},
	["SS"] = {image = "SS", offset = {x = -45, y = -5}},
	["SS+"] = {image = "SS+", offset = {x = -45, y = -5}},
	["SSS"] = {image = "SSS", offset = {x = -45, y = -5}},
	["SSS+"] = {image = "SSS+", offset = {x = -45, y = -5}},
	["U"] = {image = "U", offset = {x = -45, y = -5}},
	["U+"] = {image = "U+", offset = {x = -45, y = -5}},
	["OP"] = {image = "OP", offset = {x = -40, y = -5}},
	["OP+"] = {image = "OP+", offset = {x = -40, y = -5}},
	["DEUS"] = {image = "DEUS", offset = {x = -32, y = -10}},
	["DEUS+"] = {image = "DEUS+", offset = {x = -35, y = -10}},
}

function Monster:setRankIcon(full)
	local pokeRank = self:getRank()
	if full then
		pokeRank = pokeRank .. "+"
	end
	if pokeRank then
		local icon = ICONES_RANKS_POKEMONS[pokeRank]
		if icon then
			self:addCustomIcon(icon.image .. "special", icon.offset.x, icon.offset.y)
			return true
		end
	end
	return false
end

function Player:requestModule(type)
	if type == "shop" then
		self:sendShopData()
	elseif type == "pokebar" then
		doSendPokeTeamByClient(self)
	end
end

function Player:shakeScreen(intensity, duration)
	local msg = NetworkMessage()
	msg:addByte(0x41)
	msg:addU32(intensity)
	msg:addU32(duration)
	msg:sendToPlayer(self)
	msg:delete()
end