local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 10)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Scale Shot")

local spell = Spell(SPELL_INSTANT)

local function executeCombat(creatureId, targetPos, delay)
    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            combat:execute(creature, Variant(targetPos))
        end
    end, delay)
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local target = creature:getTarget()
    local targetPos = target:getPosition()

    for i = 0, 4 do
        executeCombat(creatureId, targetPos, i * 250)
    end

    return true
end

spell:name("Scale Shot")
spell:words("#Scale Shot#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
