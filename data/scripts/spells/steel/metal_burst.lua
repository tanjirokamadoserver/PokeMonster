local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 10)
combat:setParameter(COMBAT_PARAM_EFFECT, 2200)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Metal Burst")

local condition = createConditionObject(CONDITION_SILENCE)
condition:setParameter(CONDITION_PARAM_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 30)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()  -- Garantir que o alvo está sendo obtido de maneira segura.
    if not target then return false end  -- Retorna falso se não houver alvo

    local targetPos = target:getPosition()
    local creatureId = creature:getId()  -- Pegamos o ID da criatura para usarmos em eventos futuros

    local function executeCombat(times)
        if times > 0 then
            combat:execute(creature, Variant(targetPos))
            addEvent(executeCombat, 1000, times - 1)  -- Chama o evento novamente após 1 segundo
        end
    end

    -- Inicia a execução do combate 6 vezes
    executeCombat(6)

    return true
end

spell:name("Metal Burst")
spell:words("#Metal Burst#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(7)
spell:needTarget(true)
spell:register()

