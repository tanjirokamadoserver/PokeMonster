-- Arquivo: data/talkactions/scripts/effect.lua

-- Tempo de cooldown em segundos
local cooldownTime = 10  -- Ajuste conforme necessário

-- Armazena o último tempo que o comando foi usado por cada jogador
local lastCommandUsage = {}

function onSay(player, words, param)
    -- Verifica se o jogador está dentro do tempo de cooldown
    local lastUsageTime = lastCommandUsage[player:getId()] or 0
    local currentTime = os.time()

    if currentTime - lastUsageTime < cooldownTime then
        local remainingTime = cooldownTime - (currentTime - lastUsageTime)
        player:sendTextMessage(MESSAGE_EVENT_DEFAULT, "Aguarde " .. remainingTime .. " segundos antes de usar este comando novamente.")
        return false
    end

    -- Escolha um ID de efeito
    local effectID = 1991  -- Ajuste conforme necessário

    -- Calcule a posição à frente do jogador
    local position = getPositionInDirection(player:getPosition(), player:getDirection())

    -- Verifique se a posição foi calculada com sucesso
    if position then
        -- Envie o efeito para a posição calculada
        position:sendMagicEffect(effectID)

        -- Informe ao jogador que o efeito foi aplicado
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Emote Love aplicado!")

        -- Atualiza o tempo de uso do comando para o jogador
        lastCommandUsage[player:getId()] = currentTime
    else
        -- Informe ao jogador se houve um problema ao calcular a posição
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Erro: Não foi possível determinar a posição para o efeito.")
    end

    return true
end

-- Função para calcular a próxima posição em uma direção
function getPositionInDirection(position, direction)
    local nextPosition = Position(position.x, position.y, position.z)

    if direction == DIRECTION_NORTH then
        nextPosition.y = nextPosition.y - 1
    elseif direction == DIRECTION_EAST then
        nextPosition.x = nextPosition.x + 1
    elseif direction == DIRECTION_SOUTH then
        nextPosition.y = nextPosition.y + 1
    elseif direction == DIRECTION_WEST then
        nextPosition.x = nextPosition.x - 1
    end

    return nextPosition
end
