local AREA_PULSE = {{0, 0, 1, 2, 1, 0, 0}}
local AREA_PULSE2 = {{0, 0, 0, 3, 0, 0, 0}}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 1400)
combat1:setArea(createCombatArea(AREA_PULSE))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stickmerang")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 213)
combat2:setArea(createCombatArea(AREA_PULSE2))
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stickmerang")

local spell = Spell(SPELL_INSTANT)
local INTERVAL = 200

local function executePattern(creatureId, variant, startPos, direction, step, returning)
    local creature = Creature(creatureId)
    if not creature then return end

    local newPosition = startPos

    if direction == DIRECTION_NORTH then
        newPosition = Position(startPos.x, startPos.y - step, startPos.z)
    elseif direction == DIRECTION_EAST then
        newPosition = Position(startPos.x + step, startPos.y, startPos.z)
    elseif direction == DIRECTION_SOUTH then
        newPosition = Position(startPos.x, startPos.y + step, startPos.z)
    elseif direction == DIRECTION_WEST then
        newPosition = Position(startPos.x - step, startPos.y, startPos.z)
    end

    local newVariant = Variant(newPosition)

    if step == 1 then
        combat1:execute(creature, newVariant)
    elseif step >= 2 and step <= 7 then
        combat1:execute(creature, newVariant)
        combat2:execute(creature, newVariant)
    end

    if not returning and step < 5 then
        addEvent(executePattern, INTERVAL, creatureId, variant, startPos, direction, step + 1, false)
    elseif returning and step > 1 then
        addEvent(executePattern, INTERVAL, creatureId, variant, startPos, direction, step - 1, true)
    elseif step == 5 then
        addEvent(executePattern, INTERVAL, creatureId, variant, startPos, direction, step - 1, true)
    end
end

function spell.onCastSpell(creature, variant)
    local startPos = creature:getPosition()
    local direction = creature:getDirection()
    executePattern(creature:getId(), variant, startPos, direction, 1, false)
    return true
end

spell:name("Stickmerang")
spell:words("### Stickmerang ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
