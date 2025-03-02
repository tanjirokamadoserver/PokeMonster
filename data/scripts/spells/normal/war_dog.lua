local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_EFFECT, 4)
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)

local condition = createConditionObject(CONDITION_DEFENSEBONUS)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 4)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant) 
	creature:addCondition(condition)
    return true
end

spell:name("War Dog")
spell:words("### War Dog ###")
spell:needLearn(false)
spell:register()
