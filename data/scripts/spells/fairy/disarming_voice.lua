local AREA_SING = {
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 3, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 552)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Disarming Voice")
combat:setArea(createCombatArea(AREA_SING))

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 33)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Disarming Voice")
spell:words("### Disarming Voice ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
