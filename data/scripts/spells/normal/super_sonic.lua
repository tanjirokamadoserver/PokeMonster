local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Super Sonic")
combat:setParameter(COMBAT_PARAM_EFFECT, 22)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 34)

local condition = createConditionObject(CONDITION_CONFUSION)
condition:setParameter(CONDITION_PARAM_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 32)
combat:addCondition(condition)

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    return combat:execute(creature, variant)
end

targetSpell:name("Super Sonic")
targetSpell:words("#Super Sonic")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(6)
targetSpell:register()
