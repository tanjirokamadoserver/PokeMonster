local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ground Collapse")

local spell = Spell(SPELL_INSTANT)

local effects = { center = 2300, side = 2300 }
local directions = {
    [DIRECTION_NORTH] = {x = 0, y = -1},
    [DIRECTION_EAST] = {x = 1, y = 0},
    [DIRECTION_SOUTH] = {x = 0, y = 1},
    [DIRECTION_WEST] = {x = -1, y = 0}
}

local jumpHeight = 20
local jumpDuration = 300

local function createWaveEffect(creature_id, position, offset, effectOffsetX, effectOffsetY)
    local creature = Creature(creature_id)
    if not creature then return end

    local centerPosition = Position(position.x + effectOffsetX, position.y + effectOffsetY, position.z)
    centerPosition:sendMagicEffect(effects.center)
    combat:execute(creature, Variant(centerPosition))

    local targets = Tile(centerPosition):getCreatures()
    for _, target in ipairs(targets) do
        target:sendJump(jumpHeight, jumpDuration)
    end

    local leftPos = Position(centerPosition.x - offset.y, centerPosition.y - offset.x, centerPosition.z)
    leftPos:sendMagicEffect(effects.side)
    combat:execute(creature, Variant(leftPos))

    targets = Tile(leftPos):getCreatures()
    for _, target in ipairs(targets) do
        target:sendJump(jumpHeight, jumpDuration)
    end

    local rightPos = Position(centerPosition.x + offset.y, centerPosition.y + offset.x, centerPosition.z)
    rightPos:sendMagicEffect(effects.side)
    combat:execute(creature, Variant(rightPos))

    targets = Tile(rightPos):getCreatures()
    for _, target in ipairs(targets) do
        target:sendJump(jumpHeight, jumpDuration)
    end
end

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local pos = creature:getPosition()
    local offset = directions[direction]
    local creature_id = creature:getId()

    for i = 1, 6 do
        addEvent(function()
            local creature = Creature(creature_id)
            if not creature then return end
            pos.x = pos.x + offset.x
            pos.y = pos.y + offset.y
            createWaveEffect(creature_id, pos, offset, 0, 0)
        end, (i - 1) * 400)
    end

    return true
end

spell:name("Ground Collapse")
spell:words("#Ground Collapse#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()

