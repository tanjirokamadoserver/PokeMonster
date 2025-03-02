local AREA_WIND = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
combat1:setArea(createCombatArea(AREA_WIND))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ominous Wind")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 2497)

    combat1:execute(creature, variant)

    return true
end

spell:name("Ominous Wind")
spell:words("### Ominous Wind ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
