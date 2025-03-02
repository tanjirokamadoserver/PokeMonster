function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return false
    end
    local parts = param:split(",")
    if not parts[1] then
        return player:sendCancelMessage("Comando Inválido")
    end

    local playerTarget = Player(parts[1])
    if not playerTarget then
        return player:sendCancelMessage("Player Invalido")
    end

    local storageTarget = tonumber(parts[2])
    if type(storageTarget) ~= "number" then
        return player:sendCancelMessage("Storage Invalido")
    end

    local storageValue = playerTarget:getStorageValue(storageTarget)
    if not parts[3] then
        return player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Player: %s, Storage: %s, Value: %d", playerTarget:getName(), storageTarget, storageValue))
    end
    local stonewValue = tonumber(parts[3])

    playerTarget:setStorageValue(storageTarget, tonumber(stonewValue))
    storageValue = playerTarget:getStorageValue(storageTarget)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("[NEW STORAGE] Player: %s, Storage: %s, Value: %d", playerTarget:getName(), storageTarget, storageValue))
    return false
end