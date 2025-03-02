local followPlayer = {}

local onMoveEvent = CreatureEvent("onMoveFollow")

function onMoveEvent.onMove(creature, toPosition, fromPosition)
    local followerId = followPlayer[creature:getId()]
    if not followerId then
        return true
    end

    local follower = Player(followerId)
    if not follower then
        followPlayer[creature:getId()] = nil
        return true
    end

    follower:teleportTo(toPosition)
    return true
end

onMoveEvent:register()

function Player:startFollowing(targetPlayer)
    followPlayer[targetPlayer:getId()] = self:getId()

    targetPlayer:registerEvent("onMoveFollow")
    return true
end

function Player:stopFollowing()
    for targetId, followerId in pairs(followPlayer) do
        if followerId == self:getId() then
            followPlayer[targetId] = nil
            self:unregisterEvent("onMoveFollow")
            return true
        end
    end
end
