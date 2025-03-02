local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 3)
combat:setParameter(COMBAT_PARAM_EFFECT, 644)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Aqua Tail")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Aqua Tail")
spell:words("#Aqua Tail#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(3)
spell:needTarget(true)
spell:register()
