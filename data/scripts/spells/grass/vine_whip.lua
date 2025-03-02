local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Vine Whip")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 81,
    [DIRECTION_EAST] = 84,
    [DIRECTION_SOUTH] = 82,
    [DIRECTION_WEST] = 83
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

spell:name("Vine Whip")
spell:words("#Vine Whip#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
