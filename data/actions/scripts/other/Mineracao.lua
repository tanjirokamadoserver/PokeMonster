local sources = {
    [22957] = {maxTries = 2, tempo = 1000 * 60, reward = {itemId = 22959, min = 1, max = 3}}, -- paludio bruto
    [22985] = {maxTries = 2, tempo = 1000 * 60, reward = {itemId = 22954, min = 1, max = 3}}, -- carvao pequeno bruto
    [22986] = {maxTries = 4, tempo = 1000 * 60, reward = {itemId = 22954 , min = 1, max = 3}}, -- carvao grande bruto
    [22961] = {maxTries = 4, tempo = 1000 * 60, reward = {itemId = 22956, min = 1, max = 2}}, -- ferro avancado bruto grande
    [22960] = {maxTries = 2, tempo = 1000 * 60, reward = {itemId = 22956, min = 1, max = 2}}, -- ferro avancado bruto pequeno
    [22962] = {maxTries = 4, tempo = 1000 * 60, reward = {itemId = 22955, min = 1, max = 3}}, -- ferro bruto grande

}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local targetId = target.itemid

    if not sources[targetId] then
        return player:sendCancelMessage("Você não pode coletar esse recurso.") and player:getPosition():sendMagicEffect(3)
    end

	local sto = 9999992
	
	if player:getStorageValue(sto) - os.time() > 0 then
		return player:getPosition():sendMagicEffect(3)
	else
		player:setStorageValue(sto, os.time() + 1)
	end

    local info = sources[targetId]
    local maxTries = info.maxTries
    local creationPos = target:getPosition()
    
    if not target:getSpecialAttribute("maxTries") then
        target:setSpecialAttribute("maxTries", 0)
    end
    local tries = target:getSpecialAttribute("maxTries")

    if math.random(60) > math.random(90) then
        local quantidade = math.random(info.reward.min, info.reward.max)
        player:addItem(info.reward.itemId, quantidade)
        player:getPosition():sendMagicEffect(13)
        Game.sendAnimatedText(player:getPosition(), "+" .. quantidade, math.random(255))
    end

    toPosition:sendMagicEffect(3)
    if tries >= maxTries then
        target:remove()
        addEvent(
            function() 
                Game.createItem(targetId, 1, creationPos)
            end, info.tempo)
    else
        target:setSpecialAttribute("maxTries", tries + 1)
    end

    return true
end