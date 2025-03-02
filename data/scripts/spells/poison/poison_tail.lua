local AREA_TAIL = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 2, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat1:setArea(createCombatArea(AREA_TAIL))
combat1:setParameter(COMBAT_PARAM_EFFECT, 814)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Poison Tail")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 783)

    combat1:execute(creature, variant)

    return true
end

spell:name("Poison Tail")
spell:words("### Poison Tail ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
