local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)

local condition = createConditionObject(CONDITION_RAGE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)

local speedCondition = createConditionObject(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 10000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, 400)
speedCondition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT, 14)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant) 
	creature:addCondition(condition)
	creature:addCondition(speedCondition)
    return true
end

spell:name("Ultimate Champion")
spell:words("### Ultimate Champion ###")
spell:needLearn(false)
spell:register()
