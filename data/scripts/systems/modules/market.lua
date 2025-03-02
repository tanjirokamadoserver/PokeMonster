OPCODE_MARKET = 94
STORAGE_EXHAUST_MARKET = 1980000
EXHAUST_MARKET = 200
PAGE_SIZE_MARKET = 10
PAGE_SIZE_PLAYER = 10

CONST_MARKET_ZONE_ID = 3

local MARKET_BLOCKED_IDS = {
    [2160] = 0,
    [2152] = 0,
    [2148] = 0,
    [2270] = 0,
    [2382] = 0,
    [2580] = 0,
    [7731] = 0,
}

local players_exhausts = {}

local timer = {
	minute = 60,
	hour = 3600,
	day = 86400,
	week = 604800,
}

local itemDuration = timer.day * 2

function Player.sendMarketAbaPage(self, aba, page)
    local GUID = self:getGuid()
    local buffer = {
        type = "loadPage",
        page = page,
        abaSize = aba == 1 and getMarketItemsSize() or getPlayerMarketItemsSize(GUID),
        MARKET_DATA = aba == 1 and getMarketItemsPage(page, PAGE_SIZE_MARKET) or getPlayerMarketItemsPage(GUID, page, PAGE_SIZE_PLAYER),
        realTime = os.time(),
    }
    sendJSON(self, "sendInformations", buffer, OPCODE_MARKET)
end

function Player.sendNotify(self, data)
    sendJSON(self, "sendInformations", data, OPCODE_MARKET)
end

function Item.isValidMarketItem(self, player)
    local topParent = self:getTopParent()
    if topParent ~= player then
        return false
    end

    local id = self:getId()
    if MARKET_BLOCKED_IDS[id] then
        return false
    end
    if self:isContainer() and #self:getItems() > 0 then
        return false
    end
    if self:isBeingUsed() then
        return false
    end
    return true
end

function isValidNumber(value)
    return not value or value ~= value or value == math.huge or value == -math.huge
end

function Player.refreshMarket(self, data)
    local lastTime = math.max(0, self:getStorageValue(STORAGE_EXHAUST_MARKET))
    if os.time() - lastTime < 5 then
        return
    else
        self:setStorageValue(STORAGE_EXHAUST_MARKET, os.time())
    end

    local page = tonumber(data.page)
    local aba = tonumber(data.aba)
    if not page or not aba or isValidNumber(page) or page < 1 or isValidNumber(aba) or (aba < 1 or aba > 2) then
        return self:popupFYI("Página inválida, tente novamente.")
    end

    self:sendMarketAbaPage(aba, page)
    return true
end

function Player.loadMarketPage(self, data)
    local page = tonumber(data.page)
    local aba = tonumber(data.aba)
    if not page or not aba or isValidNumber(page) or page < 1 or isValidNumber(aba) or (aba < 1 or aba > 2) then
        return self:popupFYI("Página inválida, tente novamente.")
    end

    self:sendMarketAbaPage(aba, page)
    return true
end

function Player.checkMarketSelectedItem(self, data)
    local itemData = data.itemData
    local item = self:getItemByPos(itemData.position,
                                    itemData.stackpos, itemData.clientId)

    if not item then
        return self:popupFYI("Ocorreu um problema, selecione novamente o item.")
    end

    if not item:isValidMarketItem(self) then
        return self:popupFYI("Este item não pode ser vendido.")
    end

    local itemType = ItemType(item:getId())
    if not itemType then
        return self:popupFYI("Item inválido.")
    end

    self:setMarketSellItem(item)
    local maxQtd = 1
    if itemType:isStackable() then
        maxQtd = item:getCount()
    end
    local newBuffer = {
        type = "notify_item",
        clientId = itemType:getClientId(),
        maxQtd = maxQtd,
    }
    local pokeName = item:getCustomAttribute("pokeName")
    if pokeName then
        newBuffer.pokeballsInfo = {
            name = pokeName,
            boost = item:getCustomAttribute("boost") or 0,
        }
    end
    self:sendNotify(newBuffer)
end

