local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 23)
combat:setParameter(COMBAT_PARAM_EFFECT, 148)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Fury Swipes")

local spell = Spell(SPELL_INSTANT)

local function executeAttack(creatureId, targetPos)
    local creature = Creature(creatureId)
    if creature then
        combat:execute(creature, Variant(targetPos))
    end
end

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    local targetPos = target:getPosition()
    local creatureId = creature:getId()

    -- Agendando os eventos de ataque, criando a referência à criatura no momento da execução
    addEvent(function()
        executeAttack(creatureId, targetPos)
    end, 0)

    addEvent(function()
        executeAttack(creatureId, targetPos)
    end, 150)

    addEvent(function()
        executeAttack(creatureId, targetPos)
    end, 300)

    return true
end

spell:name("Fury Swipes")
spell:words("#Fury Swipes#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
