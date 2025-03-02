local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psybeam")
combat:setArea(createCombatArea({
    {0, 1, 0},
    {0, 1, 0},
    {0, 1, 0},
    {0, 1, 0},
    {0, 3, 0}
}))

local effects = {
    [DIRECTION_NORTH] = 59,
    [DIRECTION_EAST] = 57,
    [DIRECTION_SOUTH] = 2543,
    [DIRECTION_WEST] = 2542
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()

    for i = 1, 5 do
        pos:sendMagicEffect(effectId)
        
        if direction == DIRECTION_NORTH then
            pos.y = pos.y - 1
        elseif direction == DIRECTION_EAST then
            pos.x = pos.x + 1
        elseif direction == DIRECTION_SOUTH then
            pos.y = pos.y + 1
        elseif direction == DIRECTION_WEST then
            pos.x = pos.x - 1
        end
    end

    combat:execute(creature, variant)
    return true
end

spell:name("Psybeam")
spell:words("#Psybeam#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
