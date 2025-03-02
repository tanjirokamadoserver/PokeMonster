local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Soft-Boiled")

local condition = createConditionObject(CONDITION_DEFENSEBONUS)
condition:setParameter(CONDITION_PARAM_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 2000)
condition:setParameter(CONDITION_PARAM_EFFECT, 133)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant) 
	creature:addCondition(condition)
    return true
end

spell:name("Soft-Boiled")
spell:words("### Soft-Boiled ###")
spell:needLearn(false)
spell:register()
