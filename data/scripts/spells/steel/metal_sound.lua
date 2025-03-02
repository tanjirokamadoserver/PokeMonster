local AREA_SOUND = {
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 2, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat1:setArea(createCombatArea(AREA_SOUND))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Metal Sound")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local position = creature:getPosition()

    -- Função para verificar a existência da criatura e executar as ações
    local function executeCombatAndEffect()
        local creature = Creature(creatureId)
        if not creature then return end  -- Verifica se a criatura ainda existe

        -- Enviar o primeiro efeito
        local offsetPosition = Position(position.x + 4, position.y + 4, position.z)
        doSendMagicEffect(offsetPosition, 2477)
        
        -- Executar o combate
        combat1:execute(creature, variant)

        -- Adicionar o segundo efeito (ID 421) em uma posição diferente
        local secondEffectPosition = Position(offsetPosition.x - 2, offsetPosition.y - 2, offsetPosition.z)
        doSendMagicEffect(secondEffectPosition, 2501)
    end

    -- Agendamento dos eventos
    for i = 0, 2 do
        addEvent(function()
            -- Verifica se a criatura ainda existe antes de executar o efeito e combate
            local creature = Creature(creatureId)
            if creature then
                executeCombatAndEffect()
            end
        end, i * 500)  -- Executa a cada 500ms
    end

    return true
end

spell:name("Metal Sound")
spell:words("### Metal Sound ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
