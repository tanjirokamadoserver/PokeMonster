local rocks = {1285, 3609}
local bushes = {2767}
local holes = {468, 481, 483, 7932}
local blinkStorage = 4004

local function hasRideOrFlyStorage(player)
    return player:getStorageValue(storageRide) == 1 or player:getStorageValue(storageFly) == 1
end

local function blink(player, pokemon, toPosition)
	local pokemonPosition = pokemon:getPosition()

	player:say(pokemon:getName().." Blink!", TALKTYPE_ORANGE_1)
	doSendDistanceShoot(pokemonPosition, toPosition, 40)
	pokemon:teleportTo(toPosition)

	doSendMagicEffect(pokemonPosition, 30)
	doSendMagicEffect(toPosition, 30)

    local exhaust = CONST_BLINK_CDR
    local ball = player:getUsingBall()

    if ball then
        local heldu = ball:getAttribute(ITEM_ATTRIBUTE_HELDU)
        local isHeldBlink = isHeld("blink", heldu)
        if isHeldBlink then
            exhaust = exhaust * 0.30
        end
        ball:setAttribute(ITEM_ATTRIBUTE_BLINK, math.floor(os.time() + math.floor(exhaust)))
    end
end

local function getBlinkStatus(player)
    local ball = player:getUsingBall()
    if ball then
        local time = ball:getAttribute(ITEM_ATTRIBUTE_BLINK)
        if time < os.time() then
            return true
        end
    end
    return false
end

local function getSecondsUntilBlinkReady(player)
    local ball = player:getUsingBall()
    if ball then
        local time = ball:getAttribute(ITEM_ATTRIBUTE_BLINK) or 0
        local secondsRemaining = time - os.time()
        if secondsRemaining < 0 then
            return 0
        end
        return secondsRemaining
    end
