local AREA_CROSS = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat1:setArea(createCombatArea(AREA_CROSS))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Cross Poison")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()
	
    doSendMagicEffect(position, 2437)

    combat1:execute(creature, variant)

    return true
end

spell:name("Cross Poison")
spell:words("### Cross Poison ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