function Player.trySellMarketItem(self, data)
    local item = self:canSellMarketItem()
    if not item then
        return self:popupFYI("Ocorreu um problema, selecione novamente o item.")
    end

    local count = item:getCount()
    local qtd = tonumber(data.qtd)
    local page = tonumber(data.page)

    if count < qtd or qtd < 1 then
        return self:popupFYI("Ocorreu um erro, tente novamente.")
    end
    local currency = tonumber(data.currency)
    local price = tonumber(data.price)

    if (not currency or not price or not qtd or isValidNumber(currency) or isValidNumber(price) or isValidNumber(qtd) or price < 1 or not page or isValidNumber(page) or page < 1) then
        return self:popupFYI("Ocorreu um problema na venda, tente novamente.")
    end

    if not isInArray({0, 1}, currency) then
        return self:popupFYI("Moeda inválida, tente novamente.")
    end

    addMarketItem(item, qtd, price, currency, self:getGuid(), data.anonymous)
    self:setMarketSellItem(nil)
    item:remove(qtd)
    local newBuffer = {
        type = "notify_success_post",
    }
    self:sendNotify(newBuffer)
    self:sendMarketAbaPage(2, page)
end

function Player.tryBuyMarketItem(self, data)
    local offerId = tonumber(data.offerId)
    local amount = tonumber(data.amount)
    local page = tonumber(data.page)
    if not offerId or not amount or not page or isValidNumber(offerId) or isValidNumber(amount) or isValidNumber(page) or amount < 1 or offerId < 1 or page < 1 then
        return self:popupFYI("Oferta inválida, tente novamente.")
    end

    local offer = getMarketItemById(offerId)

    if offer.created == 0 then
        return self:popupFYI("A Oferta não existe mais.")
    end

    local offerPlayerGUID = offer.playerId
    local playerGUID = self:getGuid()

    if offer.expired == true then
        return self:popupFYI("A Oferta expirou.")
    else
        if offer.created + itemDuration < os.time() then
            setMarketItemExpired(offerId)
            return self:popupFYI("A Oferta expirou.")
        end
    end

    if amount > offer.amount then
        return self:popupFYI("Quantidade de items inválida, tente novamente.")
    end

    if offerPlayerGUID == 0 then
        return self:popupFYI("A Oferta não existe mais.")
    end

    if playerGUID == offerPlayerGUID then
        return self:popupFYI("Você não pode comprar um item de si mesmo.")
    end
    local price = offer.price * amount

    local currency = offer.currency
    if currency == 0 then
        if self:getTotalMoney() < price then
            return self:popupFYI("Você não tem dinheiro suficiente.")
        end
    elseif currency == 1 then
        if getTotalDiamonds(self) < price then
            return self:popupFYI("Você não tem diamonds suficiente.")
        end
    end

    if currency == 0 then
        removePlayerMoney(self, price)
    elseif currency == 1 then
        removePlayerDiamond(self, price)
    end

    local seller = Player(offerPlayerGUID)
    if seller then
        if currency == 0 then
            local bankBalance = seller:getBankBalance()
            player:setBankBalance(bankBalance + price)
        elseif currency == 1 then
            db.query("UPDATE `players` set `diamond` = `diamond` + " .. price .. " WHERE `id` = " .. seller:getGuid())
        end
    else
        if currency == 0 then
            db.query("UPDATE `players` set `balance` = `balance` + " .. price .. " WHERE `id` = " .. offerPlayerGUID)
        elseif currency == 1 then
            db.query("UPDATE `players` set `diamond` = `diamond` + " .. price .. " WHERE `id` = " .. offerPlayerGUID)
        end
    end

    playerAddMarketItem(self, offerId, amount)
    if offer.amount == amount then
        removeMarketItem(offerId)
    else
        updateMarketItemAmount(offerId, (offer.amount - amount))
    end

    self:sendMarketAbaPage(1, page)
end

