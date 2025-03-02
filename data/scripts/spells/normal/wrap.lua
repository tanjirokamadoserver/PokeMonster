local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 15)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wrap")

local condition = Condition(CONDITION_POISON)
condition:setTicks(8000)
condition:setParameter(CONDITION_PARAM_EFFECT, 105)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local condition2 = Condition(CONDITION_STUN)
condition2:setTicks(2000)
combat:addCondition(condition2)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Wrap")
spell:words("#Wrap#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
