local AREA_BURST = {
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1}
}

local MISSILE_ID = 40
local EFFECT_ID = 114

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat1:setArea(createCombatArea(AREA_BURST))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hi Jump Kick")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creaturePosition = creature:getPosition()
    local direction = creature:getDirection()
    local creatureId = creature:getId()

    local function getTargetPosition(offsetX, offsetY)
        local targetX = creaturePosition.x
        local targetY = creaturePosition.y
        
        if direction == NORTH then
            targetX = targetX + offsetX
            targetY = targetY - offsetY
        elseif direction == EAST then
            targetX = targetX + offsetY
            targetY = targetY + offsetX
        elseif direction == SOUTH then
            targetX = targetX + offsetX
            targetY = targetY + offsetY
        elseif direction == WEST then
            targetX = targetX - offsetY
            targetY = targetY + offsetX
        end

        return Position(targetX, targetY, creaturePosition.z)
    end

    local function launchMissileAndEffect(creatureId)
        local offsetX = math.random(-2, 2)
        local offsetY = math.random(1, 4)
        local targetPosition = getTargetPosition(offsetX, offsetY)
        local creature = Creature(creatureId)
        if creature then
            doSendDistanceShoot(creaturePosition, targetPosition, MISSILE_ID)
            doSendMagicEffect(targetPosition, EFFECT_ID)
        end
    end

    addEvent(function()
        if creature then
            creature:sendJump(15, 400)
        end
    end, 0)

    addEvent(function()
        combat1:execute(creature, variant)
        
        for i = 1, 7 do
            addEvent(launchMissileAndEffect, 100 * (i - 1), creatureId)
        end
    end, 400)

    return true
end

spell:name("Hi Jump Kick")
spell:words("### Hi Jump Kick ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