function Player.cancelMarketSell(self, data)
    local offerId = tonumber(data.offerId)
    local page = tonumber(data.page)
    if not offerId or not page or isValidNumber(offerId) or isValidNumber(page) or offerId < 1 or page < 1 then
        return self:popupFYI("Oferta inválida, tente novamente.")
    end

    local offer = getMarketItemById(offerId)

    if offer.created == 0 then
        return self:popupFYI("A Oferta não existe mais.")
    end

    local pidOffer = offer.playerId
    local playerGUID = self:getGuid()
    if pidOffer == 0 or playerGUID ~= pidOffer then
        return self:popupFYI("Um erro ocorreu, tente novamente.")
    end

    playerAddMarketItem(self, offerId, offer.amount)
    removeMarketItem(offerId)
    self:sendMarketAbaPage(2, page)
end

function Player.searchMarketItem(self, data)
    local textToSearch = tostring(data.text)
    local page = tonumber(data.page)
    local aba = tonumber(data.aba)
    local category = tonumber(data.category)

    -- print(textToSearch, category, page, aba)
    -- if not textToSearch or not page or not aba or not category or isValidNumber(page) or isValidNumber(aba) or isValidNumber(category) or page < 1 or category < 1 then
    --     return self:popupFYI("Pesquisa inválida, tente novamente.")
    -- end
    textToSearch = textToSearch:lower()
    local GUID = self:getGuid()
    local buffer = {
        type = "loadPage",
        subType = "loadedBySearch",
        text = textToSearch,
        category = category,
        page = page,
        abaSize = getMarketItemsByNameAndCategorySize(textToSearch, category),
        MARKET_DATA = getMarketItemsByNameAndCategory(textToSearch, category, page, PAGE_SIZE_MARKET),
        realTime = os.time(),
    }

    sendJSON(self, "sendInformations", buffer, OPCODE_MARKET)
end

local MARKET_ACTIONS = {
    ["loadPage"] = Player.loadMarketPage,
    ["refresh"] = Player.refreshMarket,
    ["checkSelectedItem"] = Player.checkMarketSelectedItem,
    ["trySellItem"] = Player.trySellMarketItem,
    ["cancelSell"] = Player.cancelMarketSell,
    ["tryBuyItem"] = Player.tryBuyMarketItem,
    ["search"] = Player.searchMarketItem,
}

function Player.handleMarket(self, buffer)
    -- if self:getZoneId() ~= CONST_MARKET_ZONE_ID then
    --     return false
    -- end

    local json_status, data = pcall(function() return json.decode(buffer) end)
    if not json_status then
        return error("Error parsing JSON - Player: " .. self:getName())
    end

    local timeNow = os.mtime()
    local guid = self:getGuid()

    if players_exhausts[guid] and players_exhausts[guid] > timeNow then
        return
    end
    players_exhausts[guid] = timeNow + EXHAUST_MARKET

    local action = data.type
    if MARKET_ACTIONS[action] then
        MARKET_ACTIONS[action](self, data)
    end
    return true
end

function sendJSON(player, action, data, opcode)
    local MAX_PACKET_SIZE = 50000
    local buffer = json.encode({action = action, data = data})
    local s = {}
    for i=1, #buffer, MAX_PACKET_SIZE do
       s[#s+1] = buffer:sub(i,i+MAX_PACKET_SIZE - 1)
    end
    local msg = NetworkMessage()
    if #s == 1 then
      msg:addByte(50)
      msg:addByte(opcode)
      msg:addString(s[1])
      msg:sendToPlayer(player)
      return
    end
    -- split message if too big
    msg:addByte(50)
    msg:addByte(opcode)
    msg:addString("S" .. s[1])
    msg:sendToPlayer(player)
    for i=2,#s - 1 do
      msg = NetworkMessage()
      msg:addByte(50)
      msg:addByte(opcode)
      msg:addString("P" .. s[i])
      msg:sendToPlayer(player)
    end
    msg = NetworkMessage()
    msg:addByte(50)
    msg:addByte(opcode)
    msg:addString("E" .. s[#s])
    msg:sendToPlayer(player)
end

local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    player:sendMarketAbaPage(1, 1)
    player:sendNotify({type = "toggle"})
    return true
end

action:id(34295)
action:register()

local creatureEvent = CreatureEvent("MarketLogout")
function creatureEvent.onLogout(player)
    players_exhausts[player:getGuid()] = nil
    return true
end
creatureEvent:register()