local boostDuration = 60 -- in seconds
local boostMultiplier = 1.5 -- speed multiplier for the boost

function onSay(player, words, param)
    if param == "" then
        if player:getCondition(CONDITION_OUTFIT) then
            player:sendCancelMessage("Você não pode usar este comando enquanto estiver montado.")
            return false
        end
        
        if os.time() < player:getStorageValue("speedBoostExpiry") then
            local timeLeft = player:getStorageValue("speedBoostExpiry") - os.time()
            player:sendCancelMessage("Você já está sob efeito de aumento de velocidade. Aguarde mais " .. timeLeft .. " segundos.")
            return false
        end

        local condition = Condition(CONDITION_HASTE)
        condition:setParameter(CONDITION_PARAM_SPEED, boostMultiplier)
        condition:setTicks(boostDuration * 1000) -- converting to milliseconds
        player:addCondition(condition)

        player:setStorageValue("speedBoostExpiry", os.time() + boostDuration)

        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você sente um impulso de velocidade por 60 segundos!")

    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Uso inválido. Digite o comando sem nenhum texto adicional.")
    end

    return false
end