end

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or type(target) ~= "userdata" then
        return true
    end

    local playerPosition = player:getPosition()
    --@ sair do fly
    if not hasSummons(player) and hasRideOrFlyStorage(player) then
        if not (target == player) then return true end
        local tileUnder = Tile(playerPosition)
        local groundUnder = tileUnder and tileUnder:getGround()

        if not groundUnder then return true end
        if groundUnder:getId() == flyFloor then return true end

        local summonName = player:getSummonNameFromBall()
        local actualSpeed = player:getSpeed()

        player:say("Thanks, " .. summonName .. "!", TALKTYPE_SAY)
        player:removeCondition(CONDITION_OUTFIT)
        player:changeSpeed(-actualSpeed + player:getBaseSpeed())
        player:setStorageValue(storageRide, -1)
        player:setStorageValue(storageFly, -1)
        doReleaseSummon(player:getId(), playerPosition, false)
        player:setFly(false)
        return true
    end

    local summon = player:getSummon()
    if not summon then
        return true
    end
    summon:setPokeStopped(false)
    local summonName = summon:getName()
    local monsterType = MonsterType(summonName)
    if not monsterType then return true end

    if (summon:getCondition(CONDITION_CONFUSION) or
            summon:getCondition(CONDITION_FEAR) or
                summon:getCondition(CONDITION_PARALYZE) or
                    summon:getCondition(CONDITION_SLEEP) or
                        summon:getCondition(CONDITION_STUN) or
                            summon:getCondition(CONDITION_SNARE)) then
        return true
    end

    if target:isItem() then
        if target:isItem() then
            local tile = Tile(toPosition)
            local ground = tile and tile:getGround()
            local destTile = getTileInfo(toPosition)

            if not ground or not destTile or destTile.house or destTile.protection then
                return true
            end

            local item = tile:getTopTopItem()
            
            --@ rock smash
            if item and isInArray(rocks, item:getId()) then
                local canSmash = monsterType:canSmash()
                if canSmash then
                    if not isInArray(summon:getEvents(CREATURE_EVENT_THINK), "thinkBreakOrderSmash") then
                        summon:setOrderPosition(toPosition)
                        summon:registerEvent("thinkBreakOrderSmash")
                        local condition = Condition(CONDITION_MOVING)
                        condition:setParameter(CONDITION_PARAM_TICKS, 120000)
                        summon:addCondition(condition)
                        summon:moveTo(toPosition, 0, 1)
                        player:say(summonName .. ", destroy it!", TALKTYPE_SAY)
                        local summon = summon:getId()
                        addEvent(function (id)
                            local pokemon = Creature(id)
                            if pokemon then
                                pokemon:unregisterEvent("thinkBreakOrderSmash")
                            end
                        end, 10000, summon)
                    end
                end
                return true
            end

            --@ cut
            if item and isInArray(bushes, item:getId()) then
                local canCut = monsterType:canCut()
                if canCut then
                    if not isInArray(summon:getEvents(CREATURE_EVENT_THINK), "thinkBreakOrderCut") then
                        summon:setOrderPosition(toPosition)
                        summon:registerEvent("thinkBreakOrderCut")
                        local condition = Condition(CONDITION_MOVING)
                        condition:setParameter(CONDITION_PARAM_TICKS, 120000)
                        summon:addCondition(condition)
                        summon:moveTo(toPosition, 0, 1)
                        player:say(summonName .. ", cut it!", TALKTYPE_SAY)
                        local summon = summon:getId()
                        addEvent(function (id)
                            local pokemon = Creature(id)
                            if pokemon then
                                pokemon:unregisterEvent("thinkBreakOrderCut")
                            end
                        end, 10000, summon)
                    end
                end
                return true
            end

            --@ dig
            local groundId = ground:getId()
            if isInArray(holes, groundId) then
                local canDig = monsterType:canDig()
                if canDig then
                    if not isInArray(summon:getEvents(CREATURE_EVENT_THINK), "thinkBreakOrderDig") then
                        summon:setOrderPosition(toPosition)
                        summon:registerEvent("thinkBreakOrderDig")
                        local condition = Condition(CONDITION_MOVING)
                        condition:setParameter(CONDITION_PARAM_TICKS, 120000)
                        summon:addCondition(condition)
                        summon:moveTo(toPosition, 0, 1)
                        player:say(summonName .. ", open it!", TALKTYPE_SAY)
                        local summon = summon:getId()
                        addEvent(function (id)
                            local pokemon = Creature(id)
                            if pokemon then
                                pokemon:unregisterEvent("thinkBreakOrderDig")
                            end
                        end, 10000, summon)
                    end
                end
                return true
            end

            if not summon:isGhost() then
                if Tile(toPosition):hasProperty(CONST_PROP_BLOCKSOLID) or Tile(toPosition):hasProperty(CONST_PROP_BLOCKPATH) then
                    return true
                end
            end

			--@ blink
            if monsterType:canBlink() == 1 then
                local blinkReady = getBlinkStatus(player)
                if blinkReady then
                    local freeTilePosition = getFreeTilePositionByPos(toPosition)
                    if freeTilePosition then
                        blink(player, summon, toPosition)
                        return true
                    end
                else
                    local blinkSeconds = getSecondsUntilBlinkReady(player)
                    local message = "Sorry, you need to wait " .. blinkSeconds .. " seconds to use blink again!"
                    player:sendCancelMessage(message)
                end
            end

            --@ normal walk 
            summon:unregisterEvent("thinkBreakOrderCut")
            summon:unregisterEvent("thinkBreakOrderDig")
            summon:unregisterEvent("thinkBreakOrderSmash")
            local condition = Condition(CONDITION_MOVING)
            condition:setParameter(CONDITION_PARAM_TICKS, 120000)
            summon:addCondition(condition)
            summon:moveTo(toPosition)
            local phrases = {"%s, vá até lá!", "%s, mova-se capanga!"}
            player:say(phrases[math.random(#phrases)]:format(summon:getName()), TALKTYPE_ORANGE_1)
        end
    end

    if target:isCreature() then
		if target == player then
			if player:isOnBike() then
				player:sendCancelMessage("Sorry, not possible while on bike.")
				return true
			end

            -- entrar no fly/ride
            local summon = player:getSummon()
            if not summon then return true end

            local monsterType = MonsterType(summon:getName())

            local canFly = monsterType:isFlyable()
            local canRide = monsterType:isRideable()

            if (canFly <= 0 and canRide <= 0) then
                return true
            end

            player:registerEvent("playerMoveOrder")
            summon:registerEvent("thinkOrderMount")

            local condition = Condition(CONDITION_MOVING)
            condition:setParameter(CONDITION_PARAM_TICKS, 120000)
            summon:addCondition(condition)
            summon:moveTo(playerPosition, 0, 1)
            player:say(("Deixe-me subir %s!"):format(summon:getName()), TALKTYPE_SAY)
		end
	end
	return true
end

action:allowFarUse(true)
action:id(2270)
action:register()

--@Event Creatures
local thinkOrderMount = CreatureEvent("thinkOrderMount")
function thinkOrderMount.onThink(pokemon, interval)
    local master = pokemon:getMaster()
    if not master then
        return true
    end
    local masterPosition = master:getPosition()
    local selfPosition = pokemon:getPosition()
    local distance = masterPosition:getDistance(selfPosition)
    if distance < 3 then
        local monsterType = MonsterType(pokemon:getName())
        if monsterType then
            local flyOutfit = monsterType:isFlyable()
            local rideOutfit = monsterType:isRideable()
            if flyOutfit > 0 then
                master:setStorageValue(storageFly, 1)
                doRemoveSummon(master:getId(), false)
                doChangeOutfit(master:getId(), {lookType = flyOutfit})
                local summonSpeed = pokemon:getTotalSpeed() + master:getSpeed()

                local usingball = master:getUsingBall()
                if not usingball then error("usingbal not found") end
                local heldType = "wing"
                local ident = usingball:getAttribute(ITEM_ATTRIBUTE_HELDY)
                local isWingHeld = isHeld(heldType, ident)
                if isWingHeld then
                    local tier = HELDS_Y_INFO[ident].tier
                    local bonusHeld = HELDS_BONUS[heldType][tier]
                    summonSpeed = summonSpeed + bonusHeld
                end

                master:changeSpeed(summonSpeed)
                master:setFly(true)
            elseif rideOutfit > 0 then
                master:setStorageValue(storageRide, 1)
                doRemoveSummon(master:getId(), false)
                doChangeOutfit(master:getId(), {lookType = rideOutfit})
                local summonSpeed = pokemon:getTotalSpeed() + master:getSpeed()
                master:changeSpeed(summonSpeed)
            end
        end
        return true
    end
	return true
end

thinkOrderMount:register()

local thinkBreakOrderSmash = CreatureEvent("thinkBreakOrderSmash") -- rock smash 
function thinkBreakOrderSmash.onThink(pokemon, interval)
    local master = pokemon:getMaster()
    if not master then
        return true
    end
    local toPosition = pokemon:getOrderPosition()
    if toPosition then
        local pokemonPosition = pokemon:getPosition()
        if pokemonPosition:getDistance(toPosition) < 2 then
            local tile = Tile(toPosition)
            local ground = tile and tile:getGround()

            if not ground then
                return true
            end

            local item = tile:getTopTopItem()
            if not item:getId() == 1285 then
                pokemon:unregisterEvent("thinkBreakOrderSmash")
                return true
            end

            toPosition:sendMagicEffect(CONST_ME_POFF)
            item:transform(3648)
            item:decay()
            pokemon:setDirection(getDirectionFromNewPosition(pokemonPosition, toPosition))
            pokemon:unregisterEvent("thinkBreakOrderSmash")
        end
    end
    return true
end

thinkBreakOrderSmash:register()

local thinkBreakOrderCut = CreatureEvent("thinkBreakOrderCut") -- cut
function thinkBreakOrderCut.onThink(pokemon, interval)
    local master = pokemon:getMaster()
    if not master then
        return true
    end
    local toPosition = pokemon:getOrderPosition()
    if toPosition then 
        local pokemonPosition = pokemon:getPosition()
        if pokemonPosition:getDistance(toPosition) < 2 then
            local tile = Tile(toPosition)
            local ground = tile and tile:getGround()

            if not ground then
                return true
            end

            local item = tile:getTopTopItem()
            if not item:getId() == 2767 then
                pokemon:unregisterEvent("thinkBreakOrderCut")
                return true
            end

            toPosition:sendMagicEffect(17)
            item:transform(6216)
            item:decay()
            pokemon:setDirection(getDirectionFromNewPosition(pokemonPosition, toPosition))
            pokemon:unregisterEvent("thinkBreakOrderCut")
        end
    end
    return true
end

thinkBreakOrderCut:register()

local thinkBreakOrderDig = CreatureEvent("thinkBreakOrderDig") -- dig
function thinkBreakOrderDig.onThink(pokemon, interval)
    local master = pokemon:getMaster()
    if not master then
        return true
    end
    local toPosition = pokemon:getOrderPosition()
    if toPosition then 
        local pokemonPosition = pokemon:getPosition()
        if pokemonPosition:getDistance(toPosition) < 2 then
            local tile = Tile(toPosition)
            local ground = tile and tile:getGround()

            if not ground then
                return true
            end

            local groundId = ground:getId()
            if not isInArray(holes, groundId) then
                pokemon:unregisterEvent("thinkBreakOrderDig")
                return true
            end

            toPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
            ground:transform(groundId+1)
            ground:decay()
            pokemon:setDirection(getDirectionFromNewPosition(pokemonPosition, toPosition))
            pokemon:unregisterEvent("thinkBreakOrderDig")
        end
    end
    return true
end

thinkBreakOrderDig:register()

local playerMoveOrder = CreatureEvent("playerMoveOrder")
function playerMoveOrder.onMove(player, toPosition, fromPosition)
    local summons = player:getSummons()

    if #summons > 0 then
        local summon = summons[1]
        if summon then
            summon:unregisterEvent("thinkOrderMount")
        end
    end

    player:unregisterEvent("playerMoveOrder")
    return true
end

playerMoveOrder:register()


function getDirectionFromNewPosition(pos, pos2)
	local x1, y1 = pos.x, pos.y
	local x2, y2 = pos2.x, pos2.y

	if x1 - x2 <= 0 and y1 - y2 > 0 then
		return DIRECTION_NORTH
	elseif x1 - x2 < 0 and y1 - y2 == 0 then
		return DIRECTION_EAST
	elseif x1 - x2 < 0 and y1 - y2 < 0 then
		return DIRECTION_EAST
	elseif x1 - x2 > 0 and y1 - y2 < 0 then
		return DIRECTION_SOUTH
	elseif x1 - x2 > 0 and y1 - y2 <= 0 then
		return DIRECTION_WEST
	elseif x1 - x2 > 0 and y1 - y2 >= 0 then
		return DIRECTION_WEST
	elseif x1 - x2 == 0 and y1 - y2 < 0 then
		return DIRECTION_SOUTH
	end
	return DIRECTION_WEST
end