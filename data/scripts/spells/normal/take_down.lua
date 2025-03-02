local AREA_DOWN = {
    {1, 1, 1},
    {1, 1, 1},
    {1, 2, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Take Down")
combat:setArea(createCombatArea(AREA_DOWN))

local spell = Spell(SPELL_INSTANT)

local effectInterval = 200
local effectId = 1292
local maxSteps = 4

local function addEffect(position, creatureId)
    local creature = Creature(creatureId)
    if creature then
        position:sendMagicEffect(effectId)
    end
end

local function getNextPosition(pos, direction)
    local nextPos = Position(pos)

    if direction == DIRECTION_NORTH then
        nextPos.y = nextPos.y - 1
    elseif direction == DIRECTION_SOUTH then
        nextPos.y = nextPos.y + 1
    elseif direction == DIRECTION_EAST then
        nextPos.x = nextPos.x + 1
    elseif direction == DIRECTION_WEST then
        nextPos.x = nextPos.x - 1
    end

    return nextPos
end

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)

    local direction = creature:getDirection()
    local startPosition = creature:getPosition()
    local creatureId = creature:getId()

    -- Agendamento de efeitos ao longo do trajeto
    for i = 1, maxSteps do
        addEvent(function()
            local creature = Creature(creatureId)
            if not creature then
                return -- Interrompe se a criatura não existir
            end

            -- Calcula a próxima posição
            local position = getNextPosition(startPosition, direction)
            startPosition = position -- Atualiza a posição para o próximo passo

            -- Envia o efeito na posição calculada
            addEffect(position, creatureId)
        end, effectInterval * (i - 1))
    end

    return true
end

spell:name("Take Down")
spell:words("### Take Down ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()

