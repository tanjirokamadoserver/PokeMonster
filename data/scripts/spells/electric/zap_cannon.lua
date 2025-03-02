local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 2204)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Zap Cannon")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
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
    
    creature:getPosition():sendMagicEffect(effectId)
    
    combat:execute(creature, variant)
    return true
end

spell:name("Zap Cannon")
spell:words("#Zap Cannon#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
