local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Vine Grab")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 384,
    [DIRECTION_EAST] = 385,
    [DIRECTION_SOUTH] = 387,
    [DIRECTION_WEST] = 386
}

local offsets = {
    [DIRECTION_NORTH] = {x = 0, y = -1},
    [DIRECTION_EAST] = {x = 5, y = 0},
    [DIRECTION_SOUTH] = {x = 0, y = 5},
    [DIRECTION_WEST] = {x = -1, y = 0}
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()
    local offsetX = offsets[direction].x
    local offsetY = offsets[direction].y

    local effectPos = Position(pos.x + offsetX, pos.y + offsetY, pos.z)
    effectPos:sendMagicEffect(effectId)

    combat:execute(creature, variant)
    return true
end

spell:name("Vine Grab")
spell:words("#Vine Grab#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
