local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 33)
combat:setParameter(COMBAT_PARAM_EFFECT, 1377)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Spark")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local target = creature:getTarget()

    -- Verifica se o alvo existe
    if not target then
        return false
    end

    local targetPos = target:getPosition()

    local function executeCombat(times)
        if times > 0 then
            -- Verifica se a criatura e o alvo ainda existem antes de executar o combate
            local creature = Creature(creatureId)
            if creature and target then
                combat:execute(creature, Variant(targetPos))
                addEvent(executeCombat, 150, times - 1)
            end
        end
    end

    -- Inicia a execução do combate com 5 repetições
    executeCombat(5)

    return true
end

spell:name("Spark")
spell:words("#Spark#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(7)
spell:needTarget(true)
spell:register()