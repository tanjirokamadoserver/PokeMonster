function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        -- Aqui você pode adicionar lógica adicional se desejar,
        -- como enviar uma mensagem ao jogador informando que não tem permissão.
        return true
    end

    local params = param:split(",") -- Assume que os IDs são fornecidos separados por vírgula

    -- Verifica se os parâmetros são fornecidos corretamente
    if #params ~= 2 then
        player:sendCancelMessage("Use o comando da seguinte forma: !look <playerName>,<lookType>")
        return false
    end

    local playerName = params[1]:trim()
    local lookType = tonumber(params[2])

    if not lookType then
        player:sendCancelMessage("O lookType deve ser um número válido.")
        return false
    end

    local targetPlayer = Player(playerName)

    if not targetPlayer then
        player:sendCancelMessage("O jogador '" .. playerName .. "' não foi encontrado.")
        return false
    end

    -- Aqui você pode adicionar verificações adicionais se necessário

    local targetOutfit = targetPlayer:getOutfit()
    targetOutfit.lookType = lookType
    targetPlayer:setOutfit(targetOutfit)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "A aparência de " .. targetPlayer:getName() .. " foi alterada para o lookType " .. lookType .. ".")
    return false
end
