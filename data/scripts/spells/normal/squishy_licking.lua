local AREA_LINGUADA = {
    {0, 0, 0, 3, 0, 0, 0}
}

local AREA_LINGUADA2 = {
    {0, 0, 1, 3, 1, 0, 0}
}

local AREA_LINGUADA3 = {
    {0, 1, 1, 3, 1, 1, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 146)
combat:setArea(createCombatArea(AREA_LINGUADA))
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Squishy Licking")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 146)
combat2:setArea(createCombatArea(AREA_LINGUADA2))
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Squishy Licking")

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 146)
combat3:setArea(createCombatArea(AREA_LINGUADA3))
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Squishy Licking")

local spell = Spell(SPELL_INSTANT)
local INTERVAL = 400

local function executePattern(creatureId, variant, startPos, direction, step)
    local creature = Creature(creatureId)
    if not creature then return end -- Garante que a criatura ainda existe

    local offsetX, offsetY = 0, 0
    if direction == DIRECTION_NORTH then
        offsetY = -step
    elseif direction == DIRECTION_EAST then
        offsetX = step
    elseif direction == DIRECTION_SOUTH then
        offsetY = step
    elseif direction == DIRECTION_WEST then
        offsetX = -step
    end

    local newPosition = Position(startPos.x + offsetX, startPos.y + offsetY, startPos.z)
    local newVariant = Variant(newPosition)

    if step == 1 then
        combat:execute(creature, newVariant)
    elseif step == 2 or step == 3 then
        combat2:execute(creature, newVariant)
    elseif step == 4 then
        combat3:execute(creature, newVariant)
    end

    if step < 4 then
        addEvent(function()
            if Creature(creatureId) then -- Valida novamente a criatura antes de continuar
                executePattern(creatureId, variant, startPos, direction, step + 1)
            end
        end, INTERVAL)
    end
end

function spell.onCastSpell(creature, variant)
    local startPos = creature:getPosition()
    local direction = creature:getDirection()
    executePattern(creature:getId(), variant, startPos, direction, 1)
    return true
end

spell:name("Squishy Licking")
spell:words("### Squishy Licking ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
