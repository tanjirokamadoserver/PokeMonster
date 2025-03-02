local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1302)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dizzy Punch")

local speedCondition = createConditionObject(CONDITION_CONFUSION)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 6000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT, 32)
combat:addCondition(speedCondition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Dizzy Punch")
spell:words("#Dizzy Punch#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
