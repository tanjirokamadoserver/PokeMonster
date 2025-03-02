
local talkTeste = TalkAction("!addEff")

function talkTeste.onSay(player, words, param)
    local parts = param:split(",")
    local effectId = parts[1]
    local front = parts[2]
    player:insertAttachedEffect(effectId, front)
end

talkTeste:separator(" ")
talkTeste:register()

local talkTeste = TalkAction("!removeEff")

function talkTeste.onSay(player, words, param)
    local parts = param:split(",")
    local effectId = parts[1]
    player:removeAttachedEffect(effectId)
    -- teste de commit 1
    -- teste de commit 2
end

talkTeste:separator(" ")
talkTeste:register()

local talkTeste = TalkAction("!cleanEffs")

function talkTeste.onSay(player, words, param)
    local parts = param:split(",")
    player:cleanAttachedEffects()
    -- teste de commit 3
end

talkTeste:separator(" ")
talkTeste:register()

local conditionHelper = {}

conditionHelper.addConfusion = function(creature, ticks, eff, effTicks)
    local creature = Creature(creature)
    if not creature then return false end

    local condition = Condition(CONDITION_CONFUSION)
    condition:setTicks(ticks)
    condition:setParameter(CONDITION_PARAM_EFFECT, eff)
    condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, effTicks)

    creature:addCondition(condition)
end

conditionHelper.addStun = function(creature, ticks, eff, effTicks)
    local creature = Creature(creature)
    if not creature then return false end

    local condition = Condition(CONDITION_STUN)
    condition:setTicks(ticks)
    condition:setParameter(CONDITION_PARAM_EFFECT, eff)
    condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, effTicks)

    creature:addCondition(condition)
end

conditionHelper.addBuffAttack = function(creature, ticks, eff, effTicks, bonus)
    local creature = Creature(creature)
    if not creature then return false end

    local condition = Condition(CONDITION_ATTACKBONUS)
    condition:setTicks(ticks)
    condition:setParameter(CONDITION_PARAM_EFFECT, eff)
    condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, effTicks)
    condition:setBonus(bonus)

    creature:addCondition(condition)
end

local talkTeste = TalkAction("!testet")

function talkTeste.onSay(player, words, param)
    -- local summon = player:getSummons()[1]
    player:modifierPokemon(0, 0, 1, -1)
    -- conditionHelper.addBuffAttack(summon:getId(), 10000, 14, 1000, 250)
end

talkTeste:separator(" ")
talkTeste:register()