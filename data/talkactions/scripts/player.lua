function onSay(player, words, param)
    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local position = player:getPosition()
    player:setGroup(Group(1))
    position:sendMagicEffect(13)
    --player:remove()
    return false
end