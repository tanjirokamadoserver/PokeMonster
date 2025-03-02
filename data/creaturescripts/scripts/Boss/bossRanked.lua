local minute = 60
local maxPlayers = 35

local bossTimer = {
	["BOSS GLOBAL"] = 2 * minute
}

tmpBosses = {}

local rewards = {
	[1] =  {{id = 41454, qtd = 8}},
	[2] =  {{id = 26659, qtd = 6} },
	[3] =  {{id = 26660, qtd = 4} },
	[4] =  {{id = 26662, qtd = 2} },
	[5] =  {{id = 41470, qtd = 2} },
	[6] =  {{id = 41455, qtd = 2} },
	[7] =  {{id = 26683, qtd = 2} },
	[8] =  {{id = 41440, qtd = 2} },
	[9] =  {{id = 20708, qtd = 2} },
	[10] = {{id = 20708, qtd = 2} },
	[11] = {{id = 20708, qtd = 2} },
	[12] = {{id = 20708, qtd = 2} },
	[13] = {{id = 20708, qtd = 2} },
	[14] = {{id = 20708, qtd = 2} },
	[15] = {{id = 20708, qtd = 2} },
	[16] = {{id = 20708, qtd = 2} },
	[17] = {{id = 20708, qtd = 2} },
	[18] = {{id = 20708, qtd = 2} },
	[19] = {{id = 20708, qtd = 2} },
	[20] = {{id = 20708, qtd = 2} },
	[21] = {{id = 20708, qtd = 2} },
	[22] = {{id = 20708, qtd = 2} },
	[23] = {{id = 20708, qtd = 2} },
	[24] = {{id = 20708, qtd = 2} },
	[25] = {{id = 20708, qtd = 2} },
	[26] = {{id = 20708, qtd = 2} },
	[27] = {{id = 20708, qtd = 2} },
	[28] = {{id = 20708, qtd = 2} },
	[29] = {{id = 20708, qtd = 2} },
	[30] = {{id = 20708, qtd = 2} },
	[31] = {{id = 20708, qtd = 2} },
	[32] = {{id = 20708, qtd = 2} },
	[33] = {{id = 20708, qtd = 2} },
	[34] = {{id = 20708, qtd = 2} },
	[35] = {{id = 20708, qtd = 2} },
}
function Creature:doSendRewards()
	local damageMap = self:getDamageMap()
	local playersData = {}
	for user, data in pairs(damageMap) do
		local player = Player(user)
		if player then
			local totalDamage = data["total"] or 0
			playersData[player:getName()] = {damage = totalDamage}
		end
	end

	local sortable = {}
	for player, data in pairs(playersData) do
		table.insert(sortable, { name = player, damage = data.damage })
	end
	table.sort(sortable, function(a, b) return a.damage > b.damage end)
	
	for playerName, _ in pairs(bossRanking) do
		local player = Player(playerName)
		if player then
			for _, data in pairs(imagesBossRanking) do
				player:removeCustomIcon(data.image)
			end
		end
	end
	
	bossRanking = {}
	for i = 1,3 do
		db.query("UPDATE `boss_ranking` SET `player`='".. i .. "' WHERE classificacao = " .. i .. ";")
	end
	
	for i = 1, math.min(maxPlayers, #sortable) do
		
		local player = Player(sortable[i].name)
		if player then
			if i <= 3 then
				db.query("UPDATE `boss_ranking` SET `player`='".. player:getName() .. "' WHERE classificacao = " .. i .. ";")
				bossRanking[player:getName()] = i
			end
			local playerName = player:getName()
			if bossRanking[playerName] then
				local rank = bossRanking[playerName]
				player:addCustomIcon(imagesBossRanking[rank].image, imagesBossRanking[rank].x, imagesBossRanking[rank].y)
			end
			local text = "Itens recebidos: "
			for _, data in ipairs(rewards[i]) do
				player:addItem(data.id, data.qtd)
				text = text .. " " .. getItemName(data.id) .. " " .. data.qtd .. "x"
			end
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, text)
		end
	end

	tmpBosses[self:getId()] = nil
	self:remove()
end

function onThink(creature, interval)
	local selfId = creature:getId()
	local selfTimer = bossTimer[creature:getName()]
	if not tmpBosses[creature:getId()] then
		tmpBosses[creature:getId()] = 0
		creature:setBossStatus(true)
	end
	
	tmpBosses[creature:getId()] = tmpBosses[creature:getId()] + 1
	if tmpBosses[creature:getId()] > selfTimer then
		creature:doSendRewards()
		return true
	end

	local damageMap = creature:getDamageMap()
	
	if not next(damageMap) then return true end
	
	local playersData = {}
	for user, data in pairs(damageMap) do
		local player = Player(user)
		if player then
			local totalDamage = data["total"] or 0
			playersData[player:getName()] = {damage = totalDamage}
		end
	end

	local sortable = {}
	for player, data in pairs(playersData) do
		table.insert(sortable, { name = player, damage = data.damage })
	end
	table.sort(sortable, function(a, b) return a.damage > b.damage end)
	
	local spectators = Game.getSpectators(creature:getPosition())
	
	for _, creatureUserdata in pairs(spectators) do
		if creatureUserdata:isPlayer() then
			local playerName = creatureUserdata:getName()
			if playersData[playerName] then
				creatureUserdata:updateBossWindow(sortable, selfId)
			end
		end
	end

	return true
end

function Player:updateBossWindow(rank, bossId)
	local data = {
		type = "update",
		rank = rank,
		bossId = bossId
	}
	self:sendExtendedOpcode(69, json.encode(data))
end
function getItemName(itemId) return ItemType(itemId):getName() end