function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)  -- Cria um objeto Player com o ID do jogador
    
    -- Defina as constantes para os sexos (caso n�o estejam definidas em outro lugar)
    PLAYERSEX_FEMALE = 0
    PLAYERSEX_MALE = 1
    
    local COLOR_BLUE = 4
    local COLOR_RED = 180
    
    local table_mount = {
[13531] = {velocidade = 2000, female = 1993, male = 1993},
[13533] = {velocidade = 2000, female = 37, male = 36},
[13534] = {velocidade = 2000, female = 2121, male = 2122},
[13535] = {velocidade = 2000, female = 2123, male = 2124},
[13536] = {velocidade = 2000, female = 2125, male = 2126},
[13537] = {velocidade = 2000, female = 2127, male = 2128},
[13540] = {velocidade = 2000, female = 2129, male = 2130},
[13541] = {velocidade = 2000, female = 2131, male = 2132},
[13539] = {velocidade = 2000, female = 2133, male = 2134},
[13538] = {velocidade = 2000, female = 2135, male = 2136},
[13542] = {velocidade = 2000, female = 2016, male = 2016},
[13543] = {velocidade = 2000, female = 2017, male = 2017},
[14429] = {velocidade = 2000, female = 2160, male = 2160},
[14430] = {velocidade = 2000, female = 2159, male = 2159},
[14431] = {velocidade = 2000, female = 2163, male = 2163},
[14432] = {velocidade = 2000, female = 2162, male = 2162},
[14433] = {velocidade = 2000, female = 2161, male = 2161},
[14517] = {velocidade = 2000, female = 51, male = 51},
[13314] = {velocidade = 2000, female = 2015, male = 2015},
[13532] = {velocidade = 2000, female = 1953, male = 1953},
[15231] = {velocidade = 2000, female = 2383, male = 2384},
[15232] = {velocidade = 2000, female = 2385, male = 2386}, 
[15233] = {velocidade = 2000, female = 2387, male = 2388}, 
[15234] = {velocidade = 2000, female = 2389, male = 2390}, 
[15235] = {velocidade = 2000, female = 2381, male = 2382},

    }
    local mountInfo = table_mount[item:getId()]
    
    if not mountInfo then
        player:sendCancelMessage("Essa bike nao esta configurada corretamente.")
        return true
    end
    
    if player:isOnFly() or player:isOnRide() or player:isOnDive() or player:isOnSurf() or player:isOnEvent() or player:isOnLeague() then
        return player:sendCancelMessage("Voce esta ocupado.")
    end
    
    local playerPos = player:getPosition()
    
    local originalOutfitID = player:getStorageValue(128238)
    
    if originalOutfitID <= 0 then
        local originalOutfit = player:getOutfit()
        player:setStorageValue(128238, originalOutfit.lookType) -- Armazena o ID da outfit
        
        local outfit = player:getSex() == PLAYERSEX_MALE and mountInfo.male or mountInfo.female
        player:setOutfit({lookType = outfit, lookHead = 0, lookAddons = 0, lookLegs = 0, lookBody = 0, lookFeet = 0})
        
        local bikeText = "Bike ON"
        local textColor = COLOR_BLUE
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, bikeText)
        sendBikeMessage(playerPos, bikeText, textColor)
        playerPos:sendMagicEffect(CONST_ME_MAGIC_RED)
        
        -- Aplicar velocidade apenas se a bike estiver ativa
        local speedBoost = mountInfo.velocidade
        if speedBoost then
            local condition = Condition(CONDITION_HASTE)
            condition:setParameter(CONDITION_PARAM_SPEED, speedBoost)
            condition:setTicks(-1) -- Permanente at� que a bike seja desativada
            player:addCondition(condition)
        end
        
    else
        player:setStorageValue(128238, 0)
        
        player:setOutfit({lookType = originalOutfitID, lookHead = 0, lookAddons = 0, lookLegs = 0, lookBody = 0, lookFeet = 0})
        
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Bike OFF")
        sendBikeMessage(playerPos, "Bike OFF", COLOR_RED)
        playerPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
        
        -- Remover a condi��o de velocidade ao desativar a bike
        player:removeCondition(CONDITION_HASTE)
    end

    return true
end

function sendBikeMessage(position, text, color)
    Game.sendAnimatedText(position, text, color)
end