local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 2)
combat:setParameter(COMBAT_PARAM_EFFECT, 246)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Razor Leaf")

local spell = Spell(SPELL_INSTANT)

local function repeatAttack(creatureId, targetPos, times)
    if times > 0 then
        local creature = Creature(creatureId) -- Recria o objeto da criatura para evitar erros de memória
        if not creature then
            return -- Interrompe se a criatura não existir
        end

        combat:execute(creature, Variant(targetPos))
        addEvent(function()
            repeatAttack(creatureId, targetPos, times - 1)
        end, 200) -- Agendamento seguro da próxima execução
    end
end

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false -- Cancela se não houver alvo
    end

    local targetPos = target:getPosition()
    local creatureId = creature:getId()

    repeatAttack(creatureId, targetPos, 5)

    return true
end

spell:name("Razor Leaf")
spell:words("#Razor Leaf#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()