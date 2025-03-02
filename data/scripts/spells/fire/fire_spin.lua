local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 566)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Fire Spin")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local creatureId = creature:getId()
    local targetPos = target:getPosition()

    doSendDistanceShoot(creature:getPosition(), targetPos, 4)

    for i = 1, 8 do
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then
                combat:execute(creature, Variant(targetPos))
            end
        end, (i - 1) * 1000)
    end

    return true
end

spell:name("Fire Spin")
spell:words("##Fire Spin##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(7)
spell:needTarget(true)
spell:register()
