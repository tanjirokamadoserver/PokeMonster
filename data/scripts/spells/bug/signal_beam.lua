local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Signal Beam")
combat:setArea(createCombatArea({
    {0, 1, 0},
    {0, 1, 0},
    {0, 1, 0},
    {0, 1, 0},
    {0, 1, 0},
    {0, 3, 0}
}))

local effects = {
    [DIRECTION_NORTH] = 74,
    [DIRECTION_EAST] = 75,
    [DIRECTION_SOUTH] = 76,
    [DIRECTION_WEST] = 77
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

spell:name("Signal Beam")
spell:words("#Signal Beam#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
