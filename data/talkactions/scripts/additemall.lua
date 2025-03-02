function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    local params = param:split(",")

    if #params < 2 then
        player:sendCancelMessage("Uso: /additemall <id_do_item>, <quantidade>")
        return true
    end

    local itemId = tonumber(params[1])
    local amount = tonumber(params[2])

    if not itemId or not amount then
        player:sendCancelMessage("Uso: /additemall <id_do_item>, <quantidade>")
        return true
    end

    local itemName = ItemType(itemId):getName()

    for _, targetPlayer in ipairs(Game.getPlayers()) do
        targetPlayer:addItem(itemId, amount)
        targetPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Você recebeu " .. amount .. "x " .. itemName .. ".")
        targetPlayer:sendPrivateMessage(player, "Todos os jogadores online receberam " .. amount .. "x " .. itemName .. ".", TALKTYPE_BROADCAST)
    end
    
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Todos os jogadores online receberam " .. amount .. "x " .. itemName .. ".")
    return true
end
