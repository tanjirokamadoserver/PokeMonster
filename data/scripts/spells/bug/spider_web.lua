local AREA_BURST = {
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1}
}

local MISSILE_ID = 24
local EFFECT_ID = 27

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat1:setArea(createCombatArea(AREA_BURST))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Spider Web")

local spell = Spell(SPELL_INSTANT)

-- Corrigido para aceitar posição, deslocamentos e direção corretamente
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

-- Corrigido para verificar a existência da criatura antes de executar efeitos
local function launchMissileAndEffect(creatureId, creaturePosition, direction)
    local creature = Creature(creatureId)
    if not creature then
        return -- Sai se a criatura não existir
    end

    local offsetX = math.random(-2, 2)
    local offsetY = math.random(1, 6)
    local targetPosition = getTargetPosition(creaturePosition, offsetX, offsetY, direction)

    doSendDistanceShoot(creaturePosition, targetPosition, MISSILE_ID)
    doSendMagicEffect(targetPosition, EFFECT_ID)
end

function spell.onCastSpell(creature, variant)
    local creaturePosition = creature:getPosition()
    local creatureId = creature:getId()
    local direction = creature:getDirection() -- Armazena a direção inicial

    combat1:execute(creature, variant)

    -- Agenda projéteis e efeitos de forma segura
    for i = 1, 7 do
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe
                launchMissileAndEffect(creatureId, creaturePosition, direction)
            end
        end, 100 * (i - 1))
    end

    return true
end

spell:name("Spider Web")
spell:words("### Spider Web ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()

