local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 80)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Cursed Hollow")

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_SPEED, -4000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
condition:setParameter(CONDITION_PARAM_EFFECT, 1484)

combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Cursed Hollow")
spell:words("#Cursed Hollow#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
