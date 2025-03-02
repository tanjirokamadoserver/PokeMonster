local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 176)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Frost Breath")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 555,
    [DIRECTION_EAST] = 558,
    [DIRECTION_SOUTH] = 556,
    [DIRECTION_WEST] = 557
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()

    pos:sendMagicEffect(effectId)

    combat:execute(creature, variant)
    return true
end

spell:name("Frost Breath")
spell:words("#Frost Breath#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
