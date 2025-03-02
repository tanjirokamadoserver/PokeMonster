local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Charge Beam")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 919,
    [DIRECTION_EAST] = 920,
    [DIRECTION_SOUTH] = 2548,
    [DIRECTION_WEST] = 2549
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    -- Agendamento de evento para aplicar os efeitos da spell após 1500ms
    addEvent(function(cid)
        local creature = Creature(cid)
        if creature then
            local pos = creature:getPosition()
            local direction = creature:getDirection()
            pos:sendMagicEffect(effects[direction])  -- Aplica o efeito dependendo da direção
            combat:execute(creature, variant)  -- Executa o combate
        end
    end, 1500, creatureId)

    return true
end

spell:name("Charge Beam")
spell:words("#Charge Beam#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()