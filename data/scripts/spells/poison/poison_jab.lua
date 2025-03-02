local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 16)
combat:setParameter(COMBAT_PARAM_EFFECT, 21)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Poison Jab")

local condition = Condition(CONDITION_POISON)
condition:setTicks(10000)
condition:setParameter(CONDITION_PARAM_EFFECT, 21)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Poison Jab")
spell:words("#Poison Jab#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
