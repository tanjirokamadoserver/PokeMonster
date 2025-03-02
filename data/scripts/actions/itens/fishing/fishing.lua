fishingTable = {
	["waters"] = { 4620 },

    zones = {
        ["Kanto"] = {
            from = { x = 1032, y = 1092, z = 7 },
            to = { x = 1034, y = 1098, z = 7 }
        },
        ["Hoenn"] = {
            from = { x = 1045, y = 1091, z = 7 },
            to = { x = 1041, y = 1098, z = 7 }
        }
    },

	iscas = {
        ["Default"] = {
            [-1] = { "Staryu" },                                                      -- none
            [3976] = { "Horsea", "Staryu", "Krabby", "Chinchou", "Shellos", "Buizel" }, -- worm
        },
        ["Kanto"] = {
            [-1] = { "Magikarp" },                                                      -- none
            [3976] = { "Horsea", "Staryu", "Krabby", "Chinchou", "Shellos", "Buizel" }, -- worm
        },
        ["Hoenn"] = {
            [-1] = { "Horsea" },                                                      -- none
            [3976] = { "Horsea", "Staryu", "Krabby", "Chinchou", "Shellos", "Buizel" }, -- worm
        }
	},

	iscasStorage = 1000000,  -- storage da isca / armazena o id da isca.
	isFishing = 1000001,     -- storage do player / checa se está pescando
	boia = 41631,            -- id do item da boia na agua.
	efeito = 342,            -- efeito na agua de bolha
	maxDistanceToFish = 6,   -- distancia maxima para pescar
	tempoMin = 3000,         -- minimo tempo para pescar
	tempoMax = 6000,         -- maximo tempo para pescar
	maxPokes = 5,            -- maximo de pokemons pescados
	expPesca = 1,            -- exp da pesca
	maxNivelPesca = 150,     -- nivel maximo da pesca
	chanceQuebrarLinha = 10, -- chance de quebrar a linha
	chanceTesouro = 15,      -- chance de vir o tesouro
	tesouros = {
		{ itemId = 2160, quantity = 1, rarity = "Raro" },
		{ itemId = 2160, quantity = 1, rarity = "Ultra Raro" },
		{ itemId = 2160, quantity = 1, rarity = "comum" },
		{ itemId = 2160, quantity = 1, rarity = "facil" },
		{ itemId = 2160, quantity = 1, rarity = "super dificil" },
	}
}

local ActionFish = Action()
function ActionFish.onUse(player, item, fromPosition, target, toPosition)
	if not isInArray(fishingTable.waters, getTileInfo(toPosition).itemid) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	if player:isOnRide() or player:isOnFly() or player:isOnSurf() or player:isOnBike() or player:isOnEvent()then
		return player:sendCancelMessage("Você não pode pescar enquanto está em condição especial.")
	end

	if isInArray(fishingTable.waters, getTileInfo(getThingPos(player)).itemid) then
		return player:sendCancelMessage("Você não pode pescar se estiver dentro da água.")
	end

	if getTileInfo(getThingPos(player:getSummons() and player:getSummons()[1] or player)).protection or getTileInfo(getThingPos(player)).protection then
		return player:sendCancelMessage("Você não pode pescar se você ou seu pokemon estiver em uma zona de proteção.")
	end

	if player:isFishing() then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	if isFishFar(player:getPosition(), toPosition) then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Você não tem forças suficientes para arremessar até lá!')
	end

    local isca = player:getIscaPlayer()
	if isca ~= -1 and not player:removeItem(isca, 1) then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sem iscas. compre uma isca no vendedor mais próximo para continuar com sua pesca!")
	end

	player:startFishing(toPosition)
    return true
end

ActionFish:id(2580)
ActionFish:allowFarUse(true)
ActionFish:register()

local iscas = {
   [3976] = { fishLevel = 1, level = 100 },
}

local ActionIsca = Action()
function ActionIsca.onUse(player, item, fromPosition, target, toPosition)
    local isca = iscas[item.itemid]
    local sto = fishingTable.iscasStorage

    if player:getSkillLevel(6) < isca.fishLevel then
       return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você precisa de fishing nível: " .. isca.fishLevel .. " para usar essa isca.")
    end

    if player:getLevel() < isca.level then
       return player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa de level " .. isca.level .. " para usar essa isca.")
    end

    if player:getStorageValue(sto) == -1 then
       player:setStorageValue(sto, item.itemid)
       player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'A sua isca foi colocada na vara de pesca.')
    else
       player:setStorageValue(sto, -1)
       player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'A sua isca foi retirada da vara de pesca.')
    end
    return true
end

for isca in pairs(iscas) do
    ActionIsca:id(isca)
end

ActionIsca:register()

function Player:getIscaPlayer()
	return self:getStorageValue(fishingTable.iscasStorage)
end

