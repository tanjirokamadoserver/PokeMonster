function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local players = getCountTournament()
    if players == 1 then
        player:teleportTo(Position(2230, 2579, 6))
        return true
    end
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Ainda há players para serem derrotados!")
    return true
end