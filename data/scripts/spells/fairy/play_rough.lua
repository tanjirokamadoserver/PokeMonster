local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 3)
combat:setParameter(COMBAT_PARAM_EFFECT, 1808)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Play Rough")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Play Rough")
spell:words("#Play Rough#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(3)
spell:needTarget(true)
spell:register()
