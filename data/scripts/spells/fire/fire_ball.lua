local MISSILE_TYPE = 4

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 347)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Fire Ball")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creaturePos = creature:getPosition()

    -- A posição final do míssil será exatamente a posição da criatura
    local missileFinalPos = creaturePos

    -- Enviar o míssil diretamente para a posição da criatura
    doSendDistanceShoot(creaturePos, missileFinalPos, MISSILE_TYPE)

    -- Atrasar o ataque para sincronizar com a chegada do míssil
    addEvent(function(cid)
        local creature = Creature(cid)
        if creature and creature:isCreature() then
            combat:execute(creature, variant)
        end
    end, 500, creature:getId())  -- Mudar o delay conforme necessário

    return true
end

spell:name("Fire Ball")
spell:words("#Fire Ball#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
