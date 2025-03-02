local AREA_SPIKES = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 2, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat1:setArea(createCombatArea(AREA_SPIKES))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2212)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Spikes")

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 2286)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()  -- Usando o ID da criatura em vez do objeto diretamente
    local position = creature:getPosition()

    local function executeCombat(times)
        if times > 0 then
            -- Recupera a criatura com o ID
            addEvent(function()
                local creature = Creature(creatureId)
                if creature then
                    combat1:execute(creature, variant)  -- Aplica o combate somente se a criatura existir
                end
            end, 1000 * (10 - times))  -- Agendamento com intervalo de 1 segundo

            -- Continuar agendando o próximo evento
            executeCombat(times - 1)
        end
    end

    executeCombat(10)  -- Inicializa a execução do combate

    return true
end

spell:name("Spikes")
spell:words("### Spikes ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
