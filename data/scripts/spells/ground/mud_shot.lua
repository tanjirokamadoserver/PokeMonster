local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 7)
combat:setParameter(COMBAT_PARAM_EFFECT, 315)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mud Shot")

local condition = Condition(CONDITION_BLIND)
condition:setTicks(6000)
condition:setParameter(CONDITION_PARAM_EFFECT, 654)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Mud Shot")
spell:words("#Mud Shot#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
