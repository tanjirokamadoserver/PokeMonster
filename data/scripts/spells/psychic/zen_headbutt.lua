local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Zen Headbutt")
combat:setParameter(COMBAT_PARAM_EFFECT, 822)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 34)

local condition = Condition(CONDITION_STUN)
condition:setTicks(6000)
condition:setParameter(CONDITION_PARAM_EFFECT, 872)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local function executeCombat(creatureId, variant, times)
    local creature = Creature(creatureId)
    if creature and times > 0 then
        combat:execute(creature, variant)
        addEvent(executeCombat, 150, creatureId, variant, times - 1)
    end
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    executeCombat(creature:getId(), variant, 3)
    return true
end

targetSpell:name("Zen Headbutt")
targetSpell:words("#Zen Headbutt")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(2)
targetSpell:register()
