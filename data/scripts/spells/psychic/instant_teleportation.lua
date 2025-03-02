local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 299)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Instant Teleportation")

-- local condition = createConditionObject(CONDITION_INVISIBLE)
-- condition:setParameter(CONDITION_PARAM_TICKS, 15000)
-- condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1500)
-- condition:setParameter(CONDITION_PARAM_EFFECT, 32)
-- combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Instant Teleportation")
spell:words("### Instant Teleportation ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
