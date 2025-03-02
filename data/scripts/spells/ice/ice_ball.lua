local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 29)
combat:setParameter(COMBAT_PARAM_EFFECT, 552)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ice Ball")

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()

    combat:execute(creature, Variant(target:getPosition()))

    local creatureId = creature:getId()

    -- Função para aplicar o efeito de gelo
    local function applyEffect(cid)
        local creature = Creature(cid)
        if creature then
            local target = creature:getTarget()
            if target then
                local effectPos = target:getPosition()
                effectPos:sendMagicEffect(2188)
            end
        end
    end

    -- Agendamento de eventos com verificação de existência da criatura
    for i = 0, 1 do
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then
                applyEffect(creatureId)
            end
        end, i * 2200)
    end

    return true
end

spell:name("Ice Ball")
spell:words("#Ice Ball#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
