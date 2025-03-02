local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 37)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wind Swirl")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, Variant(targetPos))

    return true
end

spell:name("Wind Swirl")
spell:words("#Wind Swirl#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
