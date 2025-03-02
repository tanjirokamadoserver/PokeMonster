local AREA_BURST = {
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1}
}

local MISSILE_ID = 26
local EFFECT_ID = 21

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setArea(createCombatArea(AREA_BURST))
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Megahorn")

local function getTargetPosition(position, offsetX, offsetY, direction)
    local targetX, targetY = position.x, position.y

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

    return Position(targetX, targetY, position.z)
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creaturePosition = creature:getPosition()
    local direction = creature:getDirection()
    local creatureId = creature:getId()

    -- Função local para lançar projéteis e efeitos
    local function launchMissileAndEffect(creaturePosition, direction)
        local offsetX = math.random(-2, 2)
        local offsetY = math.random(1, 6)
        local targetPosition = getTargetPosition(creaturePosition, offsetX, offsetY, direction)

        doSendDistanceShoot(creaturePosition, targetPosition, MISSILE_ID)
        doSendMagicEffect(targetPosition, EFFECT_ID)
    end

    -- Executa o combate imediatamente
    combat:execute(creature, variant)

    -- Agenda projéteis e efeitos de forma segura
    for i = 1, 7 do
        addEvent(function()
            local creature = Creature(creatureId)
            if not creature then
                return -- Sai do evento se a criatura não existir
            end

            launchMissileAndEffect(creaturePosition, direction)
        end, 100 * (i - 1))
    end

    return true
end

spell:name("Megahorn")
spell:words("### Megahorn ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