function Player:peixeAleatorio(toPosition)
	local iscaPokemon = fishingTable.iscas[toPosition:getFishingZone()][self:getIscaPlayer()]
	local pokemonAleatorio = math.random(#iscaPokemon)
	return iscaPokemon[pokemonAleatorio]
end

function Player:startFishing(toPos)
	local tile = Tile(toPos)
	if not tile then
		return false
	end

	self:setStorageValue(fishingTable.isFishing, 1)

	local pesca = Game.createItem(fishingTable.boia, 1, toPos)
	pesca:setAttribute("name", "uma boia. Pertence a: " .. self:getName())

	local timeFish = math.random(fishingTable.tempoMin, fishingTable.tempoMax)
	local quantidade = math.random(1, fishingTable.maxPokes)

	-- self:setNoMove(true)
    self:setMovementBlocked(true)
    local playerOutfit = self:getOutfit()

    local outfits = {
        [PLAYERSEX_FEMALE] = 2902,
        [PLAYERSEX_MALE] = 2902,
    }

    playerOutfit.lookType = outfits[self:getSex()]

    doSetCreatureOutfit(self, playerOutfit, timeFish)

	addEvent(doSendMagicEffect, timeFish / 2, toPos, fishingTable.efeito)
	addEvent(doSendMagicEffect, timeFish / 3, toPos, fishingTable.efeito)
	addEvent(doSendMagicEffect, timeFish, toPos, fishingTable.efeito)

    local fishDirection = getLookToFish(self:getPosition(), toPos)

	self:setDirection(fishDirection)

	local selfId = self:getId()
	addEvent(function()
		local player = Player(selfId)
		if player then
			player:fishPoke(player:peixeAleatorio(toPos), quantidade, toPos)
		end
	end, timeFish)
end

function Player:fishPoke(poke, qnt, toPos)
	self:stopFishing(toPos)

	local chanceQuebrarLinha = math.random(fishingTable.chanceQuebrarLinha)
	local chancePescarTesouro = math.random(fishingTable.chanceTesouro)

	if chancePescarTesouro >= math.random(100) then
		local tesouro = fishingTable.tesouros[math.random(#fishingTable.tesouros)]
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, ("Você pescou um tesouro de categoria: %s, meus parabens!"):format(tesouro.rarity))
		self:addItem(tesouro.itemId, tesouro.quantity)
		if self:getSkillLevel(6) <= fishingTable.maxNivelPesca then
			self:addSkillTries(6, fishingTable.expPesca)
		end
		return true
	end

	if chanceQuebrarLinha >= math.random(100) then
		return true and self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "o pokémon quebrou a linha e fugiu!!!!!")
	end

	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você pescou um " .. poke .. "!")

	for v = 1, qnt do
		Game.createMonster(poke, self:getPosition())
	end

	if self:getSkillLevel(6) <= fishingTable.maxNivelPesca then
		self:addSkillTries(6, fishingTable.expPesca)
	end
end

function clearFishing(baitPos, ownerFloater)
	for stack = 1, 10, 1 do
		baitPos.stackpos = stack
		local item = getThingfromPos(baitPos)
		if item and fishingTable.boia == item.itemid then
			local item = Item(item.uid)
			local name = item and item:getAttribute("name") or ""
			local player = name:match("uma boia. Pertence a: (.*)")
			if not ownerFloater or player == ownerFloater then
				if item then
					item:remove()
				end
				break
			end
		end
	end
end

function Player:stopFishing(baitPos)
    self:setMovementBlocked(false)
    self:setStorageValue(fishingTable.isFishing, -1)
	clearFishing(baitPos, self:getName())
	self:removeCondition(CONDITION_OUTFIT)
end

function isFishFar(from, to)
	if math.abs(from.y - to.y) > fishingTable.maxDistanceToFish or
		math.abs(from.x - to.x) > fishingTable.maxDistanceToFish then
		return true
	end
	return false
end

function Player:isFishing()
	return self:getStorageValue(fishingTable.isFishing) == 1 and true or false
end

function getLookToFish(pos, pos2)
	local x1, y1 = pos.x, pos.y
	local x2, y2 = pos2.x, pos2.y

	if x1 - x2 <= 0 and y1 - y2 > 0 then
		return DIRECTION_NORTH
	elseif x1 - x2 < 0 and y1 - y2 == 0 then
		return DIRECTION_EAST
	elseif x1 - x2 > 0 and y1 - y2 < 0 then
		return DIRECTION_SOUTH
	elseif x1 - x2 > 0 and y1 - y2 <= 0 then
		return DIRECTION_WEST
	elseif x1 - x2 > 0 and y1 - y2 >= 0 then
		return DIRECTION_WEST
	elseif x1 - x2 < 0 and y1 - y2 < 0 then
		return DIRECTION_EAST
	elseif x1 - x2 == 0 and y1 - y2 < 0 then
		return DIRECTION_SOUTH
	end
	return DIRECTION_WEST
end

function Position:getFishingZone()
    for zone, t in pairs(fishingTable.zones) do
        if self.x >= t.from.x and self.y >= t.from.y and self.x <= t.to.x and self.y <= t.to.y then
            return zone
        end
    end
    return "Default"
end

local creatureEvent = CreatureEvent("OnLoginFishing")
function creatureEvent.onLogin(player)
    player:setStorageValue(fishingTable.isFishing, -1)
    return true
end
creatureEvent:register()