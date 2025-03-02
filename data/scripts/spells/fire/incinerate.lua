local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 419)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Incinerate")

local speedCondition = createConditionObject(CONDITION_FIRE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 5000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT, 16)
combat:addCondition(speedCondition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Incinerate")
spell:words("#Incinerate#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
