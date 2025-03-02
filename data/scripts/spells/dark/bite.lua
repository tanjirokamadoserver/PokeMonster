local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 147)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bite")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    local targetPos = target:getPosition()
    local creatureId = creature:getId()

     combat:execute(Creature(creatureId), Variant(targetPos))

    return true
end

spell:name("Bite")
spell:words("#Bite#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
