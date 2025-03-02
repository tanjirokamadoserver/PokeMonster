local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 2)
combat:setParameter(COMBAT_PARAM_EFFECT, 441)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Leech Seed")

local spell = Spell(SPELL_INSTANT)

local function repeatAttack(creatureId, targetPos, times)
    if times > 0 then
        local creature = Creature(creatureId)
        if creature then
            combat:execute(creature, Variant(targetPos))
            addEvent(repeatAttack, 200, creatureId, targetPos, times - 1)
        end
    end
end

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    local targetPos = target:getPosition()
    local creatureId = creature:getId()

    repeatAttack(creatureId, targetPos, 10)

    return true
end

spell:name("Leech Seed")
spell:words("#Leech Seed#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
