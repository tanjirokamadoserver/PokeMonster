local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 325)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Calm Mind")

-- local condition = createConditionObject(CONDITION_DEFENSE)
-- condition:setParameter(CONDITION_PARAM_TICKS, 6000)
-- condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
-- condition:setParameter(CONDITION_PARAM_EFFECT, 325)
-- combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Calm Mind")
spell:words("### Calm Mind ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
