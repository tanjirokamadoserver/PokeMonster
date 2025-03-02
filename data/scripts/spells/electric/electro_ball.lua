local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 41)
combat:setParameter(COMBAT_PARAM_EFFECT, 275)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Electro Ball")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Electro Ball")
spell:words("##Electro Ball##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
