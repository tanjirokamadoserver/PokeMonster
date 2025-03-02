local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)

local condition = createConditionObject(CONDITION_DEFENSEBONUS)
condition:setParameter(CONDITION_PARAM_TICKS, 15000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 13)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant) 
	creature:addCondition(condition)
    return true
end

spell:name("Agility")
spell:words("### Agility ###")
spell:needLearn(false)
spell:register()
