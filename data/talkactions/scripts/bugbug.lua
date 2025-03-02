local COOLDOWN_TIME = 10 -- Tempo em segundos (1 minuto)

function onSay(player, words, param)
    player = Player(player)

    -- Verificar se o jogador ainda está no cooldown
    local lastTimeUsed = player:getStorageValue(7564) -- Usaremos o storageValue 1000 para armazenar o último horário em que o jogador usou o comando
    local currentTime = os.time()
    local timeSinceLastUse = currentTime - lastTimeUsed

    -- Se ainda estiver no cooldown, mostrar mensagem
    if timeSinceLastUse < COOLDOWN_TIME then
        local remainingTime = COOLDOWN_TIME - timeSinceLastUse
        local remainingTimeMsg = "Você precisa esperar " .. remainingTime .. " segundos antes de usar o comando novamente."
        player:sendTextMessage(MESSAGE_STATUS_WARNING, remainingTimeMsg)
        return false -- Para evitar o teleport se estiver em cooldown
    end

    local posxx = Position(3089, 2904, 7)
    player:teleportTo(posxx)
	player:setStorageValue(storageSurf, -1)
	player:setStorageValue(storageRide, -1)
	player:setStorageValue(storageFly, -1)
	player:removeCondition(CONDITION_OUTFIT)
	player:setSpeed(player:getBaseSpeed())

    -- Atualizar o storageValue com o horário atual para começar o cooldown
    player:setStorageValue(7564, currentTime)

    return false
end
