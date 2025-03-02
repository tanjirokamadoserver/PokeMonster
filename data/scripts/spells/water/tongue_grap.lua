local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 39)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Tongue Grap")

local condition = Condition(CONDITION_STUN)
condition:setTicks(1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local function castBubbleAttack(creature, targetPos, iteration, creatureId)
    if iteration <= 60 then
        local creature = Creature(creatureId)
        if creature then
            doSendMagicEffect(targetPos, 186)
            combat:execute(creature, Variant(targetPos))
            addEvent(castBubbleAttack, 100, creature, targetPos, iteration + 1, creatureId)
        end
    end
end

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    local targetPos = target:getPosition()
    local creatureId = creature:getId()

    -- Verificação de existência da criatura antes de lançar o feitiço
    if Creature(creatureId) then
        castBubbleAttack(creature, targetPos, 1, creatureId)
    end

    return true
end

spell:name("Tongue Grap")
spell:words("#Tongue Grap#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(3)
spell:needTarget(true)
spell:register()