local itemFunctions = {
    ["actionid"] = { isActive = true, targetFunction = function (item, target) return item:setActionId(target) end },
    ["action"] = { isActive = true, targetFunction = function (item, target) return item:setActionId(target) end },
    ["aid"] = { isActive = true, targetFunction = function (item, target) return item:setActionId(target) end },
    ["description"] = { isActive = true, targetFunction = function (item, target) return item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, target) end },
    ["desc"] = { isActive = true, targetFunction = function (item, target) return item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, target) end },
    ["remove"] = { isActive = true, targetFunction = function (item, target) return item:remove() end },
    ["decay"] = { isActive = true, targetFunction = function (item, target) return item:decay() end },
    ["transform"] = { isActive = true, targetFunction = function (item, target) return item:transform(target) end },
    ["clone"] = { isActive = true, targetFunction = function (item, target) return item:clone() end },
    ["boost"] = { isActive = true, targetFunction = function (item, target) return item:setSpecialAttribute("pokeBoost", tonumber(target)) end },
    ["level"] = { isActive = true, targetFunction = function (item, target) return item:setSpecialAttribute("pokeLevel", tonumber(target)) end },
    ["nickname"] = { isActive = true, targetFunction = function (item, target) return item:setSpecialAttribute("nickname", target) end },
    ["poke"] = { isActive = true, targetFunction = function (item, target) return item:setSpecialAttribute("pokeName", target) end },
    ["dono"] = { isActive = true, targetFunction = function (item, target) return item:setSpecialAttribute("ownerPokemon", target) end },
    ["heldx"] = { isActive = true, targetFunction = function (item, target) return item:setAttribute(ITEM_ATTRIBUTE_HELDX, tonumber(target)) end },
    ["heldy"] = { isActive = true, targetFunction = function (item, target) return item:setAttribute(ITEM_ATTRIBUTE_HELDY, tonumber(target)) end },
    ["heldu"] = { isActive = true, targetFunction = function (item, target) return item:setAttribute(ITEM_ATTRIBUTE_HELDU, tonumber(target)) end },
}
 
local creatureFunctions = {
    ["health"] = { isActive = true, targetFunction = function (creature, target) return creature:addHealth(target) end },
    ["mana"] = { isActive = true, targetFunction = function (creature, target) return creature:addMana(target) end },
    ["speed"] = { isActive = true, targetFunction = function (creature, target) return creature:changeSpeed(target) end },
    ["droploot"] = { isActive = true, targetFunction = function (creature, target) return creature:setDropLoot(target) end },
    ["skull"] = { isActive = true, targetFunction = function (creature, target) return creature:setSkull(target) end },
    ["direction"] = { isActive = true, targetFunction = function (creature, target) return creature:setDirection(target) end },
    ["maxHealth"] = { isActive = true, targetFunction = function (creature, target) return creature:setMaxHealth(target) end },
    ["say"] = { isActive = true, targetFunction = function (creature, target) creature:say(target, TALKTYPE_SAY) end }
}
 
local playerFunctions = {
    ["fyi"] = { isActive = true, targetFunction = function (player, target) return player:popupFYI(target) end },
    ["tutorial"] = { isActive = true, targetFunction = function (player, target) return player:sendTutorial(target) end },
    ["guildnick"] = { isActive = true, targetFunction = function (player, target) return player:setGuildNick(target) end },
    ["group"] = { isActive = true, targetFunction = function (player, target) return player:setGroup(Group(target)) end },
    ["vocation"] = { isActive = true, targetFunction = function (player, target) return player:setVocation(Vocation(target)) end },
    ["stamina"] = { isActive = true, targetFunction = function (player, target) return player:setStamina(target) end },
    ["town"] = { isActive = true, targetFunction = function (player, target) return player:setTown(Town(target)) end },
    ["balance"] = { isActive = true, targetFunction = function (player, target) return player:setBankBalance(target + player:getBankBalance()) end },
    ["save"] = { isActive = true, targetFunction = function (player, target) return target:save() end },
    ["type"] = { isActive = true, targetFunction = function (player, target) return player:setAccountType(target) end },
    ["skullTime"] = { isActive = true, targetFunction = function (player, target) return player:setSkullTime(target) end },
    ["maxMana"] = { isActive = true, targetFunction = function (player, target) return player:setMaxMana(target) end },
    ["addItem"] = { isActive = true, targetFunction = function (player, target) return player:addItem(target, 1) end },
    ["removeItem"] = { isActive = true, targetFunction = function (player, target) return player:removeItem(target, 1) end },
    ["premium"] = { isActive = true, targetFunction = function (player, target) return player:addPremiumDays(target) end }
}
 
function onSay(player, words, param)
    if(not player:getGroup():getAccess()) or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end
   
    if(param == "") then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
        return false
    end
   
    local position = player:getPosition()
    position:getNextPosition(player:getDirection(), 1)
   
    local split = param:split(",")
    local itemFunction, creatureFunction, playerFunction = itemFunctions[split[1]], creatureFunctions[split[1]], playerFunctions[split[1]]
    if(itemFunction and itemFunction.isActive) then
        local item = Tile(position):getTopVisibleThing(player)
        if(not item or not item:isItem()) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Item not found.")
            return false
        end
       
        if(itemFunction.targetFunction(item, split[2])) then
            position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You cannot add that attribute to this item.")
        end
    elseif(creatureFunction and creatureFunction.isActive) then
        local creature = Tile(position):getTopCreature()
        if(not creature or not creature:isCreature()) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Creature not found.")
            return false
        end
       
        if(creatureFunction.targetFunction(creature, split[2])) then
            position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You cannot add that attribute to this creature.")
        end
    elseif(playerFunction and playerFunction.isActive) then
        local targetPlayer = Tile(position):getTopCreature()
        if(not targetPlayer or not targetPlayer:getPlayer()) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player not found.")
            return false
        end
       
        if(playerFunction.targetFunction(targetPlayer, split[2])) then
            position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You cannot add that attribute to this player.")
        end
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Unknow attribute.")
    end
    return false
end