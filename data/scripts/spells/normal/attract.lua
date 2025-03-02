local AREA_Psychic = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat1:setArea(createCombatArea(AREA_Psychic))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Attract")

-- local condition = createConditionObject(CONDITION_CHARM)
-- condition:setParameter(CONDITION_PARAM_TICKS, 6000)
-- condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
-- condition:setParameter(CONDITION_PARAM_EFFECT, 662)
-- combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 458)

    combat1:execute(creature, variant)

    return true
end

spell:name("Attract")
spell:words("### Attract ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
