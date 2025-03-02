function onMove(creature, toPosition, fromPosition)
    local player = Player(creature:getId())
    local party = player:getParty()
    if party then
        party:updateOnWalk(player, {x = toPosition.x, y = toPosition.y, z = toPosition.z})
    end
    return true
end
