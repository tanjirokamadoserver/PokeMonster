local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1991)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Charm")

-- local condition = createConditionObject(CONDITION_DEFENSE)
-- condition:setParameter(CONDITION_PARAM_TICKS, 15000)
-- condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1500)
-- condition:setParameter(CONDITION_PARAM_EFFECT, 32)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    -- creature:addCondition(condition)
    return true
end

spell:name("Charm")
spell:words("### Charm ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
