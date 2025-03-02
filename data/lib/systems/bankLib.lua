OPCODE_BANK = 75

local currencies = {
    ["money"] = {moeda = 2148, clientId = 3031, money = true},
    ["diamonds"] = {moeda = CONSTANT_ITEM_DIAMOND, clientId = 25218, diamond = true},
    -- ["reset"] = {moeda = 23496, clientId = 22296, storage = true, query = false, stoInfo = {storageId = 32070}},
    -- ["online"] = {moeda = 23497, clientId = 22297, storage = true, query = false, stoInfo = {storageId = 71344}},
    -- ["torneio"] = {moeda = 23500, clientId = 22300, storage = true, query = false, stoInfo = {storageId = STORAGE_TORNEIO_COIN}},
    -- ["donate"] = {moeda = 23498, clientId = 22298, storage = false, query = true},
}

function Player:sendBankInfos()
    local currencyInfos = {}
    for currencyName, currencyData in pairs(currencies) do
        if currencyData.storage then
            currencyInfos[currencyName] = {itemId = currencyData.clientId, quantidade = math.max(0, self:getStorageValue(currencyData.stoInfo.storageId))}
        elseif currencyData.query then
            currencyInfos[currencyName] = {itemId = currencyData.clientId, quantidade = getPoints(self)}
        elseif currencyData.money then
            currencyInfos[currencyName] = {itemId = currencyData.clientId, quantidade = self:getBankBalance()}
        elseif currencyData.diamond then
            currencyInfos[currencyName] = {itemId = currencyData.clientId, quantidade = getDiamonds(self)}
        end
    end
    self:sendExtendedOpcode(OPCODE_BANK, json.encode(currencyInfos))
end

function Player:handleBank(buffer)
    if buffer == "require" then
        self:sendBankInfos()
        return true
    end
    local data = json.decode(buffer)
    if data then
        local id = data.id
        local value = data.value
        if value < 1 then return self:popupFYI("Operação Inválida.") end
        if value ~= value then return self:popupFYI("Operação Inválida.") end
        local type = data.type
        local currencyInfo = currencies[id]
        if currencyInfo then
            if type == "withdraw" then
                if currencyInfo.storage == true then
                    local storage = math.max(0, self:getStorageValue(currencyInfo.stoInfo.storageId))
                    if value <= storage then
                        self:setStorageValue(currencyInfo.stoInfo.storageId, storage - value)
                        if not self:addItem(currencyInfo.moeda, value) then
                            return error(string.format("[BANK-ERROR] Player: %s, teve problemas ao sacar: %s, quantidade: %d", self:getName(), id, value)) and self:popupFYI("[ERROR] foi reportado o problema, abra um ticket no discord.")
                        end
                        return self:popupFYI("Saque Bem sucedido!") and self:sendBankInfos()
                    end
                elseif currencyInfo.query == true then
                    local pontos = getPoints(self)
                    if value <= pontos then
                        db.query("UPDATE `accounts` set `pontos` = `pontos` - " .. value .. " WHERE `id` = " .. self:getAccountId())
                        if not self:addItem(currencyInfo.moeda, value) then
                            return error(string.format("[BANK-ERROR] Player: %s, teve problemas ao sacar: %s, quantidade: %d", self:getName(), id, value)) and self:popupFYI("[ERROR] foi reportado o problema, abra um ticket no discord.")
                        end
                        return self:popupFYI("Saque Bem sucedido!") and self:sendBankInfos()
                    end
                elseif currencyInfo.money == true then
                    local money = self:getBankBalance()
                    if value <= money then
                        self:setBankBalance(money - value)
                        if not self:addMoney(value) then
                            return error(string.format("[BANK-ERROR] Player: %s, teve problemas ao sacar: %s, quantidade: %d", self:getName(), id, value)) and self:popupFYI("[ERROR] foi reportado o problema, abra um ticket no discord.")
                        end
                        return self:popupFYI("Saque Bem sucedido!") and self:sendBankInfos()
                    end
                elseif currencyInfo.diamond == true then
                    local diamonds = getDiamonds(self)
                    if value <= diamonds then
                        db.query("UPDATE `players` set `diamond` = `diamond` - " .. value .. " WHERE `id` = " .. self:getGuid())
                        if not self:addItem(currencyInfo.moeda, value) then
                            return error(string.format("[BANK-ERROR] Player: %s, teve problemas ao sacar: %s, quantidade: %d", self:getName(), id, value)) and self:popupFYI("[ERROR] foi reportado o problema, abra um ticket no discord.")
                        end
                        return self:popupFYI("Saque Bem sucedido!") and self:sendBankInfos()
                    end
                end
            elseif type == "deposit" then
                if currencyInfo.storage == true then
                    local storage = math.max(0, self:getStorageValue(currencyInfo.stoInfo.storageId))
                    local itemsQtd = self:getItemCount(currencyInfo.moeda)
                    if itemsQtd >= value then
                        if not self:removeItem(currencyInfo.moeda, value) then
                            return error(string.format("[BANK-ERROR] Player: %s, teve problemas ao depositar: %s, quantidade: %d", self:getName(), id, value)) and self:popupFYI("[ERROR] foi reportado o problema, abra um ticket no discord.")
                        end
                        self:setStorageValue(currencyInfo.stoInfo.storageId, storage + value)
                        return self:popupFYI("Deposito Bem sucedido!") and self:sendBankInfos()
                    end
                elseif currencyInfo.query == true then
                    local pontos = getPoints(self)
                    local itemsQtd = self:getItemCount(currencyInfo.moeda)
                    if itemsQtd >= value then
                        if not self:removeItem(currencyInfo.moeda, value) then
                            return error(string.format("[BANK-ERROR] Player: %s, teve problemas ao depositar: %s, quantidade: %d", self:getName(), id, value)) and self:popupFYI("[ERROR] foi reportado o problema, abra um ticket no discord.")
                        end
                        db.query("UPDATE `accounts` set `pontos` = `pontos` + " .. value .. " WHERE `id` = " .. self:getAccountId())
                        return self:popupFYI("Deposito Bem sucedido!") and self:sendBankInfos()
                    end
                elseif currencyInfo.money == true then
                    local balanceMoney = self:getBankBalance()
                    local playerMoney = self:getMoney()
                    if playerMoney >= value then
                        self:removeMoney(value)
                        self:setBankBalance(balanceMoney + value)
                        return self:popupFYI("Deposito Bem sucedido!") and self:sendBankInfos()
                    end
                elseif currencyInfo.diamond == true then
                    local diamonds = getDiamonds(self)
                    local itemsQtd = self:getItemCount(currencyInfo.moeda)
                    if itemsQtd >= value then
                        if not self:removeItem(currencyInfo.moeda, value) then
                            return error(string.format("[BANK-ERROR] Player: %s, teve problemas ao depositar: %s, quantidade: %d", self:getName(), id, value)) and self:popupFYI("[ERROR] foi reportado o problema, abra um ticket no discord.")
                        end
                        db.query("UPDATE `players` set `diamond` = `diamond` + " .. value .. " WHERE `id` = " .. self:getGuid())
                        return self:popupFYI("Deposito Bem sucedido!") and self:sendBankInfos()
                    end
                end
            end
        end
    end
    return self:popupFYI("Operação Inválida.")
