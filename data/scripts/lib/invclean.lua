function onSay(cid, words, param)
    local player = Player(cid)
    
    -- Verifique se o jogador existe
    if not player then
        return false
    end

    -- Verifique se o jogador tem acesso de administrador
    if not player:getGroup():getAccess() then
        return true
    end

    -- Verifique se o jogador é um administrador (ACCOUNT_TYPE_GOD)
    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    -- Verifique se o parâmetro (nick do jogador) foi fornecido
    if not param or param == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use: !clearinventory <playername>")
        return false
    end

    -- Obtenha o jogador com base no nick fornecido
    local targetPlayer = Player(param)

    -- Verifique se o jogador alvo existe
    if not targetPlayer then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Jogador não encontrado.")
        return false
    end

    if hasSummons(targetPlayer) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "O jogador alvo não pode ter pokemons invocados.")
        return false
    end

    -- Limpe o inventário do jogador alvo
    for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
        local item = targetPlayer:getSlotItem(slot)
        if item then
            targetPlayer:removeItem(item:getId(), item:getCount())
        end
    end

    -- Envie uma mensagem para o jogador alvo
    targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Seu inventário foi limpo por um administrador.")

    -- Envie uma mensagem de confirmação para o administrador
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "O inventário de " .. param .. " foi limpo.")
    player:clearPokeballs()
    player:setUsingPokeball(false)
    return false
end
