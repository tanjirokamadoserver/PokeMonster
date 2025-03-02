local day = 24 * 60 * 60
local hour = 60 * 60
local minutes = 60



local charms = {
	[23149] = {time = ((0 * day) + (1 * hour) + ( 0 * minutes)), storage = 296582, name = "Fusion Charm"}, 
	[23151] = {time = ((1 * day) + (0 * hour) + ( 0 * minutes)), storage = 296582, name = "Fusion Charm"}, 
	[23152] = {time = ((7 * day) + (0 * hour) + ( 0 * minutes)), storage = 296582, name = "Fusion Charm"}, 
}

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local charm = charms[item.itemid]
    if not charm then
        return true
    end
	local charmStorage = charm.storage

    if player:getStorageValue(charmStorage) - os.time() > 0 then
        local remainingTime = (player:getStorageValue(charmStorage) - os.time())
        player:setStorageValue(charmStorage, remainingTime + charm.time + os.time())
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Você acaba de adicionar tempo a: %s, novo tempo: %s", charm.name, convertTime(remainingTime + charm.time)))
        item:remove(1)
        return true
    end

    player:setStorageValue(charmStorage, charm.time + os.time())

    doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, string.format("Você acaba de ativar um %s, com duração de: %s", charm.name, convertTime(charm.time)))
    item:remove(1)
    return true
end

action:id(23149, 23151, 23152)
action:register()