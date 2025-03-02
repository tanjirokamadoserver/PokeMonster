local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 25)
combat:setParameter(COMBAT_PARAM_EFFECT, 325)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psy Pulse")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId() -- Captura o ID da criatura para referência futura

    -- Função auxiliar para executar o combate
    local function executeCombat(creatureId, times)
        local creature = Creature(creatureId) -- Obtém o objeto da criatura com base no ID
        if not creature then
            return -- Interrompe se a criatura não existir mais
        end

        combat:execute(creature, variant) -- Executa o combate

        times = times - 1 -- Decrementa o contador de repetições
        if times > 0 then
            addEvent(executeCombat, 150, creatureId, times) -- Agenda a próxima execução
        end
    end

    local repeatTimes = math.random(3) -- Define um número aleatório de repetições (entre 1 e 3)
    executeCombat(creatureId, repeatTimes) -- Inicia o combate repetitivo

    return true
end

spell:name("Psy Pulse")
spell:words("#Psy Pulse#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()

