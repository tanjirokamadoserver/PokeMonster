local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 5)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Grass Knot")

local spell = Spell(SPELL_INSTANT)

local function executeAttack(creatureId, targetPos, count)
    if count <= 0 then return end

    local creature = Creature(creatureId)
    if not creature then return end

    local effectPos = { x = targetPos.x + 1, y = targetPos.y + 1, z = targetPos.z }
    doSendMagicEffect(effectPos, 241)
    combat:execute(creature, Variant(targetPos))

    -- Reagendamento com verificação de existência
    addEvent(function()
        if Creature(creatureId) then
            executeAttack(creatureId, targetPos, count - 1)
        end
    end, 100)
end

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then return false end

    executeAttack(creature:getId(), target:getPosition(), 4)
    return true
end

spell:name("Grass Knot")
spell:words("#Grass Knot#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
