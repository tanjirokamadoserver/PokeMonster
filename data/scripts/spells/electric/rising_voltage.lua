local AREA_STORE = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 3, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 2204)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Rising Voltage")
combat:setArea(createCombatArea(AREA_STORE))

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_SPEED, -4000)
combat :addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Rising Voltage")
spell:words("### Rising Voltage ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
