local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 25)
combat:setParameter(COMBAT_PARAM_EFFECT, 1056)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psy Ball")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Psy Ball")
spell:words("#Psy Ball#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
