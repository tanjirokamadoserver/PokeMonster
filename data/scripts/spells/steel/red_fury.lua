local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Red Fury")
combat:setArea(createCombatArea({
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 760,
    [DIRECTION_EAST] = 760,
    [DIRECTION_SOUTH] = 760,
    [DIRECTION_WEST] = 760
}

local spell = Spell(SPELL_INSTANT)

local function executeCombat(creatureId, variant, direction)
    local creature = Creature(creatureId)
    if not creature then
        return
    end
    
    local effectId = effects[direction]
    local pos = creature:getPosition()

    pos:sendMagicEffect(effectId)

    combat:execute(creature, variant)
end

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local creatureId = creature:getId()
    
    -- Executa imediatamente para a primeira ação
    executeCombat(creatureId, variant, direction)
    
    -- Agendamento de eventos para a execução das ações seguintes, garantindo que a criatura ainda exista
    addEvent(function()
        if Creature(creatureId) then -- Verifica se a criatura ainda existe
            executeCombat(creatureId, variant, direction)
        end
    end, 200)
    
    return true
end

spell:name("Red Fury")
spell:words("#Red Fury#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
