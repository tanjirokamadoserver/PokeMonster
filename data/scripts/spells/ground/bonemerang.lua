local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 8)
combat:setParameter(COMBAT_PARAM_EFFECT, 1301)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bonemerang")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Bonemerang")
spell:words("#Bonemerang#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
