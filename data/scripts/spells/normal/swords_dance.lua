local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Swords Dance")

local condition = createConditionObject(CONDITION_RAGE)
condition:setParameter(CONDITION_PARAM_TICKS, 15000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 2000)
condition:setParameter(CONDITION_PARAM_EFFECT, 270)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant) 
	creature:addCondition(condition)
    return true
end

spell:name("Swords Dance")
spell:words("### Swords Dance ###")
spell:needLearn(false)
spell:register()
