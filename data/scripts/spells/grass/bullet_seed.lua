local AREA_BURST = {
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1}
}

local MISSILE_ID = 2
local EFFECT_ID = 46

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat1:setArea(createCombatArea(AREA_BURST))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bullet Seed")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creaturePosition = creature:getPosition()
    local direction = creature:getDirection()
    local creatureId = creature:getId()

    -- Função para calcular a posição do alvo com base na direção
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

    -- Função que lança o projétil e aplica o efeito mágico
    local function launchMissileAndEffect(creatureId)
        -- Verifica se a criatura ainda existe
        local creature = Creature(creatureId)
        if not creature then
            return -- Interrompe se a criatura não existir
        end

        local offsetX = math.random(-2, 2)
        local offsetY = math.random(1, 6)
        local targetPosition = getTargetPosition(offsetX, offsetY)

        -- Envia o projétil e o efeito mágico
        doSendDistanceShoot(creaturePosition, targetPosition, MISSILE_ID)
        doSendMagicEffect(targetPosition, EFFECT_ID)
    end

    -- Executa o combate
    combat1:execute(creature, variant)

    -- Agendamento de eventos para lançar os projéteis
    for i = 1, 7 do
        addEvent(function()
            -- Verifica se a criatura ainda existe antes de lançar o projétil
            if Creature(creatureId) then
                launchMissileAndEffect(creatureId)
            end
        end, 100 * (i - 1))
    end

    return true
end

spell:name("Bullet Seed")
spell:words("### Bullet Seed ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
