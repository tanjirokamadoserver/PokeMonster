local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Focus Blast")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 100,
    [DIRECTION_EAST] = 100,
    [DIRECTION_SOUTH] = 100,
    [DIRECTION_WEST] = 100
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()
    local creatureId = creature:getId()

    -- Função para aplicar o efeito
    local function applyEffect(creatureId, i)
        local creature = Creature(creatureId)
        if not creature or creature:isRemoved() then
            return false -- Interrompe se a criatura não existe ou foi removida
        end

        local effectPos
        if direction == DIRECTION_NORTH then
            effectPos = Position(pos.x, pos.y - (2 * i - 1), pos.z)
        elseif direction == DIRECTION_EAST then
            effectPos = Position(pos.x + (2 * i - 1), pos.y, pos.z)
        elseif direction == DIRECTION_SOUTH then
            effectPos = Position(pos.x, pos.y + (2 * i - 1), pos.z)
        elseif direction == DIRECTION_WEST then
            effectPos = Position(pos.x - (2 * i - 1), pos.y, pos.z)
        end

        effectPos:sendMagicEffect(effectId) -- Aplica o efeito na posição calculada
    end

    -- Agendamento dos eventos para aplicar o efeito com intervalos
    for i = 1, 3 do
        addEvent(applyEffect, (i - 1) * 300, creatureId, i) -- Tempo de delay controlado para cada efeito
    end

    -- Executa o combate
    combat:execute(creature, variant)
    return true
end

spell:name("Focus Blast")
spell:words("#Focus Blast#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
