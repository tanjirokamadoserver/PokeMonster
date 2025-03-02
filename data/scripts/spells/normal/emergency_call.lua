local AREA_EMERGENCY = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 304)
combat1:setArea(createCombatArea(AREA_EMERGENCY))

-- local condition = createConditionObject(CONDITION_NEGATIVE)
-- condition:setParameter(CONDITION_PARAM_TICKS, 6000)
-- condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
-- condition:setParameter(CONDITION_PARAM_EFFECT, 726)
-- combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat1:execute(creature, variant)

    return true
end

spell:name("Emergency Call")
spell:words("### Emergency Call ###")
spell:needLearn(false)
spell:register()
