function onSay(player, words, param)
    -- Verifica se o jogador Ã© um Game Master ou tem permissÃ£o para usar o comando
    if not player:getGroup():getAccess() then
        player:sendCancelMessage("Você não tem permissão para usar este comando.")
        return false
    end

    -- Divide o parÃ¢metro em nome do jogador e a quantidade
    local parts = param:split(",")
    if #parts ~= 3 then
        player:sendCancelMessage("Uso correto: /setstorage nomeplayer, quantia, storageid")
        return false
    end

    local targetName = parts[1]
    local quantidade = tonumber(parts[2])
	local storage = tonumber(parts[3])

    if not quantidade then
        player:sendCancelMessage("Quantidade Invalida.")
        return false
    end
    if not storage then
        player:sendCancelMessage("Storage Invalido.")
        return false
    end

    -- Encontra o jogador pelo nome
    local targetPlayer = Player(targetName)
    if not targetPlayer then
        player:sendCancelMessage("Jogador não encontrado.")
        return false
    end

    -- A storage ID que vocÃª quer modificar
    local storageId = storage

    -- Define a storage para o valor especificado
    targetPlayer:setStorageValue(storageId, quantidade)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Storage " .. storageId .. " de " .. targetName .. " ajustada para " .. quantidade .. ".")

    return false
end