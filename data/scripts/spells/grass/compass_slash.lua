local AREA_SLASH = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat1:setArea(createCombatArea(AREA_SLASH))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Compass Slash")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 2418)

    combat1:execute(creature, variant)

    return true
end

spell:name("Compass Slash")
spell:words("### Compass Slash ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
