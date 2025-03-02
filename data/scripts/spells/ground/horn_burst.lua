local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 26)
combat:setParameter(COMBAT_PARAM_EFFECT, 817)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Horn Burst")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    -- Verificar se o alvo da criatura ainda existe
    local target = creature:getTarget()
    if not target then
        return false -- Se não houver um alvo, a spell não pode ser castada
    end

    for i = 0, 2 do
        addEvent(function()
            -- Verifica se a criatura e o alvo ainda existem antes de executar o combate
            if Creature(creature:getId()) and Creature(target:getId()) then
                combat:execute(creature, variant)
            end
        end, i * 200)  -- Atraso de 200ms para cada execução
    end

    return true
end

spell:name("Horn Burst")
spell:words("#Horn Burst#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
