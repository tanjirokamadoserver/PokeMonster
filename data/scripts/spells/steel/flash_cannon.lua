local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_STELLDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Flash Cannon")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 966,
    [DIRECTION_EAST] = 965,
    [DIRECTION_SOUTH] = 966,
    [DIRECTION_WEST] = 965
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

spell:name("Flash Cannon")
spell:words("#Flash Cannon#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
