local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Lock-On")
combat:setParameter(COMBAT_PARAM_EFFECT, 99)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 87)
combat:addCondition(condition)

local function getTileInFront(creature, target)
    local direction = creature:getDirection()
    local targetPosition = target:getPosition()
    local offset = {
        [DIRECTION_NORTH] = {x = 0, y = -1},
        [DIRECTION_EAST] = {x = 1, y = 0},
        [DIRECTION_SOUTH] = {x = 0, y = 1},
        [DIRECTION_WEST] = {x = -1, y = 0}
    }
    local newPosition = Position(targetPosition.x + offset[direction].x, targetPosition.y + offset[direction].y, targetPosition.z)
    return newPosition
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    local target = Creature(variant:getNumber())
    if target then
        local newPosition = getTileInFront(creature, target)
        creature:teleportTo(newPosition)
    end
    return combat:execute(creature, variant)
end

targetSpell:name("Lock-On")
targetSpell:words("#Lock-On")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(5)
targetSpell:register()
