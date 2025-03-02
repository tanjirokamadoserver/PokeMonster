local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 16)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Lightning Horn")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local target = creature:getTarget()

    if not target then
        return false -- Não executa a spell caso o alvo seja nulo
    end

    local targetPosition = target:getPosition()

    for i = 0, 2 do
        addEvent(function()
            local caster = Creature(creatureId)
            local target = Creature(target:getId()) -- Recria a referência do alvo para garantir que ainda exista

            if caster and target then
                combat:execute(caster, variant)
                doSendMagicEffect(targetPosition, 807)
            end
        end, i * 200)
    end

    return true
end

spell:name("Lightning Horn")
spell:words("#Lightning Horn#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()