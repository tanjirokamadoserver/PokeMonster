local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 110)
combat:setParameter(COMBAT_PARAM_EFFECT, 249)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Energy Ball")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Energy Ball")
spell:words("#Energy Ball#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
