local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 35)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mud Sport")
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 7)

local targetSpell = Spell(SPELL_INSTANT)

function onTargetCreature(creature, target)
    -- Função de alvo, mas está vazia no exemplo
end

function executeShot(creatureId, variant, shotIndex)
    local creature = Creature(creatureId)
    if creature and shotIndex <= 5 then
        combat:execute(creature, variant)
        -- Agendando o próximo evento, garantindo que o creatureId ainda é válido
        addEvent(executeShot, 200, creatureId, variant, shotIndex + 1)  
    end
end

function targetSpell.onCastSpell(creature, variant)
    -- Começa a execução dos tiros, passando o ID da criatura
    executeShot(creature:getId(), variant, 1)
    return true
end

targetSpell:name("Mud Sport")
targetSpell:words("#Mud Sport")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(7)
targetSpell:register()
