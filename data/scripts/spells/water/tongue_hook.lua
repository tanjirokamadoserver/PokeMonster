local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 39)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Tongue Hook")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local targetPos = target:getPosition()
    local creaturePos = creature:getPosition()
    local direction = creature:getDirection()
    local newTargetPos = Position(creaturePos)

    if direction == NORTH then
        newTargetPos.y = newTargetPos.y - 1
    elseif direction == EAST then
        newTargetPos.x = newTargetPos.x + 1
    elseif direction == SOUTH then
        newTargetPos.y = newTargetPos.y + 1
    elseif direction == WEST then
        newTargetPos.x = newTargetPos.x - 1
    end

    local creatureId = creature:getId()

    local function executeCombat(delay, moveTarget)
        addEvent(function()
            local creature = Creature(creatureId)
            if not creature then
                return
            end
            if moveTarget then
                target:teleportTo(newTargetPos)
                newTargetPos:sendMagicEffect(186)
            end
            combat:execute(creature, Variant(newTargetPos))
        end, delay)
    end

    combat:execute(creature, Variant(targetPos))
    executeCombat(200, true)
    executeCombat(400, false)

    return true
end

spell:name("Tongue Hook")
spell:words("#Tongue Hook#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
