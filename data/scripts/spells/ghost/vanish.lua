local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 307)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Vanish")

local conditionInvisible = createConditionObject(CONDITION_INVISIBLE)
conditionInvisible:setParameter(CONDITION_PARAM_TICKS, 3000)
combat:addCondition(conditionInvisible)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Vanish")
spell:words("### Vanish ###")
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
