local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 109)
combat:setParameter(COMBAT_PARAM_EFFECT, 425)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Shadow Ball")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Shadow Ball")
spell:words("#Shadow Ball#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
