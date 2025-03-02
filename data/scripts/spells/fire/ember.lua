local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 4)
combat:setParameter(COMBAT_PARAM_EFFECT, 372)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ember")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Ember")
spell:words("##Ember##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
