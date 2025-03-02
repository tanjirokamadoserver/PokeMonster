function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target then return false end
    local summons = player:getSummons()
    local summon = summons[1]
    if #summons == 0 or not summon or target ~= summon then return false end

    if summon:getCondition(CONDITION_ATTACKBONUS) then
        fromPosition:sendMagicEffect(CONST_ME_POFF)
        player:sendCancelMessage("Efeito já ativo.")
        return false
    end

    toPosition:sendMagicEffect(14)

    addEvent(
        function()
            toPosition:sendMagicEffect(40)
        end,
        500
    )
    
    local txt = {"aaah que gostoso! me sinto mais forte!", "muito bom! me sinto poderoso!", "OTIMO! agora sinto que irei arrebentar!"}
    summon:say(txt[math.random(#txt)], TALKTYPE_ORANGE_1)
    item:remove(1)

    local condition = Condition(CONDITION_ATTACKBONUS)
    condition:setTicks(8000)
    condition:setParameter(CONDITION_PARAM_BONUS_ATTACK_POWERUP, 50)
    condition:setParameter(CONDITION_PARAM_EFFECT, 14)
    condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)

    summon:addCondition(condition)
    return true
end
