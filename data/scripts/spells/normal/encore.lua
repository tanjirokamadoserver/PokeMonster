local AREA_Psychic = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setArea(createCombatArea(AREA_Psychic))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Encore")

local condition = createConditionObject(CONDITION_SILENCE)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
condition:setParameter(CONDITION_PARAM_EFFECT, 2249)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 2447)

    combat1:execute(creature, variant)

    return true
end

spell:name("Encore")
spell:words("### Encore ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
