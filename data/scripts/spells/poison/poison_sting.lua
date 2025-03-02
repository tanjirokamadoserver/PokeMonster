local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 16)
combat:setParameter(COMBAT_PARAM_EFFECT, 815)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Poison Sting")

local condition = Condition(CONDITION_POISON)
condition:setTicks(10000)
condition:setParameter(CONDITION_PARAM_EFFECT, 832)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Poison Sting")
spell:words("#Poison Sting#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
