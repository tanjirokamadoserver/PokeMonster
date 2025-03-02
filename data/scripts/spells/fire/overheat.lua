local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Overheat")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 2381,
    [DIRECTION_EAST] = 2383,
    [DIRECTION_SOUTH] = 2384,
    [DIRECTION_WEST] = 2382
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

spell:name("Overheat")
spell:words("#Overheat#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
