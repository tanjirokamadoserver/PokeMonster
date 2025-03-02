local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Fire Blast")

local spell = Spell(SPELL_INSTANT)

local effects = {
    [DIRECTION_NORTH] = 28,
    [DIRECTION_EAST] = 62,
    [DIRECTION_SOUTH] = 63,
    [DIRECTION_WEST] = 64
}

local sideEffect = 313

local directions = {
    [DIRECTION_NORTH] = {x = 0, y = -1},
    [DIRECTION_EAST] = {x = 1, y = 0},
    [DIRECTION_SOUTH] = {x = 0, y = 1},
    [DIRECTION_WEST] = {x = -1, y = 0}
}

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local pos = creature:getPosition()
    local offset = directions[direction]
    local creature_id = creature:getId()

    local function createWaveEffect(position)
        local creature = Creature(creature_id)
        if not creature then return end
        position:sendMagicEffect(effects[direction])
        combat:execute(creature, Variant(position))
        local leftPos = Position(position.x - offset.y, position.y - offset.x, position.z)
        leftPos:sendMagicEffect(sideEffect)
        combat:execute(creature, Variant(leftPos))
        local rightPos = Position(position.x + offset.y, position.y + offset.x, position.z)
        rightPos:sendMagicEffect(sideEffect)
        combat:execute(creature, Variant(rightPos))
    end

    for i = 1, 6 do
        addEvent(function()
            local creature = Creature(creature_id)
            if not creature then return end
            pos.x = pos.x + offset.x
            pos.y = pos.y + offset.y
            createWaveEffect(pos)
        end, (i - 1) * 400)
    end

    return true
end

spell:name("Fire Blast")
spell:words("#Fire Blast#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
