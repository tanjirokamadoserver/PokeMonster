local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 19)
combat:setParameter(COMBAT_PARAM_EFFECT, 197)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Beat Up")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local targetPosition = target:getPosition()
    local creatureId = creature:getId()
    local targetId = target:getId()

    local function repeatAttack(count)
        local caster = Creature(creatureId)
        local currentTarget = Creature(targetId)

        if not caster or not currentTarget or count > 5 then
            return -- Interrompe se a criatura ou o alvo não existirem ou se o limite de ataques for atingido
        end

        local targetPos = currentTarget:getPosition() -- Garante que a posição seja sempre atualizada
        combat:execute(caster, Variant(targetPos))

        -- Agenda o próximo ataque
        addEvent(repeatAttack, 200, count + 1)
    end

    repeatAttack(1)

    return true
end

spell:name("Beat Up")
spell:words("#Beat Up#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
