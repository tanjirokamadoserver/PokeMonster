local AREA_BOMB = {
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
combat1:setArea(createCombatArea(AREA_BOMB))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Snake Sense")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 2478)

    combat1:execute(creature, variant)

    return true
end

spell:name("Snake Sense")
spell:words("### Snake Sense ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
