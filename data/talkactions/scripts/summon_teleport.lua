local delay = 2 * 60
local availableCities = 60

function onSay(player, words, param)

    if player:getStorageValue(storageDelayTeleport) > os.time() then
        player:sendCancelMessage("Você deve aguardar " .. convertTime(player:getStorageValue(storageDelayTeleport) - os.time()) .. " para teleportar novamente.")
        return false
    end

	if string.find(string.lower(param), "ceu") or string.find(string.lower(param), "quest") then
		return false
	end

    if param == "" then
        local msg = "Available cities:\n\n"
        for i = 1, availableCities do
            local town = Town(i)
            if town then
                msg = msg .. town:getName() .. "\n"
            end
        end
        player:showTextDialog(2263, msg)
        return false
    end

    if not hasSummons(player) then
        return player:sendCancelMessage("Sorry, not possible. You need a pokemon to use teleport.")
    end

    local summon = player:getSummon()
    local summonName = summon:getName()
    local monsterType = MonsterType(summonName)
    if monsterType:canTeleport() == 0 then
        return player:sendCancelMessage("Sorry, not possible. Your pokemon cannot teleport.")
    end
	
	local town = Town(param) or Town(tonumber(param))
    if param ~= "house" then
        if not town then
            return player:sendCancelMessage("Town not found.")
        end

        -- Bloqueio do teletransporte para a cidade inicial (Town 1)
        if town:getId() == 13 then
            return player:sendCancelMessage("Teleport to the initial town is not allowed.")
        end

        if town:getId() > availableCities then
            return player:sendCancelMessage("Sorry, town not available.")
        end
    end

    if player:isOnDive() then
        player:setStorageValue(storageDive, -1)
        player:removeCondition(CONDITION_OUTFIT)
    end

    if player:isDuelingWithNpc() then
        player:unsetDuelWithNpc()
    end

    if param == "house" then
        local playerHouse = player:getHouse()
        if playerHouse then
            local position = playerHouse:getExitPosition()
            player:say(summonName .. ", Vamos para casa", TALKTYPE_ORANGE_1)
            if position then
                player:teleportTo(position)
            end
        else
            return player:sendCancelMessage("Você não tem casa.")
        end
        return false
    end
    local reduce = 0
    local ball = player:getUsingBall()
    if ball then
        local type = "teleport"
        local ident = ball:getAttribute(ITEM_ATTRIBUTE_HELDY)
        local isHeldTeleport = isHeld(type, ident)
        if isHeldTeleport then
            local tier = HELDS_Y_INFO[ident].tier
            reduce = HELDS_BONUS[type][tier]
        end
    end
	player:say(summonName .. ", bring me to " .. town:getName() .. "!", TALKTYPE_ORANGE_1)
	player:teleportTo(town:getTemplePosition())
	summon:teleportTo(town:getTemplePosition())
	player:setStorageValue(storageDelayTeleport, os.time() + (1800 - reduce))
    return false
end
