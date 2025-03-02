local AREA_TOXIC = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 2, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local AREA_TOXIC2 = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 1, 0, 2, 0, 1, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat1:setArea(createCombatArea(AREA_TOXIC))
combat1:setParameter(COMBAT_PARAM_EFFECT, 314)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Toxic")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat2:setArea(createCombatArea(AREA_TOXIC2))
combat2:setParameter(COMBAT_PARAM_EFFECT, 314)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Toxic")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()

    local function executeCombat(combat)
        -- Verifica se a criatura ainda existe antes de tentar executar o combate
        local creature = Creature(creature_id)
        if creature then
            local position = creature:getPosition()
            combat:execute(creature, positionToVariant(position))
        end
    end

    -- Executa o primeiro combate
    executeCombat(combat1)

    -- Agendamento do segundo combate com verificação de existência da criatura
    addEvent(function()
        -- Verifica se a criatura ainda existe antes de executar o segundo combate
        local creature = Creature(creature_id)
        if creature then
            executeCombat(combat2)
        end
    end, 200)

    return true
end

spell:name("Toxic")
spell:words("### Toxic ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
