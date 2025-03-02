local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Yawn")
combat:setParameter(COMBAT_PARAM_EFFECT, 104)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 24)

local condition = Condition(CONDITION_STUN)
condition:setTicks(3000)
condition:setParameter(CONDITION_PARAM_EFFECT, 33)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

-- Função para executar o combate com segurança
local function executeCombat(creatureId, variant, times)
    local creature = Creature(creatureId)
    if creature and times > 0 then
        combat:execute(creature, variant) -- Executa o combate
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe antes de agendar o próximo evento
                executeCombat(creatureId, variant, times - 1)
            end
        end, 150)
    end
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    executeCombat(creature:getId(), variant, 3) -- Inicia a execução do combate em 3 ciclos
    return true
end

targetSpell:name("Yawn")
targetSpell:words("#Yawn")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(2)
targetSpell:register()
