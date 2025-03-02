function onSay(player, words, param)
    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local position = player:getPosition()
    player:setGroup(Group(6))
    position:sendMagicEffect(14)
    --player:remove()
    return false
end