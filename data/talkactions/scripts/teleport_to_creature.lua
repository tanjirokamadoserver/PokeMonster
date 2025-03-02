function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD and player:getAccountType() < 4 then
        return false
    end

    local params = param:split(",") -- Divide a string de parâmetros usando vírgulas

    if #params == 3 then
        local posX = tonumber(params[1])
        local posY = tonumber(params[2])
        local posZ = tonumber(params[3])

        if posX and posY and posZ then
            local targetPosition = Position(posX, posY, posZ)
            player:teleportTo(targetPosition)
            return false
        end
    end

    local targetCreature = Creature(param)

    if not targetCreature then
        local targetPlayer = Player(param)
        if targetPlayer then
            player:teleportTo(targetPlayer:getPosition())
        else
            player:sendCancelMessage("Target not found.")
        end
    else
        local targetPosition = targetCreature:getPosition()
        player:teleportTo(targetPosition)
    end

    return false
end
