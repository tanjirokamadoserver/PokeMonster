local AREA_WIND = {
    {1, 1, 1},
    {1, 2, 1},
    {1, 1, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 868)
combat:setArea(createCombatArea(AREA_WIND))
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Tailwind")

local speedCondition = createConditionObject(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 6000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, 400)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    -- Função para executar o combate e adicionar o efeito de velocidade
    local function executeCombat(creatureId)
        local creature = Creature(creatureId)
        if creature then
            local position = creature:getPosition()
            combat:execute(creature, Variant(position))
            creature:addCondition(speedCondition)
        end
    end
    
    -- Agendamento dos eventos para cada intervalo de 1000ms
    for i = 0, 5 do
        addEvent(function()
            -- Verifica se a criatura ainda existe antes de executar
            local creature = Creature(creatureId)
            if creature then
                executeCombat(creatureId)
            end
        end, i * 1000)
    end
    
    return true
end

spell:name("Tailwind")
spell:words("### Tailwind ###")
spell:needLearn(false)
spell:register()

