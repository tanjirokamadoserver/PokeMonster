local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 9)
combat:setParameter(COMBAT_PARAM_EFFECT, 241)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Leaf Blade")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Leaf Blade")
spell:words("#Leaf Blade#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