end

function getPoints(player)
	local points = 0
	local resultId = db.storeQuery("SELECT `pontos` FROM `accounts` WHERE `id` = " .. player:getAccountId())
	if resultId ~= false then
		points = result.getDataInt(resultId, "pontos")
		result.free(resultId)
	end
	return points
end

function getDiamonds(player)
	local diamonds = 0
	local resultId = db.storeQuery("SELECT `diamond` FROM `players` WHERE `id` = " .. player:getGuid())
	if resultId ~= false then
		diamonds = result.getDataInt(resultId, "diamond")
		result.free(resultId)
	end
	return diamonds
end

function getTotalDiamonds(player)
    local diamonds = 0
    local resultId = db.storeQuery("SELECT `diamond` FROM `players` WHERE `id` = " .. player:getGuid())
    if resultId ~= false then
        diamonds = result.getDataInt(resultId, "diamond")
        result.free(resultId)
    end
    local itemCount = player:getItemCount(CONSTANT_ITEM_DIAMOND)
    return diamonds + itemCount
end

function removePlayerDiamond(player, count)
    local diamonds = getTotalDiamonds(player)
    if count > diamonds then
        return false
    end
    local queryDimonds = getDiamonds(player)
    if queryDimonds >= count then
        db.query("UPDATE `players` SET `diamond` = `diamond` - " .. count .. " WHERE `id` = " .. player:getGuid())
        return true
    end

    local itemCount = player:getItemCount(CONSTANT_ITEM_DIAMOND)
    if itemCount >= count then
        player:removeItem(CONSTANT_ITEM_DIAMOND, count)
        return true
    end


    db.query("UPDATE `players` SET `diamond` = `diamond` - " .. queryDimonds .. " WHERE `id` = " .. player:getGuid())
    local remaining = count - queryDimonds
    player:removeItem(CONSTANT_ITEM_DIAMOND, remaining)
    return true
end

function removePlayerMoney(player, amount)
    local totalMoney = player:getTotalMoney()
    if amount > totalMoney then
        return false
    end

    local money = player:getMoney()
    if money >= amount then
        player:removeMoney(amount)
        return true
    end

    local bankBalance = player:getBankBalance()
    if bankBalance >= amount then
        player:setBankBalance(bankBalance - amount)
        return true
    end

    local remaining = amount - money
    player:removeMoney(money)
    player:setBankBalance(bankBalance - remaining)
    return true
end