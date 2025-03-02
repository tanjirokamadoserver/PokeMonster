local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Assurance")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 231,
    [DIRECTION_EAST] = 232,
    [DIRECTION_SOUTH] = 236,
    [DIRECTION_WEST] = 232
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()
    local creatureId = creature:getId()

    local function applyEffect(i)
        local currentCreature = Creature(creatureId)
        if not currentCreature or currentCreature:isRemoved() then
            return false
        end

        local effectPos = Position(pos.x, pos.y, pos.z)
        if direction == DIRECTION_NORTH then
            effectPos.y = pos.y - i
        elseif direction == DIRECTION_EAST then
            effectPos.x = pos.x + i
        elseif direction == DIRECTION_SOUTH then
            effectPos.y = pos.y + i
        elseif direction == DIRECTION_WEST then
            effectPos.x = pos.x - i
        end
        effectPos:sendMagicEffect(effectId)
    end

    for i = 1, 6 do
        addEvent(applyEffect, (i - 1) * 300, i)
    end

    combat:execute(creature, variant)
    return true
end

spell:name("Assurance")
spell:words("#Assurance#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
