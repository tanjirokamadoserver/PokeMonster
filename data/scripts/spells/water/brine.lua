local AREA_BURST = {
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1}
}

local MISSILE_ID = 3
local EFFECT_ID = 644

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat1:setArea(createCombatArea(AREA_BURST))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Brine")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creaturePosition = creature:getPosition()
    local direction = creature:getDirection()
    local creatureId = creature:getId()

    local function getTargetPosition(offsetX, offsetY)
        local targetX, targetY = creaturePosition.x, creaturePosition.y
        
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

    local function launchMissileAndEffect()
        local creature = Creature(creatureId)
        if not creature then
            return -- Interrompe se a criatura não existir
        end

        local offsetX = math.random(-2, 2)
        local offsetY = math.random(1, 4)
        local targetPosition = getTargetPosition(offsetX, offsetY)

        doSendDistanceShoot(creaturePosition, targetPosition, MISSILE_ID)
        doSendMagicEffect(targetPosition, EFFECT_ID)
    end

    combat1:execute(creature, variant)

    -- Agendamento de eventos para lançamento dos projéteis
    for i = 1, 7 do
        addEvent(function()
            local creature = Creature(creatureId) -- Verifica a criatura dentro do evento
            if creature then
                launchMissileAndEffect()
            end
        end, 100 * (i - 1))
    end

    return true
end

spell:name("Brine")
spell:words("### Brine ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
