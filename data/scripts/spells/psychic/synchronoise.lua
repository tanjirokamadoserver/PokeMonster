local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 34)
combat:setParameter(COMBAT_PARAM_EFFECT, 701)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Synchronoise")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId() -- Armazena o ID da criatura
    local target = creature:getTarget()
    
    if not target then
        return false -- Cancela a execução se não houver um alvo válido
    end

    local targetId = target:getId() -- Armazena o ID do alvo

    local function repeatAttack(count)
        local caster = Creature(creatureId) -- Recupera o objeto da criatura
        local currentTarget = Creature(targetId) -- Recupera o objeto do alvo

        if not caster or not currentTarget then
            return -- Interrompe se o caster ou o alvo não existirem
        end

        local targetPos = currentTarget:getPosition()

        -- Executa o combate
        combat:execute(caster, Variant(targetPos))

        -- Reagenda o ataque, se necessário
        if count > 0 then
            addEvent(repeatAttack, 150, count - 1)
        end
    end

    repeatAttack(3)

    return true
end

spell:name("Synchronoise")
spell:words("#Synchronoise#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()