local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Air Cutter")

local spell = Spell(SPELL_INSTANT)

local effects = {
    [DIRECTION_NORTH] = 129,
    [DIRECTION_EAST] = 130,
    [DIRECTION_SOUTH] = 132,
    [DIRECTION_WEST] = 131
}

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

    local function applyDamage(position)
        local creature = Creature(creature_id)
        if creature then
            combat:execute(creature, Variant(position))
        end
    end

    for i = 1, 6 do
        addEvent(function()
            local creature = Creature(creature_id)
            if creature then
                pos.x = pos.x + offset.x
                pos.y = pos.y + offset.y

                local effectPos = Position(pos.x, pos.y, pos.z)
                effectPos:sendMagicEffect(effects[direction])
                
                applyDamage(pos)
            end
        end, (i - 1) * 400)
    end

    return true
end

spell:name("Air Cutter")
spell:words("#Air Cutter#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
