local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Fury Cutter")
combat:setArea(createCombatArea({
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 129,
    [DIRECTION_EAST] = 130,
    [DIRECTION_SOUTH] = 132,
    [DIRECTION_WEST] = 131
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

spell:name("Fury Cutter")
spell:words("#WingAttack#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
