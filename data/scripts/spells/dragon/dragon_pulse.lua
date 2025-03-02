local AREAS = {
    {
        {0, 1, 0, 0, 0, 1, 0},
        {0, 0, 1, 3, 1, 0, 0}
    },
    {
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 1, 3, 1, 0, 0}
    },
    {
        {0, 0, 1, 3, 1, 0, 0}
    }
}

local COMBAT_EFFECTS = {249, 178, 178}

local combats = {}
for i = 1, #AREAS do
    local combat = createCombatObject()
    combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
    combat:setParameter(COMBAT_PARAM_EFFECT, COMBAT_EFFECTS[i])
    combat:setArea(createCombatArea(AREAS[i]))
    combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dragon Pulse")
    table.insert(combats, combat)
end

local spell = Spell(SPELL_INSTANT)
local INTERVAL = 600

-- Função para executar o padrão de ataque
local function executePattern(creatureId, variant, startPos, direction, step)
    local creature = Creature(creatureId)
    if not creature then return end  -- Verifica se a criatura ainda existe

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

    -- Executa os combates baseados na ordem do passo (step)
    if step <= 3 then
        combats[1]:execute(creature, newVariant)
    end
    if step >= 2 then
        combats[2]:execute(creature, newVariant)
    end
    if step == 1 then
        combats[3]:execute(creature, newVariant)
    end

    -- Agendamento do próximo passo, se necessário
    if step < 5 then
        addEvent(function() 
            -- Verifica novamente a existência da criatura antes de executar o próximo evento
            if Creature(creatureId) then
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

spell:name("Dragon Pulse")
spell:words("#Dragon Pulse#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
