local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hyper Beam")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 914,
    [DIRECTION_EAST] = 913,
    [DIRECTION_SOUTH] = 2553,
    [DIRECTION_WEST] = 2552
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

spell:name("Hyper Beam")
spell:words("#Hyper Beam#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
